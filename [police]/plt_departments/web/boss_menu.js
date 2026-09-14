// 2025 iMac Boss Menu - Modern Experience

// Global scope initialization
window.currentDeptData = null;

// Function: Close Boss Menu Quickly
window.closeBossMenu = function() {
    const modernContainer = document.getElementById('boss-menu-container');
    const vintageContainer = document.getElementById('vintage-boss-menu-container');
    
    if (modernContainer) {
        modernContainer.classList.remove('visible');
        modernContainer.style.display = 'none';
    }
    if (vintageContainer) {
        vintageContainer.classList.add('hidden');
        vintageContainer.style.display = 'none';
    }

    fetch(`https://${GetParentResourceName()}/closeBossMenu`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
};
window.currentJobName = null;
window.currentPlayerName = "OFFICER";
window.currentPlayerRank = "SERGEANT";
window.financeHistory = {};
window.syncedWarrants = [];
window.syncedCaseFiles = [];
window.syncedBolos = [];
window.syncedDeptNews = [];
window.syncedDutyLogs = {};
window.syncedDepartmentMail = {};
window.syncedFormSubmissions = {};
window.formsActiveStatus = 'Pending';
window.activeFormId = null;
window.syncedDepartmentCatalog = [];
window.mailComposerOpen = false;
window.mailActiveFolder = 'inbox';
/** Which tab is visible in the department (roster) app — avoids syncData wiping Recruitment. */
window.pltBossDeptAppTab = 'roster';
window.pltWindowPositionsByDept = window.pltWindowPositionsByDept || {};
window.pltDefaultWindowPositions = window.pltDefaultWindowPositions || {};

window.pltGetWindowDeptKey = function() {
    const dept = window.currentJobName;
    if (dept === null || dept === undefined || dept === '') return '__global__';
    return String(dept);
};

window.pltRememberWindowPosition = function(windowId, element) {
    if (!windowId || !element) return;
    const deptKey = window.pltGetWindowDeptKey();
    if (!window.pltWindowPositionsByDept[deptKey]) {
        window.pltWindowPositionsByDept[deptKey] = {};
    }
    window.pltWindowPositionsByDept[deptKey][windowId] = {
        left: element.style.left || '',
        top: element.style.top || ''
    };
};

window.pltApplyWindowPosition = function(windowId, element) {
    if (!windowId || !element) return;
    const deptKey = window.pltGetWindowDeptKey();
    const deptPositions = window.pltWindowPositionsByDept[deptKey] || {};
    const saved = deptPositions[windowId];
    const defaults = window.pltDefaultWindowPositions[windowId];

    if (saved) {
        if (typeof saved.left === 'string') element.style.left = saved.left;
        if (typeof saved.top === 'string') element.style.top = saved.top;
        return;
    }

    if (defaults) {
        if (typeof defaults.left === 'string') element.style.left = defaults.left;
        if (typeof defaults.top === 'string') element.style.top = defaults.top;
    }
};

/**
 * NUI POST wrapper — fetch() rejects when the game drops focus, stops the resource, or unloads the page.
 * Never let that bubble as an uncaught (in promise) error.
 */
window.pltBossNuiFetch = function(endpoint, payload) {
    const url = 'https://' + GetParentResourceName() + '/' + endpoint;
    return fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload !== undefined ? payload : {})
    }).catch(function(err) {
        if (typeof console !== 'undefined' && console.warn) {
            console.warn('[plt_departments] NUI fetch failed (' + endpoint + '):', err && err.message ? err.message : err);
        }
        return null;
    });
};

window.pltBossNuiGetPlayers = function() {
    return window.pltBossNuiFetch('getPlayers', {}).then(function(res) {
        if (!res || !res.ok) return [];
        return res.json().then(function(j) {
            return Array.isArray(j) ? j : [];
        }).catch(function() {
            return [];
        });
    });
};

window.pltEscapeHtml = function(value) {
    if (value === null || value === undefined) return '';
    return String(value)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');
};

window.pltNormalizeNodeId = function(value) {
    if (value === null || value === undefined) return null;
    return String(value);
};

window.pltGetNodeById = function(nodeId) {
    if (!window.currentDeptData || !Array.isArray(window.currentDeptData.nodes)) return null;
    const searchId = window.pltNormalizeNodeId(nodeId);
    if (!searchId) return null;
    return window.currentDeptData.nodes.find(function(node) {
        return window.pltNormalizeNodeId(node.id) === searchId;
    }) || null;
};

window.pltResolveDepartmentForNode = function(nodeId) {
    if (!window.currentDeptData || !Array.isArray(window.currentDeptData.links)) return null;

    const startId = window.pltNormalizeNodeId(nodeId);
    if (!startId) return null;

    const startNode = window.pltGetNodeById(startId);
    if (startNode && startNode.type === 'department') return window.pltNormalizeNodeId(startNode.id);

    const queue = [startId];
    const visited = {};
    visited[startId] = true;

    while (queue.length > 0) {
        const current = queue.shift();

        for (const link of window.currentDeptData.links) {
            let target = null;
            if (window.pltNormalizeNodeId(link.from) === current) {
                target = window.pltNormalizeNodeId(link.to);
            } else if (window.pltNormalizeNodeId(link.to) === current) {
                target = window.pltNormalizeNodeId(link.from);
            }

            if (!target || visited[target]) continue;

            const targetNode = window.pltGetNodeById(target);
            if (!targetNode) continue;

            if (targetNode.type === 'department') {
                return window.pltNormalizeNodeId(targetNode.id);
            }

            visited[target] = true;
            queue.push(target);
        }
    }

    return null;
};

// Roster generation: drop stale getPlayers results and never use a "locked" queue (spam / tab switches
// could skip the queued run or leave the UI stuck until another full refresh).
(function() {
    let deptRosterGen = 0;

    /** Call when switching to Recruitment so in-flight roster fetches cannot paint over this tab. */
    window.pltBossInvalidateDeptRoster = function() {
        deptRosterGen++;
    };

    window.renderDepartmentMembers = function(showLoader = true, targetId = null) {
        if (!targetId) {
            targetId = (window.currentBossTheme === 'vintage') ? 'vintage-app-container-dept' : 'mac-app-container-dept';
        }
        const content = document.getElementById(targetId);
        if (!content) return;

        const myGen = ++deptRosterGen;

        if (showLoader) setTranslatedHTML(content, `<div class="mac-loader"></div>`);
        
        let deptLabel = "Department";
        if (window.currentDeptData && window.currentDeptData.nodes) {
            const jid = String(window.currentJobName ?? '');
            const node = window.currentDeptData.nodes.find(n => String(n.id) === jid);
            if (node) deptLabel = node.label;
        }

        const deptKey = String(window.currentJobName ?? '');

        window.pltBossNuiGetPlayers().then(function(players) {
            if (myGen !== deptRosterGen) return;
            if (!Array.isArray(players)) players = [];
            const deptMembers = players.filter(p => {
                if (p.cid && p.cid.startsWith('FAKE_')) return true;
                return String(p.jobName ?? '') === deptKey;
            });
            const list = deptMembers.map(p => {
            // Ensure medals and divisions are arrays
            const medals = Array.isArray(p.medals) ? p.medals : (typeof p.medals === 'object' ? Object.values(p.medals) : []);
            const memberDivs = Array.isArray(p.divisions) ? p.divisions : (typeof p.divisions === 'object' ? Object.values(p.divisions) : []);
            
            const medalIcons = medals.slice(0, 5).map(m => {
                if (!m || !m.id) return '';
                return `
                    <div class="member-medal-mini" title="${m.name || window.T('honored')}">
                        <img src="img/${m.id}.webp" onerror="this.src='img/members.png';">
                    </div>
                `;
            }).join('');

            const divLabels = (window.currentDeptData.divisions && window.currentDeptData.divisions[deptKey]) 
                ? window.currentDeptData.divisions[deptKey]
                    .filter(d => memberDivs.includes(d.id))
                    .map(d => `<span class="member-div-badge">${d.name}</span>`)
                    .join('')
                : '';

            return `
            <div class="mac-member-card ${!p.isOnline ? 'is-offline' : ''}">
                <div class="mac-member-info-left">
                    <div class="member-avatar-ios">
                        ${p.name.charAt(0)}
                        <div class="online-indicator ${p.isOnline ? 'online' : 'offline'}"></div>
                    </div>
                    <div class="member-details-ios">
                        <div class="member-name-ios">
                            ${p.name} 
                            <span class="ios-id-tag">${p.isOnline ? '#' + p.id : window.T('offline')}</span>
                        </div>
                        <div class="member-rank-ios">${p.jobGradeLabel}</div>
                        <div class="member-medals-row">
                            ${medalIcons || '<span class="no-medals">' + window.T('no_honors') + '</span>'}
                        </div>
                        <div class="member-divisions-row">${divLabels}</div>
                    </div>
                </div>
                <div class="mac-member-actions-slim">
                    <button class="ios-slim-btn" onclick="window.manageMember('${p.cid}', 'promote')">
                        <i class="fas fa-chevron-up"></i>
                        <span>${window.T('promote')}</span>
                    </button>
                    <button class="ios-slim-btn" onclick="window.manageMember('${p.cid}', 'demote')">
                        <i class="fas fa-chevron-down"></i>
                        <span>${window.T('demote')}</span>
                    </button>
                    <button class="ios-slim-btn honor" onclick="window.showHonorModal('${p.cid}', '${p.name.replace(/'/g, "\\'")}')">
                        <i class="fas fa-medal"></i>
                        <span>${window.T('honor')}</span>
                    </button>
                    <button class="ios-slim-btn division" onclick="window.showDivisionModal('${p.cid}', '${p.name.replace(/'/g, "\\'")}')">
                        <i class="fas fa-layer-group"></i>
                        <span>${window.T('divisions')}</span>
                    </button>
                    <button class="ios-slim-btn danger" onclick="window.manageMember('${p.cid}', 'fire')">
                        <i class="fas fa-user-slash"></i>
                        <span>${window.T('fire')}</span>
                    </button>
                </div>
            </div>
        `}).join('');

            window.pltBossDeptAppTab = 'roster';
            setTranslatedHTML(content, `
            <div class="mac-app-container-glass">
                <div class="mac-app-header">
                <div class="mac-app-header-top">
                    <div class="mac-app-icon-large" style="background: none; box-shadow: none;">
                        <img src="img/departments${document.body.classList.contains('theme-vintage') ? '90' : ''}.png" style="width: 100%; height: 100%; object-fit: contain;">
                    </div>
                    <div class="mac-app-titles">
                            <h2>${deptLabel}</h2>
                            <p>${deptMembers.length} ${window.T('active_personnel')}</p>
                        </div>
                    </div>
                    <div class="mac-app-tabs">
                        <div class="mac-tab active" onclick="window.renderDepartmentMembers(false)">${window.T('roster')}</div>
                        <div class="mac-tab" onclick="window.renderHiringTab()">${window.T('recruitment')}</div>
                    </div>
                </div>
                <div class="mac-scroll-area">${list || '<div class="mac-empty-state">' + window.T('no_personnel') + '</div>'}</div>
            </div>
        `);
        });
    };
})();

// Function: Open App (Modern macOS Style)
window.openMacApp = function(type) {
    let windowId = 'members';
    let appName = window.T('app_records');
    if (type === 'dept_manager') { windowId = 'dept'; appName = window.T('app_departments'); }
    else if (type === 'finances') { windowId = 'finances'; appName = window.T('app_finances'); }
    else if (type === 'safari') { windowId = 'safari'; appName = window.T('app_safari'); }
    else if (type === 'calculator') { windowId = 'calculator'; appName = window.T('app_calculator'); }
    else if (type === 'mail') { windowId = 'mail'; appName = 'Mail'; }
    else if (type === 'clock') { windowId = 'clock'; appName = window.T('app_clock'); }
    else if (type === 'settings') { windowId = 'settings'; appName = window.T('app_settings'); }
    else if (type === 'cameras') { windowId = 'cameras'; appName = window.T('app_cameras'); }
    else if (type === 'member_db') { windowId = 'members'; appName = window.T('app_records'); }
    
    const win = document.getElementById(`mac-window-${windowId}`);
    
    if (!win) return;

    window.pltApplyWindowPosition(windowId, win);
    
    // Add active dot to dock item
    let dockId = 'dock-members';
    if (type === 'dept_manager') dockId = 'dock-dept';
    else if (type === 'finances') dockId = 'dock-finances';
    else if (type === 'safari') dockId = 'dock-safari';
    else if (type === 'calculator') dockId = 'dock-calculator';
    else if (type === 'mail') dockId = 'dock-mail';
    else if (type === 'clock') dockId = 'dock-clock';
    else if (type === 'settings') dockId = 'dock-settings';
    else if (type === 'cameras') dockId = 'dock-cameras';
    else if (type === 'member_db') dockId = 'dock-members';
    
    const dockItem = document.getElementById(dockId);
    if (dockItem) {
        dockItem.classList.add('app-open');
        dockItem.classList.add('bouncing');
        setTimeout(() => {
            dockItem.classList.remove('bouncing');
        }, 800); // Match animation duration
    }
    
    // Update active app name in top bar
    const activeAppName = document.getElementById('active-app-name');
    if (activeAppName) activeAppName.innerText = appName;
    
    setTimeout(() => {
        win.classList.remove('hidden');
        win.style.display = 'flex';
        win.style.zIndex = ++window.highestZIndex;
        
        if (type === 'dept_manager') {
            window.renderDepartmentMembers(true);
        } else if (type === 'finances') {
            window.renderFinancesApp('main');
        } else if (type === 'member_db') {
            window.renderMembersApp('main');
        } else if (type === 'safari') {
            window.renderSafariApp('intranet');
        } else if (type === 'mail') {
            window.renderMailApp();
        } else if (type === 'clock') {
            window.renderClockApp();
        } else if (type === 'settings') {
            window.renderSettingsApp();
        } else if (type === 'cameras') {
            window.renderCamerasApp();
        } else if (type === 'calculator') {
            if (window.renderCalculatorApp) window.renderCalculatorApp();
        }
    }, 500);
};

// Function: Render Safari Browser Content
window.renderSafariApp = function(page, subPage = 'dashboard', targetId = null) {
    if (!targetId) {
        targetId = (window.currentBossTheme === 'vintage') ? 'vintage-app-container-safari' : 'mac-app-container-safari';
    }
    const content = document.getElementById(targetId);
    
    // Elements that only exist in modern iMac
    const tabContainer = (targetId === 'mac-app-container-safari') ? document.getElementById('safari-tabs') : null;
    const urlText = (targetId === 'mac-app-container-safari') ? document.getElementById('safari-url-text') : null;
    
    // Elements that only exist in vintage Macintosh
    const vintageTabContainer = document.querySelector('.vintage-netscape-tabs');
    const vintageUrlText = document.querySelector('#vintage-window-safari .safari-url');
    
    if (!content) return;

    // Update URL bar
    if (urlText) {
        urlText.innerText = `dept.pear.os/${page}${subPage !== 'dashboard' ? '/' + subPage : ''}`;
    }
    if (vintageUrlText && targetId === 'vintage-app-container-safari') {
        vintageUrlText.innerText = `dept.pear.os/${page}${subPage !== 'dashboard' ? '/' + subPage : ''}`;
    }

    // Render Tabs
    const tabs = [
        { id: 'intranet', label: window.T('tab_intranet'), icon: 'globe' },
        { id: 'trackers', label: window.T('tab_trackers'), icon: 'map-location-dot' },
        { id: 'comms', label: window.T('tab_comms'), icon: 'comments' },
        { id: 'fines', label: window.T('tab_fines'), icon: 'file-invoice-dollar' },
        { id: 'forms', label: window.T('tab_forms'), icon: 'file-signature' },
        { id: 'gunlicenses', label: 'Gun Licenses', icon: 'id-card' },
        { id: 'shifts', label: window.T('tab_radars'), icon: 'tower-observation' },
        { id: 'logs', label: window.T('tab_logs'), icon: 'list-check' }
    ];

    if (tabContainer) {
        setTranslatedHTML(tabContainer, tabs.map(t => `
            <div class="safari-tab ${page === t.id ? 'active' : ''}" onclick="window.renderSafariApp('${t.id}')">
                <i class="fas fa-${t.icon}"></i>
                <span>${t.label}</span>
                <i class="fas fa-times tab-close"></i>
            </div>
        `).join(''));
    }

    if (vintageTabContainer && targetId === 'vintage-app-container-safari') {
        setTranslatedHTML(vintageTabContainer, tabs.map(t => `
            <div class="vintage-netscape-tab ${page === t.id ? 'active' : ''}" onclick="window.renderSafariApp('${t.id}')">
                ${t.label}
            </div>
        `).join(''));
    }

    let innerHTML = '';

    if (page === 'intranet') {
        const warrants = window.syncedWarrants || [];
        const activeWarrants = warrants.slice().reverse(); 
        const bolos = window.syncedBolos || [];
        const activeBolos = bolos.slice().reverse();
        const cases = window.syncedCaseFiles || [];
        const activeCases = cases.slice().reverse();
        
        let subContent = '';
        if (subPage === 'dashboard') {
            const recentWarrants = activeWarrants.slice(0, 5).map(w => `
                <div class="intra-table-row">
                    <div class="row-cell bold">${w.subject}</div>
                    <div class="row-cell">${w.charges.substring(0, 30)}${w.charges.length > 30 ? '...' : ''}</div>
                    <div class="row-cell"><span class="badge ${w.priority === 'High' ? 'danger' : 'warning'}">${w.priority.toUpperCase()}</span></div>
                    <div class="row-cell text-right"><i class="fas fa-chevron-right"></i></div>
                </div>
            `).join('') || '<div class="intra-empty">No active warrants</div>';

            const recentBolos = activeBolos.slice(0, 3).map(b => `
                <div class="intra-bolo-card ${b.type === 'Vehicle' ? 'priority' : ''}">
                    <div class="bolo-header">
                        <span class="bolo-type">${b.type.toUpperCase()}</span>
                        <span class="bolo-date">JAN 06</span>
                    </div>
                    <div class="bolo-title">${b.title}</div>
                    <div class="bolo-footer">${b.plate ? 'PLATE: ' + b.plate : 'PERSON OF INTEREST'}</div>
                </div>
            `).join('') || '<div class="intra-empty">No active BOLOs</div>';

            subContent = `
                <div class="portal-content">
                    <div class="content-row">
                        <div class="content-block hero-bulletin">
                            <div class="block-header">DEPARTMENT ANNOUNCEMENT</div>
                            <div class="bulletin-body">
                                <h2>MANDATORY BWC POLICY UPDATE</h2>
                                <p>Effective immediately, all field units are required to synchronize body-worn cameras with the central server prior to end-of-watch. Failure to comply may result in disciplinary action. Reference SOP-2026-04 for details.</p>
                                <button class="bulletin-btn">READ FULL DIRECTIVE</button>
                            </div>
                        </div>
                    </div>

                    <div class="content-grid-2">
                        <div class="content-block">
                            <div class="block-header">
                                <span>ACTIVE BOLOs</span>
                                <span class="header-link" onclick="window.renderSafariApp('intranet', 'bolos')">VIEW ALL</span>
                            </div>
                            <div class="block-body bolo-grid">
                                ${recentBolos}
                            </div>
                        </div>
                        <div class="content-block">
                            <div class="block-header">
                                <span>RECENT WARRANTS</span>
                                <span class="header-link" onclick="window.renderSafariApp('intranet', 'warrants')">MANAGE</span>
                            </div>
                            <div class="block-body">
                                <div class="intra-table">
                                    ${recentWarrants}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `;
        } else if (subPage === 'warrants') {
            const warrantList = activeWarrants.map(w => `
                <div class="warrant-modern-card ${w.priority === 'High' ? 'is-high-priority' : ''} ${w.status === 'Completed' ? 'is-completed' : ''}">
                    <div class="card-header">
                        <span class="case-number">CASE #${w.id.toString().slice(-6)}</span>
                        <div class="header-tags">
                            ${w.status === 'Completed' ? `
                                <div class="status-tag completed">
                                    <i class="fas fa-check-circle"></i>
                                    <span>COMPLETED</span>
                                </div>
                            ` : ''}
                            <div class="priority-indicator">
                                <i class="fas fa-circle"></i>
                                <span>${w.priority.toUpperCase()}</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card-body">
                        <h3 class="subject-name">${w.subject}</h3>
                        <div class="charges-preview">${w.charges}</div>
                    </div>

                    <div class="card-footer">
                        <div class="officer-info">
                            <i class="fas fa-user-shield"></i>
                            <span>${w.issuedBy}</span>
                        </div>
                        <div class="card-actions">
                            <button class="action-icon-btn info" onclick="window.viewWarrant(${w.id})" title="VIEW DETAILS">
                                <i class="fas fa-expand"></i>
                            </button>
                            ${!window.mdtEnabled ? `
                            <button class="action-icon-btn warning" onclick="window.editWarrant(${w.id})" title="EDIT RECORD">
                                <i class="fas fa-pen-to-square"></i>
                            </button>
                            <button class="action-icon-btn danger" onclick="window.deleteWarrant(${w.id})" title="ARCHIVE RECORD">
                                <i class="fas fa-box-archive"></i>
                            </button>
                            ` : ''}
                        </div>
                    </div>
                </div>
            `).join('');

            subContent = `
                <div class="warrants-view-container portal-style-inner">
                    <div class="warrants-header">
                        <div class="header-titles-warrant">
                            <h2 style="color: #002349;">Judicial Database</h2>
                            <p style="color: #666;">Active warrants and criminal records</p>
                        </div>
                        ${!window.mdtEnabled ? `
                        <button class="intranet-btn-new" id="btn-toggle-warrant-form" onclick="window.toggleWarrantForm()" style="background: #002349;">
                            <i class="fas fa-plus"></i> NEW WARRANT
                        </button>
                        ` : ''}
                    </div>
                    
                    <div id="inline-warrant-form" class="inline-form-card" style="display: none;">
                        <div class="form-header">
                            <span>CREATE NEW JUDICIAL WARRANT</span>
                        </div>
                        <div class="form-grid">
                            <div class="intranet-input-group">
                                <label>Subject Name</label>
                                <input type="text" id="warrant-subject" placeholder="e.g. James Miller">
                            </div>
                            <div class="intranet-input-group">
                                <label>Priority Level</label>
                                <select id="warrant-priority">
                                    <option value="Standard">Standard (Misdemeanor)</option>
                                    <option value="High">High (Felony)</option>
                                </select>
                            </div>
                        </div>
                        <div class="intranet-input-group">
                            <label>Charges & Justification</label>
                            <textarea id="warrant-charges" placeholder="Enter penal codes and evidence details..." style="height: 80px;"></textarea>
                        </div>
                        <div class="form-footer">
                            <button class="intranet-btn-sm" onclick="window.toggleWarrantForm()">Cancel</button>
                            <button class="intranet-btn-sm primary" onclick="window.submitWarrantInline()">Submit to Database</button>
                        </div>
                    </div>

                    <div class="warrants-scroll-wrapper">
                        <div class="warrants-grid-container">
                            ${warrantList || '<div class="mac-empty-state">No records found.</div>'}
                        </div>
                    </div>
                </div>
            `;
        } else if (subPage === 'cases') {
            const caseList = activeCases.map(c => `
                <div class="case-modern-card ${c.status === 'Closed' ? 'status-closed' : ''}">
                    <div class="card-header">
                        <span class="case-number">FILE #${c.id.toString().slice(-6)}</span>
                        <div class="header-tags">
                            <div class="status-tag ${c.status.toLowerCase()}">
                                <i class="fas ${c.status === 'Closed' ? 'fa-lock' : 'fa-folder-open'}"></i>
                                <span>${c.status.toUpperCase()}</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card-body">
                        <h3 class="subject-name">${c.title}</h3>
                        <div class="charges-preview">${c.summary}</div>
                    </div>

                    <div class="card-footer">
                        <div class="officer-info">
                            <i class="fas fa-user-shield"></i>
                            <span>${c.issuedBy}</span>
                        </div>
                        <div class="card-actions">
                            <button class="action-icon-btn info" onclick="window.viewCaseFile(${c.id})" title="VIEW FULL REPORT">
                                <i class="fas fa-file-lines"></i>
                            </button>
                            <button class="action-icon-btn warning" onclick="window.editCaseFile(${c.id})" title="EDIT FILE">
                                <i class="fas fa-pen-to-square"></i>
                            </button>
                            <button class="action-icon-btn danger" onclick="window.deleteCaseFile(${c.id})" title="ARCHIVE FILE">
                                <i class="fas fa-box-archive"></i>
                            </button>
                        </div>
                    </div>
                </div>
            `).join('');

            subContent = `
                <div class="warrants-view-container portal-style-inner">
                    <div class="warrants-header">
                        <div class="header-titles-warrant">
                            <h2 style="color: #002349;">Intelligence Files</h2>
                            <p style="color: #666;">Active investigations and historical records</p>
                        </div>
                        <button class="intranet-btn-new" id="btn-toggle-case-form" onclick="window.toggleCaseForm()" style="background: #002349;">
                            <i class="fas fa-plus"></i> NEW CASE FILE
                        </button>
                    </div>
                    
                    <div id="inline-case-form" class="inline-form-card" style="display: none;">
                        <div class="form-header">
                            <span>CREATE NEW INVESTIGATION FILE</span>
                        </div>
                        <div class="form-grid">
                            <div class="intranet-input-group">
                                <label>Case Title</label>
                                <input type="text" id="case-title" placeholder="e.g. Vangelico Heist Investigation">
                            </div>
                            <div class="intranet-input-group">
                                <label>Current Status</label>
                                <select id="case-status">
                                    <option value="Open">Active Investigation</option>
                                    <option value="Pending">Pending Review</option>
                                    <option value="Closed">Closed / Archived</option>
                                </select>
                            </div>
                        </div>
                        <div class="intranet-input-group">
                            <label>Executive Summary</label>
                            <textarea id="case-summary" placeholder="Brief overview of the investigation..." style="height: 60px;"></textarea>
                        </div>
                        <div class="intranet-input-group">
                            <label>Full Case Details & Evidence</label>
                            <textarea id="case-details" placeholder="Detailed chronological logs, evidence lists, and suspects..." style="height: 120px;"></textarea>
                        </div>
                        <div class="form-footer">
                            <button class="intranet-btn-sm" onclick="window.toggleCaseForm()">Cancel</button>
                            <button class="intranet-btn-sm primary" onclick="window.submitCaseInline()">Save Case File</button>
                        </div>
                    </div>

                    <div class="warrants-scroll-wrapper">
                        <div class="warrants-grid-container">
                            ${caseList || '<div class="mac-empty-state">No intelligence files found.</div>'}
                        </div>
                    </div>
                </div>
            `;
        } else if (subPage === 'bolos') {
            const boloList = activeBolos.map(b => `
                <div class="case-modern-card ${b.type === 'Vehicle' ? 'bolo-vehicle' : 'bolo-person'}">
                    <div class="card-header">
                        <span class="case-number">BOLO #${b.id.toString().slice(-6)}</span>
                        <div class="header-tags">
                            <div class="status-tag ${b.type.toLowerCase()}">
                                <i class="fas ${b.type === 'Vehicle' ? 'fa-car' : 'fa-user'}"></i>
                                <span>${b.type.toUpperCase()}</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card-body">
                        <h3 class="subject-name">${b.title}</h3>
                        <div class="charges-preview">${b.description}</div>
                        ${b.plate ? `<div class="bolo-plate-tag">PLATE: ${b.plate}</div>` : ''}
                    </div>

                    <div class="card-footer">
                        <div class="officer-info">
                            <i class="fas fa-user-shield"></i>
                            <span>${b.issuedBy}</span>
                        </div>
                        <div class="card-actions">
                            <button class="action-icon-btn info" onclick="window.viewBolo(${b.id})" title="VIEW BOLO">
                                <i class="fas fa-expand"></i>
                            </button>
                            ${!window.mdtEnabled ? `
                            <button class="action-icon-btn warning" onclick="window.editBolo(${b.id})" title="EDIT BOLO">
                                <i class="fas fa-pen-to-square"></i>
                            </button>
                            <button class="action-icon-btn danger" onclick="window.deleteBolo(${b.id})" title="ARCHIVE BOLO">
                                <i class="fas fa-box-archive"></i>
                            </button>
                            ` : ''}
                        </div>
                    </div>
                </div>
            `).join('');

            subContent = `
                <div class="warrants-view-container portal-style-inner">
                    <div class="warrants-header">
                        <div class="header-titles-warrant">
                            <h2 style="color: #002349;">BOLO Database</h2>
                            <p style="color: #666;">Active Be-On-The-Look-Out alerts</p>
                        </div>
                        ${!window.mdtEnabled ? `
                        <button class="intranet-btn-new" id="btn-toggle-bolo-form" onclick="window.toggleBoloForm()" style="background: #002349;">
                            <i class="fas fa-plus"></i> NEW BOLO
                        </button>
                        ` : ''}
                    </div>
                    
                    <div id="inline-bolo-form" class="inline-form-card" style="display: none;">
                        <div class="form-header">
                            <span>CREATE NEW BOLO ALERT</span>
                        </div>
                        <div class="form-grid">
                            <div class="intranet-input-group">
                                <label>BOLO Title / Subject</label>
                                <input type="text" id="bolo-title" placeholder="e.g. Red Sultan Classic">
                            </div>
                            <div class="intranet-input-group">
                                <label>BOLO Type</label>
                                <select id="bolo-type">
                                    <option value="Vehicle">Vehicle BOLO</option>
                                    <option value="Person">Person BOLO</option>
                                    <option value="Other">Other Alert</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-grid">
                            <div class="intranet-input-group">
                                <label>License Plate (Optional)</label>
                                <input type="text" id="bolo-plate" placeholder="e.g. 45ABC123">
                            </div>
                            <div class="intranet-input-group">
                                <label>Last Seen Location</label>
                                <input type="text" id="bolo-lastseen" placeholder="e.g. Legion Square East">
                            </div>
                        </div>
                        <div class="intranet-input-group">
                            <label>Details & Reason</label>
                            <textarea id="bolo-description" placeholder="Description of the subject and reason for the BOLO..." style="height: 80px;"></textarea>
                        </div>
                        <div class="form-footer">
                            <button class="intranet-btn-sm" onclick="window.toggleBoloForm()">Cancel</button>
                            <button class="intranet-btn-sm primary" onclick="window.submitBoloInline()">Post Alert</button>
                        </div>
                    </div>

                    <div class="warrants-scroll-wrapper">
                        <div class="warrants-grid-container">
                            ${boloList || '<div class="mac-empty-state">No active BOLOs found.</div>'}
                        </div>
                    </div>
                </div>
            `;
        } else if (subPage === 'deptnews') {
            const newsList = (window.syncedDeptNews || []).slice().reverse().map(n => `
                <div class="news-article">
                    <div class="article-meta">${n.date.toUpperCase()} • ${n.author.toUpperCase()}</div>
                    <h2>${n.title.toUpperCase()}</h2>
                    <p>${n.content}</p>
                    <div class="article-actions">
                        <button class="action-icon-btn danger" onclick="window.deleteNews(${n.id})" title="DELETE ARTICLE">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                </div>
            `).join('') || `
                <div class="news-article">
                    <div class="article-meta">JANUARY 29, 2026 • COMMAND STAFF</div>
                    <h2>NEW VEHICLE FLEET ARRIVAL</h2>
                    <p>The department is pleased to announce the arrival of 15 new interceptor units. These vehicles are equipped with the latest ALPR technology and enhanced safety features. Vehicle orientation sessions will be held this weekend at the central garage.</p>
                </div>
            `;

            subContent = `
                <div class="portal-content">
                    <div class="warrants-header" style="background: white; padding: 20px; border-radius: 8px; margin-bottom: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); border: 1px solid #e1e4e8; display: flex; justify-content: space-between; align-items: center;">
                        <div class="header-titles-warrant">
                            <h2 style="color: #002349; margin: 0;">Department News</h2>
                            <p style="color: #666; margin: 5px 0 0 0;">Official bulletins and announcements</p>
                        </div>
                        <button class="intranet-btn-new" id="btn-toggle-news-form" onclick="window.toggleNewsForm()" style="background: #002349;">
                            <i class="fas fa-plus"></i> NEW ARTICLE
                        </button>
                    </div>

                    <div id="inline-news-form" class="inline-form-card" style="display: none; margin-bottom: 20px;">
                        <div class="form-header">
                            <span>CREATE NEW DEPARTMENT ANNOUNCEMENT</span>
                        </div>
                        <div class="intranet-input-group">
                            <label>Article Title</label>
                            <input type="text" id="news-title" placeholder="e.g. New Mandatory Uniform Policy">
                        </div>
                        <div class="intranet-input-group">
                            <label>Content</label>
                            <textarea id="news-content" placeholder="Enter the full announcement details here..." style="height: 120px;"></textarea>
                        </div>
                        <div class="form-footer">
                            <button class="intranet-btn-sm" onclick="window.toggleNewsForm()">Cancel</button>
                            <button class="intranet-btn-sm primary" onclick="window.submitNewsInline()">Post to Portal</button>
                        </div>
                    </div>

                    <div class="content-block">
                        <div class="block-header">LATEST BULLETINS</div>
                        <div class="block-body news-full-list">
                            ${newsList}
                        </div>
                    </div>
                </div>
            `;
        }

        innerHTML = `
            <div class="intranet-portal">
                <div class="portal-header">
                    <div class="portal-logo">
                        <i class="fas fa-shield-halved"></i>
                        <div class="logo-text">
                            <span class="dept-name">LOS SANTOS POLICE DEPARTMENT</span>
                            <span class="dept-tag">INTERNAL SERVICES PORTAL</span>
                        </div>
                    </div>
                    <div class="portal-user">
                        <div class="user-info">
                            <span class="user-name">${window.currentPlayerName.toUpperCase()}</span>
                            <span class="user-rank">${window.currentPlayerRank.toUpperCase()}</span>
                        </div>
                        <i class="fas fa-user-circle"></i>
                    </div>
                </div>

                <div class="portal-nav">
                    <div class="nav-item ${subPage === 'dashboard' ? 'active' : ''}" onclick="window.renderSafariApp('intranet', 'dashboard')">DASHBOARD</div>
                    <div class="nav-item ${subPage === 'warrants' ? 'active' : ''}" onclick="window.renderSafariApp('intranet', 'warrants')">WARRANTS</div>
                    <div class="nav-item ${subPage === 'cases' ? 'active' : ''}" onclick="window.renderSafariApp('intranet', 'cases')">INCIDENTS</div>
                    <div class="nav-item ${subPage === 'bolos' ? 'active' : ''}" onclick="window.renderSafariApp('intranet', 'bolos')">BOLOs</div>
                    <div class="nav-item ${subPage === 'deptnews' ? 'active' : ''}" onclick="window.renderSafariApp('intranet', 'deptnews')">DEPT NEWS</div>
                </div>

                <div class="portal-main-grid">
                    <div class="portal-sidebar">
                        <div class="side-section">
                            <div class="side-title">QUICK ACCESS</div>
                            <div class="side-link" onclick="window.renderSafariApp('intranet', 'bolos')"><i class="fas fa-bullhorn"></i> Active BOLOs</div>
                            <div class="side-link" onclick="window.renderSafariApp('intranet', 'warrants')"><i class="fas fa-gavel"></i> Judicial Database</div>
                            <div class="side-link" onclick="window.renderSafariApp('intranet', 'cases')"><i class="fas fa-folder-open"></i> Intelligence Files</div>
                            <div class="side-link" onclick="window.renderSafariApp('intranet', 'deptnews')"><i class="fas fa-newspaper"></i> Dept News</div>
                        </div>
                        <div class="side-section">
                            <div class="side-title">DEPARTMENT NEWS</div>
                            ${(window.syncedDeptNews || []).slice(-2).reverse().map(n => `
                                <div class="news-item clickable" onclick="window.renderSafariApp('intranet', 'deptnews')">
                                    <div class="news-date">${n.date.toUpperCase()}</div>
                                    <div class="news-head">${n.title}</div>
                                </div>
                            `).join('') || `
                                <div class="news-item clickable" onclick="window.renderSafariApp('intranet', 'deptnews')">
                                    <div class="news-date">JAN 29, 2026</div>
                                    <div class="news-head">New Vehicle Fleet Arrival</div>
                                </div>
                                <div class="news-item clickable" onclick="window.renderSafariApp('intranet', 'deptnews')">
                                    <div class="news-date">JAN 25, 2026</div>
                                    <div class="news-head">Annual Shooting Certs</div>
                                </div>
                            `}
                        </div>
                    </div>

                    ${subContent}
                </div>
            </div>
        `;
    } else if (page === 'trackers') {
        const trackerList = (window.currentTrackers || []).map(t => `
            <div class="tracker-card ${t.isOnline ? 'is-active' : ''}">
                <div class="tracker-icon">
                    <i class="fas fa-satellite-dish"></i>
                </div>
                <div class="tracker-info">
                    <div class="tracker-plate">${t.plate}</div>
                    <div class="tracker-model">${t.model}</div>
                    <div class="tracker-meta">
                        <span><i class="fas fa-user"></i> ${t.placedBy}</span>
                        <span><i class="fas fa-clock"></i> ${t.time}</span>
                    </div>
                </div>
                <div class="tracker-status">
                    <span class="status-dot ${t.isOnline ? 'online' : 'offline'}"></span>
                    ${t.isOnline ? 'ACTIVE SIGNAL' : 'SIGNAL LOST'}
                </div>
                <div class="tracker-actions">
                    <button class="tracker-btn locate" onclick="window.locateTracker('${t.plate}')" ${!t.isOnline ? 'disabled' : ''}>
                        <i class="fas fa-location-crosshairs"></i> LOCATE
                    </button>
                    <button class="tracker-btn remove" onclick="window.removeTrackerUI('${t.plate}')">
                        <i class="fas fa-trash-can"></i> REMOVE
                    </button>
                </div>
            </div>
        `).join('');

        innerHTML = `
            <div class="tracker-app-container">
                <div class="tracker-app-header">
                    <div class="header-text">
                        <h1>GPS Tracking Fleet</h1>
                        <p>Real-time vehicle monitoring and surveillance system.</p>
                    </div>
                    <button class="refresh-trackers-btn" onclick="window.refreshTrackers()">
                        <i class="fas fa-arrows-rotate"></i> REFRESH
                    </button>
                </div>
                <div class="tracker-grid">
                    ${trackerList || '<div class="mac-empty-state">No GPS trackers currently active.</div>'}
                </div>
            </div>
        `;
        if (!window.currentTrackers) {
            window.refreshTrackers();
        }
    } else if (page === 'comms') {
        const currentDept = window.currentJobName;
        
        fetch(`https://${GetParentResourceName()}/getAllDepts`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({})
        }).then(res => res.json()).then(depts => {
            const otherDepts = depts.filter(d => d.id !== currentDept);
            const deptList = otherDepts.map(d => `
                <div class="comms-dept-item ${window.selectedChatDept === d.id ? 'active' : ''}" onclick="window.selectChatDept('${d.id}')">
                    <div class="dept-avatar"><i class="fas fa-building-shield"></i></div>
                    <div class="dept-info">
                        <div class="dept-name">${d.label}</div>
                        <div class="dept-status">Secure Channel</div>
                    </div>
                </div>
            `).join('');

            innerHTML = `
                <div class="comms-app-container">
                    <div class="comms-sidebar">
                        <div class="comms-sidebar-header">
                            <h2>Departments</h2>
                            <p>Select a secure channel</p>
                        </div>
                        <div class="comms-dept-list">
                            ${deptList || '<div class="mac-empty-state">No other departments found.</div>'}
                        </div>
                    </div>
                    <div class="comms-chat-area" id="comms-chat-area">
                        ${window.selectedChatDept ? `
                            <div class="chat-header">
                                <div class="header-info">
                                    <h3>${depts.find(d => d.id === window.selectedChatDept)?.label || 'Department'}</h3>
                                    <span>Encrypted Communication Channel</span>
                                </div>
                                <div class="header-actions">
                                    <i class="fas fa-phone"></i>
                                    <i class="fas fa-video"></i>
                                    <i class="fas fa-info-circle"></i>
                                </div>
                            </div>
                            <div class="chat-messages" id="chat-messages">
                                <!-- Messages will be loaded here -->
                            </div>
                            <div class="chat-input-area">
                                <div class="input-wrapper">
                                    <input type="text" id="comms-message-input" placeholder="Type a secure message..." onkeydown="if(event.key === 'Enter') window.sendDeptMessage()">
                                    <div class="input-actions">
                                        <i class="fas fa-paperclip"></i>
                                        <button onclick="window.sendDeptMessage()"><i class="fas fa-paper-plane"></i></button>
                                    </div>
                                </div>
                            </div>
                        ` : `
                            <div class="chat-empty-state">
                                <i class="fas fa-comments"></i>
                                <h3>Select a department</h3>
                                <p>Select a department from the sidebar to start a secure communication channel.</p>
                            </div>
                        `}
                    </div>
                </div>
            `;
            // Fixed the "container is not defined" error by using "content" (which is defined in Safari render function)
            setTranslatedHTML(content, innerHTML);
            
            if (window.selectedChatDept) {
                window.loadDeptMessages();
            }
        });
        return; // Async handling
    } else if (page === 'fines') {
        const transactions = (window.syncedTransactions && window.syncedTransactions[window.currentJobName]) || [];
        const activeTransactions = transactions.slice().reverse(); // Newest first

        const getTransIcon = (type) => {
            switch(type) {
                case 'fine_paid': return { icon: 'fa-check-circle', color: '#34c759' };
                case 'fine_forced': return { icon: 'fa-clock-rotate-left', color: '#ff9500' };
                case 'deposit': return { icon: 'fa-plus-circle', color: '#007aff' };
                case 'withdraw': return { icon: 'fa-minus-circle', color: '#ff3b30' };
                default: return { icon: 'fa-circle-info', color: '#8e8e93' };
            }
        };

        const getTransLabel = (type) => {
            switch(type) {
                case 'fine_paid': return 'Fine Signed';
                case 'fine_forced': return 'Forced Payment';
                case 'deposit': return 'Deposit';
                case 'withdraw': return 'Withdrawal';
                default: return 'Transaction';
            }
        };

        const transactionList = activeTransactions.map(t => {
            const style = getTransIcon(t.type);
            const label = getTransLabel(t.type);
            return `
                <div class="ios-trans-card">
                    <div class="ios-trans-icon" style="background: ${style.color}15; color: ${style.color};">
                        <i class="fas ${style.icon}"></i>
                    </div>
                    <div class="ios-trans-info">
                        <div class="ios-trans-main">
                            <span class="ios-trans-label">${label}</span>
                            <span class="ios-trans-amount ${t.type.includes('withdraw') ? 'neg' : 'pos'}">
                                ${t.type.includes('withdraw') ? '-' : '+'}$${t.amount.toLocaleString()}
                            </span>
                        </div>
                        <div class="ios-trans-details">
                            <span class="ios-trans-officer"><i class="fas fa-user-shield"></i> ${t.officer.name}</span>
                            <span class="ios-trans-target"><i class="fas fa-user"></i> ${t.target.name}</span>
                        </div>
                        <div class="ios-trans-meta">
                            <span class="ios-trans-reason">${t.reason}</span>
                            <span class="ios-trans-date">${t.date}</span>
                        </div>
                    </div>
                </div>
            `;
        }).join('');

        innerHTML = `
            <div class="ios-safari-container">
                <div class="ios-safari-header">
                    <div class="ios-header-main">
                        <h1>Financial History</h1>
                        <div class="ios-balance-chip">
                            <label>TOTAL NET BALANCE</label>
                            <span>$${(window.syncedBalances[window.currentJobName] || 0).toLocaleString()}</span>
                        </div>
                    </div>
                </div>
                <div class="ios-trans-scroll-area">
                    <div class="ios-section-label">RECENT TRANSACTIONS</div>
                    <div class="ios-trans-list">
                        ${transactionList || '<div class="mac-empty-state">No transactions recorded.</div>'}
                    </div>
                </div>
            </div>
        `;
    } else if (page === 'shifts') {
        const radars = window.syncedRadars || {};
        const speedUnit = window.pltSpeedUnit || 'KM/H';
        const radarList = Object.values(radars).map(r => `
            <tr>
                <td>
                    <div class="radar-edit-field">
                        <input type="text" value="${r.name || 'Mobile Radar'}" onchange="window.updateRadarField('${r.id}', 'name', this.value)" style="width: 150px; background: rgba(0,0,0,0.05); border: 1px solid rgba(0,0,0,0.1); color: #000; border-radius: 4px; padding: 4px 8px; font-weight: bold;">
                        <span style="font-size: 9px; color: #8b949e; text-transform: uppercase; display: block; margin-top: 2px;">ID: ${r.id.slice(-6)}</span>
                    </div>
                </td>
                <td>
                    <div class="radar-edit-field">
                        <input type="number" value="${r.limit}" onchange="window.updateRadarField('${r.id}', 'limit', this.value)" style="width: 60px; background: rgba(0,0,0,0.05); border: 1px solid rgba(0,0,0,0.1); color: #007aff; border-radius: 4px; padding: 4px 8px; font-weight: bold;">
                        <span style="font-size: 10px; color: #8b949e; margin-left: 5px;">${speedUnit}</span>
                    </div>
                </td>
                <td>
                    <div class="radar-edit-field">
                        <span style="color: #34c759; font-weight: bold; margin-right: 4px;">$</span>
                        <input type="number" value="${r.fineAmount || 15}" onchange="window.updateRadarField('${r.id}', 'fineAmount', this.value)" style="width: 60px; background: rgba(0,0,0,0.05); border: 1px solid rgba(0,0,0,0.1); color: #34c759; border-radius: 4px; padding: 4px 8px; font-weight: bold;">
                        <span style="font-size: 10px; color: #8b949e; margin-left: 5px;">/UNIT</span>
                    </div>
                </td>
                <td><span style="color: #333; font-size: 13px; font-weight: 500;">${r.ownerName || 'Unknown'}</span></td>
                <td style="text-align: right;">
                    <button class="action-icon-btn danger" onclick="window.removeRadar('${r.id}')" title="REMOVE RADAR">
                        <i class="fas fa-trash"></i>
                    </button>
                </td>
            </tr>
        `).join('');

        innerHTML = `
            <div class="safari-page-container">
                <div class="safari-standard-header">
                    <h1>City Radar Network</h1>
                    <p>Manage active speed enforcement cameras and adjust fine rates.</p>
                </div>
                <div class="safari-section-card" style="padding: 0;">
                    <table class="safari-table">
                        <thead>
                            <tr>
                                <th>Radar Name</th>
                                <th>Speed Limit</th>
                                <th>Fine Rate</th>
                                <th>Placed By</th>
                                <th style="text-align: right;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            ${radarList || '<tr><td colspan="5" style="text-align:center; padding: 40px; color: #8b949e;">No active radars found in the network.</td></tr>'}
                        </tbody>
                    </table>
                </div>
                <div class="info-box">
                    <i class="fas fa-info-circle"></i>
                    Adjusting the **Fine Rate** sets how many dollars are charged per ${speedUnit} over the limit. Default is $15.
                </div>
            </div>
        `;
    } else if (page === 'forms' || page === 'gunlicenses') {
        window.formsActivePage = page;
        const isGunLicensePage = page === 'gunlicenses';
        const allDeptForms = ((window.syncedFormSubmissions && window.syncedFormSubmissions[window.currentJobName]) || []).slice().reverse()
            .map(form => ({ ...form, status: form.status || 'Pending', applicationType: form.applicationType || 'police_service' }));
        const allForms = allDeptForms.filter(form => {
            const appType = String(form.applicationType || '').toLowerCase();
            const formType = String(form.formType || '').toLowerCase();
            const isGun = appType === 'gun_license' || formType.includes('gun license') || formType.includes('firearm');
            return isGunLicensePage ? isGun : !isGun;
        });
        const status = window.formsActiveStatus || 'Pending';
        const counts = {
            All: allForms.length,
            Pending: allForms.filter(f => f.status === 'Pending').length,
            Accepted: allForms.filter(f => f.status === 'Accepted').length,
            Refused: allForms.filter(f => f.status === 'Refused').length
        };
        const visibleForms = status === 'All' ? allForms : allForms.filter(form => form.status === status);
        const selectedForm = visibleForms.find(form => String(form.id) === String(window.activeFormId)) || visibleForms[0] || null;
        window.activeFormId = selectedForm ? selectedForm.id : null;

        const filters = ['Pending', 'Accepted', 'Refused', 'All'].map(filter => `
            <button class="forms-filter ${status === filter ? 'active' : ''}" onclick="window.switchFormsStatus('${filter}')">
                <span>${filter}</span>
                <strong>${counts[filter]}</strong>
            </button>
        `).join('');

        const list = visibleForms.map(form => {
            const isActive = selectedForm && String(selectedForm.id) === String(form.id);
            const priorityClass = String(form.priority || '').toLowerCase() === 'urgent' || isGunLicensePage ? 'error' : 'success';
            return `
                <button class="forms-list-item ${isActive ? 'active' : ''}" onclick="window.selectDepartmentForm('${window.pltEscapeHtml(form.id)}')">
                    <div class="forms-list-top">
                        <strong>${window.pltEscapeHtml(form.fullName || form.applicant || 'Unknown')}</strong>
                        <span class="forms-status ${String(form.status || 'Pending').toLowerCase()}">${window.pltEscapeHtml(form.status || 'Pending')}</span>
                    </div>
                    <div class="forms-list-summary">${window.pltEscapeHtml(form.summary || 'Untitled request')}</div>
                    <div class="forms-list-meta">
                        <span>${window.pltEscapeHtml(isGunLicensePage ? (form.licenseClass || form.formType || 'Gun License Application') : (form.formType || 'Service Request'))}</span>
                        <span class="ios-status-tag ${priorityClass}">${window.pltEscapeHtml(form.priority || 'Routine').toUpperCase()}</span>
                    </div>
                </button>
            `;
        }).join('');

        const gunLicenseDetail = selectedForm && isGunLicensePage ? `
            <div class="forms-detail-grid forms-license-grid">
                <div><label>Date of Birth</label><strong>${window.pltEscapeHtml(selectedForm.dateOfBirth || 'N/A')}</strong></div>
                <div><label>Address</label><strong>${window.pltEscapeHtml(selectedForm.address || 'N/A')}</strong></div>
                <div><label>Occupation</label><strong>${window.pltEscapeHtml(selectedForm.occupation || 'N/A')}</strong></div>
                <div><label>Requested License</label><strong>${window.pltEscapeHtml(selectedForm.licenseClass || 'N/A')}</strong></div>
                <div><label>Training Provider</label><strong>${window.pltEscapeHtml(selectedForm.trainingProvider || 'N/A')}</strong></div>
                <div><label>Training Date</label><strong>${window.pltEscapeHtml(selectedForm.trainingDate || 'N/A')}</strong></div>
                <div><label>Prior Denial</label><strong>${window.pltEscapeHtml(selectedForm.priorDenial || 'N/A')}</strong></div>
                <div><label>Criminal History</label><strong>${window.pltEscapeHtml(selectedForm.criminalHistory || 'N/A')}</strong></div>
                <div><label>Mental Health Restriction</label><strong>${window.pltEscapeHtml(selectedForm.mentalHealth || 'N/A')}</strong></div>
                <div><label>Domestic Violence Restriction</label><strong>${window.pltEscapeHtml(selectedForm.domesticViolence || 'N/A')}</strong></div>
            </div>
            <div class="forms-detail-body">
                <label>Safe Storage Plan</label>
                <p>${window.pltEscapeHtml(selectedForm.storagePlan || 'No storage plan provided.').replace(/\n/g, '<br>')}</p>
            </div>
        ` : '';

        const detail = selectedForm ? `
            <div class="forms-detail-header">
                <div>
                    <div class="forms-detail-kicker">${window.pltEscapeHtml(isGunLicensePage ? 'Firearm Licensing Bureau' : (selectedForm.formType || 'Service Request'))}</div>
                    <h2>${window.pltEscapeHtml(isGunLicensePage ? (selectedForm.licenseClass || selectedForm.summary || 'Gun License Application') : (selectedForm.summary || 'Untitled request'))}</h2>
                    <div class="forms-detail-ref">Reference ${window.pltEscapeHtml(selectedForm.id || 'N/A')}</div>
                </div>
                <span class="forms-status large ${String(selectedForm.status || 'Pending').toLowerCase()}">${window.pltEscapeHtml(selectedForm.status || 'Pending')}</span>
            </div>
            <div class="forms-detail-grid">
                <div><label>Applicant</label><strong>${window.pltEscapeHtml(selectedForm.fullName || selectedForm.applicant || 'Unknown')}</strong></div>
                <div><label>Phone</label><strong>${window.pltEscapeHtml(selectedForm.phone || 'N/A')}</strong></div>
                <div><label>Email</label><strong>${window.pltEscapeHtml(selectedForm.email || 'N/A')}</strong></div>
                <div><label>Submitted</label><strong>${window.pltEscapeHtml((selectedForm.date || '') + (selectedForm.time ? ' ' + selectedForm.time : ''))}</strong></div>
                <div><label>Priority</label><strong>${window.pltEscapeHtml(selectedForm.priority || 'Routine')}</strong></div>
                <div><label>Submitted By</label><strong>${window.pltEscapeHtml(selectedForm.submittedBy || 'N/A')}</strong></div>
            </div>
            ${gunLicenseDetail}
            <div class="forms-detail-body">
                <label>${isGunLicensePage ? 'Reason for Application' : 'Full Statement'}</label>
                <p>${window.pltEscapeHtml(selectedForm.details || 'No details provided.').replace(/\n/g, '<br>')}</p>
            </div>
            ${(selectedForm.reviewedBy || selectedForm.reviewNote) ? `
                <div class="forms-review-note">
                    <label>Review</label>
                    <p>${window.pltEscapeHtml(selectedForm.reviewedBy || 'Command Staff')} ${selectedForm.reviewedDate ? 'on ' + window.pltEscapeHtml(selectedForm.reviewedDate + ' ' + (selectedForm.reviewedTime || '')) : ''}</p>
                    ${selectedForm.reviewNote ? `<span>${window.pltEscapeHtml(selectedForm.reviewNote)}</span>` : ''}
                </div>
            ` : ''}
            <div class="forms-actions">
                <button class="forms-action accept" onclick="window.manageDepartmentForm('accept', '${window.pltEscapeHtml(selectedForm.id)}')"><i class="fas fa-check"></i> Accept</button>
                <button class="forms-action refuse" onclick="window.manageDepartmentForm('refuse', '${window.pltEscapeHtml(selectedForm.id)}')"><i class="fas fa-xmark"></i> Refuse</button>
                <button class="forms-action delete" onclick="window.manageDepartmentForm('delete', '${window.pltEscapeHtml(selectedForm.id)}')"><i class="fas fa-trash"></i> Delete</button>
            </div>
        ` : `
            <div class="forms-empty-detail">
                <i class="fas ${isGunLicensePage ? 'fa-id-card' : 'fa-file-circle-question'}"></i>
                <h2>No ${isGunLicensePage ? 'gun license applications' : 'applications'} in this folder</h2>
                <p>Submitted ${isGunLicensePage ? 'firearm license applications' : 'forms'} will appear here once they match the selected status.</p>
            </div>
        `;

        innerHTML = `
            <div class="safari-page-container">
                <div class="safari-standard-header">
                    <h1>${isGunLicensePage ? 'Gun License Applications' : 'Application Review'}</h1>
                    <p>${isGunLicensePage ? 'Review, approve, refuse, or delete firearm licensing requests submitted through the LSPD intranet.' : 'Organize, review, accept, refuse, or delete submitted station intranet forms.'}</p>
                </div>
                <div class="forms-workspace">
                    <aside class="forms-sidebar">${filters}</aside>
                    <section class="forms-list">${list || `<div class="forms-empty-list">No ${isGunLicensePage ? 'gun license applications' : 'applications'} in this folder.</div>`}</section>
                    <section class="forms-detail">${detail}</section>
                </div>
            </div>
        `;
    } else if (page === 'logs') {
        const logs = (window.syncedDutyLogs && window.syncedDutyLogs[window.currentJobName]) || [];
        const activeLogs = logs.slice().reverse(); // Newest first

        const logList = activeLogs.map(l => `
            <tr>
                <td>${l.officer}</td>
                <td><span class="ios-status-tag ${l.action === 'Clocked On' ? 'success' : 'error'}">${l.action.toUpperCase()}</span></td>
                <td>${l.date} ${l.time}</td>
            </tr>
        `).join('');

        innerHTML = `
            <div class="safari-page-container">
                <div class="safari-standard-header">
                    <h1>Duty Logs</h1>
                    <p>Real-time record of officer activity.</p>
                </div>
                <table class="safari-table">
                    <thead>
                        <tr><th>Officer</th><th>Action</th><th>Timestamp</th></tr>
                    </thead>
                    <tbody>
                        ${logList || '<tr><td colspan="3" style="text-align:center; padding: 20px;">No logs recorded yet.</td></tr>'}
                    </tbody>
                </table>
            </div>
        `;
    }

    setTranslatedHTML(content, `
        <div class="safari-browser-view">
            <div class="safari-content-area">
                ${innerHTML}
            </div>
        </div>
    `);
};

window.switchFormsStatus = function(status) {
    window.formsActiveStatus = status || 'Pending';
    window.activeFormId = null;
    window.renderSafariApp(window.formsActivePage || 'forms');
};

window.selectDepartmentForm = function(id) {
    window.activeFormId = id;
    window.renderSafariApp(window.formsActivePage || 'forms');
};

window.manageDepartmentForm = function(action, id) {
    if (!id || !window.currentJobName) return;

    fetch(`https://${GetParentResourceName()}/manageDepartmentForm`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            deptId: window.currentJobName,
            id,
            action,
            note: ''
        })
    });
};

// Global Clock Update (for Dock Icon and Clock App)
window.updateSystemClock = function() {
    const now = new Date();
    const seconds = now.getSeconds();
    const minutes = now.getMinutes();
    const hours = now.getHours();

    const secDeg = (seconds / 60) * 360;
    const minDeg = ((minutes + seconds / 60) / 60) * 360;
    const hourDeg = (((hours % 12) + minutes / 60) / 12) * 360;

    // Analog Hands (App)
    const hHand = document.getElementById('clock-hour');
    const mHand = document.getElementById('clock-minute');
    const sHand = document.getElementById('clock-second');

    if (hHand) hHand.style.transform = `translateX(-50%) rotate(${hourDeg}deg)`;
    if (mHand) mHand.style.transform = `translateX(-50%) rotate(${minDeg}deg)`;
    if (sHand) sHand.style.transform = `translateX(-50%) rotate(${secDeg}deg)`;

    // Digital Time (App)
    const digitalTime = document.getElementById('digital-time');
    if (digitalTime) {
        digitalTime.innerText = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' });
    }

    // Digital Date (App)
    const digitalDate = document.getElementById('digital-date');
    if (digitalDate) {
        digitalDate.innerText = now.toLocaleDateString([], { weekday: 'long', month: 'long', day: 'numeric', year: 'numeric' });
    }

    // Update Dock Icon Clock
    const dockH = document.querySelector('#dock-clock .clock-hand-dock.hour');
    const dockM = document.querySelector('#dock-clock .clock-hand-dock.minute');
    const dockS = document.querySelector('#dock-clock .clock-hand-dock.second');

    if (dockH) dockH.style.transform = `translateX(-50%) rotate(${hourDeg}deg)`;
    if (dockM) dockM.style.transform = `translateX(-50%) rotate(${minDeg}deg)`;
    if (dockS) dockS.style.transform = `translateX(-50%) rotate(${secDeg}deg)`;

    requestAnimationFrame(window.updateSystemClock);
};

// Start clock immediately
window.updateSystemClock();

// Function: Render Clock App
window.renderClockApp = function() {
    const content = document.getElementById('mac-app-container-clock');
    if (!content) return;

    setTranslatedHTML(content, `
        <div class="clock-app-container">
            <div class="analog-clock">
                <div class="clock-center"></div>
                <div class="clock-hand hour" id="clock-hour"></div>
                <div class="clock-hand minute" id="clock-minute"></div>
                <div class="clock-hand second" id="clock-second"></div>
            </div>
            <div class="digital-time" id="digital-time">...</div>
            <div class="digital-date" id="digital-date">...</div>
        </div>
    `);
};

window.renderMailApp = function(selectedMailId = null) {
    const content = document.getElementById('mac-app-container-mail');
    if (!content) return;

    const catalogDepartments = Array.isArray(window.syncedDepartmentCatalog) ? window.syncedDepartmentCatalog : [];
    const allDepartments = (catalogDepartments.length > 0)
        ? catalogDepartments.map((dept) => ({
            id: dept.id,
            label: dept.label || dept.name || dept.id,
            frameworkJob: dept.frameworkJob || dept.job || dept.id,
            isAmbulanceScript: !!dept.isAmbulanceScript
        }))
        : ((window.currentDeptData && Array.isArray(window.currentDeptData.nodes))
            ? window.currentDeptData.nodes.filter((node) => node.type === 'department').map((node) => ({
                id: node.id,
                label: node.label || node.id,
                frameworkJob: node.id
            }))
            : []);
    const recipientDepartments = allDepartments.filter((node) => String(node.id) !== String(window.currentJobName));
    const deptLabelMap = {};
    allDepartments.forEach((dept) => {
        deptLabelMap[String(dept.id)] = dept.label || dept.id;
    });
    const getDeptLabel = function(deptId) {
        return deptLabelMap[String(deptId)] || deptId || 'Unknown';
    };

    const inboxMails = ((window.syncedDepartmentMail && window.syncedDepartmentMail[window.currentJobName]) || [])
        .slice()
        .sort((a, b) => (Number(b.timestamp) || 0) - (Number(a.timestamp) || 0));

    const sentMails = Object.values(window.syncedDepartmentMail || {})
        .flat()
        .filter((mail) => String(mail.fromDept || '') === String(window.currentJobName || ''))
        .sort((a, b) => (Number(b.timestamp) || 0) - (Number(a.timestamp) || 0));

    const folder = (window.mailActiveFolder === 'sent') ? 'sent' : 'inbox';
    const folderMails = folder === 'sent' ? sentMails : inboxMails;

    const safeSelectedId = selectedMailId !== null ? Number(selectedMailId) : Number(window.activeMailId);
    const activeMail = folderMails.find((mail) => Number(mail.id) === safeSelectedId) || folderMails[0] || null;
    window.activeMailId = activeMail ? Number(activeMail.id) : null;

    const mailRows = folderMails.map((mail) => {
        const isActive = activeMail && Number(activeMail.id) === Number(mail.id);
        const primaryLine = (folder === 'inbox')
            ? window.pltEscapeHtml(mail.senderName || 'Dispatch')
            : ('To: ' + window.pltEscapeHtml(getDeptLabel(mail.toDept)));
        const subject = window.pltEscapeHtml(mail.subject || 'No Subject');
        const preview = window.pltEscapeHtml((mail.message || '').slice(0, 70));
        const stamp = window.pltEscapeHtml(mail.date || mail.time || '');
        return `
            <button class="mail-row ${isActive ? 'active' : ''}" onclick="window.renderMailApp(${Number(mail.id)})">
                <div class="mail-row-header">
                    <span class="mail-row-sender">${primaryLine}</span>
                    <span class="mail-row-date">${stamp}</span>
                </div>
                <div class="mail-row-subject">${subject}</div>
                <div class="mail-row-preview">${preview}${(mail.message || '').length > 70 ? '...' : ''}</div>
            </button>
        `;
    }).join('');

    const detailHtml = activeMail ? `
        <div class="mail-detail-card">
            <div class="mail-detail-header">
                <h2>${window.pltEscapeHtml(activeMail.subject || 'No Subject')}</h2>
                <div class="mail-detail-meta">${window.pltEscapeHtml(activeMail.date || '')}${activeMail.time ? ' at ' + window.pltEscapeHtml(activeMail.time) : ''}</div>
            </div>
            <div class="mail-detail-from">
                <span class="mail-detail-pill">${window.pltEscapeHtml(String(folder === 'inbox' ? activeMail.fromDept : activeMail.toDept || 'unknown').toUpperCase())}</span>
                <span class="mail-detail-sender">${folder === 'inbox'
                    ? window.pltEscapeHtml(activeMail.senderName || 'Dispatch Center')
                    : ('To ' + window.pltEscapeHtml(getDeptLabel(activeMail.toDept)))}
                </span>
            </div>
            ${activeMail.imageUrl ? `<img class="mail-detail-image" src="${window.pltEscapeHtml(activeMail.imageUrl)}" alt="Mail attachment" referrerpolicy="no-referrer">` : ''}
            <div class="mail-detail-body">${window.pltEscapeHtml(activeMail.message || '').replace(/\n/g, '<br>')}</div>
        </div>
    ` : `
        <div class="mail-empty-detail">
            <i class="fas fa-envelope-open-text"></i>
            <h3>No ${folder === 'inbox' ? 'Inbox' : 'Sent'} Messages</h3>
            <p>${folder === 'inbox' ? 'Incoming department messages will appear here.' : 'Sent department messages will appear here.'}</p>
        </div>
    `;

    const composerHtml = window.mailComposerOpen ? `
        <div class="mail-compose-view">
            <div class="mail-detail-header">
                <h2>New Message</h2>
                <div class="mail-detail-meta">Compose department mail</div>
            </div>
            <div class="mail-compose-body">
                <label>To Department</label>
                <select id="mail-compose-to">
                    ${recipientDepartments.map((dept) => `<option value="${window.pltEscapeHtml(dept.id)}">${window.pltEscapeHtml(dept.label || dept.id)}</option>`).join('')}
                </select>
                <label>Subject</label>
                <input id="mail-compose-subject" type="text" maxlength="120" placeholder="Subject">
                <label>Image URL (Optional)</label>
                <input id="mail-compose-image-url" type="url" maxlength="1024" placeholder="https://example.com/image.png">
                <label>Message</label>
                <textarea id="mail-compose-message" maxlength="4000" placeholder="Type your message..."></textarea>
            </div>
            <div class="mail-compose-actions">
                <button class="mail-btn ghost" onclick="window.toggleMailComposer(false)">Cancel</button>
                <button class="mail-btn primary" onclick="window.sendDepartmentMailFromBoss()">Send</button>
            </div>
        </div>
    ` : detailHtml;

    setTranslatedHTML(content, `
        <div class="mail-app">
            <div class="mail-sidebar">
                <div class="mail-sidebar-top">
                    <div class="mail-app-title">Mail</div>
                    <div class="mail-app-count">${folderMails.length} messages</div>
                    <div class="mail-folder-tabs">
                        <button class="mail-folder-tab ${folder === 'inbox' ? 'active' : ''}" onclick="window.switchMailFolder('inbox')">Inbox</button>
                        <button class="mail-folder-tab ${folder === 'sent' ? 'active' : ''}" onclick="window.switchMailFolder('sent')">Sent</button>
                    </div>
                </div>
                <div class="mail-list">
                    ${mailRows || '<div class="mail-empty-list">No messages for this mailbox.</div>'}
                </div>
            </div>
            <div class="mail-detail">
                <div class="mail-toolbar">
                    <button class="mail-compose-btn" onclick="window.toggleMailComposer(true)">
                        <i class="fas fa-pen"></i> New Message
                    </button>
                </div>
                ${composerHtml}
            </div>
        </div>
    `);
};

window.switchMailFolder = function(folder) {
    window.mailActiveFolder = (folder === 'sent') ? 'sent' : 'inbox';
    window.activeMailId = null;
    window.mailComposerOpen = false;
    window.renderMailApp();
};

window.toggleMailComposer = function(show) {
    window.mailComposerOpen = !!show;
    window.renderMailApp(window.activeMailId);
};

window.sendDepartmentMailFromBoss = function() {
    const toDeptEl = document.getElementById('mail-compose-to');
    const subjectEl = document.getElementById('mail-compose-subject');
    const imageUrlEl = document.getElementById('mail-compose-image-url');
    const messageEl = document.getElementById('mail-compose-message');
    if (!toDeptEl || !subjectEl || !imageUrlEl || !messageEl) return;

    toDeptEl.style.borderColor = '';
    subjectEl.style.borderColor = '';
    imageUrlEl.style.borderColor = '';
    messageEl.style.borderColor = '';

    const imageUrl = String(imageUrlEl.value || '').trim();
    const isImageUrlValid = imageUrl === '' || /^https?:\/\/\S+$/i.test(imageUrl);

    const payload = {
        fromDept: String(window.currentJobName || ''),
        toDept: String(toDeptEl.value || ''),
        senderName: String(window.currentPlayerName || 'Dispatch Center'),
        subject: String(subjectEl.value || '').trim(),
        imageUrl: imageUrl,
        message: String(messageEl.value || '').trim()
    };

    if (!payload.toDept || !payload.subject || !payload.message || !isImageUrlValid) {
        if (!payload.toDept) toDeptEl.style.borderColor = '#ff3b30';
        if (!payload.subject) subjectEl.style.borderColor = '#ff3b30';
        if (!isImageUrlValid) imageUrlEl.style.borderColor = '#ff3b30';
        if (!payload.message) messageEl.style.borderColor = '#ff3b30';
        return;
    }

    window.pltBossNuiFetch('sendDepartmentMail', payload)
        .then(function(res) {
            if (!res || !res.ok) return { ok: false };
            return res.json().catch(function() { return { ok: true }; });
        })
        .then(function(result) {
            if (result && result.ok === false) return;
            window.mailComposerOpen = false;
            window.mailActiveFolder = 'sent';
            window.activeMailId = null;
            window.renderMailApp();
        });
};

// Function: Render Settings App
window.renderSettingsApp = function(section = 'general') {
    const content = document.getElementById('mac-app-container-settings');
    if (!content) return;

    let sectionContent = '';
    if (section === 'general') {
        sectionContent = `
            <h2 class="settings-section-title">${window.T('settings_general')}</h2>
            <div class="settings-group">
                <div class="settings-row">
                    <span class="settings-row-label">Computer Name</span>
                    <span class="settings-row-value">${window.currentJobName ? window.currentJobName.toUpperCase() : 'DEPT-PC-01'}</span>
                </div>
                <div class="settings-row">
                    <span class="settings-row-label">OS Version</span>
                    <span class="settings-row-value">PearOS Sequoia 15.2</span>
                </div>
            </div>
            <div class="settings-group">
                <div class="settings-row">
                    <span class="settings-row-label">Automatic Updates</span>
                    <div class="settings-toggle active"><div class="settings-toggle-dot"></div></div>
                </div>
            </div>
        `;
    } else if (section === 'display') {
        sectionContent = `
            <h2 class="settings-section-title">${window.T('settings_display')}</h2>
            <div class="settings-group">
                <div class="settings-row">
                    <span class="settings-row-label">Brightness</span>
                    <input type="range" style="width: 150px;">
                </div>
                <div class="settings-row">
                    <span class="settings-row-label">Night Shift</span>
                    <div class="settings-toggle"><div class="settings-toggle-dot"></div></div>
                </div>
            </div>
            <div class="settings-group">
                <div class="settings-row">
                    <span class="settings-row-label">True Tone</span>
                    <div class="settings-toggle active"><div class="settings-toggle-dot"></div></div>
                </div>
            </div>
        `;
    } else if (section === 'appearance') {
        sectionContent = `
            <h2 class="settings-section-title">${window.T('settings_appearance')}</h2>
            <div class="settings-group">
                <div class="settings-row">
                    <span class="settings-row-label">Dark Mode</span>
                    <div class="settings-toggle active"><div class="settings-toggle-dot"></div></div>
                </div>
                <div class="settings-row">
                    <span class="settings-row-label">Accent Color</span>
                    <div style="display: flex; gap: 8px;">
                        <div style="width: 16px; height: 16px; border-radius: 50%; background: #007aff; border: 2px solid #fff; box-shadow: 0 0 0 1px #007aff;"></div>
                        <div style="width: 16px; height: 16px; border-radius: 50%; background: #ff3b30;"></div>
                        <div style="width: 16px; height: 16px; border-radius: 50%; background: #34c759;"></div>
                    </div>
                </div>
            </div>
        `;
    }

    setTranslatedHTML(content, `
        <div class="settings-app">
            <div class="settings-sidebar">
                <div class="settings-nav-item ${section === 'general' ? 'active' : ''}" onclick="window.renderSettingsApp('general')">
                    <i class="fas fa-cog"></i> ${window.T('settings_general')}
                </div>
                <div class="settings-nav-item ${section === 'appearance' ? 'active' : ''}" onclick="window.renderSettingsApp('appearance')">
                    <i class="fas fa-palette"></i> ${window.T('settings_appearance')}
                </div>
                <div class="settings-nav-item ${section === 'display' ? 'active' : ''}" onclick="window.renderSettingsApp('display')">
                    <i class="fas fa-desktop"></i> ${window.T('settings_display')}
                </div>
                <div class="settings-nav-item ${section === 'accessibility' ? 'active' : ''}" onclick="window.renderSettingsApp('accessibility')">
                    <i class="fas fa-universal-access"></i> ${window.T('settings_accessibility')}
                </div>
                <div class="settings-nav-item ${section === 'wallpaper' ? 'active' : ''}" onclick="window.renderSettingsApp('wallpaper')">
                    <i class="fas fa-image"></i> ${window.T('settings_wallpaper')}
                </div>
            </div>
            <div class="settings-content-area">
                ${sectionContent}
            </div>
        </div>
    `);
};

// Function: Render Cameras App
window.renderCamerasApp = function() {
    const windowId = 'cameras';
    const content = document.getElementById(`mac-app-container-${windowId}`);
    if (!content) return;

    setTranslatedHTML(content, `<div class="mac-loader"></div>`);

    const currentDeptId = window.pltNormalizeNodeId(window.currentJobName);
    // Find all cameras only from camera nodes linked to the officer's department.
    const allCameras = [];
    if (window.currentDeptData && window.currentDeptData.nodes) {
        window.currentDeptData.nodes.forEach(node => {
            const nodeDeptId = window.pltResolveDepartmentForNode(node.id);
            if (node.type === 'camera' && node.cameras && currentDeptId && nodeDeptId === currentDeptId) {
                node.cameras.forEach((cam, index) => {
                    if (cam.coords) {
                        allCameras.push({
                            nodeId: node.id,
                            camIndex: index,
                            label: cam.label || `Camera ${allCameras.length + 1}`,
                            coords: cam.coords
                        });
                    }
                });
            }
        });
    }

    let camerasHTML = '';
    if (allCameras.length > 0) {
        camerasHTML = allCameras.map((cam, index) => `
            <div class="camera-card" onclick="window.viewCamera('${cam.nodeId}', ${cam.camIndex})">
                <div class="camera-preview">
                    <i class="fas fa-video"></i>
                    <div class="camera-overlay">
                        <span>LIVE FEED</span>
                    </div>
                </div>
                <div class="camera-info">
                    <div class="camera-name">${cam.label}</div>
                    <div class="camera-status">ONLINE</div>
                </div>
            </div>
        `).join('');
    } else {
        camerasHTML = `<div class="mac-empty-state">${window.T('no_cameras_configured')}<br>${window.T('use_dept_manager_cameras')}</div>`;
    }

    setTranslatedHTML(content, `
        <div class="mac-app-container-glass">
            <div class="mac-app-header">
                <div class="mac-app-header-top">
                    <div class="mac-app-icon-large" style="background: none; border-radius: 0; display: flex; justify-content: center; align-items: center; box-shadow: none;">
                        <img src="img/camera${document.body.classList.contains('theme-vintage') ? '90' : ''}.png" style="width: 100%; height: 100%; object-fit: contain;">
                    </div>
                    <div class="mac-app-titles">
                        <h2>${window.T('surveillance')}</h2>
                        <p>${allCameras.length} ${window.T('cameras_registered')}</p>
                    </div>
                    <button class="mac-header-btn" onclick="window.openMacApp('dept_manager')">
                        <i class="fas fa-plus"></i> ${window.T('setup')}
                    </button>
                </div>
            </div>
            <div class="mac-scroll-area">
                <div class="camera-grid">
                    ${camerasHTML}
                </div>
            </div>
        </div>
    `);
};

window.viewCamera = function(nodeId, camIndex) {
    const currentDeptId = window.pltNormalizeNodeId(window.currentJobName);
    const nodeDeptId = window.pltResolveDepartmentForNode(nodeId);
    if (!currentDeptId || !nodeDeptId || nodeDeptId !== currentDeptId) {
        return;
    }

    // Find the camera node
    const node = window.pltGetNodeById(nodeId);
    if (!node || !node.cameras || !node.cameras[camIndex]) {
        return;
    }

    const cam = node.cameras[camIndex];
    if (!cam.coords) return;

    fetch(`https://${GetParentResourceName()}/viewCamera`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            nodeId: nodeId,
            camIndex: camIndex
        })
    });
    
    // Close boss menu to view camera
    window.closeBossMenu();
};

// Function: Render Finances App with Tab Support
window.renderFinancesApp = function(tab, showLoader = true, targetId = null) {
    if (!targetId) {
        targetId = (window.currentBossTheme === 'vintage') ? 'vintage-app-container-finances' : 'mac-app-container-finances';
    }
    console.log('Rendering Finances App:', tab, 'Job:', window.currentJobName, 'Target:', targetId);
    const content = document.getElementById(targetId);
    if (!content) return;

    if (showLoader) setTranslatedHTML(content, `<div class="mac-loader"></div>`);

    // Ensure we have a job name
    if (!window.currentJobName || window.currentJobName === 'none') {
        setTranslatedHTML(content, `<div class="mac-empty-state">${window.T('no_dept_job')}</div>`);
        return;
    }

    window.pltBossNuiGetPlayers().then(function(players) {
        if (!Array.isArray(players)) players = [];
        
        const deptMembers = players.filter(p => {
            if (p.cid && p.cid.startsWith('FAKE_')) return true;
            return String(p.jobName ?? '') === String(window.currentJobName ?? '');
        });
        
        // Find Rank Data for current department (Search all links)
        let rankNode = null;
        if (window.currentDeptData && window.currentDeptData.links && window.currentDeptData.nodes) {
            const rankLinks = window.currentDeptData.links.filter(l => l.from === window.currentJobName || l.to === window.currentJobName);
            for (const link of rankLinks) {
                const targetId = link.from === window.currentJobName ? link.to : link.from;
                const found = window.currentDeptData.nodes.find(n => n.id === targetId && n.type === 'rank');
                if (found) {
                    rankNode = found;
                    break;
                }
            }
        }

        let totalWeeklySalary = 0;
        deptMembers.forEach(member => {
            if (rankNode && rankNode.ranks) {
                const rank = rankNode.ranks.find(r => r.level == member.jobGradeLevel);
                if (rank) totalWeeklySalary += (rank.pay || 0);
            }
        });

        const budget = (window.deptBalances && window.deptBalances[window.currentJobName]) || 250000; 
        const avgSalary = deptMembers.length > 0 ? Math.round(totalWeeklySalary / deptMembers.length) : 0;

        const deptHistory = window.financeHistory[window.currentJobName] || [];
        let chartData = deptHistory.map(entry => entry.balance);
        
        if (chartData.length < 7) {
            const paddingCount = 7 - chartData.length;
            const firstVal = chartData.length > 0 ? chartData[0] : budget;
            const padding = Array(paddingCount).fill(firstVal);
            chartData = [...padding, ...chartData];
        } else if (chartData.length > 7) {
            chartData = chartData.slice(-7);
        }

        chartData[chartData.length - 1] = budget; // Chart shows budget history

        const maxVal = Math.max(...chartData, budget) * 1.1;
        const minVal = Math.min(...chartData) * 0.9;
        const range = maxVal - minVal || 1; 
        
        const chartPoints = chartData.map((val, i) => ({
            x: (i / (chartData.length - 1)) * 100,
            y: 100 - ((val - minVal) / range) * 100
        }));

        function getBezierPath(points) {
            if (points.length < 2) return "";
            let path = `M ${points[0].x},${points[0].y}`;
            for (let i = 0; i < points.length - 1; i++) {
                const p0 = points[i];
                const p1 = points[i + 1];
                const cp1x = p0.x + (p1.x - p0.x) / 2;
                path += ` C ${cp1x},${p0.y} ${cp1x},${p1.y} ${p1.x},${p1.y}`;
            }
            return path;
        }

        const smoothedPath = getBezierPath(chartPoints);

        const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
        let labels = [];
        for (let i = 6; i >= 0; i--) {
            const d = new Date();
            d.setDate(d.getDate() - i);
            labels.push(days[d.getDay()]);
        }

        let innerContent = '';
        if (tab === 'main') {
            innerContent = `
                <div class="mac-finance-summary-row">
                    <div class="finance-card">
                        <div class="finance-card-label">${window.T('net_balance')}</div>
                        <div class="finance-card-value">$${budget.toLocaleString()}</div>
                    </div>
                    <div class="finance-card">
                        <div class="finance-card-label">${window.T('expenses')}</div>
                        <div class="finance-card-value danger">-$${totalWeeklySalary.toLocaleString()}</div>
                    </div>
                    <div class="finance-card">
                        <div class="finance-card-label">${window.T('avg_salary')}</div>
                        <div class="finance-card-value success">$${avgSalary.toLocaleString()}</div>
                    </div>
                </div>

                <div class="mac-finance-actions-row">
                    <div class="finance-input-group">
                        <span class="currency-prefix">$</span>
                        <input type="number" id="finance-amount" placeholder="0" min="1">
                    </div>
                    <button class="mac-finance-btn deposit" onclick="window.financeAction('deposit')">
                        <i class="fas fa-arrow-up"></i>
                        <span>${window.T('deposit')}</span>
                    </button>
                    <button class="mac-finance-btn withdraw" onclick="window.financeAction('withdraw')">
                        <i class="fas fa-arrow-down"></i>
                        <span>${window.T('withdraw')}</span>
                    </button>
                </div>

                <div class="mac-finance-chart-container">
                    <div class="chart-header">
                        <h3>${window.T('balance_history')}</h3>
                        <span class="chart-period">${window.T('last_7_days')}</span>
                    </div>
                    <div class="chart-wrapper">
                        <svg viewBox="0 0 100 100" preserveAspectRatio="none" class="finance-svg-chart">
                            <defs>
                                <linearGradient id="chartGradient" x1="0" y1="0" x2="0" y2="1">
                                    <stop offset="0%" stop-color="rgba(52, 199, 89, 0.3)" />
                                    <stop offset="100%" stop-color="rgba(52, 199, 89, 0)" />
                                </linearGradient>
                            </defs>
                            <path d="${smoothedPath} L 100,100 L 0,100 Z" fill="url(#chartGradient)" />
                            <path d="${smoothedPath}" fill="none" stroke="#34C759" stroke-width="2" vector-effect="non-scaling-stroke" stroke-linecap="round" stroke-linejoin="round" />
                        </svg>
                        <div class="chart-labels-x">
                            ${labels.map(l => `<span>${l}</span>`).join('')}
                        </div>
                    </div>
                </div>

                <div class="mac-finance-stats">
                    <div class="stat-row">
                        <span>${window.T('total_staff')}</span>
                        <span>${deptMembers.length}</span>
                    </div>
                </div>
            `;
        } else if (tab === 'salary') {
            let salaryList = '<div class="mac-empty-state">No ranks configured.</div>';
            if (rankNode && rankNode.ranks) {
                salaryList = rankNode.ranks.map(r => `
                    <div class="salary-row editable">
                        <div class="salary-rank-info">
                            <span class="rank-level-tag">Lvl ${r.level}</span>
                            <span class="rank-name">${r.name}</span>
                        </div>
                        <div class="salary-input-wrapper">
                            <span>$</span>
                            <input type="number" value="${r.pay || 0}" 
                                onchange="window.updateRankSalary('${rankNode.id}', ${r.level}, this.value)">
                        </div>
                    </div>
                `).join('');
            }
            innerContent = `
                <div class="mac-salary-list">
                    ${salaryList}
                </div>
            `;
        }

        let currentAutoPay = 'none';
        if (window.deptAutoPay && window.currentJobName) {
            currentAutoPay = window.deptAutoPay[window.currentJobName] || 'none';
        }

        setTranslatedHTML(content, `
            <div class="mac-app-container-glass finance-app">
                <div class="mac-app-header">
                <div class="mac-app-header-top">
                    <div class="mac-app-icon-large" style="background: none; box-shadow: none;">
                        <img src="img/finances${document.body.classList.contains('theme-vintage') ? '90' : ''}.png" style="width: 100%; height: 100%; object-fit: contain;">
                    </div>
                    <div class="mac-app-titles">
                            <h2>${window.T('app_finances')}</h2>
                            <p>${tab === 'main' ? window.T('dept_budget') : window.T('rank_salaries')}</p>
                        </div>
                    </div>
                    <div class="mac-app-tabs">
                        <button class="mac-tab-btn ${tab === 'main' ? 'active' : ''}" onclick="window.renderFinancesApp('main')">${window.T('overview')}</button>
                        <button class="mac-tab-btn ${tab === 'salary' ? 'active' : ''}" onclick="window.renderFinancesApp('salary')">${window.T('salary')}</button>
                    </div>
                </div>
                <div class="mac-scroll-area finance-content">
                    ${innerContent}
                </div>
                ${tab === 'salary' ? `
                    <div class="mac-app-footer ios-style-footer">
                        <button class="ios-btn primary" onclick="window.distributeSalaries()">
                            ${window.T('pay_once')}
                        </button>
                        <div class="ios-btn-group">
                            <button class="ios-btn-item ${currentAutoPay === 'hourly' ? 'active' : ''}" onclick="window.toggleAutoPay('hourly')">${window.T('hourly')}</button>
                            <button class="ios-btn-item ${currentAutoPay === 'daily' ? 'active' : ''}" onclick="window.toggleAutoPay('daily')">${window.T('daily')}</button>
                        </div>
                        <button class="ios-btn danger ${currentAutoPay === 'none' ? 'hidden' : ''}" onclick="window.toggleAutoPay('none')">
                            ${window.T('cancel')}
                        </button>
                    </div>
                ` : ''}
            </div>
        `);
    })
    .catch(err => {
        console.error('Finances App Error:', err);
        setTranslatedHTML(content, `<div class="mac-empty-state">${window.T('finances_error')}</div>`);
    });
};

window.distributeSalaries = function() {
    fetch(`https://${GetParentResourceName()}/distributeSalaries`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            dept: window.currentJobName
        })
    }).then(() => {
        // UI will be updated via syncData if needed
    });
};

window.financeAction = function(action) {
    const amountInput = document.getElementById('finance-amount');
    if (!amountInput) return;
    
    const amount = amountInput.value;
    if (amount === null || amount === "") return;
    const num = parseInt(amount);
    if (isNaN(num) || num <= 0) return;

    fetch(`https://${GetParentResourceName()}/financeAction`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            dept: window.currentJobName,
            action: action,
            amount: num
        })
    }).then(() => {
        amountInput.value = '';
    });
};

// Function: Member Management Handlers
window.manageMember = function(citizenid, action) {
    console.log(`Managing member ${citizenid}: ${action}`);
    window.pltBossNuiFetch('manageMember', {
        cid: citizenid,
        action: action,
        dept: window.currentJobName
    }).then(function(res) {
        if (res === null) return;
        window.renderDepartmentMembers(false);
        const membersWin = document.getElementById('mac-window-members') || document.getElementById('vintage-window-members');
        if (membersWin && !membersWin.classList.contains('hidden')) {
            const activeTab = membersWin.querySelector('.mac-tab-btn.active');
            const tabType = (activeTab && activeTab.innerText === 'Database') ? 'main' : 'divisions';
            setTimeout(function() { window.renderMembersApp(tabType, false); }, 400);
        }
    }).catch(function() {});
};

window.updateRankSalary = function(rankNodeId, level, newValue) {
    const salary = parseInt(newValue);
    if (isNaN(salary)) return;

    fetch(`https://${GetParentResourceName()}/updateRankSalary`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            rankNodeId: rankNodeId,
            level: level,
            pay: salary
        })
    });
};

window.toggleAutoPay = function(type) {
    if (!window.currentJobName) return;
    
    // Optimistic UI update
    if (!window.deptAutoPay) window.deptAutoPay = {};
    window.deptAutoPay[window.currentJobName] = type;
    
    // Refresh without loader for smooth transition
    window.renderFinancesApp('salary', false);

    fetch(`https://${GetParentResourceName()}/toggleAutoPay`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            dept: window.currentJobName,
            type: type
        })
    });
};

// Function: Close App (Global)
window.closeMacApp = function(windowId) {
    const win = document.getElementById(`mac-window-${windowId}`);
    if (win) {
        // Remove active dot from dock
        let dockId = 'dock-members';
        if (windowId === 'dept') dockId = 'dock-dept';
        else if (windowId === 'finances') dockId = 'dock-finances';
        else if (windowId === 'safari') dockId = 'dock-safari';
        else if (windowId === 'calculator') dockId = 'dock-calculator';
        else if (windowId === 'mail') dockId = 'dock-mail';
        else if (windowId === 'clock') dockId = 'dock-clock';
        else if (windowId === 'settings') dockId = 'dock-settings';
        
        const dockItem = document.getElementById(dockId);
        if (dockItem) dockItem.classList.remove('app-open');

        win.style.animation = 'scaleOut 0.2s ease-in forwards';
        setTimeout(() => {
            win.style.display = 'none';
            win.classList.add('hidden');
            win.style.animation = ''; // Reset animation
            
            // Revert top bar title if no windows left
            const visibleWindows = document.querySelectorAll('.mac-window:not(.hidden)');
            const activeAppName = document.getElementById('active-app-name');
            if (activeAppName) {
                if (visibleWindows.length === 0) {
                    activeAppName.innerText = 'Desktop';
                } else {
                    // Find the one with highest z-index
                    let topWin = null;
                    let maxZ = -1;
                    visibleWindows.forEach(w => {
                        const z = parseInt(w.style.zIndex || 0);
                        if (z > maxZ) { maxZ = z; topWin = w; }
                    });
                    if (topWin) {
                        const activeAppName = document.getElementById('active-app-name');
                        const appName = topWin.getAttribute('data-app');
                        if (activeAppName && appName) {
                            activeAppName.innerText = appName;
                        }
                    }
                }
            }
        }, 200);
    }
};


// Function: Shutdown PC (Modern Style)
window.shutdownPC = function() {
    const modernContainer = document.getElementById('boss-menu-container');
    const vintageContainer = document.getElementById('vintage-boss-menu-container');
    const chassis = document.querySelector('.macintosh-chassis');
    const vintageMonitor = document.querySelector('.vintage-monitor');
    
    // Animate modern chassis if visible
    if (chassis && modernContainer && modernContainer.classList.contains('visible')) {
        chassis.style.transition = 'opacity 0.5s ease-out, transform 0.5s ease-out';
        chassis.style.opacity = '0';
        chassis.style.transform = 'scale(0.95)';
    }

    // Animate vintage monitor if visible
    if (vintageMonitor && vintageContainer && vintageContainer.classList.contains('visible')) {
        vintageMonitor.style.transition = 'opacity 0.5s ease-out, transform 0.5s ease-out';
        vintageMonitor.style.opacity = '0';
        vintageMonitor.style.transform = 'scale(0.95)';
    }
    
    // Close all modern windows
    window.closeMacApp('dept');
    window.closeMacApp('members');
    window.closeMacApp('finances');
    window.closeMacApp('safari');
    window.closeMacApp('calculator');
    window.closeMacApp('mail');
    window.closeMacApp('clock');
    window.closeMacApp('settings');

    // Close all vintage windows
    if (typeof window.closeVintageApp === 'function') {
        window.closeVintageApp('dept');
        window.closeVintageApp('members');
        window.closeVintageApp('finances');
        window.closeVintageApp('safari');
    }
    
    // Clear all modern dock dots
    document.querySelectorAll('.dock-item').forEach(item => {
        item.classList.remove('app-open');
    });
    
    const activeAppName = document.getElementById('active-app-name');
    if (activeAppName) activeAppName.innerText = 'Desktop';
    
    setTimeout(() => {
        if (modernContainer) {
            modernContainer.classList.remove('visible');
            modernContainer.style.display = 'none';
        }
        if (vintageContainer) {
            vintageContainer.classList.remove('visible');
            vintageContainer.style.display = 'none';
        }

        // Reset styles for next open
        if (chassis) {
            chassis.style.opacity = '1';
            chassis.style.transform = 'scale(1)';
        }
        if (vintageMonitor) {
            vintageMonitor.style.opacity = '1';
            vintageMonitor.style.transform = 'scale(1)';
        }

        // Apply theme reset to body
        document.body.classList.remove('theme-modern', 'theme-vintage');

        fetch(`https://${GetParentResourceName()}/closeBossMenu`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({})
        });
    }, 500);
};

// Modern Power On sequence
window.startMacBoot = function() {
    const container = document.getElementById('boss-menu-container');
    const boot = document.getElementById('boot-screen');
    const desktop = document.querySelector('.macos-desktop');
    const progress = document.querySelector('.progress-fill');
    
    if (!container) return;

    container.style.display = 'flex';
    container.classList.add('visible');
    
    // Instant Boot Sequence
    if (boot) boot.style.display = 'none'; // Skip boot screen for instant experience
    if (desktop) {
        desktop.style.display = 'flex';
        desktop.style.opacity = '1';
        desktop.style.transition = 'none';
    }
};

window.refreshTrackers = function() {
    fetch(`https://${GetParentResourceName()}/getTrackers`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
};

window.locateTracker = function(plate) {
    const tracker = (window.currentTrackers || []).find(t => t.plate === plate);
    if (!tracker || !tracker.coords) return;
    
    fetch(`https://${GetParentResourceName()}/locateTrackedVehicle`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ plate: plate, coords: tracker.coords })
    });
};

window.removeTrackerUI = function(plate) {
    fetch(`https://${GetParentResourceName()}/removeTracker`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ plate: plate })
    }).then(() => {
        window.refreshTrackers();
    });
};

window.selectChatDept = function(deptId) {
    window.selectedChatDept = deptId;
    window.renderSafariApp('comms');
};

window.loadDeptMessages = function() {
    if (!window.selectedChatDept) return;
    
    fetch(`https://${GetParentResourceName()}/getDeptComms`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ fromDept: window.currentJobName, toDept: window.selectedChatDept })
    }).then(res => res.json()).then(messages => {
        window.displayDeptMessages(messages);
    });
};

window.displayDeptMessages = function(messages) {
    const chatMessages = document.getElementById('chat-messages');
    if (!chatMessages) return;
    
    // Fetch all departments to map IDs to labels
    fetch(`https://${GetParentResourceName()}/getAllDepts`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    }).then(res => res.json()).then(depts => {
        const currentDept = window.currentJobName;
        const deptMap = {};
        depts.forEach(d => { deptMap[d.id] = d.label; });

        setTranslatedHTML(chatMessages, messages.map(m => `
            <div class="message-wrapper ${m.fromDept === currentDept ? 'sent' : 'received'}">
                <div class="message-bubble">
                    <div class="message-sender">${m.senderName} (${deptMap[m.fromDept] || m.fromDept.toUpperCase()})</div>
                    <div class="message-text">${m.message}</div>
                    <div class="message-time">${new Date(m.timestamp * 1000).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</div>
                </div>
            </div>
        `).join(''));
        
        // Auto-scroll to bottom with a slight delay to ensure content is rendered
        setTimeout(() => {
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }, 50);
    });
};

window.sendDeptMessage = function() {
    const input = document.getElementById('comms-message-input');
    if (!input || !input.value.trim() || !window.selectedChatDept) return;
    
    const message = input.value.trim();
    input.value = '';
    
    fetch(`https://${GetParentResourceName()}/sendDeptMessage`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            fromDept: window.currentJobName,
            toDept: window.selectedChatDept,
            message: message
        })
    }).then(() => {
        // OPTIMISTIC UPDATE: Force immediate reload for sender to ensure they see their message
        window.loadDeptMessages();
    });
};

// NUI Message Listener
window.currentBossTheme = 'modern';

window.closeBossMenu = function() {
    const modernContainer = document.getElementById('boss-menu-container');
    const vintageContainer = document.getElementById('vintage-boss-menu-container');
    
    if (modernContainer) {
        modernContainer.classList.remove('visible');
        modernContainer.style.setProperty('display', 'none', 'important');
    }
    if (vintageContainer) {
        vintageContainer.classList.remove('visible');
        vintageContainer.style.setProperty('display', 'none', 'important');
    }

    fetch(`https://${GetParentResourceName()}/closeBossMenu`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
};

window.addEventListener('message', (event) => {
    if (event.data.action === 'openBossMenu') {
        const theme = event.data.theme || 'modern';
        window.currentBossTheme = theme;
        
        window.currentDeptData = event.data.data;
        window.currentJobName = event.data.jobName;
        window.currentPlayerName = event.data.playerName || "OFFICER";
        window.currentPlayerRank = event.data.playerRank || "SERGEANT";
        window.financeHistory = event.data.finances || {};
        window.deptBalances = event.data.balances || {};
        window.deptAutoPay = event.data.autoPay || {};
        window.syncedTransactions = event.data.transactions || {};
        window.syncedMembers = event.data.members || {};
        window.syncedDepartmentCatalog = event.data.departmentCatalog || [];
        window.syncedWarrants = event.data.warrants || [];
        window.syncedCaseFiles = event.data.cases || [];
        window.syncedBolos = event.data.bolos || [];
        window.syncedDeptNews = event.data.news || [];
        window.syncedDutyLogs = event.data.dutyLogs || {};
        window.syncedDepartmentMail = event.data.mails || {};
        window.syncedFormSubmissions = event.data.formSubmissions || {};
        window.formsActiveStatus = 'Pending';
        window.activeFormId = null;
        window.activeMailId = null;
        window.mailComposerOpen = false;
        window.mailActiveFolder = 'inbox';
        window.syncedRadars = event.data.radars || {};
        window.pltSpeedUnit = event.data.speedUnit || window.pltSpeedUnit || 'KM/H';
        
        const modernContainer = document.getElementById('boss-menu-container');
        const vintageContainer = document.getElementById('vintage-boss-menu-container');

        // Apply theme class to body for CSS scoping
        document.body.classList.remove('theme-modern', 'theme-vintage');
        document.body.classList.add(theme === 'vintage' ? 'theme-vintage' : 'theme-modern');

        if (theme === 'vintage') {
            if (modernContainer) {
                modernContainer.classList.remove('visible');
                modernContainer.style.setProperty('display', 'none', 'important');
            }
            if (vintageContainer) {
                vintageContainer.classList.add('visible');
                vintageContainer.style.setProperty('display', 'flex', 'important');
            }
        } else {
            if (vintageContainer) {
                vintageContainer.classList.remove('visible');
                vintageContainer.style.setProperty('display', 'none', 'important');
            }
            if (modernContainer) {
                modernContainer.classList.add('visible');
                modernContainer.style.setProperty('display', 'flex', 'important');
                window.startMacBoot();
            }
        }
    } else if (event.data.action === 'receiveTrackers') {
        window.currentTrackers = event.data.trackers || [];
        const safariWin = document.getElementById('mac-window-safari');
        if (safariWin && !safariWin.classList.contains('hidden')) {
            const activeTab = safariWin.querySelector('.safari-tab.active');
            if (activeTab && activeTab.querySelector('span').innerText.toLowerCase().includes('trackers')) {
                window.renderSafariApp('trackers');
            }
        }
    } else if (event.data.action === 'receiveDeptComms') {
        const safariWin = document.getElementById('mac-window-safari');
        if (safariWin && !safariWin.classList.contains('hidden')) {
            const activeTab = safariWin.querySelector('.safari-tab.active');
            if (activeTab && activeTab.querySelector('span').innerText.toLowerCase().includes('comms')) {
                // If the chat area exists, update it directly
                if (document.getElementById('comms-chat-area')) {
                    if (window.selectedChatDept === event.data.dept1 || window.selectedChatDept === event.data.dept2) {
                        window.displayDeptMessages(event.data.messages || []);
                    }
                } else {
                    // If chat area doesn't exist (maybe switched tabs), re-render the whole app
                    window.renderSafariApp('comms');
                }
            }
        }
    } else if (event.data.action === 'syncData') {
        if (event.data.data) window.currentDeptData = event.data.data;
        if (event.data.finances) window.financeHistory = event.data.finances;
        if (event.data.balances) window.deptBalances = event.data.balances;
        if (event.data.autoPay) window.deptAutoPay = event.data.autoPay;
        if (event.data.transactions) window.syncedTransactions = event.data.transactions;
        if (event.data.members) window.syncedMembers = event.data.members;
        if (event.data.departmentCatalog) window.syncedDepartmentCatalog = event.data.departmentCatalog;
        if (event.data.warrants) window.syncedWarrants = event.data.warrants;
        if (event.data.cases) window.syncedCaseFiles = event.data.cases;
        if (event.data.bolos) window.syncedBolos = event.data.bolos;
        if (event.data.news) window.syncedDeptNews = event.data.news;
        if (event.data.dutyLogs) window.syncedDutyLogs = event.data.dutyLogs;
        if (event.data.mails) window.syncedDepartmentMail = event.data.mails;
        if (event.data.formSubmissions) window.syncedFormSubmissions = event.data.formSubmissions;
        if (event.data.radars) window.syncedRadars = event.data.radars;
        if (event.data.speedUnit) window.pltSpeedUnit = event.data.speedUnit;
        if (event.data.mdtEnabled !== undefined) window.mdtEnabled = event.data.mdtEnabled;

        // Refresh Finances app if open
        const financesWin = document.getElementById('mac-window-finances');
        if (financesWin && !financesWin.classList.contains('hidden')) {
            const activeTab = financesWin.querySelector('.mac-tab-btn.active');
            if (activeTab) {
                const tabType = activeTab.innerText === 'Overview' ? 'main' : 'salary';
                window.renderFinancesApp(tabType, false);
            }
        }

        // Refresh Members app if open
        const membersWin = document.getElementById('mac-window-members');
        if (membersWin && !membersWin.classList.contains('hidden')) {
            const activeTab = membersWin.querySelector('.mac-tab-btn.active');
            if (activeTab) {
                const tabType = activeTab.innerText === 'Database' ? 'main' : 'divisions';
                window.renderMembersApp(tabType, false);
            }
        }

        // Refresh Department app if open (check both modern and vintage)
        const deptWin = document.getElementById('mac-window-dept');
        const vintageDeptWin = document.getElementById('vintage-window-dept');
        const isDeptOpen = (deptWin && !deptWin.classList.contains('hidden')) || 
                          (vintageDeptWin && !vintageDeptWin.classList.contains('hidden'));
        
        if (isDeptOpen && window.pltBossDeptAppTab !== 'recruitment') {
            window.renderDepartmentMembers(false);
        }

        // Refresh Safari app if open
        const safariWin = document.getElementById('mac-window-safari');
        if (safariWin && !safariWin.classList.contains('hidden')) {
            const activeTab = safariWin.querySelector('.safari-tab.active');
            if (activeTab) {
                // Determine which page/subpage to render
                const tabLabel = activeTab.querySelector('span').innerText.toLowerCase();
                if (tabLabel === 'intranet') {
                    const activeLink = safariWin.querySelector('.nav-links a.active');
                    const subPage = activeLink ? activeLink.innerText.trim().toLowerCase().replace(' ', '') : 'dashboard';
                    // Map display text back to internal subpage IDs
                    let finalSubPage = subPage;
                    if (subPage === 'casefiles') finalSubPage = 'cases';
                    else if (subPage === 'deptnews') finalSubPage = 'deptnews';
                    
                    window.renderSafariApp('intranet', finalSubPage);
                } else {
                    const pageId = tabLabel.includes('fines') ? 'fines' : (tabLabel.includes('forms') ? 'forms' : (tabLabel.includes('radars') ? 'shifts' : 'logs'));
                    window.renderSafariApp(pageId);
                }
            }
        }

        const mailWin = document.getElementById('mac-window-mail');
        if (mailWin && !mailWin.classList.contains('hidden')) {
            window.renderMailApp(window.activeMailId);
        }
    } else if (event.data.action === 'syncTransactions') {
        window.syncedTransactions = event.data.transactions || {};
        const safariWin = document.getElementById('mac-window-safari');
        if (safariWin && !safariWin.classList.contains('hidden')) {
            const activeTab = safariWin.querySelector('.safari-tab.active');
            if (activeTab) {
                const tabLabel = activeTab.querySelector('span').innerText.toLowerCase();
                if (tabLabel.includes('fines')) {
                    window.renderSafariApp('fines');
                }
            }
        }
    }
});

window.renderMembersApp = function(tab, showLoader = true, targetId = null) {
    if (!targetId) {
        targetId = (window.currentBossTheme === 'vintage') ? 'vintage-app-container-members' : 'mac-app-container-members';
    }
    const content = document.getElementById(targetId);
    if (!content) return;

    if (showLoader) setTranslatedHTML(content, `<div class="mac-loader"></div>`);
    
    window.pltBossNuiGetPlayers().then(function(players) {
        if (!Array.isArray(players)) players = [];
        let innerContent = '';
        
        if (tab === 'main') {
            const list = players.map(p => {
                // Get member rating
                const memberData = (window.syncedMembers && window.syncedMembers[p.cid]) || {};
                const ratings = memberData.ratings || [];
                let avgRating = 0;
                if (ratings.length > 0) {
                    const sum = ratings.reduce((acc, r) => acc + (r.overall || 0), 0);
                    avgRating = (sum / ratings.length).toFixed(1);
                }

                return `
                <div class="mac-member-card ${!p.isOnline ? 'is-offline' : ''}">
                    <div class="mac-member-info-left">
                        <div class="member-avatar-ios" style="background: #007aff; color: white;">
                            ${p.name.charAt(0)}
                            <div class="online-indicator ${p.isOnline ? 'online' : 'offline'}"></div>
                </div>
                        <div class="member-details-ios">
                            <div class="member-name-ios">
                                ${p.name} 
                                <span class="ios-id-tag">${p.isOnline ? '#' + p.id : window.T('offline')}</span>
                            </div>
                            <div class="member-rank-ios">${p.jobLabel} - ${p.jobGradeLabel}</div>
                            <div class="member-rating-ios">
                                <i class="fas fa-star" style="color: ${avgRating > 0 ? '#ffcc00' : '#ccc'}"></i>
                                <span>${avgRating > 0 ? avgRating : 'No Rating'}</span>
                                <span class="rating-count">(${ratings.length} reports)</span>
                            </div>
                        </div>
                    </div>
                    <div class="mac-member-actions-slim">
                        <button class="ios-slim-btn" onclick="window.showReportModal('${p.cid}', '${p.name}')">
                            <i class="fas fa-file-signature"></i>
                            <span>Reports</span>
                        </button>
                    </div>
                </div>
            `}).join('');
            innerContent = `<div class="mac-scroll-area">${list || '<div class="mac-empty-state">' + window.T('no_personnel') + '</div>'}</div>`;
        } else if (tab === 'divisions') {
            const divisions = (window.currentDeptData.divisions && window.currentDeptData.divisions[window.currentJobName]) || [];
            const divList = divisions.map(d => `
                <div class="mac-division-item">
                    <div class="div-info">
                        <div class="div-icon"><i class="fas fa-layer-group"></i></div>
                        <div class="div-details">
                            <span class="div-name">${d.name}</span>
                            <span class="div-id">${d.id}</span>
                        </div>
                    </div>
                    <button class="ios-slim-btn danger compact" onclick="window.manageDivision('delete', '${d.id}')">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            `).join('');

            innerContent = `
                <div class="mac-divisions-container">
                    <div class="mac-division-creator">
                        <input type="text" id="new-div-name" placeholder="New Division Name (e.g. K9 Unit)">
                        <button class="mac-btn-primary slim" onclick="window.manageDivision('create')">Create</button>
                    </div>
                    <div class="mac-scroll-area divisions-list">
                        ${divList || '<div class="mac-empty-state">' + window.T('no_divisions') + '</div>'}
                    </div>
            </div>
        `;
        }
        
        setTranslatedHTML(content, `
            <div class="mac-app-container-glass">
                <div class="mac-app-header">
                <div class="mac-app-header-top">
                    <div class="mac-app-icon-large" style="background: none; box-shadow: none;">
                        <img src="img/members${document.body.classList.contains('theme-vintage') ? '90' : ''}.png" style="width: 100%; height: 100%; object-fit: contain;">
                    </div>
                    <div class="mac-app-titles">
                            <h2>${window.T('personnel_records')}</h2>
                            <p>${tab === 'main' ? players.length + ' ' + window.T('total_personnel') : window.T('division_management')}</p>
                        </div>
                    </div>
                    <div class="mac-app-tabs">
                        <button class="mac-tab-btn ${tab === 'main' ? 'active' : ''}" onclick="window.renderMembersApp('main')">${window.T('database')}</button>
                        <button class="mac-tab-btn ${tab === 'divisions' ? 'active' : ''}" onclick="window.renderMembersApp('divisions')">${window.T('divisions')}</button>
                    </div>
                </div>
                ${innerContent}
            </div>
        `);
    }).catch(function() {
        setTranslatedHTML(content, `<div class="mac-empty-state">${window.T('no_personnel')}</div>`);
    });
};

window.manageDivision = function(action, divId) {
    const name = action === 'create' ? document.getElementById('new-div-name').value : null;
    if (action === 'create' && (!name || name.trim() === '')) return;

    window.pltBossNuiFetch('manageDivision', {
        action: action,
        deptId: window.currentJobName,
        name: name,
        divId: divId
    }).then(function(res) {
        if (res === null) return;
        if (action === 'create') {
            const input = document.getElementById('new-div-name');
            if (input) input.value = '';
        }
        window.renderMembersApp('divisions', false);
        window.renderDepartmentMembers(false);
    }).catch(function() {});
};

// --- WARRANT LOGIC ---

window.editingWarrantId = null;
window.editingCaseId = null;

window.toggleWarrantForm = function() {
    const form = document.getElementById('inline-warrant-form');
    const btn = document.getElementById('btn-toggle-warrant-form');
    const headerTitle = document.querySelector('.inline-form-card .form-header span');
    if (!form) return;
    
    if (form.style.display === 'none') {
        form.style.display = 'block';
        if (btn) setTranslatedHTML(btn, '<i class="fas fa-times"></i> ' + window.T('close_form'));
        if (headerTitle) headerTitle.innerText = window.T('create_warrant');
        // Reset fields
        document.getElementById('warrant-subject').value = '';
        document.getElementById('warrant-priority').value = 'Standard';
        document.getElementById('warrant-charges').value = '';
        window.editingWarrantId = null;
        const submitBtn = form.querySelector('.intranet-btn-sm.primary');
        if (submitBtn) submitBtn.innerText = window.T('submit_to_db');
    } else {
        form.style.display = 'none';
        if (btn) setTranslatedHTML(btn, '<i class="fas fa-plus"></i> ' + window.T('new_warrant'));
    }
};

window.toggleCaseForm = function() {
    const form = document.getElementById('inline-case-form');
    const btn = document.getElementById('btn-toggle-case-form');
    const headerTitle = document.querySelector('#inline-case-form .form-header span');
    if (!form) return;
    
    if (form.style.display === 'none') {
        form.style.display = 'block';
        if (btn) setTranslatedHTML(btn, '<i class="fas fa-times"></i> ' + window.T('close_form'));
        if (headerTitle) headerTitle.innerText = window.T('create_case_file');
        // Reset fields
        document.getElementById('case-title').value = '';
        document.getElementById('case-status').value = 'Open';
        document.getElementById('case-summary').value = '';
        document.getElementById('case-details').value = '';
        window.editingCaseId = null;
        const submitBtn = form.querySelector('.intranet-btn-sm.primary');
        if (submitBtn) submitBtn.innerText = window.T('save_case_file');
    } else {
        form.style.display = 'none';
        if (btn) setTranslatedHTML(btn, '<i class="fas fa-plus"></i> ' + window.T('new_case_file'));
    }
};

window.editCaseFile = function(id) {
    const c = window.syncedCaseFiles.find(item => item.id === id);
    if (!c) return;

    const form = document.getElementById('inline-case-form');
    const headerTitle = document.querySelector('#inline-case-form .form-header span');
    if (!form) return;

    form.style.display = 'block';
    const btn = document.getElementById('btn-toggle-case-form');
    if (btn) setTranslatedHTML(btn, '<i class="fas fa-times"></i> ' + window.T('close_form'));
    if (headerTitle) headerTitle.innerText = window.T('edit_case_file');

    document.getElementById('case-title').value = c.title;
    document.getElementById('case-status').value = c.status;
    document.getElementById('case-summary').value = c.summary;
    document.getElementById('case-details').value = c.details;
    window.editingCaseId = id;

    const submitBtn = form.querySelector('.intranet-btn-sm.primary');
    if (submitBtn) submitBtn.innerText = window.T('update_case_file');

    const scrollContainer = document.querySelector('.warrants-scroll-wrapper');
    if (scrollContainer) scrollContainer.scrollTop = 0;
};

window.submitCaseInline = function() {
    const title = document.getElementById('case-title').value;
    const status = document.getElementById('case-status').value;
    const summary = document.getElementById('case-summary').value;
    const details = document.getElementById('case-details').value;

    if (!title || !summary) {
        if (!title) document.getElementById('case-title').style.borderColor = '#f85149';
        if (!summary) document.getElementById('case-summary').style.borderColor = '#f85149';
        return;
    }

    if (window.editingCaseId) {
        fetch(`https://${GetParentResourceName()}/updateCaseFile`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ id: window.editingCaseId, title, status, summary, details })
        });
    } else {
        fetch(`https://${GetParentResourceName()}/addCaseFile`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ title, status, summary, details })
        });
    }

    window.toggleCaseForm();
};

window.viewCaseFile = function(id) {
    const c = window.syncedCaseFiles.find(item => item.id === id);
    if (!c) return;

    const container = document.getElementById('inline-view-container-cases');
    if (!container) return;

    // Hide other view containers
    const wView = document.getElementById('inline-view-container');
    if (wView) wView.style.display = 'none';
    const bView = document.getElementById('inline-view-container-bolos');
    if (bView) bView.style.display = 'none';

    // Hide creation form if open
    const creationForm = document.getElementById('inline-case-form');
    if (creationForm) creationForm.style.display = 'none';
    const createBtn = document.getElementById('btn-toggle-case-form');
    if (createBtn) setTranslatedHTML(createBtn, '<i class="fas fa-plus"></i> ' + window.T('new_case_file'));

    container.style.display = 'block';
    setTranslatedHTML(container, `
        <div class="form-header">
            <span>${window.T('intelligence_file')}: #${c.id.toString().slice(-6)}</span>
        </div>
        <div class="case-details-inline">
            <div class="detail-row">
                <span class="label">CASE TITLE:</span>
                <span class="value subject">${c.title}</span>
            </div>
            <div class="detail-row">
                <span class="label">STATUS:</span>
                <span class="value ${c.status === 'Closed' ? '' : 'priority-high'}">${c.status.toUpperCase()} STATUS</span>
            </div>
            <div class="detail-row">
                <span class="label">OFFICER:</span>
                <span class="value">${c.issuedBy}</span>
            </div>
            <div class="detail-row">
                <span class="label">CREATED:</span>
                <span class="value">${c.issuedDate}</span>
            </div>
            <div class="detail-box" style="margin-top: 15px;">
                <span class="label">EXECUTIVE SUMMARY:</span>
                <div class="box-content">${c.summary}</div>
            </div>
            <div class="detail-box" style="margin-top: 15px;">
                <span class="label">FULL INVESTIGATION DETAILS:</span>
                <div class="box-content" style="white-space: pre-wrap;">${c.details}</div>
            </div>
        </div>
        <div class="form-footer">
            <button class="intranet-btn-sm" onclick="document.getElementById('inline-view-container-cases').style.display='none'">${window.T('close_file')}</button>
        </div>
    `);

    // Jump to view
    const scrollArea = document.querySelector('.safari-content-area');
    if (scrollArea) scrollArea.scrollTop = 0;
    const scrollContainer = document.querySelector('.warrants-scroll-wrapper');
    if (scrollContainer) scrollContainer.scrollTop = 0;
};

window.deleteCaseFile = function(id) {
    fetch(`https://${GetParentResourceName()}/deleteCaseFile`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(id)
    });
};

window.editWarrant = function(id) {
    const w = window.syncedWarrants.find(item => item.id === id);
    if (!w) return;

    const form = document.getElementById('inline-warrant-form');
    const headerTitle = document.querySelector('.inline-form-card .form-header span');
    if (!form) return;

    // Ensure form is open
    form.style.display = 'block';
    const btn = document.getElementById('btn-toggle-warrant-form');
    if (btn) setTranslatedHTML(btn, '<i class="fas fa-times"></i> ' + window.T('close_form'));
    if (headerTitle) headerTitle.innerText = window.T('edit_warrant');

    // Populate fields
    document.getElementById('warrant-subject').value = w.subject;
    document.getElementById('warrant-priority').value = w.priority;
    document.getElementById('warrant-charges').value = w.charges;
    window.editingWarrantId = id;

    // Change button text
    const submitBtn = form.querySelector('.intranet-btn-sm.primary');
    if (submitBtn) submitBtn.innerText = window.T('update_warrant');

    // Jump to form
    const scrollContainer = document.querySelector('.warrants-scroll-wrapper');
    if (scrollContainer) scrollContainer.scrollTop = 0;
};

window.submitWarrantInline = function() {
    const subject = document.getElementById('warrant-subject').value;
    const priority = document.getElementById('warrant-priority').value;
    const charges = document.getElementById('warrant-charges').value;

    if (!subject || !charges) {
        if (!subject) document.getElementById('warrant-subject').style.borderColor = '#f85149';
        if (!charges) document.getElementById('warrant-charges').style.borderColor = '#f85149';
        return;
    }

    if (window.editingWarrantId) {
        // Handle Edit
        fetch(`https://${GetParentResourceName()}/updateWarrant`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ id: window.editingWarrantId, subject, priority, charges })
        });
    } else {
        // Handle New
        fetch(`https://${GetParentResourceName()}/addWarrant`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ subject, priority, charges })
        });
    }

    window.toggleWarrantForm();
};

window.viewWarrant = function(id) {
    const w = window.syncedWarrants.find(item => item.id === id);
    if (!w) return;

    const container = document.getElementById('inline-view-container');
    if (!container) return;

    // Hide other view containers
    const cView = document.getElementById('inline-view-container-cases');
    if (cView) cView.style.display = 'none';
    const bView = document.getElementById('inline-view-container-bolos');
    if (bView) bView.style.display = 'none';

    // Hide creation form if open
    const creationForm = document.getElementById('inline-warrant-form');
    if (creationForm) creationForm.style.display = 'none';
    const createBtn = document.getElementById('btn-toggle-warrant-form');
    if (createBtn) setTranslatedHTML(createBtn, '<i class="fas fa-plus"></i> ' + window.T('new_warrant'));

    container.style.display = 'block';
    setTranslatedHTML(container, `
        <div class="form-header">
            <span>${window.T('judicial_record')}: CASE #${w.id.toString().slice(-6)}</span>
        </div>
        <div class="warrant-details-inline">
            <div class="detail-row">
                <span class="label">SUBJECT:</span>
                <span class="value subject">${w.subject}</span>
            </div>
            <div class="detail-row">
                <span class="label">PRIORITY:</span>
                <span class="value ${w.priority === 'High' ? 'priority-high' : ''}">${w.priority.toUpperCase()} PRIORITY</span>
            </div>
            <div class="detail-row">
                <span class="label">ISSUED BY:</span>
                <span class="value">${w.issuedBy}</span>
            </div>
            <div class="detail-row">
                <span class="label">DATE:</span>
                <span class="value">${w.issuedDate}</span>
            </div>
            <div class="detail-box" style="margin-top: 15px;">
                <span class="label">CHARGES & EVIDENCE:</span>
                <div class="box-content">${w.charges}</div>
            </div>
        </div>
        <div class="form-footer">
            <button class="intranet-btn-sm" onclick="document.getElementById('inline-view-container').style.display='none'">${window.T('close_record')}</button>
        </div>
    `);

    // Jump to view
    const scrollArea = document.querySelector('.safari-content-area');
    if (scrollArea) scrollArea.scrollTop = 0;
    const scrollContainer = document.querySelector('.warrants-scroll-wrapper');
    if (scrollContainer) scrollContainer.scrollTop = 0;
};

window.deleteWarrant = function(id) {
    fetch(`https://${GetParentResourceName()}/deleteWarrant`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(id)
    });
};

window.toggleBoloForm = function() {
    const form = document.getElementById('inline-bolo-form');
    if (!form) return;

    // Hide view container if open
    const viewContainer = document.getElementById('inline-view-container-bolos');
    if (viewContainer) viewContainer.style.display = 'none';

    if (form.style.display === 'none') {
        form.style.display = 'block';
        setTranslatedHTML(document.getElementById('btn-toggle-bolo-form'), '<i class="fas fa-times"></i> ' + window.T('close_form'));
        window.editingBoloId = null;
        document.querySelector('#inline-bolo-form .form-header span').innerText = window.T('create_bolo');
        document.querySelector('#inline-bolo-form .intranet-btn-sm.primary').innerText = window.T('post_alert');
        
        // Reset fields
        document.getElementById('bolo-title').value = '';
        document.getElementById('bolo-type').value = 'Vehicle';
        document.getElementById('bolo-plate').value = '';
        document.getElementById('bolo-lastseen').value = '';
        document.getElementById('bolo-description').value = '';
    } else {
        form.style.display = 'none';
        setTranslatedHTML(document.getElementById('btn-toggle-bolo-form'), '<i class="fas fa-plus"></i> ' + window.T('new_bolo'));
    }
};

window.submitBoloInline = function() {
    const title = document.getElementById('bolo-title').value;
    const type = document.getElementById('bolo-type').value;
    const plate = document.getElementById('bolo-plate').value;
    const lastSeen = document.getElementById('bolo-lastseen').value;
    const description = document.getElementById('bolo-description').value;

    if (!title || !description) {
        if (!title) document.getElementById('bolo-title').style.borderColor = '#f85149';
        if (!description) document.getElementById('bolo-description').style.borderColor = '#f85149';
        return;
    }

    if (window.editingBoloId) {
        fetch(`https://${GetParentResourceName()}/updateBolo`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ id: window.editingBoloId, title, type, plate, lastSeen, description })
        });
    } else {
        fetch(`https://${GetParentResourceName()}/addBolo`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ title, type, plate, lastSeen, description })
        });
    }

    window.toggleBoloForm();
};

window.editBolo = function(id) {
    const b = window.syncedBolos.find(item => item.id === id);
    if (!b) return;

    const form = document.getElementById('inline-bolo-form');
    if (!form) return;

    // Hide view container if open
    const viewContainer = document.getElementById('inline-view-container-bolos');
    if (viewContainer) viewContainer.style.display = 'none';

    form.style.display = 'block';
    setTranslatedHTML(document.getElementById('btn-toggle-bolo-form'), '<i class="fas fa-times"></i> ' + window.T('close_form'));
    document.querySelector('#inline-bolo-form .form-header span').innerText = window.T('edit_bolo');
    document.querySelector('#inline-bolo-form .intranet-btn-sm.primary').innerText = window.T('update_alert');

    document.getElementById('bolo-title').value = b.title;
    document.getElementById('bolo-type').value = b.type;
    document.getElementById('bolo-plate').value = b.plate || '';
    document.getElementById('bolo-lastseen').value = b.lastSeen || '';
    document.getElementById('bolo-description').value = b.description;
    window.editingBoloId = id;

    const scrollContainer = document.querySelector('.warrants-scroll-wrapper');
    if (scrollContainer) scrollContainer.scrollTop = 0;
};

window.viewBolo = function(id) {
    const b = window.syncedBolos.find(item => item.id === id);
    if (!b) return;

    const container = document.getElementById('inline-view-container-bolos');
    if (!container) return;

    const creationForm = document.getElementById('inline-bolo-form');
    if (creationForm) creationForm.style.display = 'none';
    const createBtn = document.getElementById('btn-toggle-bolo-form');
    if (createBtn) setTranslatedHTML(createBtn, '<i class="fas fa-plus"></i> ' + window.T('new_bolo'));

    container.style.display = 'block';
    setTranslatedHTML(container, `
        <div class="form-header">
            <span>BOLO ALERT: #${b.id.toString().slice(-6)}</span>
        </div>
        <div class="case-details-inline">
            <div class="detail-row">
                <span class="label">BOLO SUBJECT:</span>
                <span class="value subject">${b.title}</span>
            </div>
            <div class="detail-row">
                <span class="label">ALERT TYPE:</span>
                <span class="value priority-high">${b.type.toUpperCase()}</span>
            </div>
            ${b.plate ? `
            <div class="detail-row">
                <span class="label">PLATE:</span>
                <span class="value">${b.plate}</span>
            </div>` : ''}
            <div class="detail-row">
                <span class="label">LAST SEEN:</span>
                <span class="value">${b.lastSeen || 'UNKNOWN'}</span>
            </div>
            <div class="detail-row">
                <span class="label">ISSUED BY:</span>
                <span class="value">${b.issuedBy}</span>
            </div>
            <div class="detail-box" style="margin-top: 15px;">
                <span class="label">DESCRIPTION & REASON:</span>
                <div class="box-content" style="white-space: pre-wrap;">${b.description}</div>
            </div>
        </div>
        <div class="form-footer">
            <button class="intranet-btn-sm" onclick="document.getElementById('inline-view-container-bolos').style.display='none'">${window.T('close_alert')}</button>
        </div>
    `);

    const scrollContainer = document.querySelector('.warrants-scroll-wrapper');
    if (scrollContainer) scrollContainer.scrollTop = 0;
};

window.deleteBolo = function(id) {
    fetch(`https://${GetParentResourceName()}/deleteBolo`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(id)
    });
};

window.toggleNewsForm = function() {
    const form = document.getElementById('inline-news-form');
    if (!form) return;

    if (form.style.display === 'none') {
        form.style.display = 'block';
        setTranslatedHTML(document.getElementById('btn-toggle-news-form'), '<i class="fas fa-times"></i> ' + window.T('close_form'));
        document.getElementById('news-title').value = '';
        document.getElementById('news-content').value = '';
    } else {
        form.style.display = 'none';
        setTranslatedHTML(document.getElementById('btn-toggle-news-form'), '<i class="fas fa-plus"></i> ' + window.T('new_article'));
    }
};

window.submitNewsInline = function() {
    const title = document.getElementById('news-title').value;
    const content = document.getElementById('news-content').value;

    if (!title || !content) {
        if (!title) document.getElementById('news-title').style.borderColor = '#f85149';
        if (!content) document.getElementById('news-content').style.borderColor = '#f85149';
        return;
    }

    fetch(`https://${GetParentResourceName()}/addNews`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ title, content })
    });

    window.toggleNewsForm();
};

window.deleteNews = function(id) {
    fetch(`https://${GetParentResourceName()}/deleteNews`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(id)
    });
};

window.completeWarrant = function(id) {
    fetch(`https://${GetParentResourceName()}/completeWarrant`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(id)
    });
};

window.showReportModal = function(cid, name) {
    const memberData = (window.syncedMembers && window.syncedMembers[cid]) || {};
    const reports = memberData.ratings || [];
    
    let modal = document.getElementById('mac-generic-modal');
    if (!modal) {
        modal = document.createElement('div');
        modal.id = 'mac-generic-modal';
        document.getElementById('boss-menu-container').appendChild(modal);
    }
    
    modal.className = 'mac-modal-overlay visible';
    
    const renderStars = (rating) => {
        let stars = '';
        for (let i = 1; i <= 5; i++) {
            stars += `<i class="fas fa-star" style="color: ${i <= rating ? '#ffcc00' : '#ccc'}"></i>`;
        }
        return stars;
    };

    const reportsList = reports.map(r => `
        <div class="report-log-item">
            <div class="report-log-header">
                <span class="report-author">${r.author}</span>
                <span class="report-date">${r.date}</span>
                <span class="report-overall">${renderStars(r.overall)}</span>
            </div>
            <div class="report-scores-grid">
                <div class="score-item"><span>Knowledge:</span> ${r.knowledge}/5</div>
                <div class="score-item"><span>Comms:</span> ${r.communication}/5</div>
                <div class="score-item"><span>Situational:</span> ${r.situation_management}/5</div>
                <div class="score-item"><span>Decision:</span> ${r.decision_making}/5</div>
                <div class="score-item"><span>Reports:</span> ${r.report_writing}/5</div>
            </div>
        </div>
    `).join('');

    setTranslatedHTML(modal, `
        <div class="mac-ios-modal reports-modal">
            <div class="modal-header">
                <h3>${window.T('performance_reports')}</h3>
                <p>${name}</p>
            </div>
            <div class="modal-content">
                <div class="new-report-section">
                    <h4>${window.T('add_new_report')}</h4>
                    <div class="rating-input-grid">
                        <div class="rating-field">
                            <label>Knowledge</label>
                            <input type="range" min="0" max="5" value="0" id="rate-knowledge" oninput="window.updateReportOverall()">
                            <span id="val-knowledge">0</span>
                        </div>
                        <div class="rating-field">
                            <label>Communication</label>
                            <input type="range" min="0" max="5" value="0" id="rate-communication" oninput="window.updateReportOverall()">
                            <span id="val-communication">0</span>
                        </div>
                        <div class="rating-field">
                            <label>Situation Mgmt</label>
                            <input type="range" min="0" max="5" value="0" id="rate-situation" oninput="window.updateReportOverall()">
                            <span id="val-situation">0</span>
                        </div>
                        <div class="rating-field">
                            <label>Decision Making</label>
                            <input type="range" min="0" max="5" value="0" id="rate-decision" oninput="window.updateReportOverall()">
                            <span id="val-decision">0</span>
                        </div>
                        <div class="rating-field">
                            <label>Report Writing</label>
                            <input type="range" min="0" max="5" value="0" id="rate-writing" oninput="window.updateReportOverall()">
                            <span id="val-writing">0</span>
                        </div>
                    </div>
                    <div class="overall-rating-display">
                        <span>Overall Rating:</span>
                        <div id="report-overall-stars">${renderStars(0)}</div>
                        <strong id="report-overall-value">0.0</strong>
                    </div>
                    <button class="mac-btn-primary full-width" onclick="window.submitOfficerReport('${cid}')">${window.T('submit_report')}</button>
                </div>
                <div class="reports-history-section">
                    <h4>${window.T('history')}</h4>
                    <div class="reports-log-container">
                        ${reportsList || '<div class="mac-empty-state">' + window.T('no_reports') + '</div>'}
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="mac-btn-secondary" onclick="window.closeMacModal()">${window.T('close')}</button>
            </div>
        </div>
    `);
};

window.updateReportOverall = function() {
    const k = parseInt(document.getElementById('rate-knowledge').value);
    const c = parseInt(document.getElementById('rate-communication').value);
    const s = parseInt(document.getElementById('rate-situation').value);
    const d = parseInt(document.getElementById('rate-decision').value);
    const w = parseInt(document.getElementById('rate-writing').value);

    document.getElementById('val-knowledge').innerText = k;
    document.getElementById('val-communication').innerText = c;
    document.getElementById('val-situation').innerText = s;
    document.getElementById('val-decision').innerText = d;
    document.getElementById('val-writing').innerText = w;

    const avg = ((k + c + s + d + w) / 5).toFixed(1);
    document.getElementById('report-overall-value').innerText = avg;
    
    // Update stars
    let stars = '';
    for (let i = 1; i <= 5; i++) {
        stars += `<i class="fas fa-star" style="color: ${i <= Math.round(avg) ? '#ffcc00' : '#ccc'}"></i>`;
    }
    document.getElementById('report-overall-stars').innerHTML = stars;
};

window.submitOfficerReport = function(cid) {
    const k = parseInt(document.getElementById('rate-knowledge').value);
    const c = parseInt(document.getElementById('rate-communication').value);
    const s = parseInt(document.getElementById('rate-situation').value);
    const d = parseInt(document.getElementById('rate-decision').value);
    const w = parseInt(document.getElementById('rate-writing').value);
    const overall = parseFloat(((k + c + s + d + w) / 5).toFixed(1));

    window.pltBossNuiFetch('submitOfficerReport', {
        cid: cid,
        knowledge: k,
        communication: c,
        situation_management: s,
        decision_making: d,
        report_writing: w,
        overall: overall
    }).then(function(res) {
        if (!res || !res.ok) return null;
        return window.pltBossNuiGetPlayers();
    }).then(function(players) {
        if (!Array.isArray(players)) return;
        const p = players.find(player => player.cid === cid);
        if (p) window.showReportModal(cid, p.name);
        const membersWin = document.getElementById('mac-window-members');
        if (membersWin && !membersWin.classList.contains('hidden')) {
            window.renderMembersApp('main', false);
        }
    }).catch(function() {});
};

const lapdMedals = [
    { id: 'LAPD-Medal-of-Valor', name: 'Medal of Valor' },
    { id: 'LAPD-Preservation-of-Life-Medal', name: 'Preservation of Life Medal' },
    { id: 'LAPD-Police-Distinguished-Service-Medal', name: 'Police Distinguished Service Medal' },
    { id: 'LAPD-Police-Commission-Unit-Citation', name: 'Police Commission Unit Citation' },
    { id: 'LAPD-Police-Medal', name: 'Police Medal' },
    { id: 'LAPD-Purple-Heart-Ribbon', name: 'Purple Heart' },
    { id: 'LAPD-Police-Meritorious-Service-Medal', name: 'Police Meritorious Service Medal' },
    { id: 'LAPD-Police-Meritorious-Achievement-Medal', name: 'Police Meritorious Achievement Medal' },
    { id: 'LAPD-Police-Meritorious-Unit-Citation', name: 'Police Meritorious Unit Citation' },
    { id: 'LAPD-Police-Star', name: 'Police Star' },
    { id: 'LAPD-Lifesaving-Medal', name: 'Lifesaving Medal' }
];

window.showHonorModal = function(cid, name) {
    // Get member data from syncedMembers or fetch it
    const memberData = (window.syncedMembers && window.syncedMembers[cid]) || {};
    const medals = Array.isArray(memberData.medals) ? memberData.medals : (typeof memberData.medals === 'object' ? Object.values(memberData.medals) : []);

    const activeHonors = medals.map((m, index) => `
        <div class="active-honor-item">
            <img src="img/${m.id}.webp" class="medal-icon-mini" onerror="this.src='img/members.png'">
            <div class="honor-info">
                <span class="honor-name">${m.name}</span>
                <span class="honor-date">${m.date || 'Unknown Date'}</span>
            </div>
            <button class="remove-honor-btn" onclick="window.removeMedal('${cid}', ${index}, '${name.replace(/'/g, "\\'")}')">
                <i class="fas fa-trash"></i>
            </button>
        </div>
    `).join('');

    const medalOptions = lapdMedals.map(m => {
        const imgPath = `img/${m.id}.webp`;
        return `
            <div class="medal-selection-item" onclick="window.awardMedal('${cid}', '${m.id}', '${m.name}')">
                <img src="${imgPath}" class="medal-icon-preview" onerror="this.onerror=null; this.src='img/members.png';">
                <div class="medal-info">
                    <span class="medal-name">${m.name}</span>
                    <span class="medal-description">LAPD OFFICIAL AWARD</span>
                </div>
            </div>
        `;
    }).join('');

    let modal = document.getElementById('mac-generic-modal');
    if (!modal) {
        modal = document.createElement('div');
        modal.id = 'mac-generic-modal';
        document.getElementById('boss-menu-container').appendChild(modal);
    }
    
    modal.className = 'mac-modal-overlay visible';
    setTranslatedHTML(modal, `
        <div class="mac-ios-modal">
            <div class="modal-header">
                <h3>${window.T('manage_honors')}</h3>
                <p>${window.T('personnel')}: ${name}</p>
            </div>
            <div class="modal-content">
                ${medals.length > 0 ? `
                    <div class="modal-section-title">${window.T('active_honors')}</div>
                    <div class="active-honors-list">
                        ${activeHonors}
                    </div>
                ` : ''}
                <div class="modal-section-title">${window.T('award_new_medal')}</div>
                <div class="medal-selection-list">
                    ${medalOptions}
                </div>
            </div>
            <div class="modal-footer">
                <button class="mac-btn-primary" onclick="window.closeMacModal()">${window.T('done')}</button>
            </div>
        </div>
    `);
};

window.awardMedal = function(cid, medalId, medalName) {
    window.pltBossNuiFetch('manageMember', {
        cid: cid,
        action: 'honor',
        medalId: medalId,
        medalName: medalName,
        dept: window.currentJobName
    }).then(function(res) {
        if (!res || !res.ok) return null;
        return window.pltBossNuiGetPlayers();
    }).then(function(players) {
        if (!Array.isArray(players)) return;
        const p = players.find(player => player.cid === cid);
        if (p) window.showHonorModal(cid, p.name);
        window.renderDepartmentMembers(false);
    }).catch(function() {});
};

window.removeMedal = function(cid, index, name) {
    window.pltBossNuiFetch('manageMember', {
        cid: cid,
        action: 'remove_honor',
        index: index,
        dept: window.currentJobName
    }).then(function(res) {
        if (!res || !res.ok) return null;
        return window.pltBossNuiGetPlayers();
    }).then(function(players) {
        if (!Array.isArray(players)) return;
        const p = players.find(player => player.cid === cid);
        if (p) window.showHonorModal(cid, name);
        window.renderDepartmentMembers(false);
    }).catch(function() {});
};

window.showDivisionModal = function(cid, name) {
    const divisions = (window.currentDeptData.divisions && window.currentDeptData.divisions[window.currentJobName]) || [];
    const memberDivs = (window.syncedMembers && window.syncedMembers[cid] && window.syncedMembers[cid].divisions) || [];
    
    const divOptions = divisions.map(d => {
        const isActive = memberDivs.includes(d.id);
        return `
            <div class="div-toggle-item ${isActive ? 'active' : ''}" onclick="window.toggleMemberDivision('${cid}', '${d.id}')">
                <span>${d.name}</span>
                <i class="fas ${isActive ? 'fa-check-circle' : 'fa-circle'}"></i>
            </div>
        `;
    }).join('');

    let modal = document.getElementById('mac-generic-modal');
    if (!modal) {
        modal = document.createElement('div');
        modal.id = 'mac-generic-modal';
        document.getElementById('boss-menu-container').appendChild(modal);
    }
    
    modal.className = 'mac-modal-overlay visible';
    setTranslatedHTML(modal, `
        <div class="mac-ios-modal">
            <div class="modal-header">
                <h3>${window.T('manage_divisions')}</h3>
                <p>${name}</p>
            </div>
            <div class="modal-content">
                ${divOptions.length > 0 ? divOptions : '<div class="mac-empty-state">' + window.T('no_divisions_available') + '</div>'}
            </div>
            <div class="modal-footer">
                <button class="mac-btn-primary" onclick="window.closeMacModal()">${window.T('done')}</button>
            </div>
        </div>
    `);
};

window.toggleMemberDivision = function(cid, divId) {
    window.pltBossNuiFetch('toggleMemberDivision', { cid: cid, divId: divId }).then(function(res) {
        if (res === null) return null;
        return window.pltBossNuiGetPlayers();
    }).then(function(players) {
        if (!Array.isArray(players)) return;
        const p = players.find(player => player.cid === cid);
        if (p) window.showDivisionModal(cid, p.name);
        const deptWin = document.getElementById('mac-window-dept');
        const vintageDept = document.getElementById('vintage-window-dept');
        if ((deptWin && !deptWin.classList.contains('hidden')) || (vintageDept && !vintageDept.classList.contains('hidden'))) {
            window.renderDepartmentMembers(false);
        }
    }).catch(function() {});
};

window.closeMacModal = function() {
    const modal = document.getElementById('mac-generic-modal');
    if (modal) modal.classList.remove('visible');
};

// Clock Logic
setInterval(() => {
    const clock = document.getElementById('mac-clock');
    if (clock) {
        const now = new Date();
        const timeStr = now.toLocaleTimeString('en-US', { 
            hour: 'numeric', 
            minute: '2-digit',
            hour12: true 
        });
        const dayStr = now.toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' });
        clock.innerText = `${dayStr}  ${timeStr}`;
    }
}, 1000);

// Key Handling
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
        const modernContainer = document.getElementById('boss-menu-container');
        const vintageContainer = document.getElementById('vintage-boss-menu-container');
        
        if ((modernContainer && modernContainer.classList.contains('visible')) || 
            (vintageContainer && vintageContainer.classList.contains('visible'))) {
            window.shutdownPC();
        }
    }
});

// --- Draggable Windows Functionality ---
document.addEventListener('DOMContentLoaded', () => {
    const setupDraggable = (winId) => {
        const win = document.getElementById(`mac-window-${winId}`);
        if (!win) return;
        const header = win.querySelector('.win-header');
        if (!header) return;

        window.pltDefaultWindowPositions[winId] = {
            left: win.style.left || '',
            top: win.style.top || ''
        };

        let isDragging = false;
        let offsetX, offsetY;

        // Bring to front on click
        win.addEventListener('mousedown', () => {
            win.style.zIndex = ++window.highestZIndex;
            
            // Update active app name based on data-app attribute
            const activeAppName = document.getElementById('active-app-name');
            const appName = win.getAttribute('data-app');
            if (activeAppName && appName) {
                activeAppName.innerText = appName;
            }
        });

        header.addEventListener('mousedown', (e) => {
            if (e.target.classList.contains('win-close')) return;
            isDragging = true;
            const rect = win.getBoundingClientRect();
            offsetX = e.clientX - rect.left;
            offsetY = e.clientY - rect.top;
            header.style.cursor = 'move';
        });

        document.addEventListener('mousemove', (e) => {
            if (!isDragging) return;
            const desktop = document.querySelector('.macos-desktop');
            if (!desktop) return;
            const desktopRect = desktop.getBoundingClientRect();
            const scale = window.resolutionScale || 1.0;
            
            let x = (e.clientX - desktopRect.left - offsetX) / scale;
            let y = (e.clientY - desktopRect.top - offsetY) / scale;

            // Keep window within the desktop area bounds
            x = Math.max(0, Math.min(x, (desktopRect.width / scale) - win.offsetWidth));
            y = Math.max(0, Math.min(y, (desktopRect.height / scale) - win.offsetHeight));

            win.style.left = x + 'px';
            win.style.top = y + 'px';
        });

        document.addEventListener('mouseup', () => {
            if (isDragging) {
                window.pltRememberWindowPosition(winId, win);
            }
            isDragging = false;
            header.style.cursor = 'default';
        });
    };

    setupDraggable('dept');
    setupDraggable('members');
    setupDraggable('finances');
    setupDraggable('safari');
    setupDraggable('calculator');
    setupDraggable('clock');
    setupDraggable('settings');
    setupDraggable('cameras');
});

// Calculator Logic
let calcCurrentValue = '0';
let calcPreviousValue = null;
let calcOperator = null;
let calcWaitingForNextValue = false;

window.calcInput = function(value) {
    const display = document.getElementById('calc-display');
    if (!display) return;

    if (value === 'AC') {
        calcCurrentValue = '0';
        calcPreviousValue = null;
        calcOperator = null;
        calcWaitingForNextValue = false;
    } else if (value === '+/-') {
        calcCurrentValue = (parseFloat(calcCurrentValue) * -1).toString();
    } else if (value === '%') {
        calcCurrentValue = (parseFloat(calcCurrentValue) / 100).toString();
    } else if (['+', '-', '*', '/'].includes(value)) {
        if (calcOperator && !calcWaitingForNextValue) {
            calcCurrentValue = window.calcPerformCalculation();
        }
        calcOperator = value;
        calcPreviousValue = calcCurrentValue;
        calcWaitingForNextValue = true;
    } else if (value === '=') {
        if (calcOperator && calcPreviousValue !== null) {
            calcCurrentValue = window.calcPerformCalculation();
            calcOperator = null;
            calcPreviousValue = null;
            calcWaitingForNextValue = false;
        }
    } else if (value === '.') {
        if (!calcCurrentValue.includes('.')) {
            calcCurrentValue += '.';
        }
    } else {
        // Number input
        if (calcWaitingForNextValue) {
            calcCurrentValue = value;
            calcWaitingForNextValue = false;
        } else {
            calcCurrentValue = calcCurrentValue === '0' ? value : calcCurrentValue + value;
        }
    }

    display.innerText = calcCurrentValue.substring(0, 10);
};

window.calcPerformCalculation = function() {
    const prev = parseFloat(calcPreviousValue);
    const curr = parseFloat(calcCurrentValue);
    if (isNaN(prev) || isNaN(curr)) return calcCurrentValue;

    let result = 0;
    switch (calcOperator) {
        case '+': result = prev + curr; break;
        case '-': result = prev - curr; break;
        case '*': result = prev * curr; break;
        case '/': result = prev / curr; break;
    }
    return result.toString();
};

// --- Dynamic MacOS Dock Magnification ---
document.addEventListener('DOMContentLoaded', () => {
    const dock = document.querySelector('.mac-dock');
    if (!dock) return;

    const dockItems = dock.querySelectorAll('.dock-item');
    const maxScale = 1.35; // Reduced from 1.8 for a more subtle effect
    const range = 100;     // Reduced from 150 for a tighter magnification area

    dock.addEventListener('mousemove', (e) => {
        const mouseX = e.clientX;

        dockItems.forEach(item => {
            const rect = item.getBoundingClientRect();
            const centerX = rect.left + rect.width / 2;
            const dist = Math.abs(mouseX - centerX);

            if (dist < range) {
                // Calculation for smooth curve (Gaussian-like)
                const scale = 1 + (maxScale - 1) * (1 - dist / range);
                const lift = (scale - 1) * 20;
                
                // Calculate margin with a smoother factor to avoid jumps at the edge of 'range'
                const extraWidth = (50 * scale - 50) / 2;
                const smoothnessFactor = Math.pow(1 - dist / range, 2); // Squared for a softer entrance
                const marginExtra = extraWidth + (smoothnessFactor * 6);
                
                item.style.margin = `0 ${marginExtra}px`;
                item.style.transform = `scale(${scale}) translateY(-${lift}px)`;
                item.style.zIndex = Math.round(scale * 10);
            } else {
                item.style.margin = '0';
                item.style.transform = 'scale(1) translateY(0)';
                item.style.zIndex = '1';
            }
        });
    });

    dock.addEventListener('mouseleave', () => {
        dockItems.forEach(item => {
            item.style.margin = '0';
            item.style.transform = 'scale(1) translateY(0)';
            item.style.zIndex = '1';
        });
    });
});

window.renderHiringTab = function(targetId = null) {
    if (!targetId) {
        targetId = (window.currentBossTheme === 'vintage') ? 'vintage-app-container-dept' : 'mac-app-container-dept';
    }
    const content = document.getElementById(targetId);
    if (!content) return;

    if (typeof window.pltBossInvalidateDeptRoster === 'function') {
        window.pltBossInvalidateDeptRoster();
    }
    window.pltBossDeptAppTab = 'recruitment';

    let deptLabel = "Department";
    if (window.currentDeptData && window.currentDeptData.nodes) {
        const jid = String(window.currentJobName ?? '');
        const node = window.currentDeptData.nodes.find(n => String(n.id) === jid);
        if (node) deptLabel = node.label;
    }

    setTranslatedHTML(content, `
        <div class="mac-app-container-glass">
            <div class="mac-app-header">
                <div class="mac-app-header-top">
                    <div class="mac-app-icon-large" style="background: none; box-shadow: none;">
                        <img src="img/departments${document.body.classList.contains('theme-vintage') ? '90' : ''}.png" style="width: 100%; height: 100%; object-fit: contain;">
                    </div>
                    <div class="mac-app-titles">
                        <h2>${deptLabel}</h2>
                        <p>${window.T('recruitment_portal')}</p>
                    </div>
                </div>
                <div class="mac-app-tabs">
                    <div class="mac-tab" onclick="window.renderDepartmentMembers(false)">${window.T('roster')}</div>
                    <div class="mac-tab active" onclick="window.renderHiringTab()">${window.T('recruitment')}</div>
                </div>
            </div>
            <div class="mac-scroll-area">
                <div class="hiring-tab-content">
                    <div class="hiring-search-box">
                        <i class="fas fa-search" style="color: #8E8E93; align-self: center;"></i>
                        <input type="number" id="hiring-id-input" placeholder="${window.T('hiring_placeholder')}" onkeydown="if(event.key === 'Enter') window.searchPlayerForHire()">
                        <button class="hiring-search-btn" onclick="window.searchPlayerForHire()">${window.T('detect')}</button>
                    </div>
                    <div id="hiring-result-area">
                        <div class="mac-empty-state">${window.T('hiring_enter_id')}</div>
                    </div>
                </div>
            </div>
        </div>
    `);
};

window.searchPlayerForHire = function() {
    const idInput = document.getElementById('hiring-id-input');
    const resultArea = document.getElementById('hiring-result-area');
    if (!idInput || !resultArea) return;

    const id = parseInt(idInput.value);
    if (isNaN(id)) return;

    setTranslatedHTML(resultArea, `<div class="mac-loader"></div>`);

    window.pltBossNuiGetPlayers().then(function(players) {
        const player = players.find(p => p.id === id);
        if (!player) {
            setTranslatedHTML(resultArea, `<div class="mac-empty-state">${window.T('no_player_id', { 0: id })}</div>`);
            return;
        }

        // Get available ranks for this department
        let rankOptions = '';
        if (window.currentDeptData && window.currentDeptData.links) {
            let rankNode = null;
            for (const link of window.currentDeptData.links) {
                const tid = (link.from === window.currentJobName) ? link.to : (link.to === window.currentJobName ? link.from : null);
                if (tid) {
                    rankNode = window.currentDeptData.nodes.find(n => n.id === tid && n.type === 'rank');
                    if (rankNode) break;
                }
            }

            if (rankNode && rankNode.ranks) {
                rankOptions = rankNode.ranks.map(r => `<option value="${r.level}">${r.name} (Grade ${r.level})</option>`).join('');
            }
        }

        setTranslatedHTML(resultArea, `
            <div class="hiring-player-info">
                <div class="info-header">
                    <div class="info-avatar">${player.name.charAt(0)}</div>
                    <div class="info-details">
                        <h3>${player.name}</h3>
                        <p>${window.T('citizen_id')}: ${player.cid} • ID: #${player.id}</p>
                        <p>${window.T('current_job')}: ${player.jobLabel} (${player.jobGradeLabel})</p>
                    </div>
                </div>
                <div class="hire-form">
                    <label>${window.T('assign_rank')}</label>
                    <select id="hire-grade-select">
                        ${rankOptions || '<option value="0">' + (window.T('default_grade') || 'Default (Grade 0)') + '</option>'}
                    </select>
                    <button class="confirm-hire-btn" onclick="window.confirmHire(${player.id})">${window.T('hire_personnel')}</button>
                </div>
            </div>
        `);
    }).catch(function() {
        setTranslatedHTML(resultArea, `<div class="mac-empty-state">${window.T('no_personnel')}</div>`);
    });
};

window.confirmHire = function(playerId) {
    const gradeSelect = document.getElementById('hire-grade-select');
    if (!gradeSelect) return;

    const grade = parseInt(gradeSelect.value);

    window.pltBossNuiFetch('hirePlayer', {
        playerId: playerId,
        job: window.currentJobName,
        grade: grade
    }).then(function(res) {
        if (res === null) return;
        window.renderDepartmentMembers(false);
        const membersWin = document.getElementById('mac-window-members') || document.getElementById('vintage-window-members');
        if (membersWin && !membersWin.classList.contains('hidden')) {
            window.renderMembersApp('main', false);
        }
    }).catch(function() {});
};

// Add animations to CSS via JS
const style = document.createElement('style');
style.innerHTML = `
    @keyframes scaleIn {
        from { transform: scale(calc(var(--ui-scale, 1) * 0.9)); opacity: 0; }
        to { transform: scale(var(--ui-scale, 1)); opacity: 1; }
    }
    @keyframes scaleOut {
        from { transform: scale(var(--ui-scale, 1)); opacity: 1; }
        to { transform: scale(calc(var(--ui-scale, 1) * 0.9)); opacity: 0; }
    }
`;
document.head.appendChild(style);
