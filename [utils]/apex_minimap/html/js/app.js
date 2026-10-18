/* ============================================================
   Apex Minimap Studio — app.js
   ------------------------------------------------------------
   App bus: NUI messaging, i18n, toasts, modals, tooltips and
   the chunked blob transport in BOTH directions. editor.js and
   panels.js hang off the App namespace defined here.
   ============================================================ */
'use strict';

window.App = (function () {

    const RES = (window.GetParentResourceName && GetParentResourceName()) || 'apex_minimap';

    const state = {
        open: false,
        config: {
            atlas: { rows: 3, cols: 2, tileSize: 2048 },
            worldBounds: { left: -4137.4, top: 8397.6, right: 4860.5, bottom: -5099.4 },
            maxLayers: 40,
            historyLimit: 25,
            frameThrottleMs: 120,
            exportName: 'my_minimap',
        },
        locale: {},
    };

    /* ── NUI post helper ─────────────────────────────────── */
    function post(name, data) {
        return fetch(`https://${RES}/${name}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify(data || {}),
        }).then(r => r.json()).catch(() => ({}));
    }

    /* ── i18n ────────────────────────────────────────────── */
    function t(key, fallback) {
        return state.locale[key] || fallback || key;
    }

    function fmt(key, fallback, ...args) {
        let s = t(key, fallback);
        for (const a of args) { s = s.replace('%s', String(a)); }
        return s;
    }

    function applyLocale() {
        document.querySelectorAll('[data-i18n]').forEach(el => {
            const key = el.getAttribute('data-i18n');
            if (state.locale[key]) { el.textContent = state.locale[key]; }
        });
        document.querySelectorAll('[data-i18n-ph]').forEach(el => {
            const key = el.getAttribute('data-i18n-ph');
            if (state.locale[key]) { el.placeholder = state.locale[key]; }
        });
        document.querySelectorAll('[data-i18n-tip]').forEach(el => {
            const key = el.getAttribute('data-i18n-tip');
            if (state.locale[key]) { el.setAttribute('data-tip', state.locale[key]); }
        });
    }

    /* ── toasts ──────────────────────────────────────────── */
    const TOAST_ICONS = {
        success: 'fa-solid fa-circle-check',
        error:   'fa-solid fa-circle-exclamation',
        info:    'fa-solid fa-circle-info',
        warning: 'fa-solid fa-triangle-exclamation',
    };

    function toast(message, type) {
        type = TOAST_ICONS[type] ? type : 'info';
        const root = document.getElementById('toast-root');
        const el = document.createElement('div');
        el.className = `toast ${type}`;
        el.innerHTML = `<i class="${TOAST_ICONS[type]}"></i><span></span>`;
        el.querySelector('span').textContent = String(message);
        root.appendChild(el);
        setTimeout(() => {
            el.classList.add('out');
            setTimeout(() => el.remove(), 220);
        }, 3600);
    }

    /* ── modals ──────────────────────────────────────────── */
    function closeModal() {
        const root = document.getElementById('modal-root');
        root.innerHTML = '';
    }

    // opts: { title, bodyHTML, icon, danger, confirmLabel, cancelLabel,
    //         wide, onConfirm, hideCancel }
    function modal(opts) {
        const root = document.getElementById('modal-root');
        root.innerHTML = '';
        const wrap = document.createElement('div');
        wrap.className = 'modal';
        wrap.innerHTML = `
            <div class="modal-card${opts.wide ? ' wide' : ''}">
                <div class="modal-head">
                    <div class="modal-icon${opts.danger ? ' danger' : ''}">
                        <i class="${opts.icon || 'fa-solid fa-circle-info'}"></i>
                    </div>
                    <div class="modal-title"></div>
                    <button class="modal-close"><i class="fa-solid fa-xmark"></i></button>
                </div>
                <div class="modal-body"></div>
                <div class="modal-foot">
                    <button class="btn btn-ghost" data-act="cancel">
                        <span class="modal-btn-label"></span><span class="keycap">ESC</span>
                    </button>
                    <button class="btn ${opts.danger ? 'btn-danger' : 'btn-primary'}" data-act="ok">
                        <span class="modal-btn-label"></span><span class="keycap">ENTER</span>
                    </button>
                </div>
            </div>`;
        wrap.querySelector('.modal-title').textContent = opts.title || '';
        wrap.querySelector('.modal-body').innerHTML = opts.bodyHTML || '';
        const btnCancel = wrap.querySelector('[data-act=cancel]');
        const btnOk = wrap.querySelector('[data-act=ok]');
        btnCancel.querySelector('.modal-btn-label').textContent = opts.cancelLabel || 'Cancel';
        btnOk.querySelector('.modal-btn-label').textContent = opts.confirmLabel || 'OK';
        if (opts.hideCancel) { btnCancel.hidden = true; }
        wrap.querySelector('.modal-close').onclick = closeModal;
        btnCancel.onclick = closeModal;
        const confirm = () => {
            closeModal();
            if (opts.onConfirm) { opts.onConfirm(wrap); }
        };
        btnOk.onclick = confirm;
        wrap.addEventListener('mousedown', (e) => {
            if (e.target === wrap) { closeModal(); }
        });
        root.appendChild(wrap);
        // focus the first field so ENTER/ESC are live without a click
        const first = wrap.querySelector('.modal-body input, .modal-body textarea');
        if (first) { setTimeout(() => first.focus(), 30); }
        return wrap;
    }

    /* ── tooltips (data-tip) ─────────────────────────────── */
    const tipLayer = document.createElement('div');
    tipLayer.id = 'tip-layer';
    document.body.appendChild(tipLayer);

    // 260 ms of hover before a tooltip shows: instant tooltips turn every
    // pass of the mouse across the rail into a flicker of black boxes.
    const TIP_DELAY = 260;
    let tipTimer = null;

    function hideTip() {
        if (tipTimer) { clearTimeout(tipTimer); tipTimer = null; }
        tipLayer.classList.remove('show');
    }

    function placeTip(el) {
        tipLayer.textContent = el.getAttribute('data-tip');
        const r = el.getBoundingClientRect();
        tipLayer.style.left = '0px'; tipLayer.style.top = '0px';
        tipLayer.classList.add('show');
        const tw = tipLayer.offsetWidth, th = tipLayer.offsetHeight;
        let x, y;
        const pos = el.getAttribute('data-tip-pos');
        if (pos === 'right') {
            x = r.right + 8; y = r.top + r.height / 2 - th / 2;
        } else if (pos === 'left') {
            // used by the dock spine, which hugs the right screen edge —
            // a tooltip to its right would just be clamped back on top of it
            x = r.left - tw - 8; y = r.top + r.height / 2 - th / 2;
        } else {
            x = r.left + r.width / 2 - tw / 2; y = r.bottom + 8;
        }
        x = Math.max(6, Math.min(window.innerWidth - tw - 6, x));
        y = Math.max(6, Math.min(window.innerHeight - th - 6, y));
        tipLayer.style.left = x + 'px';
        tipLayer.style.top = y + 'px';
    }

    document.addEventListener('mouseover', (e) => {
        const el = e.target.closest('[data-tip]');
        if (!el) { hideTip(); return; }
        if (tipTimer) { clearTimeout(tipTimer); }
        tipTimer = setTimeout(() => { tipTimer = null; placeTip(el); }, TIP_DELAY);
    });
    document.addEventListener('mouseout', (e) => {
        if (e.target.closest && e.target.closest('[data-tip]')) { hideTip(); }
    });
    document.addEventListener('mousedown', hideTip, true);

    /* ── chunked blob upload (UI → Lua) ──────────────────── */
    const CHUNK = 200000;   // 200 KB per NUI POST (bigger fails silently)
    let blobSeq = 0;

    async function sendBlob(kind, obj, onProgress) {
        const raw = JSON.stringify(obj);
        const id = `ui_${kind}_${Date.now()}_${++blobSeq}`;
        const total = Math.max(1, Math.ceil(raw.length / CHUNK));
        // seq is 1-based: the Lua side reassembles with table.concat,
        // which ignores a [0] index.
        for (let seq = 0; seq < total; seq++) {
            await post('blobChunk', { id, seq: seq + 1, data: raw.slice(seq * CHUNK, (seq + 1) * CHUNK) });
            if (onProgress) { onProgress((seq + 1) / total); }
        }
        return post('blobCommit', { id, kind });
    }

    /* ── chunked blob download (Lua → UI) ────────────────── */
    const blobRx = {};       // id → { kind, parts: [], meta }
    const blobHandlers = {}; // kind → fn(obj, meta)

    function onBlob(kind, fn) { blobHandlers[kind] = fn; }

    /* ── NUI message dispatch ────────────────────────────── */
    const handlers = {};
    function on(action, fn) { handlers[action] = fn; }

    window.addEventListener('message', (e) => {
        const msg = e.data || {};
        const fn = handlers[msg.action];
        if (fn) { fn(msg.payload || {}); }
    });

    /* core lifecycle */
    on('loading', () => {
        document.getElementById('loading-overlay').hidden = false;
    });

    on('boot', (payload) => {
        if (payload.locale) { state.locale = payload.locale; }
        if (payload.config) { Object.assign(state.config, payload.config); }
        applyLocale();
        // The whole palette is derived from the player's (or the server's)
        // three colours before anything is shown.
        if (window.ApexTheme) { ApexTheme.boot(payload); }
        document.getElementById('loading-overlay').hidden = true;
        document.dispatchEvent(new CustomEvent('apex:boot'));
    });

    on('open', () => {
        state.open = true;
        document.getElementById('app').hidden = false;
        document.dispatchEvent(new CustomEvent('apex:open'));
    });

    on('close', () => {
        state.open = false;
        document.getElementById('app').hidden = true;
        closeModal();
    });

    on('notify', (p) => toast(p.message, p.type));

    // /<command>settings opened the studio straight into the appearance window
    on('openSettings', () => {
        if (window.ApexTheme && !ApexTheme.isOpen()) { ApexTheme.open(); }
    });

    // An admin pushed (or cleared) the server-wide theme while we are open.
    on('themePush', (p) => {
        if (!window.ApexTheme) { return; }
        ApexTheme.boot(p);
        toast(p.serverTheme
            ? t('ts_server_push_rx', 'The server appearance was updated')
            : t('ts_server_clear_rx', 'The server appearance was cleared'), 'info');
    });

    /* blob receive */
    on('blobBegin', (p) => {
        blobRx[p.id] = { kind: p.kind, parts: [], meta: p.meta || {} };
    });
    on('blobChunk', (p) => {
        const rx = blobRx[p.id];
        if (rx) { rx.parts[p.seq - 1] = p.data; }
    });
    on('blobEnd', (p) => {
        const rx = blobRx[p.id];
        delete blobRx[p.id];
        if (!rx) { return; }
        const fn = blobHandlers[rx.kind];
        if (!fn) { return; }
        try {
            fn(JSON.parse(rx.parts.join('')), rx.meta);
        } catch (err) {
            console.error('blob decode failed', rx.kind, err);
            toast('Corrupted payload received (' + rx.kind + ')', 'error');
        }
    });

    /* ── close handling ──────────────────────────────────── */
    function requestClose() {
        state.open = false;
        document.getElementById('app').hidden = true;
        closeModal();
        post('uiClose');
    }

    document.addEventListener('keydown', (e) => {
        const openModal = document.querySelector('#modal-root .modal');
        if (e.key === 'Escape') {
            if (openModal) { closeModal(); return; }
            requestClose();
            return;
        }
        // The ENTER keycap on the confirm button is a real listener, not a
        // decoration. Buttons keep their native activation, and a textarea
        // keeps its newlines.
        if (e.key === 'Enter' && openModal) {
            const tag = (e.target.tagName || '').toUpperCase();
            if (tag === 'TEXTAREA' || tag === 'BUTTON') { return; }
            const ok = openModal.querySelector('[data-act=ok]');
            if (ok && !ok.hidden) { e.preventDefault(); ok.click(); }
        }
    });

    window.addEventListener('DOMContentLoaded', () => {
        document.getElementById('btn-close').addEventListener('click', requestClose);
        post('uiReady');
    });

    return { state, post, t, fmt, toast, modal, closeModal, on, onBlob, sendBlob, requestClose, applyLocale };
})();
