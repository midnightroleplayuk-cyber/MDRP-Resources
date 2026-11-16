/* ============================================================
   Apex Banking — DUI ATM screen (v2)
   Message contract with atmdui/client/dui.lua:
     SET_MODEL · SET_LAYOUT · SET_SCREEN · HIGHLIGHT_BUTTON · CLICK_BUTTON
     PIN_UPDATE · AMOUNT_UPDATE · playSound · SET_PROCESSING
     UPDATE_PROGRESS · NOTIFICATION · INIT_SESSION · END_SESSION · CALIBRATE
     SET_THEME (server-wide colours from /bankadmin)
   Plain DOM, no framework — this page lives inside a DUI texture.
   ============================================================ */
(function () {
    'use strict';

    // dui=true is on the URL the game opens (dui.lua) — the preview bar must
    // never appear on a real ATM even if the DUI exposes no natives.
    const IN_GAME = location.href.indexOf('dui=true') !== -1
        || typeof window.GetParentResourceName !== 'undefined'
        || typeof window.invokeNative !== 'undefined';

    // idle=1 is the attract screen every ATM prop in the world runs
    // (idle.lua). It never sees an account, so it shows a blank card.
    const IS_IDLE = location.href.indexOf('idle=1') !== -1;

    // English defaults — the game sends the active locale in INIT_SESSION.
    const EN = {
        secure: 'Secure', insert_card: 'Please insert your card', reading: 'Reading card details',
        ejecting: 'Ejecting card', take_card: 'Please take your card',
        auth: 'Authentication', enter_pin: 'Enter PIN code', set_pin: 'Set new PIN', attempts: 'Attempts remaining',
        overview: 'Account overview', welcome_back: 'Welcome back', available: 'Available balance',
        quick: 'Quick cash', select_amount: 'Select the amount', limit: 'Balance',
        custom_withdraw: 'Custom withdrawal', cash_deposit: 'Cash deposit',
        transfer_account: 'Destination account', transfer_amount: 'Transfer amount',
        enter_amount: 'Enter amount', enter_account: 'Enter the account number',
        balance_title: 'Account balance', current_balance: 'Current balance',
        complete: 'Transaction complete', print_q: 'Print a receipt?', print_hint: 'The receipt goes to your inventory',
        processed: 'Processed', remaining: 'Remaining', processing: 'Processing',
        card_required: 'Card required', card_missing: 'Card not detected',
        card_missing_desc: 'You need a debit card to use this ATM. Visit any bank branch to get one.',
        to: 'To',
        welcome: 'Welcome', hint_insert: 'Insert your card to begin', select_tx: 'Please select a transaction',
        shield_pin: 'Cover the keypad when entering your PIN', hint_pin: 'Press ENTER when done · CLEAR to correct',
        hint_select: 'Press the button next to your choice', hint_amount: 'Type the amount · ENTER to confirm · CLEAR to correct',
        hint_account: 'Type the account number · ENTER to continue', hint_wait: 'Please wait', hint_take: 'Please remove your cash',
        max_per: 'Maximum per transaction', processing_sub: 'Your transaction is being processed', counting: 'Counting notes',
        thanks: 'Thank you for banking with us', terminal: 'Terminal', encrypted: 'Secure · Encrypted',
        withdraw: 'Withdraw', deposit: 'Deposit', transfer: 'Transfer', balance: 'Balance',
        eject: 'Eject card', custom: 'Custom', back: 'Return', confirm: 'Confirm', next: 'Next',
        cancel: 'Cancel', print: 'Print', no_print: 'No receipt', get_card: 'Get card',
    };

    // ─── Icons (lucide, stroke = currentColor) ─────────────────
    const ICONS = {
        landmark: '<line x1="3" x2="21" y1="22" y2="22"/><line x1="6" x2="6" y1="18" y2="11"/><line x1="10" x2="10" y1="18" y2="11"/><line x1="14" x2="14" y1="18" y2="11"/><line x1="18" x2="18" y1="18" y2="11"/><polygon points="12 2 20 7 4 7"/>',
        banknote: '<rect width="20" height="12" x="2" y="6" rx="2"/><circle cx="12" cy="12" r="2"/><path d="M6 12h.01M18 12h.01"/>',
        deposit: '<path d="M12 3v12"/><path d="m6 9 6 6 6-6"/><path d="M19 21H5"/>',
        transfer: '<path d="M8 3 4 7l4 4"/><path d="M4 7h16"/><path d="m16 21 4-4-4-4"/><path d="M20 17H4"/>',
        wallet: '<path d="M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0 0 4h15a1 1 0 0 1 1 1v4h-3a2 2 0 0 0 0 4h3a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1"/><path d="M3 5v14a2 2 0 0 0 2 2h15a1 1 0 0 0 1-1v-4"/>',
        eject: '<path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" x2="9" y1="12" y2="12"/>',
        check: '<path d="M20 6 9 17l-5-5"/>',
        x: '<path d="M18 6 6 18"/><path d="m6 6 12 12"/>',
        back: '<path d="M9 14 4 9l5-5"/><path d="M4 9h10.5a5.5 5.5 0 0 1 0 11H11"/>',
        next: '<path d="M5 12h14"/><path d="m12 5 7 7-7 7"/>',
        printer: '<path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><path d="M6 9V3a1 1 0 0 1 1-1h10a1 1 0 0 1 1 1v6"/><rect x="6" y="14" width="12" height="8" rx="1"/>',
        lock: '<rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>',
        pencil: '<path d="M12 20h9"/><path d="M16.4 3.6a2.1 2.1 0 0 1 3 3L7.4 18.6a2 2 0 0 1-.9.5l-2.9.8a.5.5 0 0 1-.6-.6l.8-2.9a2 2 0 0 1 .5-.8z"/>',
        receipt: '<path d="M4 2v20l2-1 2 1 2-1 2 1 2-1 2 1 2-1 2 1V2l-2 1-2-1-2 1-2-1-2 1-2-1-2 1Z"/><path d="M16 8h-6a2 2 0 1 0 0 4h4a2 2 0 1 1 0 4H8"/><path d="M12 17.5v-11"/>',
        cardx: '<path d="M22 11V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h9"/><path d="M2 10h20"/><path d="m17 17 4 4"/><path d="m21 17-4 4"/>',
        shield: '<path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"/>',
    };
    const svg = (name, cls) =>
        `<svg data-icon="${name}"${cls ? ` class="${cls}"` : ''} viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">${ICONS[name] || ''}</svg>`;

    document.querySelectorAll('svg[data-icon]').forEach((el) => {
        el.outerHTML = svg(el.getAttribute('data-icon'), el.getAttribute('class'));
    });

    // ─── State ────────────────────────────────────────────────
    const KEY_IDS = ['side_l1', 'side_l2', 'side_l3', 'side_l4', 'side_r1', 'side_r2', 'side_r3', 'side_r4'];
    // mirror of AtmuiConfig.ScreenLayout.default (the game always sends SET_LAYOUT)
    const DEFAULT_LAYOUT = {
        frame: { x: 0, y: 0, sx: 100, sy: 100 },
        keys: {
            side_l1: { x: 0.6, y: 10.125, w: 23.75, h: 8.5 }, side_l2: { x: 0.6, y: 33.875, w: 23.75, h: 8.5 },
            side_l3: { x: 0.6, y: 57.625, w: 23.75, h: 8.5 }, side_l4: { x: 0.6, y: 81.375, w: 23.75, h: 8.5 },
            side_r1: { x: 76.25, y: 10.125, w: 23.75, h: 8.5 }, side_r2: { x: 76.25, y: 33.875, w: 23.75, h: 8.5 },
            side_r3: { x: 76.25, y: 57.625, w: 23.75, h: 8.5 }, side_r4: { x: 76.25, y: 81.375, w: 23.75, h: 8.5 },
        },
    };
    const S = {
        screen: 'welcome',
        player: 'Client',
        balance: 0,
        quick: [20, 50, 100, 200, 500],
        maxWithdraw: 0, maxDeposit: 0,
        pinLen: 4, pinCount: 0, pinTitle: null, attempts: null, pinError: false,
        value: '0', account: '',
        msg: '', amt: 0, bal: 0, kind: '',
        hot: '',
        prefix: 'AP',
        bankName: '',
        terminal: '',
        layout: JSON.parse(JSON.stringify(DEFAULT_LAYOUT)),
        calib: { on: false, mode: 'screen', sel: '' },
        idle: IS_IDLE,
    };
    let L = Object.assign({}, EN);
    const t = (k) => (L[k] != null ? L[k] : (EN[k] != null ? EN[k] : k));

    const $ = (id) => document.getElementById(id);
    const esc = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
    const fmt = (n) => (Number(n) || 0).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    const plain = (n) => (Number(n) || 0).toLocaleString('en-US');
    const money = (n) => {
        const [whole, cents] = fmt(n).split('.');
        return `<span class="money"><span class="cur">$</span>${whole}<span class="cents">.${cents}</span></span>`;
    };
    const num = (v, d) => (typeof v === 'number' && isFinite(v) ? v : (isFinite(parseFloat(v)) ? parseFloat(v) : d));

    // ─── Brand ramp (no color-mix in CEF — computed here) ─────
    function hexToRgb(hex) {
        const m = /^#?([0-9a-f]{6})$/i.exec(String(hex || '').trim());
        if (!m) return null;
        const v = parseInt(m[1], 16);
        return [(v >> 16) & 255, (v >> 8) & 255, v & 255];
    }
    const mix = (a, b, w) => a.map((c, i) => Math.round(c + (b[i] - c) * w));
    const rgb = (c) => `rgb(${c[0]},${c[1]},${c[2]})`;
    const rgba = (c, a) => `rgba(${c[0]},${c[1]},${c[2]},${a})`;
    function applyBrand(hex) {
        const c = hexToRgb(hex); if (!c) return;
        const r = document.documentElement.style;
        r.setProperty('--brand', rgb(c));
        r.setProperty('--brand-hi', rgb(mix(c, [255, 255, 255], 0.28)));
        r.setProperty('--brand-lo', rgb(mix(c, [0, 0, 0], 0.18)));
        r.setProperty('--brand-dk', rgb(mix(c, [0, 0, 0], 0.55)));
        [['06', .06], ['12', .12], ['18', .18], ['25', .25], ['40', .40], ['60', .60]]
            .forEach(([k, a]) => r.setProperty(`--brand-a${k}`, rgba(c, a)));
        const lum = c.map((v) => { v /= 255; return v <= 0.03928 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4); });
        const L1 = 0.2126 * lum[0] + 0.7152 * lum[1] + 0.0722 * lum[2];
        r.setProperty('--on-brand', (1.05 / (L1 + 0.05)) >= ((L1 + 0.05) / 0.05) ? '#FFFFFF' : '#05070D');
    }

    // Server-wide screen background (/bankadmin). The picked colour becomes
    // the top of the panel gradient and the rest of the ink ramp is derived
    // from it, so any colour still reads as a lit screen instead of a wall.
    const INK_DEFAULT = { 0: '#05070D', 1: '#0B0F19', 2: '#111726', 3: '#182035' };
    function applyScreenBg(hex) {
        const r = document.documentElement.style;
        const c = hexToRgb(hex);
        if (!c) {                                   // cleared: back to stock
            [0, 1, 2, 3].forEach((i) => r.setProperty(`--ink-${i}`, INK_DEFAULT[i]));
            return;
        }
        r.setProperty('--ink-2', rgb(c));
        r.setProperty('--ink-1', rgb(mix(c, [0, 0, 0], 0.35)));
        r.setProperty('--ink-0', rgb(mix(c, [0, 0, 0], 0.62)));
        r.setProperty('--ink-3', rgb(mix(c, [255, 255, 255], 0.08)));
    }

    // ─── Layout (calibrated per model) ────────────────────────
    function setLayout(data) {
        const lay = JSON.parse(JSON.stringify(DEFAULT_LAYOUT));
        if (data && data.frame) {
            const f = data.frame;
            lay.frame = { x: num(f.x, 0), y: num(f.y, 0), sx: num(f.sx, 100), sy: num(f.sy, 100) };
        }
        if (data && data.keys) {
            KEY_IDS.forEach((id) => {
                const r = data.keys[id];
                if (r) lay.keys[id] = { x: num(r.x, lay.keys[id].x), y: num(r.y, lay.keys[id].y), w: num(r.w, lay.keys[id].w), h: num(r.h, lay.keys[id].h) };
            });
        }
        S.layout = lay;
        const f = lay.frame;
        $('screen').style.transform = `translate(${f.x}vw, ${f.y}vh) scale(${f.sx / 100}, ${f.sy / 100})`;
        renderKeys(false);
        renderCalib();
    }

    // ─── Side keys per screen ─────────────────────────────────
    // idx = keypad shortcut shown on the key (digits map 1:1 to the pad)
    function sideKeys() {
        const out = [];
        const k = (id, label, o = {}) => out.push({ id, label, ...o });
        if (S.calib.on) {
            KEY_IDS.forEach((id) => k(id, id.replace('side_', '').toUpperCase(), { icon: 'pencil' }));
            return out;
        }
        switch (S.screen) {
            case 'main_menu':
                k('side_l1', t('withdraw'), { icon: 'banknote', idx: '1' });
                k('side_l2', t('deposit'), { icon: 'deposit', idx: '2' });
                k('side_l3', t('transfer'), { icon: 'transfer', idx: '3' });
                k('side_l4', t('balance'), { icon: 'wallet', idx: '4' });
                k('side_r4', t('eject'), { icon: 'eject', accent: true });
                break;
            case 'withdraw':
                S.quick.slice(0, 4).forEach((a, i) => k(`side_l${i + 1}`, `$${plain(a)}`, { idx: String(i + 1), money: true }));
                if (S.quick[4] != null) k('side_r1', `$${plain(S.quick[4])}`, { idx: '5', money: true });
                k('side_r2', t('custom'), { icon: 'pencil', idx: '6' });
                k('side_r4', t('back'), { icon: 'back', accent: true });
                break;
            case 'withdraw_amount': case 'deposit': case 'transfer_amount': case 'transfer_account': case 'pin_entry':
                k('side_r3', S.screen === 'transfer_account' ? t('next') : t('confirm'),
                    { icon: S.screen === 'transfer_account' ? 'next' : 'check', idx: 'ENT' });
                k('side_r4', t('cancel'), { icon: 'x', accent: true });
                break;
            case 'balance':
                k('side_r4', t('back'), { icon: 'back', accent: true });
                break;
            case 'receipt_prompt':
                k('side_l1', t('print'), { icon: 'printer', idx: '1' });
                k('side_r4', t('no_print'), { icon: 'x', idx: '2', accent: true });
                break;
            case 'no_card':
                k('side_r4', t('cancel'), { icon: 'eject', accent: true });
                break;
        }
        return out;
    }

    function keyHtml(key, animate) {
        const r = S.layout.keys[key.id];
        const right = key.id.indexOf('side_r') === 0;
        const cls = ['key'];
        if (key.accent) cls.push('accent');
        if (S.hot === key.id || (S.calib.on && S.calib.sel === key.id)) cls.push('hot');
        return `<div class="slot ${right ? 'right' : 'left'}${animate ? ' enter' : ''}" style="left:${r.x}%;top:${r.y}%;width:${r.w}%;height:${r.h}%">
            <div class="${cls.join(' ')}" data-id="${key.id}">
                <span class="key-arrow"></span>
                ${key.idx ? `<span class="key-idx">${esc(key.idx)}</span>` : ''}
                ${key.icon ? svg(key.icon, 'key-ic') : ''}
                <span class="key-label${key.money ? ' money' : ''}">${esc(key.label)}</span>
            </div>
        </div>`;
    }

    const NO_KEYS = ['welcome', 'card_insert', 'card_eject', 'success'];

    function renderKeys(animate) {
        const keys = (S.calib.on || !NO_KEYS.includes(S.screen)) ? sideKeys() : [];
        $('keys').innerHTML = keys.map((k) => keyHtml(k, animate)).join('');
        fit();
    }

    // ─── Header / footer copy per screen ──────────────────────
    const TITLES = {
        pin_entry: 'auth', main_menu: 'overview', withdraw: 'quick',
        withdraw_amount: 'custom_withdraw', deposit: 'cash_deposit',
        transfer_account: 'transfer_account', transfer_amount: 'transfer_amount',
        balance: 'balance_title', receipt_prompt: 'complete', no_card: 'card_required', success: 'complete',
    };
    const HINTS = {
        welcome: 'hint_insert', card_insert: 'hint_wait', card_eject: 'take_card',
        pin_entry: 'hint_pin', main_menu: 'hint_select', withdraw: 'hint_select',
        withdraw_amount: 'hint_amount', deposit: 'hint_amount', transfer_amount: 'hint_amount',
        transfer_account: 'hint_account', balance: 'hint_select', receipt_prompt: 'hint_select',
        no_card: 'hint_select', success: 'thanks',
    };

    // ─── Screen bodies ────────────────────────────────────────
    const cardArt = (mode) => `<div class="slot-art ${mode}">
        <div class="card-clip"><div class="card-art"><span class="card-brand">${esc(S.bankName || 'DEBIT')}</span><span class="card-name">${
            S.idle ? '' : esc(String(S.player || '').toUpperCase())}</span></div></div>
        <div class="reader"></div>
    </div>`;

    function pinBoxes() {
        let h = '';
        for (let i = 0; i < S.pinLen; i++) {
            const on = i < S.pinCount, next = i === S.pinCount;
            h += `<div class="pin-box${on ? ' on' : ''}${next ? ' next' : ''}">${on ? '✱' : ''}</div>`;
        }
        return h;
    }

    function entryInner() {
        if (S.screen === 'transfer_account') {
            const digits = S.value === '0' ? '' : String(S.value);
            const grouped = digits.replace(/(\d{4})(?=\d)/g, '$1 ');
            return `<span class="entry-value acct"><span class="pfx">${esc(S.prefix)}</span>${
                digits ? esc(grouped) : '<span class="ph">0000 0000 00</span>'}<span class="caret"></span></span>`;
        }
        return `<span class="entry-value"><span class="cur">$</span>${plain(S.value || '0')}<span class="caret"></span></span>`;
    }

    function body() {
        switch (S.screen) {
            case 'welcome':
                return `<div class="full">
                    ${cardArt('insert')}
                    <h1 class="idle-title">${esc(t('welcome'))}<span>.</span></h1>
                    <p class="idle-sub">${esc(t('insert_card'))}</p>
                </div>`;
            case 'card_insert':
                return `<div class="full">
                    ${cardArt('reading')}
                    <h1 class="title dots">${esc(t('reading'))}</h1>
                    <p class="subtitle">${esc(t('hint_wait'))}</p>
                </div>`;
            case 'card_eject':
                return `<div class="full">
                    ${cardArt('eject')}
                    <h1 class="title">${esc(t('take_card'))}</h1>
                    <p class="subtitle">${esc(t('thanks'))}</p>
                </div>`;

            case 'pin_entry': {
                const warn = S.attempts != null && S.attempts >= 0 && S.attempts <= 1;
                return `<div class="content">
                    <h1 class="title">${esc(S.pinTitle || t('enter_pin'))}</h1>
                    <div id="pin-boxes" class="pin-boxes${S.pinError ? ' error' : ''}">${pinBoxes()}</div>
                    ${S.attempts != null && S.attempts >= 0 ? `<div class="pin-meta${warn ? ' warn' : ''}">${esc(t('attempts'))} <b>${S.attempts}</b></div>` : ''}
                    <div class="chips"><span class="chip warn">${svg('shield')}${esc(t('shield_pin'))}</span></div>
                </div>`;
            }

            case 'main_menu':
                return `<div class="content">
                    <p class="subtitle" style="margin:0">${esc(t('welcome_back'))},</p>
                    <h1 class="title who">${esc(S.player)}</h1>
                    <p class="subtitle">${esc(t('select_tx'))}</p>
                    <div class="box">
                        <span class="eyebrow">${esc(t('available'))}</span>
                        ${money(S.balance)}
                    </div>
                </div>`;

            case 'withdraw':
                return `<div class="content">
                    <div class="art-tile">${svg('banknote')}</div>
                    <h1 class="title">${esc(t('select_amount'))}</h1>
                    <div class="chips">
                        <span class="chip"><span class="k">${esc(t('limit'))}</span>$${fmt(S.balance)}</span>
                        ${S.maxWithdraw ? `<span class="chip"><span class="k">${esc(t('max_per'))}</span>$${plain(S.maxWithdraw)}</span>` : ''}
                    </div>
                </div>`;

            case 'withdraw_amount': case 'deposit': case 'transfer_amount': case 'transfer_account': {
                const isAcct = S.screen === 'transfer_account';
                const max = S.screen === 'deposit' ? S.maxDeposit : (S.screen === 'withdraw_amount' ? S.maxWithdraw : 0);
                let chips = `<span class="chip"><span class="k">${esc(t('limit'))}</span>$${fmt(S.balance)}</span>`;
                if (S.screen === 'transfer_amount' && S.account) {
                    const acct = String(S.account).replace(/(\d{4})(?=\d)/g, '$1 ');
                    chips = `<span class="chip"><span class="k">${esc(t('to'))}</span>${esc(S.prefix)} ${esc(acct)}</span>` + chips;
                }
                if (max) chips += `<span class="chip"><span class="k">${esc(t('max_per'))}</span>$${plain(max)}</span>`;
                return `<div class="content">
                    <h1 class="title">${esc(isAcct ? t('enter_account') : t('enter_amount'))}</h1>
                    <div id="entry" class="entry">${entryInner()}</div>
                    <div class="chips">${chips}</div>
                </div>`;
            }

            case 'success': {
                const cash = S.kind === 'withdraw';
                return `<div class="full">
                    ${cash ? '<div class="cash-art"><div class="note n3"></div><div class="note n2"></div><div class="note"></div><div class="mouth"></div></div>'
                           : `<div class="done-mark">${svg('check')}</div>`}
                    <h1 class="title">${esc(S.msg)}</h1>
                    <div class="box" style="width:44%;margin-top:3.4vh">
                        <div class="rows">
                            <div class="row"><span class="eyebrow">${esc(t('processed'))}</span><span class="v">$${fmt(S.amt)}</span></div>
                            <div class="row"><span class="eyebrow green">${esc(t('remaining'))}</span><span class="v green">$${fmt(S.bal)}</span></div>
                        </div>
                    </div>
                </div>`;
            }

            case 'balance':
                return `<div class="content">
                    <h1 class="title who">${esc(S.player)}</h1>
                    <div class="box">
                        <span class="eyebrow">${esc(t('current_balance'))}</span>
                        ${money(S.balance)}
                    </div>
                    <div class="chips"><span class="chip"><span class="k">${esc(t('terminal'))}</span>${esc(S.terminal)} · ${esc($('clock').textContent)}</span></div>
                </div>`;

            case 'receipt_prompt':
                return `<div class="content">
                    <div class="art-tile">${svg('receipt')}</div>
                    <h1 class="title">${esc(t('print_q'))}</h1>
                    <p class="subtitle">${esc(t('print_hint'))}</p>
                </div>`;

            case 'no_card':
                return `<div class="content">
                    <div class="art-tile red">${svg('cardx')}</div>
                    <h1 class="title">${esc(t('card_missing'))}</h1>
                    <p class="subtitle">${esc(t('card_missing_desc'))}</p>
                </div>`;
        }
        return '';
    }

    // ─── Render ───────────────────────────────────────────────
    function render() {
        $('topbar-title').textContent = TITLES[S.screen] ? t(TITLES[S.screen]) : '';
        $('hint').textContent = t(HINTS[S.screen] || 'hint_select');
        $('terminal').textContent = S.terminal ? `${t('terminal')} ${S.terminal}` : '';

        renderKeys(true);

        const stage = $('stage');
        stage.querySelectorAll('.scr').forEach((old) => {
            old.classList.remove('enter');
            old.classList.add('leave');
            setTimeout(() => old.remove(), 200);
        });
        const scr = document.createElement('div');
        scr.className = 'scr enter';
        scr.innerHTML = body();
        stage.appendChild(scr);
        fit();
    }

    // Big figures shrink to their box; long labels/names shrink too.
    function fit() {
        document.querySelectorAll('.scr:not(.leave) .money, .scr:not(.leave) .entry-value').forEach((el) => {
            el.style.fontSize = '';
            const box = el.parentElement;
            const cs = getComputedStyle(box);
            const avail = box.clientWidth - parseFloat(cs.paddingLeft) - parseFloat(cs.paddingRight) - 6;
            const w = el.scrollWidth;
            if (avail > 0 && w > avail) el.style.fontSize = `${parseFloat(getComputedStyle(el).fontSize) * (avail / w)}px`;
        });
        document.querySelectorAll('.key-label, .scr:not(.leave) .who').forEach((el) => {
            el.style.fontSize = '';
            if (el.clientWidth > 0 && el.scrollWidth > el.clientWidth) {
                const k = Math.max(el.classList.contains('who') ? 0.6 : 0, (el.clientWidth / el.scrollWidth) * 0.98);
                el.style.fontSize = `${parseFloat(getComputedStyle(el).fontSize) * k}px`;
            }
        });
    }
    if (document.fonts && document.fonts.ready) document.fonts.ready.then(fit);

    function setHot(id) {
        S.hot = id || '';
        document.querySelectorAll('.key').forEach((el) => {
            const kid = el.getAttribute('data-id');
            el.classList.toggle('hot', kid === S.hot || (S.calib.on && kid === S.calib.sel));
        });
    }

    function pressKey(id) {
        const el = document.querySelector(`.key[data-id="${id}"]`);
        if (!el) return;
        el.classList.remove('press');
        void el.offsetWidth;
        el.classList.add('press');
    }

    function updatePin() {
        const box = document.querySelector('.scr:not(.leave) #pin-boxes');
        if (!box) return;
        box.classList.remove('error');
        box.innerHTML = pinBoxes();
    }

    function updateEntry() {
        const box = document.querySelector('.scr:not(.leave) #entry');
        if (box) { box.innerHTML = entryInner(); fit(); }
    }

    // ─── Calibration overlay ──────────────────────────────────
    function renderCalib() {
        const el = $('calib');
        if (!S.calib.on) { el.hidden = true; el.innerHTML = ''; return; }
        el.hidden = false;
        const f = S.layout.frame;
        const r2 = (v) => (Math.round(v * 100) / 100).toFixed(2);
        let h = `<div class="cal-cross h"></div><div class="cal-cross v"></div>
            <div class="cal-frame${S.calib.sel === 'frame' ? ' sel' : ''}"><span>${S.calib.mode === 'physical' ? 'PHYSICAL BUTTONS' : 'SCREEN AREA'} · x ${r2(f.x)} y ${r2(f.y)} · ${r2(f.sx)}×${r2(f.sy)}</span></div>`;
        KEY_IDS.forEach((id) => {
            const r = S.layout.keys[id];
            const sel = S.calib.sel === id;
            h += `<div class="cal-box${sel ? ' sel' : ''}${id.indexOf('side_r') === 0 ? ' r' : ''}" style="left:${r.x}%;top:${r.y}%;width:${r.w}%;height:${r.h}%">
                <span>${id} · ${r2(r.x)},${r2(r.y)} · ${r2(r.w)}×${r2(r.h)}</span></div>`;
        });
        el.innerHTML = h;
    }

    let toastTimer = null;
    function toast(msg, type) {
        const el = $('toast');
        clearTimeout(toastTimer);
        el.className = `toast ${type || 'error'}`;
        $('toast-msg').textContent = msg;
        el.hidden = false;
        el.style.animation = 'none'; void el.offsetWidth; el.style.animation = '';
        toastTimer = setTimeout(() => { el.hidden = true; }, 3000);
    }

    function setProcessing(on, duration) {
        $('processing').hidden = !on;
        $('proc-label').textContent = duration ? t('counting') : t('hint_wait');
        $('proc-sub').textContent = t('processing_sub');
        $('proc-bar').hidden = !(on && duration);
        setProgress(0);
        if (on) $('hint').textContent = t('hint_wait');
        else $('hint').textContent = t(HINTS[S.screen] || 'hint_select');
    }
    function setProgress(p) {
        p = Math.max(0, Math.min(100, Number(p) || 0));
        $('proc-fill').style.width = `${p}%`;
        $('proc-pct').textContent = `${Math.round(p)}%`;
    }

    function clock() {
        const d = new Date();
        const p = (n) => String(n).padStart(2, '0');
        $('clock').textContent = `${p(d.getHours())}:${p(d.getMinutes())}`;
        $('date').textContent = `${p(d.getDate())}/${p(d.getMonth() + 1)}/${d.getFullYear()}`;
    }
    clock();
    setInterval(clock, 10000);

    // ─── Message bus ──────────────────────────────────────────
    function handle(action, data) {
        data = data || {};
        switch (action) {
            case 'SET_MODEL': break;               // geometry comes with SET_LAYOUT
            case 'SET_LAYOUT': setLayout(data); break;

            case 'SET_SCREEN': {
                const d = data.data || {};
                S.screen = data.screen || 'welcome';
                S.hot = '';
                if (S.screen === 'pin_entry') {
                    S.pinCount = 0;
                    S.pinTitle = d.title || null;
                    S.attempts = d.attempts != null ? d.attempts : null;
                    S.pinError = !!d.error;
                } else if (S.screen === 'welcome') {
                    S.pinCount = 0;
                    S.value = '0';
                }
                if (['withdraw_amount', 'deposit', 'transfer_amount', 'transfer_account'].includes(S.screen)) S.value = '0';
                if (d.balance !== undefined && d.balance !== null) S.balance = d.balance;
                if (d.name) S.player = d.name;
                if (Array.isArray(d.quickAmounts)) S.quick = d.quickAmounts;
                if (d.account) S.account = d.account;
                if (d.message) { S.msg = d.message; S.amt = d.amount || 0; S.bal = d.newBalance || 0; S.kind = d.kind || ''; }
                render();
                break;
            }

            case 'HIGHLIGHT_BUTTON': setHot(data.buttonId); break;
            case 'CLICK_BUTTON':     pressKey(data.buttonId); break;
            case 'PIN_UPDATE':       S.pinCount = data.length || 0; updatePin(); break;
            case 'AMOUNT_UPDATE':    S.value = String(data.value != null ? data.value : '0'); updateEntry(); break;

            case 'playSound':
                if (data.sound === 'dispenser') {
                    try { const a = new Audio('dispenser.ogg'); a.volume = 0.5; a.play().catch(() => {}); } catch (e) { /* ignore */ }
                }
                break;

            case 'SET_PROCESSING':  setProcessing(!!data.processing, data.duration); break;
            case 'UPDATE_PROGRESS': setProgress(data.progress); break;
            case 'NOTIFICATION':    toast(data.message, data.type || 'error'); break;

            case 'INIT_SESSION':
                if (data.idle) S.idle = true;
                S.player = data.playerName || 'Client';
                S.balance = data.bankBalance || 0;
                S.quick = Array.isArray(data.quickAmounts) ? data.quickAmounts : [20, 50, 100, 200, 500];
                S.maxWithdraw = Number(data.maxWithdraw) || 0;
                S.maxDeposit = Number(data.maxDeposit) || 0;
                S.pinLen = Number(data.pinLength) || 4;
                S.prefix = data.ibanPrefix || 'AP';
                S.bankName = data.bankName || '';
                S.terminal = data.terminal || '';
                $('brand-name').textContent = S.bankName;
                if (data.brand) applyBrand(data.brand);
                applyScreenBg(data.bg);
                if (data.locale && typeof data.locale === 'object') L = Object.assign({}, EN, data.locale);
                break;

            case 'SET_THEME':                      // admin repaint, live
                if (data.brand) applyBrand(data.brand);
                applyScreenBg(data.bg === false ? null : data.bg);
                break;

            case 'END_SESSION':
                setProcessing(false);
                break;

            case 'CALIBRATE':
                S.calib = { on: !!data.on, mode: data.mode || 'screen', sel: data.sel || '' };
                renderKeys(false);
                renderCalib();
                break;
        }
    }

    window.addEventListener('message', (e) => {
        const m = e.data;
        if (!m || typeof m !== 'object' || !m.action) return;
        handle(m.action, m.data);
    });

    setLayout(null);
    render();

    // ─── Browser preview (never runs inside the game) ─────────
    if (!IN_GAME) {
        const q = new URLSearchParams(location.search);
        handle('INIT_SESSION', {
            playerName: 'Michael De Santa', bankBalance: 1211650, quickAmounts: [20, 50, 100, 200, 500],
            maxWithdraw: 10000, maxDeposit: 50000,
            pinLength: 4, ibanPrefix: 'AP', bankName: '', brand: q.get('brand') || '#1F5EFF', terminal: '4127',
        });
        const go = (screen, data) => handle('SET_SCREEN', { screen, data: data || {} });
        const presets = {
            welcome: () => go('welcome'),
            card_insert: () => go('card_insert'),
            pin_entry: () => { go('pin_entry', { attempts: 3 }); handle('PIN_UPDATE', { length: 2 }); },
            pin_error: () => go('pin_entry', { attempts: 1, error: true }),
            main_menu: () => go('main_menu', { name: 'Michael De Santa', balance: 1211650 }),
            withdraw: () => go('withdraw', { quickAmounts: [20, 50, 100, 200, 500], balance: 1211650 }),
            withdraw_amount: () => { go('withdraw_amount'); handle('AMOUNT_UPDATE', { value: '2500' }); },
            deposit: () => go('deposit'),
            transfer_account: () => { go('transfer_account'); handle('AMOUNT_UPDATE', { value: '482019' }); },
            transfer_amount: () => { go('transfer_amount', { account: '4820193377' }); handle('AMOUNT_UPDATE', { value: '750' }); },
            balance: () => go('balance', { balance: 1211650, name: 'Michael De Santa' }),
            success: () => go('success', { message: 'Please take your cash', amount: 500, newBalance: 1211150, kind: 'withdraw' }),
            success_deposit: () => go('success', { message: 'Deposit complete', amount: 500, newBalance: 1212150, kind: 'deposit' }),
            receipt_prompt: () => go('receipt_prompt'),
            no_card: () => go('no_card'),
            card_eject: () => go('card_eject'),
            processing: () => { handle('SET_PROCESSING', { processing: true, duration: 11000 }); handle('UPDATE_PROGRESS', { progress: 62 }); },
            toast: () => handle('NOTIFICATION', { message: 'Insufficient funds', type: 'error' }),
            calib: () => { go('main_menu', { name: 'Calibration', balance: 0 }); handle('CALIBRATE', { on: true, mode: 'screen', sel: 'side_l2' }); },
            calib_frame: () => { go('main_menu', { name: 'Calibration', balance: 0 }); handle('CALIBRATE', { on: true, mode: 'screen', sel: 'frame' }); },
        };
        const first = q.get('screen') || 'main_menu';
        (presets[first] || presets.main_menu)();
        if (q.get('hot')) setHot(q.get('hot'));
        if (q.get('proc')) presets.processing();
        if (q.get('toast')) presets.toast();
        if (q.get('fleeca')) handle('SET_LAYOUT', { frame: { x: 0.39, y: 50.78, sx: 49.21, sy: 46.48 } });

        if (!q.has('nobar')) {
            const bar = $('devbar');
            bar.hidden = false;
            bar.innerHTML = Object.keys(presets).map((k) => `<button data-p="${k}">${k}</button>`).join('')
                + '<button data-hot="1">cycle hot</button>';
            const ids = KEY_IDS.concat(['']);
            let hi = 0;
            bar.addEventListener('click', (e) => {
                const b = e.target.closest('button'); if (!b) return;
                if (b.dataset.p) { handle('SET_PROCESSING', { processing: false }); handle('CALIBRATE', { on: false }); presets[b.dataset.p](); }
                if (b.dataset.hot) { setHot(ids[hi % ids.length]); hi++; }
            });
        }
    }
})();
