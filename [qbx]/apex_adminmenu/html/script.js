/* ============================================================
   Apex Admin Menu — Side Panel controller
   Renders the main menu and all sub-menus in a single right-
   aligned panel. No radial menu.
   ============================================================ */

let currentMenu   = null;          // 'main' | <sub-menu title>
let menuHistory   = [];            // stack of previous views
let menuData      = {};            // { mainItems, dialogCallback, ... }
let isMenuOpen    = false;
let toggleStates  = {};
let currentZoneData = null;

// Sub-menus that historically opened "centered" — kept here only
// to remember their existence (the new layout is uniform).
const centeredMenus = ['Spawn Vehicle', 'Custom Vehicle'];

// Buttons that close the menu after a click (kept from legacy).
const dialogButtons = [
    'Spawn Vehicle', 'Custom Vehicle', 'Modify License Plate',
    'Give Money', 'Give Item', 'Kick', 'Ban Player',
    'Server Announcement', 'Delete Entities', 'Create Zone'
];

// Icon mapping (fallback when item.icon is not provided).
const menuIcons = {
    // Self
    'Health': 'fas fa-heart-pulse',
    'No Clip': 'fas fa-person-walking-dashed-line-arrow-right',
    'Invisible': 'fas fa-eye-slash',
    'God Mode': 'fas fa-person-rays',
    'Revive': 'fas fa-bed-pulse',
    'Heal': 'fas fa-bandage',
    'Skin Menu': 'fas fa-shirt',
    'Change Ped': 'fas fa-people-arrows',

    // Vehicle
    'Spawn Vehicle': 'fas fa-car-on',
    'Repair Vehicle': 'fas fa-screwdriver-wrench',
    'Delete Vehicle': 'fas fa-trash',
    'Modify License Plate': 'fas fa-pen',
    'Refuel Vehicle': 'fas fa-gas-pump',
    'Give Keys': 'fas fa-key',
    'Lock/Unlock Doors': 'fas fa-unlock-keyhole',
    'Torque Modifier': 'fas fa-bolt',
    'Change Vehicle Color': 'fas fa-palette',

    // Player
    'Player Health': 'fas fa-heart-pulse',
    'Freeze': 'fas fa-street-view',
    'Player Data': 'fas fa-database',
    'Player Revive': 'fas fa-bed-pulse',
    'Player Heal': 'fas fa-bandage',
    'Player Skin Menu': 'fas fa-shirt',
    'Give Money': 'fas fa-money-bill',
    'Give Item': 'fas fa-hand-holding-medical',
    'Open Inventory': 'fas fa-box-open',
    'Clear Inventory': 'fas fa-boxes-packing',
    'Teleport To Player': 'fas fa-person-arrow-up-from-line',
    'Bring': 'fas fa-person-arrow-down-to-line',
    'Kick': 'fas fa-arrow-right-from-bracket',
    'Ban Player': 'fas fa-ban',

    // Server
    'Server Announcement': 'fas fa-bullhorn',
    'Ban List': 'fas fa-ban',
    'Delete Entities': 'fas fa-trash',
    'Weather Management': 'fas fa-cloud',

    // Zones
    'Create Zone': 'fas fa-plus-circle',
    'Manage Zones': 'fas fa-list',
    'Edit Zone': 'fas fa-pen-to-square',
    'Delete Zone': 'fas fa-trash',
    'Teleport To Zone': 'fas fa-location-arrow',

    // Developer
    'Debug Mode': 'fas fa-bug-slash',
    'Copy Vector3 Coords': 'fas fa-copy',
    'Copy Vector4 Coords': 'fas fa-copy',
    'Copy Heading': 'fas fa-compass',

    'default': 'fas fa-circle-info'
};

function getIconForItem(label) {
    if (!label) return menuIcons.default;
    if (menuIcons[label]) return menuIcons[label];
    for (const key in menuIcons) {
        if (label.includes(key)) return menuIcons[key];
    }
    return menuIcons.default;
}

/* ──────────────────────────────────────────────────────────── *
 *  INIT
 * ──────────────────────────────────────────────────────────── */
// Keep the real viewport size in sync with CSS custom properties. In
// FiveM, `100vh` can refer to the native render resolution while the
// actual window is smaller — that pushed UI off the visible area.
function syncViewportVars() {
    const w = window.innerWidth  / 100;
    const h = window.innerHeight / 100;
    document.documentElement.style.setProperty('--vw', w + 'px');
    document.documentElement.style.setProperty('--vh', h + 'px');
}
syncViewportVars();
window.addEventListener('resize', syncViewportVars);

/* ── Display mode ────────────────────────────────────────────
   The dark/light choice lives in the admin panel's Settings, but the
   quick menu has to honour it too. Two paths, because either can be
   the first to know:
     • on load, read the value the panel persisted — the panel runs in
       an iframe on this same page, so it shares this origin's
       localStorage;
     • while the panel is open, it postMessages every change here so
       the switch is live rather than needing a reload.
   ──────────────────────────────────────────────────────────── */
function applyQuickMenuMode(mode) {
    if (mode !== 'light' && mode !== 'dark') mode = 'dark';
    document.documentElement.dataset.mode = mode;
    try { localStorage.setItem('ap-mode', mode); } catch (_) {}
}
try {
    applyQuickMenuMode(localStorage.getItem('ap-mode') || 'dark');
} catch (_) {
    applyQuickMenuMode('dark');
}

/* While the admin panel's key-capture overlay is up, Escape belongs to it.
   The panel posts apex:escGuard on/off (html/admin/app.js setEscGuard). */
let panelEscGuard = false;

$(document).ready(function () {
    syncViewportVars();

    window.addEventListener('message', function (event) {
        const data = event.data;

        switch (data.action) {
            case 'openMenu':
                openMainMenu(data.items);
                break;
            case 'openSubMenu':
                openSubMenu(data.title, data.items, data.parent);
                break;
            case 'closeMenu':
                closeAllMenus();
                break;
            case 'showTextUI':
                showTextUI(data.text, data.icon);
                break;
            case 'hideTextUI':
                hideTextUI();
                break;
            case 'showDialog':
                showDialog(data.title, data.content, data.callback);
                break;
            case 'showInputDialog':
                showInputDialog(data.title, data.inputs, data.callback);
                break;
            case 'updateToggleState':
                if (data.menu && data.index !== undefined) {
                    toggleStates[`${data.menu}_${data.index}`] = data.checked;
                }
                break;

            case 'moveModeHint':
                MoveMenu.onHint(data);
                break;

            /* Display mode, forwarded from the admin panel iframe. */
            case 'apex:mode':
                applyQuickMenuMode(data.mode);
                break;

            /* The panel's key-capture overlay owns Escape while it is up. */
            case 'apex:escGuard':
                panelEscGuard = !!data.on;
                break;

            /* ── Reports Center ───────────────────────────────── */
            case 'reports:open':       Reports.open(data); break;
            case 'reports:update':     Reports.updateList(data.reports || []); break;
            case 'reports:detail':     Reports.openDetail(data.report, data.messages || []); break;
            case 'reports:message':    Reports.pushMessage(data.message); break;
            case 'reports:close':      Reports.close(); break;
            case 'reports:setIsAdmin': Reports.setIsAdmin(!!data.isAdmin); break;

            /* ── Screenshot composer ──────────────────────────── */
            case 'reports:beforeShot':       Reports.beforeShot(); break;
            case 'reports:afterShot':        Reports.afterShot(); break;
            case 'reports:freecam:show':     $('#freecam-hud').removeClass('hidden'); break;
            case 'reports:freecam:hide':     $('#freecam-hud').addClass('hidden'); break;
            case 'reports:reopenAfterShot':  Reports.reopen(); break;

            /* ── Staff HUD ────────────────────────────────────── */
            case 'staff:show':   StaffHud.show(data.reports || [], data.current); break;
            case 'staff:update': StaffHud.update(data.reports || [], data.current); break;
            case 'staff:hide':   StaffHud.hide(); break;
        }
    });

    // ESC closes everything.
    $(document).on('keyup', function (e) {
        if (e.key !== 'Escape') return;

        if (isMenuOpen) {
            $.post('https://apex_adminmenu/closeMenu', JSON.stringify({}));
            closeAllMenus();
            return;
        }

        // The admin panel lives in an iframe and registers its own Escape
        // handler inside it — which never fires when keyboard focus sits
        // on THIS document instead. Close it from here too.
        // (client/adminpanel.lua also watches the raw key, so this is a
        // belt-and-braces fallback rather than the only path.)
        const frame = document.getElementById('admin-panel-frame');
        if (frame && !frame.classList.contains('hidden')) {
            // Not while a key capture is up: that Esc cancels the capture
            // (the panel reads it from here as well) and must not also
            // close the panel.
            if (panelEscGuard) return;
            $.post('https://apex_adminmenu/panel:close', JSON.stringify({}));
        }
    });

    // Panel close button.
    $('#close-panel').on('click', function () {
        $.post('https://apex_adminmenu/closeMenu', JSON.stringify({}));
        closeAllMenus();
    });

    // Make the side panel draggable by its header. Position is persisted
    // in localStorage so it survives reloads and restarts.
    const panelDrag = makeDraggable('#side-panel', '#panel-header', 'apex.hud.panelPos');
    $('#panel-reset').on('click', function (e) {
        e.stopPropagation();
        if (panelDrag) panelDrag.reset();
    });
    // Re-apply saved position whenever the panel becomes visible. We use
    // a MutationObserver so we don't have to find every spot in the code
    // that toggles its visibility.
    (function watchPanelVisibility() {
        const el = document.getElementById('side-panel');
        if (!el) return;
        const obs = new MutationObserver(() => {
            if (!el.classList.contains('hidden') && panelDrag) {
                requestAnimationFrame(() => panelDrag.pinCurrent());
            }
        });
        obs.observe(el, { attributes: true, attributeFilter: ['class'] });
    })();

    // Dialog close / cancel.
    $('#close-dialog, #dialog-cancel').on('click', function () {
        $('#dialog-modal').addClass('hidden');
        $.post('https://apex_adminmenu/dialogResponse', JSON.stringify({
            response: false,
            values: null
        }));
    });

    // Back-button delegation.
    $(document).on('click', '.back-button', function () {
        goBack();
    });

    // Breadcrumb navigation.
    $(document).on('click', '.crumb.clickable', function () {
        const target = $(this).data('target');
        if (target === 'main') {
            menuHistory = [];
            openMainMenu(menuData.mainItems);
        }
    });

    // Values navigation arrows.
    $(document).on('click', '.values-nav.prev', function () {
        const wrap = $(this).siblings('.option-values');
        wrap.stop().animate({ scrollLeft: wrap.scrollLeft() - wrap.width() * 0.8 },
            260, 'easeOutCubic');
    });
    $(document).on('click', '.values-nav.next', function () {
        const wrap = $(this).siblings('.option-values');
        wrap.stop().animate({ scrollLeft: wrap.scrollLeft() + wrap.width() * 0.8 },
            260, 'easeOutCubic');
    });

    // Easing.
    $.easing.easeOutCubic = function (x, t, b, c, d) {
        return c * ((t = t / d - 1) * t * t + 1) + b;
    };
});

/* ──────────────────────────────────────────────────────────── *
 *  NAVIGATION
 * ──────────────────────────────────────────────────────────── */
function goBack() {
    if (currentMenu && currentMenu.includes('Player:')) {
        $.post('https://apex_adminmenu/menuSelected', JSON.stringify({
            menu: 'main',
            index: 1,
            label: 'Player Options'
        }));
        return;
    }

    if (currentMenu && currentMenu.includes('Players Online')) {
        openMainMenu(menuData.mainItems);
        return;
    }

    if (menuHistory.length > 0) {
        const prev = menuHistory.pop();

        if (prev === 'main') {
            openMainMenu(menuData.mainItems);
        } else if (typeof prev === 'object' && prev.title) {
            renderSubMenu(prev.title, prev.items, prev.parent, /* pushHistory */ false);
        }
    } else {
        openMainMenu(menuData.mainItems);
    }
}

/* ──────────────────────────────────────────────────────────── *
 *  MAIN MENU
 *  Renders the root list inside the side panel — no radial.
 * ──────────────────────────────────────────────────────────── */
function openMainMenu(items) {
    menuHistory      = [];
    menuData.mainItems = items;
    currentMenu      = 'main';
    isMenuOpen       = true;

    setPanelHeader('Admin Menu', null);
    setBreadcrumb([]);

    renderItems(items, /* withBackButton */ false, 'main');
    showPanel();
}

/* ──────────────────────────────────────────────────────────── *
 *  SUB-MENU
 * ──────────────────────────────────────────────────────────── */
function openSubMenu(title, items, parent) {
    renderSubMenu(title, items, parent, /* pushHistory */ true);
}

function renderSubMenu(title, items, parent, pushHistory) {
    if (pushHistory) {
        if (currentMenu === 'main') {
            menuHistory.push('main');
        } else if (currentMenu && currentMenu !== title) {
            menuHistory.push({
                title: currentMenu,
                items: $('#panel-content').data('items'),
                parent: $('#panel-content').data('parent')
            });
        }
    }

    currentMenu = title;
    isMenuOpen  = true;

    $('#panel-content').data('items', items).data('parent', parent);

    // We deliberately don't render the "parent" string ("main", a sub-menu
    // title, etc.) as a subtitle — the breadcrumb already tells the user
    // where they are.
    setPanelHeader(title, null);
    setBreadcrumb([
        { label: 'Admin Menu', target: 'main', clickable: true },
        { label: title, current: true }
    ]);

    renderItems(items, /* withBackButton */ true, title);
    showPanel();
}

/* ──────────────────────────────────────────────────────────── *
 *  RENDERING
 * ──────────────────────────────────────────────────────────── */
function showPanel() {
    $('#side-panel').removeClass('hidden');
    $('#panel-body').scrollTop?.(0);
    $('.panel-body').scrollTop(0);
    claimKeyboardFocus();
}

/* ────────────────────────────────────────────────────────────
   Keyboard focus
   ------------------------------------------------------------
   SetNuiFocus(true, true) hands input to CEF, but CEF does NOT
   automatically give keyboard focus to a document — nothing inside
   the page is focused until something is clicked. That is why the
   Alt toggle only started working after clicking the screen: no
   focused element meant `document` never received keydown.

   Focusing the panel explicitly on open fixes it without a click.
   The element carries tabindex="-1" so it is focusable by script but
   never lands in the tab order.
   ──────────────────────────────────────────────────────────── */
function claimKeyboardFocus() {
    try { window.focus(); } catch (_) {}
    const panel = document.getElementById('side-panel');
    if (!panel) return;
    // rAF: focusing an element that was `display:none` a moment ago is
    // ignored, so wait until the browser has actually laid it out.
    requestAnimationFrame(() => {
        try { panel.focus({ preventScroll: true }); } catch (_) { try { panel.focus(); } catch (_) {} }
    });
}

function setPanelHeader(title, subtitle) {
    $('#panel-title').text(title);
    if (subtitle) {
        $('#panel-description').text(subtitle);
        $('#panel-subhead').removeAttr('hidden');
    } else {
        $('#panel-subhead').attr('hidden', true);
    }
}

function setBreadcrumb(crumbs) {
    const $crumb = $('#panel-breadcrumb').empty();
    crumbs.forEach((c, idx) => {
        const node = $('<span class="crumb"></span>')
            .text(c.label)
            .toggleClass('clickable', !!c.clickable)
            .toggleClass('current',   !!c.current);
        if (c.target) node.attr('data-target', c.target);
        $crumb.append(node);
        if (idx < crumbs.length - 1) {
            $crumb.append('<i class="crumb-sep fa-solid fa-chevron-right"></i>');
        }
    });
}

function renderItems(items, withBackButton, menuKey) {
    const $list = $('#panel-content').empty();

    if (withBackButton) {
        $list.append(`
            <div class="option-item back-button">
                <div class="option-header">
                    <div class="option-icon"><i class="fa-solid fa-arrow-left"></i></div>
                    <div class="option-info">
                        <div class="option-title">Go Back</div>
                        <div class="option-description">Return to previous menu</div>
                    </div>
                </div>
            </div>
        `);
    }

    if (!items || items.length === 0) {
        $list.append(`
            <div class="option-empty">
                <i class="fa-regular fa-folder-open"></i>
                No items available.
            </div>
        `);
        return;
    }

    items.forEach((item, index) => {
        // Restore persisted toggle state.
        if (item.checked !== undefined) {
            const key = `${menuKey}_${index}`;
            if (toggleStates[key] !== undefined) item.checked = toggleStates[key];
        }
        $list.append(createOptionItem(item, index, menuKey));
    });
}

function createOptionItem(item, index, menuKey) {
    const $opt = $('<div class="option-item"></div>');
    const $head = $('<div class="option-header"></div>');

    const iconClass = item.icon || getIconForItem(item.label);
    $head.append(`<div class="option-icon"><i class="${iconClass}"></i></div>`);

    const $info = $('<div class="option-info"></div>')
        .append(`<div class="option-title"></div>`);
    $info.find('.option-title').text(item.label || '');
    if (item.description) {
        const $desc = $('<div class="option-description"></div>').text(item.description);
        $info.append($desc);
    }
    $head.append($info);

    // Toggle option.
    if (item.checked !== undefined) {
        const $tog = $(`
            <div class="option-toggle">
                <label class="toggle-switch">
                    <input type="checkbox" ${item.checked ? 'checked' : ''}>
                    <span class="toggle-slider"></span>
                </label>
            </div>
        `);
        $tog.find('input').on('change', function () {
            const checked = $(this).is(':checked');
            toggleStates[`${menuKey}_${index}`] = checked;
            $.post('https://apex_adminmenu/toggleOption', JSON.stringify({
                menu: menuKey,
                index: index,
                checked: checked
            }));
        });
        $head.append($tog);
    } else if (!item.values || item.values.length === 0) {
        // Drill-in / action items get a chevron.
        $head.append('<i class="option-chevron fa-solid fa-chevron-right"></i>');
    }

    $opt.append($head);

    // Progress bar.
    if (item.progress !== undefined) {
        $opt.append(`
            <div class="option-progress">
                <div class="progress-bar" style="width:${Number(item.progress) || 0}%"></div>
            </div>
        `);
    }

    // Values selector.
    if (item.values && item.values.length > 0) {
        const $wrap = $('<div class="option-values-wrapper"></div>');
        const $vals = $('<div class="option-values"></div>');
        $wrap.append('<div class="values-nav prev"><i class="fa-solid fa-chevron-left"></i></div>');

        item.values.forEach((val, vi) => {
            const text = val.label || val;
            const $v = $('<div class="value-item"></div>').text(text).attr('data-index', vi);
            if (item.defaultIndex !== undefined && item.defaultIndex === vi) $v.addClass('selected');
            $v.on('click', function () {
                $v.siblings().removeClass('selected');
                $v.addClass('selected');
                $.post('https://apex_adminmenu/valueSelected', JSON.stringify({
                    menu: menuKey,
                    optionIndex: index,
                    valueIndex: vi
                }));
            });
            $vals.append($v);
        });

        $wrap.append($vals);
        $wrap.append('<div class="values-nav next"><i class="fa-solid fa-chevron-right"></i></div>');
        $opt.append($wrap);
    }

    // Plain action items (no toggle, no values).
    if (item.checked === undefined && (!item.values || item.values.length === 0)) {
        $head.on('click', function () {
            if (item.zone) {
                currentZoneData = item.zone;
                $.post('https://apex_adminmenu/menuSelected', JSON.stringify({
                    menu: menuKey,
                    index: index,
                    label: item.label,
                    zone: item.zone
                }));
            } else if (menuKey && menuKey.includes('Editing Zone')) {
                $.post('https://apex_adminmenu/menuSelected', JSON.stringify({
                    menu: menuKey,
                    index: index,
                    label: item.label,
                    action: (item.label || '').toLowerCase().replace(/\s+/g, '_'),
                    zone: currentZoneData
                }));
            } else if (menuKey === 'main') {
                handleMainMenuSelection(index);
                return;
            } else {
                $.post('https://apex_adminmenu/menuSelected', JSON.stringify({
                    menu: menuKey,
                    index: index,
                    label: item.label
                }));
                if (menuKey === 'Developer Options') return;
            }

            if (item.close !== false) closePanel();
        });
    }

    return $opt;
}

/* ──────────────────────────────────────────────────────────── *
 *  MAIN-MENU SELECTION
 * ──────────────────────────────────────────────────────────── */
function handleMainMenuSelection(index) {
    const selected = menuData.mainItems[index];
    closePanel(); // close while we wait for the next openSubMenu push
    $.post('https://apex_adminmenu/menuSelected', JSON.stringify({
        menu: 'main',
        index: index,
        label: selected.label
    }));
}

/* ──────────────────────────────────────────────────────────── *
 *  CLOSE
 * ──────────────────────────────────────────────────────────── */
function closePanel() {
    $('#side-panel').addClass('hidden');
}

function closeAllMenus() {
    $('#side-panel').addClass('hidden');
    $('#dialog-modal').addClass('hidden');
    menuHistory = [];
    isMenuOpen  = false;
}

/* ──────────────────────────────────────────────────────────── *
 *  TEXT UI
 * ──────────────────────────────────────────────────────────── */
function showTextUI(text, icon = 'fa-info-circle') {
    $('#text-ui-text').text(text);
    $('#text-ui-icon').attr('class', `fas ${icon}`);
    $('#text-ui').removeClass('hidden');
}

function hideTextUI() {
    $('#text-ui').addClass('hidden');
}

/* ──────────────────────────────────────────────────────────── *
 *  DIALOGS
 * ──────────────────────────────────────────────────────────── */
function showDialog(title, content, callback) {
    $('#dialog-title').text(title);
    $('#dialog-content').html(content);
    menuData.dialogCallback = callback;

    $('#dialog-confirm').off('click').on('click', function () {
        $('#dialog-modal').addClass('hidden');
        $.post('https://apex_adminmenu/closeMenu', JSON.stringify({}));
        closeAllMenus();
        $.post('https://apex_adminmenu/dialogResponse', JSON.stringify({
            response: true,
            values: null
        }));
    });

    $('#dialog-modal').removeClass('hidden');
}

function showInputDialog(title, inputs, callback) {
    $('#dialog-title').text(title);
    menuData.dialogCallback = callback;

    const $body = $('#dialog-content').empty();

    inputs.forEach((input, i) => {
        const $group = $('<div class="input-group"></div>');
        if (input.label) $group.append(`<label for="input-${i}">${input.label}</label>`);

        if (input.type === 'select') {
            const $sel = $(`<select id="input-${i}"></select>`);
            (input.options || []).forEach(opt => {
                $sel.append(`<option value="${opt.value}">${opt.label}</option>`);
            });
            $group.append($sel);
        } else if (input.type === 'checkbox') {
            $group.append(`
                <label class="toggle-switch">
                    <input type="checkbox" id="input-${i}" ${input.checked ? 'checked' : ''}>
                    <span class="toggle-slider"></span>
                </label>
            `);
        } else {
            const $inp = $(`<input type="${input.type || 'text'}" id="input-${i}" placeholder="${input.placeholder || ''}">`);
            if (input.value !== undefined) $inp.val(input.value);
            $group.append($inp);
        }

        $body.append($group);
    });

    $('#dialog-confirm').off('click').on('click', function () {
        const values = inputs.map((input, i) =>
            input.type === 'checkbox'
                ? $(`#input-${i}`).is(':checked')
                : $(`#input-${i}`).val()
        );

        $('#dialog-modal').addClass('hidden');
        $.post('https://apex_adminmenu/closeMenu', JSON.stringify({}));
        closeAllMenus();
        $.post('https://apex_adminmenu/dialogResponse', JSON.stringify({
            response: true,
            values: values
        }));
    });

    $('#dialog-modal').removeClass('hidden');
}

/* ============================================================
   REPORTS CENTER
   ============================================================ */
const Reports = (function () {
    let state = {
        isAdmin:    false,
        reports:    [],
        current:    null,
        view:       'inbox',
        filter:     'all',
        attachment: null
    };

    function post(action, payload) {
        $.post(`https://apex_adminmenu/reports:${action}`, JSON.stringify(payload || {}));
    }

    function categoryLabel(cat) {
        if (cat === 'player_report') return 'Player report';
        if (cat === 'question')      return 'Question';
        if (cat === 'bug')           return 'Bug';
        return 'Report';
    }

    function statusLabel(report) {
        if (report.resolved) return 'Resolved';
        if (report.assistedBy) return 'Assisting';
        return 'Waiting';
    }

    function statusClass(report) {
        if (report.resolved) return 'resolved';
        if (report.assistedBy) return 'assisting';
        return '';
    }

    /* ── Visibility ──────────────────────────────────────── */
    function open(data) {
        state.isAdmin = !!data.isAdmin;
        state.reports = data.reports || [];

        $('#reports-overlay').removeClass('hidden');
        $('#staff-mode-row').toggleClass('hidden', !state.isAdmin);
        $('#staff-mode-toggle').prop('checked', state.isAdmin && !!data.staffMode);
        $('#hud-position-btn').toggleClass('hidden', !state.isAdmin);

        // Filters & detail actions are admin-only.
        $('#reports-list, .reports-filter').toggle(true);
        $('#rep-detail-actions').toggle(state.isAdmin);
        $('[data-view="resolved"]').toggle(state.isAdmin);
        $('.rep-nav-item[data-view="resolved"]').toggle(state.isAdmin);

        // If a non-admin already has an open report, force them straight
        // into its chat — they can only have one open report at a time.
        const openOwnReport = !state.isAdmin && state.reports.find(r => !r.resolved);
        const allowNew = !openOwnReport && (!state.isAdmin || data.allowSelfReport !== false);
        $('#rep-nav-new').toggle(allowNew);

        if (openOwnReport) {
            // Ask the server for the full detail (with messages).
            post('openDetail', { id: openOwnReport.id });
            // Render list in the meantime so the inbox is consistent.
            renderList();
            return;
        }

        switchView(data.openTo || (state.isAdmin ? 'inbox' : 'new'));
        renderList();
    }

    function close() {
        $('#reports-overlay').addClass('hidden');
        clearAttachment();
        post('close');
    }

    function setIsAdmin(v) { state.isAdmin = v; }

    /* ── View switching ──────────────────────────────────── */
    function switchView(view) {
        state.view = view;
        $('.reports-view').attr('hidden', true);
        $(`.reports-view[data-view="${view}"]`).removeAttr('hidden');
        $('.rep-nav-item').removeClass('active');
        $(`.rep-nav-item[data-view="${view}"]`).addClass('active');
    }

    /* ── List rendering ──────────────────────────────────── */
    function updateList(reports) {
        state.reports = reports;
        renderList();
        renderResolved();
        updateNavCount();

        // Refresh chat detail header if the current report changed.
        if (state.current) {
            const updated = reports.find(r => r.id === state.current.id);
            if (updated) {
                state.current = updated;
                renderDetailHeader(updated);
            }
        }
    }

    function updateNavCount() {
        const active = state.reports.filter(r => !r.resolved).length;
        $('#rep-nav-count').text(active);
        $('#inbox-subtitle').text(
            active === 0 ? 'No pending reports' :
            `${active} pending report${active === 1 ? '' : 's'} need your attention`
        );
    }

    function renderList() {
        const $list = $('#reports-list').empty();
        let rows = state.reports.filter(r => !r.resolved);
        if (state.filter !== 'all') rows = rows.filter(r => r.category === state.filter);

        if (rows.length === 0) {
            $list.append(`
                <div class="rep-empty">
                    <i class="fa-solid fa-circle-check"></i>
                    No open reports right now. Good job!
                </div>
            `);
            return;
        }

        rows.sort((a, b) => b.id - a.id);
        rows.forEach(r => $list.append(buildRow(r, false)));
    }

    function renderResolved() {
        const $list = $('#resolved-list').empty();
        const rows = state.reports.filter(r => r.resolved).sort((a, b) => b.id - a.id);

        if (rows.length === 0) {
            $list.append(`
                <div class="rep-empty">
                    <i class="fa-regular fa-folder-open"></i>
                    No resolved reports yet.
                </div>
            `);
            return;
        }
        rows.forEach(r => $list.append(buildRow(r, true)));
    }

    function buildRow(r, resolved) {
        const cat = r.category || 'question';
        const status = statusClass(r);
        const subject = $('<span class="rep-row-subject"></span>').text(r.subject || '(no subject)');
        const sender = $('<span></span>').text(r.playerName || ('ID ' + (r.playerId || '?')));

        const $row = $(`
            <div class="report-row" data-id="${r.id}">
                <span class="rep-row-id">#${r.id}</span>
                <div class="rep-row-main">
                    <div class="rep-row-meta">
                        <span class="rep-cat-badge ${cat}">${categoryLabel(cat)}</span>
                        <span class="rep-status ${status}">${statusLabel(r)}</span>
                    </div>
                </div>
                <div class="rep-row-actions">
                    <button class="modal-btn ghost rep-open">
                        <i class="fa-solid fa-${resolved ? 'eye' : 'comments'}"></i>
                        ${resolved ? 'View' : 'Open'}
                    </button>
                </div>
            </div>
        `);
        const $main = $row.find('.rep-row-main');
        $main.prepend(subject);
        $main.find('.rep-row-meta').append(' · ', sender);

        $row.on('click', () => post('openDetail', { id: r.id }));
        return $row;
    }

    /* ── Detail view ─────────────────────────────────────── */
    function openDetail(report, messages) {
        state.current = report;
        renderDetailHeader(report);
        $('#chat-stream').empty();
        messages.forEach(pushMessage);
        switchView('detail');
        scrollToBottom();
    }

    function renderDetailHeader(r) {
        $('#rep-detail-title').text('Report #' + r.id);
        const cat = r.category || 'question';
        $('#rep-detail-cat')
            .text(categoryLabel(cat))
            .attr('class', 'rep-cat-badge ' + cat);
        $('#rep-detail-status')
            .text(statusLabel(r))
            .attr('class', 'rep-status ' + statusClass(r));

        $('#rep-detail-sub')
            .empty()
            .append($('<span></span>').text('From ' + (r.playerName || '—')))
            .append(' · ')
            .append($('<span></span>').text('ID ' + (r.playerId || '?')))
            .append(r.identifier ? ' · ' + r.identifier : '');

        const canResolve = state.isAdmin && !r.resolved;
        $('#rep-detail-assist').toggle(canResolve);
        $('#rep-detail-resolve').toggle(canResolve);
        $('#rep-detail-tp').toggle(state.isAdmin);
        $('#rep-detail-bring').toggle(state.isAdmin);
    }

    function pushMessage(msg) {
        if (!msg) return;
        const $stream = $('#chat-stream');
        const isMe = !!msg.self;
        const isSystem = msg.system === true;

        let kind = 'chat-msg';
        if (isSystem)   kind += ' system';
        else if (isMe)  kind += ' me';
        else if (msg.staff) kind += ' staff';

        const $msg = $('<div></div>').attr('class', kind);

        if (!isSystem) {
            const time = msg.time
                ? new Date(msg.time * 1000).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
                : '';
            const $meta = $('<div class="chat-meta"></div>')
                .append($('<i></i>').attr('class', msg.staff ? 'fa-solid fa-shield-halved' : 'fa-solid fa-user'))
                .append($('<span></span>').text(msg.author || (msg.staff ? 'Staff' : 'Player')))
                .append(time ? ' · ' + time : '');
            $msg.append($meta);
        }

        if (msg.text) {
            $msg.append($('<div></div>').text(msg.text));
        }
        if (msg.image) {
            const $img = $('<img class="chat-msg-img">')
                .attr('src', msg.image)
                .attr('alt', 'screenshot')
                .on('error', function () {
                    $(this).replaceWith(
                        '<div class="chat-msg-imgerr">' +
                        '<i class="fa-solid fa-image"></i> ' +
                        'Failed to render screenshot (data length: ' +
                        (msg.image ? msg.image.length : 0) + ')' +
                        '</div>'
                    );
                })
                .on('click', function () {
                    // Open in a new tab/window via blob so huge data URIs
                    // don't choke the address bar.
                    try {
                        const w = window.open();
                        if (w) w.document.write(
                            '<img style="max-width:100%;display:block;margin:auto;" src="' +
                            msg.image + '">'
                        );
                    } catch (e) {}
                });
            $msg.append($img);
        }

        $stream.append($msg);
        scrollToBottom();
    }

    function scrollToBottom() {
        const stream = document.getElementById('chat-stream');
        if (stream) stream.scrollTop = stream.scrollHeight;
    }

    /* ── Attachments ─────────────────────────────────────── */
    function setAttachment(url, name) {
        state.attachment = url;
        $('#chat-attach-name').text(name || 'screenshot.png');
        $('#chat-attach-preview').removeClass('hidden');
    }

    function clearAttachment() {
        state.attachment = null;
        $('#chat-attach-preview').addClass('hidden');
    }

    function sendMessage() {
        const text = $('#chat-input').val().trim();
        if (!text && !state.attachment) return;
        if (!state.current) return;

        post('sendMessage', {
            id: state.current.id,
            text: text,
            image: state.attachment
        });
        $('#chat-input').val('');
        clearAttachment();
    }

    /* ── Wire up listeners (idempotent at load) ──────────── */
    $(function () {
        // Sidebar nav.
        $(document).on('click', '.rep-nav-item', function () {
            const view = $(this).data('view');
            if (view === 'new')      switchView('new');
            else if (view === 'inbox')    switchView('inbox');
            else if (view === 'resolved') switchView('resolved');
        });

        // Filter pills.
        $(document).on('click', '.hf-pill', function () {
            $('.hf-pill').removeClass('active');
            $(this).addClass('active');
            state.filter = $(this).data('filter');
            renderList();
        });

        // Close + back.
        $('#reports-close').on('click', close);
        $('#rep-detail-back').on('click', () => {
            state.current = null;
            switchView(state.isAdmin ? 'inbox' : 'new');
        });

        // Submit new report.
        const $subject = $('#rep-subject'), $details = $('#rep-details'), $submit = $('#rep-form-submit');
        function refreshSubmit() {
            const ok = $subject.val().trim() && $details.val().trim();
            $submit.prop('disabled', !ok);
        }
        $subject.on('input', refreshSubmit);
        $details.on('input', refreshSubmit);

        $('#rep-form-cancel').on('click', close);
        $submit.on('click', function () {
            if ($(this).is(':disabled')) return;
            post('submit', {
                category: $('input[name="rep-cat"]:checked').val(),
                subject:  $subject.val().trim(),
                details:  $details.val().trim()
            });
            $subject.val(''); $details.val(''); refreshSubmit();
        });

        // Admin actions.
        $('#rep-detail-assist').on('click', () => state.current && post('assist',  { id: state.current.id }));
        $('#rep-detail-resolve').on('click', () => state.current && post('resolve', { id: state.current.id }));
        $('#rep-detail-tp').on('click',      () => state.current && post('teleport', { id: state.current.id }));
        $('#rep-detail-bring').on('click',   () => state.current && post('bring',   { id: state.current.id }));

        // Staff mode toggle.
        $('#staff-mode-toggle').on('change', function () {
            post('staffMode', { enabled: $(this).is(':checked') });
        });

        // Chat input.
        $('#chat-send').on('click', sendMessage);
        $('#chat-input').on('keydown', function (e) {
            if (e.key === 'Enter') { e.preventDefault(); sendMessage(); }
        });
        $('#chat-screenshot').on('click', () => state.current && post('screenshot', { id: state.current.id }));
        $('#chat-attach-clear').on('click', clearAttachment);

        // ESC closes overlay.
        $(document).on('keyup', function (e) {
            if (e.key === 'Escape' && !$('#reports-overlay').hasClass('hidden')) close();
        });
    });

    /* ── Screenshot composer hooks ───────────────────────── */
    function beforeShot() {
        // Hide the entire overlay so the capture is clean.
        $('#reports-overlay').addClass('hidden');
    }
    function afterShot() {
        // Nothing to do here yet; the Lua side re-opens via `reopen`.
    }
    function reopen() {
        // Restore the overlay on whichever view we were on. If a report
        // is current, switch back into its chat; otherwise show the
        // default landing view.
        $('#reports-overlay').removeClass('hidden');
        if (state.current) {
            switchView('detail');
        } else {
            switchView(state.isAdmin ? 'inbox' : 'new');
        }
    }

    /* ── HUD position mode (admin only) ──────────────────── */
    let savedHudVisible = false;

    function enterPositionMode() {
        if (!state.isAdmin) return;
        savedHudVisible = !$('#staff-hud').hasClass('hidden');

        // Tell Lua first so the cursor focus is held throughout.
        post('positionMode', { enabled: true });

        // Hide overlay so the HUD is visible & draggable.
        $('#reports-overlay').addClass('hidden');

        // Make sure the HUD is hidden BEFORE we re-show it. Removing
        // any inline styles first guarantees we start from a clean,
        // CSS-default position (the same place a Reset would put it),
        // so admins can't be stuck with a stale off-screen offset.
        $('#staff-hud').addClass('hidden').attr('style', '');

        // Show HUD (with placeholder content if empty) + edit affordance.
        if (typeof StaffHud !== 'undefined') StaffHud.forceShow();
        $('#staff-hud').addClass('positioning');
        $('#hud-position-bar').removeClass('hidden');

        // ESC finishes the positioning session.
        $(document).on('keyup.hudPos', function (e) {
            if (e.key === 'Escape') exitPositionMode();
        });
    }

    function exitPositionMode() {
        $(document).off('keyup.hudPos');
        $('#hud-position-bar').addClass('hidden');
        $('#staff-hud').removeClass('positioning');
        // Restore HUD visibility to whatever it was before.
        if (!savedHudVisible && typeof StaffHud !== 'undefined') StaffHud.hide();
        // Re-open the Reports overlay where we left off.
        $('#reports-overlay').removeClass('hidden');

        post('positionMode', { enabled: false });
    }

    // Wire the buttons once DOM is ready.
    $(function () {
        $('#hud-position-btn').on('click', enterPositionMode);
        $('#hud-position-done').on('click', exitPositionMode);
        $('#hud-position-reset').on('click', function () {
            if (typeof StaffHud !== 'undefined') StaffHud.reset();
        });
    });

    return { open, close, updateList, openDetail, pushMessage, setIsAdmin, setAttachment, beforeShot, afterShot, reopen, enterPositionMode, exitPositionMode };
})();

/* ============================================================
   DRAGGABLE — simple, percent-based draggable helper.
   Persists position as % of viewport so it survives resolution
   changes. Clears all default CSS anchors when active.
   ============================================================ */
function makeDraggable(elSelector, handleSelector, storageKey) {
    const $el = $(elSelector);
    const $handle = $(handleSelector);
    if (!$el.length || !$handle.length) return;

    function loadSaved() {
        try {
            const raw = localStorage.getItem(storageKey);
            if (!raw) return null;
            const o = JSON.parse(raw);
            // Migrate / drop legacy formats (left/top in pixels). Only
            // accept the new percent-based shape.
            if (typeof o.xPct !== 'number' || typeof o.yPct !== 'number') {
                localStorage.removeItem(storageKey);
                return null;
            }
            // Defend against junk (NaN / Infinity / way out of bounds).
            if (!isFinite(o.xPct) || !isFinite(o.yPct)
                || o.xPct < -0.5 || o.xPct > 1.5
                || o.yPct < -0.5 || o.yPct > 1.5) {
                localStorage.removeItem(storageKey);
                return null;
            }
            return o;
        } catch (e) {
            try { localStorage.removeItem(storageKey); } catch (_) {}
            return null;
        }
    }

    function save(xPct, yPct) {
        try { localStorage.setItem(storageKey, JSON.stringify({ xPct, yPct })); } catch (e) {}
    }

    function reset() {
        try { localStorage.removeItem(storageKey); } catch (e) {}
        $el.attr('style', function (_, s) {
            return (s || '')
                .replace(/(^|;)\s*(left|top|right|bottom|transform|margin)\s*:[^;]+;?/g, '')
                .trim();
        });
        // After a reset we want the CSS-default anchoring back.
        $el.css({ left: '', top: '', right: '', bottom: '', transform: '' });
    }

    function applyFromSaved() {
        const saved = loadSaved();
        if (!saved) {
            // No save → leave the CSS default anchors alone.
            $el.css({ left: '', top: '', right: '', bottom: '', transform: '' });
            return;
        }
        const vw = window.innerWidth, vh = window.innerHeight;
        const w  = $el.outerWidth(), h = $el.outerHeight();
        // Clamp inside the viewport based on current size.
        const maxLeft = Math.max(4, vw - w - 4);
        const maxTop  = Math.max(4, vh - h - 4);
        const left = Math.max(4, Math.min(maxLeft, saved.xPct * vw));
        const top  = Math.max(4, Math.min(maxTop,  saved.yPct * vh));
        $el.css({
            left: left + 'px',
            top:  top  + 'px',
            right: 'auto',
            bottom: 'auto',
            transform: 'none'
        });
    }

    // Called by the host when the element becomes visible.
    function pinCurrent() {
        applyFromSaved();
    }

    let dragging = false;
    let startMX = 0, startMY = 0, startL = 0, startT = 0;

    $handle.on('mousedown', function (e) {
        if ($(e.target).closest('button, a').length) return;
        e.preventDefault();
        const rect = $el[0].getBoundingClientRect();
        // Pin to current visual position so the first frame doesn't jump.
        $el.css({
            left: rect.left + 'px',
            top:  rect.top  + 'px',
            right: 'auto',
            bottom: 'auto',
            transform: 'none'
        });
        startL = rect.left;
        startT = rect.top;
        startMX = e.clientX;
        startMY = e.clientY;
        dragging = true;
        $el.addClass('dragging');
    });

    $(document).on('mousemove.draggable_' + storageKey, function (e) {
        if (!dragging) return;
        const vw = window.innerWidth, vh = window.innerHeight;
        const w  = $el.outerWidth(), h = $el.outerHeight();
        const maxLeft = Math.max(4, vw - w - 4);
        const maxTop  = Math.max(4, vh - h - 4);
        const left = Math.max(4, Math.min(maxLeft, startL + (e.clientX - startMX)));
        const top  = Math.max(4, Math.min(maxTop,  startT + (e.clientY - startMY)));
        $el.css({ left: left + 'px', top: top + 'px' });
    });

    $(document).on('mouseup.draggable_' + storageKey, function () {
        if (!dragging) return;
        dragging = false;
        $el.removeClass('dragging');
        const rect = $el[0].getBoundingClientRect();
        save(rect.left / window.innerWidth, rect.top / window.innerHeight);
    });

    return { reset, pinCurrent };
}

/* ============================================================
   STAFF HUD
   ============================================================ */
const StaffHud = (function () {
    function render(reports, current) {
        $('#staff-hud-count').text(reports.length);
        const $list = $('#staff-hud-list').empty();

        if (reports.length === 0) {
            $list.append('<div class="staff-hud-empty">No active reports</div>');
            return;
        }

        reports.forEach(r => {
            const cat = r.category || 'question';
            const status = r.assistedBy ? 'assisting' : '';
            const isCurrent = current && r.id === current;
            const $item = $('<div class="staff-hud-item"></div>')
                .toggleClass('current', !!isCurrent)
                .append(
                    $('<div class="sh-row"></div>')
                        .append($('<span class="sh-id"></span>').text('#' + r.id))
                        .append($('<span class="rep-cat-badge"></span>').addClass(cat).text(catShort(cat)))
                )
                .append(
                    $('<div class="sh-row"></div>')
                        .append($('<span class="sh-subject"></span>').text(r.subject || '(no subject)'))
                        .append($('<span class="rep-status"></span>').addClass(status).text(status === 'assisting' ? 'You' : 'Wait'))
                );
            $list.append($item);
        });
    }

    function catShort(c) {
        if (c === 'player_report') return 'PLAYER';
        if (c === 'question')      return 'Q';
        if (c === 'bug')           return 'BUG';
        return '·';
    }

    // Wire up drag + reset once the DOM is ready.
    let dragApi = null;
    $(function () {
        dragApi = makeDraggable('#staff-hud', '#staff-hud-handle', 'apex.hud.staffPos');
        $('#staff-hud-reset').on('click', function (e) {
            e.stopPropagation();
            if (dragApi) dragApi.reset();
        });
    });

    function showAndPin(reports, current) {
        $('#staff-hud').removeClass('hidden');
        render(reports, current);
        // Wait one frame so the element is laid out with its final
        // size before we lock its position — getBoundingClientRect()
        // returns zeros otherwise.
        requestAnimationFrame(() => {
            if (dragApi) dragApi.pinCurrent();
        });
    }

    return {
        show:   (reports, current) => showAndPin(reports, current),
        update: (reports, current) => render(reports, current),
        hide:   () => $('#staff-hud').addClass('hidden'),
        // Force-show with placeholder content so the admin can position
        // the HUD even when no reports are pending.
        forceShow: () => showAndPin([], null),
        reset: () => dragApi && dragApi.reset()
    };
})();

// ─────────────────────────────────────────────────────────────
// Announce slide overlay
// ─────────────────────────────────────────────────────────────
// Server-driven slide-in card pushed by /announce from the admin
// panel. Pure DOM (no jQuery) so it works even before the rest of
// the quickmenu UI is mounted. Each card auto-dismisses after the
// configured duration, with a progress bar showing time remaining.
(function () {
    const TYPE_META = {
        info:    { icon: 'fa-circle-info',          color: '#4E9CE5' },
        success: { icon: 'fa-circle-check',         color: '#34C77B' },
        warning: { icon: 'fa-triangle-exclamation', color: '#E5A93C' },
        error:   { icon: 'fa-circle-exclamation',   color: '#E5564B' }
    };

    function show(opts) {
        const root = document.getElementById('ann-root');
        if (!root) return;
        const pos = opts.position || 'top-center';
        const meta = TYPE_META[opts.type] || TYPE_META.info;
        const duration = Math.max(2, Math.min(60, Number(opts.duration) || 8));

        // Make sure we have a zone container for this position.
        let zone = root.querySelector('.ann-zone[data-pos="' + pos + '"]');
        if (!zone) {
            zone = document.createElement('div');
            zone.className = 'ann-zone';
            zone.dataset.pos = pos;
            root.appendChild(zone);
        }

        // Build the card.
        const card = document.createElement('div');
        card.className = 'ann-card ann-' + (opts.type || 'info');
        card.style.setProperty('--ann-color', meta.color);
        card.innerHTML =
            '<div class="ann-icon"><i class="fa-solid ' + meta.icon + '"></i></div>' +
            '<div class="ann-body">' +
                (opts.title ? '<div class="ann-title">' + escapeText(opts.title) + '</div>' : '') +
                '<div class="ann-msg">' + escapeText(opts.message || '') + '</div>' +
            '</div>' +
            '<button class="ann-close" type="button" aria-label="Dismiss">×</button>' +
            '<div class="ann-progress"><span style="animation-duration:' + duration + 's"></span></div>';

        // From-direction depends on the position so the entry animation feels right.
        const fromDir =
            pos.startsWith('top')    ? 'from-top'   :
            pos.startsWith('bottom') ? 'from-bottom':
            pos.endsWith('-left')    ? 'from-left'  :
            pos.endsWith('-right')   ? 'from-right' :
            'from-top';
        card.classList.add(fromDir);
        zone.appendChild(card);

        // Trigger entry transition next frame.
        requestAnimationFrame(() => card.classList.add('in'));

        let dismissed = false;
        const dismiss = () => {
            if (dismissed) return;
            dismissed = true;
            card.classList.remove('in');
            card.classList.add('out');
            setTimeout(() => {
                card.remove();
                if (zone && !zone.children.length) zone.remove();
            }, 280);
        };
        card.querySelector('.ann-close').addEventListener('click', dismiss);
        setTimeout(dismiss, duration * 1000);
    }

    function escapeText(s) {
        return String(s).replace(/[&<>"']/g, c => ({
            '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'
        }[c]));
    }

    // Listen for the client → NUI message dispatched by adminpanel.lua.
    window.addEventListener('message', (e) => {
        const d = e.data || {};
        if (d.action === 'announce:show') {
            show(d);
        }
    });
})();

/* ============================================================
   MOVABLE MENU
   ------------------------------------------------------------
   Lets staff alternate between "cursor mode" (interact with the
   menu) and "movement mode" (walk/look while the menu stays
   visible). In cursor mode the NUI has focus, so JS catches the
   toggle key and asks Lua to switch into movement mode. Coming
   back the other way is handled Lua-side (the NUI has no focus
   in movement mode). A small on-screen hint shows the current
   mode and the key to press.
   ============================================================ */
const MoveMenu = (function () {
    const state = { mode: 'off', code: 'AltLeft', label: 'Alt', lastToggle: 0 };

    function ensureHint() {
        let el = document.getElementById('apex-move-hint');
        if (!el) {
            el = document.createElement('div');
            el.id = 'apex-move-hint';
            // No backdrop-filter and no dark plate behind the hint: it sits
            // directly on the game world. Legibility comes from a text
            // shadow instead, which costs nothing to render (backdrop
            // blur forces CEF to re-composite the whole area every frame).
            el.style.cssText =
                'position:fixed;bottom:18px;left:50%;transform:translateX(-50%);' +
                'z-index:2200;display:none;align-items:center;gap:8px;' +
                'padding:6px 4px;font-family:Inter,system-ui,sans-serif;' +
                'font-size:13px;font-weight:600;color:#f4f4f5;letter-spacing:.2px;' +
                'background:transparent;border:0;' +
                'text-shadow:0 1px 3px rgba(0,0,0,.9), 0 0 10px rgba(0,0,0,.7);' +
                'pointer-events:none;';
            document.body.appendChild(el);
        }
        return el;
    }

    function kbd(text) {
        return '<span style="display:inline-block;padding:1px 7px;margin:0 2px;border-radius:6px;' +
            'background:rgba(255,255,255,.14);border:1px solid rgba(255,255,255,.22);' +
            'font-size:12px;">' + esc(text) + '</span>';
    }

    function esc(s) {
        return String(s).replace(/[&<>"']/g, c => ({
            '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
        }[c]));
    }

    function onHint(data) {
        state.mode = data.mode || 'off';
        state.lastToggle = Date.now();
        if (data.code)  state.code  = data.code;
        if (data.label) state.label = data.label;

        // Coming back from movement mode, Lua re-enables NUI focus but CEF
        // again leaves no element focused — without this the toggle would
        // work exactly once and then need a click to work again.
        if (state.mode === 'cursor' && typeof claimKeyboardFocus === 'function') {
            claimKeyboardFocus();
        }

        const el = ensureHint();
        if (state.mode === 'off') {
            el.style.display = 'none';
            return;
        }

        el.style.display = 'flex';
        // The hint has no plate/border any more, so the mode colour lives
        // on the icon instead.
        if (state.mode === 'move') {
            el.innerHTML =
                '<i class="fa-solid fa-person-walking" style="color:#34c77b"></i>' +
                '<span>Movement mode · ' + kbd(state.label) + 'cursor · ' + kbd('Esc') + 'close</span>';
        } else {
            el.innerHTML =
                '<i class="fa-solid fa-arrow-pointer" style="color:#4e9ce5"></i>' +
                '<span>Cursor mode · ' + kbd(state.label) + 'to move around</span>';
        }
    }

    // Catch the toggle key while in cursor mode and ask Lua to switch.
    document.addEventListener('keydown', function (e) {
        if (!isMenuOpen || state.mode !== 'cursor') return;
        if (e.code !== state.code) return;
        if (e.repeat) return;                       // ignore held-key auto-repeat
        if (Date.now() - state.lastToggle < 350) return; // debounce rapid flips

        // Ignore while typing in a dialog field.
        const ae = document.activeElement;
        if (ae && (ae.tagName === 'INPUT' || ae.tagName === 'TEXTAREA' || ae.tagName === 'SELECT')) return;

        e.preventDefault();
        state.lastToggle = Date.now();
        $.post('https://apex_adminmenu/setMoveMode', JSON.stringify({ enabled: true }));
    });

    return { onHint };
})();

