/* ============================================================
   Apex Restaurant — UI controller + Node Editor
   Vanilla JS, no frameworks. Handles:
     • Apex.lib NUI (notify, menu, input, alert, progress, stash)
     • In-world target wheel & textui
     • Blueprint-style node editor with bezier connections,
       drag/pan/zoom, inspector & live preview
   ============================================================ */
(function () {
'use strict';

// ─── Tiny helpers ──────────────────────────────────────────
const $   = (sel, root = document) => root.querySelector(sel);
const $$  = (sel, root = document) => Array.from(root.querySelectorAll(sel));
const h   = (tag, attrs = {}, ...children) => {
    const el = document.createElement(tag);
    for (const k in attrs) {
        if (k === 'class') el.className = attrs[k];
        else if (k === 'dataset') Object.assign(el.dataset, attrs[k]);
        else if (k.startsWith('on') && typeof attrs[k] === 'function') el.addEventListener(k.slice(2).toLowerCase(), attrs[k]);
        else if (attrs[k] === false || attrs[k] == null) continue;
        else if (attrs[k] === true) el.setAttribute(k, '');
        else el.setAttribute(k, attrs[k]);
    }
    for (const c of children.flat(Infinity)) {
        if (c == null || c === false) continue;
        el.append(c instanceof Node ? c : document.createTextNode(c));
    }
    return el;
};
const post = (name, payload = {}) => fetch(`https://${GetParentResourceName()}/${name}`, {
    method: 'POST', headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
}).then(r => r.json().catch(() => ({})));

function GetParentResourceName() { return window.GetParentResourceName ? window.GetParentResourceName() : 'apex_restaurant'; }

// Promote every native `title` on an ICON-ONLY button into our themed
// floating tooltip. Buttons that already display text keep their text
// (no tooltip needed). The tooltip is a single global element
// positioned via JS so it stays inside the viewport even when the
// hovered button is at the screen edge.
(function () {
    const tip = document.createElement('div');
    tip.className = 'apex-tooltip';
    tip.hidden = true;
    document.addEventListener('DOMContentLoaded', () => document.body.appendChild(tip));

    const isIconOnly = (el) => {
        // True if the button shows no visible text (only icons / images).
        const text = (el.textContent || '').replace(/\s+/g, '').trim();
        return text.length === 0;
    };

    const tagOnce = (el) => {
        if (!el || el.dataset.tip != null || !el.getAttribute) return;
        const t = el.getAttribute('title');
        if (!t || !t.trim()) return;
        if (!isIconOnly(el)) {
            // Has visible text — strip title so the native bubble
            // doesn't appear, but DON'T add a tooltip.
            el.removeAttribute('title');
            return;
        }
        el.dataset.tip = t;
        el.removeAttribute('title');
    };
    const SELECTOR = 'button[title], .icon-btn[title], a[title]';
    const sweep = (root) => {
        if (!root || !root.querySelectorAll) return;
        if (root.matches && root.matches(SELECTOR)) tagOnce(root);
        root.querySelectorAll(SELECTOR).forEach(tagOnce);
    };
    document.addEventListener('DOMContentLoaded', () => sweep(document.body));
    new MutationObserver((muts) => {
        muts.forEach(m => m.addedNodes.forEach(n => { if (n.nodeType === 1) sweep(n); }));
    }).observe(document.documentElement, { childList: true, subtree: true });

    // ── Hover-to-show with viewport clamping ──────────
    const PAD = 6;
    function show(el) {
        const txt = el.dataset.tip;
        if (!txt) return;
        tip.textContent = txt;
        tip.hidden = false;
        // Force layout so we can measure
        tip.style.left = '0px';
        tip.style.top  = '0px';
        const tr = tip.getBoundingClientRect();
        const er = el.getBoundingClientRect();
        // Default: centred above the target
        let left = er.left + er.width / 2 - tr.width / 2;
        let top  = er.top - tr.height - 8;
        let pos  = 'top';
        // Flip below if no room above
        if (top < PAD) {
            top = er.bottom + 8;
            pos = 'bottom';
        }
        // Clamp horizontally to viewport
        const vw = window.innerWidth;
        if (left < PAD) left = PAD;
        if (left + tr.width > vw - PAD) left = vw - PAD - tr.width;
        tip.style.left = left + 'px';
        tip.style.top  = top  + 'px';
        tip.dataset.pos = pos;
        tip.classList.add('apex-tip-show');
    }
    function hide() {
        tip.classList.remove('apex-tip-show');
        // Delay hidden so the fade-out completes
        setTimeout(() => { if (!tip.classList.contains('apex-tip-show')) tip.hidden = true; }, 140);
    }
    document.addEventListener('mouseover', (e) => {
        const t = e.target.closest('[data-tip]');
        if (t) show(t);
    });
    document.addEventListener('mouseout', (e) => {
        const t = e.target.closest('[data-tip]');
        if (t) hide();
    });
    // Hide the tooltip the instant the user clicks anywhere — fixes
    // the "ghost tooltip" left behind when a button gets removed
    // mid-hover (e.g. the close X on the profile modal).
    document.addEventListener('mousedown', () => { hide(); }, true);

    // Belt + braces: any time the currently-tip-tagged element is
    // removed from the DOM, hide the tooltip too.
    new MutationObserver((muts) => {
        if (tip.hidden) return;
        muts.forEach(m => m.removedNodes.forEach(() => hide()));
    }).observe(document.body, { childList: true, subtree: true });
})();

// Reset every scrollable descendant of `root` back to the top.
// Called from each menu's open() so the user always sees content
// from the start rather than wherever the last session left off.
function resetScroll(root) {
    if (!root) return;
    root.scrollTop = 0;
    root.querySelectorAll('*').forEach(el => {
        if (el.scrollHeight > el.clientHeight) el.scrollTop = 0;
    });
}

// ─── Global UI config (pushed by Lua via `set_config`) ─────
window.ApexUI = window.ApexUI || {
    currency: { symbol: '$', position: 'before' },
    fmtMoney(n) {
        const raw = Math.round(Number(n) || 0);
        const v   = Math.abs(raw).toLocaleString();
        const sign = raw < 0 ? '-' : '';
        const cur = this.currency || { symbol: '$', position: 'before' };
        return cur.position === 'after'
            ? sign + v + ' ' + cur.symbol
            : sign + cur.symbol + v;
    },
    locale: {},
};

// ─── i18n: L(key, ...args) ─────────────────────────────────
// Localisation helper mirroring the Lua-side L(). Lua pushes
// the full locale table at bootstrap / editor_open / set_locale.
// Missing keys fall back to the key itself so the UI never
// silently breaks if a translator forgets one.
// Supports printf-style %s / %d / %.2f placeholders.
window.L = window.L || function L(key, ...args) {
    const tbl = (window.ApexUI && ApexUI.locale) || {};
    let s = tbl[key];
    if (s == null) s = key;
    if (!args.length) return s;
    let i = 0;
    return String(s).replace(/%(?:\.\d+)?[sdif%]/g, (m) => {
        if (m === '%%') return '%';
        const a = args[i++];
        if (m.endsWith('s')) return a == null ? '' : String(a);
        if (m.endsWith('d') || m.endsWith('i')) return String(Math.round(Number(a) || 0));
        if (m.endsWith('f')) {
            const decMatch = m.match(/\.(\d+)/);
            const dec = decMatch ? +decMatch[1] : 6;
            return (Number(a) || 0).toFixed(dec);
        }
        return String(a);
    });
};

// ─── Static-HTML localisation ──────────────────────────────
// Sweeps every element in index.html that carries a `data-i18n`
// (or `data-i18n-title` / `data-i18n-placeholder`) attribute and
// rewrites its text using the active locale. Called once at
// boot from set_config — and again on set_locale.
window.applyStaticLocale = function applyStaticLocale() {
    document.querySelectorAll('[data-i18n]').forEach(el => {
        const k = el.getAttribute('data-i18n');
        if (!k) return;
        const v = L(k);
        if (v != null) el.textContent = v;
    });
    document.querySelectorAll('[data-i18n-title]').forEach(el => {
        const k = el.getAttribute('data-i18n-title');
        if (k) el.setAttribute('title', L(k));
    });
    document.querySelectorAll('[data-i18n-placeholder]').forEach(el => {
        const k = el.getAttribute('data-i18n-placeholder');
        if (k) el.setAttribute('placeholder', L(k));
    });
    // <title> tag
    const tk = document.documentElement.getAttribute('data-i18n-doctitle');
    if (tk) document.title = L(tk);
};

// ════════════════════════════════════════════════════════════
// NOTIFICATIONS
// ════════════════════════════════════════════════════════════
const Notify = (() => {
    const container = $('#notify-container');
    const ICONS = { info:'circle-info', success:'circle-check', warning:'triangle-exclamation', error:'circle-xmark' };
    const TITLE_KEYS = { info:'ui.notify.title_info', success:'ui.notify.title_success', warning:'ui.notify.title_warning', error:'ui.notify.title_error' };

    // Built-in NUI toast renderer — used ONLY as the Lua-side fallback (the
    // 'notify' action) when ox_lib isn't running.
    function render({ message, title, type = 'info', duration = 5000, position = 'top-right' }) {
        container.className = `notify-container pos-${position}`;
        const card = h('div', { class: `notify-card ${type}` },
            h('div', { class: 'notify-header' },
                h('i', { class: `notify-icon fa-solid fa-${ICONS[type] || ICONS.info}` }),
                h('div', { class: 'notify-title' }, title || L(TITLE_KEYS[type] || 'ui.notify.title_info'))
            ),
            h('div', { class: 'notify-body' }, message),
            h('div', { class: 'notify-progress' }, h('div', { class: 'notify-progress-bar' }))
        );
        container.appendChild(card);
        const bar = card.querySelector('.notify-progress-bar');
        bar.style.transition = `transform ${duration}ms linear`;
        requestAnimationFrame(() => { bar.style.transform = 'scaleX(0)'; });
        setTimeout(() => { card.classList.add('exit'); setTimeout(() => card.remove(), 200); }, duration);
    }
    // Every in-menu notification goes through ox_lib (via the client), so the
    // whole resource shares one notification style.
    function show(opts) {
        opts = opts || {};
        post('apex_notify', { message: opts.message, type: opts.type || 'info', duration: opts.duration });
    }
    return { show, render };
})();

// ════════════════════════════════════════════════════════════
// 3D FLOATING WORLD ICON  (replaces the old side TextUI)
// ════════════════════════════════════════════════════════════
const WorldIcon = (() => {
    const host  = $('#world-icon');
    const i     = $('#world-icon-i');
    const lbl   = $('#world-icon-label');
    const circle= host.querySelector('.world-icon-circle');
    return {
        show({ x, y, scale, label, icon, key }) {
            // x/y are 0..1 screen-relative from World3dToScreen2d
            const sx = x * window.innerWidth;
            const sy = y * window.innerHeight;
            host.style.left = sx + 'px';
            host.style.top  = sy + 'px';
            host.style.transform = `translate(-50%, -50%) scale(${scale || 1})`;
            i.className   = `fa-solid fa-${icon || 'hand'}`;
            lbl.textContent = label || 'Interact';
            host.querySelector('.world-icon-key').textContent = key || 'E';
            host.hidden = false;
        },
        hide() { host.hidden = true; },
    };
})();

// ════════════════════════════════════════════════════════════
// TARGET WHEEL (on-screen)
// ════════════════════════════════════════════════════════════
const Target = (() => {
    const host = $('#target-host');
    const ring = $('#target-ring');
    let pendingOptions = [];

    function show({ id, options }) {
        pendingOptions = options || [];
        host.hidden = false;
    }
    function focus() {
        // Render an interactive radial menu on focus
        host.innerHTML = '';
        host.hidden = false;
        const wheel = h('div', { style: 'pointer-events:auto;background:rgba(11,13,22,.92);border:1px solid var(--brand-a25);border-radius:14px;padding:8px;display:flex;flex-direction:column;gap:4px;min-width:240px;box-shadow:0 0 0 1px var(--brand-a15),0 0 28px var(--brand-a35);' });
        pendingOptions.forEach((o) => {
            wheel.appendChild(h('button', {
                style: 'display:flex;align-items:center;gap:10px;padding:8px 12px;background:transparent;border-radius:7px;color:var(--text);font-size:12px;font-weight:600;text-align:left;transition:background 100ms;',
                onmouseenter: e => e.currentTarget.style.background = 'var(--brand-a08)',
                onmouseleave: e => e.currentTarget.style.background = 'transparent',
                onclick: () => { hide(); post('target_select', { idx: o.idx }); },
            },
                h('i', { class: `fa-solid fa-${o.icon || 'hand'}`, style: 'color:var(--brand-text);width:18px' }),
                o.label
            ));
        });
        host.appendChild(wheel);
    }
    function hide() {
        host.hidden = true;
        host.innerHTML = '<div id="target-ring" class="target-ring"></div>';
    }
    return { show, focus, hide };
})();

// ════════════════════════════════════════════════════════════
// MENU MODAL
// ════════════════════════════════════════════════════════════
const Menu = (() => {
    const overlay  = $('#menu-overlay');
    const titleEl  = $('#menu-title');
    const subEl    = $('#menu-subtitle');
    const list     = $('#menu-options');

    // Shared ingredient tooltip — fixed-positioned and appended to <body> so
    // the scrolling options list can never clip it. Shown on option hover.
    const ingTip = h('div', { class: 'opt-ings-tip', hidden: true });
    document.body.appendChild(ingTip);
    function showIngTip(optEl, ings) {
        ingTip.innerHTML = '';
        ingTip.appendChild(h('div', { class: 'opt-ings-title' }, 'Requires'));
        ings.forEach(ing => ingTip.appendChild(h('div', { class: 'opt-ing' },
            h('img', { src: ing.image || '', alt: '', onerror: "this.style.visibility='hidden'" }),
            h('span', { class: 'opt-ing-qty' }, (ing.qty || 1) + '×'),
            h('span', { class: 'opt-ing-label' }, ing.label || ing.name || '')
        )));
        ingTip.hidden = false;
        const r = optEl.getBoundingClientRect();
        const tw = ingTip.offsetWidth, th = ingTip.offsetHeight;
        let left = r.left - tw - 10;          // prefer the LEFT of the option
        if (left < 8) left = r.right + 10;    // no room → flip to the right
        let top = r.top;
        if (top + th > window.innerHeight - 8) top = window.innerHeight - th - 8;
        ingTip.style.left = Math.max(8, left) + 'px';
        ingTip.style.top  = Math.max(8, top) + 'px';
    }
    function hideIngTip() { ingTip.hidden = true; }

    function open({ title, subtitle, icon, options }) {
        titleEl.textContent = title || '';
        subEl.textContent   = subtitle || '';
        subEl.style.display = subtitle ? 'block' : 'none';
        hideIngTip();

        // Header icon (brand-tinted box, left of title)
        const headIcon = $('#menu-head-icon');
        if (icon) {
            $('#menu-head-icon-i').className = `fa-solid fa-${icon}`;
            headIcon.hidden = false;
        } else {
            headIcon.hidden = true;
        }

        list.innerHTML = '';
        (options || []).forEach((opt, idx) => {
            // Icon area: image takes precedence over FA icon
            const iconEl = h('div', { class: 'opt-icon' });
            if (opt.image) {
                iconEl.appendChild(h('img', { src: opt.image, alt: '', onerror: 'this.style.opacity=0.2' }));
            } else {
                iconEl.appendChild(h('i', { class: `fa-solid fa-${opt.icon || 'circle'}` }));
            }

            const optBtn = h('button', {
                class: 'menu-option' + (opt.disabled ? ' disabled' : ''),
                disabled: opt.disabled || false,
                onclick: () => {
                    if (opt.disabled) return;
                    close();
                    post('menu_select', { idx, value: opt.value, label: opt.label });
                },
            },
                iconEl,
                h('div', { class: 'opt-text' },
                    h('div', { class: 'opt-label' }, opt.label),
                    opt.description ? h('div', { class: 'opt-desc' }, opt.description) : null
                ),
                opt.meta ? h('div', { class: 'opt-meta' }, opt.meta) : null
            );
            // Hover → show the required ingredients with images.
            if (opt.ingredients && opt.ingredients.length) {
                optBtn.addEventListener('mouseenter', () => showIngTip(optBtn, opt.ingredients));
                optBtn.addEventListener('mouseleave', hideIngTip);
            }
            list.appendChild(optBtn);
        });
        overlay.hidden = false;
        resetScroll(overlay);
    }
    function close() { overlay.hidden = true; hideIngTip(); }
    overlay.addEventListener('click', e => {
        if (e.target === overlay || e.target.closest('[data-action="menu-close"]')) {
            close(); post('menu_close');
        }
    });
    document.addEventListener('keydown', e => {
        if (!overlay.hidden && e.key === 'Escape') { close(); post('menu_close'); }
    });
    return { open, close };
})();

// ════════════════════════════════════════════════════════════
// INPUT MODAL
// ════════════════════════════════════════════════════════════
const Input = (() => {
    const overlay = $('#input-overlay');
    const titleEl = $('#input-title');
    const fields  = $('#input-fields');
    let currentFields = [];

    function open({ title, fields: defs }) {
        titleEl.textContent = title || '';
        currentFields = defs || [];
        fields.innerHTML = '';
        currentFields.forEach((f, idx) => {
            const id = `inp-${idx}`;
            let control;
            if (f.type === 'select') {
                control = h('select', { id, class: 'apex-select' },
                    ...(f.options || []).map(o =>
                        h('option', { value: o.value, ...(o.value == f.value ? { selected: true } : {}) }, o.label)
                    )
                );
            } else if (f.type === 'checkbox') {
                control = h('input', { id, type: 'checkbox', class: 'apex-input', ...(f.value ? { checked: true } : {}) });
            } else if (f.type === 'color') {
                control = h('input', { id, type: 'color', class: 'apex-input', value: f.value || '#8d21e8' });
            } else if (f.type === 'number') {
                control = h('input', { id, type: 'number', class: 'apex-input', value: f.value ?? '' });
            } else {
                control = h('input', { id, type: 'text', class: 'apex-input', value: f.value ?? '' });
            }
            fields.appendChild(h('div', { class: 'field' },
                h('label', { class: 'field-label', for: id }, f.label || f.id),
                control
            ));
        });
        overlay.hidden = false;
        const first = fields.querySelector('input, select');
        if (first) setTimeout(() => first.focus(), 50);
    }
    function submit() {
        const values = {};
        currentFields.forEach((f, idx) => {
            const el = $(`#inp-${idx}`);
            values[f.id || idx] = f.type === 'checkbox' ? el.checked
                                : f.type === 'number'   ? Number(el.value)
                                : el.value;
        });
        overlay.hidden = true;
        post('input_submit', { values });
    }
    function cancel() { overlay.hidden = true; post('input_cancel'); }

    overlay.addEventListener('click', e => {
        if (e.target === overlay) cancel();
        if (e.target.closest('[data-action="input-cancel"]')) cancel();
        if (e.target.closest('[data-action="input-submit"]')) submit();
    });
    document.addEventListener('keydown', e => {
        if (overlay.hidden) return;
        if (e.key === 'Escape') cancel();
        if (e.key === 'Enter')  submit();
    });
    return { open };
})();

// ════════════════════════════════════════════════════════════
// ALERT
// ════════════════════════════════════════════════════════════
const Alert = (() => {
    const overlay = $('#alert-overlay');
    function open({ title, content, type }) {
        $('#alert-title').textContent = title || 'Confirm';
        $('#alert-content').textContent = content || '';
        overlay.hidden = false;
    }
    overlay.addEventListener('click', e => {
        if (e.target.closest('[data-action="alert-yes"]')) { overlay.hidden = true; post('alert_answer', { confirm: true  }); }
        if (e.target.closest('[data-action="alert-no"]'))  { overlay.hidden = true; post('alert_answer', { confirm: false }); }
        if (e.target === overlay) { overlay.hidden = true; post('alert_answer', { confirm: false }); }
    });
    return { open };
})();

// ════════════════════════════════════════════════════════════
// PROGRESS
// ════════════════════════════════════════════════════════════
const Progress = (() => {
    const host = $('#progress-host');
    const lbl  = $('#progress-label');
    const fill = $('#progress-fill');
    return {
        show({ label, duration }) {
            lbl.textContent = label || 'Working…';
            // Reset to 0% with no transition (otherwise the previous
            // "width 100%" sticks and the new fill never animates).
            fill.style.transition = 'none';
            fill.style.width      = '0%';
            host.hidden = false;
            // Force a layout reflow so the browser commits the 0% state
            // BEFORE we apply the new transition. Without this both style
            // writes batch into one frame and the bar jumps straight to
            // 100% (which is what made it look out-of-sync with the
            // actual script duration).
            // eslint-disable-next-line no-unused-expressions
            void fill.offsetWidth;
            requestAnimationFrame(() => {
                fill.style.transition = `width ${duration}ms linear`;
                fill.style.width      = '100%';
            });
        },
        hide() { host.hidden = true; },
    };
})();

// ════════════════════════════════════════════════════════════
// INVENTORY (stash modal)
//   • Player LEFT, container RIGHT
//   • 25 slots per side (5x5 grid)
//   • Drag-and-drop transfer (custom — HTML5 DnD unreliable in CEF)
//   • Ghost item follows cursor while dragging
//   • Hover tooltip, right-click quantity prompt, shift-click instant
// ════════════════════════════════════════════════════════════
const Stash = (() => {
    const overlay  = $('#stash-overlay');
    const sideName = $('#stash-side-name');
    const playerSlots = $('#player-slots');
    const stashSlots  = $('#stash-slots');
    const playerMeta  = $('#player-meta');
    const stashMeta   = $('#stash-meta');

    const ghost     = $('#inv-ghost');
    const ghostImg  = $('#inv-ghost-img');
    const ghostLbl  = $('#inv-ghost-label');
    const ghostCnt  = $('#inv-ghost-count');

    const tooltip   = $('#inv-tooltip');
    const tipLabel  = $('#inv-tooltip-label');
    const tipCount  = $('#inv-tooltip-count');
    const tipKey    = $('#inv-tooltip-key');

    const qtyOverlay = $('#inv-qty');
    const qtyInput   = $('#inv-qty-input');
    const qtyTitle   = $('#inv-qty-title');

    const SLOTS_PER_SIDE = 30;       // can hold up to 30 (6 rows of 5)

    let state = {
        stashId: null,
        stashName: '',
        player: [],
        stash:  [],
        slots:  { player: 30, stash: 30 },
    };
    let drag = null;        // { item, fromSide, fromIndex }
    let qtyResolve = null;  // promise resolver for quantity dialog

    // ─── Render helpers ───────────────────────────────────
    function renderSide(side, items, root) {
        root.innerHTML = '';
        const max = state.slots[side] || SLOTS_PER_SIDE;
        for (let i = 0; i < max; i++) {
            const item = items[i];
            const slot = h('div', {
                class: 'inv-slot ' + (item ? 'filled' : 'empty'),
                dataset: { side, index: String(i) },
            });
            if (item) {
                const itemEl = h('div', {
                    class: 'inv-item',
                    onmousedown: e => beginDrag(e, item, side, i, itemEl),
                    onmouseenter: e => showTooltip(item, e),
                    onmouseleave: () => hideTooltip(),
                    onmousemove:  e => positionTooltip(e),
                    oncontextmenu: e => {
                        e.preventDefault();
                        const otherSide = side === 'player' ? 'stash' : 'player';
                        askQuantity(item, otherSide);
                    },
                    onclick: async e => {
                        const other = side === 'player' ? 'stash' : 'player';
                        if (e.shiftKey) {
                            // Shift-click → instant full-stack transfer (express)
                            await doTransfer(item, side, other, item.count);
                        } else {
                            // Default click → quantity prompt
                            askQuantity(item, other);
                        }
                    },
                },
                    h('img', { src: item.image || '', alt: item.label, draggable: 'false', onerror: 'this.style.opacity=0.25' }),
                    h('span', { class: 'inv-item-count' }, '×' + item.count),
                );
                slot.appendChild(itemEl);
            }
            root.appendChild(slot);
        }
    }

    function renderAll() {
        renderSide('player', state.player, playerSlots);
        renderSide('stash',  state.stash,  stashSlots);
        if (sideName) sideName.textContent = state.stashName || 'Storage';
        const used = (arr) => arr.filter(Boolean).length;
        playerMeta.textContent = `${used(state.player)}/${state.slots.player}`;
        stashMeta.textContent  = `${used(state.stash)}/${state.slots.stash}`;
    }

    // ─── Drag & drop ──────────────────────────────────────
    function beginDrag(e, item, fromSide, fromIndex, sourceEl) {
        if (e.button !== 0) return;        // left button only
        e.preventDefault();
        drag = { item, fromSide, fromIndex, sourceEl };
        sourceEl.classList.add('dragging');
        hideTooltip();

        ghostImg.src = item.image || '';
        ghostLbl.textContent = item.label;
        ghostCnt.textContent = '×' + item.count;
        ghost.style.left = e.clientX + 'px';
        ghost.style.top  = e.clientY + 'px';
        ghost.hidden = false;

        function move(ev) {
            ghost.style.left = ev.clientX + 'px';
            ghost.style.top  = ev.clientY + 'px';
            highlightDropTarget(ev);
        }
        function up(ev) {
            document.removeEventListener('mousemove', move);
            document.removeEventListener('mouseup', up);
            const target = document.elementFromPoint(ev.clientX, ev.clientY);
            const slot   = target && target.closest('.inv-slot');
            const otherSide = drag.fromSide === 'player' ? 'stash' : 'player';
            clearDropHighlights();
            ghost.hidden = true;
            sourceEl.classList.remove('dragging');

            if (slot && slot.dataset.side !== drag.fromSide) {
                // Drop on the OTHER side → transfer
                doTransfer(drag.item, drag.fromSide, otherSide, drag.item.count);
            }
            drag = null;
        }
        document.addEventListener('mousemove', move);
        document.addEventListener('mouseup', up);
    }

    function highlightDropTarget(ev) {
        clearDropHighlights();
        if (!drag) return;
        const t = document.elementFromPoint(ev.clientX, ev.clientY);
        const slot = t && t.closest('.inv-slot');
        if (!slot) return;
        const valid = slot.dataset.side !== drag.fromSide;
        slot.classList.add(valid ? 'drop-target' : 'drop-invalid');
    }
    function clearDropHighlights() {
        $$('.inv-slot.drop-target, .inv-slot.drop-invalid')
            .forEach(s => s.classList.remove('drop-target', 'drop-invalid'));
    }

    // ─── Server transfer + refresh ────────────────────────
    async function doTransfer(item, fromSide, toSide, count) {
        if (!count || count <= 0) return;
        const dir = fromSide === 'stash' ? 'take' : 'put';
        const res = await post('stash_move', {
            stashId: state.stashId,
            name:    item.name,
            count:   Math.min(count, item.count),
            dir,
        });
        if (res && res.ok === false && res.err) {
            Notify.show({ message: res.err, type: 'error' });
        }
        // Always refresh — server is authoritative
        await refresh();
    }

    async function refresh() {
        const fresh = await post('stash_refresh', { stashId: state.stashId });
        if (!fresh || !fresh.ok) return;
        state.player = fresh.player || [];
        state.stash  = fresh.stash  || [];
        if (fresh.slots) state.slots = fresh.slots;
        renderAll();
    }

    // ─── Tooltip ──────────────────────────────────────────
    function showTooltip(item, e) {
        if (drag) return;
        tipLabel.textContent = item.label;
        tipCount.textContent = item.count + ' in stack';
        tipKey.textContent   = 'shift+click · drag';
        positionTooltip(e);
        tooltip.hidden = false;
    }
    function positionTooltip(e) {
        tooltip.style.left = e.clientX + 'px';
        tooltip.style.top  = e.clientY + 'px';
    }
    function hideTooltip() { tooltip.hidden = true }

    // ─── Quantity prompt ─────────────────────────────────
    function askQuantity(item, otherSide) {
        qtyTitle.textContent = `Transfer ${item.label}`;
        qtyInput.value = 1;
        qtyInput.max   = item.count;
        qtyOverlay.hidden = false;
        setTimeout(() => qtyInput.focus(), 50);

        qtyResolve = (qty) => {
            qtyResolve = null;
            qtyOverlay.hidden = true;
            if (qty && qty > 0) {
                const fromSide = otherSide === 'player' ? 'stash' : 'player';
                doTransfer(item, fromSide, otherSide, Math.min(qty, item.count));
            }
        };
    }
    qtyOverlay.addEventListener('click', e => {
        const action = e.target.closest('[data-action]')?.dataset.action;
        if (action === 'inv-qty-cancel' || e.target === qtyOverlay) qtyResolve && qtyResolve(0);
        if (action === 'inv-qty-ok')      qtyResolve && qtyResolve(parseInt(qtyInput.value, 10) || 0);
        const preset = e.target.closest('[data-q]')?.dataset.q;
        if (preset) {
            if (preset === 'max') qtyInput.value = qtyInput.max || 1;
            else qtyInput.value = preset;
        }
    });
    qtyInput.addEventListener('keydown', e => {
        if (e.key === 'Enter') qtyResolve && qtyResolve(parseInt(qtyInput.value, 10) || 0);
        if (e.key === 'Escape') qtyResolve && qtyResolve(0);
    });

    // ─── Public ──────────────────────────────────────────
    function open(payload) {
        state.stashId   = payload.stashId;
        state.stashName = payload.label || payload.stashId || 'Storage';
        state.player    = payload.player || [];
        state.stash     = (payload.items && payload.items.items) || payload.items || [];
        if (payload.items && payload.items.slots) {
            state.slots = { player: 25, stash: payload.items.slots };
        }
        renderAll();
        overlay.hidden = false;
        resetScroll(overlay);
    }
    function close() {
        overlay.hidden = true;
        hideTooltip();
        ghost.hidden = true;
        post('ui_close');
    }
    overlay.addEventListener('click', e => {
        if (e.target === overlay) close();
        if (e.target.closest('[data-action="stash-close"]')) close();
    });
    document.addEventListener('keydown', e => {
        if (!overlay.hidden && e.key === 'Escape' && qtyOverlay.hidden) close();
    });
    return { open };
})();

// ════════════════════════════════════════════════════════════
// THEME — runtime brand colour + shell size
//   Persisted in localStorage so the user's preference survives
//   resource restarts.
// ════════════════════════════════════════════════════════════
const Theme = (() => {
    const LS_SIZE  = 'apex_restaurant_size';
    const LS_MPOS  = 'apex_restaurant_mpos';
    const DEFAULT_COLOR = '#1F5EFF';
    const DEFAULT_BG    = '#0A0A0B';
    const DEFAULT_SIZE  = 'm';
    const DEFAULT_MPOS  = 'top-right';

    const PRESETS = [
        '#1F5EFF', // Apex blue
        '#8B5CF6', // Violet
        '#EC4899', // Pink
        '#EF4444', // Red
        '#F97316', // Orange
        '#22C55E', // Green
        '#06B6D4', // Cyan
        '#EAB308', // Yellow
    ];

    // Dark background bases — the picked colour becomes --surface-0 and a
    // matching lighter ramp (surfaces 1-5 / cards / sidebar) is generated.
    const BG_PRESETS = [
        '#0A0A0B', // Neutral black (default)
        '#0B0F1A', // Blue night
        '#0E0A16', // Violet night
        '#0A1410', // Green night
        '#140A0C', // Crimson night
        '#12100A', // Warm night
    ];

    const SIZES = {
        s:    { w: 'min(1100px, 80vw)', h: 'min(720px, 78vh)', radius: '14px', padding: '16px' },
        m:    { w: 'min(1380px, 90vw)', h: 'min(860px, 88vh)', radius: '14px', padding: '16px' },
        l:    { w: 'min(1720px, 96vw)', h: 'min(940px, 92vh)', radius: '14px', padding: '12px' },
        full: { w: '100vw',             h: '100vh',            radius: '0',    padding: '0'    },
    };

    // ── Colour math ─────────────────────────────────────
    const hexToRgb = (hex) => {
        const v = hex.replace('#', '');
        return [parseInt(v.slice(0,2),16), parseInt(v.slice(2,4),16), parseInt(v.slice(4,6),16)];
    };
    const rgbToHsl = (r, g, b) => {
        r/=255; g/=255; b/=255;
        const max = Math.max(r,g,b), min = Math.min(r,g,b);
        let h, s; const l = (max+min)/2;
        if (max === min) { h = s = 0; }
        else {
            const d = max - min;
            s = l > 0.5 ? d/(2-max-min) : d/(max+min);
            switch(max){
                case r: h = (g-b)/d + (g<b?6:0); break;
                case g: h = (b-r)/d + 2; break;
                case b: h = (r-g)/d + 4; break;
            }
            h /= 6;
        }
        return [h*360, s*100, l*100];
    };
    const hslToHex = (h, s, l) => {
        s/=100; l/=100;
        const c = (1 - Math.abs(2*l-1)) * s;
        const x = c * (1 - Math.abs((h/60)%2 - 1));
        const m = l - c/2;
        let r, g, b;
        if (h<60)        [r,g,b] = [c,x,0];
        else if (h<120)  [r,g,b] = [x,c,0];
        else if (h<180)  [r,g,b] = [0,c,x];
        else if (h<240)  [r,g,b] = [0,x,c];
        else if (h<300)  [r,g,b] = [x,0,c];
        else             [r,g,b] = [c,0,x];
        const toHex = (v) => Math.round((v+m)*255).toString(16).padStart(2,'0');
        return '#' + toHex(r) + toHex(g) + toHex(b);
    };

    // ── Apply brand colour (generates full scale + alphas) ──
    function applyBrand(hex) {
        const [r, g, b] = hexToRgb(hex);
        const [h, s]    = rgbToHsl(r, g, b);
        const root = document.documentElement.style;
        // Keep ApexUI.theme.brand in sync so subsequent calls to
        // configBrand() (Theme.init on editor re-open) see the latest
        // picked colour — not the value from the initial bootstrap.
        window.ApexUI = window.ApexUI || {};
        ApexUI.theme  = ApexUI.theme  || {};
        ApexUI.theme.brand = hex;

        const scale = {
            50: hslToHex(h, Math.min(100,s+10), 95),
            100: hslToHex(h, Math.min(100,s+8),  88),
            200: hslToHex(h, s, 80),
            300: hslToHex(h, s, 72),
            400: hslToHex(h, s, 65),
            500: hex,
            600: hslToHex(h, s, 45),
            700: hslToHex(h, s, 35),
            800: hslToHex(h, s, 25),
            900: hslToHex(h, s, 18),
        };
        for (const [k, v] of Object.entries(scale)) {
            root.setProperty(`--brand-${k}`, v);
        }
        const alphas = { 'a05': .05, 'a08': .08, 'a12': .12, 'a18': .18, 'a25': .25, 'a40': .40 };
        for (const [k, a] of Object.entries(alphas)) {
            root.setProperty(`--brand-${k}`, `rgba(${r},${g},${b},${a})`);
        }
        // Type accents that piggy-back on the brand
        ['t-restaurant', 't-blip', 't-menu', 't-delivery'].forEach(k => root.setProperty(`--${k}`, hex));

        // Update popover chrome (if popover is mounted)
        const hexEl  = $('#color-hex');
        const inpEl  = $('#color-input');
        if (hexEl) hexEl.textContent = hex.toUpperCase();
        if (inpEl) inpEl.value       = hex;
        $$('.preset-swatch').forEach(s => s.classList.toggle('active', s.dataset.color.toLowerCase() === hex.toLowerCase()));
    }

    // ── Apply background colour (picked hue = surface-0, ramp up) ──
    //   Regenerates the neutral surface ramp (--surface-0..5) and the
    //   --bg / --bg-card / --bg-raised / --bg-sidebar aliases from a single
    //   base colour, keeping the same relative lightness steps as the
    //   shipped theme so contrast stays intact for any picked tone.
    function applyBg(hex) {
        if (!/^#[0-9a-f]{6}$/i.test(hex)) hex = DEFAULT_BG;
        const [r, g, b] = hexToRgb(hex);
        const [hue, sat, l0] = rgbToHsl(r, g, b);
        const root = document.documentElement.style;
        window.ApexUI = window.ApexUI || {};
        ApexUI.theme  = ApexUI.theme  || {};
        ApexUI.theme.bg = hex;

        const clampL = (x) => Math.max(0, Math.min(100, x));
        // lightness offsets (in % points) above the picked base — mirrors the
        // shipped #0A0A0B → #38383C ramp (~+3.5/+6/+10/+14/+18).
        const steps = [0, 3.5, 6, 10, 14, 18];
        steps.forEach((d, i) => {
            root.setProperty(`--surface-${i}`, hslToHex(hue, sat, clampL(l0 + d)));
        });
        root.setProperty('--bg',         hslToHex(hue, sat, clampL(l0 + steps[0])));
        root.setProperty('--bg-sidebar', hslToHex(hue, sat, clampL(l0 + steps[1])));
        root.setProperty('--bg-card',    hslToHex(hue, sat, clampL(l0 + steps[2])));
        root.setProperty('--bg-raised',  hslToHex(hue, sat, clampL(l0 + steps[3])));

        const hexEl = $('#bg-hex');
        const inpEl = $('#bg-input');
        if (hexEl) hexEl.textContent = hex.toUpperCase();
        if (inpEl) {
            inpEl.value = hex;
            if (inpEl.parentElement) inpEl.parentElement.style.background = hex;
        }
        $$('.bg-preset-swatch').forEach(s => s.classList.toggle('active', s.dataset.color.toLowerCase() === hex.toLowerCase()));
    }

    // ── Apply shell size ────────────────────────────────
    function applySize(key) {
        const s = SIZES[key] || SIZES.m;
        const shell = $('.editor-shell');
        const root  = $('#editor-root');
        if (shell) {
            shell.style.width  = s.w;
            shell.style.height = s.h;
            shell.style.borderRadius = s.radius;
        }
        if (root) root.style.padding = s.padding;
        $$('.size-btn').forEach(b => b.classList.toggle('active', b.dataset.size === key));
    }

    // ── Apply in-game menu position ─────────────────────
    const MPOS_CLASSES = [
        'mpos-top-left','mpos-top-center','mpos-top-right',
        'mpos-middle-left','mpos-middle','mpos-middle-right',
        'mpos-bottom-left','mpos-bottom-center','mpos-bottom-right',
    ];
    function applyMPos(pos) {
        const cls = 'mpos-' + (pos || DEFAULT_MPOS);
        // Apply to every overlay that should follow the configured menu
        // position: the main menu modal AND the persistent delivery HUD.
        ['#menu-overlay', '#delivery-hud'].forEach(sel => {
            const el = document.querySelector(sel);
            if (!el) return;
            MPOS_CLASSES.forEach(c => el.classList.remove(c));
            el.classList.add(cls);
        });
        $$('.mpos-cell').forEach(b => b.classList.toggle('active', b.dataset.pos === pos));
    }

    // ── Popover toggle (single combined panel) ─────────
    document.addEventListener('click', (e) => {
        const pop = $('#settings-popover');
        if (!pop) return;
        if (e.target.closest('#btn-settings')) { pop.hidden = !pop.hidden; return; }
        if (!e.target.closest('.topbar-popover')) pop.hidden = true;
    });

    // Default colour falls back to Config.theme.brand (pushed via set_config)
    // before the hardcoded blue — so the runtime UI matches the configured
    // brand even if the creator was never opened.
    // Brand + background are SERVER-GLOBAL: the authoritative values come from
    // Config.theme (pushed via set_config / theme_brand_apply). No localStorage
    // override — every player always renders the same admin-picked colours.
    function configBrand() {
        return (window.ApexUI && ApexUI.theme && ApexUI.theme.brand) || DEFAULT_COLOR;
    }
    function configBg() {
        return (window.ApexUI && ApexUI.theme && ApexUI.theme.bg) || DEFAULT_BG;
    }

    // Called from the `set_config` NUI message on bootstrap so notifications /
    // register / customer menu pick up the server theme before the editor opens.
    function applyDefaults() {
        applyBrand(configBrand());
        applyBg(configBg());
    }

    // ── Init wiring (idempotent — safe to call on every open) ──
    let wired = false;
    function init() {
        if (wired) {
            applyBrand(configBrand());
            applyBg(configBg());
            applySize(load('size')  || DEFAULT_SIZE);
            return;
        }
        wired = true;

        // Brand + background are SERVER-GLOBAL: every pick goes to the server,
        // which validates, persists (data/theme.json) and broadcasts the new
        // colour to ALL online players. The local apply*() call is just instant
        // preview — the authoritative apply comes back via `theme_brand_apply`.
        function pushBrand(c) {
            applyBrand(c);
            post('theme_set_brand', { color: c });
        }
        function pushBg(c) {
            applyBg(c);
            post('theme_set_bg', { color: c });
        }

        // Build brand presets
        const wrap = $('#color-presets');
        wrap.innerHTML = '';
        PRESETS.forEach(c => {
            wrap.appendChild(h('button', {
                class: 'preset-swatch',
                style: `--_c:${c}`,
                dataset: { color: c },
                title: c,
                onclick: () => pushBrand(c),
            }));
        });

        $('#color-input').addEventListener('input', e => pushBrand(e.target.value));
        $('#color-reset').addEventListener('click', () => post('theme_reset_brand'));

        // Build background presets
        const bgWrap = $('#bg-presets');
        if (bgWrap) {
            bgWrap.innerHTML = '';
            BG_PRESETS.forEach(c => {
                bgWrap.appendChild(h('button', {
                    class: 'bg-preset-swatch',
                    style: `--_c:${c}`,
                    dataset: { color: c },
                    title: c,
                    onclick: () => pushBg(c),
                }));
            });
        }
        const bgInput = $('#bg-input');
        if (bgInput) bgInput.addEventListener('input', e => pushBg(e.target.value));
        const bgReset = $('#bg-reset');
        if (bgReset) bgReset.addEventListener('click', () => post('theme_reset_bg'));

        $('#size-grid').addEventListener('click', e => {
            const btn = e.target.closest('[data-size]');
            if (!btn) return;
            applySize(btn.dataset.size);
            save('size', btn.dataset.size);
        });

        const mposGrid = $('#mpos-grid');
        if (mposGrid) {
            mposGrid.addEventListener('click', e => {
                const cell = e.target.closest('[data-pos]');
                if (!cell) return;
                applyMPos(cell.dataset.pos);
                save('mpos', cell.dataset.pos);
            });
        }

        // Restore prefs (colours come from the server; size/mpos are local)
        applyBrand(configBrand());
        applyBg(configBg());
        applySize(load('size')   || DEFAULT_SIZE);
        applyMPos(load('mpos')   || DEFAULT_MPOS);
    }

    const LS_KEY = { size: LS_SIZE, mpos: LS_MPOS };
    function save(k, v) { try { localStorage.setItem(LS_KEY[k], v); } catch {} }
    function load(k)    { try { return localStorage.getItem(LS_KEY[k]); } catch { return null; } }

    // Apply the menu position immediately so the first menu after
    // page-load already lands in the right spot (the script tag sits
    // at end-of-body so #menu-overlay is already in the DOM).
    applyMPos(load('mpos') || DEFAULT_MPOS);

    return { init, applyBrand, applyBg, applySize, applyMPos, applyDefaults };
})();

// ════════════════════════════════════════════════════════════
// PHONE CALL  (delivery dispatch)
// ════════════════════════════════════════════════════════════
const Phone = (() => {
    const overlay = $('#phone-overlay');
    const timerEl = $('#phone-timer');
    const nameEl  = $('#phone-name');
    const nameEl2 = $('#phone-name-2');
    const vehList = $('#phone-veh-list');

    let timer = null;
    let secs  = 0;
    let pendingResult = null;

    function showState(s) {
        $$('.phone-state').forEach(el => el.hidden = el.dataset.state !== s);
    }

    function startTimer() {
        secs = 0; timerEl.textContent = '0:00';
        timer = setInterval(() => {
            secs++;
            const m = Math.floor(secs/60), s = secs%60;
            timerEl.textContent = m + ':' + (s < 10 ? '0'+s : s);
        }, 1000);
    }
    function stopTimer() { if (timer) { clearInterval(timer); timer = null } }

    function open({ contact, vehicles }) {
        nameEl.textContent  = contact || 'Dispatch';
        nameEl2.textContent = contact || 'Dispatch';
        showState('calling');
        startTimer();
        pendingResult = null;
        overlay.hidden = false;

        // After ~2.5s, transition to "connected" with vehicle picker
        setTimeout(() => {
            if (overlay.hidden) return;
            showState('connected');
            vehList.innerHTML = '';
            (vehicles || []).forEach(v => {
                vehList.appendChild(h('button', {
                    class: 'phone-veh',
                    onclick: () => close({ vehicle: v.model, label: v.label }),
                },
                    h('i', { class: 'fa-solid fa-truck-fast' }),
                    h('div', null,
                        h('div', { class: 'phone-veh-label' }, v.label || v.model),
                        h('div', { class: 'phone-veh-model' }, v.model)
                    )
                ));
            });
            if (!vehicles || !vehicles.length) {
                vehList.appendChild(h('div', { style: 'padding:12px;color:var(--text-3);font-size:12px' }, 'No vehicles available'));
            }
        }, 2500);
    }
    function close(result) {
        if (overlay.hidden) return;
        stopTimer();
        overlay.hidden = true;
        post('phone_done', result || { cancel: true });
    }

    $('#phone-hangup').addEventListener('click', () => close({ cancel: true }));

    return { open, close };
})();

// ════════════════════════════════════════════════════════════
// DELIVERY HUD  (persistent panel during a run)
// ════════════════════════════════════════════════════════════
const DeliveryHUD = (() => {
    const hud = $('#delivery-hud');
    const elV = $('#dh-vehicle');
    const elD = $('#dh-distance');
    const elR = $('#dh-reward');
    const elT = $('#dh-title');
    const hint  = $('#dh-cancel-hint');
    const armed = $('#dh-cancel-armed');
    const btnReturn = $('#dh-return');

    function open(p) {
        elV.textContent = p.vehicle || '—';
        elD.textContent = p.distance != null ? p.distance + 'm' : '—';
        elR.textContent = p.reward   || '—';
        elT.textContent = p.title    || 'Active delivery';
        btnReturn.hidden = !p.canReturn;
        hint.hidden  = p.canReturn === true;
        armed.hidden = true;
        hud.classList.remove('confirm-cancel');
        hud.hidden = false;
    }
    function update(p) {
        if (p.distance  != null) elD.textContent = p.distance + 'm';
        if (p.title)             elT.textContent = p.title;
        if (p.canReturn != null) {
            btnReturn.hidden = !p.canReturn;
            hint.hidden = p.canReturn === true;
            if (p.canReturn) { armed.hidden = true; hud.classList.remove('confirm-cancel'); }
        }
        if (p.confirmCancel === true) {
            hint.hidden = true;
            armed.hidden = false;
            hud.classList.add('confirm-cancel');
        } else if (p.confirmCancel === false) {
            armed.hidden = true;
            hint.hidden  = btnReturn.hidden === false; // hide hint while in return phase
            hud.classList.remove('confirm-cancel');
        }
    }
    function close() { hud.hidden = true; hud.classList.remove('confirm-cancel') }

    btnReturn.addEventListener('click', () => post('delivery_return'));

    return { open, update, close };
})();

// ════════════════════════════════════════════════════════════
// ORDER HERE  (customer-facing menu — gallery + cart)
// ════════════════════════════════════════════════════════════
const Order = (() => {
    const overlay  = $('#order-overlay');
    const titleEl  = $('#order-title');
    const gallery  = $('#order-gallery');
    const cartList = $('#order-cart-items');
    const cartCnt  = $('#order-cart-count');
    const subEl    = $('#order-subtotal');
    const totEl    = $('#order-total');
    const ckBtn    = $('#order-checkout');
    const ckLbl    = $('#order-checkout-label');

    let job        = null;
    let menu       = [];
    let cart       = {};    // { name: { item, qty } }
    let pay        = 'money';
    let busy       = false;
    let readOnly   = false;
    let mode       = 'order';   // 'order' | 'shop'
    let isEmployee = false;     // restaurant employee viewing their own shop
    const editing  = new Set(); // item names currently in edit mode

    function totalsArr() { return Object.values(cart) }
    function totalSum() {
        return totalsArr().reduce((s, c) => s + (c.item.price || 0) * c.qty, 0);
    }
    function itemCount() {
        return totalsArr().reduce((s, c) => s + c.qty, 0);
    }

    function paint() {
        // Cart list
        cartList.innerHTML = '';
        const entries = totalsArr();
        if (!entries.length) {
            cartList.appendChild(h('div', { class: 'order-cart-empty' },
                h('i', { class: 'fa-solid fa-basket-shopping' }),
                h('div', { class: 'oce-title' }, 'Your cart is empty'),
                h('div', { class: 'oce-sub' }, 'Pick something from the menu')
            ));
        } else {
            entries.forEach(({ item, qty }) => {
                cartList.appendChild(h('div', { class: 'order-cart-item' },
                    h('img', { src: item.image || '', alt: item.label, onerror: 'this.style.opacity=0.25' }),
                    h('div', null,
                        h('div', { class: 'order-cart-item-name' }, item.label),
                        h('div', { class: 'order-cart-item-price' }, ApexUI.fmtMoney(item.price)),
                    ),
                    h('div', { class: 'order-cart-qty' },
                        h('button', { onclick: () => bump(item, -1) }, '−'),
                        h('span', { class: 'order-cart-qty-val' }, qty),
                        h('button', { onclick: () => bump(item, +1) }, '+'),
                    ),
                    h('div', null) // spacer for grid
                ));
            });
        }
        cartCnt.textContent = itemCount();
        const t = totalSum();
        subEl.textContent = ApexUI.fmtMoney(t);
        totEl.textContent = ApexUI.fmtMoney(t);
        ckBtn.disabled = t <= 0 || busy;
        ckLbl.textContent = t > 0 ? `Place order · ${ApexUI.fmtMoney(t)}` : 'Place order';
    }

    function bump(item, delta) {
        if (readOnly) return;            // can't add when just viewing
        const key = item.name;
        cart[key] = cart[key] || { item, qty: 0 };
        const next = cart[key].qty + delta;
        // Cap at available stock — customers can never order more than
        // the employees have deposited. Shop mode (NPC supplier) is
        // unlimited so we only check when stock is tracked.
        if (delta > 0 && item.stock != null && next > item.stock) {
            Notify.show({ message: 'Only ' + item.stock + ' in stock', type: 'warning' });
            return;
        }
        cart[key].qty = next;
        if (cart[key].qty <= 0) delete cart[key];
        paint();
    }

    // Re-fetch stock + menu after a deposit/withdraw/setPrice so the
    // card numbers update without closing the overlay.
    async function refreshStock() {
        const res = await post('shop_menu_refresh');
        if (res && res.items) { menu = res.items; renderGallery(); }
    }

    // ── "Add product" modal (FOOD inventory picker) ──
    async function openFoodPicker() {
        const res = await post('shop_food_inventory', { job });
        const items = (res && res.items) || [];

        const back = h('div', {
            style: 'position:fixed;inset:0;background:transparent;z-index:9999;display:flex;align-items:center;justify-content:center;padding:24px',
            onclick: e => { if (e.target === back) back.remove(); },
        });
        const modal = h('div', {
            style: 'width:min(560px,94vw);max-height:80vh;background:var(--surface-2);border:1px solid var(--line-2);border-radius:var(--r-4);box-shadow:var(--shadow-modal);display:flex;flex-direction:column;overflow:hidden',
        });

        modal.appendChild(h('div', {
            style: 'display:flex;align-items:center;justify-content:space-between;padding:14px 16px;border-bottom:1px solid var(--line-1)',
        },
            h('div', null,
                h('div', { style: 'font-size:13px;font-weight:600;color:var(--text-1)' }, L('ui.shop.deposit.title')),
                h('div', { style: 'font-size:10.5px;color:var(--text-3);margin-top:2px' },
                    L('ui.shop.deposit.subtitle'))
            ),
            (() => {
                const x = h('button', {
                    style: 'background:transparent;border:none;color:var(--text-3);cursor:pointer;font-size:14px',
                }, h('i', { class: 'fa-solid fa-xmark' }));
                x.addEventListener('click', () => back.remove());
                return x;
            })()
        ));

        const body = h('div', {
            style: 'padding:12px;overflow-y:auto;display:flex;flex-direction:column;gap:6px',
        });
        if (!items.length) {
            body.appendChild(h('div', {
                style: 'padding:36px;text-align:center;color:var(--text-3);font-size:12px;line-height:1.6',
            },
                L('ui.shop.deposit.empty_line1'),
                h('br'),
                L('ui.shop.deposit.empty_line2')
            ));
        } else {
            items.forEach(it => {
                const qty   = h('input', { type: 'number', class: 'apex-input', value: 1, min: 1, max: it.count,
                    style: 'width:70px;text-align:right;padding:4px 6px;font-size:11px' });
                const price = h('input', { type: 'number', class: 'apex-input', value: it.price || 0, min: 0,
                    style: 'width:80px;text-align:right;padding:4px 6px;font-size:11px' });
                const haveEl = h('div', { style: 'font-size:10.5px;color:var(--text-3)' }, L('ui.shop.deposit.you_have', it.count));
                const addBtn = h('button', { class: 'btn btn-primary btn-sm',
                    style: 'padding:4px 10px;font-size:11px;flex-shrink:0' },
                    h('i', { class: 'fa-solid fa-arrow-down' }), ' ' + L('ui.shop.deposit.deposit_btn'));

                const row = h('div', {
                    style: 'display:grid;grid-template-columns:32px 1fr 60px 70px 80px auto;align-items:center;gap:10px;padding:8px 10px;background:var(--surface-3);border:1px solid var(--line-2);border-radius:var(--r-2)',
                },
                    h('img', { src: it.image || '', alt: '', style: 'width:28px;height:28px;object-fit:contain',
                        onerror: 'this.style.opacity=0.25' }),
                    h('div', { style: 'min-width:0' },
                        h('div', { style: 'font-size:12px;font-weight:600;color:var(--text-1);overflow:hidden;text-overflow:ellipsis;white-space:nowrap' }, it.label),
                        haveEl
                    ),
                    h('div', { style: 'font-size:10px;color:var(--text-3);text-align:right' }, L('ui.shop.deposit.qty_label')),
                    qty,
                    price,
                    addBtn,
                );

                addBtn.addEventListener('click', async () => {
                    const q = Math.max(1, Math.min(Number(qty.value) || 1, it.count));
                    const p = Math.max(0, Number(price.value) || 0);
                    addBtn.disabled = true;
                    const r = await post('shop_stock_deposit', { item: it.name, qty: q, price: p });
                    addBtn.disabled = false;
                    if (r && r.ok) {
                        Notify.show({ message: L('ui.shop.deposit.deposit_success', q, it.label), type: 'success' });
                        // Keep the modal OPEN — just update this row's remaining count.
                        it.count = Math.max(0, (it.count || 0) - q);
                        if (it.count <= 0) {
                            row.remove();
                            if (!body.children.length) {
                                body.appendChild(h('div', { style: 'padding:36px;text-align:center;color:var(--text-3);font-size:12px;line-height:1.6' },
                                    L('ui.shop.deposit.empty_line1'), h('br'), L('ui.shop.deposit.empty_line2')));
                            }
                        } else {
                            qty.max = it.count;
                            if (Number(qty.value) > it.count) qty.value = it.count;
                            haveEl.textContent = L('ui.shop.deposit.you_have', it.count);
                        }
                        refreshStock();
                    } else {
                        Notify.show({ message: (r && r.info) || L('ui.common.failed'), type: 'error' });
                    }
                });

                body.appendChild(row);
            });
        }
        modal.appendChild(body);
        back.appendChild(modal);
        document.body.appendChild(back);
    }

    // Build the employee-only management strip that sits BELOW each card.
    // Lets the employee deposit from inventory, withdraw back to it, and
    // update the live price — all from inside the customer-facing shop UI.
    function buildEmployeeStrip(item) {
        const initialPrice = item.price || item.basePrice || 0;
        const priceInput = h('input', { type: 'number', class: 'apex-input',
            value: initialPrice, min: 0, title: 'Price ($)',
            style: 'width:100%;text-align:right;padding:4px 6px;font-size:11px',
            onclick: e => e.stopPropagation(),
            oninput:  e => e.stopPropagation(),
        });
        const qtyInput = h('input', { type: 'number', class: 'apex-input',
            value: 1, min: 1, title: 'Qty',
            style: 'width:100%;text-align:right;padding:4px 6px;font-size:11px',
            onclick: e => e.stopPropagation(),
            oninput:  e => e.stopPropagation(),
        });
        const onErr = info => Notify.show({ message: info || 'Failed', type: 'error' });

        function btn(opts, ...children) {
            const b = h('button', opts, ...children);
            b.addEventListener('click', e => e.stopPropagation());
            return b;
        }

        const setBtn = btn({
            class: 'btn btn-ghost btn-sm',
            title: 'Save price',
            style: 'padding:4px 8px;font-size:11px;flex-shrink:0',
            onclick: async () => {
                const res = await post('shop_stock_setprice',
                    { item: item.name, price: Number(priceInput.value) || 0 });
                if (res && res.ok) { Notify.show({ message: 'Price saved', type: 'success' }); refreshStock(); }
                else onErr(res && res.info);
            }
        }, h('i', { class: 'fa-solid fa-check' }));

        const depBtn = btn({
            class: 'btn btn-primary btn-sm',
            title: 'Deposit from inventory',
            style: 'padding:4px 8px;font-size:11px;flex:1;justify-content:center',
            onclick: async () => {
                const res = await post('shop_stock_deposit', {
                    item:  item.name,
                    qty:   Number(qtyInput.value) || 1,
                    price: Number(priceInput.value) || 0,
                });
                if (res && res.ok) { Notify.show({ message: 'Deposited', type: 'success' }); refreshStock(); }
                else onErr(res && res.info);
            }
        }, h('i', { class: 'fa-solid fa-arrow-down' }), ' In');

        const wdBtn = btn({
            class: 'btn btn-ghost btn-sm',
            title: 'Withdraw back to inventory',
            style: 'padding:4px 8px;font-size:11px;flex:1;justify-content:center',
            onclick: async () => {
                const res = await post('shop_stock_withdraw',
                    { item: item.name, qty: Number(qtyInput.value) || 1 });
                if (res && res.ok) { Notify.show({ message: 'Withdrawn', type: 'success' }); refreshStock(); }
                else onErr(res && res.info);
            }
        }, h('i', { class: 'fa-solid fa-arrow-up' }), ' Out');

        const strip = h('div', {
            class: 'order-card-emp',
            style: 'display:flex;flex-direction:column;gap:6px;padding:8px 10px;background:var(--surface-1);border-top:1px solid var(--line-1)',
            onclick: e => e.stopPropagation(),
        },
            h('div', { style: 'display:flex;gap:6px;align-items:center' },
                h('span', { style: 'flex:0 0 38px;font-size:10px;color:var(--text-3);text-transform:uppercase;letter-spacing:.04em' }, 'Price'),
                priceInput, setBtn
            ),
            h('div', { style: 'display:flex;gap:6px;align-items:center' },
                h('span', { style: 'flex:0 0 38px;font-size:10px;color:var(--text-3);text-transform:uppercase;letter-spacing:.04em' }, 'Qty'),
                qtyInput
            ),
            h('div', { style: 'display:flex;gap:6px' }, depBtn, wdBtn)
        );
        return strip;
    }

    function renderGallery() {
        gallery.innerHTML = '';

        // The "+ Add product" action now lives in the navbar (#order-add-product,
        // shown for employees in open()).

        // Employees see EVERY item on the menu (so they can deposit/
        // withdraw/price even items currently at 0 stock). Customers,
        // NPC-shop mode and read-only view all keep the original rules:
        // shop/readOnly = show everything, customers = stock > 0 only.
        const visible = (isEmployee || mode === 'shop' || readOnly)
            ? menu
            : menu.filter(it => it.stock != null && it.stock > 0);

        if (!visible.length) {
            const empty = isEmployee
                ? 'No products yet — use "Add product from inventory" above to stock something.'
                : (menu.length ? 'Sold out — come back later' : 'No items on the menu yet');
            gallery.appendChild(h('div', {
                style: 'grid-column:1/-1;text-align:center;color:var(--text-3);padding:40px;font-size:12px'
            }, empty));
            return;
        }
        visible.forEach(item => {
            const label = String(item.label || item.name || 'Item');
            const desc  = item.description
                       || (item.calories ? (item.calories + ' cal') : '');
            const price = ApexUI.fmtMoney(item.price || 0);

            // For the transactional Order Here / NPC shop we add inline
            // styles WITH !important as fallbacks (defensive — guarantees
            // labels/prices show even with stale CSS).  Skipped in read-only.
            const tBody  = readOnly ? '' : 'display:flex!important;flex-direction:column!important;gap:6px!important;padding:14px 14px 14px!important;min-height:100px!important;background:transparent;overflow:visible!important;visibility:visible!important;opacity:1!important';
            const tLabel = readOnly ? '' : 'display:block!important;color:#F4F4F5!important;font-weight:600!important;font-size:13px!important;line-height:1.5!important;padding-bottom:2px!important;overflow:hidden!important;text-overflow:ellipsis;white-space:nowrap;visibility:visible!important;opacity:1!important';
            const tDesc  = readOnly ? '' : 'display:block!important;color:#A8A8AD!important;font-size:10.5px!important;line-height:1.5!important;visibility:visible!important;opacity:1!important';
            const tFoot  = readOnly ? '' : 'display:flex!important;align-items:center;justify-content:space-between;margin-top:6px!important;background:transparent;visibility:visible!important;line-height:1.4!important';
            const tPrice = readOnly ? '' : 'display:inline-block!important;color:var(--brand-400)!important;font-weight:700!important;font-size:14px!important;line-height:1.4!important;padding:2px 0!important;font-variant-numeric:tabular-nums;visibility:visible!important';
            const tAdd   = readOnly ? '' : 'width:26px;height:26px;display:inline-flex!important;align-items:center;justify-content:center;background:var(--brand-a12);color:var(--brand-400);border:1px solid var(--brand-a25);border-radius:6px;font-size:11px;flex-shrink:0';

            // Card is always rendered like the customer sees it
            // (image + label + price + "+"). Employees additionally get:
            //   • a stock badge on the image (top-left)
            //   • an edit pencil overlay (top-right) → expands the
            //     deposit/withdraw/price strip below.
            const card = h('div', { class: 'order-card', onclick: () => bump(item, +1),
                style: 'position:relative' });

            // Show the item's own image. If the configured source (e.g.
            // ox_inventory) is missing it, fall back to the shipped local
            // PNG before giving up — so the dish always shows its picture.
            const imgFallback = 'nui://apex_restaurant/build/html/img/' + (item.name || 'restaurant_food') + '.png';
            const imgWrap = h('div', { class: 'order-card-img', style: 'position:relative' },
                h('img', { src: item.image || imgFallback, alt: label, 'data-fb': imgFallback,
                    onerror: "this.onerror=null;this.src=this.dataset.fb" })
            );
            if (isEmployee) {
                imgWrap.appendChild(h('span', {
                    style: 'position:absolute;top:6px;left:6px;background:rgba(0,0,0,.65);color:#fff;font-size:10.5px;font-weight:700;padding:2px 6px;border-radius:10px;font-variant-numeric:tabular-nums;pointer-events:none',
                }, 'x' + (item.stock != null ? item.stock : 0)));

                const editIcon = h('button', {
                    title: 'Manage this product',
                    style: 'position:absolute;top:6px;right:6px;width:24px;height:24px;display:inline-flex;align-items:center;justify-content:center;background:rgba(0,0,0,.6);color:#fff;border:none;border-radius:50%;font-size:10px;cursor:pointer',
                }, h('i', { class: 'fa-solid fa-' + (editing.has(item.name) ? 'xmark' : 'pen') }));
                editIcon.addEventListener('click', e => {
                    e.stopPropagation();
                    if (editing.has(item.name)) editing.delete(item.name);
                    else editing.add(item.name);
                    renderGallery();
                });
                imgWrap.appendChild(editIcon);
            }
            card.appendChild(imgWrap);

            const body = h('div', { class: 'order-card-body', style: tBody });
            body.appendChild(h('div', { class: 'order-card-label', style: tLabel }, label));
            if (desc) body.appendChild(h('div', { class: 'order-card-desc', style: tDesc }, desc));
            body.appendChild(h('div', { class: 'order-card-foot', style: tFoot },
                h('span', { class: 'order-card-price', style: tPrice }, price),
                h('span', { class: 'order-card-add', style: tAdd }, h('i', { class: 'fa-solid fa-plus' })),
            ));
            card.appendChild(body);
            // Inline edit panel — only when the employee toggled this card on.
            if (isEmployee && editing.has(item.name)) {
                card.appendChild(buildEmployeeStrip(item));
            }
            gallery.appendChild(card);
        });
    }

    // Payment toggle
    $$('.order-pay-btn').forEach(b => {
        b.addEventListener('click', () => {
            pay = b.dataset.pay;
            $$('.order-pay-btn').forEach(x => x.classList.toggle('active', x.dataset.pay === pay));
        });
    });

    ckBtn.addEventListener('click', async () => {
        if (busy || itemCount() === 0) return;
        busy = true; paint();
        const items = totalsArr().map(({ item, qty }) => ({ name: item.name, qty }));
        // 'shop' mode = NPC supplier (pays from society funds)
        // 'order' mode = customer ordering (pays from own wallet)
        const endpoint = mode === 'shop' ? 'shop_checkout' : 'order_checkout';
        console.log('[apex_restaurant] checkout', { endpoint, mode, job, payment: pay, items });
        const res = await post(endpoint, { job, items, payment: pay });
        console.log('[apex_restaurant] checkout result', res);
        busy = false;
        if (res && res.ok) {
            Notify.show({ message: 'Order placed', type: 'success' });
            close();
        } else {
            Notify.show({ message: (res && res.err) || 'Order failed', type: 'error' });
            paint();
        }
    });

    overlay.addEventListener('click', e => {
        if (e.target === overlay) close();
        if (e.target.closest('[data-action="order-close"]')) close();
    });
    document.addEventListener('keydown', e => {
        if (!overlay.hidden && e.key === 'Escape') close();
    });

    // "Add product from inventory" now lives in the navbar (employee mode).
    const addProductBtn = $('#order-add-product');
    if (addProductBtn) addProductBtn.addEventListener('click', () => openFoodPicker());

    function open(payload) {
        job        = payload.job;
        menu       = payload.menu || [];
        cart       = {};
        pay        = 'money';
        busy       = false;
        readOnly   = payload.readOnly === true;
        mode       = payload.mode || 'order';   // 'order' | 'shop' (UI is identical;
                                                // only the server endpoint differs)
        isEmployee = payload.employee === true && !readOnly;
        editing.clear();   // reset per-card edit toggles
        titleEl.textContent = payload.label || 'Restaurant';

        // Stale toggle pill from earlier versions — remove if present.
        const oldPill = $('#order-emp-toggle');
        if (oldPill) oldPill.remove();
        const cartPanel = overlay.querySelector('.order-cart');
        if (cartPanel) cartPanel.style.display = '';

        // Shop mode pays from society funds — Cash/Card makes no sense
        const payEl = overlay.querySelector('.order-pay');
        if (payEl) payEl.style.display = mode === 'shop' ? 'none' : '';

        // Eyebrow text mirrors the mode
        const eyebrow = overlay.querySelector('.order-eyebrow');
        if (eyebrow) eyebrow.textContent = readOnly ? 'View menu' : (isEmployee ? 'Stock manager' : 'Order here');

        // Navbar "Add product from inventory" — only for employees managing stock.
        if (addProductBtn) addProductBtn.hidden = !isEmployee;

        // Style only applies to the VIEW MENU (read-only). The transactional
        // Order Here is intentionally fixed (grid/dark) for a clean shop UX —
        // the boss's "Menu" builder is meant to design the ementa, not the cart.
        const shell = overlay.querySelector('.order-shell');
        const logoEl = $('#order-logo');
        if (readOnly) {
            const style = payload.style || { layout: 'grid', theme: 'dark' };
            const hasLogo = !!style.logo;
            shell.className = 'order-shell read-only layout-' + (style.layout || 'grid') + ' theme-' + (style.theme || 'dark') + (hasLogo ? ' has-logo' : '');
            shell.style.setProperty('--ementa-accent', style.accent || (ApexUI.theme && ApexUI.theme.brand) || '#1F5EFF');
            if (hasLogo) {
                logoEl.src = style.logo;
                logoEl.hidden = false;
            } else {
                logoEl.hidden = true;
            }
        } else {
            shell.className = 'order-shell layout-grid theme-dark';
            shell.style.removeProperty('--ementa-accent');
            logoEl.hidden = true;
        }

        $$('.order-pay-btn').forEach(b => b.classList.toggle('active', b.dataset.pay === 'money'));
        renderGallery();
        paint();
        overlay.hidden = false;
        resetScroll(overlay);
    }
    function close() { overlay.hidden = true; post('order_close') }

    return { open };
})();

// ════════════════════════════════════════════════════════════
// REGISTER  (point-of-sale terminal)
// ════════════════════════════════════════════════════════════
const Register = (() => {
    const overlay   = $('#register-overlay');
    const amountEl  = $('#register-amount');
    const titleEl   = $('#register-title');
    const chargeBtn = $('#register-charge-btn');
    const chargeLbl = $('#register-charge-label');
    const currencyEl= $('#register-currency');
    const customerList = $('#register-customers');
    const refreshBtn   = $('#register-customers-refresh');

    // Internal numeric value (cents to avoid float drift)
    let cents     = 0;
    let payment   = 'money';
    let job       = null;
    let busy      = false;
    let targetId  = null;    // selected customer (server id)
    let nearby    = [];      // [{ id, name, distance }]

    function fmt() {
        const whole = Math.floor(cents / 100);
        const frac  = (cents % 100).toString().padStart(2, '0');
        return whole.toLocaleString() + '.' + frac;
    }
    function fmtWithCurrency() {
        const cur = ApexUI.currency || { symbol: '$', position: 'before' };
        return cur.position === 'after' ? fmt() + ' ' + cur.symbol : cur.symbol + fmt();
    }
    function paint() {
        // Currency symbol on the LCD
        const cur = ApexUI.currency || { symbol: '$', position: 'before' };
        if (currencyEl) {
            currencyEl.textContent = cur.symbol;
            currencyEl.style.order = cur.position === 'after' ? '2' : '0';
        }
        amountEl.textContent = fmt();
        chargeLbl.textContent = cents > 0 ? `Charge ${fmtWithCurrency()}` : 'Charge customer';
        chargeBtn.disabled = cents <= 0 || busy || !targetId;
        chargeBtn.style.opacity = chargeBtn.disabled ? '.5' : '1';
    }

    // ── Numpad input ──────────────────────────────────
    function pressDigit(d) {
        if (cents >= 100_000_000) return;
        cents = (cents * 10 + parseInt(d, 10));
        paint();
    }
    function pressDouble() { pressDigit(0); pressDigit(0); }
    function pressBack()   { cents = Math.floor(cents / 10); paint(); }
    function pressClear()  { cents = 0; paint(); }
    function quickAdd(v)   { cents += (parseInt(v, 10) * 100); paint(); }

    $('#register-pad').addEventListener('click', e => {
        const b = e.target.closest('[data-k]');
        if (!b) return;
        const k = b.dataset.k;
        if (k === '←') return pressBack();
        if (k === '00') return pressDouble();
        if (/^\d$/.test(k)) return pressDigit(k);
    });
    $('#register-quick').addEventListener('click', e => {
        const b = e.target.closest('[data-add]');
        if (b) quickAdd(b.dataset.add);
    });
    overlay.addEventListener('click', e => {
        if (e.target.closest('[data-k="C"]')) pressClear();
        if (e.target.closest('[data-action="register-close"]') || e.target === overlay) close();
        const payBtn = e.target.closest('[data-pay]');
        if (payBtn) {
            payment = payBtn.dataset.pay;
            $$('.register-pay-btn').forEach(b => b.classList.toggle('active', b.dataset.pay === payment));
        }
    });

    chargeBtn.addEventListener('click', async () => {
        if (busy || cents <= 0 || !targetId) return;
        busy = true; paint();
        const amount = cents / 100;
        const res = await post('register_charge', { job, amount, payment, targetId });
        busy = false;
        if (res && res.ok) {
            Notify.show({ message: `Payment received · ${fmtWithCurrency()}`, type: 'success' });
            close();
        } else {
            Notify.show({ message: (res && res.err) || 'Payment failed', type: 'error' });
            paint();
        }
    });

    // ── Customer selection ────────────────────────────
    function renderCustomers() {
        customerList.innerHTML = '';
        if (!nearby.length) {
            customerList.appendChild(h('div', { class: 'register-empty' }, 'No customers nearby'));
            targetId = null;
            paint();
            return;
        }
        if (!targetId || !nearby.some(n => n.id === targetId)) targetId = nearby[0].id;
        nearby.forEach(p => {
            customerList.appendChild(h('button', {
                class: 'register-customer' + (p.id === targetId ? ' active' : ''),
                onclick: () => { targetId = p.id; renderCustomers(); paint(); },
            },
                h('span', { class: 'register-customer-dot' }),
                h('span', { class: 'register-customer-name' }, p.name || 'Unknown'),
                h('span', { class: 'register-customer-dist' }, p.distance.toFixed(1) + 'm'),
            ));
        });
        paint();
    }

    async function refreshCustomers() {
        if (!job) return;
        refreshBtn.classList.add('spinning');
        nearby = await post('register_get_nearby', { job }) || [];
        refreshBtn.classList.remove('spinning');
        renderCustomers();
    }
    refreshBtn.addEventListener('click', refreshCustomers);

    // Keyboard support
    document.addEventListener('keydown', e => {
        if (overlay.hidden) return;
        if (e.key === 'Escape') return close();
        if (e.key === 'Enter')  return chargeBtn.click();
        if (e.key === 'Backspace') { e.preventDefault(); return pressBack(); }
        if (/^[0-9]$/.test(e.key)) return pressDigit(e.key);
    });

    function open(payload) {
        cents = 0;
        payment = 'money';
        job = payload.job;
        targetId = null;
        nearby = [];
        titleEl.textContent = payload.label ? `${payload.label} · Register` : 'Register';
        $$('.register-pay-btn').forEach(b => b.classList.toggle('active', b.dataset.pay === 'money'));
        renderCustomers();
        paint();
        overlay.hidden = false;
        resetScroll(overlay);
        // Fetch the actual list async
        refreshCustomers();
    }
    function close() {
        overlay.hidden = true;
        post('register_close');
    }

    return { open };
})();

// ════════════════════════════════════════════════════════════
// BOSS DASHBOARD  (tablet-style modal)
// ════════════════════════════════════════════════════════════
const Boss = (() => {
    const overlay = $('#boss-overlay');
    const restName = $('#boss-rest-name');
    const dutyWarn = $('#boss-duty-warn');

    let state = null;
    let busy  = false;
    let revFilter = 'all';      // 'all' | 'register' | 'delivery' | 'customer'

    // ── Helpers ────────────────────────────────────────
    function fmtMoney(n)  { return ApexUI.fmtMoney(n); }
    function fmtHours(s)  {
        s = Math.max(0, Number(s)||0);
        const h = Math.floor(s/3600), m = Math.floor((s%3600)/60);
        if (h === 0) return m + 'm';
        return h + 'h ' + (m < 10 ? '0'+m : m);
    }
    function fmtShort(n) {
        n = Number(n)||0;
        const cur = ApexUI.currency || { symbol: '$', position: 'before' };
        const body = n >= 1000 ? (n/1000).toFixed(n>=10000?0:1) + 'k' : String(n);
        return cur.position === 'after' ? body + ' ' + cur.symbol : cur.symbol + body;
    }

    // ── Tabs ───────────────────────────────────────────
    $('#boss-tabs').addEventListener('click', e => {
        const t = e.target.closest('[data-tab]');
        if (!t) return;
        const id = t.dataset.tab;
        $$('.boss-tab').forEach(b => b.classList.toggle('active', b.dataset.tab === id));
        $$('.boss-pane').forEach(p => {
            const isActive = p.dataset.pane === id;
            p.classList.toggle('active', isActive);
            if (isActive) resetScroll(p);
        });
    });

    // ── Render: stat cards + chart + sources + duty ───
    function renderOverview(d) {
        console.log('[apex_restaurant] renderOverview', {
            funds: d.funds,
            revenue7dSum: d.revenue7dSum,
            revenue7d: d.revenue7d,
            bySource: d.bySource,
        });
        $('#stat-funds').textContent   = fmtMoney(d.funds);
        $('#stat-revenue').textContent = fmtMoney(d.revenue7dSum);
        $('#stat-online').textContent  = `${d.totals.online}/${d.totals.employees}`;
        $('#stat-hours').textContent   = fmtHours(d.totals.totalSeconds);

        renderChart($('#rev-chart'), filterDays(d.revenue7d, revFilter));
        renderSources($('#src-list'), d.bySource);
        renderDutyList($('#duty-list'), d.employees);
    }

    function filterDays(days, src) {
        if (!Array.isArray(days)) return [];
        if (!src || src === 'all') return days;
        return days.map(day => ({
            date:  day.date,
            label: day.label,
            value: (day.sources && day.sources[src]) || 0,
        }));
    }

    // Filter pill listener
    $('#rev-filter').addEventListener('click', e => {
        const pill = e.target.closest('[data-src]');
        if (!pill || !state) return;
        revFilter = pill.dataset.src;
        $$('.rev-pill').forEach(p => p.classList.toggle('active', p.dataset.src === revFilter));
        renderChart($('#rev-chart'), filterDays(state.revenue7d, revFilter));
        const sub = $('#rev-sub');
        if (sub) sub.textContent = revFilter === 'all'
            ? 'Filter to drill down by income source'
            : 'Showing revenue from: ' + revFilter;
    });

    function renderChart(svg, days) {
        // Use the SVG's REAL pixel size as the internal coordinate
        // system. That way the chart never gets stretched by the
        // viewBox/aspect-ratio mismatch — text + lines + dots stay
        // perfectly 1:1 with what the user sees.
        let rect = svg.getBoundingClientRect();
        // If we're being called while the overlay is still hidden
        // (getBoundingClientRect returns 0x0), retry after the next
        // frame when layout has settled.
        if (rect.width < 50 || rect.height < 50) {
            requestAnimationFrame(() => renderChart(svg, days));
            return;
        }
        const W = Math.round(rect.width);
        const H = Math.round(rect.height);
        const pad = { top: 28, right: 24, bottom: 34, left: 40 };
        days = Array.isArray(days) ? days : [];

        const root    = getComputedStyle(document.documentElement);
        const brand   = (root.getPropertyValue('--brand-500') || '#1F5EFF').trim() || '#1F5EFF';
        const brand4  = (root.getPropertyValue('--brand-400') || brand).trim() || brand;
        const text1   = (root.getPropertyValue('--text-1') || '#F4F4F5').trim();
        const text3   = (root.getPropertyValue('--text-3') || '#7C7C82').trim();
        const text4   = (root.getPropertyValue('--text-4') || '#565659').trim();
        const line1   = (root.getPropertyValue('--line-1') || '#1F1F21').trim();
        const surface = (root.getPropertyValue('--surface-1') || '#0A0A0B').trim();

        // viewBox = real pixel box; do NOT stretch.
        svg.setAttribute('viewBox', `0 0 ${W} ${H}`);
        svg.setAttribute('preserveAspectRatio', 'none');
        svg.style.width  = '100%';
        svg.style.height = '100%';

        if (days.length === 0 || days.every(d => !Number(d.value))) {
            svg.innerHTML = `<text x="${W/2}" y="${H/2}" text-anchor="middle" fill="${text3}" font-size="12" font-family="Inter, sans-serif" font-style="italic">No revenue logged in the last 7 days</text>`;
            return;
        }

        // Compute Y axis with a "nice" rounded max so the grid reads cleanly
        const rawMax = Math.max(1, ...days.map(d => Number(d.value) || 0));
        const niceMax = (() => {
            const exp = Math.pow(10, Math.floor(Math.log10(rawMax)));
            const m   = rawMax / exp;
            const n   = m <= 1 ? 1 : m <= 2 ? 2 : m <= 5 ? 5 : 10;
            return n * exp;
        })();

        const innerW = W - pad.left - pad.right;
        const innerH = H - pad.top - pad.bottom;
        const slot   = innerW / (days.length - 1 || 1);
        const todayIdx = days.length - 1;

        // Build the (x, y) for each point
        const points = days.map((day, i) => {
            const v = Number(day.value) || 0;
            return {
                v, label: day.label,
                x: pad.left + slot * i,
                y: H - pad.bottom - (v / niceMax) * innerH,
                isToday: i === todayIdx,
            };
        });

        let html = '';

        // ── Y-axis grid lines + tick labels ─────────────
        const ticks = 4;
        for (let i = 0; i <= ticks; i++) {
            const yVal = (niceMax / ticks) * i;
            const yPx  = H - pad.bottom - (yVal / niceMax) * innerH;
            html += `<line x1="${pad.left}" y1="${yPx}" x2="${W - pad.right}" y2="${yPx}" stroke="${line1}" stroke-width="1" stroke-dasharray="${i === 0 ? '0' : '3 4'}"/>`;
            html += `<text x="${pad.left - 8}" y="${yPx + 3}" text-anchor="end" fill="${text4}" font-size="9" font-family="'JetBrains Mono', monospace">${fmtShort(yVal)}</text>`;
        }

        // ── Soft area fill under the line ───────────────
        const linePath = points.map((p, i) => (i === 0 ? 'M' : 'L') + p.x + ',' + p.y).join(' ');
        const areaPath = linePath
            + ` L ${points[points.length - 1].x},${H - pad.bottom}`
            + ` L ${points[0].x},${H - pad.bottom} Z`;
        html += `<path d="${areaPath}" fill="${brand}" fill-opacity="0.12"/>`;

        // ── The line itself (solid brand colour, no gradient) ──
        html += `<path d="${linePath}" fill="none" stroke="${brand}" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>`;

        // ── Data points + per-day labels ───────────────
        points.forEach((p, i) => {
            // White-cored dot ringed in brand (today is bigger + glowing)
            const r1 = p.isToday ? 6 : 4.5;
            const r2 = p.isToday ? 3.2 : 2.4;
            html += `<circle cx="${p.x}" cy="${p.y}" r="${r1}" fill="${brand}"${p.isToday ? ` style="filter:drop-shadow(0 0 6px ${brand})"` : ''}/>`;
            html += `<circle cx="${p.x}" cy="${p.y}" r="${r2}" fill="${surface}"/>`;

            // Value above point
            if (p.v > 0) {
                html += `<text x="${p.x}" y="${p.y - 10}" text-anchor="middle" fill="${text1}" font-weight="700" font-size="10.5" font-family="'JetBrains Mono', monospace">${fmtShort(p.v)}</text>`;
            }

            // Day label below the chart
            html += `<text x="${p.x}" y="${H - pad.bottom + 17}" text-anchor="middle" fill="${p.isToday ? text1 : text3}" font-weight="${p.isToday ? 700 : 500}" font-size="11" font-family="Inter, sans-serif">${p.label}</text>`;
            if (p.isToday) {
                html += `<circle cx="${p.x}" cy="${H - pad.bottom + 25}" r="1.6" fill="${brand4}"/>`;
            }

            // Invisible hit-target rect for hover tooltip
            const hitX = pad.left + (slot * i) - slot/2;
            html += `<rect x="${Math.max(0, hitX)}" y="${pad.top}" width="${slot}" height="${innerH}" fill="transparent">
                <title>${p.label}: ${fmtMoney(p.v)}</title>
            </rect>`;
        });

        svg.innerHTML = html;
    }

    function renderSources(root, bySource) {
        root.innerHTML = '';
        const entries = Object.entries(bySource || {});
        const total   = entries.reduce((a, [_, v]) => a + (v||0), 0);
        if (!total) {
            root.innerHTML = '<div class="duty-empty">No revenue logged yet</div>';
            return;
        }
        const brand = (getComputedStyle(document.documentElement).getPropertyValue('--brand-500') || '#1F5EFF').trim() || '#1F5EFF';
        entries.sort((a, b) => b[1] - a[1]);
        entries.forEach(([source, amount]) => {
            const pct = total ? (amount/total) * 100 : 0;
            const label = source.charAt(0).toUpperCase() + source.slice(1);
            root.appendChild(h('div', { class: 'src-row' },
                h('span', { class: `src-pill ${source}` }, label),
                h('div', { class: 'src-bar' },
                    h('div', { class: 'src-bar-fill', style: `width:${pct.toFixed(1)}%;background:${brand}` })
                ),
                h('span', { class: 'src-value' }, fmtMoney(amount)),
            ));
        });
    }

    function renderDutyList(root, employees) {
        root.innerHTML = '';
        const onDuty = (employees || []).filter(e => e.onDuty);
        if (!onDuty.length) {
            root.innerHTML = '<div class="duty-empty">No one on duty right now</div>';
            return;
        }
        onDuty.forEach(e => {
            root.appendChild(h('div', { class: 'duty-row' },
                h('span', { class: 'duty-dot' }),
                h('span', { class: 'duty-name'  }, e.name || 'Unknown'),
                h('span', { class: 'duty-grade' }, 'G' + (e.grade ?? 0)),
                h('span', { class: 'duty-hours' }, fmtHours(e.seconds)),
            ));
        });
    }

    // ── Render: employees table ───────────────────────
    function renderEmployees(d) {
        const tb = $('#emp-tbody');
        tb.innerHTML = '';
        $('#tab-employees-badge').textContent = d.totals.employees;

        if (!d.employees.length) {
            tb.appendChild(h('tr', null,
                h('td', { colspan: '5', style: 'text-align:center;color:var(--text-4);padding:32px;font-style:italic' }, 'No employees yet — use "Hire nearby" to start')
            ));
            return;
        }

        d.employees.forEach(e => {
            let statusEl;
            if (e.onDuty)      statusEl = h('span', { class: 'emp-status duty'    }, h('span', { class: 'dot' }), 'ON DUTY');
            else if (e.online) statusEl = h('span', { class: 'emp-status online'  }, h('span', { class: 'dot' }), 'ONLINE');
            else               statusEl = h('span', { class: 'emp-status offline' }, h('span', { class: 'dot' }), 'OFFLINE');

            tb.appendChild(h('tr', { class: e.online ? '' : 'offline' },
                h('td', null, statusEl),
                h('td', null,
                    h('div', { class: 'emp-name' }, e.name || '(unknown)')
                ),
                h('td', null, h('span', { class: 'emp-grade-pill' }, 'G' + (e.grade ?? 0) + (e.grade_label ? ' · ' + e.grade_label : ''))),
                h('td', { class: 'emp-hours' }, fmtHours(e.seconds)),
                h('td', { class: 'emp-actions' },
                    h('button', { class: 'emp-act emp-act-profile', title: 'View profile', onclick: () => openPlayerProfile(e) }, h('i', { class: 'fa-solid fa-id-card' })),
                    h('button', { class: 'emp-act',        title: 'Promote', onclick: () => act('promote', e.identifier) },     h('i', { class: 'fa-solid fa-arrow-up' })),
                    h('button', { class: 'emp-act',        title: 'Demote',  onclick: () => act('demote',  e.identifier) },     h('i', { class: 'fa-solid fa-arrow-down' })),
                    h('button', { class: 'emp-act danger', title: 'Fire',    onclick: () => actConfirm('fire', e.identifier, e.name) }, h('i', { class: 'fa-solid fa-user-xmark' })),
                ),
            ));
        });
    }

    // ── Player profile modal ─────────────────────────
    async function openPlayerProfile(emp) {
        const res = await post('boss_player_profile', { identifier: emp.identifier });
        // Custom overlay class — no dark backdrop, just floats over
        // the editor without dimming it. Adds body.pp-open so we can
        // neutralize the boss-overlay's own dark backdrop while the
        // profile is visible (otherwise it shows through pp's blur).
        const overlay = h('div', { class: 'pp-overlay', style: 'z-index:10500' });
        document.body.classList.add('pp-open');
        const close = () => {
            overlay.remove();
            document.body.classList.remove('pp-open');
        };
        overlay.addEventListener('click', e => { if (e.target === overlay) close(); });

        const kinds = (res && res.kinds) || {};
        const KIND_META = {
            sale:      { icon: 'bowl-food',     label: L('ui.kinds.player.sale')      },
            register:  { icon: 'cash-register', label: L('ui.kinds.player.register')  },
            delivery:  { icon: 'truck',         label: L('ui.kinds.player.delivery')  },
            cook:      { icon: 'fire',          label: L('ui.kinds.player.cook')      },
            prep:      { icon: 'utensils',      label: L('ui.kinds.player.prep')      },
            stock_in:  { icon: 'arrow-down',    label: L('ui.kinds.player.stock_in')  },
            stock_out: { icon: 'arrow-up',      label: L('ui.kinds.player.stock_out') },
            price:     { icon: 'tag',           label: L('ui.kinds.player.price')     },
            npc_buy:   { icon: 'cart-shopping', label: L('ui.kinds.player.npc_buy')   },
            deposit:   { icon: 'arrow-up',      label: L('ui.kinds.player.deposit')   },
            withdraw:  { icon: 'arrow-down',    label: L('ui.kinds.player.withdraw')  },
            hire:      { icon: 'user-plus',     label: L('ui.kinds.player.hire')      },
            fire:      { icon: 'user-xmark',    label: L('ui.kinds.player.fire')      },
            promote:   { icon: 'arrow-up',      label: L('ui.kinds.player.promote')   },
            demote:    { icon: 'arrow-down',    label: L('ui.kinds.player.demote')    },
        };
        // Title-Case any kind not in the map (so e.g. a new `bonus_pay`
        // renders as "Bonus Pay", never "bonus_pay").
        const labelFor = (k) => KIND_META[k]
            ? KIND_META[k].label
            : String(k || '').split('_')
                .map(w => w ? w.charAt(0).toUpperCase() + w.slice(1) : '')
                .join(' ');
        const iconFor = (k) => (KIND_META[k] && KIND_META[k].icon) || 'circle';
        let activeKind = null;   // null = show all

        const head = h('header', { class: 'pp-head' },
            h('div', { class: 'pp-head-avatar' }, (emp.name || '?').charAt(0).toUpperCase()),
            h('div', { class: 'pp-head-info' },
                h('div', { class: 'pp-name' }, emp.name || '(unknown)'),
                h('div', { class: 'pp-sub' },
                    h('span', { class: 'emp-grade-pill' }, 'G' + (emp.grade ?? 0) + (emp.grade_label ? ' · ' + emp.grade_label : '')),
                    h('span', null, ' · ' + (emp.identifier || '—')),
                ),
            ),
            h('button', { class: 'icon-btn', onclick: close, title: 'Close' }, h('i', { class: 'fa-solid fa-xmark' })),
        );

        const stats = h('div', { class: 'pp-stats' },
            h('div', { class: 'pp-stat' },
                h('div', { class: 'pp-stat-label' }, 'Worktime'),
                h('div', { class: 'pp-stat-value' }, fmtHours(res && res.worktime || 0)),
            ),
            h('div', { class: 'pp-stat' },
                h('div', { class: 'pp-stat-label' }, 'Revenue brought in'),
                h('div', { class: 'pp-stat-value' }, fmtMoney(res && res.totalMoney || 0)),
            ),
            h('div', { class: 'pp-stat' },
                h('div', { class: 'pp-stat-label' }, 'NPC supplies'),
                h('div', { class: 'pp-stat-value' }, '−' + fmtMoney(res && res.npcSpent || 0)),
            ),
            h('div', { class: 'pp-stat' },
                h('div', { class: 'pp-stat-label' }, 'Log entries'),
                h('div', { class: 'pp-stat-value' }, String((res && res.logs && res.logs.length) || 0)),
            ),
        );

        // Counters by kind — single horizontal row, each chip is a
        // filter button. Clicking one shows only logs of that kind;
        // clicking it again (or clicking "All") clears the filter.
        const counters = h('div', { class: 'pp-counters' });
        const logs    = (res && res.logs) || [];

        function renderLogs() {
            list.innerHTML = '';
            const filtered = activeKind ? logs.filter(l => l.kind === activeKind) : logs;
            if (filtered.length === 0) {
                list.appendChild(h('div', { class: 'pp-empty' }, activeKind
                    ? 'No entries of this type.'
                    : 'No log entries yet for this player.'));
                return;
            }
            filtered.forEach(l => {
                list.appendChild(h('div', { class: 'pp-log' },
                    h('span', { class: 'pp-log-icon' }, h('i', { class: 'fa-solid fa-' + iconFor(l.kind) })),
                    h('div', { class: 'pp-log-body' },
                        h('div', { class: 'pp-log-detail' }, l.detail || labelFor(l.kind)),
                        h('div', { class: 'pp-log-time' }, l.created_at || ''),
                    ),
                    l.amount != null && l.amount !== 0
                        ? h('div', { class: 'pp-log-amount' + (l.amount < 0 ? ' neg' : ' pos') },
                            (l.amount > 0 ? '+' : '') + fmtMoney(l.amount))
                        : h('div', { class: 'pp-log-amount neutral' }, ''),
                ));
            });
        }
        function refreshKindActive() {
            counters.querySelectorAll('.pp-kind').forEach(el => {
                el.classList.toggle('active', el.dataset.k === (activeKind || '__all'));
            });
        }

        // "All" chip first
        const allChip = h('button', { class: 'pp-kind', dataset: { k: '__all' },
            onclick: () => { activeKind = null; refreshKindActive(); renderLogs(); }
        },
            h('i', { class: 'fa-solid fa-list' }),
            h('span', null, 'All'),
            h('span', { class: 'pp-kind-count' }, logs.length),
        );
        counters.appendChild(allChip);

        Object.keys(kinds).sort().forEach(k => {
            const chip = h('button', { class: 'pp-kind', dataset: { k },
                onclick: () => {
                    activeKind = activeKind === k ? null : k;
                    refreshKindActive();
                    renderLogs();
                },
            },
                h('i', { class: 'fa-solid fa-' + iconFor(k) }),
                h('span', null, labelFor(k)),
                h('span', { class: 'pp-kind-count' }, kinds[k]),
            );
            counters.appendChild(chip);
        });

        const list = h('div', { class: 'pp-logs' });
        renderLogs();
        refreshKindActive();

        overlay.appendChild(h('div', { class: 'pp-panel' }, head, stats, counters, list));
        document.body.appendChild(overlay);
        resetScroll(overlay);
    }

    // ── Render: finances tab ──────────────────────────
    function renderFinances(d) {
        console.log('[apex_restaurant] renderFinances revenue7d=', d.revenue7d, 'expenses=', d.expenses);
        $('#treasury-value').textContent = fmtMoney(d.funds);
        const root = $('#rev-days');
        root.innerHTML = '';
        const days = Array.isArray(d.revenue7d) ? d.revenue7d : [];
        // Resolve brand from CSS so the bar colour always reflects
        // the current theme.
        const cs    = getComputedStyle(document.documentElement);
        const brand = (cs.getPropertyValue('--brand-500') || '#1F5EFF').trim() || '#1F5EFF';
        if (days.length === 0) {
            root.appendChild(h('div', { class: 'rev-empty', style: 'color:var(--text-3);text-align:center;padding:18px;font-size:12px' },
                'No revenue logged in the last 7 days'));
            renderExpenses(d.expenses || []);
            return;
        }
        const max = Math.max(1, ...days.map(x => Number(x.value) || 0));
        days.forEach(day => {
            const value = Number(day.value) || 0;
            root.appendChild(h('div', { class: 'rev-day' },
                h('span', { class: 'rev-day-label' }, day.label || '—'),
                h('div',  { class: 'rev-day-bar' },
                    h('div', { class: 'rev-day-fill', style: `width:${(value/max)*100}%;background:${brand}` })
                ),
                h('span', { class: 'rev-day-value' }, fmtMoney(value)),
            ));
        });
        renderExpenses(d.expenses || []);
    }

    function renderExpenses(rows) {
        const root = $('#exp-list');
        root.innerHTML = '';
        if (!rows.length) {
            root.appendChild(h('div', { class: 'exp-empty' }, 'No expenses logged yet'));
            return;
        }
        const SRC_LABEL = { npc_shop: 'Supplies', withdraw: 'Withdraw' };
        rows.forEach(e => {
            root.appendChild(h('div', { class: 'exp-row' },
                h('span', { class: `exp-pill ${e.source || 'unknown'}` }, SRC_LABEL[e.source] || e.source || '—'),
                h('span', { class: 'exp-detail' }, e.detail || '—'),
                h('span', { class: 'exp-amount' }, '−' + fmtMoney(e.amount)),
                h('span', { class: 'exp-actor' }, (e.actor || '').slice(0, 18)),
            ));
        });
    }

    // ── Logs tab ──────────────────────────────────────
    let logsFilter = '';
    const KIND_META = {
        sale:      { icon: 'bowl-food',       label: L('ui.kinds.logs.sale')      },
        register:  { icon: 'cash-register',   label: L('ui.kinds.logs.register')  },
        delivery:  { icon: 'truck-fast',      label: L('ui.kinds.logs.delivery')  },
        cook:      { icon: 'fire',            label: L('ui.kinds.logs.cook')      },
        prep:      { icon: 'utensils',        label: L('ui.kinds.logs.prep')      },
        stock_in:  { icon: 'arrow-down',      label: L('ui.kinds.logs.stock_in')  },
        stock_out: { icon: 'arrow-up',        label: L('ui.kinds.logs.stock_out') },
        price:     { icon: 'tag',             label: L('ui.kinds.logs.price')     },
        npc_buy:   { icon: 'cart-shopping',   label: L('ui.kinds.logs.npc_buy')   },
        hire:      { icon: 'user-plus',       label: L('ui.kinds.logs.hire')      },
        fire:      { icon: 'user-xmark',      label: L('ui.kinds.logs.fire')      },
        promote:   { icon: 'arrow-up',        label: L('ui.kinds.logs.promote')   },
        demote:    { icon: 'arrow-down',      label: L('ui.kinds.logs.demote')    },
        deposit:   { icon: 'sack-dollar',     label: L('ui.kinds.logs.deposit')   },
        withdraw:  { icon: 'sack-dollar',     label: L('ui.kinds.logs.withdraw')  },
    };

    async function loadLogs() {
        if (!state) return;
        const root = $('#logs-list');
        root.innerHTML = `<div class="exp-empty">${L('ui.boss.logs.loading')}</div>`;
        const res = await post('boss_logs', { kind: logsFilter, limit: 100 });
        if (!res || !res.rows) {
            root.innerHTML = '<div class="exp-empty">Failed to load logs</div>';
            return;
        }
        renderLogs(res.rows);
    }

    function renderLogs(rows) {
        const root = $('#logs-list');
        root.innerHTML = '';
        if (!rows.length) {
            root.appendChild(h('div', { class: 'exp-empty' }, 'No activity yet'));
            return;
        }
        rows.forEach(r => {
            const meta = KIND_META[r.kind] || { icon: 'circle-info', label: r.kind };
            const row = h('div', { class: 'logs-row' },
                h('div', { class: 'logs-icon' }, h('i', { class: `fa-solid fa-${meta.icon}` })),
                h('div', { class: 'logs-body' },
                    h('div', { class: 'logs-line1' },
                        h('span', { class: 'logs-kind' }, meta.label),
                        r.amount != null ? h('span', {
                            class: 'logs-amount ' + ((r.amount || 0) >= 0 ? 'in' : 'out')
                        }, ((r.amount || 0) >= 0 ? '+' : '−') + fmtMoney(Math.abs(r.amount || 0))) : null
                    ),
                    h('div', { class: 'logs-detail' }, r.detail || '—'),
                    h('div', { class: 'logs-meta' },
                        h('span', null, r.actorName || r.actor || 'system'),
                        h('span', null, formatLogDate(r.when_))
                    )
                )
            );
            root.appendChild(row);
        });
    }

    function formatLogDate(s) {
        // server gives 'YYYY-MM-DD HH:MM:SS' (UTC-ish). Trim seconds.
        if (!s) return '';
        const m = String(s).match(/^(\d{4}-\d{2}-\d{2}) (\d{2}:\d{2})/);
        return m ? (m[1] + ' ' + m[2]) : String(s);
    }

    $('#logs-filter').addEventListener('click', e => {
        const pill = e.target.closest('[data-kind]');
        if (!pill) return;
        logsFilter = pill.dataset.kind || '';
        $$('#logs-filter .rev-pill').forEach(p =>
            p.classList.toggle('active', (p.dataset.kind || '') === logsFilter));
        loadLogs();
    });
    $('#logs-refresh').addEventListener('click', loadLogs);

    // When the Logs tab is opened, fetch the latest
    $('#boss-tabs').addEventListener('click', e => {
        const t = e.target.closest('[data-tab]');
        if (t && t.dataset.tab === 'logs') loadLogs();
    });

    // ── Apply payload everywhere ──────────────────────
    function apply(d) {
        state = d;
        restName.textContent = d.restaurant.label || d.restaurant.name;
        dutyWarn.hidden = d.dutyEnabled === true;
        renderOverview(d);
        renderEmployees(d);
        renderFinances(d);
        // Menu + Recipes builders mirror persisted state on each load.
        // (Recipes used to skip this step, which is why the boss menu
        // showed an empty Recipes tab even when MySQL had rows.)
        Menu.rehydrate(d.menu || [], d.menuStyle || { layout: 'grid', theme: 'dark', accent: '#1F5EFF' });
        Recipes.rehydrate(d.recipes || { preparation: [], grill: [], assembly: [], fryer: [], drinks: [], coffee: [] });
        $('#tab-menu-badge').textContent = (d.menu || []).length;
    }

    // ── Actions ───────────────────────────────────────
    async function act(action, identifier) {
        if (busy) return; busy = true;
        const res = await post('boss_employee_action', { action, identifier });
        busy = false;
        if (res && res.ok === false) Notify.show({ message: res.err || 'Action failed', type: 'error' });
    }
    function actConfirm(action, identifier, name) {
        confirmDanger({
            title: action === 'fire' ? 'Fire employee?' : 'Confirm',
            content: `Are you sure you want to ${action} ${name || identifier}? This cannot be undone.`,
            confirmLabel: 'Confirm',
        }).then(yes => { if (yes) act(action, identifier); });
    }

    // Lightweight inline danger confirm (reused for hire too if needed)
    function confirmDanger({ title, content, confirmLabel }) {
        return new Promise(resolve => {
            const overlay = h('div', { class: 'modal-overlay', style: 'z-index:10500' });
            const cancel  = h('button', { class: 'btn btn-ghost',  onclick: () => done(false) }, 'Cancel');
            const ok      = h('button', { class: 'btn btn-danger', onclick: () => done(true)  }, confirmLabel || 'Confirm');
            overlay.appendChild(h('div', { class: 'alert-panel' },
                h('div', { class: 'alert-title' }, title),
                h('div', { class: 'alert-content' }, content),
                h('div', { class: 'alert-actions' }, cancel, ok),
            ));
            overlay.addEventListener('click', e => { if (e.target === overlay) done(false); });
            document.body.appendChild(overlay);
            function done(v) { overlay.remove(); resolve(v); }
            setTimeout(() => ok.focus(), 50);
        });
    }

    // ── Hire / deposit / withdraw bindings ────────────
    $('#boss-hire-btn').addEventListener('click', async () => {
        if (busy) return; busy = true;
        const res = await post('boss_hire');
        busy = false;
        if (res && res.ok === false) Notify.show({ message: res.err || 'Hire failed', type: 'error' });
        else                          Notify.show({ message: 'Employee hired',         type: 'success' });
    });

    async function money(action) {
        const amount = parseInt($('#money-amount').value, 10);
        if (!amount || amount <= 0) return Notify.show({ message: 'Enter a valid amount', type: 'warning' });
        if (busy) return; busy = true;
        const res = await post('boss_' + action, { amount });
        busy = false;
        if (res && res.ok)  { Notify.show({ message: (action === 'deposit' ? 'Deposited ' : 'Withdrew ') + fmtMoney(amount), type: 'success' }); $('#money-amount').value = ''; }
        else                Notify.show({ message: (res && res.err) || (action + ' failed'), type: 'error' });
    }
    $('#btn-deposit').addEventListener('click',  () => money('deposit'));
    $('#btn-withdraw').addEventListener('click', () => money('withdraw'));

    $('#boss-refresh').addEventListener('click', () => post('boss_refresh'));

    overlay.addEventListener('click', e => {
        if (e.target === overlay) close();
        if (e.target.closest('[data-action="boss-close"]')) close();
    });

    // ════════════════════════════════════════════════════════
    // Menu builder (Menu tab) — items + layout + live preview
    // ════════════════════════════════════════════════════════
    const Menu = (() => {
        const itemsRoot = $('#mb-items');
        const countEl   = $('#mb-items-count');
        const preview   = $('#mb-preview');

        let draft = { items: [], style: { layout: 'grid', theme: 'dark', accent: '#1F5EFF' } };
        let dirty = false;

        function rehydrate(items, style) {
            // Calories are always read from the live catalogue
            // (items.lua) so changing a kcal value there propagates
            // without forcing the boss to re-save every menu.
            const calFor = (name) => {
                const c = catalog().find(x => x.name === name);
                return c && Number(c.calories) || 0;
            };
            draft = {
                items: (items || []).map(it => ({
                    name: it.name, label: it.label || it.name,
                    price: Number(it.price) || 0,
                    calories: calFor(it.name),
                })),
                style: {
                    layout: (style && style.layout) || 'grid',
                    theme:  (style && style.theme)  || 'dark',
                    accent: (style && style.accent) || '#1F5EFF',
                    logo:   (style && style.logo)   || null,
                },
            };
            dirty = false;
            renderItems();
            syncStyleButtons();
            renderLogo();
            renderPreview();
        }

        function catalog() { return ApexUI.items || [] }

        function renderItems() {
            itemsRoot.innerHTML = '';
            countEl.textContent = draft.items.length;
            if (!draft.items.length) {
                itemsRoot.appendChild(h('div', { class: 'mb-empty' }, 'No items yet — click below to add some'));
                renderPreview();
                return;
            }
            draft.items.forEach((it, idx) => {
                const img = h('img', { src: ApexUI.itemImage ? ApexUI.itemImage(it.name) : '', alt: '', onerror: 'this.style.opacity=.25' });
                // Inferred image (catalog lookup or convention <name>.png)
                const c = catalog().find(x => x.name === it.name);
                img.src = (c && c.image) || '';

                // Name select (from catalog)
                const sel = h('select', { class: 'apex-select' },
                    ...catalog().map(opt => h('option', { value: opt.name, ...(opt.name === it.name ? { selected: true } : {}) }, opt.label))
                );
                sel.addEventListener('change', () => {
                    const next = catalog().find(x => x.name === sel.value);
                    if (!next) return;
                    it.name = next.name;
                    it.label = next.label;
                    if (!it.price) it.price = next.price || 0;
                    // Calories auto-track the item — boss can't edit.
                    it.calories = Number(next.calories) || 0;
                    img.src = next.image || '';
                    calBadge.textContent = (it.calories || 0) + ' cal';
                    dirty = true; renderPreview();
                });

                const price = h('input', { class: 'apex-input', type: 'number', min: 0, value: it.price });
                price.addEventListener('input', () => { it.price = Number(price.value) || 0; dirty = true; renderPreview(); });

                // Calories are read-only — sourced from shared/items.lua.
                const calBadge = h('div', { class: 'mb-cal-badge', title: 'Calories — auto from items.lua' },
                    h('i', { class: 'fa-solid fa-fire' }),
                    ' ' + (it.calories || 0) + ' cal'
                );

                const del = h('span', { class: 'mb-del', title: 'Remove', onclick: () => {
                    draft.items.splice(idx, 1); dirty = true; renderItems();
                } }, h('i', { class: 'fa-solid fa-xmark' }));

                itemsRoot.appendChild(h('div', { class: 'mb-item' }, img, sel, price, calBadge, del));
            });
            renderPreview();
        }

        function syncStyleButtons() {
            $$('.mb-layout').forEach(b => b.classList.toggle('active', b.dataset.layout === draft.style.layout));
            $$('.mb-theme').forEach(b  => b.classList.toggle('active', b.dataset.theme  === draft.style.theme));
            // Accent inputs
            const aIn  = $('#mb-accent-input');
            const aHex = $('#mb-accent-hex');
            const aSw  = aIn && aIn.parentElement;
            if (aIn)  aIn.value = draft.style.accent;
            if (aHex) aHex.textContent = (draft.style.accent || '').toUpperCase();
            if (aSw)  aSw.style.setProperty('--_c', draft.style.accent);
            $$('.mb-color-presets button').forEach(b => b.classList.toggle('active', b.dataset.c && b.dataset.c.toLowerCase() === (draft.style.accent || '').toLowerCase()));
        }

        // ── Logo handling ────────────────────────────────
        function renderLogo() {
            const prev = $('#mb-logo-preview');
            const urlIn = $('#mb-logo-url');
            const hint  = $('#mb-logo-hint');
            if (draft.style.logo) {
                prev.innerHTML = '';
                prev.appendChild(h('img', { src: draft.style.logo, alt: '' }));
                // Show the URL in the input only if it isn't a base64 blob
                urlIn.value = draft.style.logo.startsWith('data:') ? '' : draft.style.logo;
                hint.classList.remove('err');
                hint.innerHTML = draft.style.logo.startsWith('data:')
                    ? 'Uploaded image (saved with the menu)'
                    : 'Linked from i.ibb.co';
            } else {
                prev.innerHTML = '<i class="fa-regular fa-image"></i><span>No logo</span>';
                urlIn.value = '';
                hint.classList.remove('err');
                hint.innerHTML = 'URL from <code>i.ibb.co</code> or upload an image (max 500&nbsp;KB)';
            }
        }
        function setLogoUrl(u) {
            const hint = $('#mb-logo-hint');
            u = (u || '').trim();
            if (!u) {
                draft.style.logo = null; dirty = true; renderLogo(); renderPreview(); return;
            }
            if (!u.startsWith('https://i.ibb.co/')) {
                hint.classList.add('err');
                hint.textContent = 'Only https://i.ibb.co URLs are allowed.';
                return;
            }
            draft.style.logo = u; dirty = true; renderLogo(); renderPreview();
        }

        $('#mb-logo-url').addEventListener('change', e => setLogoUrl(e.target.value));
        $('#mb-logo-clear-btn').addEventListener('click', () => { draft.style.logo = null; dirty = true; renderLogo(); renderPreview(); });
        $('#mb-logo-upload-btn').addEventListener('click', () => $('#mb-logo-file').click());
        $('#mb-logo-file').addEventListener('change', e => {
            const f = e.target.files && e.target.files[0];
            if (!f) return;
            const hint = $('#mb-logo-hint');
            if (f.size > 500 * 1024) {
                hint.classList.add('err');
                hint.textContent = 'File is too large (' + Math.round(f.size/1024) + ' KB). Max 500 KB.';
                e.target.value = '';
                return;
            }
            if (!/^image\//.test(f.type)) {
                hint.classList.add('err');
                hint.textContent = 'Only image files are accepted.';
                e.target.value = '';
                return;
            }
            const fr = new FileReader();
            fr.onload = () => {
                draft.style.logo = fr.result;
                dirty = true;
                renderLogo();
                renderPreview();
            };
            fr.readAsDataURL(f);
            e.target.value = '';
        });

        // ── Accent colour ─────────────────────────────────
        const ACCENT_PRESETS = ['#1F5EFF','#8B5CF6','#EC4899','#EF4444','#F97316','#22C55E','#06B6D4','#EAB308'];
        function buildAccentPresets() {
            const root = $('#mb-color-presets');
            if (!root) return;
            root.innerHTML = '';
            ACCENT_PRESETS.forEach(c => {
                root.appendChild(h('button', {
                    style: '--_c:' + c,
                    dataset: { c },
                    onclick: () => { draft.style.accent = c; dirty = true; syncStyleButtons(); renderPreview(); },
                }));
            });
        }
        buildAccentPresets();
        $('#mb-accent-input').addEventListener('input', e => {
            draft.style.accent = e.target.value;
            dirty = true; syncStyleButtons(); renderPreview();
        });
        $('#mb-accent-reset').addEventListener('click', () => {
            draft.style.accent = '#1F5EFF'; dirty = true; syncStyleButtons(); renderPreview();
        });

        // Preview renders the SAME DOM as the actual view menu (order-shell
        // read-only) — so what the boss sees is 1:1 what customers see.
        // We scale it down via CSS so it fits the preview pane.
        function renderPreview() {
            preview.className = `mb-preview`;
            preview.style.setProperty('--ementa-accent', draft.style.accent || '#1F5EFF');

            const shell = h('div', {
                class: `order-shell read-only layout-${draft.style.layout} theme-${draft.style.theme}${draft.style.logo ? ' has-logo' : ''} mb-preview-shell`,
                style: '--ementa-accent:' + (draft.style.accent || '#1F5EFF'),
            });

            // Header
            const head = h('header', { class: 'order-head' });
            if (draft.style.logo) {
                head.appendChild(h('img', { class: 'order-logo', src: draft.style.logo, alt: '' }));
            }
            const r = state && state.restaurant;
            const restName = (r && (r.label || r.name)) || 'Restaurant';
            const headLeft = h('div', { class: 'order-head-left' },
                h('div', null,
                    h('div', { class: 'order-eyebrow' }, 'View menu'),
                    h('div', { class: 'order-title' }, restName)
                )
            );
            head.appendChild(headLeft);
            shell.appendChild(head);

            const body = h('main', { class: 'order-body' });
            const gallery = h('section', { class: 'order-gallery' });

            if (!draft.items.length) {
                gallery.appendChild(h('div', {
                    style: 'text-align:center;color:var(--text-3);padding:40px 0;font-size:11px;opacity:.7',
                }, 'Add menu items to see them here'));
            } else {
                draft.items.forEach(it => {
                    const c = catalog().find(x => x.name === it.name);
                    // Same image + local fallback as the live ementa, so the
                    // preview shows the exact same dish picture.
                    const fb  = 'nui://apex_restaurant/build/html/img/' + (it.name || 'restaurant_food') + '.png';
                    const img = (c && c.image) || fb;
                    // Keep DOM identical to the live ementa (renderGallery):
                    // .order-card-foot must live INSIDE .order-card-body so the
                    // grid CSS places price on the same row as the label.
                    const card = h('div', { class: 'order-card' },
                        h('div', { class: 'order-card-img', style: 'position:relative' },
                            h('img', { src: img, alt: '', 'data-fb': fb, onerror: "this.onerror=null;this.src=this.dataset.fb" })),
                        h('div', { class: 'order-card-body' },
                            h('div', { class: 'order-card-label' }, it.label),
                            it.calories ? h('div', { class: 'order-card-desc' }, it.calories + ' cal') : null,
                            h('div', { class: 'order-card-foot' },
                                h('span', { class: 'order-card-price' }, ApexUI.fmtMoney(it.price))
                            )
                        )
                    );
                    gallery.appendChild(card);
                });
            }
            body.appendChild(gallery);
            shell.appendChild(body);

            preview.innerHTML = '';
            preview.appendChild(shell);
        }

        // Bind layout/theme pickers
        $('#mb-layouts').addEventListener('click', e => {
            const b = e.target.closest('[data-layout]'); if (!b) return;
            draft.style.layout = b.dataset.layout;
            dirty = true; syncStyleButtons(); renderPreview();
        });
        $('#mb-themes').addEventListener('click', e => {
            const b = e.target.closest('[data-theme]'); if (!b) return;
            draft.style.theme = b.dataset.theme;
            dirty = true; syncStyleButtons(); renderPreview();
        });

        $('#mb-add').addEventListener('click', () => {
            const first = catalog()[0] || { name: 'restaurant_food', label: 'Food', price: 5, calories: 0 };
            // calories auto-sourced from the item catalogue (items.lua)
            draft.items.push({
                name:     first.name,
                label:    first.label,
                price:    first.price || 5,
                calories: Number(first.calories) || 0,
            });
            dirty = true; renderItems();
        });

        $('#menu-discard').addEventListener('click', () => {
            if (!state) return;
            rehydrate(state.menu, state.menuStyle);
            Notify.show({ message: 'Changes discarded', type: 'info' });
        });

        $('#menu-save').addEventListener('click', async () => {
            const res = await post('boss_save_menu', { menu: draft.items, style: draft.style });
            if (res && res.ok) {
                Notify.show({ message: 'Menu saved & broadcast', type: 'success' });
                dirty = false;
            } else {
                Notify.show({ message: (res && res.err) || 'Save failed', type: 'error' });
            }
        });

        return { rehydrate };
    })();

    // ════════════════════════════════════════════════════════
    // Recipes builder (Recipes tab) — preparation + 4 stations
    // ════════════════════════════════════════════════════════
    const Recipes = (() => {
        const STATIONS = ['preparation', 'grill', 'assembly', 'fryer', 'drinks', 'coffee'];
        let subtab = 'preparation';
        let draft  = { preparation: [], grill: [], assembly: [], fryer: [], drinks: [], coffee: [] };

        // Each "slot" (input/output/ingredient/result) is restricted to a
        // sensible category list so the boss only sees relevant items.
        // The current value is always added back to the options so legacy
        // data is never lost.
        const CAT_FILTER = {
            preparation: {
                input:  ['raw', 'vegetable', 'fruit'],
                output: ['cutted'],
            },
            grill: {
                // Grilling = patties only. Inputs are cut/raw, output
                // is a patty (cutted category for the grilled patty
                // items: grilled_burger, grilled_chicken_burger).
                ingredients: ['cutted', 'raw'],
                result:      ['cutted', 'food'],
            },
            assembly: {
                // Combines a patty + bun + cut veg into a finished dish.
                ingredients: ['cutted', 'vegetable', 'raw', 'food'],
                result:      ['food'],
            },
            fryer: {
                ingredients: ['cutted', 'raw'],
                result:      ['food'],
            },
            drinks: {
                ingredients: ['drink', 'cutted', 'fruit', 'universal'],
                result:      ['drink'],
            },
            coffee: {
                ingredients: ['drink', 'universal'],
                result:      ['drink'],
            },
        };

        // Sensible defaults so the freshly-added recipe HAS a valid item
        // (image renders immediately, no need to pick one first).
        const DEFAULTS = {
            preparation: { input: 'meat',           output: 'cutted_meat' },
            grill:       { result: 'grilled_burger', ingredients: { cutted_meat: 1 } },
            assembly:    { result: 'cheeseburger',   ingredients: { grilled_burger: 1, bread_bun: 1, cutted_lettuce: 1 } },
            fryer:       { result: 'fries',          ingredients: { cutted_potato: 1 } },
            drinks:      { result: 'cola',           ingredients: { empty_cup: 1 } },
            coffee:      { result: 'coffe',          ingredients: { empty_cup: 1, coffee_beans: 1 } },
        };

        function catalog() { return ApexUI.items || [] }
        function imageOf(name) {
            const c = catalog().find(x => x.name === name);
            return (c && c.image) || '';
        }
        function labelOf(name) {
            const c = catalog().find(x => x.name === name);
            return (c && c.label) || name || '';
        }
        // Filter items by category list; always keep the current value visible
        function filteredCatalog(allowedCats, currentValue) {
            const cats = new Set(allowedCats || []);
            const list = catalog().filter(it => cats.size === 0 || cats.has(it.category));
            if (currentValue && !list.some(x => x.name === currentValue)) {
                const cur = catalog().find(x => x.name === currentValue)
                    || { name: currentValue, label: currentValue, image: '' };
                list.unshift(cur);
            }
            return list;
        }

        function rehydrate(rec) {
            // cjson on the server encodes an empty Lua table as `{}` (object),
            // not `[]` (array). Coerce non-arrays back to [] so the rest of
            // the UI can use `.length` / `.forEach` safely.
            const asArray = (v) => Array.isArray(v) ? v : [];
            draft = {
                preparation: asArray(rec && rec.preparation),
                grill:       asArray(rec && rec.grill),
                assembly:    asArray(rec && rec.assembly),
                fryer:       asArray(rec && rec.fryer),
                drinks:      asArray(rec && rec.drinks),
                coffee:      asArray(rec && rec.coffee),
            };
            // Total count for tab badge
            const total = STATIONS.reduce((s, k) => s + draft[k].length, 0);
            $('#tab-recipes-badge').textContent = total;
            renderList();
        }

        function totalIngredients(rs) {
            return rs.reduce((s, r) => s + Object.keys(r.ingredients || {}).length, 0);
        }

        // ── List + ingredient editors ─────────────────────
        function renderList() {
            const root = $('#rb-recipes');
            root.innerHTML = '';
            $('#rb-section-title').textContent =
                subtab === 'preparation'
                    ? 'Preparation cuts (1 input → 1 output)'
                    : (subtab.charAt(0).toUpperCase() + subtab.slice(1)) + ' recipes (ingredients → 1 result)';

            const arr = draft[subtab];
            if (!arr.length) {
                root.appendChild(h('div', { class: 'mb-empty' }, 'No recipes yet — click "Add new recipe" below'));
                return;
            }
            arr.forEach((rec, idx) => {
                root.appendChild(renderRecipe(rec, idx));
            });
        }

        // Helper: build a select element filtered by allowed categories
        function buildItemSelect(currentValue, allowedCats, onChange) {
            const list = filteredCatalog(allowedCats, currentValue);
            const sel = h('select', { class: 'apex-select' },
                ...list.map(opt => h('option', {
                    value: opt.name,
                    ...(opt.name === currentValue ? { selected: true } : {}),
                }, opt.label || opt.name))
            );
            sel.addEventListener('change', () => onChange(sel.value));
            return sel;
        }

        function renderRecipe(rec, idx) {
            const wrap = h('div', { class: 'rb-recipe' });

            const isPrep  = subtab === 'preparation';
            const outName = isPrep ? 'output' : 'result';
            const outCats = (CAT_FILTER[subtab] && CAT_FILTER[subtab][outName]) || [];

            // Head row: image preview + output picker + delete.
            // (Time is no longer editable here — it's computed from
            // Config.times by Utils.recipeTime so more ingredients
            // automatically take longer to cook.)
            const img = h('img', { src: imageOf(rec[outName]), alt: '' });
            const sel = buildItemSelect(rec[outName], outCats, (v) => {
                rec[outName] = v;
                img.src = imageOf(v);
            });
            const del = h('span', { class: 'rb-del', onclick: () => { draft[subtab].splice(idx, 1); renderList() } }, h('i', { class: 'fa-solid fa-trash' }));

            wrap.appendChild(h('div', { class: 'rb-recipe-head' }, img, sel, del));

            // Sub: input/ingredients
            if (isPrep) {
                rec.input = rec.input || DEFAULTS.preparation.input;
                wrap.appendChild(h('div', { class: 'rb-recipe-sub' }, 'Input ingredient (raw)'));
                wrap.appendChild(renderSingleInput(rec));
            } else {
                rec.ingredients = rec.ingredients || {};
                wrap.appendChild(h('div', { class: 'rb-recipe-sub' }, 'Ingredients required'));
                wrap.appendChild(renderIngredients(rec));
                // Eat animation picker — saved on the recipe and travels
                // with the cooked item's metadata so the player gets the
                // right animation + prop when they consume it.
                wrap.appendChild(h('div', { class: 'rb-recipe-sub' }, 'Eat / drink animation'));
                wrap.appendChild(renderAnimPicker(rec));
            }
            return wrap;
        }

        function renderAnimPicker(rec) {
            const presets = window.ApexUI && ApexUI.foodAnimations || {};
            const keys    = Object.keys(presets);
            // Drop a leading "Auto" choice so the boss can fall back to
            // category default (set via Config.defaultFoodAnimByCategory).
            const opts = [{ value: '', label: 'Auto (by category)' }]
                .concat(keys.map(k => ({ value: k, label: presets[k].label || k })));
            const sel = h('select', { class: 'apex-select' },
                ...opts.map(o => h('option', {
                    value: o.value,
                    ...(o.value === (rec.anim || '') ? { selected: true } : {}),
                }, o.label))
            );
            sel.addEventListener('change', () => { rec.anim = sel.value || null; });
            return h('div', { class: 'rb-anim-row' }, sel);
        }

        function renderSingleInput(rec) {
            const wrap = h('div', { class: 'rb-ingredients' });
            const row  = h('div', { class: 'rb-ingredient' });
            const img  = h('img', { src: imageOf(rec.input), alt: '' });
            const sel  = buildItemSelect(rec.input, CAT_FILTER.preparation.input, (v) => {
                rec.input = v;
                img.src = imageOf(v);
            });
            row.append(img, sel, h('span'), h('span'));
            wrap.appendChild(row);
            return wrap;
        }

        function renderIngredients(rec) {
            const wrap = h('div', { class: 'rb-ingredients' });
            const entries = Object.entries(rec.ingredients || {});
            if (!entries.length) {
                wrap.appendChild(h('div', { style: 'font-size:11px;color:var(--text-3);padding:4px 0' }, 'No ingredients yet'));
            }
            const cats = (CAT_FILTER[subtab] && CAT_FILTER[subtab].ingredients) || [];
            entries.forEach(([name, qty]) => {
                const row = h('div', { class: 'rb-ingredient' });
                const img = h('img', { src: imageOf(name), alt: '' });
                const sel = buildItemSelect(name, cats, (newName) => {
                    if (newName === name) return;
                    delete rec.ingredients[name];
                    rec.ingredients[newName] = qty;
                    renderList();
                });
                const qtyEl = h('input', { class: 'apex-input', type: 'number', min: 1, value: qty });
                qtyEl.addEventListener('input', () => {
                    const v = Math.max(1, parseInt(qtyEl.value, 10) || 1);
                    rec.ingredients[name] = v;
                });
                const del = h('span', { class: 'rb-ing-del', onclick: () => { delete rec.ingredients[name]; renderList() } }, '×');
                row.append(img, sel, qtyEl, del);
                wrap.appendChild(row);
            });

            // Add ingredient: pick a sensible default from the allowed categories
            const add = h('button', { class: 'rb-add-ing', onclick: () => {
                const allowed = filteredCatalog(cats, null);
                const candidate = allowed[0] || catalog()[0] || { name: 'meat' };
                // Find a name not already in ingredients
                let pick = candidate.name;
                if (rec.ingredients[pick]) {
                    const alt = allowed.find(x => !rec.ingredients[x.name]);
                    if (alt) pick = alt.name;
                }
                rec.ingredients[pick] = (rec.ingredients[pick] || 0) + 1;
                renderList();
            } }, h('i', { class: 'fa-solid fa-plus' }), 'Add ingredient');
            wrap.appendChild(add);
            return wrap;
        }

        // ── Subtab navigation ─────────────────────────────
        $('#rb-subtabs').addEventListener('click', e => {
            const b = e.target.closest('[data-rb]');
            if (!b) return;
            subtab = b.dataset.rb;
            $$('.rb-subtab').forEach(x => x.classList.toggle('active', x.dataset.rb === subtab));
            renderList();
        });

        $('#rb-add').addEventListener('click', () => {
            // Use the curated DEFAULTS so the new recipe is immediately
            // valid (image renders, dropdowns are populated correctly).
            // Falls back to first allowed-category item if defaults aren't
            // present in the catalogue.
            const def = DEFAULTS[subtab] || {};
            const cats = CAT_FILTER[subtab] || {};
            const pickFor = (slot, preferred) => {
                const allowed = filteredCatalog(cats[slot] || [], null);
                if (preferred && (catalog().find(x => x.name === preferred))) return preferred;
                return (allowed[0] && allowed[0].name) || (catalog()[0] && catalog()[0].name) || 'meat';
            };

            if (subtab === 'preparation') {
                const input  = pickFor('input',  def.input);
                const output = pickFor('output', def.output);
                // No `time` — Utils.recipeTime pulls from Config.times
                draft.preparation.push({ input, output });
            } else {
                const result = pickFor('result', def.result);
                const ingredients = {};
                for (const [n, q] of Object.entries(def.ingredients || {})) {
                    // Only keep defaults present in the catalogue
                    if (catalog().find(x => x.name === n)) ingredients[n] = q;
                }
                // If no valid defaults, seed with first allowed ingredient
                if (!Object.keys(ingredients).length) {
                    const ing = pickFor('ingredients');
                    ingredients[ing] = 1;
                }
                // No `time` — Utils.recipeTime computes it as
                // cookBase + (ingredient units - 1) * cookExtra
                draft[subtab].push({ result, ingredients });
            }
            renderList();
        });

        $('#rb-discard').addEventListener('click', () => {
            rehydrate(state && state.recipes);
            Notify.show({ message: 'Recipe changes discarded', type: 'info' });
        });

        $('#rb-save').addEventListener('click', async () => {
            const res = await post('boss_save_recipes', { recipes: draft });
            if (res && res.ok) Notify.show({ message: 'Recipes saved & broadcast', type: 'success' });
            else                Notify.show({ message: (res && res.err) || 'Save failed', type: 'error' });
        });

        return { rehydrate };
    })();

    function open(payload) { apply(payload); overlay.hidden = false; resetScroll(overlay); }
    function close() { overlay.hidden = true; post('boss_close'); }

    document.addEventListener('keydown', e => {
        if (!overlay.hidden && e.key === 'Escape') close();
    });

    return { open, apply };
})();

// ════════════════════════════════════════════════════════════
// NODE EDITOR
// ════════════════════════════════════════════════════════════
const Editor = (() => {
    // ─── Node type registry ────────────────────────────────
    // A "type" describes both a button in the palette and the
    // shape of the node card the inspector renders for it.
    const TYPES = {
        restaurant:   { icon: 'utensils',         label: 'Restaurant', single: true },
        blip:         { icon: 'map-pin',          label: 'Map Blip',   single: true },
        boss:         { icon: 'briefcase',        label: 'Boss',       single: true },
        duty:         { icon: 'clock',            label: 'Duty',       single: true },
        wardrobe:     { icon: 'shirt',            label: 'Wardrobe',   single: true },
        register:     { icon: 'cash-register',    label: 'Register',   multi: true },
        preparation:  { icon: 'utensils',      label: 'Prep Table', multi: true },
        station:      { icon: 'fire',      label: 'Station',    multi: true },
        storage:      { icon: 'box',              label: 'Storage',    multi: true },
        tray:         { icon: 'bowl-food',      label: 'Tray',       multi: true },
        menuDisplay:  { icon: 'book-open',        label: 'Menu Board', multi: true },
        npcShop:      { icon: 'cart-shopping',    label: 'NPC Shop',   multi: true },
        customerShop: { icon: 'users',            label: 'Customer Ped', multi: true },
        delivery:     { icon: 'truck-fast',       label: 'Delivery',   multi: true },
    };

    // ─── State ────────────────────────────────────────────
    const state = {
        restaurants: [],   // array of restaurant objects from the server
        activeId: null,    // current restaurant id
        nodes: [],         // [{ id, type, x, y, ref }] — ref is a property bag on the restaurant
        connections: [],   // [{ from: nodeId, to: nodeId }]
        selected: null,
        zoom: 1,
        offset: { x: 0, y: 0 },
        items: [],         // item catalogue from server
        tempConn: null,    // { fromId, fromX, fromY, x, y }
    };

    // ─── DOM refs ─────────────────────────────────────────
    const root         = $('#editor-root');
    const restList     = $('#restaurant-list');
    const palette      = $('#node-palette');
    const canvasWrap   = $('#canvas-wrap');
    const nodesLayer   = $('#nodes-layer');
    const canvasSvg    = $('#canvas-svg');
    const connLayer    = $('#connections');
    const tempLayer    = $('#conn-temp');
    const canvasLayer  = $('#canvas-layer');
    const inspector    = $('#inspector-body');
    const insTitle     = $('#inspector-title');
    const insTypePill  = $('#inspector-type-pill');
    const insType      = $('#inspector-type');
    const hudZoom      = $('#hud-zoom');
    const statRest     = $('#status-rest');
    const statNodes    = $('#status-nodes');
    const statConn     = $('#status-conn');
    const statSelected = $('#status-selected');
    const restNameEl   = $('#active-rest-name');
    const restJobEl    = $('#active-rest-job');

    // ─── Open / close ─────────────────────────────────────
    function open({ restaurants, items, locale }) {
        if (locale) { ApexUI.locale = locale; applyStaticLocale(); }
        state.restaurants = (restaurants || []).map(prepareRestaurant);
        state.items       = items || [];
        if (state.restaurants.length) selectRestaurant(state.restaurants[0].id);
        else { state.activeId = null; renderAll(); }
        root.hidden = false;
        resetScroll(root);
        // Hydrate theme preferences after the shell exists
        Theme.init();
        // Snapshot the layout as the "saved" baseline so subsequent
        // edits flip the dirty flag.
        markSaved();
        _closing = false;
    }
    // ── Dirty-state tracking ──────────────────────────
    // We snapshot the restaurant list whenever it's loaded or saved.
    // A close attempt that finds a divergent snapshot prompts the user
    // before discarding their work.
    function snapshotRestaurants() {
        try { return JSON.stringify(cleanForExport()); } catch (_) { return ''; }
    }
    function markSaved() { state._savedSnapshot = snapshotRestaurants() }
    function isDirty()   { return state._savedSnapshot !== snapshotRestaurants() }

    // Re-entry guard. Lua's editor_close handler echoes an
    // 'editor_close' NUI message back to us (which re-invokes
    // Editor.close), so without this the prompt would re-open after
    // the user picks Discard or Save & close.
    let _closing = false;
    function close() {
        if (_closing) return;
        if (!isDirty()) {
            _closing = true;
            root.hidden = true;
            post('editor_close');
            return;
        }
        confirmSaveDialog().then((choice) => {
            if (choice === 'cancel') return;
            const restaurants = (choice === 'save') ? cleanForExport() : null;
            _closing = true;          // suppress the echo from Lua
            root.hidden = true;
            post('editor_close');
            if (choice === 'save' && restaurants) {
                post('editor_save', { restaurants }).then(res => {
                    if (res && res.ok) {
                        markSaved();
                        Notify.show({ message: 'Saved', type: 'success' });
                    } else {
                        Notify.show({ message: (res && res.err) || 'Save failed', type: 'error' });
                    }
                });
            } else if (choice === 'discard') {
                // Reset the dirty baseline so the next open isn't
                // stuck thinking it has pending changes.
                markSaved();
            }
        });
    }
    $('#btn-close-editor').addEventListener('click', close);

    // Three-button confirm: Save & close · Discard · Cancel.
    function confirmSaveDialog() {
        return new Promise(resolve => {
            // Use the transparent confirm overlay — no dark backdrop.
            const overlay = h('div', { class: 'confirm-overlay', style: 'z-index:11500' });
            const done = (v) => { overlay.remove(); resolve(v); };
            const cancelBtn  = h('button', { class: 'btn btn-ghost',   onclick: () => done('cancel')  }, h('i', { class: 'fa-solid fa-xmark'        }), ' ' + L('ui.editor.confirm.btn_cancel'));
            const discardBtn = h('button', { class: 'btn btn-danger',  onclick: () => done('discard') }, h('i', { class: 'fa-solid fa-trash'        }), ' ' + L('ui.editor.confirm.btn_discard'));
            const saveBtn    = h('button', { class: 'btn btn-primary', onclick: () => done('save')    }, h('i', { class: 'fa-solid fa-floppy-disk' }), ' ' + L('ui.editor.confirm.btn_save_and_close'));
            overlay.appendChild(h('div', { class: 'alert-panel save-prompt' },
                h('div', { class: 'alert-title' }, L('ui.editor.confirm.unsaved_title')),
                h('div', { class: 'alert-content' }, L('ui.editor.confirm.unsaved_body')),
                h('div', { class: 'alert-actions save-prompt-actions' }, cancelBtn, discardBtn, saveBtn),
            ));
            overlay.addEventListener('click', e => { if (e.target === overlay) done('cancel'); });
            document.body.appendChild(overlay);
        });
    }

    // Ensure incoming restaurants have ids on every nested part
    function prepareRestaurant(r) {
        r.id = r.id || uid('rest');
        ['registers','preparation','stations','storage','trays','menuDisplay'].forEach(k => {
            r[k] = r[k] || [];
            r[k].forEach(o => { o._id = o._id || uid(k); });
        });
        return r;
    }
    function uid(p) { return p + '_' + Math.random().toString(36).slice(2, 9); }

    function getActive() { return state.restaurants.find(r => r.id === state.activeId); }

    // ─── Render restaurant list (left sidebar) ────────────
    function renderRestList() {
        restList.innerHTML = '';
        state.restaurants.forEach(r => {
            const row = h('div', {
                class: `restaurant-item ${r.id === state.activeId ? 'active' : ''} ${r.enabled === false ? 'disabled' : ''}`,
                onclick: (e) => {
                    if (e.target.closest('.ri-del') || e.target.closest('.ri-wipe')) return;
                    selectRestaurant(r.id);
                },
            },
                h('span', { class: 'ri-dot' }),
                h('div', { class: 'ri-name' }, r.label || r.name || L('ui.common.no_name')),

                // Wipe-data button — clears every DB row tied to this job
                // (funds, stashes, revenue, expenses, activity, uniforms,
                // shop_stock, menus, recipes, worktime). The restaurant
                // layout itself is kept.
                h('button', {
                    class: 'ri-wipe',
                    title: L('ui.editor.row_wipe_tooltip'),
                    onclick: async (e) => {
                        e.stopPropagation();
                        if (!r.job) {
                            Notify.show({ message: L('ui.editor.no_job_set'), type: 'error' });
                            return;
                        }
                        const yes = await confirmDialog({
                            title:   L('ui.editor.confirm.wipe_title'),
                            content: L('ui.editor.confirm.wipe_body', r.job),
                            confirmLabel: L('ui.editor.confirm.wipe_btn'),
                            danger: true,
                        });
                        if (!yes) return;
                        const res = await post('editor_wipe_data', { job: r.job });
                        if (res && res.ok) {
                            Notify.show({ message: L('ui.editor.confirm.wipe_success'), type: 'success' });
                        } else {
                            Notify.show({ message: (res && res.err) || L('ui.editor.confirm.wipe_failed'), type: 'error' });
                        }
                    },
                }, h('i', { class: 'fa-solid fa-broom' })),
                h('button', {
                    class: 'ri-del',
                    title: L('ui.editor.row_delete_tooltip'),
                    onclick: async (e) => {
                        e.stopPropagation();
                        const yes = await confirmDialog({
                            title:   L('ui.editor.confirm.delete_title'),
                            content: L('ui.editor.confirm.delete_body', r.label || r.name || r.job),
                            confirmLabel: L('ui.editor.confirm.delete_btn'),
                            danger: true,
                        });
                        if (!yes) return;
                        const res = await post('editor_delete', { id: r.id });
                        if (res && res.ok) {
                            state.restaurants = state.restaurants.filter(x => x.id !== r.id);
                            if (state.activeId === r.id) {
                                state.activeId = (state.restaurants[0] && state.restaurants[0].id) || null;
                                if (state.activeId) selectRestaurant(state.activeId);
                                else { renderRestList(); state.nodes = []; state.connections = []; renderCanvas(); renderInspector(); }
                            } else {
                                renderRestList();
                            }
                            Notify.show({ message: L('ui.editor.confirm.delete_success'), type: 'success' });
                        } else {
                            Notify.show({ message: (res && res.err) || L('ui.editor.confirm.delete_failed'), type: 'error' });
                        }
                    },
                }, h('i', { class: 'fa-solid fa-trash' }))
            );
            restList.appendChild(row);
        });
        if (!state.restaurants.length) {
            restList.appendChild(h('div', { class: 'empty-hint' }, L('ui.editor.no_restaurants')));
        }
    }

    // Lightweight inline confirm dialog (reuses .alert-panel styling)
    function confirmDialog({ title, content, confirmLabel, danger = false }) {
        if (confirmLabel == null) confirmLabel = L('ui.common.confirm');
        return new Promise(resolve => {
            // Transparent overlay — used by the delete + wipe confirms.
            const overlay = h('div', { class: 'confirm-overlay', style: 'z-index:10001' });
            const cancel = h('button', { class: 'btn btn-ghost', onclick: () => done(false) }, L('ui.common.cancel'));
            const ok     = h('button', { class: `btn ${danger ? 'btn-danger' : 'btn-primary'}`, onclick: () => done(true) }, confirmLabel);
            const panel  = h('div', { class: 'alert-panel' },
                h('div', { class: 'alert-title' }, title),
                h('div', { class: 'alert-content' }, content),
                h('div', { class: 'alert-actions' }, cancel, ok)
            );
            overlay.appendChild(panel);
            overlay.addEventListener('click', e => { if (e.target === overlay) done(false); });
            document.body.appendChild(overlay);
            function done(v) { overlay.remove(); resolve(v); }
            setTimeout(() => ok.focus(), 50);
        });
    }

    // ─── Palette buttons ──────────────────────────────────
    const TYPE_COLOR_VAR = {
        blip:'blip', boss:'boss', duty:'duty', wardrobe:'wardrobe',
        register:'register', preparation:'prep', station:'station',
        storage:'storage', tray:'tray', menuDisplay:'menu',
        npcShop:'npc', customerShop:'customer', delivery:'delivery',
    };
    function renderPalette() {
        palette.innerHTML = '';
        Object.entries(TYPES).filter(([t]) => t !== 'restaurant').forEach(([t, def]) => {
            const tc = `var(--t-${TYPE_COLOR_VAR[t] || 'restaurant'})`;
            palette.appendChild(h('button', {
                class: 'palette-btn',
                title: 'Add ' + def.label + (def.single ? ' (one per restaurant)' : ''),
                style: `--_pc:${tc}`,
                onclick: () => addNodeOfType(t),
            },
                h('i', { class: `fa-solid fa-${def.icon}` }),
                h('span', null, def.label)
            ));
        });
    }

    // ─── Convert a restaurant <-> graph nodes ─────────────
    function syncNodesFromRestaurant() {
        const r = getActive();
        state.nodes = [];
        state.connections = [];
        if (!r) return;

        // Root restaurant node always in centre
        const rootNode = { id: r.id, type: 'restaurant', x: 480, y: 240, ref: r };
        state.nodes.push(rootNode);

        const grid = laneLayout(rootNode);
        const place = (type, ref, lane) => {
            const id = ref._id = ref._id || uid(type);
            const pos = grid.next(lane);
            state.nodes.push({ id, type, x: pos.x, y: pos.y, ref });
            state.connections.push({ from: rootNode.id, to: id });
        };

        // Single-instance parts (subkeys on the restaurant)
        const singles = ['blip','boss','duty','wardrobe'];
        singles.forEach((k, i) => {
            if (r[k]) place(k, r[k] = ensurePart(r[k]), 'left');
        });

        // Multi-instance arrays. customerShops / npcShops / deliveries
        // share the parent config block (r.customerShop, r.npcShop,
        // r.delivery) for things like items/garage/labels — each array
        // entry is just one physical zone (ped/coords).
        const multiMap = {
            registers:'register', preparation:'preparation', stations:'station',
            storage:'storage', trays:'tray', menuDisplay:'menuDisplay',
            customerShops:'customerShop', npcShops:'npcShop', deliveries:'delivery',
        };
        Object.entries(multiMap).forEach(([arrKey, type]) => {
            (r[arrKey] || []).forEach((it) => place(type, ensurePart(it), 'right'));
        });
    }
    function ensurePart(p) {
        p = p || {};
        if (!p.coords) p.coords = { x: 0, y: 0, z: 0 };
        p.size  = p.size  || { x: 2, y: 2, z: 2 };
        if (p.heading == null) p.heading = 0;
        return p;
    }
    function laneLayout(root) {
        const lanes = { left: { x: root.x - 320, y: root.y - 200, dy: 110 },
                        right:{ x: root.x + 320, y: root.y - 200, dy: 110 } };
        return {
            next(lane) {
                const ln = lanes[lane];
                const pos = { x: ln.x, y: ln.y };
                ln.y += ln.dy;
                return pos;
            },
        };
    }

    // ─── Persist node positions / changes back to the model
    // (positions are kept in the editor only; the persisted JSON
    //  ignores graph layout, only the actual config matters)

    // ─── Render canvas ────────────────────────────────────
    function renderCanvas() {
        nodesLayer.innerHTML = '';
        connLayer.innerHTML = '';
        tempLayer.innerHTML = '';

        state.nodes.forEach(renderNode);
        state.connections.forEach(renderConnection);

        applyTransform();
        updateStatus();
    }

    function updateStatus() {
        hudZoom.textContent     = Math.round(state.zoom * 100) + '%';
        statRest.textContent    = state.restaurants.length + (state.restaurants.length === 1 ? ' restaurant' : ' restaurants');
        statNodes.innerHTML     = '<i class="fa-solid fa-circle-nodes"></i> ' + state.nodes.length + ' nodes';
        statConn.innerHTML      = '<i class="fa-solid fa-link"></i> ' + state.connections.length + ' connections';
        const sel = state.selected ? state.nodes.find(n => n.id === state.selected) : null;
        statSelected.textContent = sel ? titleFor(sel) : 'No selection';
    }

    function renderNode(node) {
        const def = TYPES[node.type] || TYPES.station;
        const typeColor = `var(--t-${({
            restaurant:'restaurant', blip:'blip', boss:'boss', duty:'duty', wardrobe:'wardrobe',
            register:'register', preparation:'prep', station:'station', storage:'storage',
            tray:'tray', menuDisplay:'menu', npcShop:'npc', customerShop:'customer', delivery:'delivery',
        })[node.type] || 'restaurant'})`;

        const el = h('div', {
            class: `node ${state.selected === node.id ? 'selected' : ''}`,
            dataset: { type: node.type, id: node.id },
            style: `left:${node.x}px;top:${node.y}px;--type-c:${typeColor}`,
            onmousedown: e => beginDragNode(e, node, el),
            onclick: e => { e.stopPropagation(); selectNode(node.id); },
        },
            h('div', { class: 'node-head' },
                h('span', { class: 'type-icon' }, h('i', { class: `fa-solid fa-${def.icon}` })),
                h('div', { class: 'node-title' }, titleFor(node)),
                node.type !== 'restaurant' ? h('div', { class: 'node-actions' },
                    h('button', {
                        class: 'node-act', title: 'Delete node',
                        onclick: e => { e.stopPropagation(); removeNode(node); },
                    }, h('i', { class: 'fa-solid fa-xmark' }))
                ) : null,
                node.type !== 'restaurant'
                    ? h('div', { class: 'node-port in', onmousedown: e => endTempConn(e, node) })
                    : null,
                h('div', { class: 'node-port out', onmousedown: e => beginTempConn(e, node) })
            ),
            renderNodeBody(node)
        );
        nodesLayer.appendChild(el);
        node._el = el;
    }

    function titleFor(node) {
        const def = TYPES[node.type];
        if (node.type === 'restaurant') return node.ref.label || node.ref.name || 'Restaurant';
        return (node.ref && node.ref.label) ? node.ref.label : def.label;
    }

    function renderNodeBody(node) {
        const body = h('div', { class: 'node-body' });
        const r = node.ref || {};
        if (node.type === 'restaurant') {
            body.append(
                row('job',     r.job || '—'),
                row('status',  r.enabled === false ? 'disabled' : 'active')
            );
        } else if (node.type === 'blip') {
            body.append(row('sprite', r.sprite ?? 106), row('color', r.color ?? 5));
        } else if (r.coords && (r.coords.x !== undefined)) {
            const c = r.coords;
            body.append(row('coords', `${num(c.x)}, ${num(c.y)}, ${num(c.z)}`));
            if (r.heading !== undefined) body.append(row('head', num(r.heading) + '°'));
        } else {
            body.append(h('div', { class: 'node-empty' }, 'not configured'));
        }
        return body;
    }
    function row(lbl, val) {
        return h('div', { class: 'node-row' },
            h('span', { class: 'lbl' }, lbl),
            h('span', { class: 'val' }, String(val))
        );
    }
    function num(v) { return (typeof v === 'number' ? v.toFixed(2) : v ?? '—'); }

    // ─── Connections (cubic bezier) ───────────────────────
    // Node width = 200px, head-h = 32px → port centre at y+16
    function nodeOutPort(node) {
        return { x: node.x + 200 + 5, y: node.y + 16 };
    }
    function nodeInPort(node) {
        return { x: node.x - 5, y: node.y + 16 };
    }
    function renderConnection(c) {
        const a = state.nodes.find(n => n.id === c.from);
        const b = state.nodes.find(n => n.id === c.to);
        if (!a || !b) return;
        const p1 = nodeOutPort(a), p2 = nodeInPort(b);
        const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
        path.setAttribute('d', bezier(p1, p2));
        path.setAttribute('class', 'connection');
        connLayer.appendChild(path);
    }
    function bezier(p1, p2) {
        const dx = Math.max(40, Math.abs(p2.x - p1.x) * 0.5);
        return `M ${p1.x} ${p1.y} C ${p1.x + dx} ${p1.y}, ${p2.x - dx} ${p2.y}, ${p2.x} ${p2.y}`;
    }
    function renderTempConn() {
        tempLayer.innerHTML = '';
        if (!state.tempConn) return;
        const t = state.tempConn;
        const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
        path.setAttribute('d', bezier({ x: t.fromX, y: t.fromY }, { x: t.x, y: t.y }));
        path.setAttribute('class', 'connection temp');
        tempLayer.appendChild(path);
    }

    // ─── Node dragging ────────────────────────────────────
    function beginDragNode(e, node, el) {
        if (e.target.closest('.node-port')) return;
        if (e.target.closest('.node-act')) return;
        if (e.button !== 0) return;
        e.stopPropagation();
        el.classList.add('dragging');
        const sx = e.clientX, sy = e.clientY;
        const ox = node.x, oy = node.y;
        function move(ev) {
            node.x = ox + (ev.clientX - sx) / state.zoom;
            node.y = oy + (ev.clientY - sy) / state.zoom;
            el.style.left = node.x + 'px';
            el.style.top  = node.y + 'px';
            // Repaint connections only (cheap)
            connLayer.innerHTML = '';
            state.connections.forEach(renderConnection);
        }
        function up() {
            el.classList.remove('dragging');
            document.removeEventListener('mousemove', move);
            document.removeEventListener('mouseup', up);
        }
        document.addEventListener('mousemove', move);
        document.addEventListener('mouseup', up);
    }

    // ─── Temp connection drag (port → port) ───────────────
    function beginTempConn(e, fromNode) {
        e.stopPropagation();
        const p = nodeOutPort(fromNode);
        state.tempConn = { fromId: fromNode.id, fromX: p.x, fromY: p.y, x: p.x, y: p.y };
        function move(ev) {
            const rect = canvasWrap.getBoundingClientRect();
            state.tempConn.x = (ev.clientX - rect.left - state.offset.x) / state.zoom;
            state.tempConn.y = (ev.clientY - rect.top  - state.offset.y) / state.zoom;
            renderTempConn();
        }
        function up(ev) {
            document.removeEventListener('mousemove', move);
            document.removeEventListener('mouseup', up);
            state.tempConn = null;
            tempLayer.innerHTML = '';
        }
        document.addEventListener('mousemove', move);
        document.addEventListener('mouseup', up);
    }
    function endTempConn(e, toNode) {
        if (!state.tempConn) return;
        e.stopPropagation();
        const fromId = state.tempConn.fromId;
        if (fromId !== toNode.id && !state.connections.some(c => c.from === fromId && c.to === toNode.id)) {
            state.connections.push({ from: fromId, to: toNode.id });
            renderCanvas();
        }
        state.tempConn = null;
        tempLayer.innerHTML = '';
    }

    // ─── Pan & zoom ───────────────────────────────────────
    let spaceDown = false;
    document.addEventListener('keydown', e => {
        if (root.hidden) return;
        if (e.code === 'Space' && !e.repeat) {
            spaceDown = true;
            canvasWrap.style.cursor = 'grab';
        }
    });
    document.addEventListener('keyup', e => {
        if (e.code === 'Space') { spaceDown = false; canvasWrap.style.cursor = ''; }
    });

    canvasWrap.addEventListener('mousedown', e => {
        if (e.target.closest('.node') || e.target.closest('.node-port')) return;
        if (e.target.closest('.canvas-toolbar') || e.target.closest('.canvas-shortcuts')) return;

        const isPan = (e.button === 1) || (e.button === 0 && spaceDown);
        if (e.button === 0 && !spaceDown) {
            selectNode(null);   // background click deselects
            return;
        }
        if (!isPan) return;

        e.preventDefault();
        canvasWrap.classList.add('panning');
        const sx = e.clientX, sy = e.clientY;
        const ox = state.offset.x, oy = state.offset.y;
        function move(ev) {
            state.offset.x = ox + (ev.clientX - sx);
            state.offset.y = oy + (ev.clientY - sy);
            applyTransform();
        }
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
        const factor = e.deltaY < 0 ? 1.1 : 1 / 1.1;
        zoomBy(factor, { x: e.clientX, y: e.clientY });
    }, { passive: false });

    function applyTransform() {
        nodesLayer.style.transform = `translate(${state.offset.x}px,${state.offset.y}px) scale(${state.zoom})`;
        canvasLayer.setAttribute('transform', `translate(${state.offset.x},${state.offset.y}) scale(${state.zoom})`);
    }

    function zoomBy(factor, anchor) {
        const rect = canvasWrap.getBoundingClientRect();
        const ax = anchor ? anchor.x - rect.left : rect.width  / 2;
        const ay = anchor ? anchor.y - rect.top  : rect.height / 2;
        const newZoom = Math.max(0.25, Math.min(2.5, state.zoom * factor));
        state.offset.x = ax - ((ax - state.offset.x) * (newZoom / state.zoom));
        state.offset.y = ay - ((ay - state.offset.y) * (newZoom / state.zoom));
        state.zoom = newZoom;
        applyTransform();
        hudZoom.textContent = Math.round(state.zoom * 100) + '%';
    }
    $('#btn-zoom-in').addEventListener('click',  () => zoomBy(1.2));
    $('#btn-zoom-out').addEventListener('click', () => zoomBy(1 / 1.2));
    $('#btn-zoom-reset').addEventListener('click', () => {
        state.zoom = 1; state.offset = { x: 0, y: 0 }; applyTransform();
        hudZoom.textContent = '100%';
    });
    $('#btn-zoom-fit').addEventListener('click', () => {
        if (!state.nodes.length) return;
        const xs = state.nodes.map(n => n.x), ys = state.nodes.map(n => n.y);
        const minX = Math.min(...xs), maxX = Math.max(...xs) + 220;
        const minY = Math.min(...ys), maxY = Math.max(...ys) + 120;
        const rect = canvasWrap.getBoundingClientRect();
        const z = Math.min(1, Math.min(rect.width / (maxX - minX + 80), rect.height / (maxY - minY + 80)));
        state.zoom = z;
        state.offset = { x: (rect.width - (maxX - minX) * z) / 2 - minX * z, y: (rect.height - (maxY - minY) * z) / 2 - minY * z };
        applyTransform();
    });

    // ─── Selection & inspector ────────────────────────────
    function selectNode(id) {
        state.selected = id;
        $$('.node').forEach(n => n.classList.toggle('selected', n.dataset.id === id));
        // Highlight connections that touch the selected node
        $$('.connection').forEach((p, i) => {
            const c = state.connections[i];
            if (c) p.classList.toggle('active', c.from === id || c.to === id);
        });
        renderInspector();
        updateStatus();
    }
    function renderInspector() {
        inspector.innerHTML = '';
        const node = state.nodes.find(n => n.id === state.selected);
        if (!node) {
            insTitle.textContent = 'Inspector';
            insTypePill.hidden = true;
            inspector.appendChild(h('div', { class: 'inspector-empty' },
                h('i', { class: 'fa-regular fa-hand-pointer' }),
                h('span', {}, 'Select a node to edit its properties')
            ));
            updateStatus();
            return;
        }
        const def = TYPES[node.type] || TYPES.station;
        insTitle.textContent = titleFor(node);
        insTypePill.hidden = false;
        insType.textContent = def.label;
        insTypePill.querySelector('i').className = `fa-solid fa-${def.icon}`;
        const r = node.ref;
        if (node.type === 'restaurant') {
            inspector.append(
                group('General',
                    field('Name',  textInput(r, 'name')),
                    field('Label', textInput(r, 'label')),
                    field('Job',   textInput(r, 'job')),
                    toggleField('Enabled', r, 'enabled', true)
                )
            );
        } else if (node.type === 'blip') {
            inspector.append(
                group('Blip',
                    field('Sprite',  numInput(r, 'sprite', 106)),
                    field('Colour',  numInput(r, 'color', 5)),
                    field('Scale',   numInput(r, 'scale', 0.8, 0.1)),
                    field('Display', numInput(r, 'display', 4)),
                    coordsField('Coords', r)
                )
            );
        } else if (node.type === 'boss') {
            inspector.append(
                group('Boss menu',
                    toggleField('Enabled', r, 'enabled', true),
                    field('Min grade', numInput(r, 'minGrade', 3)),
                    coordsField('Coords', r),
                    sizeField('Size', r),
                    field('Heading', numInput(r, 'heading', 0))
                )
            );
        } else if (node.type === 'duty' || node.type === 'wardrobe') {
            inspector.append(
                group(TYPES[node.type].label,
                    toggleField('Enabled', r, 'enabled', true),
                    coordsField('Coords', r),
                    sizeField('Size', r),
                    field('Heading', numInput(r, 'heading', 0))
                )
            );
        } else if (node.type === 'register' || node.type === 'preparation' || node.type === 'menuDisplay'
                || node.type === 'storage' || node.type === 'tray' || node.type === 'station') {
            const groups = [
                field('Label', textInput(r, 'label')),
                coordsField('Coords', r),
                sizeField('Size', r),
                field('Heading', numInput(r, 'heading', 0)),
            ];
            if (node.type === 'station') {
                // The station key drives which DEFAULT recipe set the
                // station shows in-game (also the boss-menu Recipes
                // subtab). A select keeps invalid kinds from being
                // typed by accident.
                groups.push(field('Station kind', selectInput(r, 'name', [
                    { value: 'grill',    label: 'Grill (patties)' },
                    { value: 'assembly', label: 'Assembly (burger build)' },
                    { value: 'fryer',    label: 'Fryer (fries / nuggets)' },
                    { value: 'drinks',   label: 'Drinks' },
                    { value: 'coffee',   label: 'Coffee' },
                ], 'grill')));
            }
            if (node.type === 'storage' || node.type === 'tray') {
                groups.push(
                    field('Slots', numInput(r, 'slots', 25)),
                    field('Weight', numInput(r, 'weight', 50000))
                );
            }
            inspector.append(group(TYPES[node.type].label, ...groups));
        } else if (node.type === 'npcShop') {
            // Shared config across every NPC shop zone of this restaurant
            const rest = getActive();
            const shared = rest.npcShop = rest.npcShop || { enabled: true };
            inspector.append(
                group('NPC supplier (shared)',
                    toggleField('Enabled', shared, 'enabled', true),
                    field('Min grade', numInput(shared, 'minGrade', 0)),
                    field('Payment', selectInput(shared, 'paymentType', [
                        { label: 'Cash', value: 'money' },
                        { label: 'Bank', value: 'bank'  },
                    ], 'money'))
                ),
                group('This zone',
                    field('Label', textInput(r, 'label', 'Supplies')),
                    pedFields(r.ped = r.ped || {})
                ),
                group('Items (shared)', itemsList(shared.items = shared.items || []))
            );
        } else if (node.type === 'customerShop') {
            const rest = getActive();
            const shared = rest.customerShop = rest.customerShop || { enabled: true };
            inspector.append(
                group('Customer shop (shared)',
                    toggleField('Enabled', shared, 'enabled', true)
                ),
                group('This zone',
                    field('Label', textInput(r, 'label', 'Order here')),
                    pedFields(r.ped = r.ped || {})
                )
            );
        } else if (node.type === 'delivery') {
            const rest = getActive();
            const shared = rest.delivery = rest.delivery || { enabled: true };
            shared.garage      = shared.garage      || { spawn: { x: 0, y: 0, z: 0, w: 0 }, vehicles: [] };
            shared.deliveryPay = shared.deliveryPay || { min: 500, max: 1000 };
            inspector.append(
                group('Delivery (shared)',
                    toggleField('Enabled', shared, 'enabled', true),
                    field('Pay min',     numInput(shared.deliveryPay, 'min', 500)),
                    field('Pay max',     numInput(shared.deliveryPay, 'max', 1000)),
                    field('Commission %',numInput(shared, 'commission', 15))
                ),
                group('This phone zone',
                    field('Label', textInput(r, 'label', 'Delivery')),
                    coordsField('Phone zone', r),
                    field('Heading', numInput(r, 'heading', 0))
                ),
                group('Garage (shared)',
                    // Where the delivery vehicle actually appears (runtime
                    // reads garage.spawn). Place it with a translucent ghost
                    // vehicle so the spawn lands exactly where it'll come out.
                    coordsField('Vehicle spawn', shared.garage, true, {
                        key: 'spawn',
                        vehicleGhost: () => (shared.garage.vehicles && shared.garage.vehicles[0] && shared.garage.vehicles[0].model) || 'boxville2',
                    }),
                    // Where the player returns the vehicle (runtime reads
                    // garage.coords).
                    coordsField('Return point', shared.garage, true),
                    vehiclesList(shared.garage.vehicles = shared.garage.vehicles || [])
                )
            );
        }
    }

    function group(title, ...children) {
        return h('div', { class: 'group' },
            h('div', { class: 'group-title' }, title),
            ...children
        );
    }
    function field(label, control) {
        return h('div', { class: 'field' },
            h('label', { class: 'field-label' }, label),
            control
        );
    }
    function textInput(ref, key, def = '') {
        const el = h('input', { class: 'apex-input', type: 'text', value: ref[key] ?? def });
        el.addEventListener('input', () => { ref[key] = el.value; refreshNode(); });
        return el;
    }
    function numInput(ref, key, def = 0, step = 1) {
        const el = h('input', { class: 'apex-input', type: 'number', value: ref[key] ?? def, step });
        el.addEventListener('input', () => { ref[key] = Number(el.value); refreshNode(); });
        return el;
    }
    function selectInput(ref, key, options, def) {
        const el = h('select', { class: 'apex-select' },
            ...options.map(o => h('option', { value: o.value, ...(o.value == (ref[key] ?? def) ? { selected: true } : {}) }, o.label))
        );
        el.addEventListener('change', () => { ref[key] = el.value; });
        return el;
    }
    function toggleField(label, ref, key, defaultOn = false) {
        const cur = ref[key] === undefined ? defaultOn : !!ref[key];
        if (ref[key] === undefined) ref[key] = cur;
        const t = h('div', { class: `toggle ${cur ? 'on' : ''}` });
        t.addEventListener('click', () => {
            ref[key] = !ref[key];
            t.classList.toggle('on', !!ref[key]);
            refreshList();
        });
        return h('div', { class: 'field toggle-row' },
            h('span', { class: 'field-label', style: 'margin:0' }, label),
            t
        );
    }
    function coordsField(label, ref, isVec4 = false, opts = {}) {
        // opts.key lets a field target a property other than `coords`
        // (e.g. the delivery garage's `spawn`).
        const key = opts.key || 'coords';
        ref[key] = ref[key] || (isVec4 ? { x:0,y:0,z:0,w:0 } : { x:0,y:0,z:0 });
        const c = ref[key];
        const inp = (k) => {
            const el = h('input', { class: 'apex-input', type: 'number', step: '0.01', value: c[k] ?? 0 });
            el.addEventListener('input', () => { c[k] = Number(el.value); refreshNode(); });
            return el;
        };
        const x = inp('x'), y = inp('y'), z = inp('z'), w = isVec4 ? inp('w') : null;

        // [a] Instant grab — use my current position right now
        const here = h('button', { title: 'Use my position (right now)' }, h('i', { class: 'fa-solid fa-person-circle-check' }));
        here.addEventListener('click', async () => {
            const { coords, heading } = await post('editor_get_coords');
            if (!coords) return;
            x.value = coords.x; y.value = coords.y; z.value = coords.z;
            c.x = coords.x; c.y = coords.y; c.z = coords.z;
            if (isVec4) { w.value = heading; c.w = heading; }
            refreshNode();
        });

        // [b] Walk-and-confirm — hides editor, walk to spot, press E
        const walk = h('button', { title: 'Walk to spot, then [E] to confirm' }, h('i', { class: 'fa-solid fa-shoe-prints' }));
        walk.addEventListener('click', async () => {
            window._coordsTarget = { x, y, z, w };
            await post('editor_pick_coords');
        });

        // [c] Laser raycast — hides editor, aim with camera, press E on impact.
        // Skipped for NPC ped fields (the "Place ghost ped" button is used instead).
        const laser = opts.noLaser ? null : (() => {
            const b = h('button', { title: 'Laser pick (aim with camera)' }, h('i', { class: 'fa-solid fa-bullseye' }));
            b.addEventListener('click', async () => {
                window._coordsTarget = { x, y, z, w };
                await post('editor_laser_pick');
            });
            return b;
        })();

        // [d] Ghost vehicle — spawn a translucent vehicle, aim with the
        // camera, A/D rotate, [E] to place. opts.vehicleGhost returns the
        // model to preview. Only added for vec4 fields (needs a heading).
        const vehGhost = (opts.vehicleGhost && isVec4) ? (() => {
            const b = h('button', { title: 'Place with a ghost vehicle (aim + A/D rotate, E)' }, h('i', { class: 'fa-solid fa-truck' }));
            b.addEventListener('click', async () => {
                window._coordsTarget = { x, y, z, w };
                await post('editor_vehicle_pick', { model: opts.vehicleGhost() || 'boxville2' });
            });
            return b;
        })() : null;

        return h('div', { class: 'field' },
            h('label', { class: 'field-label' }, label),
            h('div', { class: 'coord-pick' }, x, y, z, isVec4 ? w : null, here, walk, laser, vehGhost)
        );
    }
    function sizeField(label, ref) {
        ref.size = ref.size || { x: 2, y: 2, z: 2 };
        const s = ref.size;
        const inp = (k) => {
            const el = h('input', { class: 'apex-input', type: 'number', step: '0.1', value: s[k] ?? 2 });
            el.addEventListener('input', () => { s[k] = Number(el.value); });
            return el;
        };
        return h('div', { class: 'field' },
            h('label', { class: 'field-label' }, label),
            h('div', { class: 'row-3' }, inp('x'), inp('y'), inp('z'))
        );
    }
    function pedFields(ped) {
        ped.coords = ped.coords || { x: 0, y: 0, z: 0, w: 0 };

        const modelInput = textInput(ped, 'model', 'mp_m_shopkeep_01');

        // "Place ghost ped" — spawns a translucent preview that walks
        // with the player. [E] confirms position + heading.
        const placeBtn = h('button', {
            class: 'btn btn-ghost btn-sm btn-block',
            style: 'margin-top:6px',
            onclick: async () => {
                window._coordsTarget = (function () {
                    // Stash references so editor_restore lands in coords + w
                    const fields = $$('.coord-pick', inspector);
                    const lastWrap = fields[fields.length - 1];
                    if (!lastWrap) return null;
                    const inputs = $$('input', lastWrap);
                    return { x: inputs[0], y: inputs[1], z: inputs[2], w: inputs[3] };
                })();
                await post('editor_ped_pick', { model: ped.model || 'mp_m_shopkeep_01' });
            },
        }, h('i', { class: 'fa-solid fa-person-walking' }), 'Place ghost ped in world');

        return h('div', null,
            field('Model', modelInput),
            field('Scenario', textInput(ped, 'scenario', 'WORLD_HUMAN_STAND_IMPATIENT')),
            // NPC peds use the dedicated ghost-ped placer below; the
            // laser pick doesn't fit (you can't aim a ped at a wall),
            // so hide it here for clarity. Height is adjusted IN the
            // ghost-ped placer with the Page Up / Page Down keys.
            coordsField('Position', ped, true, { noLaser: true }),
            placeBtn
        );
    }

    function itemsList(arr) {
        const wrap = h('div', { class: 'sub-list' });
        function paint() {
            wrap.innerHTML = '';
            arr.forEach((it, i) => {
                const row = h('div', { class: 'sub-list-row' });
                const sel = h('select', { class: 'apex-select' },
                    ...state.items.map(opt => h('option', { value: opt.name, ...(opt.name === it.name ? { selected: true } : {}) }, opt.label))
                );
                sel.addEventListener('change', () => { it.name = sel.value; it.label = state.items.find(x => x.name === sel.value)?.label || sel.value; });
                const price = h('input', { type: 'number', class: 'apex-input price', value: it.price ?? 10 });
                price.addEventListener('input', () => it.price = Number(price.value));
                const del = h('span', { class: 'del', onclick: () => { arr.splice(i, 1); paint(); } }, '×');
                row.append(h('div', { class: 'name' }, sel), price, del);
                wrap.appendChild(row);
            });
            wrap.appendChild(h('button', { class: 'add-sub-btn', onclick: () => {
                const first = state.items[0] || { name: 'meat', label: 'Meat', price: 10 };
                arr.push({ name: first.name, label: first.label, price: first.price });
                paint();
            } }, h('i', { class: 'fa-solid fa-plus' }), 'Add item'));
        }
        paint();
        return wrap;
    }

    function vehiclesList(arr) {
        const wrap = h('div', { class: 'sub-list' });
        function paint() {
            wrap.innerHTML = '';
            arr.forEach((v, i) => {
                const row = h('div', { class: 'sub-list-row' });
                const model = h('input', { type: 'text', class: 'apex-input name', value: v.model ?? '' });
                model.addEventListener('input', () => v.model = model.value);
                const label = h('input', { type: 'text', class: 'apex-input price', value: v.label ?? '' });
                label.addEventListener('input', () => v.label = label.value);
                const del   = h('span', { class: 'del', onclick: () => { arr.splice(i, 1); paint(); } }, '×');
                row.append(model, label, del);
                wrap.appendChild(row);
            });
            wrap.appendChild(h('button', { class: 'add-sub-btn', onclick: () => {
                arr.push({ model: 'boxville2', label: 'Boxville' }); paint();
            } }, h('i', { class: 'fa-solid fa-plus' }), 'Add vehicle'));
        }
        paint();
        return wrap;
    }

    // Refresh just the selected node's card (and connections that touch it)
    function refreshNode() {
        const node = state.nodes.find(n => n.id === state.selected);
        if (!node || !node._el) return;
        node._el.querySelector('.node-title').textContent = titleFor(node);
        const oldBody = node._el.querySelector('.node-body');
        if (oldBody) oldBody.replaceWith(renderNodeBody(node));
    }
    function refreshList() { renderRestList(); }

    // ─── Add / remove restaurants ─────────────────────────
    $('#btn-new-restaurant').addEventListener('click', () => {
        const r = prepareRestaurant({
            id: uid('rest'), name: 'New Restaurant', label: 'New Restaurant',
            job: 'newjob', enabled: true,
        });
        state.restaurants.push(r);
        selectRestaurant(r.id);
    });

    // ─── Create a new framework job (society, grades, funds) ───
    $('#btn-new-job').addEventListener('click', () => openCreateJobModal());

    // ─── Fast setup: lay out a whole restaurant in one guided pass ──
    $('#btn-fast-setup').addEventListener('click', () => openFastSetupModal());

    function openFastSetupModal() {
        const overlay = h('div', { class: 'cj-overlay', style: 'z-index:11500' });
        const done = () => overlay.remove();
        const slugInput  = h('input', { class: 'apex-input', type: 'text', placeholder: 'e.g. burgershot' });
        const labelInput = h('input', { class: 'apex-input', type: 'text', placeholder: 'e.g. Burger Shot' });
        const mkJob = h('input', { type: 'checkbox', checked: true });
        const start = h('button', { class: 'btn btn-primary' }, h('i', { class: 'fa-solid fa-bolt' }), ' Start placing');
        start.addEventListener('click', async () => {
            const job   = (slugInput.value  || '').trim().toLowerCase();
            const label = (labelInput.value || '').trim();
            if (!job || !label) { Notify.show({ message: 'Slug and label are required', type: 'error' }); return; }
            if (!/^[a-z0-9_]+$/.test(job)) { Notify.show({ message: 'Slug: lowercase letters, digits, underscore', type: 'error' }); return; }
            start.disabled = true;
            if (mkJob.checked) { try { await post('editor_create_job', { name: job, label }); } catch (_) {} }
            done();
            post('editor_fast_create', { job, label, vehicle: 'boxville2' });
        });
        overlay.appendChild(h('div', { class: 'cj-panel' },
            h('header', { class: 'cj-head' },
                h('span', { class: 'cj-head-icon' }, h('i', { class: 'fa-solid fa-bolt' })),
                h('div', null, h('div', { class: 'cj-eyebrow' }, 'Creator'), h('div', { class: 'cj-title' }, 'Fast setup')),
                h('button', { class: 'icon-btn', onclick: done }, h('i', { class: 'fa-solid fa-xmark' })),
            ),
            h('div', { class: 'cj-body' },
                h('div', { class: 'cj-row-2col' },
                    h('div', { class: 'cj-field' }, h('label', null, 'Job slug'), slugInput),
                    h('div', { class: 'cj-field' }, h('label', null, 'Label'), labelInput),
                ),
                h('label', { class: 'cj-field', style: 'flex-direction:row;align-items:center;gap:8px;cursor:pointer' },
                    mkJob, h('span', { style: 'font-size:12px;color:var(--text-2)' }, 'Create the framework job too (society, grades, funds)')),
                h('div', { class: 'cj-info' }, h('i', { class: 'fa-solid fa-circle-info' }),
                    h('span', null, 'Place each zone in-world: aim with the laser and press E. TAB skips a zone (nothing is mandatory), BACKSPACE finishes. The delivery vehicle spawn uses a ghost vehicle (A/D to rotate).')),
            ),
            h('footer', { class: 'cj-foot' }, h('button', { class: 'btn btn-ghost', onclick: done }, 'Cancel'), start),
        ));
        document.body.appendChild(overlay);
        setTimeout(() => slugInput.focus(), 50);
    }

    // Assemble + save the restaurant from the coords the player placed.
    function fastDone(payload) {
        const root2 = document.getElementById('editor-root');
        if (root2) root2.style.visibility = 'visible';
        if (!payload || !payload.placed) return;
        const p = payload.placed;
        const job = payload.job || 'job', label = payload.label || 'Restaurant';
        const has = k => p[k] && (p[k].x || p[k].y || p[k].z);
        const v3 = k => ({ x: p[k].x, y: p[k].y, z: p[k].z });
        const v4 = k => ({ x: p[k].x, y: p[k].y, z: p[k].z, w: p[k].w || 0 });

        const r = { id: uid('rest'), job, name: label, label, enabled: true };
        if (has('boss')) {
            r.boss = { enabled: true, coords: v3('boss'), heading: p.boss.w || 0, minGrade: 3, size: { x: 2, y: 2, z: 2 } };
            r.blip = { enabled: true, coords: v3('boss'), sprite: 106, color: 5, scale: 0.8, display: 4, size: { x: 2, y: 2, z: 2 } };
        }
        if (has('duty'))     r.duty     = { enabled: true, coords: v3('duty'),     heading: p.duty.w || 0,     size: { x: 2, y: 2, z: 2 } };
        if (has('wardrobe')) r.wardrobe = { enabled: true, coords: v3('wardrobe'), heading: p.wardrobe.w || 0, size: { x: 2, y: 2, z: 2 } };
        if (has('register')) r.registers   = [{ label: 'Register', coords: v3('register'), heading: p.register.w || 0, size: { x: 1, y: 1, z: 1 } }];
        if (has('storage'))  r.storage     = [{ label: 'Fridge', coords: v3('storage'), slots: 50, weight: 100000, size: { x: 2, y: 2, z: 2 } }];
        if (has('tray'))     r.trays       = [{ label: 'Tray', coords: v3('tray'), slots: 10, weight: 10000, size: { x: 1, y: 1, z: 1 } }];
        if (has('prep'))     r.preparation = [{ label: 'Preparation Table', coords: v3('prep'), heading: p.prep.w || 0, size: { x: 2, y: 2, z: 2 } }];
        const stations = [];
        [['grill', 'Grill Station'], ['fryer', 'Deep Fryer'], ['drinks', 'Drinks Station'], ['coffee', 'Coffee Machine'], ['assembly', 'Assembly']].forEach(([k, lbl]) => {
            if (has(k)) stations.push({ name: k, label: lbl, coords: v3(k), heading: p[k].w || 0, size: { x: 2, y: 2, z: 2 } });
        });
        if (stations.length) r.stations = stations;
        if (has('customer')) r.customerShops = [{ label: 'Order Here', coords: { x: 0, y: 0, z: 0 }, size: { x: 2, y: 2, z: 2 }, ped: { coords: v4('customer'), model: 'a_f_y_hipster_01', scenario: 'WORLD_HUMAN_STAND_IMPATIENT' } }];
        if (has('npcshop'))  r.npcShop = { enabled: true, label: 'Supplies', coords: { x: 0, y: 0, z: 0 }, size: { x: 2, y: 2, z: 2 }, paymentType: 'money', items: [], ped: { coords: v4('npcshop'), model: 'mp_m_shopkeep_01', scenario: 'WORLD_HUMAN_CLIPBOARD' } };
        if (has('menu'))     r.menuDisplay = [{ label: 'Menu Board', coords: v3('menu'), heading: p.menu.w || 0, size: { x: 1, y: 1, z: 1 } }];
        if (has('delivery') || has('garageSpawn')) {
            r.delivery = {
                enabled: true, commission: 15, deliveryPay: { min: 500, max: 1000 },
                coords: has('delivery') ? v3('delivery') : (has('garageSpawn') ? v3('garageSpawn') : { x: 0, y: 0, z: 0 }),
                heading: has('delivery') ? (p.delivery.w || 0) : 0, size: { x: 2, y: 2, z: 2 },
                garage: {
                    spawn:  has('garageSpawn')  ? v4('garageSpawn')  : (has('garageReturn') ? v4('garageReturn') : { x: 0, y: 0, z: 0, w: 0 }),
                    coords: has('garageReturn') ? v4('garageReturn') : (has('garageSpawn')  ? v4('garageSpawn')  : { x: 0, y: 0, z: 0, w: 0 }),
                    vehicles: [{ model: 'boxville2', label: 'Boxville' }],
                },
            };
        }
        prepareRestaurant(r);
        state.restaurants.push(r);
        selectRestaurant(r.id);
        // Auto-save + broadcast so the new restaurant is live immediately.
        post('editor_save', { restaurants: cleanForExport() }).then(res => {
            if (res && res.ok) { markSaved(); Notify.show({ message: 'Restaurant created & saved', type: 'success' }); }
            else Notify.show({ message: (res && res.err) || 'Saved locally; broadcast failed', type: 'error' });
        });
    }

    function openCreateJobModal() {
        // Use the dedicated cj-overlay class — no dark backdrop, no
        // backdrop-filter (CEF would otherwise render it as black on
        // a transparent layer).
        const overlay = h('div', { class: 'cj-overlay' });
        const close = () => overlay.remove();
        overlay.addEventListener('click', (e) => { if (e.target === overlay) close(); });

        const nameInput  = h('input', { class: 'apex-input', type: 'text', placeholder: 'burgershot', maxlength: 30 });
        const labelInput = h('input', { class: 'apex-input', type: 'text', placeholder: 'Burger Shot', maxlength: 50 });

        // Default 4 grades
        const grades = [
            { grade: 0, name: 'employee', label: 'Employee', salary: 50 },
            { grade: 1, name: 'senior',   label: 'Senior',   salary: 75 },
            { grade: 2, name: 'manager',  label: 'Manager',  salary: 100 },
            { grade: 3, name: 'boss',     label: 'Boss',     salary: 200 },
        ];
        const gradesRoot = h('div', { class: 'cj-grades' });
        function renderGrades() {
            gradesRoot.innerHTML = '';
            // Header row labels (only once)
            gradesRoot.appendChild(h('div', { class: 'cj-grade-head' },
                h('span', null, '#'),
                h('span', null, 'Slug'),
                h('span', null, 'Label'),
                h('span', null, 'Salary'),
                h('span', null, ''),
            ));
            grades.forEach((g, i) => {
                const row = h('div', { class: 'cj-grade-row' },
                    h('input', { class: 'apex-input cj-grade-num', type: 'number', min: 0, max: 99, value: g.grade,
                        oninput: (e) => { g.grade = Number(e.target.value) || 0 } }),
                    h('input', { class: 'apex-input', type: 'text', value: g.name, placeholder: 'slug',
                        oninput: (e) => { g.name = e.target.value } }),
                    h('input', { class: 'apex-input', type: 'text', value: g.label, placeholder: 'Label',
                        oninput: (e) => { g.label = e.target.value } }),
                    h('input', { class: 'apex-input cj-grade-salary', type: 'number', min: 0, value: g.salary, placeholder: '$',
                        oninput: (e) => { g.salary = Number(e.target.value) || 0 } }),
                    h('button', { class: 'icon-btn cj-grade-del', title: 'Remove grade',
                        onclick: () => { grades.splice(i, 1); renderGrades(); } },
                        h('i', { class: 'fa-solid fa-xmark' })),
                );
                gradesRoot.appendChild(row);
            });
        }
        renderGrades();

        const addGradeBtn = h('button', { class: 'btn btn-ghost btn-sm', onclick: () => {
            const next = (grades[grades.length - 1] && grades[grades.length - 1].grade + 1) || 0;
            grades.push({ grade: next, name: 'staff', label: 'Staff', salary: 50 });
            renderGrades();
        } }, h('i', { class: 'fa-solid fa-plus' }), ' Add grade');

        const cancelBtn = h('button', { class: 'btn btn-ghost', onclick: close }, 'Cancel');
        const createBtn = h('button', { class: 'btn btn-primary', onclick: async () => {
            const name  = (nameInput.value  || '').trim().toLowerCase();
            const label = (labelInput.value || '').trim();
            if (!name || !label) {
                Notify.show({ message: 'Both job slug and label are required', type: 'error' });
                return;
            }
            if (!/^[a-z0-9_]+$/.test(name)) {
                Notify.show({ message: 'Slug must be lowercase letters, digits, underscore', type: 'error' });
                return;
            }
            createBtn.disabled = true;
            const res = await post('editor_create_job', { name, label, grades });
            createBtn.disabled = false;
            if (res && res.ok) {
                Notify.show({ message: `Job "${name}" created — assign it to a restaurant`, type: 'success' });
                close();
            } else {
                Notify.show({ message: (res && res.info && res.info.errors && res.info.errors.join(', ')) || 'Create failed', type: 'error' });
            }
        } }, h('i', { class: 'fa-solid fa-id-badge' }), ' Create job');

        overlay.appendChild(h('div', { class: 'cj-panel' },
            // Header
            h('header', { class: 'cj-head' },
                h('span', { class: 'cj-head-icon' }, h('i', { class: 'fa-solid fa-id-badge' })),
                h('div', null,
                    h('div', { class: 'cj-eyebrow' }, 'Framework'),
                    h('div', { class: 'cj-title' }, 'Create new job'),
                ),
                h('button', { class: 'icon-btn', onclick: close, title: 'Close' },
                    h('i', { class: 'fa-solid fa-xmark' })),
            ),
            // Body
            h('div', { class: 'cj-body' },
                // Two-column row: slug + label
                h('div', { class: 'cj-row-2col' },
                    h('div', { class: 'cj-field' },
                        h('label', null, 'Slug'),
                        nameInput,
                    ),
                    h('div', { class: 'cj-field' },
                        h('label', null, 'Label'),
                        labelInput,
                    ),
                ),
                // Grades
                h('div', { class: 'cj-field' },
                    h('label', null, 'Grades'),
                    gradesRoot,
                    h('div', { class: 'cj-add-row' }, addGradeBtn),
                ),
                // Info banner
                h('div', { class: 'cj-info' },
                    h('i', { class: 'fa-solid fa-circle-info' }),
                    h('span', null, 'Creates the job + grades + society account + inventory + datastore. A framework restart may be required for /setjob to see the new job.'),
                ),
            ),
            // Footer (sticky)
            h('footer', { class: 'cj-foot' }, cancelBtn, createBtn),
        ));
        document.body.appendChild(overlay);
        setTimeout(() => nameInput.focus(), 50);
    }

    function selectRestaurant(id) {
        state.activeId = id;
        state.selected = null;
        const r = getActive();
        restNameEl.textContent = r ? (r.label || r.name || 'Unnamed') : 'No restaurant selected';
        if (r && r.job) {
            restJobEl.hidden = false;
            restJobEl.textContent = r.job;
        } else {
            restJobEl.hidden = true;
        }
        renderRestList();
        syncNodesFromRestaurant();
        renderCanvas();
        renderInspector();
    }

    // For multi-zone nodes we now keep the SHARED config under the
    // singular key (r.customerShop / r.npcShop / r.delivery) and put the
    // per-zone struct (ped + coords) into a plural array.
    const MULTI_ARR = {
        register:'registers', preparation:'preparation', station:'stations',
        storage:'storage', tray:'trays', menuDisplay:'menuDisplay',
        customerShop:'customerShops', npcShop:'npcShops', delivery:'deliveries',
    };
    const SHARED_KEY = { customerShop:'customerShop', npcShop:'npcShop', delivery:'delivery' };

    // ─── Add a child node (e.g. add a Register to the active rest) ─
    function addNodeOfType(type) {
        const r = getActive();
        if (!r) return Notify.show({ message: 'Create a restaurant first', type: 'warning' });
        const def = TYPES[type];
        if (def.single) {
            const key = ({ blip:'blip', boss:'boss', duty:'duty', wardrobe:'wardrobe' })[type];
            r[key] = r[key] || ensurePart({});
            r[key].enabled = true;
        } else {
            const arrKey = MULTI_ARR[type];
            r[arrKey] = r[arrKey] || [];
            // Multi-zone types with shared config: make sure the parent
            // exists + is enabled so the runtime spawns the zones.
            const sharedKey = SHARED_KEY[type];
            if (sharedKey) {
                r[sharedKey] = r[sharedKey] || {};
                if (r[sharedKey].enabled !== false) r[sharedKey].enabled = true;
            }
            r[arrKey].push(ensurePart({ label: def.label + ' ' + (r[arrKey].length + 1) }));
        }
        syncNodesFromRestaurant();
        renderCanvas();
    }

    function removeNode(node) {
        const r = getActive(); if (!r) return;
        const single = TYPES[node.type].single;
        if (single) {
            const key = ({ blip:'blip', boss:'boss', duty:'duty', wardrobe:'wardrobe' })[node.type];
            delete r[key];
        } else {
            const arrKey = MULTI_ARR[node.type];
            r[arrKey] = (r[arrKey] || []).filter(x => x._id !== node.id);
        }
        if (state.selected === node.id) state.selected = null;
        syncNodesFromRestaurant();
        renderCanvas();
        renderInspector();
    }

    // ─── Save / preview / export / import ─────────────────
    function cleanForExport() {
        // Strip editor-only fields (_id) but keep the rest as-is.
        return state.restaurants.map(r => {
            const clone = JSON.parse(JSON.stringify(r));
            const stripArr = (arr) => arr && arr.forEach(o => delete o._id);
            const stripObj = (obj) => { if (obj && typeof obj === 'object') delete obj._id; };
            ['registers','preparation','stations','storage','trays','menuDisplay',
             'customerShops','npcShops','deliveries'].forEach(k => stripArr(clone[k]));
            ['blip','boss','duty','wardrobe','npcShop','customerShop','delivery'].forEach(k => stripObj(clone[k]));
            return clone;
        });
    }
    $('#btn-save').addEventListener('click', async () => {
        const res = await post('editor_save', { restaurants: cleanForExport() });
        if (res && res.ok) markSaved();
        const toast = h('div', { class: `save-toast ${res.ok ? '' : 'error'}` },
            h('i', { class: `fa-solid fa-${res.ok ? 'check' : 'xmark'}` }), ' ',
            res.ok ? 'Saved & broadcast' : (res.err || 'Save failed')
        );
        canvasWrap.appendChild(toast);
        setTimeout(() => toast.remove(), 2400);
    });
    $('#btn-preview').addEventListener('click', async () => {
        await post('editor_preview', { restaurants: cleanForExport() });
        Notify.show({ message: 'Live preview pushed to your client only', type: 'info' });
    });
    $('#btn-export').addEventListener('click', () => {
        const blob = new Blob([JSON.stringify(cleanForExport(), null, 2)], { type: 'application/json' });
        const url  = URL.createObjectURL(blob);
        const a    = h('a', { href: url, download: 'restaurants.json' });
        document.body.append(a); a.click(); a.remove();
        URL.revokeObjectURL(url);
    });
    $('#btn-import').addEventListener('click', () => $('#file-import').click());
    $('#file-import').addEventListener('change', e => {
        const f = e.target.files[0]; if (!f) return;
        const fr = new FileReader();
        fr.onload = () => {
            try {
                const data = JSON.parse(fr.result);
                if (!Array.isArray(data)) throw 0;
                state.restaurants = data.map(prepareRestaurant);
                if (state.restaurants[0]) selectRestaurant(state.restaurants[0].id);
                else renderAll();
                Notify.show({ message: 'Imported '+ data.length +' restaurants', type: 'success' });
            } catch { Notify.show({ message: 'Invalid JSON', type: 'error' }); }
        };
        fr.readAsText(f);
        e.target.value = '';
    });

    // Coord-pick restore
    window.addEventListener('message', (ev) => {
        const m = ev.data || {};
        if (m.action === 'editor_restore' && m.payload && m.payload.coords && window._coordsTarget) {
            const t = window._coordsTarget;
            const c = m.payload.coords;
            if (t.x && typeof t.x.value !== 'undefined') {
                t.x.value = c.x; t.y.value = c.y; t.z.value = c.z;
                if (t.w) t.w.value = m.payload.heading ?? 0;
                t.x.dispatchEvent(new Event('input'));
                t.y.dispatchEvent(new Event('input'));
                t.z.dispatchEvent(new Event('input'));
                if (t.w) t.w.dispatchEvent(new Event('input'));
            }
            window._coordsTarget = null;
        }
    });

    // Keyboard shortcuts (editor only)
    document.addEventListener('keydown', e => {
        if (root.hidden) return;
        const tag = (e.target && e.target.tagName) || '';
        const inField = tag === 'INPUT' || tag === 'TEXTAREA' || tag === 'SELECT';

        // Ctrl+S — save
        if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 's') {
            e.preventDefault();
            $('#btn-save').click();
            return;
        }
        // Esc — close (only when no modal open)
        if (e.key === 'Escape' && !inField) {
            const anyModalOpen = ['menu-overlay','input-overlay','alert-overlay','stash-overlay']
                .some(id => !document.getElementById(id).hidden);
            if (!anyModalOpen) close();
            return;
        }
        // Del — remove selected node
        if ((e.key === 'Delete' || e.key === 'Backspace') && state.selected && !inField) {
            const n = state.nodes.find(x => x.id === state.selected);
            if (n && n.type !== 'restaurant') { e.preventDefault(); removeNode(n); }
        }
        // +/- zoom
        if (e.key === '+' || (e.key === '=' && e.shiftKey)) { e.preventDefault(); zoomBy(1.15); }
        if (e.key === '-' || e.key === '_')                 { e.preventDefault(); zoomBy(1 / 1.15); }
        if (e.key === '0' && (e.ctrlKey || e.metaKey))      { e.preventDefault(); $('#btn-zoom-reset').click(); }
    });

    function renderAll() { renderRestList(); renderPalette(); renderCanvas(); renderInspector(); }

    renderPalette();

    return { open, close, fastDone };
})();

// ════════════════════════════════════════════════════════════
// NUI message router
// ════════════════════════════════════════════════════════════

window.addEventListener('message', (ev) => {
    const m = ev.data || {};
    const a = m.action, p = m.payload || {};
    switch (a) {
        case 'boss_frame': {
            // Relay to the embedded apex_bossmenu UI (iframe). The inner UI
            // listens for window 'message' events ({action, data}). Because the
            // iframe loads CDN scripts (Leaflet) that delay its listener, we
            // keep re-sending 'open' until the iframe acks (bf_open_ack), and
            // also deliver as soon as it reports ready (bf_ready).
            const fr = document.getElementById('boss-frame');
            if (!fr) break;
            window.__bf = window.__bf || { pending: null, iv: null };
            const bf = window.__bf;
            const deliver = () => { try { fr.contentWindow.postMessage({ action: 'open', data: bf.pending || {} }, '*'); } catch (_) {} };
            if (m.sub === 'open') {
                bf.pending = m.data || {};
                fr.hidden = false;
                // Hand DOM focus to the iframe, otherwise keydown stays with
                // this page and the command center's own ESC / shortcuts
                // never fire.
                try { fr.focus(); fr.contentWindow.focus(); } catch (_) {}
                deliver();
                if (bf.iv) clearInterval(bf.iv);
                let tries = 0;
                bf.iv = setInterval(() => { if (!bf.pending || ++tries > 30) { clearInterval(bf.iv); bf.iv = null; return; } deliver(); }, 150);
            } else if (m.sub === 'hide') {
                if (bf.iv) { clearInterval(bf.iv); bf.iv = null; }
                bf.pending = null;
                try { fr.contentWindow.postMessage({ action: 'close' }, '*'); } catch (_) {}
                fr.hidden = true;
            } else if (fr.contentWindow) {
                try { fr.contentWindow.postMessage({ action: m.sub, data: m.data || {} }, '*'); } catch (_) {}
            }
            break;
        }
        case 'bf_ready': {
            // iframe app loaded — deliver any pending open immediately
            const fr = document.getElementById('boss-frame');
            const bf = window.__bf;
            if (fr && bf && bf.pending) { try { fr.contentWindow.postMessage({ action: 'open', data: bf.pending }, '*'); } catch (_) {} }
            break;
        }
        case 'bf_open_ack': {
            // iframe processed 'open' — stop re-sending
            const bf = window.__bf;
            if (bf) { bf.pending = null; if (bf.iv) { clearInterval(bf.iv); bf.iv = null; } }
            break;
        }
        case 'set_config':
            if (p && p.currency)       ApexUI.currency       = p.currency;
            if (p && p.items)          ApexUI.items          = p.items;
            if (p && p.foodAnimations) ApexUI.foodAnimations = p.foodAnimations;
            if (p && p.locale)       { ApexUI.locale         = p.locale; applyStaticLocale(); }
            if (p && p.theme) {
                ApexUI.theme = p.theme;
                Theme.applyDefaults();
            }
            break;
        case 'set_locale':
            if (p && p.locale) { ApexUI.locale = p.locale; applyStaticLocale(); }
            break;
        case 'theme_brand_apply':
            // Server pushed new global colours (admin changed brand and/or
            // background from the creator). Override everyone immediately.
            if (p && p.brand) {
                ApexUI.theme = ApexUI.theme || {};
                ApexUI.theme.brand = p.brand;
                Theme.applyBrand(p.brand);
            }
            if (p && p.bg) {
                ApexUI.theme = ApexUI.theme || {};
                ApexUI.theme.bg = p.bg;
                Theme.applyBg(p.bg);
            }
            break;
        case 'notify':         Notify.render(p); break;
        case 'show3DIcon':     WorldIcon.show(m); break;
        case 'hide3DIcon':     WorldIcon.hide();  break;
        case 'target_show':    Target.show(p); break;
        case 'target_focus':   Target.focus(); break;
        case 'target_hide':    Target.hide();  break;
        case 'menu_open':      Menu.open(p);   break;
        case 'menu_close':     Menu.close();   break;
        case 'input_open':     Input.open(p);  break;
        case 'alert_open':     Alert.open(p);  break;
        case 'progress_show':  Progress.show(p); break;
        case 'progress_hide':  Progress.hide();  break;
        case 'stash_open':     Stash.open(p);    break;
        case 'boss_open':      Boss.open(p);
                               if (p && p.startTab) { const _bt = document.querySelector('#boss-tabs [data-tab="' + p.startTab + '"]'); if (_bt) _bt.click(); }
                               break;
        case 'boss_update':    Boss.apply(p);     break;
        case 'register_open':  Register.open(p);  break;
        case 'order_open':     Order.open(p);     break;
        case 'phone_open':     Phone.open(p);     break;
        case 'phone_close':    Phone.close({ cancel: true }); break;
        case 'delivery_hud_open':   DeliveryHUD.open(p);   break;
        case 'delivery_hud_update': DeliveryHUD.update(p); break;
        case 'delivery_hud_close':  DeliveryHUD.close();   break;
        case 'editor_open':    Editor.open(p);   break;
        case 'editor_close':   Editor.close();   break;
        case 'editor_minimize': document.getElementById('editor-root').style.visibility = 'hidden';  break;
        case 'editor_restore':  document.getElementById('editor-root').style.visibility = 'visible'; break;
        case 'editor_fast_done': Editor.fastDone(p); break;
        case 'wardrobe_open':    Wardrobe.open(p);     break;
        case 'wardrobe_close':   Wardrobe.close();     break;
        case 'wardrobe_max_tex': Wardrobe.setMaxTex(p); break;
        case 'placement_hud_show': PlacementHUD.show(p); break;
        case 'placement_hud_hide': PlacementHUD.hide();  break;
    }
});

// ════════════════════════════════════════════════════════════
// WARDROBE — standalone uniform creator
// ════════════════════════════════════════════════════════════
const Wardrobe = (() => {
    const overlay   = $('#wardrobe-overlay');
    const titleEl   = $('#wardrobe-title');
    const slotsRoot = $('#wardrobe-slots');
    const nameInput = $('#wardrobe-name');

    // Each slot carries its own current drawable/texture — avoids the
    // Lua→JSON sparse-array trap when looking up state by idx.
    let slots = [];   // [{ idx, kind, label, maxDraw, maxTex, drawable, texture }]

    function findSlot(kind, idx) {
        return slots.find(s => s.kind === kind && s.idx === idx);
    }

    function pushChange(slot) {
        post('wardrobe_change', { kind: slot.kind, idx: slot.idx, drawable: slot.drawable, texture: slot.texture });
    }

    function paintRow(row, slot) {
        row.querySelector('[data-d-val]').textContent = (slot.drawable == null || slot.drawable < 0 ? '—' : slot.drawable) + ' / ' + slot.maxDraw;
        row.querySelector('[data-t-val]').textContent = (slot.texture  || 0) + ' / ' + slot.maxTex;
    }

    function bump(kind, idx, axis, delta) {
        const slot = findSlot(kind, idx); if (!slot) return;
        if (axis === 'd') {
            // Props can be cleared by going below 0
            const min = kind === 'prop' ? -1 : 0;
            let nd = (slot.drawable == null ? 0 : slot.drawable) + delta;
            if (nd > slot.maxDraw) nd = min;
            if (nd < min)          nd = slot.maxDraw;
            slot.drawable = nd;
            slot.texture  = 0;
        } else {
            let nt = (slot.texture || 0) + delta;
            if (nt > slot.maxTex) nt = 0;
            if (nt < 0)           nt = slot.maxTex;
            slot.texture = nt;
        }
        const row = slotsRoot.querySelector(`[data-row="${kind}-${idx}"]`);
        if (row) paintRow(row, slot);
        pushChange(slot);
    }

    function render() {
        slotsRoot.innerHTML = '';
        slots.forEach(slot => {
            const row = h('div', { class: 'wr-row', dataset: { row: slot.kind + '-' + slot.idx } });
            row.appendChild(h('div', { class: 'wr-row-label' },
                h('span', { class: 'wr-row-icon' }, h('i', { class: 'fa-solid fa-' + (slot.icon || 'shirt') })),
                h('span', { class: 'wr-row-name' }, slot.label),
                h('span', { class: 'wr-row-kind' }, slot.kind === 'prop' ? 'Prop' : 'Comp'),
            ));
            const draw = h('div', { class: 'wr-stepper' },
                h('button', { class: 'wr-step-btn', onclick: () => bump(slot.kind, slot.idx, 'd', -1) }, h('i', { class: 'fa-solid fa-minus' })),
                h('span',   { class: 'wr-step-val', dataset: { dVal: '1' } }, '0 / 0'),
                h('button', { class: 'wr-step-btn', onclick: () => bump(slot.kind, slot.idx, 'd', +1) }, h('i', { class: 'fa-solid fa-plus' })),
            );
            const tex = h('div', { class: 'wr-stepper' },
                h('button', { class: 'wr-step-btn', onclick: () => bump(slot.kind, slot.idx, 't', -1) }, h('i', { class: 'fa-solid fa-minus' })),
                h('span',   { class: 'wr-step-val', dataset: { tVal: '1' } }, '0 / 0'),
                h('button', { class: 'wr-step-btn', onclick: () => bump(slot.kind, slot.idx, 't', +1) }, h('i', { class: 'fa-solid fa-plus' })),
            );
            row.appendChild(h('div', { class: 'wr-row-controls' },
                h('div', { class: 'wr-stepper-wrap' }, h('div', { class: 'wr-stepper-label' }, h('i', { class: 'fa-solid fa-shapes' }), ' Style'),   draw),
                h('div', { class: 'wr-stepper-wrap' }, h('div', { class: 'wr-stepper-label' }, h('i', { class: 'fa-solid fa-palette' }), ' Texture'), tex),
            ));
            paintRow(row, slot);
            slotsRoot.appendChild(row);
        });
    }

    function open(p) {
        titleEl.textContent = p.title || 'Create uniform';
        slots = p.slots || [];
        nameInput.value = '';
        // Reset camera preset to "Full" (matches the Lua-side default)
        $$('[data-wr-zoom]').forEach(b => b.classList.toggle('active', b.dataset.wrZoom === 'full'));
        render();
        overlay.hidden = false;
        resetScroll(overlay);
    }
    function close() { overlay.hidden = true; }

    function setMaxTex(p) {
        const slot = findSlot(p.kind, p.idx); if (!slot) return;
        slot.maxTex = p.maxTex;
        const row = slotsRoot.querySelector(`[data-row="${p.kind}-${p.idx}"]`);
        if (row) paintRow(row, slot);
    }

    // Save / cancel / zoom / rotate buttons
    overlay.addEventListener('click', e => {
        if (e.target.closest('[data-wr-save]')) {
            const name = (nameInput.value || '').trim();
            if (!name) {
                nameInput.classList.add('wr-input-err');
                nameInput.focus();
                setTimeout(() => nameInput.classList.remove('wr-input-err'), 600);
                return;
            }
            post('wardrobe_save', { name });
            return;
        }
        if (e.target.closest('[data-wr-cancel]')) {
            post('wardrobe_cancel');
            return;
        }
        const zoomBtn = e.target.closest('[data-wr-zoom]');
        if (zoomBtn) {
            $$('[data-wr-zoom]').forEach(b => b.classList.toggle('active', b === zoomBtn));
            post('wardrobe_zoom', { zoom: zoomBtn.dataset.wrZoom });
            return;
        }
        const rotBtn = e.target.closest('[data-wr-rot]');
        if (rotBtn) {
            post('wardrobe_rotate', { delta: Number(rotBtn.dataset.wrRot) || 0 });
            return;
        }
    });
    document.addEventListener('keydown', e => {
        if (!overlay.hidden && e.key === 'Escape') post('wardrobe_cancel');
    });

    // Drag-to-rotate: mouse down anywhere OUTSIDE the panel (i.e. on
    // the game viewport) + drag horizontally → rotate the ped.
    // Throttled to ~30Hz so we don't spam the NUI bridge.
    let dragging = false, lastX = 0, pending = 0, lastSend = 0;
    document.addEventListener('mousedown', e => {
        if (overlay.hidden) return;
        if (e.target.closest('.wr-panel')) return;
        dragging = true; lastX = e.clientX; pending = 0;
    });
    document.addEventListener('mouseup', () => { dragging = false });
    document.addEventListener('mousemove', e => {
        if (!dragging) return;
        pending += e.clientX - lastX;
        lastX = e.clientX;
        const now = performance.now();
        if (now - lastSend < 33) return;
        lastSend = now;
        if (Math.abs(pending) >= 1) {
            post('wardrobe_rotate', { delta: pending * 0.5 });
            pending = 0;
        }
    });

    return { open, close, setMaxTex };
})();

// ════════════════════════════════════════════════════════════
// PLACEMENT HUD — shown while picking coords / placing a ped
// (the editor UI itself is minimized during this).
// ════════════════════════════════════════════════════════════
const PlacementHUD = (() => {
    const overlay   = $('#placement-hud');
    const eyebrow   = $('#placement-eyebrow');
    const titleEl   = $('#placement-title');
    const keysRoot  = $('#placement-keys');
    function show(p) {
        eyebrow.textContent = (p && p.eyebrow) || 'Placement';
        titleEl.textContent = (p && p.title)   || 'Pick a spot in the world';
        keysRoot.innerHTML  = '';
        const keys = (p && p.keys) || [];
        keys.forEach(k => {
            keysRoot.appendChild(h('span', { class: 'placement-key' },
                h('kbd', null, k.key || ''),
                h('span', null, k.label || ''),
            ));
        });
        overlay.hidden = false;
    }
    function hide() { overlay.hidden = true; }
    return { show, hide };
})();

// ════════════════════════════════════════════════════════════
// Global ESC handler — closes every visible UI at once.
// Each UI has its own per-context handler too, but this is the
// catch-all so the user is never stuck with stacked modals.
// ════════════════════════════════════════════════════════════
document.addEventListener('keydown', (e) => {
    if (e.key !== 'Escape') return;
    let closedAny = false;

    // Profile (player) — pp-overlay
    document.querySelectorAll('.pp-overlay').forEach(o => { o.remove(); closedAny = true; });
    document.body.classList.remove('pp-open');

    // Generic modal overlays + confirm dialogs (input, alert, qty,
    // confirm, save-prompt, register, order, stash, boss, …)
    document.querySelectorAll('.modal-overlay').forEach(ov => {
        if (!ov.hidden) {
            // Try to close via the matching post() route first so the
            // backend learns about it (some UIs unfreeze game inputs).
            const id = ov.id;
            if (id === 'menu-overlay')     { try { post('menu_close')  } catch(_){} }
            if (id === 'input-overlay')    { try { post('input_cancel')} catch(_){} }
            if (id === 'alert-overlay')    { try { post('alert_answer', { confirm: false }) } catch(_){} }
            if (id === 'order-overlay')    { try { post('order_close') } catch(_){} }
            if (id === 'register-overlay') { try { post('register_close') } catch(_){} }
            if (id === 'boss-overlay')     { try { post('boss_close')  } catch(_){} }
            if (id === 'stash-overlay')    { try { post('ui_close')    } catch(_){} }
            ov.hidden = true;
            closedAny = true;
        } else if (ov.parentElement === document.body && !ov.id) {
            // Ad-hoc confirm dialogs are appended to <body> without an id
            ov.remove();
            closedAny = true;
        }
    });

    // Wardrobe (side panel, not a modal-overlay)
    const wr = document.getElementById('wardrobe-overlay');
    if (wr && !wr.hidden) {
        try { post('wardrobe_cancel') } catch(_){}
        wr.hidden = true;
        closedAny = true;
    }

    // Boss command center — an <iframe>, so it is not a .modal-overlay and
    // was never covered here. Its own ESC handler only runs while the
    // iframe holds DOM focus, which it may have lost to a click on this
    // page, so close it from here as well.
    const bossFrame = document.getElementById('boss-frame');
    if (bossFrame && !bossFrame.hidden) {
        try { post('bf_close') } catch(_){}
        closedAny = true;
    }

    // Editor — only close on ESC if no other modal was open (so ESC
    // inside the editor's inspector doesn't slam it shut). Editor
    // close also runs through the unsaved-changes prompt.
    if (!closedAny) {
        const ed = document.getElementById('editor-root');
        if (ed && !ed.hidden) {
            const btn = document.getElementById('btn-close-editor');
            if (btn) btn.click();
            closedAny = true;
        }
    }

    if (closedAny) e.stopPropagation();
}, true);

// Suppress right-click in CEF (it crashes some FiveM builds)
window.addEventListener('contextmenu', e => e.preventDefault());

})();
