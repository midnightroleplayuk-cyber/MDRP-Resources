/* ============================================================
   Apex Minimap Studio — theme.js
   ------------------------------------------------------------
   O motor de tema do design system Apex (§3) + a janela de
   definições que um script premium deve expor (§11).

   Nada de 40 cores à mão: TRÊS cores (acento, canvas, texto)
   geram a paleta inteira.
     · rampa do brand por HSL (L−.09 / L+.12 / L+.20), nunca por
       mistura com branco/preto — misturar suja o matiz;
     · tinta sobre o acento por CONTRASTE WCAG real, não por um
       limiar de luminância inventado (que põe preto sobre o azul
       Apex, ilegível);
     · superfícies por fracções fixas a partir do canvas
       (.037 / .066 / .102 / .131) e linhas (.086 / .131 / .19).

   Persistência: KVP por jogador (Lua) + GlobalState para o tema
   forçado pelo servidor — o global ganha até ser limpo. O tema
   viaja como um JSON pequeno; o Lua não conhece as chaves.
   ============================================================ */
'use strict';

window.ApexTheme = (function () {

    /* ════════ cor: utilitários ════════ */

    function clamp(n, a, b) { return Math.max(a, Math.min(b, n)); }

    function hexToRgb(hex) {
        let h = String(hex || '').trim().replace('#', '');
        if (h.length === 3) { h = h[0] + h[0] + h[1] + h[1] + h[2] + h[2]; }
        if (!/^[0-9a-f]{6}$/i.test(h)) { return null; }
        return {
            r: parseInt(h.slice(0, 2), 16),
            g: parseInt(h.slice(2, 4), 16),
            b: parseInt(h.slice(4, 6), 16),
        };
    }

    function rgbToHex(c) {
        const p = (v) => clamp(Math.round(v), 0, 255).toString(16).padStart(2, '0');
        return ('#' + p(c.r) + p(c.g) + p(c.b)).toUpperCase();
    }

    function rgbToHsl(c) {
        const r = c.r / 255, g = c.g / 255, b = c.b / 255;
        const max = Math.max(r, g, b), min = Math.min(r, g, b);
        const l = (max + min) / 2;
        let h = 0, s = 0;
        if (max !== min) {
            const d = max - min;
            s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
            if (max === r) { h = (g - b) / d + (g < b ? 6 : 0); }
            else if (max === g) { h = (b - r) / d + 2; }
            else { h = (r - g) / d + 4; }
            h /= 6;
        }
        return { h, s, l };
    }

    function hslToRgb(c) {
        const h = c.h, s = c.s, l = c.l;
        if (s === 0) { const v = l * 255; return { r: v, g: v, b: v }; }
        const q = l < 0.5 ? l * (1 + s) : l + s - l * s;
        const p = 2 * l - q;
        const hue = (t) => {
            if (t < 0) { t += 1; }
            if (t > 1) { t -= 1; }
            if (t < 1 / 6) { return p + (q - p) * 6 * t; }
            if (t < 1 / 2) { return q; }
            if (t < 2 / 3) { return p + (q - p) * (2 / 3 - t) * 6; }
            return p;
        };
        return { r: hue(h + 1 / 3) * 255, g: hue(h) * 255, b: hue(h - 1 / 3) * 255 };
    }

    /* luminância relativa (WCAG 2.x) */
    function relLum(c) {
        const f = (v) => {
            v /= 255;
            return v <= 0.03928 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4);
        };
        return 0.2126 * f(c.r) + 0.7152 * f(c.g) + 0.0722 * f(c.b);
    }

    function contrast(a, b) {
        const la = relLum(a), lb = relLum(b);
        return (Math.max(la, lb) + 0.05) / (Math.min(la, lb) + 0.05);
    }

    /* tinta sobre uma cor: por contraste REAL, não por limiar */
    function inkOn(c) {
        const L = relLum(c);
        const onWhite = 1.05 / (L + 0.05);
        const onBlack = (L + 0.05) / 0.05;
        return onWhite >= onBlack ? '#FFFFFF' : '#09090A';
    }

    function mix(a, b, t) {
        return { r: a.r + (b.r - a.r) * t, g: a.g + (b.g - a.g) * t, b: a.b + (b.b - a.b) * t };
    }

    /* rampa do brand: mexer SÓ na luminosidade mantém o matiz */
    function lshift(rgb, d) {
        const hsl = rgbToHsl(rgb);
        hsl.l = clamp(hsl.l + d, 0.02, 0.98);
        return hslToRgb(hsl);
    }

    function rgbaStr(c, a) {
        return `rgba(${Math.round(c.r)},${Math.round(c.g)},${Math.round(c.b)},${a})`;
    }

    /* ════════ presets ════════ */

    const PRESETS = [
        { id: 'apex',    name: 'Apex Blue', accent: '#1F5EFF', bg: '#0A0A0B', text: '#F4F4F5' },
        { id: 'ice',     name: 'Ice',       accent: '#2BB3E0', bg: '#080C0E', text: '#F1F6F8' },
        { id: 'emerald', name: 'Emerald',   accent: '#1C7E50', bg: '#080B09', text: '#F1F5F2' },
        { id: 'amber',   name: 'Amber',     accent: '#E5A93C', bg: '#0B0A08', text: '#F6F4EF' },
        { id: 'violet',  name: 'Violet',    accent: '#8B5CF6', bg: '#0A090C', text: '#F4F2F7' },
        { id: 'crimson', name: 'Crimson',   accent: '#E5564B', bg: '#0C0909', text: '#F7F3F3' },
    ];

    const DEFAULTS = {
        preset: 'apex',
        accent: '#1F5EFF',
        bg:     '#0A0A0B',
        text:   '#F4F4F5',
        radius: 8,        /* raio do cartão; o resto da escala deriva daqui */
        glow:   100,      /* intensidade do glow do acento, em %            */
        /* Véu do acento nas margens da TELA. Fica a 0 por omissão: aqui a
           tela é onde se julgam as cores do mapa, e um véu por cima
           falsearia o que o designer está a ver. É uma escolha, não um
           default. */
        veil:   0,
        anim:   true,
        mirror: false,    /* dock à esquerda                                */
    };

    /* ════════ derivação ════════ */

    function normalize(s) {
        const out = Object.assign({}, DEFAULTS, s || {});
        if (!hexToRgb(out.accent)) { out.accent = DEFAULTS.accent; }
        if (!hexToRgb(out.bg))     { out.bg     = DEFAULTS.bg; }
        if (!hexToRgb(out.text))   { out.text   = DEFAULTS.text; }
        out.radius = clamp(Number(out.radius) || DEFAULTS.radius, 0, 18);
        out.glow   = clamp(Number(out.glow)   || 0, 0, 200);
        out.veil   = clamp(Number(out.veil)   || 0, 0, 60);
        out.anim   = out.anim !== false;
        out.mirror = !!out.mirror;
        return out;
    }

    function derive(settings) {
        const s = normalize(settings);
        const accent = hexToRgb(s.accent);
        const bg = hexToRgb(s.bg);
        const text = hexToRgb(s.text);

        /* pólo de contraste: em temas escuros é o branco */
        const dark = relLum(bg) < relLum(text);
        const pole = dark ? { r: 255, g: 255, b: 255 } : { r: 0, g: 0, b: 0 };

        const b500 = accent;
        const b600 = lshift(accent, -0.09);
        const b400 = lshift(accent, +0.12);
        const b300 = lshift(accent, +0.20);

        const surf = (t) => rgbToHex(mix(bg, pole, t));
        const txt  = (t) => rgbToHex(mix(text, bg, t));

        const g = s.glow / 100;
        const r  = s.radius;
        const rs = Math.max(2, Math.round(r * 0.62));
        const rl = Math.round(r * 1.75);

        const tokens = {
            '--brand-500': rgbToHex(b500),
            '--brand-600': rgbToHex(b600),
            '--brand-400': rgbToHex(b400),
            '--brand-300': rgbToHex(b300),
            '--brand-ink': inkOn(b500),
            '--brand-rgb': `${Math.round(accent.r)} ${Math.round(accent.g)} ${Math.round(accent.b)}`,

            '--brand-a06': rgbaStr(accent, 0.06),
            '--brand-a10': rgbaStr(accent, 0.10),
            '--brand-a12': rgbaStr(accent, 0.12),
            '--brand-a15': rgbaStr(accent, 0.15),
            '--brand-a28': rgbaStr(accent, 0.28),
            '--brand-a40': rgbaStr(accent, 0.40),

            '--surface-0': rgbToHex(bg),
            '--surface-1': surf(0.037),
            '--surface-2': surf(0.066),
            '--surface-3': surf(0.102),
            '--surface-4': surf(0.131),
            '--surface-5': surf(0.190),

            '--line-1': surf(0.086),
            '--line-2': surf(0.131),
            '--line-3': surf(0.190),
            '--line-4': surf(0.280),

            '--text-1': rgbToHex(text),
            '--text-2': txt(0.28),
            '--text-3': txt(0.45),
            '--text-4': txt(0.62),

            '--r-sm': rs + 'px',
            '--r':    r + 'px',
            '--r-lg': rl + 'px',

            '--glow-brand':      `0 8px 28px -8px ${rgbaStr(accent, 0.55 * g)}`,
            '--glow-brand-soft': `0 0 22px -4px ${rgbaStr(accent, 0.35 * g)}`,
            '--halo':            `0 0 90px -28px ${rgbaStr(accent, 0.16 * g)}`,

            /* véu do acento nas margens: CINCO paragens — duas fazem banda */
            '--veil-1': rgbaStr(accent, (s.veil / 100) * 1.00),
            '--veil-2': rgbaStr(accent, (s.veil / 100) * 0.55),
            '--veil-3': rgbaStr(accent, (s.veil / 100) * 0.28),
            '--veil-4': rgbaStr(accent, (s.veil / 100) * 0.11),
            '--veil-5': rgbaStr(accent, 0),
        };
        return { settings: s, tokens: tokens };
    }

    /* ════════ aplicação ════════ */

    let current = normalize(null);
    let serverForced = null;      /* tema global do servidor (ganha) */

    function apply(settings, opts) {
        const d = derive(settings);
        const root = document.documentElement;
        for (const k in d.tokens) { root.style.setProperty(k, d.tokens[k]); }
        root.classList.toggle('no-anim', !d.settings.anim);
        const ws = document.querySelector('.workspace');
        if (ws) { ws.classList.toggle('mirror', d.settings.mirror); }
        if (!opts || !opts.transient) { current = d.settings; }
        // quem desenha em canvas (o chrome da tela) relê o acento daqui
        document.dispatchEvent(new CustomEvent('apex:theme', { detail: d }));
        return d;
    }

    function get() { return Object.assign({}, current); }

    /* ── persistência ── */

    const LS_KEY = 'apex_minimap_theme';
    const LS_SAVED = 'apex_minimap_themes';   /* temas guardados pelo jogador */

    function save(settings) {
        const s = normalize(settings);
        current = s;
        try { localStorage.setItem(LS_KEY, JSON.stringify(s)); } catch (e) { /* CEF privado */ }
        if (window.App && App.post) { App.post('themeSave', { theme: s }); }
        return s;
    }

    function loadLocal() {
        try {
            const raw = localStorage.getItem(LS_KEY);
            if (raw) { return normalize(JSON.parse(raw)); }
        } catch (e) { /* ignora */ }
        return null;
    }

    function savedThemes() {
        try { return JSON.parse(localStorage.getItem(LS_SAVED) || '[]'); }
        catch (e) { return []; }
    }

    function writeSavedThemes(list) {
        try { localStorage.setItem(LS_SAVED, JSON.stringify(list.slice(0, 24))); }
        catch (e) { /* ignora */ }
    }

    let isAdmin = false;

    /* Boot: o tema forçado pelo servidor ganha até ser limpo. */
    function boot(payload) {
        payload = payload || {};
        // Config.theme (Lua) é o ponto de partida do servidor — passa a ser
        // o "Defaults" do botão de reset, não uma cópia morta do azul.
        if (payload.themeDefault) {
            const d = payload.themeDefault;
            for (const k of ['accent', 'bg', 'text', 'radius', 'glow', 'veil', 'anim', 'mirror']) {
                if (d[k] !== undefined && d[k] !== null) { DEFAULTS[k] = d[k]; }
            }
        }
        serverForced = payload.serverTheme ? normalize(payload.serverTheme) : null;
        const mine = payload.theme ? normalize(payload.theme) : loadLocal();
        apply(serverForced || mine || DEFAULTS);
        if (payload.themeAdmin !== undefined) { isAdmin = !!payload.themeAdmin; }
    }

    /* ════════════════════════════════════════════════════════
       JANELA DE DEFINIÇÕES (§11)
       Rectangular e central: navegação à esquerda, conteúdo ao
       meio, PREVIEW VIVO à direita, acções no rodapé.
       ════════════════════════════════════════════════════════ */

    let win = null;          /* elemento aberto            */
    let draft = null;        /* estado a ser editado       */
    let baseline = null;     /* estado ao abrir (Cancelar) */

    function el(tag, cls, html) {
        const n = document.createElement(tag);
        if (cls) { n.className = cls; }
        if (html != null) { n.innerHTML = html; }
        return n;
    }

    function T(key, fallback) {
        return (window.App && App.t) ? App.t(key, fallback) : fallback;
    }

    function dirty() {
        return JSON.stringify(normalize(draft)) !== JSON.stringify(normalize(baseline));
    }

    function markDirty() {
        if (!win) { return; }
        const chip = win.querySelector('.ts-chip-unsaved');
        if (chip) { chip.hidden = !dirty(); }
    }

    function live() {
        apply(draft, { transient: true });
        renderPreview();
        markDirty();
    }

    /* ── separadores ── */

    const TABS = [
        { id: 'themes',    icon: 'fa-solid fa-swatchbook',  label: 'Themes' },
        { id: 'colors',    icon: 'fa-solid fa-palette',     label: 'Colors' },
        { id: 'interface', icon: 'fa-solid fa-sliders',     label: 'Interface' },
        { id: 'layout',    icon: 'fa-solid fa-table-columns', label: 'Layout' },
        { id: 'server',    icon: 'fa-solid fa-server',      label: 'Server' },
    ];

    function open() {
        close();
        baseline = get();
        draft = get();

        const wrap = el('div', 'modal');
        wrap.innerHTML = `
            <div class="modal-card xl">
                <div class="modal-head">
                    <div class="modal-icon"><i class="fa-solid fa-sliders"></i></div>
                    <div class="modal-title">${T('ts_title', 'Appearance')}</div>
                    <span class="ts-chip-unsaved" hidden>UNSAVED</span>
                    <button class="modal-close"><i class="fa-solid fa-xmark"></i></button>
                </div>
                <div class="tstudio">
                    <nav class="ts-nav">
                        ${TABS.map((t, i) => `
                            <button class="ts-nav-item${i === 0 ? ' active' : ''}" data-ts="${t.id}">
                                <i class="${t.icon}"></i><span>${T('ts_tab_' + t.id, t.label)}</span>
                            </button>`).join('')}
                        <div class="ts-nav-foot">${T('ts_foot', 'Saved per player. A server theme overrides it until cleared.')}</div>
                    </nav>
                    <div class="ts-body"></div>
                    <aside class="ts-preview"></aside>
                </div>
                <div class="modal-foot">
                    <span class="ts-foot-note">${T('ts_note', 'Changes preview live.')}</span>
                    <button class="btn btn-ghost" data-act="reset"><i class="fa-solid fa-arrow-rotate-left"></i><span>${T('ts_reset', 'Defaults')}</span></button>
                    <button class="btn btn-ghost" data-act="cancel"><span>${T('ts_cancel', 'Cancel')}</span><span class="keycap">ESC</span></button>
                    <button class="btn btn-primary" data-act="save"><i class="fa-solid fa-check"></i><span>${T('ts_save', 'Save')}</span><span class="keycap">ENTER</span></button>
                </div>
            </div>`;
        document.getElementById('modal-root').appendChild(wrap);
        win = wrap;

        wrap.querySelectorAll('.ts-nav-item').forEach(btn => {
            btn.addEventListener('click', () => {
                wrap.querySelectorAll('.ts-nav-item').forEach(b => b.classList.toggle('active', b === btn));
                renderPanel(btn.dataset.ts);
            });
        });
        wrap.querySelector('.modal-close').addEventListener('click', cancel);
        wrap.querySelector('[data-act=cancel]').addEventListener('click', cancel);
        wrap.querySelector('[data-act=reset]').addEventListener('click', () => {
            draft = Object.assign({}, DEFAULTS);
            renderPanel(activeTab);
            live();
        });
        wrap.querySelector('[data-act=save]').addEventListener('click', commit);
        wrap.addEventListener('mousedown', (e) => { if (e.target === wrap) { cancel(); } });

        renderPanel('themes');
        renderPreview();
    }

    function close() {
        if (win && win.parentNode) { win.parentNode.removeChild(win); }
        win = null;
    }

    function cancel() {
        apply(baseline);          /* devolve o que estava */
        close();
    }

    function commit() {
        save(draft);
        close();
        if (window.App && App.toast) { App.toast(T('ts_saved', 'Appearance saved'), 'success'); }
    }

    function isOpen() { return !!win; }

    /* ── painéis ── */

    let activeTab = 'themes';

    function renderPanel(tab) {
        activeTab = tab;
        const body = win.querySelector('.ts-body');
        body.innerHTML = '';
        const panel = el('div', 'ts-panel active');
        body.appendChild(panel);
        if (tab === 'themes') { panelThemes(panel); }
        else if (tab === 'colors') { panelColors(panel); }
        else if (tab === 'interface') { panelInterface(panel); }
        else if (tab === 'layout') { panelLayout(panel); }
        else { panelServer(panel); }
    }

    function row(panel, label, build) {
        const r = el('div', 'ts-row');
        r.appendChild(el('span', 'micro-label ts-row-label', label));
        const body = el('div', 'ts-row-body');
        r.appendChild(body);
        panel.appendChild(r);
        build(body);
        return r;
    }

    /* — Themes: presets com mini-mock de 3 camadas + import/export — */
    function panelThemes(panel) {
        panel.appendChild(el('span', 'micro-label section', T('ts_presets', 'Presets')));
        const grid = el('div', 'ts-preset-grid');
        for (const p of PRESETS) {
            const d = derive({ accent: p.accent, bg: p.bg, text: p.text });
            const card = el('button', 'ts-preset' + (draft.preset === p.id ? ' active' : ''));
            card.innerHTML = `
                <span class="ts-mock3" style="background:${d.tokens['--surface-1']}">
                    <span style="background:${d.tokens['--surface-3']}"></span>
                    <span style="background:${d.tokens['--surface-4']}"></span>
                    <span style="background:${d.tokens['--brand-500']}"></span>
                </span>
                <span class="ts-preset-name">${p.name}</span>`;
            card.addEventListener('click', () => {
                draft.preset = p.id; draft.accent = p.accent; draft.bg = p.bg; draft.text = p.text;
                renderPanel('themes');
                live();
            });
            grid.appendChild(card);
        }
        panel.appendChild(grid);

        /* temas do jogador */
        panel.appendChild(el('span', 'micro-label section', T('ts_mine', 'My themes')));
        const mine = savedThemes();
        if (!mine.length) {
            panel.appendChild(el('div', 'empty-state small',
                `<i class="fa-solid fa-bookmark"></i><span>${T('ts_mine_empty', 'Save the current look to reuse it later')}</span>`));
        } else {
            const g2 = el('div', 'ts-preset-grid');
            for (let i = 0; i < mine.length; i++) {
                const it = mine[i];
                const d = derive(it.settings);
                const card = el('button', 'ts-preset');
                card.innerHTML = `
                    <span class="ts-mock3" style="background:${d.tokens['--surface-1']}">
                        <span style="background:${d.tokens['--surface-3']}"></span>
                        <span style="background:${d.tokens['--surface-4']}"></span>
                        <span style="background:${d.tokens['--brand-500']}"></span>
                    </span>
                    <span class="ts-preset-name">${it.name}</span>`;
                card.addEventListener('click', () => { draft = normalize(it.settings); renderPanel('themes'); live(); });
                card.addEventListener('contextmenu', (e) => {
                    e.preventDefault();
                    const list = savedThemes(); list.splice(i, 1); writeSavedThemes(list);
                    renderPanel('themes');
                });
                g2.appendChild(card);
            }
            panel.appendChild(g2);
            panel.appendChild(el('p', 'pane-hint', T('ts_mine_hint', 'Right-click a saved theme to delete it.')));
        }

        const saveRow = el('div', 'code-row');
        const nameIn = el('input', 'input');
        nameIn.placeholder = T('ts_name_ph', 'Theme name');
        nameIn.maxLength = 28;
        const saveBtn = el('button', 'btn btn-ghost', `<i class="fa-solid fa-bookmark"></i><span>${T('ts_store', 'Save look')}</span>`);
        saveBtn.addEventListener('click', () => {
            const list = savedThemes();
            list.unshift({ name: (nameIn.value || 'Custom').slice(0, 28), settings: normalize(draft) });
            writeSavedThemes(list);
            renderPanel('themes');
        });
        saveRow.appendChild(nameIn); saveRow.appendChild(saveBtn);
        panel.appendChild(saveRow);

        /* import / export por código JSON */
        panel.appendChild(el('span', 'micro-label section', T('ts_code', 'Theme code')));
        const ta = el('textarea', 'input mono');
        ta.rows = 3;
        ta.value = JSON.stringify(normalize(draft));
        panel.appendChild(ta);
        const codeRow = el('div', 'code-row');
        const copyBtn = el('button', 'btn btn-ghost', `<i class="fa-regular fa-copy"></i><span>${T('ts_copy', 'Copy')}</span>`);
        copyBtn.addEventListener('click', () => {
            ta.select();
            try { document.execCommand('copy'); } catch (e) { /* */ }
            if (window.App && App.toast) { App.toast(T('ts_copied', 'Theme code copied'), 'success'); }
        });
        const applyBtn = el('button', 'btn btn-soft', `<i class="fa-solid fa-file-import"></i><span>${T('ts_apply_code', 'Apply code')}</span>`);
        applyBtn.addEventListener('click', () => {
            try {
                draft = normalize(JSON.parse(ta.value));
                renderPanel('themes');
                live();
            } catch (e) {
                if (window.App && App.toast) { App.toast(T('ts_bad_code', 'That is not a valid theme code'), 'error'); }
            }
        });
        codeRow.appendChild(copyBtn); codeRow.appendChild(applyBtn);
        panel.appendChild(codeRow);
    }

    /* — Colors: acento / fundo / texto + leitura WCAG ao vivo — */
    const QUICK_ACCENT = ['#1F5EFF', '#2BB3E0', '#1C7E50', '#34C77B', '#E5A93C', '#FF7A3C', '#E5564B', '#8B5CF6'];
    const QUICK_BG = ['#0A0A0B', '#08090C', '#0C0C0E', '#101012', '#141416'];

    function colorControl(body, key, quick) {
        const swatches = el('div', 'ts-quick');
        for (const c of quick) {
            const s = el('button', 'swatch' + (draft[key].toUpperCase() === c ? ' active' : ''));
            s.style.background = c;
            s.title = c;
            s.addEventListener('click', () => { draft[key] = c; draft.preset = 'custom'; renderPanel('colors'); live(); });
            swatches.appendChild(s);
        }
        const picker = el('input');
        picker.type = 'color';
        picker.value = draft[key];
        const hex = el('input', 'input ts-hex');
        hex.value = draft[key].toUpperCase();
        picker.addEventListener('input', () => {
            draft[key] = picker.value.toUpperCase(); draft.preset = 'custom';
            hex.value = draft[key]; live(); renderWcag();
        });
        hex.addEventListener('change', () => {
            if (!hexToRgb(hex.value)) { hex.value = draft[key]; return; }
            draft[key] = rgbToHex(hexToRgb(hex.value)); draft.preset = 'custom';
            picker.value = draft[key]; live(); renderWcag();
        });
        body.appendChild(picker);
        body.appendChild(hex);
        body.appendChild(swatches);
    }

    function renderWcag() {
        if (!win) { return; }
        const box = win.querySelector('.ts-wcag-box');
        if (!box) { return; }
        const accent = hexToRgb(draft.accent), bg = hexToRgb(draft.bg), text = hexToRgb(draft.text);
        const ink = hexToRgb(inkOn(accent));
        // Os limiares não são todos iguais: texto corrido é 4.5/7 (WCAG
        // 1.4.3/1.4.6), mas o acento contra o fundo é um COMPONENTE, não
        // texto — aí a régua é 3:1 (1.4.11). Usar 4.5 em toda a linha
        // marcava o azul Apex como "LOW" sem que nada estivesse errado.
        const pairs = [
            { label: 'TEXT / BG',    ratio: contrast(text, bg),    aa: 4.5, aaa: 7 },
            { label: 'INK / ACCENT', ratio: contrast(ink, accent), aa: 4.5, aaa: 7 },
            { label: 'ACCENT / BG',  ratio: contrast(accent, bg),  aa: 3,   aaa: 4.5 },
        ];
        box.innerHTML = pairs.map(p => {
            const grade = p.ratio >= p.aaa ? 'aaa' : (p.ratio >= p.aa ? 'aa' : 'low');
            const name = grade === 'aaa' ? 'AAA' : (grade === 'aa' ? 'AA' : 'LOW');
            return `<span class="ts-wcag ${grade}">${p.label} · ${p.ratio.toFixed(1)}:1 · ${name}</span>`;
        }).join('');
    }

    function panelColors(panel) {
        panel.appendChild(el('span', 'micro-label section', T('ts_colors', 'Colors')));
        row(panel, T('ts_accent', 'Accent'), (b) => colorControl(b, 'accent', QUICK_ACCENT));
        row(panel, T('ts_bg', 'Canvas'),     (b) => colorControl(b, 'bg', QUICK_BG));
        row(panel, T('ts_text', 'Text'),     (b) => colorControl(b, 'text', ['#F4F4F5', '#EDEDEF', '#E4E4E7', '#FFFFFF']));

        panel.appendChild(el('span', 'micro-label section', T('ts_contrast', 'Contrast (WCAG)')));
        const box = el('div', 'ts-wcag-box ts-quick');
        panel.appendChild(box);
        renderWcag();

        panel.appendChild(el('span', 'micro-label section', T('ts_ramp', 'Derived accent ramp')));
        const d = derive(draft);
        const ramp = el('div', 'ts-ramp');
        ['--brand-600', '--brand-500', '--brand-400', '--brand-300'].forEach(k => {
            const s = el('span'); s.style.background = d.tokens[k]; s.title = k + ' ' + d.tokens[k];
            ramp.appendChild(s);
        });
        panel.appendChild(ramp);

        panel.appendChild(el('span', 'micro-label section', T('ts_surfaces', 'Surface scale')));
        const scale = el('div', 'ts-scale');
        ['--surface-0', '--surface-1', '--surface-2', '--surface-3', '--surface-4', '--line-3'].forEach(k => {
            const s = el('span'); s.style.background = d.tokens[k]; s.title = k + ' ' + d.tokens[k];
            scale.appendChild(s);
        });
        panel.appendChild(scale);
    }

    /* — Interface: raio, glow, véu, animações — */
    function slider(panel, label, key, min, max, unit) {
        row(panel, label, (b) => {
            const inp = el('input');
            inp.type = 'range'; inp.min = min; inp.max = max; inp.value = draft[key];
            inp.style.flex = '1';
            const out = el('span', 'opt-val mono', draft[key] + unit);
            inp.addEventListener('input', () => {
                draft[key] = Number(inp.value);
                out.textContent = inp.value + unit;
                live();
            });
            b.appendChild(inp); b.appendChild(out);
        });
    }

    function panelInterface(panel) {
        panel.appendChild(el('span', 'micro-label section', T('ts_interface', 'Interface')));
        slider(panel, T('ts_radius', 'Corner radius'), 'radius', 0, 18, 'px');
        slider(panel, T('ts_glow', 'Accent glow'), 'glow', 0, 200, '%');
        slider(panel, T('ts_veil', 'Edge veil'), 'veil', 0, 60, '%');
        row(panel, T('ts_anim', 'Animations'), (b) => {
            const lab = el('label', 'check-row');
            lab.innerHTML = `<input type="checkbox" ${draft.anim ? 'checked' : ''}><span>${T('ts_anim_on', 'Animate panels and transitions')}</span>`;
            lab.querySelector('input').addEventListener('change', (e) => { draft.anim = e.target.checked; live(); });
            b.appendChild(lab);
        });
        panel.appendChild(el('p', 'pane-hint', T('ts_interface_hint',
            'The radius drives the whole shape scale: buttons and inputs derive from the card radius, the shell from both.')));
    }

    /* — Layout: lado do painel — */
    function panelLayout(panel) {
        panel.appendChild(el('span', 'micro-label section', T('ts_layout', 'Panel side')));
        const grid = el('div', 'ts-preset-grid');
        [{ v: false, name: T('ts_right', 'Dock right') }, { v: true, name: T('ts_left', 'Dock left') }].forEach(opt => {
            const card = el('button', 'ts-preset' + (draft.mirror === opt.v ? ' active' : ''));
            const bars = opt.v
                ? `<span style="background:var(--brand-500);width:34%"></span><span style="background:var(--surface-4);width:78%"></span><span style="background:var(--surface-3);width:52%"></span>`
                : `<span style="background:var(--surface-3);width:52%"></span><span style="background:var(--surface-4);width:78%"></span><span style="background:var(--brand-500);width:34%;margin-left:auto"></span>`;
            card.innerHTML = `<span class="ts-mock3" style="background:var(--surface-1)">${bars}</span>
                              <span class="ts-preset-name">${opt.name}</span>`;
            card.addEventListener('click', () => { draft.mirror = opt.v; renderPanel('layout'); live(); });
            grid.appendChild(card);
        });
        panel.appendChild(grid);
        panel.appendChild(el('p', 'pane-hint', T('ts_layout_hint',
            'Mirrors the whole workspace: the dock, its spine and the seams follow.')));
    }

    /* — Server: tema global de admin — */
    function panelServer(panel) {
        panel.appendChild(el('span', 'micro-label section', T('ts_server', 'Server theme')));
        if (!isAdmin) {
            panel.appendChild(el('div', 'empty-state small',
                `<i class="fa-solid fa-lock"></i><span>${T('ts_server_denied', 'Needs the ace apex_minimap.themeadmin')}</span>`));
            return;
        }
        panel.appendChild(el('p', 'pane-hint', T('ts_server_hint',
            'Push this look to every player. It overrides their own theme until it is cleared.')));
        const push = el('button', 'btn btn-soft btn-block',
            `<i class="fa-solid fa-tower-broadcast"></i><span>${T('ts_server_push', 'Apply for everyone')}</span>`);
        push.addEventListener('click', () => {
            if (window.App) { App.post('themeGlobal', { theme: normalize(draft) }); App.toast(T('ts_server_done', 'Server theme applied'), 'success'); }
        });
        const clear = el('button', 'btn btn-ghost btn-block',
            `<i class="fa-solid fa-eraser"></i><span>${T('ts_server_clear', 'Clear the server theme')}</span>`);
        clear.addEventListener('click', () => {
            if (window.App) { App.post('themeGlobal', { clear: true }); App.toast(T('ts_server_cleared', 'Server theme cleared'), 'info'); }
        });
        panel.appendChild(push);
        panel.appendChild(clear);
        if (serverForced) {
            panel.appendChild(el('div', 'export-note', T('ts_server_active', 'A server theme is currently forced.')));
        }
    }

    /* ── preview vivo ── */
    function renderPreview() {
        if (!win) { return; }
        const box = win.querySelector('.ts-preview');
        box.innerHTML = `
            <span class="micro-label">${T('ts_preview', 'Live preview')}</span>
            <div class="ts-preview-shell">
                <div class="ts-preview-head">
                    <span class="ts-preview-mark"><i class="fa-solid fa-map-location-dot"></i></span>
                    <span>
                        <div class="ts-preview-title">Apex Minimap</div>
                        <div class="ts-preview-sub">4096 × 6144</div>
                    </span>
                </div>
                <div class="ts-preview-row is-active">
                    <span class="ts-preview-tile"><i class="fa-solid fa-paintbrush"></i></span>
                    <span class="ts-preview-name">Highway paint</span>
                    <span class="ts-preview-chip">PAINT</span>
                </div>
                <div class="ts-preview-row">
                    <span class="ts-preview-tile"><i class="fa-solid fa-font"></i></span>
                    <span class="ts-preview-name">Vespucci</span>
                    <span class="ts-preview-chip">TEXT</span>
                </div>
                <div class="ts-preview-row">
                    <span class="ts-preview-tile"><i class="fa-solid fa-location-dot"></i></span>
                    <span class="ts-preview-name">Garage</span>
                    <span class="ts-preview-chip">BLIP</span>
                </div>
                <div class="ts-preview-btns">
                    <button class="btn btn-ghost" type="button">Cancel</button>
                    <button class="btn btn-primary" type="button">Export</button>
                </div>
            </div>`;
    }

    /* ── teclado: ENTER guarda, ESC cancela (listeners a sério) ── */
    document.addEventListener('keydown', (e) => {
        if (!win) { return; }
        if (e.key === 'Enter' && e.target.tagName !== 'TEXTAREA') {
            e.preventDefault(); e.stopPropagation();
            commit();
        } else if (e.key === 'Escape') {
            e.preventDefault(); e.stopPropagation();
            cancel();
        }
    }, true);

    /* Aplica o último tema conhecido JÁ (antes do boot do Lua chegar), para
       que nem o overlay de carregamento pisque na paleta errada. */
    apply(loadLocal() || DEFAULTS);

    return {
        PRESETS, DEFAULTS,
        derive, apply, get, save, boot, open, close, isOpen,
        // utilitários expostos para quem precise (o preview de export, p.ex.)
        hexToRgb, rgbToHex, contrast, inkOn,
    };
})();
