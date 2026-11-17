
(function () {
    'use strict';

    const RES = (typeof GetParentResourceName === 'function')
        ? GetParentResourceName() : 'tw-builderjob';


    function post(name, data) {
        return fetch(`https://${RES}/${name}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data || {})
        }).catch(() => { });
    }

    function el(tag, attrs, children) {
        const e = document.createElement(tag);
        if (attrs) for (const k in attrs) {
            if (k === 'class') e.className = attrs[k];
            else if (k.startsWith('on') && typeof attrs[k] === 'function') {
                e.addEventListener(k.slice(2).toLowerCase(), attrs[k]);
            } else e.setAttribute(k, attrs[k]);
        }
        if (children) {
            (Array.isArray(children) ? children : [children]).forEach(c => {
                if (c == null) return;
                if (typeof c === 'string') e.appendChild(document.createTextNode(c));
                else e.appendChild(c);
            });
        }
        return e;
    }

    function fmt(n, d) {
        const m = Math.pow(10, d || 3);
        return (Math.round((n || 0) * m) / m).toFixed(d || 3);
    }


    let panel = null;
    let state = {
        active: false,
        pickingRoot: false,
        focused: false,
        rootLabel: 'world',
        nodes: [],
        activeIndex: 0,
        axis: 'x',
        adjustType: 'pos',
        stepIndex: 4,
        steps: [0.001, 0.005, 0.01, 0.05, 0.1, 0.5, 1.0],
        exportText: ''
    };

    function build() {
        if (panel) return;
        panel = el('div', { id: 'crane-panel' });
        document.body.appendChild(panel);
    }

    function activeNode() {
        return state.nodes.find(n => n.idx === state.activeIndex);
    }

    function render() {
        if (!panel) build();
        panel.classList.toggle('crane-visible', !!state.active);
        panel.classList.toggle('crane-focused', !!state.focused);
        panel.innerHTML = '';
        if (!state.active) return;

        panel.appendChild(el('div', { class: 'crane-header' }, [
            el('span', { class: 'crane-title' }, 'CRANE CHAIN'),
            el('span', { class: 'crane-focus-pill' },
                state.focused ? '● MOUSE ON (ESC)' : '○ keys only (/cranefocus)')
        ]));

        const body = el('div', { class: 'crane-body' });

        body.appendChild(rootSection());

        if (state.pickingRoot) {
            panel.appendChild(body);
            panel.appendChild(footer());
            return;
        }

        body.appendChild(addNodeSection());

        body.appendChild(importSection());

        const a = activeNode();
        if (a) body.appendChild(activeSection(a));

        body.appendChild(nodeListSection());

        if (state.exportText) body.appendChild(exportSection());

        panel.appendChild(body);
        panel.appendChild(footer());
    }

    function rootSection() {
        const s = el('div', { class: 'crane-section' });
        s.appendChild(el('div', { class: 'crane-label' }, 'CHAIN ROOT'));

        if (state.pickingRoot) {
            s.appendChild(el('div', { class: 'crane-pick-banner' },
                'Aim at vehicle / object — press [E] to pick'));
            s.appendChild(el('div', { class: 'crane-row' }, [
                el('button', {
                    class: 'crane-btn crane-danger',
                    onclick: () => post('crane:cancelPick')
                }, 'Cancel pick')
            ]));
        } else {
            s.appendChild(el('div', { class: 'crane-status-line' }, 'root: ' + state.rootLabel));
            s.appendChild(el('div', { class: 'crane-row' }, [
                el('button', { class: 'crane-btn', onclick: () => post('crane:pickRoot') }, 'Pick vehicle / object'),
                el('button', { class: 'crane-btn', onclick: () => post('crane:setRootWorld') }, 'Use world')
            ]));
        }
        return s;
    }

    function addNodeSection() {
        const s = el('div', { class: 'crane-section' });
        s.appendChild(el('div', { class: 'crane-label' }, 'ADD NODE'));

        const modelInput = el('input', {
            class: 'crane-input', placeholder: 'prop model (e.g. tworst_buildbase1)'
        });

        const parentSel = el('select', { class: 'crane-input' });
        parentSel.appendChild(new Option('parent: 0 (root)', '0'));
        state.nodes.forEach(n => {
            parentSel.appendChild(new Option(`parent: ${n.idx} (${n.model})`, String(n.idx)));
        });
        if (state.nodes.length > 0) parentSel.value = String(state.nodes[state.nodes.length - 1].idx);

        const boneInput = el('input', {
            class: 'crane-input', placeholder: 'bone (optional, e.g. chassis)'
        });

        s.appendChild(el('div', { class: 'crane-row' }, [modelInput]));
        s.appendChild(el('div', { class: 'crane-row' }, [parentSel]));
        s.appendChild(el('div', { class: 'crane-row' }, [boneInput]));
        s.appendChild(el('div', { class: 'crane-row' }, [
            el('button', {
                class: 'crane-btn crane-success', onclick: () => {
                    if (!modelInput.value.trim()) return;
                    post('crane:addNode', {
                        model: modelInput.value.trim(),
                        parentIdx: parseInt(parentSel.value, 10) || 0,
                        bone: boneInput.value.trim() || null
                    });
                    modelInput.value = '';
                    boneInput.value = '';
                }
            }, '+ Add to chain')
        ]));
        return s;
    }

    function axisBlock(node, type) {
        const block = el('div', { class: 'crane-axis-block' });
        block.appendChild(el('div', { class: 'crane-label' }, type === 'pos' ? 'OFFSET' : 'ROTATION'));
        ['x', 'y', 'z'].forEach(ax => {
            const val = type === 'pos' ? node.offset[ax] : node.rotation[ax];
            const valEl = el('input', {
                class: 'crane-axis-value',
                type: 'number',
                step: type === 'pos' ? '0.001' : '0.1',
                value: fmt(val, type === 'pos' ? 3 : 2)
            });
            valEl.addEventListener('change', () => {
                const v = parseFloat(valEl.value);
                if (!isNaN(v)) post('crane:setValue', { axis: ax, value: v, type: type });
            });
            const row = el('div', { class: 'crane-axis-row' }, [
                el('div', { class: 'crane-axis-label crane-' + ax }, ax.toUpperCase()),
                el('button', {
                    class: 'crane-btn crane-pm-btn',
                    onclick: () => post('crane:adjust', { axis: ax, dir: -1, type: type })
                }, '−'),
                valEl,
                el('button', {
                    class: 'crane-btn crane-pm-btn',
                    onclick: () => post('crane:adjust', { axis: ax, dir: 1, type: type })
                }, '+')
            ]);
            block.appendChild(row);
        });
        return block;
    }

    function activeSection(node) {
        const s = el('div', { class: 'crane-section' });
        s.appendChild(el('div', { class: 'crane-label' },
            `EDITING #${node.idx} — ${node.model} (parent ${node.parentIdx})`));

        s.appendChild(el('div', { class: 'crane-label' }, 'STEP (applies to ± buttons & arrow keys)'));
        const stepRow = el('div', { class: 'crane-step-row' });
        state.steps.forEach((st, i) => {
            stepRow.appendChild(el('button', {
                class: 'crane-btn' + (state.stepIndex === i + 1 ? ' crane-active' : ''),
                onclick: () => post('crane:setStep', { stepIndex: i + 1 })
            }, st < 0.01 ? st.toFixed(3) : (st < 1 ? st.toFixed(2) : st.toFixed(1))));
        });
        s.appendChild(stepRow);

        s.appendChild(axisBlock(node, 'pos'));
        s.appendChild(axisBlock(node, 'rot'));

        s.appendChild(el('div', { class: 'crane-label' }, 'PARENT BONE'));
        const boneRow = el('div', { class: 'crane-row' });
        const boneInp = el('input', {
            class: 'crane-input', placeholder: 'e.g. chassis (empty = root)',
            value: node.parentBone || ''
        });
        const boneBtn = el('button', {
            class: 'crane-btn', onclick: () =>
                post('crane:setBone', { bone: boneInp.value.trim() || null })
        }, 'Apply');
        boneRow.appendChild(boneInp);
        boneRow.appendChild(boneBtn);
        s.appendChild(boneRow);

        s.appendChild(el('div', { class: 'crane-row' }, [
            el('button', {
                class: 'crane-btn crane-success',
                onclick: () => post('crane:confirmActive')
            }, '✓ Confirm (lock as parent)'),
            el('button', {
                class: 'crane-btn crane-danger',
                onclick: () => post('crane:cancelActive')
            }, '✗ Delete')
        ]));

        s.appendChild(el('div', { class: 'crane-hint' },
            'keys also work — ↑/↓ value, ←/→ axis, mwheel step, ENTER confirm, BACK delete'));

        return s;
    }

    function importSection() {
        const s = el('div', { class: 'crane-section' });
        s.appendChild(el('div', { class: 'crane-label' }, 'IMPORT EXISTING CHAIN'));
        const ta = el('textarea', {
            class: 'crane-input',
            rows: '6',
            placeholder:
                "paste node lines from a previous export, e.g.:\n" +
                "{ name='node_1', model='tworst_buildexc1', parent=0, bone=nil, offset=vector3(0,0,1), rotation=vector3(0,0,0) },"
        });
        ta.style.fontFamily = "'Consolas', monospace";
        ta.style.fontSize = '11px';
        ta.style.minHeight = '90px';
        ta.style.resize = 'vertical';
        s.appendChild(ta);
        s.appendChild(el('div', { class: 'crane-row' }, [
            el('button', {
                class: 'crane-btn crane-success',
                onclick: () => {
                    if (!ta.value.trim()) return;
                    post('crane:import', { text: ta.value });
                    ta.value = '';
                }
            }, 'Import & continue from next node')
        ]));
        s.appendChild(el('div', { class: 'crane-hint' },
            'parent indices are remapped to current chain length. set the root first.'));
        return s;
    }

    function nodeListSection() {
        const s = el('div', { class: 'crane-section' });
        s.appendChild(el('div', { class: 'crane-label' }, `CHAIN (${state.nodes.length})`));
        if (state.nodes.length === 0) {
            s.appendChild(el('div', { class: 'crane-status-line' }, 'no nodes yet — add one above'));
            return s;
        }
        const list = el('div', { class: 'crane-nodes' });
        state.nodes.forEach(n => {
            const isActive = n.idx === state.activeIndex;
            const cls = 'crane-node' +
                (isActive ? ' crane-node-active' : '') +
                (!n.confirmed ? ' crane-node-pending' : '');
            const node = el('div', { class: cls });
            const info = el('div', { class: 'crane-node-info' }, [
                el('div', { class: 'crane-node-name' }, `[${n.idx}] ${n.model}`),
                el('div', { class: 'crane-node-meta' },
                    `parent ${n.parentIdx} • bone ${n.parentBone || '0'} • ` +
                    `pos(${fmt(n.offset.x, 2)}, ${fmt(n.offset.y, 2)}, ${fmt(n.offset.z, 2)})`)
            ]);
            const actions = el('div', { class: 'crane-node-actions' }, [
                el('button', {
                    class: 'crane-btn',
                    onclick: () => post('crane:editNode', { idx: n.idx })
                }, 'edit'),
                el('button', {
                    class: 'crane-btn crane-danger',
                    onclick: () => post('crane:removeNode', { idx: n.idx })
                }, '✕')
            ]);
            node.appendChild(info);
            node.appendChild(actions);
            list.appendChild(node);
        });
        s.appendChild(list);
        return s;
    }

    function exportSection() {
        const s = el('div', { class: 'crane-section' });
        s.appendChild(el('div', { class: 'crane-label' }, 'EXPORT'));
        s.appendChild(el('pre', { class: 'crane-export' }, state.exportText));
        s.appendChild(el('div', { class: 'crane-row' }, [
            el('button', {
                class: 'crane-btn', onclick: () => {
                    if (navigator.clipboard) navigator.clipboard.writeText(state.exportText).catch(() => { });
                    post('crane:copyExport', { text: state.exportText });
                }
            }, 'Copy to clipboard'),
            el('button', {
                class: 'crane-btn',
                onclick: () => { state.exportText = ''; render(); }
            }, 'Hide')
        ]));
        return s;
    }

    function footer() {
        return el('div', { class: 'crane-footer' }, [
            el('button', { class: 'crane-btn', onclick: () => post('crane:toggleFocus') },
                state.focused ? 'Unfocus (ESC)' : 'Focus mouse'),
            el('button', { class: 'crane-btn', onclick: () => post('crane:export') }, 'Export'),
            el('button', { class: 'crane-btn crane-danger', onclick: () => post('crane:close') }, 'Close')
        ]);
    }



    let keysHud = null;

    function buildKeysHud() {
        if (keysHud) return keysHud;
        keysHud = document.createElement('div');
        keysHud.id = 'crane-keys-hud';
        const row = (keys, desc) => {
            const caps = keys.map(k =>
                `<span class="crane-keycap${k.length > 2 ? ' crane-keycap-wide' : ''}">${k}</span>`
            ).join('');
            return `<div class="crane-keys-row"><span class="crane-keys-keys">${caps}</span>` +
                `<span class="crane-keys-desc">${desc}</span></div>`;
        };
        keysHud.innerHTML =
            '<div class="crane-keys-title">⚙ CRANE CONTROLS</div>' +
            row(['D', 'A'], 'base swing (slewing)') +
            row(['S', 'W'], 'telescopic extend / retract') +
            row(['↑', '↓'], 'boom pitch up / down') +
            row(['Q', 'E'], 'knuckle open / close') +
            row(['L-CLICK', 'R-CLICK'], 'rope: drop / raise hook') +
            row(['B', 'N'], 'base pitch') +
            row(['Z', 'X'], 'hook yaw left / right') +
            row(['SHIFT'], 'hold = slow (×0.25)') +
            row(['H'], 'exit control') +
            '<div class="crane-keys-footer">G = camera toggle</div>';
        document.body.appendChild(keysHud);
        return keysHud;
    }

    function showKeysHud() {
        buildKeysHud();
        requestAnimationFrame(() => keysHud.classList.add('crane-keys-visible'));
    }
    function hideKeysHud() {
        if (!keysHud) return;
        keysHud.classList.remove('crane-keys-visible');
    }

    let keysHudV2 = null;
    function buildKeysHudV2() {
        if (keysHudV2) return keysHudV2;
        keysHudV2 = document.createElement('div');
        keysHudV2.id = 'cranev2-keys-hud';
        const row = (keys, desc) => {
            const caps = keys.map(k =>
                `<span class="crane-keycap${k.length > 2 ? ' crane-keycap-wide' : ''}">${k}</span>`
            ).join('');
            return `<div class="crane-keys-row"><span class="crane-keys-keys">${caps}</span>` +
                `<span class="crane-keys-desc">${desc}</span></div>`;
        };
        keysHudV2.innerHTML =
            '<div class="crane-keys-title">⚙ CRANEV2 CONTROLS</div>' +
            row(['A', 'D'], 'slewing (base rotate)') +
            row(['W', 'S'], 'main boom up / down') +
            row(['←', '→'], 'knuckle open / close') +
            row(['↑', '↓'], 'telescope extend / retract') +
            row(['L-CLICK', 'R-CLICK'], 'rope: drop / raise hook') +
            row(['E'], 'pickup / place (grab + place anim)') +
            row(['SHIFT', '←/→'], 'rotate carried prop (yaw)') +
            row(['G'], 'stabilizer legs deploy / retract') +
            row(['V'], 'camera distance (3 tier)') +
            row(['SHIFT'], 'hold = slow (×0.25)') +
            row(['H'], 'exit control') +
            '<div class="crane-keys-footer">G = showcase camera (in control)</div>';
        document.body.appendChild(keysHudV2);
        return keysHudV2;
    }
    function showKeysHudV2() {
        buildKeysHudV2();
        if (keysHud) keysHud.classList.remove('crane-keys-visible');
        requestAnimationFrame(() => keysHudV2.classList.add('crane-keys-visible'));
    }
    function hideKeysHudV2() {
        if (!keysHudV2) return;
        keysHudV2.classList.remove('crane-keys-visible');
    }



    const HOOK_STEPS = [0.01, 0.05, 0.1, 0.5, 1.0];
    let hookTuneHud = null;
    let hookTuneState = {
        offset: { x: 0, y: 0, z: 0 },
        rot:    { x: 0, y: 0, z: 0 },
        stepIdx: 2,
    };

    function buildHookTuneHud() {
        if (hookTuneHud) return hookTuneHud;
        hookTuneHud = document.createElement('div');
        hookTuneHud.id = 'hook-tune-hud';
        document.body.appendChild(hookTuneHud);
        return hookTuneHud;
    }

    function renderHookTune() {
        if (!hookTuneHud) return;
        const step = HOOK_STEPS[hookTuneState.stepIdx] || 0.1;
        const axisRow = (kind, axis) => {
            const val = hookTuneState[kind][axis];
            const prec = kind === 'offset' ? 3 : 2;
            return `<div class="hook-tune-row">
                <span class="hook-tune-axis hook-${axis}">${axis.toUpperCase()}</span>
                <button class="hook-tune-pm" data-adj="${kind}|${axis}|-">−</button>
                <input class="hook-tune-value" type="number" step="${kind === 'offset' ? '0.001' : '0.1'}" value="${val.toFixed(prec)}" data-set="${kind}|${axis}">
                <button class="hook-tune-pm" data-adj="${kind}|${axis}|+">+</button>
            </div>`;
        };
        const stepBtn = (i, v) =>
            `<div class="hook-tune-step${hookTuneState.stepIdx === i ? ' hook-tune-active' : ''}" data-step="${i}">${v < 1 ? v.toFixed(2) : v.toFixed(1)}</div>`;

        hookTuneHud.innerHTML =
            '<div class="hook-tune-title">⚙ HOOK ATTACH TUNER</div>' +
            '<div class="hook-tune-label">STEP (± amount)</div>' +
            '<div class="hook-tune-steps">' + HOOK_STEPS.map((v, i) => stepBtn(i, v)).join('') + '</div>' +
            '<div class="hook-tune-label">OFFSET</div>' +
            ['x', 'y', 'z'].map(a => axisRow('offset', a)).join('') +
            '<div class="hook-tune-label">ROTATION</div>' +
            ['x', 'y', 'z'].map(a => axisRow('rot', a)).join('') +
            '<div class="hook-tune-footer">' +
            '<button class="hook-tune-btn" data-act="copy">Copy</button>' +
            '<button class="hook-tune-btn hook-tune-close" data-act="close">Close</button>' +
            '</div>';

        hookTuneHud.querySelectorAll('[data-step]').forEach(el => {
            el.onclick = () => {
                hookTuneState.stepIdx = parseInt(el.dataset.step, 10);
                renderHookTune();
            };
        });
        hookTuneHud.querySelectorAll('[data-adj]').forEach(el => {
            el.onclick = () => {
                const [kind, axis, sign] = el.dataset.adj.split('|');
                const s = HOOK_STEPS[hookTuneState.stepIdx] || 0.1;
                const delta = sign === '+' ? s : -s;
                post('hookTune:adjust', { kind, axis, delta });
            };
        });
        hookTuneHud.querySelectorAll('[data-set]').forEach(el => {
            el.addEventListener('change', () => {
                const [kind, axis] = el.dataset.set.split('|');
                const v = parseFloat(el.value);
                if (!isNaN(v)) post('hookTune:set', { kind, axis, value: v });
            });
        });
        hookTuneHud.querySelectorAll('[data-act]').forEach(el => {
            el.onclick = () => {
                if (el.dataset.act === 'copy') post('hookTune:copy');
                else if (el.dataset.act === 'close') post('hookTune:close');
            };
        });
    }

    function showHookTune() {
        buildHookTuneHud();
        renderHookTune();
        requestAnimationFrame(() => hookTuneHud.classList.add('hook-tune-visible'));
    }
    function hideHookTune() {
        if (!hookTuneHud) return;
        hookTuneHud.classList.remove('hook-tune-visible');
    }


    window.addEventListener('message', function (e) {
        const d = e.data || {};
        if (!d.action) return;

        switch (d.action) {
            case 'CRANE_OPEN':
                state.active = true;
                state.exportText = '';
                Object.assign(state, d.payload || {});
                render();
                break;
            case 'CRANE_UPDATE': {
                const p = Object.assign({}, d.payload || {});
                delete p.active;
                delete p.focused;
                Object.assign(state, p);
                render();
                break;
            }
            case 'CRANE_EXPORT_RESULT':
                state.exportText = d.text || '';
                render();
                break;
            case 'CRANE_CLOSE':
                state.active = false;
                state.focused = false;
                state.exportText = '';
                render();
                break;
            case 'CRANE_KEYS_SHOW':
                showKeysHud();
                break;
            case 'CRANE_KEYS_HIDE':
                hideKeysHud();
                break;
            case 'CRANEV2_KEYS_SHOW':
                showKeysHudV2();
                break;
            case 'CRANEV2_KEYS_HIDE':
                hideKeysHudV2();
                break;
            case 'HOOK_TUNE_SHOW':
                showHookTune();
                break;
            case 'HOOK_TUNE_HIDE':
                hideHookTune();
                break;
            case 'HOOK_TUNE_STATE':
                if (d.payload) {
                    hookTuneState.offset = d.payload.offset || hookTuneState.offset;
                    hookTuneState.rot    = d.payload.rot    || hookTuneState.rot;
                    renderHookTune();
                }
                break;
        }
    });

    document.addEventListener('keydown', function (e) {
        if (!state.active || !state.focused) return;
        if (e.key === 'Escape') post('crane:toggleFocus');
    });

    build();
})();
