/* ============================================================
   Apex Minimap Studio — panels.js
   ------------------------------------------------------------
   Everything around the canvas: tool rail wiring, contextual
   tool options, layers dock + inspector, themes, projects,
   export, the live manager modal, statusbar readouts.
   ============================================================ */
'use strict';

(function () {

    const $ = (sel) => document.querySelector(sel);
    const $$ = (sel) => Array.from(document.querySelectorAll(sel));

    let currentProject = { id: null, name: '' };
    let cayoPreviewOn = false;
    let booted = false;

    /* ════════ CUSTOM SELECT ════════
       The native <select> popup is drawn by Chromium, not by us, so it
       never matches the studio. Every select is hidden (it stays in the
       DOM as the value/event source) and driven by a styled button + a
       floating menu appended to <body> — position:fixed, so no scroll
       container can clip it. A MutationObserver picks up selects that
       are built later (modals, dynamically-filled pickers) on its own. */

    let openCsel = null;   // { close } of the menu currently open

    function closeCsel() {
        if (openCsel) { openCsel.close(); openCsel = null; }
    }

    function mk(tag, cls, text) {
        const n = document.createElement(tag);
        if (cls) { n.className = cls; }
        if (text != null) { n.textContent = text; }
        return n;
    }

    function enhanceSelect(select) {
        if (!select || select.dataset.csel || !select.parentNode) { return; }
        select.dataset.csel = '1';

        const wrap = mk('div', 'csel');
        select.parentNode.insertBefore(wrap, select);
        wrap.appendChild(select);
        select.classList.add('csel-native');
        // the native select carried the sizing classes/inline height; the
        // button replaces it visually, so hand those over to the wrapper
        if (select.style.width) { wrap.style.width = select.style.width; }

        const btn = mk('button', 'csel-btn');
        btn.type = 'button';
        const label = mk('span', 'csel-label');
        const caret = mk('i', 'fa-solid fa-chevron-down csel-caret');
        btn.appendChild(label);
        btn.appendChild(caret);
        wrap.appendChild(btn);

        // Font pickers preview each face in its own typeface.
        const isFontPicker = select.id === 'ps-font';

        const optText = () => {
            const o = select.options[select.selectedIndex];
            return o ? o.textContent : '';
        };
        const syncLabel = () => {
            label.textContent = optText();
            if (isFontPicker) { label.style.fontFamily = `'${optText()}', 'Inter', sans-serif`; }
        };
        syncLabel();

        function openMenu() {
            closeCsel();
            const menu = mk('div', 'csel-menu' + (isFontPicker ? ' font-preview' : ''));
            Array.prototype.forEach.call(select.options, (opt, i) => {
                const it = mk('button', 'csel-item' + (i === select.selectedIndex ? ' active' : ''));
                it.type = 'button';
                const lbl = mk('span', 'csel-item-label', opt.textContent);
                if (isFontPicker) { lbl.style.fontFamily = `'${opt.value || opt.textContent}', 'Inter', sans-serif`; }
                it.appendChild(lbl);
                it.addEventListener('click', (e) => {
                    e.stopPropagation();
                    if (select.selectedIndex !== i) {
                        select.selectedIndex = i;
                        select.dispatchEvent(new Event('change', { bubbles: true }));
                    }
                    syncLabel();
                    closeCsel();
                });
                menu.appendChild(it);
            });
            document.body.appendChild(menu);

            // fixed-position, clamped to the viewport, flips up when the
            // list would run off the bottom
            const r = btn.getBoundingClientRect();
            menu.style.minWidth = r.width + 'px';
            const mh = menu.offsetHeight, mw = menu.offsetWidth;
            const below = window.innerHeight - r.bottom;
            const top = (mh <= below || below >= r.top) ? (r.bottom + 4) : Math.max(6, r.top - mh - 4);
            const left = Math.min(r.left, window.innerWidth - mw - 6);
            menu.style.top = top + 'px';
            menu.style.left = Math.max(6, left) + 'px';
            const act = menu.querySelector('.csel-item.active');
            if (act && act.scrollIntoView) { act.scrollIntoView({ block: 'nearest' }); }

            btn.classList.add('open');
            const onDoc = (e) => {
                if (!menu.contains(e.target) && !btn.contains(e.target)) { closeCsel(); }
            };
            const onScroll = () => closeCsel();
            setTimeout(() => document.addEventListener('mousedown', onDoc, true), 0);
            window.addEventListener('scroll', onScroll, true);

            openCsel = {
                close: () => {
                    document.removeEventListener('mousedown', onDoc, true);
                    window.removeEventListener('scroll', onScroll, true);
                    if (menu.parentNode) { menu.parentNode.removeChild(menu); }
                    btn.classList.remove('open');
                },
            };
        }

        btn.addEventListener('click', (e) => {
            e.stopPropagation();
            if (openCsel) { closeCsel(); return; }
            openMenu();
        });
        // stay in sync when CODE (not the user) changes the value…
        select.addEventListener('change', syncLabel);
        // …and when code rebuilds the <option> list (the font and Cayo
        // pickers are filled after boot).
        if (typeof MutationObserver === 'function') {
            new MutationObserver(syncLabel).observe(select, { childList: true });
        }
    }

    function enhanceSelects(root) {
        (root || document).querySelectorAll('select:not([data-csel])').forEach(enhanceSelect);
    }

    function watchSelects() {
        enhanceSelects(document);
        if (typeof MutationObserver !== 'function') { return; }
        new MutationObserver((muts) => {
            for (const m of muts) {
                for (const n of m.addedNodes) {
                    if (n.nodeType !== 1) { continue; }
                    if (n.tagName === 'SELECT') { enhanceSelect(n); }
                    else if (n.querySelectorAll) { enhanceSelects(n); }
                }
            }
        }).observe(document.body, { childList: true, subtree: true });
    }

    /* ════════ BOOT ════════ */

    document.addEventListener('apex:boot', async () => {
        if (!booted) {
            booted = true;
            await Editor.boot();
            bindAll();
        }
        const d = Editor.dims();
        $('#canvas-title').textContent =
            `Los Santos — ${d.COLS * d.FULL_TILE}×${d.ROWS * d.FULL_TILE}`;
        $('#export-name').value = App.state.config.exportName || 'my_minimap';
        loadMaps();
        renderThemeCards();
        renderToolOptions();
        renderLayers();
        updateExportNote();
        refreshProjects();
        refreshLiveButton();
    });

    document.addEventListener('apex:open', () => {
        // The NUI page is never reloaded — closing the studio only hides
        // #app — so any rail the player expanded would still be expanded
        // the next time they open it. The tool rail always starts closed.
        const ws = $('.workspace');
        if (ws) { ws.classList.add('rail-collapsed'); }
        if (booted) {
            Editor.resizeView();
            Editor.zoomFit();
        }
    });

    /* ════════ TOOL RAIL ════════ */

    function bindRail() {
        $$('#tool-rail .tool-btn[data-tool]').forEach(btn => {
            btn.addEventListener('click', () => Editor.setTool(btn.dataset.tool));
        });
        $('#rail-collapse').addEventListener('click', () => {
            $('.workspace').classList.toggle('rail-collapsed');
            setTimeout(Editor.resizeView, 200);
        });
        $('#btn-undo').addEventListener('click', Editor.undo);
        $('#btn-redo').addEventListener('click', Editor.redo);
        Editor.onEvent('history', updateUndoButtons);
        updateUndoButtons();
        Editor.onEvent('tool', renderToolOptions);
    }

    function updateUndoButtons() {
        $('#btn-undo').disabled = !Editor.canUndo();
        $('#btn-redo').disabled = !Editor.canRedo();
    }

    /* ════════ TOOL OPTIONS BAR ════════ */

    const SWATCHES = ['#FFFFFF', '#0A0A0B', '#1F5EFF', '#34C77B', '#F0556D',
        '#FFC53D', '#A66DF0', '#4E9CE5', '#FF7A3C', '#19B5A5'];

    const FONTS = ['Inter', 'Oswald', 'Bebas Neue', 'Anton', 'Montserrat',
        'Roboto Condensed', 'Permanent Marker', 'Righteous', 'Archivo Black', 'Teko'];

    function optSlider(label, min, max, val, unit, oninput) {
        const wrap = document.createElement('div');
        wrap.className = 'opt-group';
        wrap.innerHTML = `
            <span class="opt-label">${label}</span>
            <input type="range" min="${min}" max="${max}" value="${val}">
            <span class="opt-val mono">${val}${unit}</span>`;
        const range = wrap.querySelector('input');
        const out = wrap.querySelector('.opt-val');
        range.addEventListener('input', () => {
            out.textContent = range.value + unit;
            oninput(Number(range.value));
        });
        return wrap;
    }

    function optColor(label, val, oninput) {
        const wrap = document.createElement('div');
        wrap.className = 'opt-group';
        wrap.innerHTML = `<span class="opt-label">${label}</span><input type="color" value="${val}">`;
        wrap.querySelector('input').addEventListener('input', (e) => oninput(e.target.value));
        return wrap;
    }

    function optSwatches(get, set) {
        const wrap = document.createElement('div');
        wrap.className = 'opt-group swatch-row';
        for (const c of SWATCHES) {
            const s = document.createElement('button');
            s.className = 'swatch' + (get() === c ? ' active' : '');
            s.style.background = c;
            s.addEventListener('click', () => {
                set(c);
                wrap.querySelectorAll('.swatch').forEach(x => x.classList.remove('active'));
                s.classList.add('active');
                renderToolOptions();
            });
            wrap.appendChild(s);
        }
        return wrap;
    }

    function optSeg(items, get, set) {
        const wrap = document.createElement('div');
        wrap.className = 'seg-group';
        for (const it of items) {
            const b = document.createElement('button');
            b.className = 'seg-btn' + (get() === it.v ? ' active' : '');
            b.innerHTML = it.icon ? `<i class="${it.icon}"></i>` : it.label;
            if (it.label && it.icon) { b.innerHTML += `<span>${it.label}</span>`; }
            b.addEventListener('click', () => {
                set(it.v);
                wrap.querySelectorAll('.seg-btn').forEach(x => x.classList.remove('active'));
                b.classList.add('active');
            });
            wrap.appendChild(b);
        }
        return wrap;
    }

    function renderToolOptions() {
        const bar = $('#tool-options');
        bar.innerHTML = '';
        const tool = Editor.tool;
        const B = Editor.brush;

        if (tool === 'brush') {
            bar.appendChild(optSeg([
                { v: 'normal', icon: 'fa-solid fa-paintbrush' },
                { v: 'marker', icon: 'fa-solid fa-marker' },
            ], () => B.mode, v => B.mode = v));
            bar.appendChild(optSlider('Size', 2, 220, B.size, 'px', v => B.size = v));
            bar.appendChild(optSlider('Opacity', 5, 100, Math.round(B.opacity * 100), '%', v => B.opacity = v / 100));
            bar.appendChild(optColor('Color', B.color, v => B.color = v));
            bar.appendChild(optSwatches(() => B.color, v => B.color = v));
        } else if (tool === 'eraser') {
            bar.appendChild(optSlider('Size', 2, 260, B.size, 'px', v => B.size = v));
        } else if (tool === 'fill') {
            bar.appendChild(optColor('Color', B.color, v => B.color = v));
            bar.appendChild(optSwatches(() => B.color, v => B.color = v));
            bar.appendChild(optSlider('Tolerance', 4, 96, Editor.fillOpts.tolerance, '', v => Editor.fillOpts.tolerance = v));
        } else if (tool === 'zone') {
            const Z = Editor.zoneOpts;
            bar.appendChild(optSeg([
                { v: 'rect', icon: 'fa-regular fa-square' },
                { v: 'ellipse', icon: 'fa-regular fa-circle' },
                { v: 'poly', icon: 'fa-solid fa-draw-polygon' },
            ], () => Z.kind, v => { Z.kind = v; renderToolOptions(); }));
            bar.appendChild(optColor('Color', Z.color, v => Z.color = v));
            bar.appendChild(optSlider('Opacity', 10, 90, Math.round(Z.opacity * 100), '%', v => Z.opacity = v / 100));
            if (Z.kind === 'poly') {
                const hint = document.createElement('span');
                hint.className = 'opt-label';
                hint.style.color = 'var(--brand-300)';
                hint.textContent = App.t('zone_poly_hint', 'Click corners · click the first point or Enter to close · Esc cancels');
                bar.appendChild(hint);
            }
        } else if (tool === 'shape') {
            const S = Editor.shapeOpts;
            bar.appendChild(optSeg([
                { v: 'rect', icon: 'fa-regular fa-square' },
                { v: 'ellipse', icon: 'fa-regular fa-circle' },
                { v: 'line', icon: 'fa-solid fa-slash' },
                { v: 'arrow', icon: 'fa-solid fa-arrow-right-long' },
            ], () => S.kind, v => S.kind = v));
            bar.appendChild(optColor('Stroke', S.stroke, v => S.stroke = v));
            bar.appendChild(optSlider('Width', 1, 40, S.width, 'px', v => S.width = v));
            const fillToggle = document.createElement('label');
            fillToggle.className = 'toggle-chip';
            fillToggle.innerHTML = `<input type="checkbox" ${S.fill ? 'checked' : ''}><span>Fill</span>`;
            fillToggle.querySelector('input').addEventListener('change', (e) => S.fill = e.target.checked);
            bar.appendChild(fillToggle);
            bar.appendChild(optColor('Fill', S.fillColor, v => S.fillColor = v));
        } else if (tool === 'text') {
            const T = Editor.textOpts;
            const sel = document.createElement('div');
            sel.className = 'opt-group';
            sel.innerHTML = `<span class="opt-label">Font</span>
                <select class="input mono" style="width:170px;height:28px">
                ${FONTS.map(f => `<option ${f === T.font ? 'selected' : ''}>${f}</option>`).join('')}
                </select>`;
            sel.querySelector('select').addEventListener('change', (e) => T.font = e.target.value);
            bar.appendChild(sel);
            bar.appendChild(optSlider('Size', 14, 300, T.size, 'px', v => T.size = v));
            bar.appendChild(optColor('Color', T.color, v => T.color = v));
            bar.appendChild(optSwatches(() => T.color, v => T.color = v));
        } else if (tool === 'blip') {
            const B = Editor.blipOpts;
            // sprite picker — opens the searchable grid of REAL GTA blips
            const sp = document.createElement('div');
            sp.className = 'opt-group';
            const spBtn = document.createElement('button');
            spBtn.className = 'btn btn-ghost blip-pick-btn';
            spBtn.innerHTML = `<span class="blip-pick-preview"></span><span class="blip-pick-name"></span>`;
            const syncPickBtn = () => {
                const prev = spBtn.querySelector('.blip-pick-preview');
                const nm = spBtn.querySelector('.blip-pick-name');
                if (B.img) {
                    prev.innerHTML = `<img src="${escapeHtml(Editor.blipSrc(B.img))}" alt="">`;
                    nm.textContent = B.name || ('#' + B.sprite);
                } else {
                    prev.innerHTML = `<span class="blip-cell-glyph">${escapeHtml(B.glyph || '')}</span>`;
                    nm.textContent = B.name || 'Pin';
                }
            };
            syncPickBtn();
            spBtn.addEventListener('click', () => openBlipPicker(B, syncPickBtn));
            sp.innerHTML = `<span class="opt-label">Blip</span>`;
            sp.appendChild(spBtn);
            bar.appendChild(sp);
            // colour swatches (GTA blip colours)
            const cw = document.createElement('div');
            cw.className = 'opt-group swatch-row';
            for (const c of Editor.BLIP_COLORS) {
                const s = document.createElement('button');
                s.className = 'swatch' + (c.id === B.color ? ' active' : '');
                s.style.background = c.hex;
                s.title = c.name;
                s.addEventListener('click', () => {
                    B.color = c.id; B.colorHex = c.hex;
                    cw.querySelectorAll('.swatch').forEach(x => x.classList.remove('active'));
                    s.classList.add('active');
                });
                cw.appendChild(s);
            }
            bar.appendChild(cw);
            bar.appendChild(optSlider('Size', 24, 120, B.size, 'px', v => B.size = v));
            const hint = document.createElement('span');
            hint.className = 'opt-label';
            hint.style.color = 'var(--brand-300)';
            hint.textContent = App.t('blip_hint', 'Click to place · drag to move · exports a /blips script');
            bar.appendChild(hint);
        }

        bar.classList.toggle('open', bar.children.length > 0);
    }

    /* ════════ LAYERS DOCK ════════ */

    const LAYER_ICONS = { paint: 'fa-solid fa-paintbrush', text: 'fa-solid fa-font', shape: 'fa-solid fa-shapes', zone: 'fa-solid fa-vector-square', image: 'fa-regular fa-image', blip: 'fa-solid fa-location-dot', postals: 'fa-solid fa-signs-post' };

    /* Cache das miniaturas. Cada `renderLayers` desenhava um canvas + um
       toDataURL POR LINHA — e a lista é reconstruída a cada traço, a cada
       reordenação, a cada mudança de camada. Com 20 camadas isso são 20
       renders de cada vez, e é boa parte do "está muito pesado". A
       assinatura cobre tudo o que muda o aspeto da miniatura. */
    const thumbCache = new Map();

    function thumbSig(o) {
        return [
            o.type, o.rev || 0, Math.round(o.w), Math.round(o.h), Math.round(o.rot || 0),
            o.color, o.fillColor, o.stroke, o.width, o.kind, o.opacity,
            o.text, o.label, o.upper, o.bold, o.size, o.font,
            o.colorHex, o.sprite, typeof o.img === 'string' ? o.img.length : (o.img ? 1 : 0),
        ].join('|');
    }

    function thumbFor(o) {
        if (o.type === 'image' && o.src) { return o.src; }
        // a camada dos postais não tem desenho próprio: fica o ícone
        if (o.type === 'postals') { return null; }
        const sig = thumbSig(o);
        const hit = thumbCache.get(o.id);
        if (hit && hit.sig === sig) { return hit.url; }
        const url = Editor.objectThumb(o, 38);
        thumbCache.set(o.id, { sig, url });
        // a cache não pode crescer para sempre com ids apagados
        if (thumbCache.size > 120) {
            const live = new Set(Editor.objects.map(x => x.id));
            for (const k of Array.from(thumbCache.keys())) {
                if (!live.has(k)) { thumbCache.delete(k); }
            }
        }
        return url;
    }

    /* Trocar de camada NÃO reconstrói a lista: só troca as classes das
       linhas. Reconstruir redesenhava um thumbnail (um canvas!) por linha
       a cada clique — era isso que fazia a seleção piscar e o scroll saltar
       para o topo a meio do trabalho. */
    function syncSelection() {
        const id = Editor.selectedId;
        $$('#layer-list .layer-row').forEach(r => {
            r.classList.toggle('active', Number(r.dataset.id) === id);
        });
        const ops = $('#layer-ops');
        if (ops) { ops.hidden = id == null; }
        renderInspector();
        const row = $(`#layer-list .layer-row[data-id="${id}"]`);
        if (row && row.scrollIntoView) { row.scrollIntoView({ block: 'nearest' }); }
    }

    /* O objeto mudou por fora (arrastar/escrever na tela, setas): os
       controlos do inspector acompanham, menos o que estiver focado. */
    function refreshLive(o) {
        if (!o || o.id !== Editor.selectedId) { return; }
        for (const b of liveBindings) {
            try { b.apply(b.key === '*' ? o : o[b.key]); } catch (e) { /* ignora */ }
        }
    }

    function renderLayers() {
        const list = $('#layer-list');
        const keepScroll = list.scrollTop;
        const objs = Editor.objects;
        $('.dock-tab[data-tab=layers] .tab-count').textContent = objs.length ? String(objs.length) : '';
        if (!objs.length) {
            list.innerHTML = `<div class="empty-state">
                <i class="fa-solid fa-layer-group"></i>
                <span>${App.t('layers_empty', 'No layers yet — pick a tool to start designing')}</span></div>`;
            $('#layer-ops').hidden = true;
            renderInspector();
            return;
        }
        list.innerHTML = '';
        // topmost first in the list (visual order)
        for (let i = objs.length - 1; i >= 0; i--) {
            const o = objs[i];
            const row = document.createElement('div');
            row.className = 'layer-row'
                + (o.id === Editor.selectedId ? ' active' : '')
                + (o.hidden ? ' hidden-layer' : '')
                + (o.locked ? ' locked' : '');
            row.draggable = true;
            row.dataset.id = o.id;
            row.dataset.type = o.type;      // drives the identity colour notch
            // real rendered thumbnail (fallback to the type icon)
            let thumbHtml = `<i class="${LAYER_ICONS[o.type] || 'fa-solid fa-square'}"></i>`;
            try {
                const url = thumbFor(o);
                if (url) { thumbHtml = `<img src="${url}" alt="">`; }
            } catch (e) { /* keep icon */ }
            row.innerHTML = `
                <span class="layer-thumb">${thumbHtml}</span>
                <span class="layer-txt">
                    <span class="layer-name">${escapeHtml(layerLabel(o))}</span>
                    <span class="layer-type">${escapeHtml(o.type)}</span>
                </span>
                <span class="layer-actions">
                    <button class="layer-act" data-act="dup" data-tip="Duplicate"><i class="fa-regular fa-clone"></i></button>
                    <button class="layer-act layer-lock ${o.locked ? 'on' : 'off'}" data-act="lock" data-tip="Lock"><i class="fa-solid ${o.locked ? 'fa-lock' : 'fa-lock-open'}"></i></button>
                    <button class="layer-act layer-eye ${o.hidden ? 'off' : 'on'}" data-act="eye" data-tip="Show / hide"><i class="fa-regular ${o.hidden ? 'fa-eye-slash' : 'fa-eye'}"></i></button>
                    <button class="layer-act danger" data-act="del" data-tip="Delete"><i class="fa-solid fa-trash"></i></button>
                </span>`;
            row.addEventListener('click', (e) => {
                const act = e.target.closest('.layer-act');
                if (act) {
                    if (act.dataset.act === 'eye') { o.hidden = !o.hidden; }
                    else if (act.dataset.act === 'lock') { o.locked = !o.locked; }
                    else if (act.dataset.act === 'dup') { Editor.duplicateObject(o.id); return; }
                    else if (act.dataset.act === 'del') { Editor.removeObject(o.id); return; }
                    Editor.requestDraw();
                    Editor.schedulePreview();
                    renderLayers();
                    return;
                }
                Editor.selectObject(o.id);
            });
            // duplo-clique numa camada de texto abre-a para escrever na tela
            row.addEventListener('dblclick', () => {
                if (o.type !== 'text' || o.locked) { return; }
                Editor.setTool('text');
                Editor.beginTextEdit(o, false);
            });
            bindLayerDrag(row);
            list.appendChild(row);
        }
        $('#layer-ops').hidden = Editor.selectedId == null;
        list.scrollTop = keepScroll;   // reconstruir não pode roubar o scroll
        renderInspector();
    }

    // HTML5 drag-and-drop reordering (clothing parity).
    let dragLayerId = null;
    function bindLayerDrag(row) {
        row.addEventListener('dragstart', (e) => {
            dragLayerId = row.dataset.id;
            row.classList.add('dragging');
            e.dataTransfer.effectAllowed = 'move';
            try { e.dataTransfer.setData('text/plain', dragLayerId); } catch (err) { /* */ }
        });
        row.addEventListener('dragend', () => {
            dragLayerId = null;
            $$('#layer-list .layer-row').forEach(r => r.classList.remove('dragging', 'drop-above', 'drop-below'));
        });
        row.addEventListener('dragover', (e) => {
            e.preventDefault();
            if (row.dataset.id === dragLayerId) { return; }
            const r = row.getBoundingClientRect();
            const above = (e.clientY - r.top) < r.height / 2;
            row.classList.toggle('drop-above', above);
            row.classList.toggle('drop-below', !above);
        });
        row.addEventListener('dragleave', () => row.classList.remove('drop-above', 'drop-below'));
        row.addEventListener('drop', (e) => {
            e.preventDefault();
            const targetId = row.dataset.id;
            const above = row.classList.contains('drop-above');
            row.classList.remove('drop-above', 'drop-below');
            if (!dragLayerId || dragLayerId === targetId) { return; }
            // visual order (top→bottom) = objects reversed
            const visual = Editor.objects.map(o => o.id).reverse();
            const from = visual.indexOf(Number(dragLayerId));
            if (from >= 0) { visual.splice(from, 1); }
            let to = visual.indexOf(Number(targetId));
            if (!above) { to += 1; }
            visual.splice(to, 0, Number(dragLayerId));
            Editor.setObjectOrder(visual.slice().reverse());   // back to bottom→top
            renderLayers();
        });
    }

    /* ════════ BLIP PICKER ════════
       A searchable grid of the REAL GTA blips (html/blips/, ~900 sprites)
       with the curated custom markers pinned at the top. `target` is either
       Editor.blipOpts (placing) or a blip object (editing); onPick re-syncs
       whatever button opened it. */
    function openBlipPicker(target, onPick) {
        const custom = Editor.BLIP_SPRITES.map(s => ({
            id: s.id, name: s.name, file: null, glyph: s.glyph, custom: true,
        }));
        const real = Editor.BLIP_CATALOGUE || [];
        const all = custom.concat(real);

        App.modal({
            title: App.t('blip_pick_title', 'Pick a blip'),
            icon: 'fa-solid fa-location-dot',
            wide: true,
            hideCancel: true,
            confirmLabel: App.t('tip_close', 'Close'),
            bodyHTML:
                `<div class="tpl-search blip-search">
                     <i class="fa-solid fa-magnifying-glass"></i>
                     <input id="blip-search" class="tpl-search-input" type="text" spellcheck="false"
                            autocomplete="off" placeholder="${escapeHtml(App.t('blip_search_ph', 'Search by name or id…'))}">
                 </div>
                 <div class="blip-custom-row">
                     <button id="blip-upload" class="btn btn-ghost">
                        <i class="fa-solid fa-upload"></i><span>${escapeHtml(App.t('blip_upload', 'Upload image'))}</span>
                     </button>
                     <input id="blip-url" class="input" type="text" spellcheck="false" autocomplete="off"
                            placeholder="${escapeHtml(App.t('blip_url_ph', '…or paste an image URL'))}">
                     <button id="blip-url-add" class="btn btn-ghost">${escapeHtml(App.t('blip_add', 'Add'))}</button>
                     <input id="blip-file" type="file" accept="image/*" hidden>
                 </div>
                 <p class="pane-hint">${escapeHtml(App.t('blip_custom_hint',
                     'A custom image is painted onto the map itself — the game can only show its own sprite ids.'))}</p>
                 <div id="blip-grid" class="blip-grid"></div>
                 <p class="pane-hint" id="blip-count"></p>`,
        });
        bindCustomBlipInputs(target, onPick);

        const grid = $('#modal-root #blip-grid');
        const count = $('#modal-root #blip-count');
        const search = $('#modal-root #blip-search');

        function render(filter) {
            const q = (filter || '').trim().toLowerCase();
            const list = q
                ? all.filter(s => String(s.id) === q
                    || String(s.name || '').toLowerCase().includes(q))
                : all;
            // Cap the DOM: ~900 <img> at once is a visible hitch in CEF.
            const shown = list.slice(0, 240);
            grid.innerHTML = shown.map(s => `
                <button class="blip-cell${s.custom ? ' is-custom' : ''}" data-blip="${s.id}" data-file="${escapeHtml(s.file || '')}" title="${escapeHtml(s.name)} (${s.id})">
                    <span class="blip-cell-img">${s.file
                        ? `<img loading="lazy" src="${escapeHtml(Editor.blipSrc(s.file))}" alt=""
                               onerror="this.replaceWith(Object.assign(document.createElement('i'),{className:'fa-solid fa-location-dot'}))">`
                        // each curated marker draws its OWN Font Awesome glyph —
                        // they were all rendering the same pin before
                        : `<span class="blip-cell-glyph">${escapeHtml(s.glyph || '')}</span>`}</span>
                    <span class="blip-cell-id mono">${escapeHtml(s.name)}</span>
                </button>`).join('');
            // Say so out loud when only the custom set is present — silently
            // showing 14 made a missing catalogue look like "blips are broken".
            if (!real.length) {
                count.innerHTML = `<span style="color:var(--red)">${escapeHtml(
                    App.t('blip_catalogue_missing', 'Real GTA blips did not load — restart the resource (html/js/blipdata.js).'))}</span>`;
            } else {
                count.textContent = App.fmt('blip_count', '%s of %s blips', shown.length, list.length);
            }
            grid.querySelectorAll('.blip-cell').forEach((cell) => {
                cell.addEventListener('click', () => {
                    const id = Number(cell.dataset.blip);
                    const s = list.find(x => x.id === id && (x.file || '') === cell.dataset.file);
                    if (!s) { return; }
                    applyBlipChoice(target, s);
                    if (onPick) { onPick(); }
                    App.closeModal();
                });
            });
        }

        let t = null;
        search.addEventListener('input', () => {
            clearTimeout(t);
            t = setTimeout(() => render(search.value), 120);
        });
        render('');
        search.focus();
    }

    /* Custom marker art: upload a file, or paste a URL.
       Everything is normalised to a data: URL on purpose — an external image
       drawn into the atlas would taint the canvas and make toDataURL() throw,
       killing both Export and the PNG save. */
    const MAX_BLIP_IMG = 512 * 1024;

    function readFileAsDataUrl(file) {
        return new Promise((resolve, reject) => {
            const fr = new FileReader();
            fr.onload = () => resolve(String(fr.result || ''));
            fr.onerror = () => reject(new Error('read failed'));
            fr.readAsDataURL(file);
        });
    }

    async function urlToDataUrl(url) {
        const res = await fetch(url, { mode: 'cors' });
        if (!res.ok) { throw new Error('HTTP ' + res.status); }
        const blob = await res.blob();
        if (!/^image\//.test(blob.type)) { throw new Error('not an image'); }
        return await readFileAsDataUrl(blob);
    }

    function useCustomBlipImage(target, onPick, dataUrl, label) {
        if (!dataUrl || !/^data:image\//i.test(dataUrl)) {
            App.toast(App.t('blip_img_bad', 'That is not a usable image'), 'error');
            return;
        }
        if (dataUrl.length > MAX_BLIP_IMG * 1.4) {
            App.toast(App.t('blip_img_big', 'Image is too large — use one under 512 KB'), 'warning');
            return;
        }
        applyBlipChoice(target, { id: target.sprite || 1, name: label, file: dataUrl, customImg: true });
        if (onPick) { onPick(); }
        App.closeModal();
        App.toast(App.t('blip_img_added', 'Custom blip image set'), 'success');
    }

    function bindCustomBlipInputs(target, onPick) {
        const fileInput = $('#modal-root #blip-file');
        const upBtn = $('#modal-root #blip-upload');
        const urlIn = $('#modal-root #blip-url');
        const urlBtn = $('#modal-root #blip-url-add');
        if (!fileInput || !upBtn || !urlIn || !urlBtn) { return; }

        upBtn.addEventListener('click', () => fileInput.click());
        fileInput.addEventListener('change', async () => {
            const f = fileInput.files && fileInput.files[0];
            if (!f) { return; }
            if (f.size > MAX_BLIP_IMG) {
                App.toast(App.t('blip_img_big', 'Image is too large — use one under 512 KB'), 'warning');
                return;
            }
            try {
                useCustomBlipImage(target, onPick, await readFileAsDataUrl(f), f.name.replace(/\.[^.]+$/, ''));
            } catch (e) {
                App.toast(App.t('blip_img_bad', 'That is not a usable image'), 'error');
            }
        });

        const addUrl = async () => {
            const url = (urlIn.value || '').trim();
            if (!url) { return; }
            urlBtn.classList.add('busy');
            try {
                useCustomBlipImage(target, onPick, await urlToDataUrl(url), 'Custom');
            } catch (e) {
                // usually CORS — the host has to allow us to read the bytes
                App.toast(App.t('blip_url_fail', 'Could not fetch that URL (the host must allow cross-origin reads)'), 'error');
            } finally {
                urlBtn.classList.remove('busy');
            }
        };
        urlBtn.addEventListener('click', addUrl);
        urlIn.addEventListener('keydown', (e) => { if (e.key === 'Enter') { e.preventDefault(); addUrl(); } });
    }

    // Write a catalogue entry onto blipOpts or an existing blip object.
    function applyBlipChoice(target, s) {
        const isObject = target && target.type === 'blip';
        const before = isObject ? Object.assign({}, target) : null;
        target.sprite = s.id;
        target.name = s.name;
        target.img = s.file || null;
        target.customImg = !!s.customImg;
        target.glyph = s.glyph || target.glyph;
        if (isObject) {
            Editor.objectPatchOp(target.id, before, Object.assign({}, target));
            Editor.requestDraw();
            Editor.schedulePreview();
        }
    }

    function layerLabel(o) {
        if (o.type === 'postals') { return App.t('postal_layer', 'Postal codes'); }
        if (o.type === 'text') { return (o.text || 'Text').slice(0, 22); }
        if (o.type === 'zone' && o.label) { return o.label.slice(0, 22); }
        return o.name || o.type;
    }

    function escapeHtml(s) {
        return String(s).replace(/[&<>"']/g, c => ({
            '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
        }[c]));
    }

    /* ── inspector ── */

    function inspRow(label, control) {
        const row = document.createElement('div');
        row.className = 'insp-row';
        const lab = document.createElement('span');
        lab.className = 'micro-label';
        lab.textContent = label;
        row.appendChild(lab);
        row.appendChild(control);
        return row;
    }

    function inspSlider(o, key, min, max, mul, done) {
        const input = document.createElement('input');
        input.type = 'range';
        input.min = min; input.max = max;
        input.value = Math.round((o[key] != null ? o[key] : 1) * mul);
        let before = null;
        input.addEventListener('input', () => {
            if (!before) { before = Object.assign({}, o); }
            o[key] = Number(input.value) / mul;
            // mudar o corpo da letra tem de re-medir a caixa, senão a
            // seleção e a área de clique ficam do tamanho antigo
            if (o.type === 'text' && (key === 'size' || key === 'bold')) { Editor.remeasureText(o); }
            Editor.requestDraw();
            refreshLive(o);
        });
        input.addEventListener('change', () => {
            if (before) {
                Editor.objectPatchOp(o.id, before, Object.assign({}, o));
                before = null;
            }
            Editor.schedulePreview();
            if (done) { done(); }
        });
        liveBind(key, (val) => { if (document.activeElement !== input) { input.value = Math.round(val * mul); } });
        return input;
    }

    function inspColor(o, key, done) {
        const input = document.createElement('input');
        input.type = 'color';
        input.value = o[key] || '#FFFFFF';
        let before = null;
        input.addEventListener('input', () => {
            if (!before) { before = Object.assign({}, o); }
            o[key] = input.value;
            Editor.requestDraw();
        });
        input.addEventListener('change', () => {
            if (before) {
                Editor.objectPatchOp(o.id, before, Object.assign({}, o));
                before = null;
            }
            Editor.schedulePreview();
            if (done) { done(); }
        });
        return input;
    }

    /* Campos de texto do inspector: escrevem ao VIVO.
       Antes só aplicavam no `change` (ao sair do campo), por isso escrever
       um rótulo era escrever às cegas. Agora cada tecla redesenha o mapa e
       o histórico recebe UMA entrada por pausa (600 ms) em vez de uma por
       letra — undo devolve a frase, não o caractere. */
    function inspText(o, key, done) {
        const input = document.createElement('input');
        input.type = 'text';
        input.className = 'input';
        input.value = o[key] || '';
        let before = null, timer = null;

        const commit = () => {
            clearTimeout(timer);
            if (!before) { return; }
            if (before[key] !== o[key]) {
                Editor.objectPatchOp(o.id, before, Object.assign({}, o));
            }
            before = null;
            renderLayers();
            if (done) { done(); }
        };

        input.addEventListener('input', () => {
            if (!before) { before = Object.assign({}, o); }
            o[key] = input.value;
            if (o.type === 'text' && key === 'text') { Editor.remeasureText(o); }
            touchLayerName(o);
            Editor.requestDraw();
            Editor.schedulePreview();
            clearTimeout(timer);
            timer = setTimeout(commit, 600);
        });
        input.addEventListener('blur', commit);
        input.addEventListener('keydown', (e) => { if (e.key === 'Enter') { input.blur(); } });
        liveBind(key, (val) => { if (document.activeElement !== input) { input.value = val || ''; } });
        return input;
    }

    /* O nome da camada segue o texto enquanto se escreve, sem reconstruir
       a lista toda (que redesenharia um thumbnail por linha a cada tecla). */
    function touchLayerName(o) {
        const row = $(`#layer-list .layer-row[data-id="${o.id}"]`);
        if (!row) { return; }
        const nameEl = row.querySelector('.layer-name');
        if (nameEl) { nameEl.textContent = layerLabel(o); }
    }

    /* Ligações vivas do inspector: quando o objeto muda POR FORA (arrastar
       na tela, escrever na tela, setas do teclado), os controlos seguem —
       exceto aquele que o utilizador tem debaixo dos dedos. */
    let liveBindings = [];
    function liveBind(key, apply) { liveBindings.push({ key, apply }); }

    function renderInspector() {
        const box = $('#inspector');
        const o = Editor.getObject(Editor.selectedId);
        liveBindings = [];
        if (!o) {
            box.innerHTML = `<div class="empty-state small">
                <i class="fa-solid fa-crosshairs"></i>
                <span>${App.t('inspector_empty', 'Select a layer to edit its properties')}</span></div>`;
            return;
        }
        box.innerHTML = '';
        const title = document.createElement('div');
        title.className = 'insp-row';
        title.innerHTML = `<span class="micro-label">${o.type.toUpperCase()}</span>
            <span class="mono" style="font-size:10px;color:var(--text-3)">#${o.id}</span>`;
        box.appendChild(title);

        // posição/tamanho ao vivo — o que muda ao arrastar na tela
        if (o.type !== 'paint') {
            const geo = document.createElement('div');
            geo.className = 'insp-row insp-geo';
            const fmt = () => o.type === 'text'
                ? `${Math.round(o.x * 2)}, ${Math.round(o.y * 2)} · ${o.size}px · ${Math.round(o.rot || 0)}°`
                : `${Math.round(o.x * 2)}, ${Math.round(o.y * 2)} · ${Math.round(o.w * 2)}×${Math.round(o.h * 2)} · ${Math.round(o.rot || 0)}°`;
            geo.innerHTML = `<span class="micro-label">${App.t('insp_geo', 'Position')}</span>
                <span class="mono insp-geo-val">${fmt()}</span>`;
            box.appendChild(geo);
            liveBind('*', () => { geo.querySelector('.insp-geo-val').textContent = fmt(); });
        }

        if (o.type === 'postals') {
            // a camada dos postais: opacidade aqui, o resto no separador
            box.appendChild(inspRow(App.t('postal_count_lbl', 'Codes'),
                (() => { const s = document.createElement('span'); s.className = 'mono opt-val';
                    s.textContent = String(Editor.getPostals().points.length); return s; })()));
            box.appendChild(inspRow('Opacity', inspSlider(o, 'opacity', 5, 100, 100)));
            const go = document.createElement('button');
            go.className = 'btn btn-soft btn-block';
            go.innerHTML = `<i class="fa-solid fa-signs-post"></i><span>${App.t('postal_open_tab', 'Open the Postals tab')}</span>`;
            go.addEventListener('click', () => switchTab('postals'));
            box.appendChild(go);
        } else if (o.type === 'paint') {
            box.appendChild(inspRow('Opacity', inspSlider(o, 'opacity', 5, 100, 100)));
            const clr = document.createElement('button');
            clr.className = 'btn btn-ghost btn-block';
            clr.innerHTML = `<i class="fa-solid fa-eraser"></i><span>${App.t('layer_clear', 'Clear this layer')}</span>`;
            clr.addEventListener('click', () => {
                if (o.cv) {
                    const d = Editor.dims();
                    o.cv.getContext('2d').clearRect(0, 0, d.AW, d.AH);
                    o.rev = (o.rev || 0) + 1;   // invalida a redução em cache
                    Editor.requestDraw(); Editor.schedulePreview(); renderLayers();
                }
            });
            box.appendChild(clr);
        } else if (o.type === 'text') {
            box.appendChild(inspRow('Text', inspText(o, 'text')));
            const edit = document.createElement('button');
            edit.className = 'btn btn-soft btn-block';
            edit.innerHTML = `<i class="fa-solid fa-i-cursor"></i><span>${App.t('text_edit_on_map', 'Edit on the map')}</span>`;
            edit.addEventListener('click', () => { Editor.setTool('text'); Editor.beginTextEdit(o, false); });
            box.appendChild(edit);
            const fontSel = document.createElement('select');
            fontSel.className = 'input mono';
            fontSel.innerHTML = FONTS.map(f => `<option ${f === o.font ? 'selected' : ''}>${f}</option>`).join('');
            fontSel.addEventListener('change', () => {
                const before = Object.assign({}, o);
                o.font = fontSel.value;
                Editor.remeasureText(o);   // outra fonte = outra largura
                Editor.objectPatchOp(o.id, before, Object.assign({}, o));
                Editor.requestDraw();
                Editor.schedulePreview();
                refreshLive(o);
            });
            box.appendChild(inspRow('Font', fontSel));
            box.appendChild(inspRow('Size', inspSlider(o, 'size', 14, 300, 1)));
            box.appendChild(inspRow('Color', inspColor(o, 'color')));
            box.appendChild(inspRow('Outline', inspColor(o, 'outlineColor')));
        } else if (o.type === 'zone') {
            box.appendChild(inspRow('Label', inspText(o, 'label')));
            box.appendChild(inspRow('Color', inspColor(o, 'color')));
            box.appendChild(inspRow('Text', inspColor(o, 'labelColor')));
            box.appendChild(inspRow('Opacity', inspSlider(o, 'opacity', 5, 95, 100)));
        } else if (o.type === 'shape') {
            box.appendChild(inspRow('Stroke', inspColor(o, 'stroke')));
            box.appendChild(inspRow('Fill', inspColor(o, 'fillColor')));
            box.appendChild(inspRow('Width', inspSlider(o, 'width', 1, 40, 1)));
            box.appendChild(inspRow('Opacity', inspSlider(o, 'opacity', 5, 100, 100)));
        } else if (o.type === 'image') {
            box.appendChild(inspRow('Opacity', inspSlider(o, 'opacity', 5, 100, 100)));
        } else if (o.type === 'blip') {
            box.appendChild(inspRow('Label', inspText(o, 'label')));
            // same searchable picker as the tool bar, so an already-placed
            // blip can be swapped to any of the ~900 real GTA sprites
            const spBtn = document.createElement('button');
            spBtn.className = 'btn btn-ghost blip-pick-btn';
            const syncBtn = () => {
                spBtn.innerHTML =
                    `<span class="blip-pick-preview">${o.img
                        ? `<img src="${escapeHtml(Editor.blipSrc(o.img))}" alt="">`
                        : `<span class="blip-cell-glyph">${escapeHtml(o.glyph || '')}</span>`}</span>` +
                    `<span class="blip-pick-name">${escapeHtml(o.name || ('#' + o.sprite))}</span>`;
            };
            syncBtn();
            spBtn.addEventListener('click', () => openBlipPicker(o, syncBtn));
            box.appendChild(inspRow('Blip', spBtn));
            const cwrap = document.createElement('div');
            cwrap.className = 'swatch-row';
            for (const c of Editor.BLIP_COLORS) {
                const b = document.createElement('button');
                b.className = 'swatch' + (c.id === o.color ? ' active' : '');
                b.style.background = c.hex; b.title = c.name;
                b.addEventListener('click', () => {
                    const before = Object.assign({}, o);
                    o.color = c.id; o.colorHex = c.hex;
                    Editor.objectPatchOp(o.id, before, Object.assign({}, o));
                    cwrap.querySelectorAll('.swatch').forEach(x => x.classList.remove('active'));
                    b.classList.add('active');
                    Editor.requestDraw(); Editor.schedulePreview();
                });
                cwrap.appendChild(b);
            }
            box.appendChild(inspRow('Color', cwrap));
            // Size AFTER placing. A blip is square and anchored by its
            // top-left corner, so resize around the CENTRE — otherwise the
            // marker slides off the spot you put it on. The exported scale
            // is derived from o.w, so this drives the in-game blip too.
            const szInput = document.createElement('input');
            szInput.type = 'range';
            szInput.min = 24; szInput.max = 120;
            szInput.value = Math.round(o.w);
            const szVal = document.createElement('span');
            szVal.className = 'mono opt-val';
            szVal.textContent = Math.round(o.w) + 'px';
            let szBefore = null;
            szInput.addEventListener('input', () => {
                if (!szBefore) { szBefore = Object.assign({}, o); }
                const n = Number(szInput.value);
                const cx = o.x + o.w / 2, cy = o.y + o.h / 2;
                o.w = n; o.h = n;
                o.x = cx - n / 2; o.y = cy - n / 2;
                szVal.textContent = n + 'px';
                Editor.requestDraw();
            });
            szInput.addEventListener('change', () => {
                if (szBefore) {
                    Editor.objectPatchOp(o.id, szBefore, Object.assign({}, o));
                    szBefore = null;
                }
                Editor.schedulePreview();
            });
            const szWrap = document.createElement('div');
            szWrap.className = 'insp-size';
            szWrap.appendChild(szInput);
            szWrap.appendChild(szVal);
            box.appendChild(inspRow('Size', szWrap));
        }
        if (o.type !== 'blip' && o.type !== 'paint') {
            box.appendChild(inspRow('Rotation', inspSlider(o, 'rot', -180, 180, 1)));
        }
    }

    // "+" → the same add-layer menu the clothing studio uses: a grid of
    // layer types with a name + one-line description.
    function openAddLayerMenu() {
        const items = [
            { id: 'paint', icon: 'fa-solid fa-paintbrush', name: App.t('add_paint', 'Paint layer'), desc: App.t('add_paint_d', 'Empty raster to brush, erase and fill on') },
            { id: 'text',  icon: 'fa-solid fa-font',        name: App.t('add_text', 'Text'),        desc: App.t('add_text_d', 'Place a label anywhere on the map') },
            { id: 'zone',  icon: 'fa-solid fa-vector-square', name: App.t('add_zone', 'Zone'),      desc: App.t('add_zone_d', 'Highlight an area — box, ellipse or polygon') },
            { id: 'shape', icon: 'fa-solid fa-shapes',      name: App.t('add_shape', 'Shape'),      desc: App.t('add_shape_d', 'Rectangle, ellipse, line or arrow') },
            { id: 'image', icon: 'fa-regular fa-image',     name: App.t('add_image', 'Image'),      desc: App.t('add_image_d', 'Upload a logo or picture from your PC') },
            { id: 'blip',  icon: 'fa-solid fa-location-dot', name: App.t('add_blip', 'Blip'),       desc: App.t('add_blip_d', 'A GTA map blip, exported as a script') },
        ];
        App.modal({
            title: App.t('add_layer_title', 'Add layer'),
            icon: 'fa-solid fa-layer-group',
            wide: true,
            hideCancel: true,
            confirmLabel: App.t('tip_close', 'Close'),
            bodyHTML: `<div class="add-layer-menu">${items.map(it => `
                <button class="menu-item" data-add="${it.id}">
                    <i class="${it.icon}"></i>
                    <span class="mi-text">
                        <span class="mi-name">${escapeHtml(it.name)}</span>
                        <span class="mi-desc">${escapeHtml(it.desc)}</span>
                    </span>
                </button>`).join('')}</div>`,
        });
        $$('#modal-root .menu-item').forEach(btn => {
            btn.addEventListener('click', () => {
                const kind = btn.dataset.add;
                App.closeModal();
                if (kind === 'paint') { Editor.newPaintLayer(); return; }
                if (kind === 'image') { Editor.setTool('image'); $('#file-image').click(); return; }
                // the remaining types are placed by clicking on the map
                Editor.setTool(kind);
                App.toast(App.fmt('add_place_hint', 'Now click on the map to place the %s', kind), 'info');
            });
        });
    }

    function bindLayerOps() {
        const add = $('#btn-add-layer');
        if (add) { add.addEventListener('click', openAddLayerMenu); }
        $('#lop-up').addEventListener('click', () => Editor.moveObjectLayer(Editor.selectedId, +1));
        $('#lop-down').addEventListener('click', () => Editor.moveObjectLayer(Editor.selectedId, -1));
        $('#lop-dup').addEventListener('click', () => Editor.duplicateObject(Editor.selectedId));
        $('#lop-del').addEventListener('click', () => Editor.removeObject(Editor.selectedId));
        Editor.onEvent('layers', renderLayers);
        Editor.onEvent('select', syncSelection);
        Editor.onEvent('objectlive', refreshLive);
        // enquanto se escreve NA TELA o inspector segue o texto
        Editor.onEvent('textedit', () => renderInspector());
    }

    /* ════════ MAPS RAIL ════════ */

    let mapsCatalog = [];
    let mapFilter = 'ls';   // 'ls' | 'cayo'

    async function loadMaps() {
        try {
            const res = await fetch('tiles/maps.json', { cache: 'no-cache' });
            mapsCatalog = await res.json();
        } catch (e) {
            mapsCatalog = [];
        }
        renderMaps();
        populateCayoStyles();
    }

    function populateCayoStyles() {
        const sel = $('#export-cayo-style');
        if (!sel) { return; }
        sel.innerHTML = `<option value="match">${App.t('export_cayo_match', 'Match the base map')}</option>`
            + mapsCatalog.map(m => `<option value="${m.id}">${escapeHtml(m.label)}</option>`).join('');
    }

    function renderMaps(filter) {
        const grid = $('#maps-grid');
        if (!grid) { return; }
        const q = (filter || '').trim().toLowerCase();
        const inGroup = (m) => mapFilter === 'cayo' ? m.cayo : !m.cayo;
        const list = mapsCatalog.filter(m => inGroup(m) &&
            (!q || m.label.toLowerCase().includes(q) || m.id.toLowerCase().includes(q)));
        $('#maps-count').textContent = String(mapsCatalog.filter(inGroup).length || '');
        if (!list.length) {
            grid.innerHTML = `<div class="empty-state small">
                <i class="fa-solid fa-map-location-dot"></i>
                <span>${q ? 'No maps match' : App.t('maps_loading', 'Loading maps…')}</span></div>`;
            return;
        }
        grid.innerHTML = '';
        for (const m of list) { grid.appendChild(mapCard(m)); }
    }

    function mapCard(m) {
        const card = document.createElement('div');
        card.className = 'map-card' + (m.id === Editor.currentMap ? ' active' : '');
        card.dataset.map = m.id;
        const fmt = m.cayo ? 'GFX' : (m.native >= 4096 ? 'HD' : (m.format || ''));
        // Cayo tiles are a single minimap_0_0; LS maps use minimap_1_1 as the thumb
        const thumb = m.cayo ? `tiles/${m.id}/minimap_0_0.png` : `tiles/${m.id}/minimap_1_1.png`;
        card.innerHTML = `
            <div class="map-thumb" style="background-image:url('${thumb}')"></div>
            ${fmt ? `<span class="map-fmt">${fmt}</span>` : ''}
            ${m.imported ? `<span class="map-mine">${App.t('maps_mine', 'MINE')}</span>` : ''}
            <div class="map-card-body">
                <div class="map-card-name">${escapeHtml(m.label)}<i class="fa-solid fa-circle-check"></i></div>
                <div class="map-card-desc">${escapeHtml(m.description || '')}</div>
            </div>`;
        card.addEventListener('click', () => {
            if (m.id === Editor.currentMap) { return; }
            Editor.setMap(m);
        });
        return card;
    }

    function bindMaps() {
        const search = $('#maps-search');
        if (search) { search.addEventListener('input', () => renderMaps(search.value)); }

        // "Use my own map" — the conversion happens on disk (tools/import_map),
        // so the pane only explains it and re-reads the catalog afterwards.
        const help = $('#maps-help'), importBtn = $('#maps-import');
        if (importBtn && help) {
            importBtn.addEventListener('click', () => {
                help.hidden = !help.hidden;
                importBtn.classList.toggle('active', !help.hidden);
                if (!help.hidden) { help.scrollIntoView({ block: 'nearest' }); }
            });
        }
        const reload = $('#maps-reload');
        if (reload) {
            reload.addEventListener('click', async () => {
                const before = mapsCatalog.length;
                await loadMaps();
                const added = mapsCatalog.length - before;
                App.toast(added > 0
                    ? App.t('maps_reload_new', 'Found new maps: ') + added
                    : App.t('maps_reload_none', 'No new maps. Did you restart the resource after importing?'),
                    added > 0 ? 'success' : 'info');
            });
        }
        $$('.maps-toggle .seg-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                mapFilter = btn.dataset.mapfilter;
                $$('.maps-toggle .seg-btn').forEach(b => b.classList.toggle('active', b === btn));
                if (search) { search.value = ''; }
                renderMaps();
            });
        });
        // A base tile that fails to load leaves a blank square on the canvas.
        // Say which one, instead of leaving the map looking half-empty.
        Editor.onEvent('tileerror', (info) => {
            App.toast(`${info.missing.length}/${info.expected} tiles of "${info.map}" failed to load: `
                + info.missing.join(', '), 'error');
        });
        Editor.onEvent('map', () => {
            const cur = mapsCatalog.find(x => x.id === Editor.currentMap);
            // the theme swatches preview the active base map
            renderThemeCards();
            // keep the LS/Cayo toggle in sync with the active map's group
            const wantFilter = (cur && cur.cayo) ? 'cayo' : 'ls';
            if (wantFilter !== mapFilter) {
                mapFilter = wantFilter;
                $$('.maps-toggle .seg-btn').forEach(b => b.classList.toggle('active', b.dataset.mapfilter === mapFilter));
                renderMaps();
            }
            $$('#maps-grid .map-card').forEach(c =>
                c.classList.toggle('active', c.dataset.map === Editor.currentMap));
            const m = cur;
            if (m) {
                App.toast(m.label, 'info');
                const d = Editor.dims();
                $('#canvas-title').textContent = m.cayo
                    ? m.label
                    : `Los Santos — ${d.COLS * d.FULL_TILE}×${d.ROWS * d.FULL_TILE}`;
            }
            // export tab: live mode is meaningless for the Cayo scaleform
            updateExportForMap();
        });
    }

    // Cayo is a scaleform overlay — only the "resource" export applies;
    // the live-tile modes are hidden while editing a Cayo map.
    function updateExportForMap() {
        const cayo = Editor.isCayo();
        const liveCard = document.querySelector('input[name=export-mode][value=live]');
        if (liveCard) {
            const label = liveCard.closest('.mode-card');
            if (label) { label.style.display = cayo ? 'none' : ''; }
            if (cayo && liveCard.checked) {
                const pkg = document.querySelector('input[name=export-mode][value=package]');
                if (pkg) { pkg.checked = true; updateExportNote(); }
            }
        }
    }

    /* ════════ POSTALS ════════ */

    const POSTAL_FONTS = ['Outfit', 'Inter', 'Oswald', 'Bebas Neue', 'Anton',
        'Montserrat', 'Roboto Condensed', 'Righteous', 'Archivo Black', 'Teko'];

    // Postal sets bundled with the resource (html/postals/<id>.json).
    // id → display name shown as the active set name.
    const POSTAL_PRESETS = { ocrp: 'OCRP', new: 'New', oulsen: 'Oulsen' };

    function parsePostals(text) {
        text = (text || '').trim();
        if (!text) { return []; }
        const out = [];
        // JSON array first
        if (text[0] === '[' || text[0] === '{') {
            try {
                let data = JSON.parse(text);
                if (!Array.isArray(data)) {
                    const nested = data.postals || data.points || data.codes;
                    if (Array.isArray(nested)) {
                        data = nested;
                    } else {
                        // Keyed map shape: { "100": { x, y }, ... } — what the
                        // fivem-tools.com postals.json ships (and our bundled
                        // OCRP / New / Oulsen sets). The key IS the code.
                        data = Object.keys(nested || data).map((code) => {
                            const v = (nested || data)[code] || {};
                            return { code, x: v.x, y: v.y };
                        });
                    }
                }
                for (const p of data) {
                    const code = p.code != null ? p.code : (p.number != null ? p.number : p.postal);
                    const x = Number(p.x), y = Number(p.y);
                    if (code != null && isFinite(x) && isFinite(y)) { out.push({ code: String(code), x, y }); }
                }
                return out;
            } catch (e) { /* fall through to CSV */ }
        }
        // CSV / lines: code,x,y  (header line auto-skipped)
        for (const line of text.split(/\r?\n/)) {
            const parts = line.split(/[,;\t]/).map(s => s.trim());
            if (parts.length < 3) { continue; }
            const code = parts[0], x = Number(parts[1]), y = Number(parts[2]);
            if (code && isFinite(x) && isFinite(y) && !/[a-z]/i.test(parts[1])) {
                out.push({ code: String(code), x, y });
            }
        }
        return out;
    }

    function generateGridPostals() {
        const wb = App.state.config.worldBounds || { left: -4137.4, top: 8397.6, right: 4860.5, bottom: -5099.4 };
        const step = 500;
        const pts = [];
        let n = 1;
        // top→bottom, left→right, numbered sequentially (like real postal sets)
        for (let y = wb.top; y >= wb.bottom; y -= step) {
            for (let x = wb.left; x <= wb.right; x += step) {
                pts.push({ code: String(n++), x: Math.round(x), y: Math.round(y) });
            }
        }
        return pts;
    }

    function syncPostalUI() {
        const P = Editor.getPostals();
        const s = P.style;
        $('#postal-enabled').checked = P.enabled;
        $('#postal-ingame').checked = P.ingameScript;
        $('#postal-set-name').textContent = P.setName || 'New';
        $('#postal-count').textContent = String(P.points.length);
        $('#ps-color').value = s.color;
        $('#ps-size').value = s.size; $('#ps-size-val').textContent = s.size;
        $('#ps-opacity').value = s.opacity; $('#ps-opacity-val').textContent = s.opacity + '%';
        $('#ps-outline').checked = s.outline;
        $('#ps-outline-color').value = s.outlineColor;
        $('#ps-outline-w').value = s.outlineWidth; $('#ps-outline-w-val').textContent = s.outlineWidth;
        $('#ps-shadow').checked = s.shadow;
        $('#ps-shadow-color').value = s.shadowColor;
        $('#ps-shadow-blur').value = s.shadowBlur; $('#ps-shadow-blur-val').textContent = s.shadowBlur;
        $('#ps-shadow-off').value = s.shadowOffset; $('#ps-shadow-off-val').textContent = s.shadowOffset;
        const fontSel = $('#ps-font');
        if (fontSel && !fontSel.options.length) {
            fontSel.innerHTML = POSTAL_FONTS.map(f => `<option>${f}</option>`).join('');
        }
        if (fontSel) { fontSel.value = s.font; }
        renderOverrides();
    }

    function renderOverrides() {
        const P = Editor.getPostals();
        const list = $('#postal-ov-list');
        const codes = Object.keys(P.overrides);
        if (!codes.length) {
            list.innerHTML = `<div class="empty-state small"><i class="fa-solid fa-signs-post"></i><span>${App.t('postal_no_ov', 'No per-code overrides')}</span></div>`;
            return;
        }
        // Codes present in the set that is actually loaded — an override on a
        // code that isn't there can never show up, which reads as "broken".
        const present = new Set(P.points.map(p => String(p.code)));
        list.innerHTML = '';
        for (const code of codes) {
            const ov = P.overrides[code];
            const missing = P.points.length > 0 && !present.has(String(code));
            const row = document.createElement('div');
            row.className = 'postal-ov-row' + (missing ? ' is-missing' : '');
            row.innerHTML = `
                <span class="ov-code mono">${escapeHtml(code)}</span>
                <input type="color" value="${ov.color || P.style.color}" title="Color">
                ${missing ? `<i class="fa-solid fa-triangle-exclamation ov-warn"
                                title="${escapeHtml(App.t('postal_ov_missing', 'This code is not in the loaded set'))}"></i>` : ''}
                <span class="ov-spacer"></span>
                <button class="btn-icon sm danger" data-tip="Remove"><i class="fa-solid fa-trash"></i></button>`;
            row.querySelector('input[type=color]').addEventListener('input', (e) =>
                Editor.setPostalOverride(code, { color: e.target.value }));
            // Re-render HERE rather than from the 'postals' event: that event
            // also fires while the colour picker is being dragged, and
            // rebuilding the list mid-drag would rip the <input> out.
            row.querySelector('button').addEventListener('click', () => {
                Editor.clearPostalOverride(code);
                renderOverrides();
            });
            list.appendChild(row);
        }
    }

    /* ── posição do conjunto de postais ──────────────────────
       Os conjuntos prontos foram desenhados para outros mapas e caem
       quase sempre uns metros ao lado. Isto move os 1687 de uma vez,
       mostra a posição exata (para se poder repetir a partir de um
       screenshot) e fica guardado no projeto e no /gps exportado. */
    function syncPostalOffset() {
        const o = Editor.getPostalOffset();
        const x = $('#postal-off-x'), y = $('#postal-off-y'), read = $('#postal-off-read');
        if (x && document.activeElement !== x) { x.value = Math.round(o.x); }
        if (y && document.activeElement !== y) { y.value = Math.round(o.y); }
        if (read) { read.textContent = `${o.x.toFixed(1)}, ${o.y.toFixed(1)}`; }
    }

    function bindPostalOffset() {
        const apply = () => {
            Editor.setPostalOffset(Number($('#postal-off-x').value) || 0,
                Number($('#postal-off-y').value) || 0);
            syncPostalOffset();
        };
        ['#postal-off-x', '#postal-off-y'].forEach(sel => {
            const el = $(sel);
            if (el) { el.addEventListener('input', apply); }
        });
        $$('.postal-nudge [data-nudge]').forEach(btn => {
            btn.addEventListener('click', () => {
                const [dx, dy] = btn.dataset.nudge.split(',').map(Number);
                Editor.nudgePostals(dx, dy);
                syncPostalOffset();
            });
        });
        const drag = $('#postal-drag');
        if (drag) {
            drag.addEventListener('click', () => {
                Editor.setTool('postalmove');
                App.toast(App.t('postal_drag_hint', 'Drag anywhere on the map to move the whole postal set'), 'info');
            });
        }
        const reset = $('#postal-offset-reset');
        if (reset) {
            reset.addEventListener('click', () => { Editor.setPostalOffset(0, 0); syncPostalOffset(); });
        }
        Editor.onEvent('postals', syncPostalOffset);
        syncPostalOffset();
    }

    function bindPostals() {
        bindPostalOffset();
        $('#postal-enabled').addEventListener('change', (e) => Editor.setPostalEnabled(e.target.checked));
        $('#postal-ingame').addEventListener('change', (e) => Editor.setPostalIngame(e.target.checked));

        $('#postal-import').addEventListener('click', () => {
            App.modal({
                title: App.t('postal_import', 'Import'),
                icon: 'fa-solid fa-file-import',
                wide: true,
                bodyHTML: `
                    <p>${App.t('postal_import_hint', 'Paste a postal set — a JSON array of {code, x, y} or CSV lines "code,x,y". Works with OCRP / Oulsen exports.')}</p>
                    <input id="postal-import-name" class="input" type="text" placeholder="Set name" value="Imported">
                    <textarea id="postal-import-data" class="input textarea" rows="8" spellcheck="false" placeholder='[{"code":"100","x":0.0,"y":0.0}, ...]'></textarea>`,
                confirmLabel: App.t('postal_import', 'Import'),
                onConfirm: () => {
                    const name = ($('#postal-import-name') || {}).value || 'Imported';
                    const pts = parsePostals(($('#postal-import-data') || {}).value || '');
                    if (!pts.length) { App.toast(App.t('postal_import_empty', 'No valid postals found'), 'error'); return; }
                    Editor.setPostalPoints(pts, name);
                    Editor.setPostalEnabled(true);
                    syncPostalUI();
                    App.toast(App.fmt('postal_imported', '%s postals imported', pts.length), 'success');
                },
            });
        });

        $('#postal-grid').addEventListener('click', () => {
            const pts = generateGridPostals();
            Editor.setPostalPoints(pts, 'Grid');
            Editor.setPostalEnabled(true);
            syncPostalUI();
            App.toast(App.fmt('postal_grid_made', 'Generated %s grid postals', pts.length), 'success');
        });

        $('#postal-clear').addEventListener('click', () => {
            Editor.setPostalPoints([], 'New');
            syncPostalUI();
        });

        // Style back to the shipped defaults (and drop every per-code
        // override). The imported set is untouched — that's Clear's job.
        $('#postal-style-reset').addEventListener('click', () => {
            Editor.resetPostalStyle();
            syncPostalUI();
            renderOverrides();
            App.toast(App.t('postal_reset_done', 'Postal style reset'), 'success');
        });

        // Bundled postal sets (html/postals/*.json, keyed { code: {x,y} }).
        // Fetched on demand so the ~110 KB of coordinates never load unless asked.
        document.querySelectorAll('[data-postal-preset]').forEach((btn) => {
            btn.addEventListener('click', async () => {
                const id = btn.getAttribute('data-postal-preset');
                const label = POSTAL_PRESETS[id] || id;
                if (btn.disabled) { return; }
                btn.disabled = true;
                try {
                    const res = await fetch(`./postals/${id}.json`, { cache: 'force-cache' });
                    if (!res.ok) { throw new Error(`HTTP ${res.status}`); }
                    const pts = parsePostals(await res.text());
                    if (!pts.length) { throw new Error('empty set'); }
                    Editor.setPostalPoints(pts, label);
                    Editor.setPostalEnabled(true);
                    syncPostalUI();
                    App.toast(App.fmt('postal_imported', '%s postals imported', pts.length), 'success');
                } catch (e) {
                    App.toast(App.fmt('postal_preset_fail', 'Could not load the %s postal set', label), 'error');
                } finally {
                    btn.disabled = false;
                }
            });
        });

        // style controls
        const styleBind = (id, key, isRange, unit, labelId) => {
            const el = $(id);
            el.addEventListener('input', () => {
                let v = el.type === 'checkbox' ? el.checked : (isRange ? Number(el.value) : el.value);
                if (labelId) { $(labelId).textContent = v + (unit || ''); }
                const patch = {}; patch[key] = v;
                Editor.setPostalStyle(patch);
            });
        };
        styleBind('#ps-color', 'color');
        $('#ps-font').addEventListener('change', () => Editor.setPostalStyle({ font: $('#ps-font').value }));
        styleBind('#ps-size', 'size', true, '', '#ps-size-val');
        styleBind('#ps-opacity', 'opacity', true, '%', '#ps-opacity-val');
        styleBind('#ps-outline', 'outline');
        styleBind('#ps-outline-color', 'outlineColor');
        styleBind('#ps-outline-w', 'outlineWidth', true, '', '#ps-outline-w-val');
        styleBind('#ps-shadow', 'shadow');
        styleBind('#ps-shadow-color', 'shadowColor');
        styleBind('#ps-shadow-blur', 'shadowBlur', true, '', '#ps-shadow-blur-val');
        styleBind('#ps-shadow-off', 'shadowOffset', true, '', '#ps-shadow-off-val');

        const addOverride = () => {
            const code = ($('#postal-ov-code').value || '').trim();
            if (!code) { return; }
            const P = Editor.getPostals();
            if (!P.points.length) {
                App.toast(App.t('postal_ov_no_set', 'Load a postal set first'), 'warning');
                return;
            }
            // Silently accepting a code that is not in the set is what made
            // this look broken — nothing could ever change on the map.
            if (!P.points.some(p => String(p.code) === code)) {
                App.toast(App.fmt('postal_ov_unknown', 'Postal %s is not in "%s"', code, P.setName || 'this set'), 'warning');
                return;
            }
            Editor.setPostalOverride(code, { color: P.style.color });
            $('#postal-ov-code').value = '';
            renderOverrides();
        };
        $('#postal-ov-add').addEventListener('click', addOverride);
        $('#postal-ov-code').addEventListener('keydown', (e) => {
            if (e.key === 'Enter') { e.preventDefault(); addOverride(); }
        });

        Editor.onEvent('postals', () => {
            $('#postal-count').textContent = String(Editor.getPostals().points.length);
            $('#postal-set-name').textContent = Editor.getPostals().setName || 'New';
        });
    }

    /* ════════ THEMES ════════ */

    const THEMES = [
        { id: 'original', name: 'Original', t: { hue: 0, sat: 100, bri: 100, con: 100, tintAmt: 0 } },
        { id: 'noir', name: 'Noir', t: { hue: 0, sat: 0, bri: 82, con: 118, tintAmt: 0 } },
        { id: 'midnight', name: 'Midnight', t: { hue: 0, sat: 42, bri: 52, con: 116, tint: '#0B1B4A', tintAmt: 38 } },
        { id: 'blueprint', name: 'Blueprint', t: { hue: 0, sat: 12, bri: 84, con: 122, tint: '#1F5EFF', tintAmt: 44 } },
        { id: 'sepia', name: 'Vintage', t: { hue: -18, sat: 58, bri: 104, con: 96, tint: '#B98A4A', tintAmt: 22 } },
        { id: 'emerald', name: 'Emerald', t: { hue: 62, sat: 82, bri: 92, con: 108, tint: '#1C7E50', tintAmt: 14 } },
        { id: 'inferno', name: 'Inferno', t: { hue: -48, sat: 118, bri: 88, con: 112, tint: '#8A1E12', tintAmt: 18 } },
        { id: 'toner', name: 'Toner', t: { hue: 0, sat: 0, bri: 122, con: 138, tintAmt: 0 } },
    ];

    function cssFilterOf(t) {
        return `hue-rotate(${t.hue || 0}deg) saturate(${t.sat != null ? t.sat : 100}%) brightness(${t.bri != null ? t.bri : 100}%) contrast(${t.con != null ? t.con : 100}%)`;
    }

    /* Theme swatches preview the CURRENT base map. The tile lives inside the
       map's own folder — `tiles/minimap_1_0.png` (no folder) does not exist,
       so every swatch used to 404 on that one name. Cayo has a single tile. */
    function themeThumbUrl() {
        const id = String(Editor.currentMap || 'original');
        return id.indexOf('cayo-') === 0
            ? `tiles/${id}/minimap_0_0.png`
            : `tiles/${id}/minimap_1_0.png`;
    }

    function renderThemeCards() {
        const grid = $('#theme-grid');
        grid.innerHTML = '';
        const thumb = themeThumbUrl();
        for (const th of THEMES) {
            const card = document.createElement('div');
            card.className = 'theme-card' + (Editor.theme.preset === th.id ? ' active' : '');
            card.dataset.theme = th.id;
            card.innerHTML = `
                <div class="theme-thumb" style="background-image:url('${thumb}');filter:${cssFilterOf(th.t)}"></div>
                <div class="theme-name">${th.name}</div>`;
            card.addEventListener('click', () => {
                Editor.setTheme(Object.assign({ tint: Editor.theme.tint }, th.t), th.id);
                syncThemeSliders();
                renderThemeCards();
            });
            grid.appendChild(card);
        }
    }

    function syncThemeSliders() {
        const t = Editor.theme;
        $('#adj-hue').value = t.hue; $('#adj-hue-val').textContent = t.hue + '°';
        $('#adj-sat').value = t.sat; $('#adj-sat-val').textContent = t.sat + '%';
        $('#adj-bri').value = t.bri; $('#adj-bri-val').textContent = t.bri + '%';
        $('#adj-con').value = t.con; $('#adj-con-val').textContent = t.con + '%';
        $('#adj-tint-amt').value = t.tintAmt; $('#adj-tint-val').textContent = t.tintAmt + '%';
        $('#adj-tint').value = t.tint || '#1F5EFF';
    }

    function bindThemes() {
        const bind = (id, key, unit, labelSel) => {
            const el = $(id);
            const label = $(labelSel || (id + '-val'));
            el.addEventListener('input', () => {
                if (label) { label.textContent = el.value + unit; }
                const patch = {};
                patch[key] = Number(el.value);
                Editor.setTheme(patch, 'custom');
                renderThemeCards();
            });
        };
        bind('#adj-hue', 'hue', '°');
        bind('#adj-sat', 'sat', '%');
        bind('#adj-bri', 'bri', '%');
        bind('#adj-con', 'con', '%');
        bind('#adj-tint-amt', 'tintAmt', '%', '#adj-tint-val');
        $('#adj-tint').addEventListener('input', () => {
            Editor.setTheme({ tint: $('#adj-tint').value }, 'custom');
            renderThemeCards();
        });
        $('#btn-theme-reset').addEventListener('click', () => {
            Editor.setTheme(THEMES[0].t, 'original');
            syncThemeSliders();
            renderThemeCards();
        });
        syncThemeSliders();
    }

    /* ════════ PROJECTS ════════ */

    function refreshProjects() {
        App.post('projectList');
    }

    App.on('projectsList', (p) => {
        const grid = $('#projects-mine');
        const items = p.items || [];
        if (!items.length) {
            grid.innerHTML = `<div class="empty-state small">
                <i class="fa-regular fa-folder-open"></i>
                <span>${App.t('projects_empty', 'No projects saved yet')}</span></div>`;
            return;
        }
        grid.innerHTML = '';
        for (const it of items) {
            const card = document.createElement('div');
            card.className = 'project-card' + (it.id === currentProject.id ? ' selected' : '');
            const when = it.savedAt ? new Date(it.savedAt * 1000).toLocaleString() : '';
            card.innerHTML = `
                <div class="project-thumb"><i class="fa-solid fa-map"></i></div>
                <div class="project-body">
                    <div class="project-name">${escapeHtml(it.name)}</div>
                    <div class="project-meta mono">${when}</div>
                </div>
                <div class="project-actions">
                    <button class="btn-icon sm" data-act="rename" data-tip="Rename"><i class="fa-solid fa-pen"></i></button>
                    <button class="btn-icon sm danger" data-act="del" data-tip="Delete"><i class="fa-solid fa-trash"></i></button>
                </div>`;
            card.addEventListener('click', (e) => {
                const act = e.target.closest('[data-act]');
                if (act) {
                    if (act.dataset.act === 'del') { confirmDeleteProject(it); }
                    if (act.dataset.act === 'rename') { renameProject(it); }
                    return;
                }
                App.post('projectLoad', { id: it.id });
            });
            grid.appendChild(card);
        }
    });

    function confirmDeleteProject(it) {
        App.modal({
            title: it.name,
            icon: 'fa-solid fa-trash',
            danger: true,
            bodyHTML: `<p>${App.t('project_delete_confirm', 'Delete this project? This cannot be undone.')}</p>`,
            confirmLabel: App.t('tip_delete', 'Delete'),
            onConfirm: async () => {
                await App.post('projectDelete', { id: it.id });
                if (currentProject.id === it.id) { currentProject = { id: null, name: '' }; }
                refreshProjects();
            },
        });
    }

    function renameProject(it) {
        App.modal({
            title: App.t('tip_duplicate', 'Rename'),
            icon: 'fa-solid fa-pen',
            bodyHTML: `<input id="rename-input" class="input" type="text" maxlength="60" value="${escapeHtml(it.name)}">`,
            confirmLabel: 'OK',
            onConfirm: async () => {
                const name = ($('#rename-input') || {}).value || it.name;
                await App.post('projectRename', { id: it.id, name });
                if (currentProject.id === it.id) { setProjectName(name); }
                refreshProjects();
            },
        });
        setTimeout(() => { const i = $('#rename-input'); if (i) { i.focus(); i.select(); } }, 60);
    }

    function setProjectName(name) {
        currentProject.name = name || '';
        $('#project-name').textContent = name || App.t('project_untitled', 'Untitled map');
        $('#project-name-input').value = name || '';
    }

    let saveBusy = false;
    let saveTimeout = null;

    async function saveProject() {
        if (saveBusy) { return; }
        const name = ($('#project-name-input').value || currentProject.name || '').trim()
            || App.t('project_untitled', 'Untitled map');
        setProjectName(name);

        // codifica as camadas de pintura fora da thread principal (um PNG de
        // 2048×3072 por camada de uma vez só pendurava o jogo ao guardar)
        saveBusy = true;
        App.toast(App.t('saving', 'Saving…'), 'info');
        const payload = { id: currentProject.id, name, state: await Editor.serializeAsync() };
        saveBusy = false;

        // The server silently DROPS a blob over the limit — no reply, so the
        // UI would wait forever. Check here and say something useful instead.
        const limit = App.state.config.maxTransferBytes || (24 * 1024 * 1024);
        let size = 0;
        try {
            size = JSON.stringify(payload).length;
        } catch (e) {
            App.toast(App.t('project_save_serialize', 'This project could not be prepared for saving'), 'error');
            return;
        }
        if (size > limit) {
            App.toast(App.fmt('project_too_big',
                'Project is too large to save (%s MB, limit %s MB) — flatten or delete a paint layer',
                (size / 1048576).toFixed(1), Math.round(limit / 1048576)), 'error');
            return;
        }

        saveBusy = true;
        clearTimeout(saveTimeout);
        // last-resort guard: if the server never answers at all, don't leave
        // the button dead and the player guessing
        saveTimeout = setTimeout(() => {
            if (!saveBusy) { return; }
            saveBusy = false;
            App.toast(App.t('project_save_timeout', 'The server did not answer the save — check the server console'), 'error');
        }, 20000);

        try {
            await App.sendBlob('project', payload);
        } catch (e) {
            saveBusy = false;
            clearTimeout(saveTimeout);
            App.toast(App.fmt('project_save_failed', 'Could not save the project (%s).', 'upload'), 'error');
        }
    }

    const SAVE_ERRORS = {
        cooldown: 'Saving too fast — wait a moment and try again',
        decode: 'The project data could not be read by the server',
        write: 'The server could not write the project file',
    };

    App.on('projectSaved', (p) => {
        saveBusy = false;
        clearTimeout(saveTimeout);
        if (p.ok) {
            currentProject.id = p.id;
            setProjectName(p.name);
            Editor.markClean();
            refreshProjects();
            App.toast(App.fmt('project_saved', 'Project "%s" saved.', p.name || ''), 'success');
            return;
        }
        // Failures used to be swallowed entirely, which is why "save does
        // nothing" was the symptom instead of an error.
        const r = String(p.reason || '');
        let msg = SAVE_ERRORS[r];
        if (!msg && r.startsWith('limit:')) {
            msg = App.fmt('project_limit', 'Project limit reached (%s) — delete one first', r.split(':')[1]);
        }
        App.toast(msg || App.fmt('project_save_failed', 'Could not save the project (%s).', r || '?'), 'error');
    });

    App.onBlob('projectLoad', (data) => {
        currentProject.id = data.id || null;
        setProjectName(data.name || '');
        Editor.loadState(data.state || {}, () => {
            renderLayers();
            syncThemeSliders();
            renderThemeCards();
            syncPostalUI();
            App.toast(data.name || 'Project', 'success');
        });
        refreshProjects();
    });

    /* ════════ EXPORT ════════ */

    function exportMode() {
        const checked = document.querySelector('input[name=export-mode]:checked');
        return checked ? checked.value : 'package';
    }

    function updateExportNote() {
        const note = $('#export-mode-note');
        note.textContent = exportMode() === 'live'
            ? App.t('export_note_live', '')
            : App.t('export_note_package', '');
    }

    function setExportBusy(busy, label) {
        $('#btn-export-run').classList.toggle('busy', busy);
        $('#export-progress').hidden = !busy;
        if (label) { $('#export-progress-label').textContent = label; }
    }

    async function runExport() {
        const mode = exportMode();
        const name = ($('#export-name').value || 'my_minimap').trim()
            .replace(/[^\w-]/g, '_').slice(0, 40) || 'my_minimap';
        $('#export-name').value = name;
        $('#export-result').hidden = true;

        setExportBusy(true, App.t('loading', 'Loading…'));
        // give the progress bar a frame before the heavy compose
        await new Promise(r => setTimeout(r, 30));

        try {
            if (mode === 'live') {
                const tiles = await Editor.composeTilesAsync(1024, null, (f) =>
                    setExportBusy(true, `${App.t('export_composing', 'Composing')}… ${Math.round(f * 100)}%`));
                await App.sendBlob('live', { name, map: Editor.currentMap, tiles }, (f) =>
                    setExportBusy(true, `Uploading… ${Math.round(f * 100)}%`));
                setExportBusy(false);
                refreshLiveButton();
            } else if (Editor.isCayo()) {
                // Cayo Perico → re-embed the painted island back into the
                // style's .gfx (single composited tile).
                const d = Editor.dims();
                const tiles = await Editor.composeTilesAsync(d.FULL_TILE, null, (f) =>
                    setExportBusy(true, `${App.t('export_composing', 'Composing')}… ${Math.round(f * 100)}%`));
                await App.sendBlob('stage', {
                    name, cayoPaint: true, cayoStyle: Editor.cayoStyle(), tiles,
                }, (f) => setExportBusy(true, `Uploading… ${Math.round(f * 100)}%`));
                setExportBusy(false);
            } else {
                const d = Editor.dims();
                /* Qualidade do export. "light" compõe a metade da resolução
                   E manda o build usar o template leve (2048 DXT5) em vez do
                   4096 sem compressão do mapa base: o resource passa de
                   centenas de MB para poucas dezenas. */
                const quality = exportQuality();
                const outSize = quality === 'light' ? Math.min(2048, d.FULL_TILE) : d.FULL_TILE;
                // the ONLY path that also ships blips.lua → don't bake them
                const tiles = await Editor.composeTilesAsync(outSize, { forExport: true }, (f) =>
                    setExportBusy(true, `${App.t('export_composing', 'Composing')}… ${Math.round(f * 100)}%`));
                /* Qualidade nativa: além do design composto (fallback), vai um
                   OVERLAY por tile — só a pilha por cima da base (pinturas,
                   objetos, postais) sobre transparente, renderizado à resolução
                   NATIVA do mapa (4096). O make_ytd compõe esse overlay sobre a
                   base tirada diretamente do template .ytd: zero upscale, os
                   vetores saem cristalinos ao dar zoom em jogo. */
                let overlays = null, native = 0, theme = null;
                if (quality !== 'light') {
                    const mapMeta = mapsCatalog.find(m => m.id === Editor.currentMap) || {};
                    native = mapMeta.native || d.FULL_TILE;
                    overlays = await Editor.composeTilesAsync(native,
                        { forExport: true, overlayOnly: true }, (f) =>
                        setExportBusy(true, `${App.t('export_overlay', 'Rendering native detail')}… ${Math.round(f * 100)}%`));
                    const T = Editor.theme;
                    theme = { hue: T.hue, sat: T.sat, bri: T.bri, con: T.con,
                              tint: T.tint, tintAmt: T.tintAmt };
                }
                const P = Editor.getPostals();
                // com o deslocamento JÁ aplicado: o /gps em jogo tem de
                // apontar para onde os números estão desenhados no mapa
                const postals = P.ingameScript
                    ? { setName: P.setName, style: P.style, overrides: P.overrides,
                        points: Editor.getPostalPointsResolved() }
                    : null;
                const cayoStyleSel = ($('#export-cayo-style') || {}).value || 'match';
                const blips = Editor.getBlips();
                const exts = Editor.getExtensions();
                const payload = {
                    name, map: Editor.currentMap, tiles, postals,
                    overlays, native: native || null, theme,
                    blips: blips.length ? blips : null,
                    extensions: exts.length ? exts : null,
                    cayo: $('#export-cayo').checked,
                    cayoStyle: cayoStyleSel === 'match' ? null : cayoStyleSel,
                    hideRoads: $('#export-hideroads').checked,
                    quality,
                };
                /* O servidor DESCARTA em silêncio um blob acima de
                   maxTransferBytes. Um design carregado de pinturas pode
                   passar do limite com os overlays nativos — nesse caso
                   larga-se só os overlays (export clássico) e avisa-se,
                   em vez de o export morrer sem resposta. */
                if (payload.overlays) {
                    const limit = App.state.config.maxTransferBytes || (24 * 1024 * 1024);
                    let size = Infinity;
                    try { size = JSON.stringify(payload).length; } catch (e) { /* fica Infinity */ }
                    if (size > limit) {
                        payload.overlays = null; payload.native = null; payload.theme = null;
                        App.toast(App.t('export_overlay_too_big',
                            'Design too heavy for native compositing — exporting the classic way. Raise Config.limits.maxTransferBytes to keep full quality.'), 'error');
                    }
                }
                await App.sendBlob('stage', payload,
                    (f) => setExportBusy(true, `Uploading… ${Math.round(f * 100)}%`));
                setExportBusy(false);
            }
        } catch (err) {
            console.error(err);
            setExportBusy(false);
            App.toast(App.t('export_failed', 'Export failed.'), 'error');
        }
    }

    /* ════════ DOWNLOAD ATLAS PNG ════════ */

    let downloadBusy = false;

    function setDownloadBusy(b) {
        downloadBusy = b;
        const btn = $('#btn-download-png');
        if (btn) { btn.classList.toggle('busy', b); }
    }

    App.on('downloadResult', (p) => {
        setDownloadBusy(false);
        if (!p.ok) {
            App.toast(p.message || App.t('download_failed', 'Could not save the PNG.'), 'error');
            return;
        }
        // Show the folder, not just "saved" — the file lands on the machine
        // running the SERVER, so the player needs the actual path.
        App.modal({
            title: App.t('download_title', 'Atlas PNG saved'),
            icon: 'fa-solid fa-download',
            hideCancel: true,
            confirmLabel: App.t('tip_close', 'Close'),
            bodyHTML:
                `<p>${escapeHtml(App.t('download_hint', 'Written on the machine running the server:'))}</p>` +
                `<div class="result-box mono ok">${escapeHtml(p.dir || '')}</div>` +
                `<p class="pane-hint">${escapeHtml(p.file || '')}</p>`,
        });
        App.toast(p.message || App.t('download_done', 'Saved'), 'success');
    });

    App.on('exportResult', (p) => {
        setExportBusy(false);
        const box = $('#export-result');
        box.hidden = false;
        box.className = 'result-box mono ' + (p.ok ? 'ok' : 'fail');
        box.textContent = p.message || (p.ok ? 'OK' : 'Failed');
        App.toast(p.message || (p.ok ? 'OK' : 'Failed'), p.ok ? 'success' : 'error');
    });

    /* ════════ LIVE MANAGER ════════ */

    async function refreshLiveButton() {
        const info = await App.post('liveStatus');
        $('#btn-live').classList.toggle('on', !!(info && info.active));
    }

    async function openLiveModal() {
        const info = await App.post('liveStatus') || {};
        const active = !!info.active;
        const previewOn = Editor.previewEnabled;
        App.modal({
            title: App.t('live_title', 'Live on server'),
            icon: 'fa-solid fa-tower-broadcast',
            wide: true,
            bodyHTML: `
                <p>${App.t('live_note', '')}</p>
                <div class="result-box mono ${active ? 'ok' : ''}" style="${active ? '' : 'background:var(--surface-2);color:var(--text-3)'}">
                    ${active
                        ? `● LIVE — ${escapeHtml(info.name || 'map')}`
                        : '○ ' + App.t('theme_none', 'Original')}
                </div>
                <div style="display:flex;gap:8px;flex-wrap:wrap">
                    <button id="lm-apply" class="btn btn-primary"><i class="fa-solid fa-tower-broadcast"></i> ${App.t('live_apply', 'Apply to everyone')}</button>
                    <button id="lm-clear" class="btn btn-ghost" ${active ? '' : 'disabled'}><i class="fa-solid fa-arrow-rotate-left"></i> ${App.t('live_clear', 'Restore original')}</button>
                    <button id="lm-local" class="btn btn-ghost"><i class="fa-solid fa-satellite-dish"></i> ${previewOn ? App.t('live_local_off', 'Stop my preview') : App.t('live_local', 'Preview on my radar')}</button>
                    <button id="lm-cayo" class="btn btn-ghost"><i class="fa-solid fa-umbrella-beach"></i> ${cayoPreviewOn ? App.t('live_cayo_off', 'Stop Cayo view') : App.t('live_cayo', 'View Cayo on my radar')}</button>
                </div>`,
            hideCancel: true,
            confirmLabel: App.t('tip_close', 'Close'),
        });
        $('#lm-apply').addEventListener('click', async () => {
            App.closeModal();
            const name = ($('#export-name').value || 'my_minimap');
            App.toast(App.t('saving', 'Saving…'), 'info');
            const tiles = Editor.composeTiles(1024);
            await App.sendBlob('live', { name, tiles });
            refreshLiveButton();
        });
        $('#lm-clear').addEventListener('click', async () => {
            App.closeModal();
            await App.post('liveClear');
            refreshLiveButton();
        });
        $('#lm-local').addEventListener('click', () => {
            App.closeModal();
            Editor.setPreviewEnabled(!Editor.previewEnabled);
        });
        $('#lm-cayo').addEventListener('click', async () => {
            App.closeModal();
            cayoPreviewOn = !cayoPreviewOn;
            await App.post('cayoPreview', { on: cayoPreviewOn });
            App.toast(cayoPreviewOn
                ? App.t('live_cayo_on_toast', 'Cayo Perico map shown on your radar')
                : App.t('live_cayo_off_toast', 'Cayo view stopped'), 'info');
        });
    }

    /* ════════ TOPBAR / HELP / RESET ════════ */

    function openHelp() {
        App.modal({
            title: App.t('help_title', 'Controls & shortcuts'),
            icon: 'fa-regular fa-keyboard',
            wide: true,
            hideCancel: true,
            confirmLabel: 'OK',
            bodyHTML: `
                <div class="help-grid">
                    <div class="help-sect">Text</div>
                    <div class="help-row"><span>Place a label — type straight on the map</span><kbd>T</kbd> <kbd>Click</kbd></div>
                    <div class="help-row"><span>Edit an existing label</span><kbd>Double-click</kbd></div>
                    <div class="help-row"><span>Edit the selected label</span><kbd>Enter / F2</kbd></div>
                    <div class="help-row"><span>Finish / discard while typing</span><kbd>Enter / Esc</kbd></div>
                    <div class="help-sect">Select &amp; transform</div>
                    <div class="help-row"><span>Move</span><kbd>Drag</kbd></div>
                    <div class="help-row"><span>Straight line while moving</span><kbd>Shift + drag</kbd></div>
                    <div class="help-row"><span>Duplicate while moving</span><kbd>Alt + drag</kbd></div>
                    <div class="help-row"><span>Ignore the snapping guides</span><kbd>Ctrl + drag</kbd></div>
                    <div class="help-row"><span>Resize</span><kbd>Drag a handle</kbd></div>
                    <div class="help-row"><span>Keep proportions / from the centre</span><kbd>Shift / Alt</kbd></div>
                    <div class="help-row"><span>Rotate (15° steps with Shift)</span><kbd>Drag the top handle</kbd></div>
                    <div class="help-row"><span>Pick what is UNDER the selection</span><kbd>Alt + click</kbd></div>
                    <div class="help-row"><span>Duplicate the selected layer</span><kbd>Ctrl+D</kbd></div>
                    <div class="help-row"><span>Drop the selection</span><kbd>Esc</kbd></div>
                    <div class="help-sect">Tools</div>
                    <div class="help-row"><span>Pan / select</span><kbd>V</kbd></div>
                    <div class="help-row"><span>Brush</span><kbd>B</kbd></div>
                    <div class="help-row"><span>Eraser</span><kbd>E</kbd></div>
                    <div class="help-row"><span>Fill</span><kbd>F</kbd></div>
                    <div class="help-row"><span>Eyedropper</span><kbd>I</kbd></div>
                    <div class="help-row"><span>Text</span><kbd>T</kbd></div>
                    <div class="help-row"><span>Shape</span><kbd>S</kbd></div>
                    <div class="help-row"><span>Zone highlight</span><kbd>Z</kbd></div>
                    <div class="help-sect">Polygon zone</div>
                    <div class="help-row"><span>Add corner</span><kbd>Click</kbd></div>
                    <div class="help-row"><span>Close the zone</span><kbd>Enter / click 1st point</kbd></div>
                    <div class="help-row"><span>Take back last corner</span><kbd>Ctrl+Z</kbd></div>
                    <div class="help-row"><span>Delete one corner</span><kbd>Alt + click it</kbd></div>
                    <div class="help-row"><span>Cancel the zone</span><kbd>Esc</kbd></div>
                    <div class="help-row"><span>Move a corner (after closing)</span><kbd>Drag it</kbd></div>
                    <div class="help-sect">Canvas</div>
                    <div class="help-row"><span>Zoom</span><kbd>Scroll</kbd></div>
                    <div class="help-row"><span>Pan</span><kbd>Space + drag</kbd></div>
                    <div class="help-row"><span>Fit to view</span><kbd>0</kbd></div>
                    <div class="help-row"><span>Undo / Redo</span><kbd>Ctrl+Z / Ctrl+Y</kbd></div>
                    <div class="help-row"><span>Delete selected layer</span><kbd>Del</kbd></div>
                    <div class="help-row"><span>Nudge selected layer (×10 with Shift)</span><kbd>Arrows</kbd></div>
                    <div class="help-row"><span>Brush size</span><kbd>[ / ]</kbd></div>
                    <div class="help-row"><span>Paste image</span><kbd>Ctrl+V</kbd></div>
                    <div class="help-sect">Studio</div>
                    <div class="help-row"><span>${App.t('tip_settings', 'Appearance & theme')}</span><kbd>/${App.state.config.command || 'minimapstudio'}settings</kbd></div>
                    <div class="help-row"><span>Close the studio</span><kbd>Esc</kbd></div>
                </div>`,
        });
    }

    function bindTopbar() {
        $('#btn-help').addEventListener('click', openHelp);
        const settingsBtn = $('#btn-settings');
        if (settingsBtn && window.ApexTheme) {
            settingsBtn.addEventListener('click', () => ApexTheme.open());
        }
        $('#btn-save').addEventListener('click', saveProject);
        $('#btn-save-project').addEventListener('click', saveProject);
        $('#btn-live').addEventListener('click', openLiveModal);
        $('#btn-export').addEventListener('click', () => {
            switchTab('export');
        });
        $('#project-pill').addEventListener('click', () => switchTab('projects'));
        $('#btn-reset-all').addEventListener('click', () => {
            App.modal({
                title: App.t('reset_all_tip', 'Reset everything'),
                icon: 'fa-solid fa-arrow-rotate-left',
                danger: true,
                bodyHTML: `<p>${App.t('reset_confirm', 'Reset the whole map? All layers are lost.')}</p>`,
                confirmLabel: App.t('reset_all_tip', 'Reset'),
                onConfirm: () => {
                    Editor.resetAll();
                    syncThemeSliders();
                    renderThemeCards();
                },
            });
        });
    }

    /* ════════ MAP EXTENSIONS ════════
       Um mapa add-on (Roxwood e companhia) fica fora da caixa onde o jogo
       deixa o jogador andar. Aqui marca-se a área em coordenadas de MUNDO
       e o export gera um extensions.lua com ExtendWorldBoundaryForPlayer,
       que é exatamente o native que faz o sítio passar a ser alcançável. */

    function extRow(e) {
        const row = document.createElement('div');
        row.className = 'ext-row';
        row.innerHTML = `
            <div class="ext-head">
                <input class="input ext-name" type="text" maxlength="32" value="${escapeHtml(e.name || '')}"
                       spellcheck="false" autocomplete="off">
                <button class="btn-icon sm danger ext-del" data-tip="Remove"><i class="fa-solid fa-trash"></i></button>
            </div>
            <div class="ext-grid">
                <label class="ext-field"><span class="micro-label">X1</span><input class="input mono" type="number" data-k="x1" value="${Math.round(e.x1)}"></label>
                <label class="ext-field"><span class="micro-label">Y1</span><input class="input mono" type="number" data-k="y1" value="${Math.round(e.y1)}"></label>
                <label class="ext-field"><span class="micro-label">X2</span><input class="input mono" type="number" data-k="x2" value="${Math.round(e.x2)}"></label>
                <label class="ext-field"><span class="micro-label">Y2</span><input class="input mono" type="number" data-k="y2" value="${Math.round(e.y2)}"></label>
                <label class="ext-field"><span class="micro-label">Z</span><input class="input mono" type="number" data-k="z" value="${Math.round(e.z || 0)}"></label>
                <span class="ext-size mono"></span>
            </div>
            <label class="check-row">
                <input type="checkbox" class="ext-bounds" ${e.bounds !== false ? 'checked' : ''}>
                <span>${App.t('ext_bounds', 'Extend the world boundary here')}</span>
            </label>`;

        const sizeEl = row.querySelector('.ext-size');
        const syncSize = () => {
            sizeEl.textContent = `${Math.abs(Math.round(e.x2 - e.x1))} × ${Math.abs(Math.round(e.y2 - e.y1))} m`;
        };
        syncSize();

        row.querySelector('.ext-name').addEventListener('input', (ev) => {
            Editor.updateExtension(e.id, { name: ev.target.value });
        });
        row.querySelectorAll('.ext-grid input').forEach(inp => {
            inp.addEventListener('input', () => {
                const v = Number(inp.value);
                if (!isFinite(v)) { return; }
                Editor.updateExtension(e.id, { [inp.dataset.k]: v });
                syncSize();
            });
        });
        row.querySelector('.ext-bounds').addEventListener('change', (ev) => {
            Editor.updateExtension(e.id, { bounds: ev.target.checked });
        });
        row.querySelector('.ext-del').addEventListener('click', () => Editor.removeExtension(e.id));
        return row;
    }

    function renderExtensions() {
        const list = $('#ext-list');
        if (!list) { return; }
        const items = Editor.getExtensions();
        const tab = $('.dock-tab[data-tab=extensions] .tab-count');
        if (tab) { tab.textContent = items.length ? String(items.length) : ''; }
        if (!items.length) {
            list.innerHTML = `<div class="empty-state small">
                <i class="fa-solid fa-maximize"></i>
                <span>${App.t('ext_empty', 'No extensions yet — draw the area your add-on map covers')}</span></div>`;
            return;
        }
        list.innerHTML = '';
        for (const e of items) { list.appendChild(extRow(e)); }
    }

    function bindExtensions() {
        const draw = $('#ext-draw');
        if (draw) {
            draw.addEventListener('click', () => {
                Editor.setTool('ext');
                App.toast(App.t('ext_draw_hint', 'Drag on the map to mark the area the add-on covers'), 'info');
            });
        }
        const add = $('#ext-add');
        if (add) {
            add.addEventListener('click', () => {
                // uma área ao lado do centro do mapa, para depois se afinar
                Editor.addExtension({
                    name: 'Extension ' + (Editor.getExtensions().length + 1),
                    x1: 3000, y1: 7000, x2: 5000, y2: 9000, z: 100, bounds: true,
                });
            });
        }
        Editor.onEvent('extensions', renderExtensions);
        renderExtensions();
    }

    /* ════════ ASSISTENTE ════════
       O cliente só transporta: a pergunta e o retrato do estúdio vão para
       o servidor (que tem a chave) e a resposta volta. As acções que o
       modelo sugere são executadas AQUI, contra uma lista fechada — nunca
       mexem no mapa, só abrem separadores e escolhem ferramentas. */

    const askHistory = [];
    let askBusy = false;
    let askSeq = 0;
    let askPending = null;

    const ASK_ACTIONS = {
        'tool.move':  () => Editor.setTool('pan'),
        'tool.brush': () => Editor.setTool('brush'),
        'tool.eraser': () => Editor.setTool('eraser'),
        'tool.fill':  () => Editor.setTool('fill'),
        'tool.picker': () => Editor.setTool('picker'),
        'tool.zone':  () => Editor.setTool('zone'),
        'tool.text':  () => Editor.setTool('text'),
        'tool.shape': () => Editor.setTool('shape'),
        'tool.image': () => Editor.setTool('image'),
        'tool.blip':  () => Editor.setTool('blip'),
        'dock.layers': () => switchTab('layers'),
        'dock.themes': () => switchTab('themes'),
        'dock.projects': () => switchTab('projects'),
        'dock.postals': () => switchTab('postals'),
        'dock.extensions': () => switchTab('extensions'),
        'dock.export': () => switchTab('export'),
        'view.fit': () => Editor.zoomFit(),
        'view.in': () => Editor.setZoom(Editor.zoom * 1.25),
        'view.out': () => Editor.setZoom(Editor.zoom / 1.25),
        'view.tiles': () => { const t = $('#tiles-toggle'); t.checked = !t.checked; Editor.setShowTiles(t.checked); },
        'view.grid': () => { const g = $('#grid-toggle'); g.checked = !g.checked; Editor.setShowGrid(g.checked); },
        'layer.add': () => { switchTab('layers'); openAddLayerMenu(); },
        'app.settings': () => { if (window.ApexTheme) { ApexTheme.open(); } },
        'app.help': () => openHelp(),
        'postals.drag': () => { switchTab('postals'); Editor.setTool('postalmove'); },
        'ext.draw': () => { switchTab('extensions'); Editor.setTool('ext'); },
    };

    function askContext() {
        const sel = Editor.getObject(Editor.selectedId);
        const P = Editor.getPostals();
        const openTab = ($('.dock-tab.active') || {}).dataset;
        return {
            tool: Editor.tool,
            layers: Editor.objects.length,
            selected: sel ? sel.type : 'none',
            map: Editor.currentMap,
            postals: !!P.enabled,
            postalCount: P.points.length,
            extensions: Editor.getExtensions().length,
            zoom: Math.round(Editor.zoom * 100) + '%',
            dirty: Editor.dirty,
            tab: openTab ? openTab.tab : '',
        };
    }

    function askBubble(role, text, actions) {
        const log = $('#ask-log');
        const intro = log.querySelector('.ask-intro');
        if (intro) { intro.remove(); }
        const el = document.createElement('div');
        el.className = 'ask-msg ask-' + role;
        const body = document.createElement('div');
        body.className = 'ask-body';
        body.textContent = text;
        el.appendChild(body);
        if (actions && actions.length) {
            const row = document.createElement('div');
            row.className = 'ask-actions';
            for (const a of actions) {
                if (!ASK_ACTIONS[a.id]) { continue; }   // nunca confiar no id
                const b = document.createElement('button');
                b.className = 'btn btn-soft btn-mini';
                b.textContent = a.label || a.id;
                b.addEventListener('click', () => {
                    try { ASK_ACTIONS[a.id](); } catch (e) { /* */ }
                });
                row.appendChild(b);
            }
            if (row.children.length) { el.appendChild(row); }
        }
        log.appendChild(el);
        log.scrollTop = log.scrollHeight;
        return el;
    }

    function askSend(text) {
        const q = String(text || $('#ask-input').value || '').trim();
        if (!q || askBusy) { return; }
        $('#ask-input').value = '';
        askBubble('user', q);
        askHistory.push({ role: 'user', content: q });
        askBusy = true;
        $('#ask-send').classList.add('busy');
        const thinking = askBubble('bot', App.t('ask_thinking', 'Thinking…'));
        thinking.classList.add('ask-thinking');
        askPending = { id: 'ask_' + (++askSeq), el: thinking };
        App.post('aiAsk', { id: askPending.id, question: q, history: askHistory.slice(-12), ctx: askContext() });
        // rede lenta ou servidor sem resposta: não deixar o balão a pensar
        setTimeout(() => {
            if (askPending && askPending.el === thinking) { askAnswer({ id: askPending.id, ok: false, error: App.t('ask_timeout', 'No answer from the server.') }); }
        }, 60000);
    }

    function askAnswer(p) {
        if (!askPending || (p.id && p.id !== askPending.id)) { return; }
        const el = askPending.el;
        askPending = null;
        askBusy = false;
        $('#ask-send').classList.remove('busy');
        el.remove();
        if (p.ok && p.answer) {
            askBubble('bot', p.answer, p.actions);
            askHistory.push({ role: 'assistant', content: String(p.answer).slice(0, 1200) });
        } else {
            const e = askBubble('bot', p.error || App.t('ask_failed', 'The assistant could not answer.'));
            e.classList.add('ask-error');
        }
    }

    function bindAsk() {
        const send = $('#ask-send');
        const input = $('#ask-input');
        if (!send || !input) { return; }
        send.addEventListener('click', () => askSend());
        input.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') { e.preventDefault(); askSend(); }
            e.stopPropagation();          // as teclas de ferramenta não roubam
        });
        $$('.ask-chip').forEach(c => c.addEventListener('click', () => askSend(c.dataset.ask)));
        App.on('aiAnswer', askAnswer);
        // o separador só existe se o assistente estiver ligado na config
        if (App.state.config.aiEnabled === false) {
            const tab = $('.dock-tab[data-tab=ask]');
            if (tab) { tab.hidden = true; }
        }
    }

    /* ════════ DOCK TABS ════════ */

    function switchTab(name) {
        const tabs = $$('.dock-tab');
        tabs.forEach(t => t.classList.toggle('active', t.dataset.tab === name));
        $$('.dock-pane').forEach(p => p.classList.toggle('active', p.dataset.pane === name));
        // the active tile SLIDES between positions — the spine owns one
        // indicator, not five painted backgrounds
        const idx = tabs.findIndex(t => t.dataset.tab === name);
        const spine = $('.dock-tabs');
        if (spine && idx >= 0) { spine.style.setProperty('--i', String(idx)); }
        if (name === 'projects') { refreshProjects(); }
        if (name === 'export') { updateExportNote(); }
    }

    /* ── qualidade do export ──────────────────────────────────
       "Full" reconstrói cada tile no formato nativo do mapa base (4096
       sem compressão): é o melhor que há e são centenas de MB. "Light"
       compõe a metade da resolução e manda o build usar o template leve
       (2048 DXT5) — o mesmo desenho num resource dezenas de vezes mais
       pequeno, e um export que não pendura o jogo a meio. */
    let exportQualityMode = 'native';
    function exportQuality() { return exportQualityMode; }

    function updateQualityNote() {
        const note = $('#quality-note');
        if (!note) { return; }
        note.textContent = exportQualityMode === 'light'
            ? App.t('export_q_light_note', 'Half-resolution tiles rebuilt as compressed 2048 textures — a much smaller resource and a much faster export. Best for servers that care about download size.')
            : App.t('export_q_native_note', 'The base comes straight from the map’s native 4096 texture — zero upscale — with your design rendered on top at native resolution. Sharpest result possible, biggest resource, slowest export.');
    }

    function bindQuality() {
        const seg = $('.quality-seg');
        if (!seg) { return; }
        seg.querySelectorAll('.seg-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                exportQualityMode = btn.dataset.quality;
                seg.querySelectorAll('.seg-btn').forEach(b => b.classList.toggle('active', b === btn));
                updateQualityNote();
            });
        });
        updateQualityNote();
    }

    function bindDock() {
        $$('.dock-tab').forEach(tab => {
            tab.addEventListener('click', () => switchTab(tab.dataset.tab));
        });
        bindQuality();
        $$('input[name=export-mode]').forEach(r => r.addEventListener('change', updateExportNote));
        $('#btn-export-run').addEventListener('click', runExport);
        // Cayo style row only matters when the island is included
        const cayoToggle = $('#export-cayo');
        const cayoRow = $('#cayo-style-row');
        const syncCayoRow = () => { if (cayoRow) { cayoRow.style.display = cayoToggle.checked ? '' : 'none'; } };
        if (cayoToggle) { cayoToggle.addEventListener('change', syncCayoRow); syncCayoRow(); }
    }

    /* ════════ CANVAS HEAD + STATUSBAR ════════ */

    function bindCanvasHead() {
        $('#zoom-in').addEventListener('click', () => Editor.setZoom(Editor.zoom * 1.25));
        $('#zoom-out').addEventListener('click', () => Editor.setZoom(Editor.zoom / 1.25));
        $('#btn-zoom-fit').addEventListener('click', Editor.zoomFit);
        $('#tiles-toggle').addEventListener('change', (e) => Editor.setShowTiles(e.target.checked));
        $('#grid-toggle').addEventListener('change', (e) => Editor.setShowGrid(e.target.checked));
        // CEF has no download handler, so `<a download>` did nothing at all.
        // Compose the atlas, ship it to the server and let it write a real
        // .png — then tell the player exactly where it landed.
        $('#btn-download-png').addEventListener('click', async () => {
            if (downloadBusy) { return; }
            const d = Editor.dims();
            const cv = document.createElement('canvas');
            cv.width = d.AW; cv.height = d.AH;
            setDownloadBusy(true);
            const tiles = await Editor.composeTilesAsync(d.EDIT_TILE);
            if (!tiles.length) { setDownloadBusy(false); return; }
            let left = tiles.length;
            const ctx = cv.getContext('2d');
            tiles.forEach(t => {
                const img = new Image();
                img.onload = async () => {
                    ctx.drawImage(img, t.col * d.EDIT_TILE, t.row * d.EDIT_TILE);
                    if (--left > 0) { return; }
                    try {
                        const name = (currentProject.name || 'minimap_atlas')
                            .replace(/[^\w\-]+/g, '_') || 'minimap_atlas';
                        // encode assíncrono: o atlas inteiro em PNG bloqueava
                        const image = await Editor.encodeCanvas(cv);
                        await App.sendBlob('download_png', { name, image });
                    } catch (err) {
                        setDownloadBusy(false);
                        App.toast(App.t('download_failed', 'Could not save the PNG.'), 'error');
                    }
                };
                img.onerror = () => {
                    if (--left <= 0) { setDownloadBusy(false); }
                };
                img.src = t.image;
            });
        });
        $('#preview-chip').addEventListener('click', () => {
            Editor.setPreviewEnabled(!Editor.previewEnabled);
        });
        $('#preview-chip').style.cursor = 'pointer';

        Editor.onEvent('zoom', (z) => {
            $('#zoom-value').textContent = Math.round(z * 100) + '%';
        });

        Editor.onEvent('preview', (on) => {
            $('#preview-chip').classList.toggle('live', on);
            $('#preview-chip').classList.toggle('off', !on);
            $('#preview-label').textContent = on
                ? App.t('preview_live', 'Live preview')
                : App.t('preview_off', 'Preview paused');
        });

        Editor.onEvent('cursor', (p) => {
            const d = Editor.dims();
            const wb = App.state.config.worldBounds;
            const inMap = p.x >= 0 && p.y >= 0 && p.x < d.AW && p.y < d.AH;
            const tileEl = $('#status-tile');
            if (!inMap) {
                tileEl.hidden = true;
                $('#status-px').textContent = '—';
                $('#status-world').textContent = '—';
                return;
            }
            const row = Math.floor(p.y / d.EDIT_TILE), col = Math.floor(p.x / d.EDIT_TILE);
            tileEl.hidden = false;
            tileEl.textContent = `minimap_${row}_${col}`;
            $('#status-px').textContent = `${Math.round(p.x * 2)}, ${Math.round(p.y * 2)} px`;
            const wx = wb.left + (p.x / d.AW) * (wb.right - wb.left);
            const wy = wb.top + (p.y / d.AH) * (wb.bottom - wb.top);
            $('#status-world').textContent = `${wx.toFixed(0)}, ${wy.toFixed(0)}`;
        });

        Editor.onEvent('brush', () => renderToolOptions());
    }

    /* ════════ WIRE EVERYTHING ════════ */

    function bindAll() {
        watchSelects();   // must run first so every select is styled from the start
        bindRail();
        bindLayerOps();
        bindThemes();
        bindDock();
        bindTopbar();
        bindCanvasHead();
        bindMaps();
        bindPostals();
        bindExtensions();
        bindAsk();
        syncPostalUI();
    }

})();
