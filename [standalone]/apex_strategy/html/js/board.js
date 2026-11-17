/*  apex_strategy, html/js/board.js
    ═══════════════════════════════════════════════════════════════
    O renderizador do quadro. É partilhado pelas duas superfícies:

      · board.html → o ecrã na prop (DUI), só desenha
      · index.html → o editor (NUI), desenha e deixa mexer

    Ter um só renderizador é o que garante que o que o agente vê no
    editor é EXACTAMENTE o que aparece no quadro para os outros.

    Dois espaços de coordenadas, conforme o modo:
      · draw → normalizado 0..1 sobre o painel
      · map  → coordenadas do mundo (GTA). Assim um círculo desenhado
               à volta de um quarteirão fica colado ao quarteirão
               quando se dá zoom, em vez de escorregar.
*/
(function (global) {
    'use strict';

    /* Largura de referência: as espessuras e os tamanhos de letra são
       guardados em px desta escala, e depois multiplicados pelo
       tamanho real do canvas. É o que faz um traço ter a mesma grossura
       no editor e na prop. */
    var BASE_W = 1920;

    function clamp(v, lo, hi) { return v < lo ? lo : (v > hi ? hi : v); }

    /* ── Cache de tiles ────────────────────────────────────────
       Sem crossOrigin de propósito: o servidor de tiles não manda
       cabeçalhos CORS e pedir-lhos faria o browser recusar a imagem.
       Não lemos pixels do canvas, por isso o "taint" não incomoda. */
    function TileCache(onLoad) {
        this.items = {};
        this.onLoad = onLoad;
        this.pending = 0;
    }
    TileCache.prototype.get = function (url) {
        var e = this.items[url];
        if (e) { return e.ok ? e.img : null; }
        var self = this;
        var img = new Image();
        e = { img: img, ok: false, failed: false };
        this.items[url] = e;
        this.pending++;
        img.onload = function () {
            e.ok = true; self.pending--;
            if (self.onLoad) { self.onLoad(); }
        };
        img.onerror = function () {
            e.failed = true; self.pending--;
            if (self.onLoad) { self.onLoad(); }
        };
        img.src = url;
        return null;
    };

    /* ── Renderizador ──────────────────────────────────────── */
    function BoardRenderer(canvas, opts) {
        opts = opts || {};
        this.canvas = canvas;
        this.ctx = canvas.getContext('2d');
        this.map = opts.map || null;
        this.icons = {};
        (opts.icons || []).forEach(function (i) { this.icons[i.id] = i; }, this);

        this.doc = null;
        this.units = [];
        this.ghost = null;      // item a ser desenhado neste momento
        this.selection = null;  // rectângulo de selecção de área
        this.dirty = true;

        var self = this;
        this.tiles = new TileCache(function () { self.dirty = true; });
    }

    BoardRenderer.prototype.setIcons = function (icons) {
        this.icons = {};
        (icons || []).forEach(function (i) { this.icons[i.id] = i; }, this);
    };

    BoardRenderer.prototype.setMapConfig = function (cfg) {
        this.map = cfg;
        this.dirty = true;
    };

    BoardRenderer.prototype.setDoc = function (doc) {
        this.doc = doc;
        this.dirty = true;
    };

    BoardRenderer.prototype.setUnits = function (units) {
        this.units = units || [];
        this.dirty = true;
    };

    BoardRenderer.prototype.layer = function () {
        if (!this.doc) { return null; }
        /* Repara no this.doc.mode e não no isMap(): a camada existe
           mesmo antes de a projecção chegar. */
        return this.doc.mode === 'map' ? this.doc.map : this.doc.draw;
    };

    /* Só se considera modo mapa quando HÁ configuração de mapa. Sem
       ela não há projecção nenhuma, e todo o desenho em coordenadas
       do mundo rebentava a tentar ler this.map.scaleX. */
    BoardRenderer.prototype.isMap = function () {
        return !!(this.doc && this.doc.mode === 'map' && this.map);
    };

    /* O documento PEDE mapa mas ainda não temos projecção? */
    BoardRenderer.prototype.mapPending = function () {
        return !!(this.doc && this.doc.mode === 'map' && !this.map);
    };

    /* O fundo por baixo do que se desenha é claro ou escuro? */
    BoardRenderer.prototype.lightBg = function () {
        if (this.isMap()) { return false; }
        return ((this.doc && this.doc.draw && this.doc.draw.bg) || 'white') !== 'dark';
    };

    /* Contorno do texto: pinta-se com a COR DO FUNDO, não com preto.
       Um contorno preto num quadro branco escurecia as letras escuras
       em vez de as separar; assim qualquer cor se lê nos dois fundos. */
    BoardRenderer.prototype.halo = function () {
        return this.lightBg() ? 'rgba(255,255,255,.92)' : 'rgba(0,0,0,.72)';
    };

    BoardRenderer.prototype.view = function () {
        return (this.doc && this.doc.map && this.doc.map.view) || { cx: 0, cy: 0, zoom: 4 };
    };

    /* Aplica uma operação vinda do servidor. */
    BoardRenderer.prototype.applyOp = function (op) {
        if (!this.doc || !op) { return; }
        var layer = op.mode === 'map' ? this.doc.map : this.doc.draw;
        if (op.op === 'add' && op.item) {
            /* O editor já pintou o traço assim que o servidor
               confirmou; a difusão chega a seguir com o mesmo id.
               Sem esta verificação ficava lá duas vezes. */
            var exists = layer.items.some(function (it) { return it.id === op.item.id; });
            if (!exists) { layer.items.push(op.item); }
        } else if (op.op === 'move' || op.op === 'scale') {
            for (var k = 0; k < layer.items.length; k++) {
                if (layer.items[k].id === op.itemId) {
                    if (op.op === 'move') {
                        BoardRenderer.shift(layer.items[k], op.dx, op.dy);
                    } else {
                        var cp = JSON.parse(JSON.stringify(layer.items[k]));
                        BoardRenderer.scaleFrom(layer.items[k], cp, op.fx, op.fy, op.ox, op.oy);
                    }
                    break;
                }
            }
        } else if (op.op === 'order') {
            for (var z = 0; z < layer.items.length; z++) {
                if (layer.items[z].id === op.itemId) {
                    var moved = layer.items.splice(z, 1)[0];
                    if (op.to === 'back') { layer.items.unshift(moved); }
                    else { layer.items.push(moved); }
                    break;
                }
            }
        } else if (op.op === 'lock') {
            this.doc.locked = op.locked === true;
        } else if (op.op === 'erase') {
            var kill = {};
            (op.ids || []).forEach(function (id) { kill[id] = true; });
            layer.items = layer.items.filter(function (it) { return !kill[it.id]; });
        } else if (op.op === 'replace') {
            layer.items = op.items || [];
        } else if (op.op === 'mode') {
            this.doc.mode = op.mode;
        } else if (op.op === 'view') {
            this.doc.map.view = op.view;
        } else if (op.op === 'bg') {
            this.doc.draw.bg = op.bg;
        }
        if (typeof op.rev === 'number') { this.doc.rev = op.rev; }
        this.dirty = true;
    };

    /* Desloca um item no espaço do documento. A mesma matemática
       existe no servidor (shiftItem), este lado é só para se ver o
       arrasto sem esperar pela resposta. */
    BoardRenderer.shift = function (it, dx, dy) {
        if (!it) { return; }
        if (it.t === 'stroke') {
            for (var i = 0; i < it.p.length; i += 2) {
                it.p[i] += dx; it.p[i + 1] += dy;
            }
        } else if (it.t === 'text' || it.t === 'icon') {
            it.x += dx; it.y += dy;
        } else {
            it.ax += dx; it.ay += dy; it.bx += dx; it.by += dy;
        }
    };

    /* Escala em torno de (ox,oy), no espaço do documento. Escreve a
       partir de `orig` (uma cópia feita no início do arrasto) para não
       acumular erro frame a frame. A mesma matemática vive no
       servidor, ver scaleItem. */
    BoardRenderer.scaleFrom = function (it, orig, fx, fy, ox, oy) {
        var sx = function (v) { return ox + (v - ox) * fx; };
        var sy = function (v) { return oy + (v - oy) * fy; };
        var uni = (Math.abs(fx) + Math.abs(fy)) * 0.5;

        if (it.t === 'stroke') {
            for (var i = 0; i < orig.p.length; i += 2) {
                it.p[i] = sx(orig.p[i]);
                it.p[i + 1] = sy(orig.p[i + 1]);
            }
            return;
        }
        if (it.t === 'text' || it.t === 'icon') {
            it.x = sx(orig.x); it.y = sy(orig.y);
            if (it.t === 'text') {
                it.s = Math.max(14, Math.min(420, (orig.s || 72) * uni));
            } else {
                it.sc = Math.max(0.35, Math.min(4, (orig.sc || 1) * uni));
            }
            return;
        }
        it.ax = sx(orig.ax); it.ay = sy(orig.ay);
        it.bx = sx(orig.bx); it.by = sy(orig.by);
    };

    BoardRenderer.prototype.findItem = function (id) {
        var layer = this.layer();
        if (!layer) { return null; }
        for (var i = 0; i < layer.items.length; i++) {
            if (layer.items[i].id === id) { return layer.items[i]; }
        }
        return null;
    };

    /* Caixa que envolve o item, em px do canvas. Serve para desenhar
       o realce de selecção. */
    BoardRenderer.prototype.itemBounds = function (it) {
        var u = this.unit(), p, i;
        var x1 = Infinity, y1 = Infinity, x2 = -Infinity, y2 = -Infinity;
        var self = this;
        function add(px, py) {
            if (px < x1) { x1 = px; } if (px > x2) { x2 = px; }
            if (py < y1) { y1 = py; } if (py > y2) { y2 = py; }
        }

        if (it.t === 'stroke') {
            for (i = 0; i < it.p.length; i += 2) {
                p = self.toCanvas(it.p[i], it.p[i + 1]); add(p.x, p.y);
            }
        } else if (it.t === 'text') {
            p = this.toCanvas(it.x, it.y);
            var s = (it.s || 44) * u;
            add(p.x - s * 0.15, p.y - s * 0.75);
            add(p.x + s * 0.58 * (it.v || '').length + s * 0.15, p.y + s * 0.75);
        } else if (it.t === 'icon') {
            p = this.toCanvas(it.x, it.y);
            var r = 44 * u * (it.sc || 1);
            add(p.x - r, p.y - r);
            add(p.x + r, p.y + r + (it.v ? 46 * u * (it.sc || 1) : 0));
        } else {
            p = this.toCanvas(it.ax, it.ay); add(p.x, p.y);
            p = this.toCanvas(it.bx, it.by); add(p.x, p.y);
        }

        var pad = Math.max(6 * u, (it.w || 6) * u);
        return { x: x1 - pad, y: y1 - pad, w: (x2 - x1) + pad * 2, h: (y2 - y1) + pad * 2 };
    };

    /* ── Geometria ──────────────────────────────────────────── */
    BoardRenderer.prototype.unit = function () {
        return this.canvas.width / BASE_W;
    };

    BoardRenderer.prototype.worldToPixel = function (x, y, zoom) {
        var m = this.map, s = Math.pow(2, zoom);
        return {
            px: (m.scaleX * x + m.originX) * s,
            py: (m.scaleY * y + m.originY) * s
        };
    };

    BoardRenderer.prototype.pixelOrigin = function () {
        var v = this.view();
        var c = this.worldToPixel(v.cx, v.cy, v.zoom);
        return { x: c.px - this.canvas.width / 2, y: c.py - this.canvas.height / 2 };
    };

    BoardRenderer.prototype.worldToCanvas = function (x, y) {
        var v = this.view(), o = this.pixelOrigin();
        var p = this.worldToPixel(x, y, v.zoom);
        return { x: p.px - o.x, y: p.py - o.y };
    };

    BoardRenderer.prototype.canvasToWorld = function (cx, cy) {
        var m = this.map, v = this.view(), o = this.pixelOrigin();
        var s = Math.pow(2, v.zoom);
        var crsX = (cx + o.x) / s, crsY = (cy + o.y) / s;
        return {
            x: (crsX - m.originX) / m.scaleX,
            y: (crsY - m.originY) / m.scaleY
        };
    };

    /* Ponto do documento → px do canvas, conforme o modo. */
    BoardRenderer.prototype.toCanvas = function (a, b) {
        if (this.isMap()) { return this.worldToCanvas(a, b); }
        return { x: a * this.canvas.width, y: b * this.canvas.height };
    };

    /* px do canvas → ponto do documento.
       O arrasto é escutado na janela inteira (senão perdia-se o
       "largar" fora da moldura), por isso o rato pode acabar fora do
       quadro. Sem este travão saíam coordenadas fora do intervalo, o
       servidor recusava a linha inteira com "bad_item", e o desenho
       aparecia e desaparecia. Não se desenha fora do quadro: encosta
       à borda. */
    BoardRenderer.prototype.fromCanvas = function (px, py) {
        if (this.isMap()) {
            var w = this.canvasToWorld(px, py);
            return { x: clamp(w.x, -11500, 11500), y: clamp(w.y, -11500, 11500) };
        }
        return {
            x: clamp(px / this.canvas.width, 0, 1),
            y: clamp(py / this.canvas.height, 0, 1)
        };
    };

    /* Que zoom é preciso para um rectângulo do mundo caber no ecrã,
       sem mudar o tamanho do ecrã. É isto que faz o "seleccionar uma
       área do mapa", enquadra a zona escolhida e mais nada. */
    BoardRenderer.prototype.zoomToFit = function (x1, y1, x2, y2) {
        var m = this.map;
        var dx = Math.abs(x2 - x1), dy = Math.abs(y2 - y1);
        if (dx < 1) { dx = 1; }
        if (dy < 1) { dy = 1; }
        var needX = this.canvas.width / (Math.abs(m.scaleX) * dx);
        var needY = this.canvas.height / (Math.abs(m.scaleY) * dy);
        var z = Math.log(Math.min(needX, needY)) / Math.LN2;
        return clamp(z, m.minZoom, m.maxZoom);
    };

    /* ── Fundos ─────────────────────────────────────────────── */
    BoardRenderer.prototype.drawWhiteboard = function () {
        var ctx = this.ctx, W = this.canvas.width, H = this.canvas.height;
        var bg = (this.doc && this.doc.draw && this.doc.draw.bg) || 'white';

        if (bg === 'dark') {
            ctx.fillStyle = '#131314';
        } else {
            ctx.fillStyle = '#F7F7F5';
        }
        ctx.fillRect(0, 0, W, H);

        if (bg === 'grid') {
            var step = Math.round(W / 32);
            ctx.strokeStyle = 'rgba(31,94,255,.13)';
            ctx.lineWidth = Math.max(1, this.unit());
            ctx.beginPath();
            for (var x = step; x < W; x += step) { ctx.moveTo(x, 0); ctx.lineTo(x, H); }
            for (var y = step; y < H; y += step) { ctx.moveTo(0, y); ctx.lineTo(W, y); }
            ctx.stroke();
        }

        /* Um brilho muito ao de leve no canto, para não parecer papel
           liso quando visto de lado dentro do jogo. */
        if (bg !== 'dark') {
            var g = ctx.createLinearGradient(0, 0, W * 0.6, H);
            g.addColorStop(0, 'rgba(255,255,255,.55)');
            g.addColorStop(1, 'rgba(255,255,255,0)');
            ctx.fillStyle = g;
            ctx.fillRect(0, 0, W, H);
        }
    };

    BoardRenderer.prototype.drawMap = function () {
        var ctx = this.ctx, W = this.canvas.width, H = this.canvas.height;
        var m = this.map, v = this.view();

        ctx.fillStyle = '#0B1220';
        ctx.fillRect(0, 0, W, H);
        if (!m) { return; }

        var tz = clamp(Math.floor(v.zoom), m.minZoom, m.maxNativeZoom);
        var s = Math.pow(2, v.zoom - tz);       /* px por px de tile */
        var size = m.tileSize * s;
        var o = this.pixelOrigin();

        /* Origem em coordenadas de pixel do NÍVEL DE TILE. */
        var ox = o.x / s, oy = o.y / s;
        var tx0 = Math.floor(ox / m.tileSize);
        var ty0 = Math.floor(oy / m.tileSize);
        var tx1 = Math.floor((ox + W / s) / m.tileSize);
        var ty1 = Math.floor((oy + H / s) / m.tileSize);

        var maxT = Math.pow(2, tz);
        ctx.imageSmoothingEnabled = true;

        for (var ty = ty0; ty <= ty1; ty++) {
            for (var tx = tx0; tx <= tx1; tx++) {
                if (tx < 0 || ty < 0 || tx >= maxT || ty >= maxT) { continue; }
                var url = m.tileUrl
                    .replace('{z}', tz).replace('{x}', tx).replace('{y}', ty);
                var img = this.tiles.get(url);
                if (!img) { continue; }
                var dx = tx * m.tileSize * s - o.x;
                var dy = ty * m.tileSize * s - o.y;
                /* +1 px para não deixar costura entre tiles */
                ctx.drawImage(img, dx, dy, size + 1, size + 1);
            }
        }
    };

    /* ── Itens ──────────────────────────────────────────────── */
    BoardRenderer.prototype.drawItem = function (it) {
        var ctx = this.ctx, u = this.unit();
        ctx.strokeStyle = it.c || '#1F5EFF';
        ctx.fillStyle = it.c || '#1F5EFF';
        ctx.lineWidth = Math.max(1, (it.w || 6) * u);
        ctx.lineCap = 'round';
        ctx.lineJoin = 'round';

        var a, b, i, p;

        if (it.t === 'stroke') {
            if (!it.p || it.p.length < 4) { return; }
            ctx.beginPath();
            p = this.toCanvas(it.p[0], it.p[1]);
            ctx.moveTo(p.x, p.y);
            for (i = 2; i < it.p.length; i += 2) {
                p = this.toCanvas(it.p[i], it.p[i + 1]);
                ctx.lineTo(p.x, p.y);
            }
            ctx.stroke();

        } else if (it.t === 'line' || it.t === 'arrow') {
            a = this.toCanvas(it.ax, it.ay);
            b = this.toCanvas(it.bx, it.by);

            if (it.t !== 'arrow') {
                ctx.beginPath();
                ctx.moveTo(a.x, a.y);
                ctx.lineTo(b.x, b.y);
                ctx.stroke();
            } else {
                /* A haste TEM de parar na base da cabeça. Desenhada até
                   ao bico, a ponta redonda do traço (lineCap round)
                   espeta meia grossura para lá da seta e fica um risco
                   solto na ponta. */
                var ang = Math.atan2(b.y - a.y, b.x - a.x);
                var len = Math.hypot(b.x - a.x, b.y - a.y);
                var head = Math.max(14 * u, ctx.lineWidth * 3.0);
                /* Setas curtas: a cabeça nunca come mais de 80% do
                   comprimento, senão fica só um triângulo. */
                if (head > len * 0.8) { head = len * 0.8; }

                var nx = b.x - Math.cos(ang) * head;
                var ny = b.y - Math.sin(ang) * head;

                if (len > head + 0.5) {
                    ctx.beginPath();
                    ctx.moveTo(a.x, a.y);
                    ctx.lineTo(nx, ny);
                    ctx.stroke();
                }

                /* Cabeça com entalhe no meio, para casar com a haste
                   sem deixar costura. */
                var wing = 0.42;
                ctx.beginPath();
                ctx.moveTo(b.x, b.y);
                ctx.lineTo(b.x - head * Math.cos(ang - wing), b.y - head * Math.sin(ang - wing));
                ctx.lineTo(nx, ny);
                ctx.lineTo(b.x - head * Math.cos(ang + wing), b.y - head * Math.sin(ang + wing));
                ctx.closePath();
                ctx.fill();
            }

        } else if (it.t === 'rect') {
            a = this.toCanvas(it.ax, it.ay);
            b = this.toCanvas(it.bx, it.by);
            if (it.fill) {
                ctx.globalAlpha = 0.22;
                ctx.fillRect(a.x, a.y, b.x - a.x, b.y - a.y);
                ctx.globalAlpha = 1;
            }
            ctx.strokeRect(a.x, a.y, b.x - a.x, b.y - a.y);

        } else if (it.t === 'ellipse') {
            a = this.toCanvas(it.ax, it.ay);
            b = this.toCanvas(it.bx, it.by);
            var cx = (a.x + b.x) / 2, cy = (a.y + b.y) / 2;
            var rx = Math.abs(b.x - a.x) / 2, ry = Math.abs(b.y - a.y) / 2;
            ctx.beginPath();
            ctx.ellipse(cx, cy, rx, ry, 0, 0, Math.PI * 2);
            if (it.fill) {
                ctx.globalAlpha = 0.22; ctx.fill(); ctx.globalAlpha = 1;
            }
            ctx.stroke();

        } else if (it.t === 'ruler') {
            this.drawRuler(it);

        } else if (it.t === 'text') {
            p = this.toCanvas(it.x, it.y);
            var size = (it.s || 44) * u;
            ctx.font = '700 ' + size + 'px Inter, "Segoe UI", Arial, sans-serif';
            ctx.textBaseline = 'middle';
            ctx.textAlign = 'left';
            /* it.o === false → texto pelado, sem contorno nenhum.
               É o "texto sem caixa de fundo". */
            if (it.o !== false) {
                ctx.lineWidth = Math.max(2, size * 0.16);
                ctx.strokeStyle = this.halo();
                ctx.lineJoin = 'round';
                ctx.strokeText(it.v, p.x, p.y);
            }
            ctx.fillStyle = it.c || '#1F5EFF';
            ctx.fillText(it.v, p.x, p.y);

        } else if (it.t === 'icon') {
            this.drawIcon(it);
        }
    };

    /* ── Pictogramas ────────────────────────────────────────────
       Desenhados à mão em vectores. Nada de fontes de ícones nem de
       imagens: dentro de um DUI não há garantia nenhuma de que uma
       fonte externa carregue, e uma letra sozinha não se lê a três
       metros de distância dentro do jogo.

       Cada função desenha numa caixa de -1..1 e o chamador escala.
       PICTO_BG é a cor do fundo do marcador, usa-se para "recortar"
       detalhes sem furar a imagem que está por baixo.  */
    var PICTO_BG = '#1F5EFF';
    var PICTO = {
        car: function (c) {
            c.beginPath();
            c.moveTo(-.85, .18); c.lineTo(-.72, -.16); c.lineTo(-.44, -.34);
            c.lineTo(.44, -.34); c.lineTo(.72, -.16); c.lineTo(.85, .18);
            c.lineTo(.85, .40); c.lineTo(-.85, .40); c.closePath(); c.fill();
            c.beginPath();                                   /* barra de luzes */
            c.rect(-.34, -.60, .68, .20); c.fill();
            c.beginPath();                                   /* rodas */
            c.arc(-.50, .44, .17, 0, Math.PI * 2);
            c.arc(.50, .44, .17, 0, Math.PI * 2); c.fill();
        },
        van: function (c) {
            c.beginPath();
            c.moveTo(-.88, -.36); c.lineTo(.34, -.36); c.lineTo(.62, -.06);
            c.lineTo(.88, -.06); c.lineTo(.88, .34); c.lineTo(-.88, .34);
            c.closePath(); c.fill();
            c.beginPath();
            c.arc(-.50, .40, .17, 0, Math.PI * 2);
            c.arc(.52, .40, .17, 0, Math.PI * 2); c.fill();
        },
        moto: function (c) {
            c.lineWidth = .17; c.lineCap = 'round';
            c.beginPath();
            c.arc(-.55, .28, .30, 0, Math.PI * 2);
            c.arc(.55, .28, .30, 0, Math.PI * 2); c.stroke();
            c.beginPath();
            c.moveTo(-.55, .28); c.lineTo(-.10, -.10); c.lineTo(.30, -.10);
            c.lineTo(.55, .28); c.stroke();
            c.beginPath();
            c.moveTo(.18, -.10); c.lineTo(.48, -.52); c.stroke();
        },
        heli: function (c) {
            c.lineWidth = .15; c.lineCap = 'round';
            c.beginPath(); c.moveTo(-.88, -.52); c.lineTo(.88, -.52); c.stroke();
            c.beginPath(); c.moveTo(0, -.52); c.lineTo(0, -.24); c.stroke();
            c.beginPath();
            c.ellipse(-.14, .04, .52, .30, 0, 0, Math.PI * 2); c.fill();
            c.beginPath();
            c.moveTo(.32, .00); c.lineTo(.88, .10); c.lineTo(.88, .22);
            c.lineTo(.32, .16); c.closePath(); c.fill();
            c.beginPath(); c.moveTo(.80, -.14); c.lineTo(.80, .34); c.stroke();
        },
        boat: function (c) {
            c.beginPath();
            c.moveTo(-.88, .06); c.lineTo(.88, .06); c.lineTo(.56, .48);
            c.lineTo(-.56, .48); c.closePath(); c.fill();
            c.beginPath();
            c.moveTo(-.10, -.62); c.lineTo(.34, -.02); c.lineTo(-.10, -.02);
            c.closePath(); c.fill();
        },
        k9: function (c) {
            c.beginPath();
            c.ellipse(-.06, .16, .56, .28, 0, 0, Math.PI * 2); c.fill();
            c.beginPath();
            c.moveTo(.40, .04); c.lineTo(.86, -.28); c.lineTo(.86, .10);
            c.lineTo(.50, .26); c.closePath(); c.fill();
            c.beginPath();                                   /* orelha */
            c.moveTo(.52, -.22); c.lineTo(.66, -.62); c.lineTo(.76, -.26);
            c.closePath(); c.fill();
            c.lineWidth = .14; c.lineCap = 'round';
            c.beginPath();
            c.moveTo(-.40, .40); c.lineTo(-.40, .64);
            c.moveTo(.16, .40); c.lineTo(.16, .64);
            c.moveTo(-.62, .06); c.lineTo(-.88, -.28); c.stroke();
        },
        shield: function (c) {
            c.beginPath();
            c.moveTo(0, -.74);
            c.lineTo(.60, -.46); c.lineTo(.60, .08);
            c.quadraticCurveTo(.60, .52, 0, .74);
            c.quadraticCurveTo(-.60, .52, -.60, .08);
            c.lineTo(-.60, -.46); c.closePath(); c.fill();
            /* Estrela recortada na cor do fundo (ver nota no `warn`). */
            c.fillStyle = PICTO_BG;
            c.beginPath();
            for (var i = 0; i < 10; i++) {
                var a = -Math.PI / 2 + i * Math.PI / 5;
                var rr = (i % 2 === 0) ? .30 : .13;
                var fn = i ? 'lineTo' : 'moveTo';
                c[fn](Math.cos(a) * rr, Math.sin(a) * rr - .04);
            }
            c.closePath(); c.fill();
        },
        cross: function (c) {
            c.beginPath();
            c.rect(-.24, -.76, .48, 1.52);
            c.rect(-.76, -.24, 1.52, .48); c.fill();
        },
        flame: function (c) {
            c.beginPath();
            c.moveTo(0, -.82);
            c.quadraticCurveTo(.62, -.20, .40, .28);
            c.quadraticCurveTo(.30, .76, 0, .80);
            c.quadraticCurveTo(-.30, .76, -.40, .28);
            c.quadraticCurveTo(-.62, -.20, 0, -.82);
            c.closePath(); c.fill();
        },
        person: function (c) {
            c.beginPath(); c.arc(0, -.44, .28, 0, Math.PI * 2); c.fill();
            c.beginPath();
            c.moveTo(0, -.10);
            c.quadraticCurveTo(.56, -.06, .52, .74);
            c.lineTo(-.52, .74);
            c.quadraticCurveTo(-.56, -.06, 0, -.10);
            c.closePath(); c.fill();
        },
        armed: function (c) {
            PICTO.person(c);
            c.lineWidth = .16; c.lineCap = 'round';
            c.beginPath();
            c.moveTo(.30, .10); c.lineTo(.90, -.16); c.stroke();
        },
        down: function (c) {
            c.beginPath(); c.arc(-.52, .10, .26, 0, Math.PI * 2); c.fill();
            c.beginPath();
            c.moveTo(-.24, -.16); c.lineTo(.76, .06); c.lineTo(.76, .52);
            c.lineTo(-.24, .40); c.closePath(); c.fill();
        },
        scope: function (c) {
            c.lineWidth = .15;
            c.beginPath(); c.arc(0, 0, .56, 0, Math.PI * 2); c.stroke();
            c.beginPath();
            c.moveTo(-.92, 0); c.lineTo(-.30, 0);
            c.moveTo(.30, 0); c.lineTo(.92, 0);
            c.moveTo(0, -.92); c.lineTo(0, -.30);
            c.moveTo(0, .30); c.lineTo(0, .92); c.stroke();
            c.beginPath(); c.arc(0, 0, .13, 0, Math.PI * 2); c.fill();
        },
        door: function (c) {
            c.beginPath();
            c.rect(-.10, -.78, .78, 1.56); c.fill();
            c.lineWidth = .16; c.lineCap = 'round';
            c.beginPath();
            c.moveTo(-.90, 0); c.lineTo(-.24, 0); c.stroke();
            c.beginPath();
            c.moveTo(-.46, -.28); c.lineTo(-.14, 0); c.lineTo(-.46, .28);
            c.closePath(); c.fill();
        },
        exit: function (c) {
            c.beginPath();
            c.rect(-.78, -.78, .70, 1.56); c.fill();
            c.lineWidth = .16; c.lineCap = 'round';
            c.beginPath();
            c.moveTo(.06, 0); c.lineTo(.76, 0); c.stroke();
            c.beginPath();
            c.moveTo(.44, -.30); c.lineTo(.88, 0); c.lineTo(.44, .30);
            c.closePath(); c.fill();
        },
        chevron: function (c) {
            c.lineWidth = .20; c.lineCap = 'round'; c.lineJoin = 'round';
            c.beginPath();
            c.moveTo(-.62, .28); c.lineTo(0, -.34); c.lineTo(.62, .28); c.stroke();
            c.beginPath();
            c.moveTo(-.62, .78); c.lineTo(0, .16); c.lineTo(.62, .78); c.stroke();
        },
        barrier: function (c) {
            c.beginPath(); c.rect(-.90, -.30, 1.80, .46); c.fill();
            c.lineWidth = .14;
            c.beginPath();
            c.moveTo(-.52, .16); c.lineTo(-.52, .78);
            c.moveTo(.52, .16); c.lineTo(.52, .78); c.stroke();
        },
        spikes: function (c) {
            c.beginPath();
            c.moveTo(-.90, .46);
            for (var i = 0; i < 5; i++) {
                var x = -.90 + i * .45;
                c.lineTo(x + .22, -.34); c.lineTo(x + .45, .46);
            }
            c.closePath(); c.fill();
        },
        perim: function (c) {
            c.lineWidth = .16;
            c.setLineDash([.30, .22]);
            c.beginPath(); c.arc(0, 0, .70, 0, Math.PI * 2); c.stroke();
            c.setLineDash([]);
            c.beginPath(); c.arc(0, 0, .16, 0, Math.PI * 2); c.fill();
        },
        cuffs: function (c) {
            c.lineWidth = .18;
            c.beginPath(); c.arc(-.44, .10, .40, 0, Math.PI * 2); c.stroke();
            c.beginPath(); c.arc(.44, .10, .40, 0, Math.PI * 2); c.stroke();
            c.beginPath(); c.rect(-.12, -.06, .24, .32); c.fill();
        },
        warn: function (c) {
            /* Triângulo com o ponto de exclamação recortado. O recorte
               é pintado com a COR DO FUNDO e não com destination-out:
               esse apagava também o que estava por baixo do marcador e
               abria um buraco transparente no mapa. */
            c.beginPath();
            c.moveTo(0, -.78); c.lineTo(.82, .62); c.lineTo(-.82, .62);
            c.closePath(); c.fill();
            c.fillStyle = PICTO_BG;
            c.beginPath();
            c.rect(-.10, -.24, .20, .52);
            c.rect(-.10, .36, .20, .18);
            c.fill();
        },
        target: function (c) {
            c.lineWidth = .17;
            c.beginPath(); c.arc(0, 0, .74, 0, Math.PI * 2); c.stroke();
            c.beginPath(); c.arc(0, 0, .40, 0, Math.PI * 2); c.stroke();
            c.beginPath(); c.arc(0, 0, .13, 0, Math.PI * 2); c.fill();
        },
        building: function (c) {
            c.beginPath(); c.rect(-.74, -.56, 1.48, 1.34); c.fill();
            c.beginPath();
            c.moveTo(-.86, -.56); c.lineTo(0, -.92); c.lineTo(.86, -.56);
            c.closePath(); c.fill();
        },
        flag: function (c) {
            c.lineWidth = .16; c.lineCap = 'round';
            c.beginPath(); c.moveTo(-.48, -.80); c.lineTo(-.48, .80); c.stroke();
            c.beginPath();
            c.moveTo(-.34, -.72); c.lineTo(.74, -.42); c.lineTo(-.34, -.12);
            c.closePath(); c.fill();
        },
        camera: function (c) {
            c.beginPath();
            c.moveTo(-.84, -.44); c.lineTo(.52, -.44); c.lineTo(.52, .16);
            c.lineTo(-.84, .16); c.closePath(); c.fill();
            c.beginPath();
            c.moveTo(.52, -.28); c.lineTo(.90, -.50); c.lineTo(.90, .10);
            c.lineTo(.52, -.06); c.closePath(); c.fill();
            c.lineWidth = .14;
            c.beginPath(); c.moveTo(-.58, .16); c.lineTo(-.58, .80); c.stroke();
        },
        evidence: function (c) {
            c.beginPath();
            c.moveTo(-.58, -.34); c.lineTo(.58, -.34); c.lineTo(.72, .80);
            c.lineTo(-.72, .80); c.closePath(); c.fill();
            c.lineWidth = .15;
            c.beginPath();
            c.moveTo(-.30, -.34);
            c.quadraticCurveTo(-.30, -.86, 0, -.86);
            c.quadraticCurveTo(.30, -.86, .30, -.34); c.stroke();
        },
        radio: function (c) {
            c.beginPath(); c.arc(0, .20, .22, 0, Math.PI * 2); c.fill();
            c.lineWidth = .15;
            [.44, .74].forEach(function (r) {
                c.beginPath();
                c.arc(0, .20, r, Math.PI * 1.15, Math.PI * 1.85); c.stroke();
            });
            c.beginPath(); c.moveTo(0, .20); c.lineTo(0, .82); c.stroke();
        }
    };

    var SHAPE_BY_CAT = { 'Táctico': 'diamond', 'Locais': 'square' };

    /* Badge + pictograma. Partilhado entre o quadro e as
       miniaturas do painel, para o que se escolhe ser exactamente o
       que aparece. */
    function paintBadge(ctx, cx, cy, r, color, meta, ringPx) {
        var shape = SHAPE_BY_CAT[meta.cat] || 'circle';

        ctx.beginPath();
        if (shape === 'diamond') {
            ctx.moveTo(cx, cy - r * 1.18); ctx.lineTo(cx + r * 1.18, cy);
            ctx.lineTo(cx, cy + r * 1.18); ctx.lineTo(cx - r * 1.18, cy);
            ctx.closePath();
        } else if (shape === 'square') {
            ctx.rect(cx - r * .92, cy - r * .92, r * 1.84, r * 1.84);
        } else {
            ctx.arc(cx, cy, r, 0, Math.PI * 2);
        }
        ctx.fillStyle = color;
        ctx.fill();
        ctx.lineWidth = ringPx;
        ctx.strokeStyle = 'rgba(0,0,0,.5)';
        ctx.stroke();

        var draw = PICTO[meta.pic];
        PICTO_BG = color;
        ctx.save();
        ctx.translate(cx, cy);
        ctx.scale(r * 0.58, r * 0.58);
        ctx.fillStyle = '#FFFFFF';
        ctx.strokeStyle = '#FFFFFF';
        ctx.lineWidth = .16;
        ctx.lineJoin = 'round';
        ctx.lineCap = 'round';
        if (draw) {
            draw(ctx);
        } else if (meta.pic !== 'number') {
            /* Sem pictograma, fica a inicial. O 'number' é o único que
               não leva nada aqui: o conteúdo dele é o próprio número,
               desenhado a seguir com o tamanho todo do fundo. */
            ctx.font = '800 1.1px Inter, "Segoe UI", Arial, sans-serif';
            ctx.textAlign = 'center';
            ctx.textBaseline = 'middle';
            ctx.fillText((meta.label || '?').charAt(0).toUpperCase(), 0, 0);
        }
        ctx.restore();
    }

    /* Miniatura para o painel de escolha. */
    BoardRenderer.iconPreview = function (canvas, meta) {
        var ctx = canvas.getContext('2d');
        var W = canvas.width, H = canvas.height;
        ctx.clearRect(0, 0, W, H);
        paintBadge(ctx, W / 2, H / 2, Math.min(W, H) * 0.40,
            meta.color || '#1F5EFF', meta, Math.max(1, W * 0.035));
    };

    /* Régua. No modo mapa as coordenadas são as do mundo, por isso a
       distância sai directamente em metros. No quadro branco não há
       escala nenhuma, e aí mostra-se a percentagem da largura. */
    BoardRenderer.prototype.measure = function (it) {
        if (this.isMap()) {
            var d = Math.hypot(it.bx - it.ax, it.by - it.ay);
            return d >= 1000 ? (d / 1000).toFixed(2) + ' km' : Math.round(d) + ' m';
        }
        return Math.round(Math.hypot(it.bx - it.ax, it.by - it.ay) * 100) + '%';
    };

    BoardRenderer.prototype.drawRuler = function (it) {
        var ctx = this.ctx, u = this.unit();
        var a = this.toCanvas(it.ax, it.ay);
        var b = this.toCanvas(it.bx, it.by);
        var col = it.c || '#1F5EFF';

        ctx.strokeStyle = col;
        ctx.lineWidth = Math.max(2, (it.w || 6) * u * 0.6);
        ctx.setLineDash([14 * u, 9 * u]);
        ctx.beginPath();
        ctx.moveTo(a.x, a.y);
        ctx.lineTo(b.x, b.y);
        ctx.stroke();
        ctx.setLineDash([]);

        /* Traços nas pontas, perpendiculares, como numa fita métrica. */
        var ang = Math.atan2(b.y - a.y, b.x - a.x);
        var tick = 13 * u;
        [a, b].forEach(function (pnt) {
            ctx.beginPath();
            ctx.moveTo(pnt.x - Math.sin(ang) * tick, pnt.y + Math.cos(ang) * tick);
            ctx.lineTo(pnt.x + Math.sin(ang) * tick, pnt.y - Math.cos(ang) * tick);
            ctx.stroke();
        });

        var label = this.measure(it);
        var fs = 32 * u;
        var mx = (a.x + b.x) / 2, my = (a.y + b.y) / 2;
        ctx.font = '800 ' + fs + 'px Inter, "Segoe UI", Arial, sans-serif';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        var w = ctx.measureText(label).width + 18 * u;
        ctx.fillStyle = col;
        ctx.fillRect(mx - w / 2, my - fs * 0.78, w, fs * 1.56);
        ctx.fillStyle = '#FFFFFF';
        ctx.fillText(label, mx, my);
        ctx.textAlign = 'left';
    };

    BoardRenderer.prototype.drawIcon = function (it) {
        var ctx = this.ctx, u = this.unit();
        var meta = this.icons[it.k] || {};
        var p = this.toCanvas(it.x, it.y);
        var sc = it.sc || 1;
        var r = 40 * u * sc;   /* ~4 cm no quadro real, vezes a escala */

        paintBadge(ctx, p.x, p.y, r, it.c || meta.color || '#1F5EFF', meta, 4 * u * sc);

        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';

        /* Passo numerado: o número vai DENTRO, grande, e não há
           etiqueta por baixo. */
        if (meta.pic === 'number') {
            ctx.fillStyle = '#FFFFFF';
            ctx.font = '900 ' + (r * 1.05) + 'px Inter, "Segoe UI", Arial, sans-serif';
            ctx.fillText(String(it.v || '1'), p.x, p.y + r * 0.03);
            ctx.textAlign = 'left';
            return;
        }

        if (it.v) {
            var fs = 38 * u * sc;
            var light = this.lightBg();
            ctx.font = '700 ' + fs + 'px Inter, "Segoe UI", Arial, sans-serif';
            ctx.textAlign = 'center';
            ctx.lineWidth = Math.max(2, fs * 0.18);
            ctx.lineJoin = 'round';
            ctx.strokeStyle = this.halo();
            ctx.strokeText(it.v, p.x, p.y + r + fs * 0.9);
            ctx.fillStyle = light ? '#131314' : '#F4F4F5';
            ctx.fillText(it.v, p.x, p.y + r + fs * 0.9);
        }
        ctx.textAlign = 'left';
    };

    /* Agentes ao vivo, só no modo mapa. */
    BoardRenderer.prototype.drawUnits = function () {
        if (!this.isMap() || !this.units.length) { return; }
        var ctx = this.ctx, u = this.unit();
        for (var i = 0; i < this.units.length; i++) {
            var un = this.units[i];
            var p = this.worldToCanvas(un.x, un.y);
            if (p.x < -40 || p.y < -40 || p.x > this.canvas.width + 40 || p.y > this.canvas.height + 40) { continue; }

            ctx.beginPath();
            ctx.arc(p.x, p.y, 15 * u, 0, Math.PI * 2);
            ctx.fillStyle = un.me ? '#34C77B' : '#1F5EFF';
            ctx.fill();
            ctx.lineWidth = 4 * u;
            ctx.strokeStyle = '#FFFFFF';
            ctx.stroke();

            var fs = 24 * u;
            ctx.font = '700 ' + fs + 'px Inter, "Segoe UI", Arial, sans-serif';
            ctx.textAlign = 'center';
            ctx.lineWidth = Math.max(2, fs * 0.18);
            ctx.lineJoin = 'round';
            ctx.strokeStyle = 'rgba(0,0,0,.75)';
            ctx.strokeText(un.n, p.x, p.y - 24 * u);
            ctx.fillStyle = '#FFFFFF';
            ctx.fillText(un.n, p.x, p.y - 24 * u);
            ctx.textAlign = 'left';
        }
    };

    /* ── Render ─────────────────────────────────────────────── */
    BoardRenderer.prototype.render = function () {
        var ctx = this.ctx, W = this.canvas.width, H = this.canvas.height;
        ctx.setTransform(1, 0, 0, 1, 0, 0);
        ctx.clearRect(0, 0, W, H);

        if (!this.doc) {
            ctx.fillStyle = '#0A0A0B';
            ctx.fillRect(0, 0, W, H);
            this.dirty = false;
            return;
        }

        if (this.mapPending()) {
            /* Documento em modo mapa mas ainda sem projecção: mostra
               que está à espera em vez de rebentar a desenhar. */
            ctx.fillStyle = '#0B1220';
            ctx.fillRect(0, 0, W, H);
            ctx.fillStyle = 'rgba(244,244,245,.55)';
            ctx.font = '700 ' + (34 * this.unit()) + 'px Inter, "Segoe UI", Arial, sans-serif';
            ctx.textAlign = 'center';
            ctx.fillText(this.loadingText || 'loading the map...', W / 2, H / 2);
            ctx.textAlign = 'left';
            this.dirty = false;
            return;
        }

        if (this.isMap()) { this.drawMap(); } else { this.drawWhiteboard(); }

        var layer = this.layer();
        if (layer) {
            for (var i = 0; i < layer.items.length; i++) { this.drawItem(layer.items[i]); }
        }
        this.drawUnits();
        if (this.ghost) { this.drawItem(this.ghost); }

        if (this.selection) {
            var s = this.selection, u = this.unit();
            ctx.setLineDash([12 * u, 8 * u]);
            ctx.lineWidth = 3 * u;
            ctx.strokeStyle = '#1F5EFF';
            ctx.strokeRect(s.x, s.y, s.w, s.h);
            ctx.setLineDash([]);
            ctx.fillStyle = 'rgba(31,94,255,.12)';
            ctx.fillRect(s.x, s.y, s.w, s.h);
        }

        /* Anel do pincel: mostra a grossura e a cor no sítio onde o
           traço vai sair, antes de se carregar. Sem isto escolhia-se
           a espessura às cegas. */
        if (this.cursor) {
            var cu = this.cursor, cur = this.unit();
            var rad = Math.max(4 * cur, (cu.w || 6) * cur / 2);
            ctx.beginPath();
            ctx.arc(cu.x, cu.y, rad, 0, Math.PI * 2);
            ctx.lineWidth = 3 * cur;
            ctx.strokeStyle = 'rgba(0,0,0,.45)';
            ctx.stroke();
            ctx.lineWidth = 1.6 * cur;
            ctx.strokeStyle = cu.color || '#1F5EFF';
            ctx.stroke();
        }

        /* Realce do item agarrado pela ferramenta de mover. */
        if (this.selectedId) {
            var sel = this.findItem(this.selectedId);
            if (sel) {
                var bb = this.itemBounds(sel), uu = this.unit();
                ctx.setLineDash([9 * uu, 6 * uu]);
                ctx.lineWidth = 2.5 * uu;
                ctx.strokeStyle = '#1F5EFF';
                ctx.strokeRect(bb.x, bb.y, bb.w, bb.h);
                ctx.setLineDash([]);
                /* Pegas nos cantos: puxa-se por aqui para redimensionar.
                   O tamanho tem de bater com a área de agarrar do
                   editor (14 px), senão vê-se uma pega onde não se
                   consegue pegar. */
                var hs = 18 * uu;
                [[bb.x, bb.y], [bb.x + bb.w, bb.y],
                 [bb.x, bb.y + bb.h], [bb.x + bb.w, bb.y + bb.h]]
                    .forEach(function (c) {
                        ctx.fillStyle = '#FFFFFF';
                        ctx.fillRect(c[0] - hs / 2, c[1] - hs / 2, hs, hs);
                        ctx.fillStyle = '#1F5EFF';
                        ctx.fillRect(c[0] - hs / 2 + 3 * uu, c[1] - hs / 2 + 3 * uu,
                                     hs - 6 * uu, hs - 6 * uu);
                    });
            } else {
                this.selectedId = null;
            }
        }

        this.dirty = false;
    };

    /* ── Apagar: o que está debaixo do ponto? ───────────────── */
    BoardRenderer.prototype.hitTest = function (px, py, radiusPx) {
        var layer = this.layer();
        if (!layer) { return []; }
        var r = radiusPx || 18 * this.unit();
        var hits = [];

        for (var i = layer.items.length - 1; i >= 0; i--) {
            var it = layer.items[i];
            if (this.itemHit(it, px, py, r)) { hits.push(it.id); }
        }
        return hits;
    };

    function distToSegment(px, py, ax, ay, bx, by) {
        var dx = bx - ax, dy = by - ay;
        var len2 = dx * dx + dy * dy;
        var t = len2 ? ((px - ax) * dx + (py - ay) * dy) / len2 : 0;
        t = clamp(t, 0, 1);
        var qx = ax + t * dx, qy = ay + t * dy;
        return Math.hypot(px - qx, py - qy);
    }

    BoardRenderer.prototype.itemHit = function (it, px, py, r) {
        var a, b, i, p, q;
        var pad = r + (it.w || 6) * this.unit() * 0.5;

        if (it.t === 'stroke') {
            if (!it.p || it.p.length < 4) { return false; }
            p = this.toCanvas(it.p[0], it.p[1]);
            for (i = 2; i < it.p.length; i += 2) {
                q = this.toCanvas(it.p[i], it.p[i + 1]);
                if (distToSegment(px, py, p.x, p.y, q.x, q.y) <= pad) { return true; }
                p = q;
            }
            return false;
        }
        if (it.t === 'line' || it.t === 'arrow' || it.t === 'ruler') {
            a = this.toCanvas(it.ax, it.ay);
            b = this.toCanvas(it.bx, it.by);
            return distToSegment(px, py, a.x, a.y, b.x, b.y) <= pad;
        }
        if (it.t === 'rect' || it.t === 'ellipse') {
            a = this.toCanvas(it.ax, it.ay);
            b = this.toCanvas(it.bx, it.by);
            var x1 = Math.min(a.x, b.x) - pad, x2 = Math.max(a.x, b.x) + pad;
            var y1 = Math.min(a.y, b.y) - pad, y2 = Math.max(a.y, b.y) + pad;
            if (px < x1 || px > x2 || py < y1 || py > y2) { return false; }
            if (it.fill) { return true; }
            /* Só o contorno conta quando não está preenchido, senão
               apagava-se sem querer ao passar pelo meio. */
            var inX = px > x1 + pad * 2 && px < x2 - pad * 2;
            var inY = py > y1 + pad * 2 && py < y2 - pad * 2;
            return !(inX && inY);
        }
        if (it.t === 'text') {
            p = this.toCanvas(it.x, it.y);
            var size = (it.s || 44) * this.unit();
            var w = size * 0.58 * (it.v || '').length;
            return px >= p.x - pad && px <= p.x + w + pad
                && py >= p.y - size * 0.7 - pad && py <= p.y + size * 0.7 + pad;
        }
        if (it.t === 'icon') {
            p = this.toCanvas(it.x, it.y);
            return Math.hypot(px - p.x, py - p.y) <= 44 * this.unit() * (it.sc || 1) + r;
        }
        return false;
    };

    global.BoardRenderer = BoardRenderer;
    global.BOARD_BASE_W = BASE_W;
}(window));
