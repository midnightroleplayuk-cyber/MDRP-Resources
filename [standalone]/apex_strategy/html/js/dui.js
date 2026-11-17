/*  apex_strategy, html/js/dui.js
    O ecrã que aparece na prop. Não tem interacção nenhuma: recebe
    mensagens do Lua e desenha.

    Só redesenha quando há qualquer coisa nova (ou quando um tile
    acabou de chegar). Um DUI a 60 fps a redesenhar um mapa parado
    era desperdício puro, e podem estar vários quadros no ar.
*/
(function () {
    'use strict';

    var canvas = document.getElementById('board');
    var chrome = document.getElementById('chrome');
    var nameEl = chrome.querySelector('.name');
    var modeEl = chrome.querySelector('.mode');
    var calib  = document.getElementById('calib');
    var calVals = calib.querySelector('.vals');

    var renderer = new BoardRenderer(canvas, {});

    function resize(w, h) {
        canvas.width = w || window.innerWidth;
        canvas.height = h || window.innerHeight;
        renderer.dirty = true;
    }
    resize();
    window.addEventListener('resize', function () { resize(); });

    /* As duas etiquetas do cabeçalho vêm traduzidas no URL, para o
       ecrã da prop falar a mesma língua que o resto do script.
       ⚠️ Tem de ficar ANTES do bootFromUrl. Estava depois, e como o
       `var` só é içado sem o valor, o bootFromUrl apanhava TXT a
       undefined, rebentava, e levava com ele o resto do ficheiro: o
       ouvinte de mensagens e o ciclo de desenho nunca chegavam a
       existir. Era isso o quadro todo preto. */
    var TXT = { modeDraw: 'Board', modeMap: 'Map', loadingMap: 'loading the map...' };

    /* A configuração vem no URL, não numa mensagem: quando o Lua manda
       a primeira mensagem este script pode ainda não existir, e aí ela
       perde-se. Com o URL, a projecção do mapa já cá está antes de
       chegar seja o que for. */
    (function bootFromUrl() {
        var m = /[?&]cfg=([^&]+)/.exec(window.location.search);
        if (!m) { return; }
        var cfg;
        try { cfg = JSON.parse(decodeURIComponent(m[1])); } catch (e) { return; }
        if (cfg.i18n) {
            Object.keys(cfg.i18n).forEach(function (k) { TXT[k] = cfg.i18n[k]; });
            renderer.loadingText = TXT.loadingMap;
        }
        if (cfg.map) { renderer.setMapConfig(cfg.map); }
        if (cfg.icons) { renderer.setIcons(cfg.icons); }
        if (cfg.width && cfg.height) { resize(cfg.width, cfg.height); }
        if (cfg.label) { nameEl.textContent = cfg.label; }
    }());

    function paintChrome() {
        var doc = renderer.doc;
        if (!doc) { return; }
        modeEl.textContent = doc.mode === 'map' ? TXT.modeMap : TXT.modeDraw;
        /* Sobre o quadro branco o cabeçalho tem de ser escuro. */
        var light = doc.mode !== 'map'
            && ((doc.draw && doc.draw.bg) || 'white') !== 'dark';
        document.body.classList.toggle('light', light);
    }

    window.addEventListener('message', function (e) {
        var msg = e.data;
        if (typeof msg === 'string') {
            try { msg = JSON.parse(msg); } catch (err) { return; }
        }
        if (!msg || !msg.action) { return; }

        if (msg.action === 'init') {
            renderer.setMapConfig(msg.map);
            renderer.setIcons(msg.icons);
            if (msg.width && msg.height) { resize(msg.width, msg.height); }
            if (msg.label) { nameEl.textContent = msg.label; }

        } else if (msg.action === 'doc') {
            renderer.setDoc(msg.doc);
            paintChrome();

        } else if (msg.action === 'op') {
            renderer.applyOp(msg.op);
            if (msg.op && (msg.op.op === 'mode' || msg.op.op === 'bg')) { paintChrome(); }
            if (msg.op && msg.op.op === 'rename' && msg.op.name) {
                nameEl.textContent = msg.op.name;
            }

        } else if (msg.action === 'units') {
            renderer.setUnits(msg.units);

        } else if (msg.action === 'name') {
            nameEl.textContent = msg.name || 'Quadro de estratégia';

        } else if (msg.action === 'calib') {
            calib.classList.toggle('on', !!msg.on);

        } else if (msg.action === 'cal') {
            var c = msg.cal || {};
            calVals.textContent =
                'modo ' + (msg.method || '-') +
                '   x ' + (+c.x).toFixed(4) + '   z ' + (+c.z).toFixed(4) +
                '   m/un ' + (+msg.mux).toFixed(2) + ' / ' + (+msg.muz).toFixed(2);
        }
    });

    (function loop() {
        if (renderer.dirty) { renderer.render(); }
        requestAnimationFrame(loop);
    }());
}());
