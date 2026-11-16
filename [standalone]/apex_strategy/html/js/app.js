/*  apex_strategy, html/js/app.js
    ═══════════════════════════════════════════════════════════════
    O editor. Desenha no MESMO canvas lógico que o DUI da prop
    (1920 × altura do painel) e depois deixa o CSS encolher a coisa
    para caber no ecrã. É isso que garante que uma linha de 6 px aqui
    é uma linha de 6 px no quadro lá fora.

    Nada é escrito à bruta no documento local: manda-se a operação, o
    servidor valida e devolve-a. O que se vê enquanto se arrasta é um
    "fantasma" local, que desaparece quando a coisa a sério chega.
*/
(function () {
    'use strict';

    var $  = function (s, r) { return (r || document).querySelector(s); };
    var $$ = function (s, r) {
        return Array.prototype.slice.call((r || document).querySelectorAll(s));
    };

    /* O nome do resource vem do hostname (cfx-nui-<resource>). A
       versão anterior lia o pathname e devolvia sempre "html", o que
       só funcionava por o fallback estar certo por acaso, bastava
       renomear a pasta para nenhum callback chegar ao Lua. */
    var RES = (function () {
        if (typeof GetParentResourceName === 'function') {
            try { return GetParentResourceName(); } catch (e) { /* segue */ }
        }
        var h = window.location.hostname || '';
        if (h.indexOf('cfx-nui-') === 0) { return h.slice(8); }
        return 'apex_strategy';
    }());

    function post(name, data) {
        return fetch('https://' + RES + '/' + name, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify(data || {})
        }).then(function (r) { return r.json(); }).catch(function () { return null; });
    }

    function toast(msg, kind) {
        var el = document.createElement('div');
        el.className = 'toast' + (kind ? ' ' + kind : '');
        el.textContent = msg;
        $('#toast').appendChild(el);
        setTimeout(function () { el.remove(); }, 2600);
    }

    /* ── Traduções ──────────────────────────────────────────────
       A tabela vem do Lua já resolvida (língua escolhida por cima do
       inglês), por isso aqui nunca falta uma chave. T() devolve a
       própria chave se faltar, para se ver logo o que ficou por
       traduzir em vez de aparecer um espaço em branco. */
    var I18N = {};

    function T(key) {
        var s = I18N[key];
        if (s === undefined) { return key; }
        for (var i = 1; i < arguments.length; i++) {
            s = s.replace(/%[sd]/, arguments[i]);
        }
        return s;
    }

    /* Onde é que cada frase fixa da interface vive. Manter isto aqui,
       em vez de encher o HTML de atributos, deixa o HTML legível e a
       lista de chaves toda num sítio só. */
    var STATIC = [
        ['.eyebrow', 'ui_eyebrow'],
        ['[data-mode="draw"]', 'ui_mode_draw'],
        ['[data-mode="map"]', 'ui_mode_map'],
        ['#bg-group .glabel', 'ui_bg'],
        ['[data-bg="white"]', 'ui_bg_white'],
        ['[data-bg="grid"]', 'ui_bg_grid'],
        ['[data-bg="dark"]', 'ui_bg_dark'],
        ['#map-group .glabel', 'ui_zone'],
        ['#preset .dd-label', 'ui_frame_it'],
        ['#btn-here', 'ui_here'],
        ['#btn-wp', 'ui_waypoint'],
        ['#btn-rename', 'ui_rename'],
        ['#btn-clear', 'ui_clear'],
        ['#sec-width h4', 'ui_width'],
        ['#sec-text h4', 'ui_text_size'],
        ['#sec-icons h4', 'ui_markers'],
        ['#sec-select h4', 'ui_selected'],
        ['#sec-units h4', 'ui_live_units'],
        ['#sec-admin h4', 'ui_admin'],
        ['#btn-front', 'ui_front'],
        ['#btn-back', 'ui_back'],
        ['#btn-dup', 'ui_duplicate'],
        ['#btn-new', 'ui_new_board'],
        ['#btn-delboard', 'ui_delete_board'],
        ['#modal-cancel', 'ui_cancel'],
        ['[data-tool="select"] em', 'tool_select'],
        ['[data-tool="pen"] em', 'tool_pen'],
        ['[data-tool="line"] em', 'tool_line'],
        ['[data-tool="arrow"] em', 'tool_arrow'],
        ['[data-tool="rect"] em', 'tool_rect'],
        ['[data-tool="ellipse"] em', 'tool_ellipse'],
        ['[data-tool="text"] em', 'tool_text'],
        ['[data-tool="icon"] em', 'tool_icon'],
        ['[data-tool="ruler"] em', 'tool_ruler'],
        ['[data-tool="erase"] em', 'tool_erase'],
        ['[data-tool="pan"] em', 'tool_pan'],
        ['[data-tool="area"] em', 'tool_area']
    ];

    function applyI18n() {
        STATIC.forEach(function (pair) {
            var el = $(pair[0]);
            if (el) { el.textContent = T(pair[1]); }
        });
        /* Os que levam a tecla ao lado mantêm o <kbd>. */
        var kb = [['#btn-undo', 'ui_undo', 'Ctrl+Z'], ['#btn-close', 'ui_close', 'ESC'],
                  ['#btn-del', 'ui_delete', 'DEL']];
        kb.forEach(function (k) {
            var el = $(k[0]);
            if (el) { el.innerHTML = T(k[1]) + ' <kbd>' + k[2] + '</kbd>'; }
        });
        $('#preset').dataset.placeholder = T('ui_frame_it');
        $('#readonly').textContent = T('err_no_job');
        $('#locked').textContent = T('err_locked');
        $('#sel-info').textContent = T('ui_sel_none');
        $('#icon-label').placeholder = T('ui_marker_label_ph');
        $('#sec-icons .field span').textContent = T('ui_marker_label');
        $('#text-outline').parentNode.querySelector('span').textContent = T('ui_text_outline');
        $('#sec-text .muted').textContent = T('ui_text_outline_hint');
        $('#units-on').parentNode.querySelector('span').textContent = T('ui_show_on_map');
        $('#btn-lock').title = T('ui_lock_hint');
        $('#sec-admin .muted').innerHTML =
            T('ui_also_commands', '<code>/wb</code>', '<code>/wbdel</code>');

        var sc = [['ui_sc_move'], ['ui_sc_tools'], ['ui_sc_delete'], ['ui_sc_undo'],
                  ['ui_sc_duplicate'], ['ui_sc_order'], ['ui_sc_wheel'],
                  ['ui_sc_space'], ['ui_sc_close']];
        $$('.keys li span').forEach(function (el, i) {
            if (sc[i]) { el.textContent = T(sc[i][0]); }
        });
        $('.panel section:last-of-type h4').textContent = T('ui_shortcuts');
    }

    /* ── Caixa de diálogo ───────────────────────────────────────
       Substitui o window.confirm/prompt, que no CEF abre uma janela
       do browser com o endereço cfx-nui-... no topo. Devolve uma
       promessa: null se cancelar, true (ou o texto escrito) se
       confirmar. */
    var Modal = (function () {
        var el, title, text, input, ok, cancel, resolver;

        function bind() {
            if (el) { return; }
            el = $('#modal'); title = $('#modal-title'); text = $('#modal-text');
            input = $('#modal-input'); ok = $('#modal-ok'); cancel = $('#modal-cancel');

            ok.addEventListener('click', function () { finish(true); });
            cancel.addEventListener('click', function () { finish(false); });
            el.addEventListener('mousedown', function (ev) {
                if (ev.target === el) { finish(false); }
            });
            input.addEventListener('keydown', function (ev) {
                ev.stopPropagation();
                if (ev.key === 'Enter') { finish(true); }
                else if (ev.key === 'Escape') { finish(false); }
            });
        }

        function finish(confirmed) {
            if (!resolver) { return; }
            var r = resolver; resolver = null;
            var value = input.hidden ? true : input.value.trim();
            el.hidden = true;
            r(confirmed ? (input.hidden ? true : (value || null)) : null);
        }

        return {
            isOpen: function () { return el && !el.hidden; },
            close: function () { finish(false); },
            ask: function (opts) {
                bind();
                title.textContent = opts.title || '';
                text.textContent = opts.text || '';
                text.hidden = !opts.text;
                input.hidden = opts.input === undefined;
                if (!input.hidden) { input.value = opts.input || ''; }
                ok.textContent = opts.ok || 'Confirmar';
                ok.classList.toggle('danger', !!opts.danger);
                el.hidden = false;
                if (!input.hidden) { setTimeout(function () { input.focus(); input.select(); }, 20); }
                return new Promise(function (res) { resolver = res; });
            }
        };
    }());

    /* ── Estado ────────────────────────────────────────────── */
    var S = {
        open: false, board: null, doc: null, write: false, boss: false,
        me: null, cfg: null, iconMeta: {},
        tool: 'pen', color: null, width: null, textSize: null, icon: null,
        textOutline: false, locked: false,
        drag: null, spacePan: false, unitsOn: true, unitsTimer: null,
        myOps: {}
    };

    /* ── O bilhete ──────────────────────────────────────────────
       Cada operação que eu mando leva um bilhete único. O servidor
       devolve-o na difusão, e é assim que eu reconheço o meu próprio
       eco e o ignoro, já pintei aquilo localmente.

       Sem isto, tudo o que eu fazia era aplicado DUAS vezes: os
       traços apareciam a dobrar, apagar um levava os dois, e mover
       deslocava só uma das cópias. Era isso o "está tudo bugado". */
    var CID = 'c' + Math.random().toString(36).slice(2, 8);
    var opSeq = 0;
    var itemSeq = 0;

    function newTok() { return CID + '_' + (++opSeq); }
    function newItemId() { return CID + 'i' + (++itemSeq); }

    var canvas = $('#board');
    var frame  = $('#frame');
    var R = new BoardRenderer(canvas, {});

    /* ── Tamanho ───────────────────────────────────────────── */
    function fitFrame() {
        if (!canvas.width) { return; }
        var stage = $('#stage');
        var pad = 40;
        var availW = stage.clientWidth - pad;
        var availH = stage.clientHeight - pad - 30;
        var scale = Math.min(availW / canvas.width, availH / canvas.height);
        if (!isFinite(scale) || scale <= 0) { scale = 0.5; }
        frame.style.width  = Math.floor(canvas.width * scale) + 'px';
        frame.style.height = Math.floor(canvas.height * scale) + 'px';
        canvas.style.width  = '100%';
        canvas.style.height = '100%';
    }
    window.addEventListener('resize', fitFrame);

    /* CSS px → px do canvas. */
    function toCanvasPx(ev) {
        var r = canvas.getBoundingClientRect();
        return {
            x: (ev.clientX - r.left) * (canvas.width / r.width),
            y: (ev.clientY - r.top) * (canvas.height / r.height)
        };
    }

    /* ── Interface ─────────────────────────────────────────── */
    function buildPalette() {
        var c = S.cfg;

        $('#colors').innerHTML = c.colors.map(function (col, i) {
            return '<div class="swatch' + (i === 0 ? ' is-on' : '') +
                   '" data-color="' + col + '" style="background:' + col + '"></div>';
        }).join('');
        S.color = c.colors[0];

        $('#widths').innerHTML = c.widths.map(function (w, i) {
            return '<button class="wbtn' + (i === 1 ? ' is-on' : '') + '" data-width="' + w + '">' +
                   '<i style="height:' + Math.max(2, Math.round(w / 2)) + 'px"></i>' + w + '</button>';
        }).join('');
        S.width = c.widths[Math.min(1, c.widths.length - 1)];

        $('#sizes').innerHTML = c.textSizes.map(function (s, i) {
            var names = [T('ui_size_small'), T('ui_size_normal'),
                         T('ui_size_big'), T('ui_size_huge')];
            return '<button class="sbtn' + (i === 1 ? ' is-on' : '') + '" data-size="' + s + '">' +
                   (names[i] || s) + '</button>';
        }).join('');
        S.textSize = c.textSizes[Math.min(1, c.textSizes.length - 1)];

        /* Marcadores agrupados por categoria, cada um desenhado com o
           MESMO código do quadro, o que se escolhe é o que sai. */
        var byCat = [];
        var seen = {};
        c.icons.forEach(function (ic) {
            var cat = ic.cat || 'Outros';
            if (!seen[cat]) { seen[cat] = { cat: cat, items: [] }; byCat.push(seen[cat]); }
            seen[cat].items.push(ic);
        });
        $('#icons').innerHTML = byCat.map(function (g) {
            return '<div class="igroup"><h5>' + g.cat + '</h5><div class="igrid">' +
                g.items.map(function (ic) {
                    return '<button class="ibtn" data-icon="' + ic.id + '" title="' + ic.label +
                           '"><canvas width="72" height="72"></canvas></button>';
                }).join('') + '</div></div>';
        }).join('');
        S.iconMeta = {};
        c.icons.forEach(function (ic) { S.iconMeta[ic.id] = ic; });
        $$('#icons .ibtn').forEach(function (b) {
            BoardRenderer.iconPreview(b.querySelector('canvas'), S.iconMeta[b.dataset.icon]);
        });
        S.icon = c.icons[0] && c.icons[0].id;
        var first = $('#icons .ibtn');
        if (first) { first.classList.add('is-on'); }

        Dropdown.fill($('#preset'), (c.map.presets || []).map(function (p) {
            return { value: p.id, label: p.label };
        }));
    }

    /* ── Dropdown ───────────────────────────────────────────────
       Lista em HTML, para se poder dar-lhe o aspecto do resto. Só um
       fica aberto de cada vez e um clique fora fecha-o. */
    var Dropdown = {
        fill: function (root, items) {
            var list = root.querySelector('.dd-list');
            list.innerHTML = items.map(function (i) {
                return '<button type="button" class="dd-item" data-value="' +
                       i.value + '">' + i.label + '</button>';
            }).join('');
            root.dataset.value = '';
            Dropdown.close(root);
        },
        open: function (root) {
            Dropdown.closeAll();
            root.classList.add('is-open');
            root.querySelector('.dd-list').hidden = false;
        },
        close: function (root) {
            root.classList.remove('is-open');
            var l = root.querySelector('.dd-list');
            if (l) { l.hidden = true; }
        },
        closeAll: function () {
            $$('.dd').forEach(Dropdown.close);
        },
        select: function (root, value, label) {
            root.dataset.value = value || '';
            root.querySelector('.dd-label').textContent =
                label || root.dataset.placeholder || '';
            $$('.dd-item', root).forEach(function (b) {
                b.classList.toggle('is-on', b.dataset.value === value);
            });
        }
    };

    document.addEventListener('click', function (ev) {
        var item = ev.target.closest('.dd-item');
        if (item) {
            var root = item.closest('.dd');
            Dropdown.select(root, item.dataset.value, item.textContent);
            Dropdown.close(root);
            root.dispatchEvent(new CustomEvent('pick', {
                detail: { value: item.dataset.value }
            }));
            return;
        }
        var btn = ev.target.closest('.dd-btn');
        if (btn) {
            var dd = btn.closest('.dd');
            if (dd.classList.contains('is-open')) { Dropdown.close(dd); }
            else { Dropdown.open(dd); }
            return;
        }
        Dropdown.closeAll();
    });

    function setTool(tool) {
        /* Antes isto era um `return` mudo: sem serviço, metade da
           barra não reagia e não havia forma de perceber porquê. */
        if (!S.write && tool !== 'pan' && tool !== 'area' && tool !== 'select') {
            toast(T('err_no_job'), 'error');
            return;
        }
        S.tool = tool;
        if (tool !== 'select') { R.selectedId = null; R.dirty = true; }
        $$('.tool').forEach(function (b) { b.classList.toggle('is-on', b.dataset.tool === tool); });
        frame.className = 'frame tool-' + tool + (S.write ? '' : ' readonly');

        $('#sec-width').hidden  = ['text', 'icon', 'pan', 'area', 'select'].indexOf(tool) >= 0;
        $('#sec-text').hidden   = tool !== 'text';
        $('#sec-icons').hidden  = tool !== 'icon';
        $('#sec-select').hidden = tool !== 'select';
        if (tool === 'select') { updateSelInfo(); }

        var hints = {
            select: T('tip_select'), pen: T('tip_pen'), line: T('tip_line'),
            arrow: T('tip_arrow'), rect: T('tip_rect'), ellipse: T('tip_ellipse'),
            text: T('tip_text'), icon: T('tip_icon'), ruler: T('tip_ruler'),
            erase: T('tip_erase'), pan: T('tip_pan'), area: T('tip_area')
        };
        showHint(hints[tool] || '');
    }

    /* Contador de desenhos. O tecto do servidor existe, e sem isto à
       vista o quadro enchia-se sem aviso e cada traço novo era
       recusado, parecia que "desaparecia sozinho". */
    function updateCount() {
        var el = $('#count');
        if (!el || !S.cfg) { return; }
        var layer = R.layer();
        var n = layer ? layer.items.length : 0;
        var max = S.cfg.maxItems || 600;
        el.textContent = T('ui_count', n, max);
        el.style.color = n >= max ? '#E5564B' : (n > max * 0.85 ? '#E5A93C' : '');
    }

    /* Próximo número livre da sequência de passos. */
    function nextStepNumber() {
        var layer = R.layer();
        if (!layer) { return 1; }
        var max = 0;
        layer.items.forEach(function (it) {
            if (it.t !== 'icon') { return; }
            var m = S.iconMeta[it.k];
            if (!m || m.pic !== 'number') { return; }
            var n = parseInt(it.v, 10);
            if (n > max) { max = n; }
        });
        return max + 1;
    }

    function updateSelInfo() {
        var el = $('#sel-info');
        if (!el) { return; }
        var it = R.selectedId && R.findItem(R.selectedId);
        if (!it) {
            el.textContent = 'Clica num desenho para o agarrar.';
            $('#btn-del').disabled = true;
            return;
        }
        var names = { stroke: T('item_stroke'), line: T('item_line'), arrow: T('item_arrow'),
                      rect: T('item_rect'), ellipse: T('item_ellipse'), text: T('item_text'),
                      icon: T('item_icon'), ruler: T('item_ruler') };
        var who = it.an ? (' · ' + it.an) : '';
        el.textContent = (names[it.t] || it.t) + (it.v ? ' “' + it.v + '”' : '') + who;
        $('#btn-del').disabled = false;
    }

    var hintTimer;
    function showHint(text) {
        var el = $('#hint');
        if (!text) { el.classList.remove('on'); return; }
        el.textContent = text;
        el.classList.add('on');
        clearTimeout(hintTimer);
        hintTimer = setTimeout(function () { el.classList.remove('on'); }, 3200);
    }

    function syncModeUi() {
        var isMap = R.isMap();
        $$('.mode').forEach(function (b) { b.classList.toggle('is-on', (b.dataset.mode === 'map') === isMap); });
        $('#bg-group').hidden  = isMap;
        $('#map-group').hidden = !isMap;
        $('#sec-units').hidden = !isMap;
        $$('[data-map-only]').forEach(function (el) { el.hidden = !isMap; });

        if (!isMap && (S.tool === 'pan' || S.tool === 'area')) {
            setTool(S.write ? 'pen' : 'select');
        }

        var bg = (S.doc && S.doc.draw.bg) || 'white';
        $$('[data-bg]').forEach(function (b) { b.classList.toggle('is-on', b.dataset.bg === bg); });

        if (isMap) { $('#zoomval').textContent = R.view().zoom.toFixed(1); }
        startUnits();
    }

    /* ── Operações ─────────────────────────────────────────── */
    function mode() { return R.isMap() ? 'map' : 'draw'; }

    /* Porque é que o servidor recusou. Isto tem de aparecer AQUI, no
       editor: com o rato preso à NUI, um aviso do jogo passa
       despercebido e o desenho parecia desaparecer sem razão. */
    var ERR = {
        no_board:   'Esse quadro já não existe.',
        too_far:    'Estás longe demais do quadro.',
        no_job:     'Não tens serviço para escrever neste quadro.',
        not_boss:   'Só um superior pode fazer isso.',
        board_full: 'Quadro cheio, apaga alguma coisa (botão Limpar) antes de continuar.',
        not_yours:  'Isso foi escrito por outra pessoa. Só um superior lhe pode mexer.',
        no_item:    'Esse desenho já não existe.',
        bad_item:   'O servidor não aceitou este desenho.',
        bad_delta:  'Deslocamento inválido.',
        bad_scale:  'Tamanho inválido.',
        out_of_bounds: 'Isso sai fora do quadro.',
        rate_limited:  'Devagar, demasiadas alterações de uma vez.',
        timeout:    'O servidor não respondeu.',
        closed:     'O quadro foi fechado.',
        unknown:    'Operação desconhecida (o resource está desactualizado?).'
    };

    /* keepEcho = "não apliquei isto localmente, deixa a difusão
       entrar". O bilhete só se guarda para operações que o editor JÁ
       pintou; guardá-lo em todas engolia a resposta de coisas que
       ninguém tinha aplicado, e a alteração só se via ao reabrir. */
    function send(name, data, keepEcho) {
        data = data || {};
        data.tok = newTok();
        if (!keepEcho) {
            S.myOps[data.tok] = true;
            /* Se a resposta se perder, o bilhete ficava lá para sempre. */
            setTimeout(function () { delete S.myOps[data.tok]; }, 30000);
        }
        return post(name, data).then(function (res) {
            if (res && res.data) { return res.data; }
            var why = res && res.error;
            toast(ERR[why] || ('Recusado: ' + (why || 'sem resposta do cliente')), 'error');
            return null;
        });
    }

    /* O desenho aparece JÁ, com um id provisório, e só depois é que o
       servidor confirma. Antes esperava-se pela resposta: o fantasma
       do arrasto era apagado, o item ainda não existia, e a seta
       "desaparecia" durante a ida e volta. Se o servidor recusar, o
       item é retirado e diz-se porquê. */
    /* O id é escolhido AQUI, não pelo servidor: assim a difusão que
       volta traz o mesmo id, a verificação de duplicado apanha-o, e
       não é preciso andar a renomear nada a meio. */
    function addItem(item) {
        if (!S.write) {
            toast(T('err_no_job'), 'error');
            return Promise.resolve(null);
        }
        var m = mode();
        item.id = newItemId();
        /* ⚠️ `au`/`an`, nunca `by`/`bn`: nas formas, `by` é a
           coordenada Y do segundo ponto. Marcar aqui o autor num
           campo com esse nome esmagava a geometria com a string 'me'
           e o servidor recusava a linha inteira. */
        item.au = 'me';
        item.an = S.me && S.me.name;
        R.applyOp({ mode: m, op: 'add', item: item });
        updateCount();

        return send('add', { mode: m, item: item }).then(function (res) {
            if (!res || !res.id) {
                R.applyOp({ mode: m, op: 'erase', ids: [item.id] });
                return null;
            }
            if (res.id !== item.id) {
                /* O servidor recusou o meu id (repetido) e deu outro. */
                var live = R.findItem(item.id);
                if (live) { live.id = res.id; R.dirty = true; }
                if (R.selectedId === item.id) { R.selectedId = res.id; }
            }
            return res;
        });
    }

    /* Apagar também é optimista: sai do ecrã já, e volta se o servidor
       recusar (não é teu, por exemplo). */
    function eraseItems(ids) {
        if (!ids.length || !S.write) { return; }
        var m = mode();
        var backup = ids.map(function (id) {
            var it = R.findItem(id);
            return it ? JSON.parse(JSON.stringify(it)) : null;
        }).filter(Boolean);

        R.applyOp({ mode: m, op: 'erase', ids: ids });
        updateCount();
        if (R.selectedId && ids.indexOf(R.selectedId) >= 0) {
            R.selectedId = null;
            updateSelInfo();
        }

        send('erase', { mode: m, ids: ids }).then(function (res) {
            if (res) { return; }
            backup.forEach(function (it) {
                R.applyOp({ mode: m, op: 'add', item: it });
            });
        });
    }

    var viewTimer = null;
    function pushView() {
        clearTimeout(viewTimer);
        viewTimer = setTimeout(function () {
            var v = R.view();
            send('view', { cx: v.cx, cy: v.cy, zoom: v.zoom });
        }, 220);
    }

    function setView(cx, cy, zoom) {
        var v = R.view();
        var m = S.cfg.map;
        S.doc.map.view = {
            cx: cx !== undefined ? cx : v.cx,
            cy: cy !== undefined ? cy : v.cy,
            zoom: Math.max(m.minZoom, Math.min(m.maxZoom, zoom !== undefined ? zoom : v.zoom))
        };
        R.dirty = true;
        $('#zoomval').textContent = S.doc.map.view.zoom.toFixed(1);
        pushView();
    }

    /* ── Pegas de redimensionar ─────────────────────────────────
       Os 4 cantos da caixa do item seleccionado. Devolve a pega
       apanhada e o canto OPOSTO (ox/oy), que é o ponto que fica
       quieto enquanto se estica. */
    function handleAt(p) {
        if (!R.selectedId) { return null; }
        var it = R.findItem(R.selectedId);
        if (!it) { return null; }
        var b = R.itemBounds(it);
        /* Em px do canvas. O canvas aparece encolhido a ~0.65, por
           isso 22 aqui são uns 14 px reais no ecrã, que é o mínimo
           para se acertar na pega sem paciência. */
        var grab = 22 * R.unit();
        var corners = [
            { x: b.x,         y: b.y,         ox: b.x + b.w, oy: b.y + b.h },
            { x: b.x + b.w,   y: b.y,         ox: b.x,       oy: b.y + b.h },
            { x: b.x,         y: b.y + b.h,   ox: b.x + b.w, oy: b.y },
            { x: b.x + b.w,   y: b.y + b.h,   ox: b.x,       oy: b.y }
        ];
        for (var i = 0; i < corners.length; i++) {
            var c = corners[i];
            if (Math.abs(p.x - c.x) <= grab && Math.abs(p.y - c.y) <= grab) { return c; }
        }
        return null;
    }

    /* ── Rato no quadro ────────────────────────────────────── */
    function beginDrag(ev) {
        if (!S.doc) { return; }
        var p = toCanvasPx(ev);
        var tool = (S.spacePan && R.isMap()) ? 'pan' : S.tool;

        if (tool === 'pan') {
            S.drag = { tool: 'pan', sx: p.x, sy: p.y, v0: Object.assign({}, R.view()) };
            frame.classList.add('dragging');
            return;
        }
        if (tool === 'area') {
            S.drag = { tool: 'area', sx: p.x, sy: p.y };
            return;
        }

        /* Seleccionar, arrastar e redimensionar. Funciona mesmo sem
           poder escrever (aí só selecciona; o servidor recusa o resto). */
        if (tool === 'select') {
            /* Primeiro as pegas do que já está seleccionado: estão por
               cima e têm prioridade sobre o que esteja por baixo. */
            var h = handleAt(p);
            if (h && S.write) {
                var it0 = R.findItem(R.selectedId);
                S.drag = {
                    tool: 'resize', id: R.selectedId,
                    orig: JSON.parse(JSON.stringify(it0)),
                    origin: R.fromCanvas(h.ox, h.oy),
                    start: R.fromCanvas(p.x, p.y),
                    uniform: (it0.t === 'text' || it0.t === 'icon')
                };
                return;
            }

            var hit = R.hitTest(p.x, p.y)[0] || null;
            R.selectedId = hit;
            R.dirty = true;
            updateSelInfo();
            if (hit && S.write) {
                S.drag = { tool: 'select', id: hit, sx: p.x, sy: p.y,
                           from: R.fromCanvas(p.x, p.y), moved: false };
            }
            return;
        }

        if (!S.write) { return; }

        if (tool === 'text') { openTextBox(p, ev); return; }

        if (tool === 'icon') {
            var d = R.fromCanvas(p.x, p.y);
            var meta = S.iconMeta[S.icon] || {};
            var label = ($('#icon-label').value || '').trim();
            /* Os passos numeram-se sozinhos: conta os que já lá estão
               e segue a partir daí. */
            if (meta.pic === 'number') { label = String(nextStepNumber()); }
            addItem({ t: 'icon', k: S.icon, x: d.x, y: d.y, c: S.color, v: label || undefined });
            return;
        }

        if (tool === 'erase') {
            S.drag = { tool: 'erase', ids: {} };
            collectErase(p);
            return;
        }

        var doc0 = R.fromCanvas(p.x, p.y);
        if (tool === 'pen') {
            S.drag = { tool: 'pen', pts: [doc0.x, doc0.y], last: p };
            R.ghost = { t: 'stroke', c: S.color, w: S.width, p: S.drag.pts };
        } else {
            S.drag = { tool: tool, a: doc0, fill: ev.shiftKey };
            R.ghost = {
                t: tool, c: S.color, w: S.width,
                ax: doc0.x, ay: doc0.y, bx: doc0.x, by: doc0.y, fill: ev.shiftKey
            };
        }
        R.dirty = true;
    }

    function collectErase(p) {
        var hits = R.hitTest(p.x, p.y);
        hits.forEach(function (id) { S.drag.ids[id] = true; });
    }

    function moveDrag(ev) {
        if (!S.drag) { return; }
        var p = toCanvasPx(ev);

        if (S.drag.tool === 'pan') {
            var m = S.cfg.map;
            var s = Math.pow(2, S.drag.v0.zoom);
            var dx = (p.x - S.drag.sx) / (s * m.scaleX);
            var dy = (p.y - S.drag.sy) / (s * m.scaleY);
            setView(S.drag.v0.cx - dx, S.drag.v0.cy - dy);
            return;
        }

        if (S.drag.tool === 'area') {
            S.drag.ex = p.x; S.drag.ey = p.y;
            R.selection = {
                x: Math.min(S.drag.sx, p.x), y: Math.min(S.drag.sy, p.y),
                w: Math.abs(p.x - S.drag.sx), h: Math.abs(p.y - S.drag.sy)
            };
            R.dirty = true;
            return;
        }

        if (S.drag.tool === 'resize') {
            var d = S.drag;
            var cur = R.fromCanvas(p.x, p.y);
            var denX = d.start.x - d.origin.x;
            var denY = d.start.y - d.origin.y;
            /* Cantos degenerados (item sem largura ou sem altura)
               dariam divisão por zero, nesses o eixo fica a 1. */
            var fx = Math.abs(denX) > 1e-9 ? (cur.x - d.origin.x) / denX : 1;
            var fy = Math.abs(denY) > 1e-9 ? (cur.y - d.origin.y) / denY : 1;
            fx = Math.max(0.05, Math.min(20, Math.abs(fx)));
            fy = Math.max(0.05, Math.min(20, Math.abs(fy)));
            if (d.uniform || ev.shiftKey) { fx = fy = (fx + fy) / 2; }
            d.fx = fx; d.fy = fy;

            var it = R.findItem(d.id);
            if (it) {
                BoardRenderer.scaleFrom(it, d.orig, fx, fy, d.origin.x, d.origin.y);
                R.dirty = true;
            }
            return;
        }

        if (S.drag.tool === 'select') {
            /* Move-se já no documento local para o arrasto ser
               instantâneo; o servidor confirma no fim. */
            var now = R.fromCanvas(p.x, p.y);
            var dx = now.x - S.drag.from.x, dy = now.y - S.drag.from.y;
            if (!S.drag.moved && Math.hypot(p.x - S.drag.sx, p.y - S.drag.sy) < 3) { return; }
            S.drag.moved = true;
            S.drag.from = now;
            S.drag.dx = (S.drag.dx || 0) + dx;
            S.drag.dy = (S.drag.dy || 0) + dy;
            var it = R.findItem(S.drag.id);
            if (it) { BoardRenderer.shift(it, dx, dy); R.dirty = true; }
            return;
        }

        if (S.drag.tool === 'erase') { collectErase(p); return; }

        if (S.drag.tool === 'pen') {
            /* Um ponto por cada 3 px chega para a linha sair suave e
               poupa muito tamanho na mensagem e na base de dados. */
            if (Math.hypot(p.x - S.drag.last.x, p.y - S.drag.last.y) < 3) { return; }
            S.drag.last = p;
            var max = (S.cfg.maxPoints || 400) * 2;
            if (S.drag.pts.length < max) {
                var d = R.fromCanvas(p.x, p.y);
                S.drag.pts.push(d.x, d.y);
            }
            R.dirty = true;
            return;
        }

        var q = p;
        /* Nas linhas e setas, o Shift prende o ângulo a múltiplos de
           45°, é o que dá para traçar eixos e vectores direitos sem
           andar a apurar o pulso. */
        if (ev.shiftKey && (S.drag.tool === 'line' || S.drag.tool === 'arrow')) {
            var a0 = R.toCanvas(R.ghost.ax, R.ghost.ay);
            var dxp = p.x - a0.x, dyp = p.y - a0.y;
            var len = Math.hypot(dxp, dyp);
            var snap = Math.round(Math.atan2(dyp, dxp) / (Math.PI / 4)) * (Math.PI / 4);
            q = { x: a0.x + Math.cos(snap) * len, y: a0.y + Math.sin(snap) * len };
        }
        var db = R.fromCanvas(q.x, q.y);
        R.ghost.bx = db.x; R.ghost.by = db.y;
        if (S.drag.tool === 'rect' || S.drag.tool === 'ellipse') {
            R.ghost.fill = ev.shiftKey;
        }
        R.dirty = true;
    }

    /* Anel do pincel a seguir o rato. */
    canvas.addEventListener('mousemove', function (ev) {
        if (!S.open) { return; }
        /* Só onde a grossura é a informação que falta: no marcador e
           na borracha. Nas formas já se vê o desenho a nascer, e o
           anel parado no fim do arrasto passava por conteúdo. */
        var showFor = ['pen', 'erase'];
        if (showFor.indexOf(S.tool) < 0 || !S.write || S.drag) {
            if (R.cursor) { R.cursor = null; R.dirty = true; }
            return;
        }
        var p = toCanvasPx(ev);
        R.cursor = {
            x: p.x, y: p.y,
            w: S.tool === 'erase' ? 36 : S.width,
            color: S.tool === 'erase' ? '#E5564B' : S.color
        };
        R.dirty = true;
    });
    canvas.addEventListener('mouseleave', function () {
        if (R.cursor) { R.cursor = null; R.dirty = true; }
    });

    function endDrag(ev) {
        if (!S.drag) { return; }
        var d = S.drag;
        S.drag = null;
        frame.classList.remove('dragging');

        if (d.tool === 'pan') { return; }

        if (d.tool === 'area') {
            R.selection = null; R.dirty = true;
            if (d.ex === undefined || Math.abs(d.ex - d.sx) < 12 || Math.abs(d.ey - d.sy) < 12) {
                showHint('Arrasta um rectângulo maior para enquadrar.');
                return;
            }
            /* Enquadrar = mudar o que o quadro MOSTRA. O tamanho do
               ecrã na prop nunca muda, muda só a janela do mapa. */
            var w1 = R.canvasToWorld(d.sx, d.sy);
            var w2 = R.canvasToWorld(d.ex, d.ey);
            var z = R.zoomToFit(w1.x, w1.y, w2.x, w2.y);
            setView((w1.x + w2.x) / 2, (w1.y + w2.y) / 2, z);
            showHint('Enquadrado. O quadro mostra agora só esta zona.');
            return;
        }

        if (d.tool === 'resize') {
            if (!d.fx || (Math.abs(d.fx - 1) < 1e-4 && Math.abs(d.fy - 1) < 1e-4)) { return; }
            send('scale', { mode: mode(), itemId: d.id,
                            fx: d.fx, fy: d.fy, ox: d.origin.x, oy: d.origin.y })
                .then(function (res) {
                    if (res) { updateSelInfo(); return; }
                    /* Recusado: repõe o tamanho de origem. */
                    var it = R.findItem(d.id);
                    if (it) {
                        BoardRenderer.scaleFrom(it, d.orig, 1, 1, d.origin.x, d.origin.y);
                        R.dirty = true;
                    }
                });
            return;
        }

        if (d.tool === 'select') {
            if (!d.moved || (!d.dx && !d.dy)) { return; }
            /* O item já está no sítio novo aqui; o eco do servidor é
               ignorado pelo bilhete. Se recusar, volta para trás. */
            send('move', { mode: mode(), itemId: d.id, dx: d.dx, dy: d.dy })
                .then(function (res) {
                    if (res) { return; }
                    var it = R.findItem(d.id);
                    if (it) { BoardRenderer.shift(it, -d.dx, -d.dy); R.dirty = true; }
                    updateSelInfo();
                });
            return;
        }

        if (d.tool === 'erase') {
            eraseItems(Object.keys(d.ids));
            return;
        }

        var ghost = R.ghost;
        R.ghost = null; R.dirty = true;
        if (!ghost) { return; }

        if (d.tool === 'pen') {
            if (d.pts.length < 4) { return; }
            addItem({ t: 'stroke', c: S.color, w: S.width, p: d.pts });
            return;
        }

        /* Um clique sem arrastar não é uma forma. */
        var sameSpot = Math.abs(ghost.bx - ghost.ax) < 1e-6 && Math.abs(ghost.by - ghost.ay) < 1e-6;
        if (sameSpot) { return; }

        addItem({
            t: d.tool, c: S.color, w: S.width,
            ax: ghost.ax, ay: ghost.ay, bx: ghost.bx, by: ghost.by,
            fill: !!ghost.fill
        });
    }

    canvas.addEventListener('mousedown', function (ev) { ev.preventDefault(); beginDrag(ev); });
    window.addEventListener('mousemove', moveDrag);
    window.addEventListener('mouseup', endDrag);

    canvas.addEventListener('wheel', function (ev) {
        if (!R.isMap() || !S.doc) { return; }
        ev.preventDefault();
        var p = toCanvasPx(ev);
        var before = R.canvasToWorld(p.x, p.y);
        var step = ev.deltaY < 0 ? 0.35 : -0.35;
        var v = R.view();
        var m = S.cfg.map;
        var z = Math.max(m.minZoom, Math.min(m.maxZoom, v.zoom + step));

        /* Zoom para onde o rato está, não para o centro. */
        S.doc.map.view = { cx: v.cx, cy: v.cy, zoom: z };
        var after = R.canvasToWorld(p.x, p.y);
        setView(v.cx + (before.x - after.x), v.cy + (before.y - after.y), z);
    }, { passive: false });

    /* ── Caixa de texto ────────────────────────────────────── */
    var textAt = null;

    /* Escreve-se em cima do quadro, com a cor e o tamanho reais e sem
       fundo nenhum, o que se vê a escrever é exactamente o que fica. */
    function openTextBox(p, ev) {
        var box = $('#textbox'), input = $('#textinput');
        var r = canvas.getBoundingClientRect();
        var shown = r.width / canvas.width;      /* canvas px → CSS px */

        box.style.left = (ev.clientX - r.left) + 'px';
        box.style.top  = (ev.clientY - r.top) + 'px';
        input.style.fontSize = Math.max(11, S.textSize * shown) + 'px';
        input.style.color = S.color;
        input.style.width = '60px';
        box.hidden = false;
        input.value = '';
        textAt = R.fromCanvas(p.x, p.y);
        setTimeout(function () { input.focus(); }, 10);
    }

    function closeTextBox() {
        $('#textbox').hidden = true;
        textAt = null;
    }

    function commitText() {
        var input = $('#textinput');
        var v = input.value.trim();
        if (v && textAt) {
            addItem({ t: 'text', x: textAt.x, y: textAt.y, v: v,
                      c: S.color, s: S.textSize, o: S.textOutline });
        }
        closeTextBox();
    }

    $('#textinput').addEventListener('input', function () {
        /* Cresce com o que se escreve, senão o cursor foge da caixa. */
        this.style.width = Math.max(60, this.value.length * (parseFloat(this.style.fontSize) * 0.58) + 20) + 'px';
    });
    $('#textinput').addEventListener('keydown', function (ev) {
        ev.stopPropagation();
        if (ev.key === 'Enter') { commitText(); }
        else if (ev.key === 'Escape') { closeTextBox(); }
    });
    /* Clicar fora grava o que já lá está, em vez de deitar fora. */
    $('#textinput').addEventListener('blur', function () {
        if (!$('#textbox').hidden) { commitText(); }
    });

    /* ── Cliques na interface ──────────────────────────────── */
    document.addEventListener('click', function (ev) {
        var el;

        if ((el = ev.target.closest('.tool'))) { setTool(el.dataset.tool); return; }

        if ((el = ev.target.closest('.swatch'))) {
            S.color = el.dataset.color;
            $$('.swatch').forEach(function (s) { s.classList.toggle('is-on', s === el); });
            return;
        }
        if ((el = ev.target.closest('.wbtn'))) {
            S.width = Number(el.dataset.width);
            $$('.wbtn').forEach(function (s) { s.classList.toggle('is-on', s === el); });
            return;
        }
        if ((el = ev.target.closest('.sbtn'))) {
            S.textSize = Number(el.dataset.size);
            $$('.sbtn').forEach(function (s) { s.classList.toggle('is-on', s === el); });
            return;
        }
        if ((el = ev.target.closest('.ibtn'))) {
            S.icon = el.dataset.icon;
            $$('.ibtn').forEach(function (s) { s.classList.toggle('is-on', s === el); });
            return;
        }

        if ((el = ev.target.closest('.mode'))) {
            if (!S.write) { return toast('Não tens serviço para mudar o quadro.', 'error'); }
            setMode(el.dataset.mode);
            return;
        }
        if ((el = ev.target.closest('[data-bg]'))) {
            if (!S.write) { return; }
            setBg(el.dataset.bg);
            return;
        }

        if (ev.target.closest('#btn-close')) { close(); return; }
        if (ev.target.closest('#btn-undo'))  { undoMine(); return; }
        if (ev.target.closest('#btn-clear')) { doClear(); return; }
        if (ev.target.closest('#btn-front')) { reorder('front'); return; }
        if (ev.target.closest('#btn-back'))  { reorder('back'); return; }
        if (ev.target.closest('#btn-dup'))   { duplicateSel(); return; }
        if (ev.target.closest('#btn-lock'))  { toggleLock(); return; }
        if (ev.target.closest('#btn-rename')) { doRename(); return; }
        if (ev.target.closest('#btn-new'))   { post('newBoard'); return; }
        if (ev.target.closest('#btn-delboard')) {
            Modal.ask({
                title: T('dlg_delboard_title'),
                text: T('dlg_delboard_text',
                        (S.board && S.board.name) || T('dlg_no_name')),
                ok: T('dlg_delboard_ok'),
                danger: true
            }).then(function (yes) { if (yes) { post('deleteBoard'); } });
            return;
        }
        if (ev.target.closest('#btn-del')) {
            if (R.selectedId) {
                eraseItems([R.selectedId]);
                R.selectedId = null; R.dirty = true; updateSelInfo();
            }
            return;
        }
        if (ev.target.closest('#zoom-in'))  { setView(undefined, undefined, R.view().zoom + 0.4); return; }
        if (ev.target.closest('#zoom-out')) { setView(undefined, undefined, R.view().zoom - 0.4); return; }

        if (ev.target.closest('#btn-here')) {
            post('here').then(function (r) {
                if (r && r.ok) { setView(r.x, r.y, Math.max(R.view().zoom, 5.2)); }
            });
            return;
        }
        if (ev.target.closest('#btn-wp')) {
            post('waypoint').then(function (r) {
                if (r && r.ok) { setView(r.x, r.y, Math.max(R.view().zoom, 5.0)); }
                else { toast('Não tens waypoint no mapa.', 'error'); }
            });
            return;
        }
    });

    $('#preset').addEventListener('pick', function (ev) {
        var id = ev.detail.value;
        var p = (S.cfg.map.presets || []).filter(function (x) { return x.id === id; })[0];
        if (p) { setView(p.cx, p.cy, p.zoom); }
    });

    $('#text-outline').addEventListener('change', function () {
        S.textOutline = this.checked;
    });

    $('#units-on').addEventListener('change', function () {
        S.unitsOn = this.checked;
        if (!S.unitsOn) { R.setUnits([]); $('#units-count').textContent = '-'; }
        startUnits();
    });

    /* Modo e fundo mudam JÁ no editor e só depois se confirmam. São
       um campo cada um, por isso não há como o resultado local
       divergir do servidor. Se recusar, volta atrás. */
    function setMode(want) {
        var was = S.doc.mode;
        if (was === want) { return; }
        R.applyOp({ op: 'mode', mode: want });
        syncModeUi();
        updateCount();
        send('mode', { mode: want }).then(function (res) {
            if (res) { return; }
            R.applyOp({ op: 'mode', mode: was });
            syncModeUi();
            updateCount();
        });
    }

    function setBg(want) {
        var was = S.doc.draw.bg || 'white';
        if (was === want) { return; }
        R.applyOp({ mode: 'draw', op: 'bg', bg: want });
        syncModeUi();
        send('bg', { bg: want }).then(function (res) {
            if (res) { return; }
            R.applyOp({ mode: 'draw', op: 'bg', bg: was });
            syncModeUi();
        });
    }

    /* ── Acções sobre o seleccionado ───────────────────────── */
    function reorder(to) {
        if (!R.selectedId) { return showHint('Escolhe um desenho primeiro.'); }
        var id = R.selectedId, m = mode();
        R.applyOp({ mode: m, op: 'order', itemId: id, to: to });
        send('order', { mode: m, itemId: id, to: to }).then(function (res) {
            if (!res) {
                R.applyOp({ mode: m, op: 'order', itemId: id,
                            to: to === 'front' ? 'back' : 'front' });
            }
        });
    }

    function duplicateSel() {
        if (!R.selectedId) { return showHint('Escolhe um desenho primeiro.'); }
        var src = R.findItem(R.selectedId);
        if (!src) { return; }
        var copy = JSON.parse(JSON.stringify(src));
        delete copy.id; delete copy.au; delete copy.an;
        /* Desencostada da original, senão fica escondida por baixo. */
        var off = R.isMap() ? 25 : 0.03;
        BoardRenderer.shift(copy, off, off);
        addItem(copy).then(function (res) {
            if (res && res.id) {
                R.selectedId = res.id;
                R.dirty = true;
                updateSelInfo();
            }
        });
    }

    function toggleLock() {
        var want = !S.locked;
        send('lock', { locked: want }).then(function (res) {
            if (res) { setLocked(res.locked); }
        });
    }

    function setLocked(on) {
        S.locked = !!on;
        if (S.doc) { S.doc.locked = S.locked; }
        $('#btn-lock').textContent = S.locked ? T('ui_unlock') : T('ui_lock');
        $('#btn-lock').classList.toggle('ghost', !S.locked);
        $('#locked').hidden = !(S.locked && !S.boss);
    }

    function doRename() {
        Modal.ask({
            title: T('dlg_rename_title'),
            text: T('dlg_rename_text'),
            input: (S.board && S.board.name) || '',
            ok: T('ui_save')
        }).then(function (name) {
            if (!name || name === true) { return; }
            send('rename', { name: name }).then(function (res) {
                if (res) {
                    S.board.name = name;
                    $('#board-name').textContent = name;
                }
            });
        });
    }

    function doClear() {
        if (!S.write) { return; }
        Modal.ask({
            title: T('dlg_clear_title'),
            text: S.boss ? T('dlg_clear_boss') : T('dlg_clear_own'),
            ok: T('dlg_clear_ok'),
            danger: true
        }).then(function (yes) {
            if (!yes) { return; }
            /* Aqui NÃO se aplica localmente: quem decide o que sobra é
               o servidor (um agente normal só leva o que é dele, e o
               editor não sabe ao certo o que é dele de sessões
               antigas). Deixa-se a difusão fazer o trabalho. */
            send('clear', { mode: mode() }, true);
        });
    }

    /* ── Agentes ao vivo ───────────────────────────────────── */
    function startUnits() {
        clearInterval(S.unitsTimer);
        S.unitsTimer = null;
        if (!S.open || !R.isMap() || !S.unitsOn) { return; }
        var tick = function () {
            post('units').then(function (r) {
                if (!r || !r.ok) { return; }
                R.setUnits(r.units);
                $('#units-count').textContent = T('ui_units_count', r.units.length);
            });
        };
        tick();
        S.unitsTimer = setInterval(tick, 3000);
    }

    /* ── Teclado ───────────────────────────────────────────── */
    var TOOL_KEYS = { '1': 'pen', '2': 'line', '3': 'arrow', '4': 'rect', '5': 'ellipse',
                      '6': 'text', '7': 'icon', '9': 'ruler', '0': 'erase',
                      's': 'select', 'S': 'select',
                      'p': 'pan', 'P': 'pan', 'a': 'area', 'A': 'area' };

    document.addEventListener('keydown', function (ev) {
        if (!S.open) { return; }
        /* Com uma caixa de diálogo aberta, as teclas são dela. */
        if (Modal.isOpen()) {
            if (ev.key === 'Escape') { ev.preventDefault(); Modal.close(); }
            return;
        }
        /* Enquanto se escreve, o ESC é do campo de texto e não do
           editor, senão fechava tudo a meio de uma palavra. */
        if (!$('#textbox').hidden) { return; }
        if (ev.key === 'Escape') { close(); return; }

        if (ev.key === 'Delete' || ev.key === 'Backspace') {
            if (R.selectedId) {
                ev.preventDefault();
                eraseItems([R.selectedId]);
                R.selectedId = null;
                R.dirty = true;
                updateSelInfo();
            }
            return;
        }

        if (ev.key === ' ') { S.spacePan = true; ev.preventDefault(); return; }

        if (ev.ctrlKey && (ev.key === 'z' || ev.key === 'Z')) {
            ev.preventDefault();
            undoMine();
            return;
        }
        if (ev.ctrlKey && (ev.key === 'd' || ev.key === 'D')) {
            ev.preventDefault();
            duplicateSel();
            return;
        }
        if (ev.key === 'PageUp')   { ev.preventDefault(); reorder('front'); return; }
        if (ev.key === 'PageDown') { ev.preventDefault(); reorder('back');  return; }
        var t = TOOL_KEYS[ev.key];
        if (t) {
            if ((t === 'pan' || t === 'area') && !R.isMap()) { return; }
            setTool(t);
        }
    });
    document.addEventListener('keyup', function (ev) {
        if (ev.key === ' ') { S.spacePan = false; }
    });

    function undoMine() {
        var layer = R.layer();
        if (!layer) { return; }
        for (var i = layer.items.length - 1; i >= 0; i--) {
            /* 'me' é o que o editor marca no que acabou de mandar; o
               servidor devolve o identificador verdadeiro na difusão,
               por isso aceitam-se os dois. */
            if (layer.items[i].au === 'me' || layer.items[i].an === (S.me && S.me.name)) {
                eraseItems([layer.items[i].id]);
                return;
            }
        }
        showHint('Não há nada teu para anular.');
    }

    /* ── Abrir / fechar ────────────────────────────────────── */
    function open(msg) {
        S.open = true;
        S.board = msg.board;
        S.doc = msg.doc;
        S.write = !!msg.write;
        S.boss = !!msg.boss;
        S.me = msg.me;
        S.cfg = msg.config;
        S.cfg.maxPoints = 400;
        I18N = msg.i18n || {};
        applyI18n();

        canvas.width  = (msg.screen && msg.screen.w) || 1920;
        canvas.height = (msg.screen && msg.screen.h) || 1080;

        R.setMapConfig(S.cfg.map);
        R.setIcons(S.cfg.icons);
        R.setDoc(S.doc);

        buildPalette();
        $('#board-name').textContent = msg.board.name || 'Quadro';

        /* O estado de escrita fica à vista. Antes, sem serviço, metade
           da barra ficava muda e não havia nada no ecrã a explicar
           porquê. */
        $('#who').innerHTML = '<b>' + (S.me.name || '-') + '</b>' +
            (S.me.label ? ' · ' + S.me.label : '') +
            (S.boss ? ' · supervisor' : '') +
            (S.write ? '' : ' · <span style="color:#E5A93C">' + T('ui_readonly') + '</span>');
        $('#readonly').hidden = S.write;
        $('#btn-clear').hidden = !S.write;
        $('#btn-undo').hidden = !S.write;
        $('#btn-lock').hidden = !S.boss;
        $('#btn-rename').hidden = !S.boss;
        /* Pousar e apagar quadros é administração do servidor, não
           galões de esquadra: gate no ACE, não no grade do job. */
        $('#sec-admin').hidden = !(S.me && S.me.admin);
        setLocked(msg.doc && msg.doc.locked);
        $('#foot').textContent = S.write
            ? T('ui_foot_write')
            : T('ui_foot_read', S.me.job || '-');

        $('#app').hidden = false;
        setTool(S.write ? 'pen' : 'select');
        syncModeUi();
        updateCount();
        fitFrame();
        R.dirty = true;
    }

    function close() {
        if (!S.open) { return; }
        S.open = false;
        S.drag = null;
        R.ghost = null;
        R.selection = null;
        clearInterval(S.unitsTimer);
        S.unitsTimer = null;
        closeTextBox();
        $('#app').hidden = true;
        post('close');
    }

    /* ── Mensagens do Lua ──────────────────────────────────── */
    window.addEventListener('message', function (e) {
        var msg = e.data;
        if (!msg || !msg.action) { return; }

        if (msg.action === 'open') {
            open(msg);
        } else if (msg.action === 'close') {
            S.open = false;
            $('#app').hidden = true;
            clearInterval(S.unitsTimer);
        } else if (msg.action === 'op') {
            if (!S.open) { return; }
            /* O meu próprio eco: já foi pintado quando o fiz. */
            if (msg.op.tok && S.myOps[msg.op.tok]) {
                delete S.myOps[msg.op.tok];
                updateSelInfo();
                return;
            }
            var wasMap = R.isMap();
            R.applyOp(msg.op);
            updateCount();
            if (msg.op.op === 'mode' || msg.op.op === 'bg' || wasMap !== R.isMap()) { syncModeUi(); }
            if (msg.op.op === 'view') { $('#zoomval').textContent = R.view().zoom.toFixed(1); }
            if (msg.op.op === 'rename') {
                if (S.board) { S.board.name = msg.op.name; }
                $('#board-name').textContent = msg.op.name;
            }
            if (msg.op.op === 'lock') { setLocked(msg.op.locked); }
        }
    });

    (function loop() {
        if (S.open && R.dirty) { R.render(); }
        requestAnimationFrame(loop);
    }());
}());
