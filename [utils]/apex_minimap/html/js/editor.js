/* ============================================================
   Apex Minimap Studio â€” editor.js
   ------------------------------------------------------------
   The atlas canvas engine.

   Model
   Â· The map atlas is rowsÃ—cols tiles of tileSize px (full res
     4096Ã—6144). Editing happens at HALF resolution (EDIT space,
     2048Ã—3072) â€” light enough for CEF, and the export composes
     back at full resolution from the same scene.
   Â· base       â€” the original tile PNGs (never touched)
   Â· styledBase â€” base with the theme (filter + tint) baked in;
     recomputed only when the theme changes so the per-frame
     draw stays cheap
   Â· paint      â€” ONE raster canvas for brush / eraser / fill
   Â· objects[]  â€” text / shape / zone / image items, drawn on
     top, each movable & editable (the "layers" in the dock)

   Everything visual funnels through drawScene(ctx): the view,
   the live tile preview and the export all render the exact
   same scene at different transforms.
   ============================================================ */
'use strict';

window.Editor = (function () {

    const cfg = () => App.state.config;

    /* â”€â”€ dimensions â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ */
    let ROWS = 3, COLS = 2, FULL_TILE = 2048;
    let EDIT_TILE = 1024;                  // edit-space tile size
    let AW = 2048, AH = 3072;              // edit-space atlas size

    /* â”€â”€ scene state â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ */
    const base = document.createElement('canvas');
    const styledBase = document.createElement('canvas');
    let baseReady = false;

    // Brush / eraser / fill paint into REAL layers: every paint layer is
    // an object of type 'paint' carrying its own full-size canvas, drawn
    // in stack order with the vector objects. That is what makes the
    // Layers panel reflect painting (clothing parity).
    function makePaintCanvas() {
        const cv = document.createElement('canvas');
        cv.width = AW; cv.height = AH;
        return cv;
    }

    let objects = [];          // topmost LAST
    let nextObjId = 1;
    let selectedId = null;

    const theme = { hue: 0, sat: 100, bri: 100, con: 100, tint: '#1F5EFF', tintAmt: 0, preset: 'original' };

    // â”€â”€ Postal codes â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    // A dataset of world-space points drawn on top of the map (and
    // baked into the export), plus an optional in-game /gps script
    // bundled into the exported resource. Per-code style overrides
    // let one postal look different from the rest.
    // Shipped look of a postal code. Kept as its own frozen constant so
    // the Reset button can restore it without re-typing the values.
    const POSTAL_STYLE_DEFAULTS = Object.freeze({
        color: '#FFFFFF', opacity: 100, font: 'Outfit', size: 22,
        outline: true, outlineColor: '#0A0A0B', outlineWidth: 2,
        shadow: true, shadowColor: '#000000', shadowBlur: 3, shadowOffset: 1,
    });

    const postals = {
        enabled: false,
        ingameScript: true,
        setName: 'New',
        points: [],          // { code, x, y } world coords
        // Deslocamento do CONJUNTO INTEIRO, em unidades de mundo. Os
        // conjuntos prontos (OCRP / New / Oulsen) foram feitos para mapas
        // diferentes e caem quase sempre uns metros ao lado; em vez de
        // corrigir 1687 pontos à mão, alinha-se o conjunto todo de uma vez.
        // Vai no projeto e no export, por isso alinha-se uma vez e fica.
        offset: { x: 0, y: 0 },
        style: Object.assign({}, POSTAL_STYLE_DEFAULTS),
        overrides: {},       // code -> partial style
    };

    // ── Map extensions ──────────────────────────────────────────
    // Mapas como Roxwood ficam FORA da caixa onde o jogo deixa o
    // jogador andar: sem `ExtendWorldBoundaryForPlayer` bate-se numa
    // parede invisível antes de lá chegar. Uma extensão é um retângulo
    // em coordenadas de MUNDO que o estúdio mostra sobre o atlas (para
    // se desenhar a zona no sítio certo) e que o export transforma num
    // `extensions.lua` dentro do resource gerado.
    let extensions = [];     // { id, name, x1, y1, x2, y2, z, bounds, blip }
    let nextExtId = 1;

    /* â”€â”€ view state â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ */
    const wrap = () => document.getElementById('canvas-wrap');
    const viewCv = () => document.getElementById('view-canvas');
    const overlayCv = () => document.getElementById('overlay-canvas');

    let zoom = 0.2, panX = 0, panY = 0;
    let showTiles = true, showGrid = false;
    let currentMap = 'original';
    let currentMapObj = null;

    /* â”€â”€ tool state â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ */
    let tool = 'pan';
    const brush = { size: 14, color: '#FFFFFF', opacity: 1, mode: 'normal' };
    const shapeOpts = { kind: 'rect', stroke: '#FFFFFF', width: 6, fill: false, fillColor: '#1F5EFF' };
    const zoneOpts = { kind: 'rect', color: '#1F5EFF', opacity: 0.35, stroke: true };
    const textOpts = { font: 'Inter', size: 64, color: '#FFFFFF', bold: true, upper: true };
    const fillOpts = { tolerance: 32 };

    // â”€â”€ Blip creator â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    // Curated GTA blip sprites/colours. `glyph` is the Font Awesome 6
    // solid unicode drawn on the canvas marker; `id` is the real GTA
    // sprite/colour id used by the exported in-game blip script.
    const BLIP_SPRITES = [
        { id: 1,   glyph: 'ï…', name: 'Pin' },
        { id: 161, glyph: 'ï›', name: 'Target' },
        { id: 431, glyph: 'ï”¡', name: 'Crown' },
        { id: 480, glyph: 'ï•Œ', name: 'Skull' },
        { id: 280, glyph: 'ï…•', name: 'Cash' },
        { id: 357, glyph: 'ïƒ€', name: 'Gang' },
        { id: 361, glyph: 'ï”¯', name: 'Gas' },
        { id: 357, glyph: 'ï’”', name: 'Garage', key: 'garage' },
        { id: 52,  glyph: 'ïº', name: 'Store' },
        { id: 110, glyph: 'î†›', name: 'Weapons' },
        { id: 225, glyph: 'ï†¹', name: 'Vehicle' },
        { id: 40,  glyph: 'ï€•', name: 'House' },
        { id: 84,  glyph: 'ïƒ„', name: 'Barber' },
        { id: 267, glyph: 'ï”³', name: 'Heli' },
    ];
    const BLIP_COLORS = [
        { id: 0,  hex: '#FFFFFF', name: 'White' },
        { id: 1,  hex: '#E03A3A', name: 'Red' },
        { id: 2,  hex: '#4CAF50', name: 'Green' },
        { id: 3,  hex: '#3B78E7', name: 'Blue' },
        { id: 5,  hex: '#F2C230', name: 'Yellow' },
        { id: 17, hex: '#E8760E', name: 'Orange' },
        { id: 83, hex: '#8E44AD', name: 'Purple' },
        { id: 8,  hex: '#F06EAA', name: 'Pink' },
        { id: 48, hex: '#19B5A5', name: 'Teal' },
        { id: 40, hex: '#7C7C82', name: 'Grey' },
    ];
    // assign Font Awesome 6 solid unicodes by index (kept as codepoints
    // so the source stays plain ASCII)
    const BLIP_GLYPHS = [0xf3c5, 0xf05b, 0xf521, 0xf54c, 0xf155, 0xf0c0, 0xf52f, 0xf494, 0xf07a, 0xe19b, 0xf1b9, 0xf015, 0xf0c4, 0xf533];
    BLIP_SPRITES.forEach((s, i) => { s.glyph = String.fromCharCode(BLIP_GLYPHS[i] || 0xf3c5); });
    BLIP_SPRITES.forEach((s) => { s.custom = true; });
    const blipOpts = { sprite: 1, glyph: String.fromCharCode(0xf3c5), img: null, color: 1, colorHex: '#E03A3A', size: 46 };

    // â”€â”€ Real GTA blip catalogue â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    // html/js/blipdata.js sets window.APEX_BLIPS = [id, name, file], scraped
    // from the FiveM docs, with every sprite bundled in html/blips/.
    // Bundled ON PURPOSE:
    // drawing a cross-origin image into the atlas would taint the canvas and
    // make toDataURL() throw â€” which would break Export AND the PNG save.
    let BLIP_CATALOGUE = null;   // null = not read yet (lazy, see blipCatalogue)
    const blipImgCache = new Map();

    // A blip sprite is either a bundled file name or, for a user-supplied
    // marker, a full data: URL. Anything already absolute is used as-is.
    function blipSrc(file) {
        return /^(data:|blob:|https?:)/i.test(file) ? file : 'blips/' + file;
    }

    // Returns a ready-to-draw Image, or null while it loads / if it failed.
    function blipImage(file) {
        if (!file) { return null; }
        if (blipImgCache.has(file)) {
            const c = blipImgCache.get(file);
            return (c && c.complete && c.naturalWidth) ? c : null;
        }
        const img = new Image();
        blipImgCache.set(file, img);
        img.onload = () => requestDraw();
        img.onerror = () => blipImgCache.set(file, null);
        img.src = blipSrc(file);
        return null;
    }

    // The catalogue ships as html/js/blipdata.js (window.APEX_BLIPS), NOT as a
    // fetched .json: html/js/*.js is already served, so there is no new glob
    // that can silently 404 and leave the picker showing only the 14 custom
    // markers â€” which is exactly what happened with the fetch version.
    // Read lazily on first use so script ORDER can never matter: whether the
    // picker opens before or after boot, it always sees the full catalogue.
    function blipCatalogue() {
        if (BLIP_CATALOGUE) { return BLIP_CATALOGUE; }
        const raw = (typeof window !== 'undefined' && window.APEX_BLIPS) || null;
        BLIP_CATALOGUE = Array.isArray(raw)
            ? raw.map(r => ({ id: r[0], name: r[1], file: r[2] }))
            : [];
        return BLIP_CATALOGUE;
    }

    /* â”€â”€ listeners (panels.js subscribes) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ */
    const listeners = {};
    function emit(ev, data) { (listeners[ev] || []).forEach(fn => fn(data)); }
    function onEvent(ev, fn) { (listeners[ev] = listeners[ev] || []).push(fn); }

    /* â•â•â•â•â•â•â•â• THEME â•â•â•â•â•â•â•â• */

    function themeFilter() {
        return `hue-rotate(${theme.hue}deg) saturate(${theme.sat}%) brightness(${theme.bri}%) contrast(${theme.con}%)`;
    }

    /* ── mips da vista ─────────────────────────────────────────
       O atlas tem 2048×3072 (6 MP) e a vista normal está a ~30% de
       zoom. Redesenhar 6 MP com suavização a cada frame é o que fazia
       o estúdio arrastar-se em jogo. Guardamos duas reduções e a vista
       usa a que chega para o zoom actual — o export e a pré-visualização
       continuam a compor a partir do original, em resolução plena. */
    const mip2 = document.createElement('canvas');
    const mip4 = document.createElement('canvas');

    function rebuildMips() {
        mip2.width = Math.max(1, AW >> 1); mip2.height = Math.max(1, AH >> 1);
        const c2 = mip2.getContext('2d');
        c2.clearRect(0, 0, mip2.width, mip2.height);
        c2.drawImage(styledBase, 0, 0, mip2.width, mip2.height);
        mip4.width = Math.max(1, AW >> 2); mip4.height = Math.max(1, AH >> 2);
        const c4 = mip4.getContext('2d');
        c4.clearRect(0, 0, mip4.width, mip4.height);
        c4.drawImage(mip2, 0, 0, mip4.width, mip4.height);
    }

    // O mesmo para cada camada de pintura, refeito só quando o traço acaba.
    function paintMip(o) {
        if (!o.cv) { return null; }
        const rev = o.rev || 0;
        const w = Math.max(1, AW >> 1), h = Math.max(1, AH >> 1);
        if (!o._mip || o._mipRev !== rev || o._mip.width !== w || o._mip.height !== h) {
            if (!o._mip) { o._mip = document.createElement('canvas'); }
            o._mip.width = w; o._mip.height = h;
            const c = o._mip.getContext('2d');
            c.clearRect(0, 0, w, h);
            c.drawImage(o.cv, 0, 0, w, h);
            o._mipRev = rev;
        }
        return o._mip;
    }

    /* ── base em ALTA RESOLUÇÃO (sob demanda) ──────────────────
       O editor trabalha a 1024 px por tile: o atlas inteiro cabe em
       2048×3072, que é o que o CEF aguenta com camadas de pintura por
       cima. Só que os PNGs em html/tiles/ são de 2048 — ao aproximar,
       mostrava-se METADE da resolução que já estava no disco, e o mapa
       parecia desfocado.

       Estas cópias "hi" trazem o tile na resolução completa, com o tema
       já aplicado. São construídas apenas para os tiles VISÍVEIS e só
       quando o zoom o justifica; quando se afasta, são libertadas. Um
       tile custa 16 MB, por isso o limite é rígido. */
    const HI_TILE = 2048;
    const HI_MAX = 4;
    const hiTiles = new Map();     // chave -> { cv, used } | 'pending'
    let themeRev = 0;              // sobe sempre que o tema muda

    function hiKey(r, c) { return `${currentMap}|${themeRev}|${r}_${c}`; }

    function hiEvict() {
        if (hiTiles.size <= HI_MAX) { return; }
        const live = [];
        for (const [k, v] of hiTiles) {
            if (v === 'pending') { continue; }
            if (k.indexOf(`${currentMap}|${themeRev}|`) !== 0) { hiTiles.delete(k); continue; }
            live.push([k, v]);
        }
        live.sort((a, b) => a[1].used - b[1].used);
        while (hiTiles.size > HI_MAX && live.length) {
            const [k, v] = live.shift();
            if (v.cv) { v.cv.width = 0; v.cv.height = 0; }
            hiTiles.delete(k);
        }
    }

    function buildHiTile(r, c) {
        const key = hiKey(r, c);
        return new Promise((resolve) => {
            const img = new Image();
            img.onload = () => {
                const cv = document.createElement('canvas');
                cv.width = HI_TILE; cv.height = HI_TILE;
                const cx = cv.getContext('2d');
                cx.filter = themeFilter();
                cx.drawImage(img, 0, 0, HI_TILE, HI_TILE);
                cx.filter = 'none';
                if (theme.tintAmt > 0) {
                    cx.globalCompositeOperation = 'source-atop';
                    cx.globalAlpha = theme.tintAmt / 100;
                    cx.fillStyle = theme.tint;
                    cx.fillRect(0, 0, HI_TILE, HI_TILE);
                    cx.globalAlpha = 1;
                    cx.globalCompositeOperation = 'source-over';
                }
                hiTiles.set(key, { cv, used: Date.now() });
                hiEvict();
                resolve(cv);
            };
            img.onerror = () => { hiTiles.delete(key); resolve(null); };
            img.src = `tiles/${currentMap}/minimap_${r}_${c}.png`;
        });
    }

    // versão para a VISTA: nunca bloqueia — devolve o que já existe e
    // manda construir o que falta, repintando quando chegar
    function getHiTile(r, c) {
        const key = hiKey(r, c);
        const hit = hiTiles.get(key);
        if (hit && hit !== 'pending') { hit.used = Date.now(); return hit.cv; }
        if (hit === 'pending') { return null; }
        hiTiles.set(key, 'pending');
        buildHiTile(r, c).then((cv) => { if (cv) { requestDraw(); } });
        return null;
    }

    // versão para o EXPORT: espera, porque aí a qualidade é o objetivo
    async function ensureHiTile(r, c) {
        const key = hiKey(r, c);
        const hit = hiTiles.get(key);
        if (hit && hit !== 'pending') { hit.used = Date.now(); return hit.cv; }
        hiTiles.set(key, 'pending');
        return buildHiTile(r, c);
    }

    function dropHiTiles() {
        for (const [, v] of hiTiles) { if (v !== 'pending' && v.cv) { v.cv.width = 0; v.cv.height = 0; } }
        hiTiles.clear();
    }

    function recomputeStyledBase() {
        themeRev++;                 // as cópias em alta ficam velhas
        dropHiTiles();
        const ctx = styledBase.getContext('2d');
        ctx.clearRect(0, 0, AW, AH);
        ctx.filter = themeFilter();
        ctx.drawImage(base, 0, 0);
        ctx.filter = 'none';
        if (theme.tintAmt > 0) {
            // tint only where the map has pixels (keep transparency)
            ctx.globalCompositeOperation = 'source-atop';
            ctx.globalAlpha = theme.tintAmt / 100;
            ctx.fillStyle = theme.tint;
            ctx.fillRect(0, 0, AW, AH);
            ctx.globalAlpha = 1;
            ctx.globalCompositeOperation = 'source-over';
        }
        rebuildMips();
        requestDraw();
        schedulePreview();
        markDirty();
    }

    function setTheme(patch, preset) {
        Object.assign(theme, patch || {});
        theme.preset = preset || 'custom';
        recomputeStyledBase();
        emit('theme', theme);
    }

    /* â•â•â•â•â•â•â•â• SCENE DRAW â•â•â•â•â•â•â•â• */

    function fontFamily(name) {
        return `'${name}', Inter, sans-serif`;
    }

    function drawObject(ctx, o) {
        ctx.save();
        ctx.globalAlpha = (o.opacity != null ? o.opacity : 1);
        ctx.translate(o.x + o.w / 2, o.y + o.h / 2);
        if (o.rot) { ctx.rotate(o.rot * Math.PI / 180); }
        ctx.translate(-o.w / 2, -o.h / 2);

        if (o.type === 'zone') {
            ctx.fillStyle = o.color;
            ctx.globalAlpha = (o.opacity != null ? o.opacity : 0.35);
            if (o.kind === 'poly' && Array.isArray(o.pts) && o.pts.length >= 3) {
                // points are stored normalized (0..1) to the bbox so they
                // scale with the handles like every other object
                ctx.beginPath();
                o.pts.forEach((pt, i) => {
                    const X = pt.x * o.w, Y = pt.y * o.h;
                    if (i === 0) { ctx.moveTo(X, Y); } else { ctx.lineTo(X, Y); }
                });
                ctx.closePath();
                ctx.fill();
                if (o.stroke) {
                    ctx.globalAlpha = Math.min(1, (o.opacity || 0.35) + 0.35);
                    ctx.lineWidth = 3;
                    ctx.strokeStyle = o.color;
                    ctx.stroke();
                }
            } else if (o.kind === 'ellipse') {
                ctx.beginPath();
                ctx.ellipse(o.w / 2, o.h / 2, o.w / 2, o.h / 2, 0, 0, Math.PI * 2);
                ctx.fill();
                if (o.stroke) {
                    ctx.globalAlpha = Math.min(1, (o.opacity || 0.35) + 0.35);
                    ctx.lineWidth = 3;
                    ctx.strokeStyle = o.color;
                    ctx.stroke();
                }
            } else {
                const r = Math.min(24, o.w / 6, o.h / 6);
                roundRectPath(ctx, 0, 0, o.w, o.h, r);
                ctx.fill();
                if (o.stroke) {
                    ctx.globalAlpha = Math.min(1, (o.opacity || 0.35) + 0.35);
                    ctx.lineWidth = 3;
                    ctx.strokeStyle = o.color;
                    ctx.stroke();
                }
            }
            if (o.label) {
                ctx.globalAlpha = 1;
                ctx.fillStyle = o.labelColor || '#FFFFFF';
                ctx.font = `700 ${Math.max(18, Math.min(o.w / 8, 40))}px ${fontFamily('Inter')}`;
                ctx.textAlign = 'center';
                ctx.textBaseline = 'middle';
                ctx.fillText(o.label.toUpperCase(), o.w / 2, o.h / 2);
            }
        } else if (o.type === 'text') {
            const txt = o.upper ? String(o.text || '').toUpperCase() : String(o.text || '');
            ctx.fillStyle = o.color;
            ctx.font = `${o.bold ? 700 : 400} ${o.size}px ${fontFamily(o.font)}`;
            ctx.textAlign = 'left';
            ctx.textBaseline = 'top';
            if (o.outline) {
                ctx.lineWidth = Math.max(2, o.size / 12);
                ctx.strokeStyle = o.outlineColor || '#0A0A0B';
                ctx.strokeText(txt, 0, 0);
            }
            ctx.fillText(txt, 0, 0);
        } else if (o.type === 'shape') {
            ctx.lineWidth = o.width;
            ctx.strokeStyle = o.stroke;
            ctx.fillStyle = o.fillColor;
            if (o.kind === 'ellipse') {
                ctx.beginPath();
                ctx.ellipse(o.w / 2, o.h / 2, Math.max(1, o.w / 2), Math.max(1, o.h / 2), 0, 0, Math.PI * 2);
                if (o.fill) { ctx.fill(); }
                ctx.stroke();
            } else if (o.kind === 'line' || o.kind === 'arrow') {
                ctx.beginPath();
                ctx.moveTo(0, 0);
                ctx.lineTo(o.w, o.h);
                ctx.stroke();
                if (o.kind === 'arrow') {
                    const ang = Math.atan2(o.h, o.w);
                    const hl = Math.max(12, o.width * 3);
                    ctx.beginPath();
                    ctx.moveTo(o.w, o.h);
                    ctx.lineTo(o.w - hl * Math.cos(ang - 0.45), o.h - hl * Math.sin(ang - 0.45));
                    ctx.moveTo(o.w, o.h);
                    ctx.lineTo(o.w - hl * Math.cos(ang + 0.45), o.h - hl * Math.sin(ang + 0.45));
                    ctx.stroke();
                }
            } else {
                if (o.fill) { ctx.fillRect(0, 0, o.w, o.h); }
                ctx.strokeRect(0, 0, o.w, o.h);
            }
        } else if (o.type === 'image' && o.img) {
            ctx.drawImage(o.img, 0, 0, o.w, o.h);
        } else if (o.type === 'blip') {
            const R = o.w / 2;
            const sprite = o.img ? blipImage(o.img) : null;
            if (sprite) {
                // Real GTA sprite. The chosen blip colour is what the exported
                // script applies in game, so show it as a ring â€” the sprite
                // artwork itself carries its own colours.
                if (o.colorHex) {
                    ctx.beginPath();
                    ctx.arc(o.w / 2, o.h / 2, R * 0.96, 0, Math.PI * 2);
                    ctx.strokeStyle = o.colorHex;
                    ctx.lineWidth = Math.max(2, R * 0.13);
                    ctx.stroke();
                }
                ctx.drawImage(sprite, 0, 0, o.w, o.h);
            } else {
                ctx.beginPath();
                ctx.arc(o.w / 2, o.h / 2, R, 0, Math.PI * 2);
                ctx.fillStyle = o.colorHex || '#E03A3A';
                ctx.fill();
                ctx.lineWidth = Math.max(2, R * 0.12);
                ctx.strokeStyle = 'rgba(0,0,0,.5)';
                ctx.stroke();
                if (o.glyph) {
                    ctx.fillStyle = '#fff';
                    ctx.font = `900 ${R}px "Font Awesome 6 Free"`;
                    ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
                    ctx.fillText(o.glyph, o.w / 2, o.h / 2 + R * 0.02);
                }
            }
            if (o.label) {
                ctx.font = `700 ${R * 0.72}px 'Inter', sans-serif`;
                ctx.textAlign = 'center'; ctx.textBaseline = 'top';
                ctx.lineWidth = R * 0.18;
                ctx.strokeStyle = 'rgba(0,0,0,.75)';
                ctx.strokeText(o.label, o.w / 2, o.h + 3);
                ctx.fillStyle = '#fff';
                ctx.fillText(o.label, o.w / 2, o.h + 3);
            }
        }
        ctx.restore();
    }

    function roundRectPath(ctx, x, y, w, h, r) {
        ctx.beginPath();
        ctx.moveTo(x + r, y);
        ctx.arcTo(x + w, y, x + w, y + h, r);
        ctx.arcTo(x + w, y + h, x, y + h, r);
        ctx.arcTo(x, y + h, x, y, r);
        ctx.arcTo(x, y, x + w, y, r);
        ctx.closePath();
    }

    // world â†’ edit-atlas pixel (uses the config world bounds)
    function worldToPixel(wx, wy) {
        const wb = cfg().worldBounds || { left: -4137.4, top: 8397.6, right: 4860.5, bottom: -5099.4 };
        return {
            x: (wx - wb.left) / (wb.right - wb.left) * AW,
            y: (wy - wb.top) / (wb.bottom - wb.top) * AH,
        };
    }
    // edit-atlas pixel â†’ world (for placing/importing)
    function pixelToWorld(px, py) {
        const wb = cfg().worldBounds || { left: -4137.4, top: 8397.6, right: 4860.5, bottom: -5099.4 };
        return {
            x: wb.left + (px / AW) * (wb.right - wb.left),
            y: wb.top + (py / AH) * (wb.bottom - wb.top),
        };
    }

    /* Os conjuntos prontos têm até 1687 códigos, e desenhar 1687 textos com
       contorno E sombra a cada frame é caro. A primeira tentativa foi uma
       cache em bitmap do tamanho do atlas — mas isso desenha o texto UMA vez
       à resolução do atlas e depois reduz o bitmap, o que borrata e desloca
       os números meio pixel. Aqui a solução certa é outra: desenhar sempre
       texto a sério (nítido, igual ao que sai no export) mas SÓ os códigos
       que estão dentro do que se vê. Fica mais rápido do que a cache e sem
       um único pixel fora do sítio. */
    function invalidatePostals() { /* nada a invalidar: já não há cache */ }

    function drawPostals(ctx, clip, layerAlpha) {
        if (!postals.enabled || !postals.points.length) { return; }
        const la = layerAlpha != null ? layerAlpha : 1;
        if (la <= 0) { return; }
        const base = postals.style;
        ctx.save();
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        const off = postals.offset || { x: 0, y: 0 };
        for (const p of postals.points) {
            const st = postals.overrides[p.code] ? Object.assign({}, base, postals.overrides[p.code]) : base;
            const pt = worldToPixel(p.x + off.x, p.y + off.y);
            if (pt.x < -50 || pt.y < -50 || pt.x > AW + 50 || pt.y > AH + 50) { continue; }
            // fora do que se vê não se desenha (o export não passa clip)
            if (clip && (pt.x < clip.x0 || pt.x > clip.x1 || pt.y < clip.y0 || pt.y > clip.y1)) { continue; }
            ctx.globalAlpha = ((st.opacity != null ? st.opacity : 100) / 100) * la;
            ctx.font = `700 ${st.size}px '${st.font}', 'Inter', sans-serif`;
            if (st.shadow) {
                ctx.shadowColor = st.shadowColor || '#000';
                ctx.shadowBlur = st.shadowBlur || 0;
                ctx.shadowOffsetX = st.shadowOffset || 0;
                ctx.shadowOffsetY = st.shadowOffset || 0;
            } else {
                ctx.shadowColor = 'transparent'; ctx.shadowBlur = 0;
                ctx.shadowOffsetX = 0; ctx.shadowOffsetY = 0;
            }
            const label = String(p.code);
            if (st.outline && st.outlineWidth > 0) {
                ctx.lineWidth = st.outlineWidth;
                ctx.strokeStyle = st.outlineColor || '#000';
                ctx.lineJoin = 'round';
                ctx.strokeText(label, pt.x, pt.y);
            }
            // the fill must not inherit the outline's shadow twice
            ctx.shadowColor = st.shadow ? (st.shadowColor || '#000') : 'transparent';
            ctx.fillStyle = st.color || '#FFF';
            ctx.fillText(label, pt.x, pt.y);
        }
        ctx.restore();
    }

    // Draw the WHOLE scene in edit-space coordinates.
    function drawScene(ctx, opts) {
        opts = opts || {};
        if (opts.overlayOnly) {
            /* Export nativo: a BASE fica de fora — o make_ytd vai buscá-la
               diretamente ao template .ytd na resolução nativa (4096), sem
               nenhum reamostrar. Aqui só sai a pilha por cima (pinturas,
               objetos, postais) sobre fundo transparente. */
        } else if (opts.hi) {
            /* Base tile a tile na resolução completa. O que ainda não
               estiver pronto sai da base normal — nunca se espera pelo
               carregamento a meio de um frame. */
            for (let r = 0; r < ROWS; r++) {
                for (let c = 0; c < COLS; c++) {
                    const dx = c * EDIT_TILE, dy = r * EDIT_TILE;
                    if (opts.clip && (dx + EDIT_TILE < opts.clip.x0 || dx > opts.clip.x1 ||
                                      dy + EDIT_TILE < opts.clip.y0 || dy > opts.clip.y1)) { continue; }
                    const hi = opts.hiReady ? opts.hiReady(r, c) : getHiTile(r, c);
                    if (hi) { ctx.drawImage(hi, dx, dy, EDIT_TILE, EDIT_TILE); }
                    else { ctx.drawImage(styledBase, dx, dy, EDIT_TILE, EDIT_TILE, dx, dy, EDIT_TILE, EDIT_TILE); }
                }
            }
        } else {
            // opts.mip só chega da VISTA; export e preview usam o original
            const src = opts.mip === 4 ? mip4 : (opts.mip === 2 ? mip2 : styledBase);
            ctx.drawImage(src, 0, 0, AW, AH);
        }
        for (const o of objects) {
            if (o.hidden) { continue; }
            // A sprite blip ships as a real in-game blip (blips.lua), so baking
            // it into the tiles too would leave a painted copy sitting under
            // the real one â€” skip it. A CUSTOM-IMAGE blip is the opposite: the
            // game has no sprite id for it, so the only way to see it is to
            // paint it into the map, and getBlips() leaves it out of the script.
            if (o.type === 'blip' && opts.forExport && !o.customImg) { continue; }
            if (o.type === 'paint') {
                ctx.save();
                ctx.globalAlpha = (o.opacity != null ? o.opacity : 1);
                if (o.cv) {
                    const pm = opts.mip ? paintMip(o) : null;
                    if (pm) { ctx.drawImage(pm, 0, 0, AW, AH); }
                    else { ctx.drawImage(o.cv, 0, 0); }
                }
                ctx.restore();
                // the in-progress stroke composites at ITS layer's depth
                if (strokeActive && o === strokeTarget) { compositeStrokePreview(ctx); }
            } else if (o.type === 'postals') {
                // Os códigos postais SÃO uma camada: entram na pilha na
                // posição delas, por isso dá para pôr texto, zonas ou
                // imagens POR CIMA (antes eram sempre desenhados no fim).
                drawPostals(ctx, opts.clip, o.opacity != null ? o.opacity : 1);
            } else {
                drawObject(ctx, o);
            }
        }
        // projeto antigo (ou postais ligados sem camada): desenha na mesma
        if (postals.enabled && !objects.some(o => o.type === 'postals')) {
            drawPostals(ctx, opts.clip, 1);
        }
    }

    /* â•â•â•â•â•â•â•â• VIEW â•â•â•â•â•â•â•â• */

    let drawQueued = false;
    function requestDraw() {
        if (drawQueued) { return; }
        drawQueued = true;
        requestAnimationFrame(() => { drawQueued = false; draw(); });
    }

    /* O buffer da tela tem de acompanhar SEMPRE a caixa que a mostra. Se
       ficar para trás, o CSS estica a imagem e o rato deixa de bater
       certo com o que está desenhado — era o que acontecia sempre que a
       barra de opções da ferramenta abria (48px a menos de altura), o
       rail encolhia ou a janela mudava de tamanho. */
    function resizeView() {
        const w = wrap();
        if (!w) { return; }
        const r = w.getBoundingClientRect();
        const k = dpr();
        const W = Math.max(1, Math.round(r.width * k));
        const H = Math.max(1, Math.round(r.height * k));
        let changed = false;
        for (const cv of [viewCv(), overlayCv()]) {
            if (cv.width !== W || cv.height !== H) {
                cv.width = W; cv.height = H;
                changed = true;
            }
        }
        if (changed) { clampPan(); }
        requestDraw();
    }

    function draw() {
        const cv = viewCv();
        if (!cv) { return; }
        const ctx = cv.getContext('2d');
        ctx.setTransform(1, 0, 0, 1, 0, 0);
        ctx.clearRect(0, 0, cv.width, cv.height);
        if (!baseReady) { return; }
        /* Com a base em alta, o pixel de origem é METADE do de trabalho:
           só se deve desligar a suavização quando se está mesmo a ampliar
           acima da resolução real, senão o mapa fica serrilhado. */
        const hiOn = zoom >= 0.85;
        const eff = zoom * dpr() / (hiOn ? 2 : 1);
        ctx.imageSmoothingEnabled = eff < 1;
        ctx.imageSmoothingQuality = 'high';
        ctx.setTransform(zoom, 0, 0, zoom, panX, panY);
        // a vista escolhe a redução que chega para este zoom e diz que
        // pedaço do atlas está mesmo à vista (recorte dos postais)
        const m = 80 / zoom;
        drawScene(ctx, {
            // a partir de ~85% o ecrã já mostra mais detalhe do que o
            // atlas de trabalho tem: passa-se à base em alta resolução
            hi: zoom >= 0.85,
            mip: zoom <= 0.34 ? 4 : (zoom <= 0.7 ? 2 : 0),
            view: true,
            clip: {
                x0: (-panX / zoom) - m, y0: (-panY / zoom) - m,
                x1: ((cv.width - panX) / zoom) + m, y1: ((cv.height - panY) / zoom) + m,
            },
        });
        drawOverlay();
    }

    /* â”€â”€ cor de chrome da tela â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
       As guias, o marquee e as pegas de selecÃ§Ã£o sÃ£o UI, nÃ£o
       conteÃºdo: vivem na overlay canvas e NUNCA entram no export.
       Por isso seguem o acento do tema em vez de um azul fixo (as
       cores das camadas â€” zonas, formas, tinta â€” nÃ£o seguem: essas
       sÃ£o o desenho do jogador). O valor Ã© lido uma vez e recalculado
       quando o tema muda. */
    let accentRgbCache = null;
    document.addEventListener('apex:theme', () => { accentRgbCache = null; });

    function uiAccent(alpha) {
        if (!accentRgbCache) {
            const raw = getComputedStyle(document.documentElement)
                .getPropertyValue('--brand-rgb').trim();
            accentRgbCache = /^\d/.test(raw) ? raw.split(/\s+/).join(',') : '31,94,255';
        }
        return alpha == null ? `rgb(${accentRgbCache})` : `rgba(${accentRgbCache},${alpha})`;
    }

    function drawOverlay() {
        const cv = overlayCv();
        const ctx = cv.getContext('2d');
        ctx.setTransform(1, 0, 0, 1, 0, 0);
        ctx.clearRect(0, 0, cv.width, cv.height);
        ctx.setTransform(zoom, 0, 0, zoom, panX, panY);

        // tile boundaries
        if (showTiles) {
            ctx.strokeStyle = uiAccent(.5);
            ctx.lineWidth = 1.5 / zoom;
            ctx.setLineDash([8 / zoom, 6 / zoom]);
            for (let r = 0; r <= ROWS; r++) {
                ctx.beginPath(); ctx.moveTo(0, r * EDIT_TILE); ctx.lineTo(AW, r * EDIT_TILE); ctx.stroke();
            }
            for (let c = 0; c <= COLS; c++) {
                ctx.beginPath(); ctx.moveTo(c * EDIT_TILE, 0); ctx.lineTo(c * EDIT_TILE, AH); ctx.stroke();
            }
            ctx.setLineDash([]);
            // tile labels
            ctx.fillStyle = uiAccent(.75);
            ctx.font = `${12 / zoom}px 'JetBrains Mono', monospace`;
            for (let r = 0; r < ROWS; r++) {
                for (let c = 0; c < COLS; c++) {
                    ctx.fillText(`minimap_${r}_${c}`, c * EDIT_TILE + 8 / zoom, r * EDIT_TILE + 18 / zoom);
                }
            }
        }

        // pixel grid (only useful when zoomed in)
        if (showGrid && zoom >= 0.5) {
            const step = 64;   // edit-space px
            ctx.strokeStyle = 'rgba(255,255,255,.07)';
            ctx.lineWidth = 1 / zoom;
            for (let x = 0; x <= AW; x += step) {
                ctx.beginPath(); ctx.moveTo(x, 0); ctx.lineTo(x, AH); ctx.stroke();
            }
            for (let y = 0; y <= AH; y += step) {
                ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(AW, y); ctx.stroke();
            }
        }

        // marquee while dragging out a zone/shape
        if (marquee) {
            ctx.strokeStyle = uiAccent(.9);
            ctx.lineWidth = 1.5 / zoom;
            ctx.setLineDash([6 / zoom, 4 / zoom]);
            ctx.strokeRect(marquee.x, marquee.y, marquee.w, marquee.h);
            ctx.setLineDash([]);
        }

        // custom-zone polygon being drawn corner by corner
        if (polyDraft && polyDraft.length) {
            ctx.save();
            ctx.fillStyle = zoneOpts.color;
            ctx.strokeStyle = zoneOpts.color;
            ctx.lineWidth = 2 / zoom;
            // filled preview
            ctx.globalAlpha = 0.2;
            ctx.beginPath();
            polyDraft.forEach((pt, i) => { i ? ctx.lineTo(pt.x, pt.y) : ctx.moveTo(pt.x, pt.y); });
            if (cursorPos) { ctx.lineTo(cursorPos.x, cursorPos.y); }
            ctx.closePath();
            ctx.fill();
            // edges
            ctx.globalAlpha = 0.95;
            ctx.beginPath();
            polyDraft.forEach((pt, i) => { i ? ctx.lineTo(pt.x, pt.y) : ctx.moveTo(pt.x, pt.y); });
            if (cursorPos) { ctx.lineTo(cursorPos.x, cursorPos.y); }
            ctx.stroke();
            // corner dots (first bigger = close target)
            polyDraft.forEach((pt, i) => {
                ctx.beginPath();
                ctx.fillStyle = i === 0 ? '#fff' : zoneOpts.color;
                ctx.arc(pt.x, pt.y, (i === 0 ? 6 : 4) / zoom, 0, Math.PI * 2);
                ctx.fill();
                if (i === 0) {
                    ctx.lineWidth = 2 / zoom; ctx.strokeStyle = zoneOpts.color;
                    ctx.stroke();
                }
            });
            ctx.restore();
        }

        /* Extensões de mapa: retângulo tracejado + nome, em coordenadas de
           mundo convertidas para o atlas. Vive na overlay, portanto NUNCA
           entra nos tiles exportados — é uma guia de trabalho, não pintura. */
        if (extensions.length) {
            ctx.save();
            for (const e of extensions) {
                const a = worldToPixel(e.x1, e.y1);
                const b = worldToPixel(e.x2, e.y2);
                const x = Math.min(a.x, b.x), y = Math.min(a.y, b.y);
                const w2 = Math.abs(b.x - a.x), h2 = Math.abs(b.y - a.y);
                ctx.setLineDash([10 / zoom, 7 / zoom]);
                ctx.lineWidth = 2 / zoom;
                ctx.strokeStyle = 'rgba(52,199,123,.95)';
                ctx.strokeRect(x, y, w2, h2);
                ctx.setLineDash([]);
                ctx.fillStyle = 'rgba(52,199,123,.10)';
                ctx.fillRect(x, y, w2, h2);
                ctx.fillStyle = 'rgba(52,199,123,1)';
                ctx.font = `700 ${13 / zoom}px ${fontFamily('Inter')}`;
                ctx.textAlign = 'left';
                ctx.textBaseline = 'bottom';
                ctx.fillText(String(e.name || 'Extension'), x + 4 / zoom, y - 5 / zoom);
            }
            ctx.restore();
        }

        // guias de alinhamento (só enquanto o snap está a prender)
        if (snapGuides.length) {
            ctx.strokeStyle = uiAccent(.9);
            ctx.lineWidth = 1 / zoom;
            ctx.setLineDash([6 / zoom, 4 / zoom]);
            for (const g of snapGuides) {
                ctx.beginPath();
                if (g.axis === 'x') { ctx.moveTo(g.at, 0); ctx.lineTo(g.at, AH); }
                else { ctx.moveTo(0, g.at); ctx.lineTo(AW, g.at); }
                ctx.stroke();
            }
            ctx.setLineDash([]);
        }

        // realce do objeto sob o rato (antes de clicar já se sabe qual é)
        const hov = hoverId != null ? getObject(hoverId) : null;
        if (hov && !hov.hidden && hov.id !== selectedId) {
            ctx.save();
            ctx.translate(hov.x + hov.w / 2, hov.y + hov.h / 2);
            if (hov.rot) { ctx.rotate(hov.rot * Math.PI / 180); }
            ctx.translate(-hov.w / 2, -hov.h / 2);
            ctx.strokeStyle = uiAccent(.45);
            ctx.lineWidth = 1 / zoom;
            ctx.strokeRect(0, 0, hov.w, hov.h);
            ctx.restore();
        }

        // selection box + handles
        const sel = getObject(selectedId);
        if (sel && !sel.hidden && sel.type !== 'paint') {
            const editing = textEdit && textEdit.id === sel.id;
            ctx.save();
            ctx.translate(sel.x + sel.w / 2, sel.y + sel.h / 2);
            if (sel.rot) { ctx.rotate(sel.rot * Math.PI / 180); }
            ctx.translate(-sel.w / 2, -sel.h / 2);

            if (editing) {
                drawTextCaret(ctx, sel);
            } else if (sel.locked) {
                ctx.strokeStyle = 'rgba(229,169,60,.85)';
                ctx.lineWidth = 1.5 / zoom;
                ctx.setLineDash([5 / zoom, 4 / zoom]);
                ctx.strokeRect(0, 0, sel.w, sel.h);
                ctx.setLineDash([]);
            } else {
                ctx.strokeStyle = uiAccent(.85);
                ctx.lineWidth = 1.5 / zoom;
                ctx.strokeRect(0, 0, sel.w, sel.h);

                // braço + pega de rotação
                const pts = handlePoints(sel);
                ctx.beginPath();
                ctx.moveTo(sel.w / 2, 0);
                ctx.lineTo(pts.rot.x, pts.rot.y);
                ctx.stroke();
                ctx.beginPath();
                ctx.arc(pts.rot.x, pts.rot.y, 4.5 / zoom, 0, Math.PI * 2);
                ctx.fillStyle = '#fff';
                ctx.fill();
                ctx.lineWidth = 1.5 / zoom;
                ctx.strokeStyle = uiAccent();
                ctx.stroke();

                // pegas: quadrado branco com aro da marca (lêem-se sobre
                // qualquer mapa, ao contrário de um quadrado azul cheio).
                // O desenho acompanha a tolerância real de agarrar — se
                // fosse maior do que ela, apontar-se-ia para o sítio errado.
                const hs = Math.min(7 / zoom, handleSize(sel) * 1.4);
                for (const k of handleKinds(sel)) {
                    const c = pts[k];
                    ctx.fillStyle = '#fff';
                    ctx.fillRect(c.x - hs / 2, c.y - hs / 2, hs, hs);
                    ctx.lineWidth = 1.25 / zoom;
                    ctx.strokeStyle = uiAccent();
                    ctx.strokeRect(c.x - hs / 2, c.y - hs / 2, hs, hs);
                }
            }

            // draggable polygon vertices (round white dots)
            if (sel.type === 'zone' && sel.kind === 'poly' && Array.isArray(sel.pts)) {
                const vr = 5.5 / zoom;
                for (const pt of sel.pts) {
                    ctx.beginPath();
                    ctx.arc(pt.x * sel.w, pt.y * sel.h, vr, 0, Math.PI * 2);
                    ctx.fillStyle = '#fff';
                    ctx.fill();
                    ctx.lineWidth = 2 / zoom;
                    ctx.strokeStyle = uiAccent();
                    ctx.stroke();
                }
            }
            ctx.restore();

            // HUD de medidas enquanto se arrasta (em px de ECRÃ, para se ler
            // na mesma a 6% de zoom)
            if (dragInfo && dragInfo.moved) { drawTransformHud(ctx, sel); }
        }

        // brush cursor
        if ((tool === 'brush' || tool === 'eraser') && cursorPos) {
            ctx.lineWidth = 1 / zoom;
            ctx.strokeStyle = 'rgba(0,0,0,.55)';
            ctx.beginPath();
            ctx.arc(cursorPos.x, cursorPos.y, brush.size / 2 + 1 / zoom, 0, Math.PI * 2);
            ctx.stroke();
            ctx.strokeStyle = tool === 'eraser' ? 'rgba(240,85,109,.95)' : 'rgba(255,255,255,.95)';
            ctx.beginPath();
            ctx.arc(cursorPos.x, cursorPos.y, brush.size / 2, 0, Math.PI * 2);
            ctx.stroke();
        }
    }

    /* Caret + seleção do texto que está a ser escrito. Espelha o
       <textarea> invisível, por isso o que se vê é o que sai. */
    function drawTextCaret(ctx, o) {
        const el = textField();
        const raw = el.value || '';
        const disp = o.upper ? raw.toUpperCase() : raw;
        const m = measureCv.getContext('2d');
        m.font = `${o.bold ? 700 : 400} ${o.size}px ${fontFamily(o.font)}`;
        const a = Math.min(el.selectionStart, el.selectionEnd);
        const b = Math.max(el.selectionStart, el.selectionEnd);
        const preW = m.measureText(disp.slice(0, a)).width;
        const selW = m.measureText(disp.slice(a, b)).width;

        const ph = raw ? 0 : m.measureText(App.t('text_placeholder', 'Type the label…')).width;
        const boxW = Math.max(o.w, ph);
        ctx.strokeStyle = uiAccent(.9);
        ctx.lineWidth = 1 / zoom;
        ctx.setLineDash([4 / zoom, 3 / zoom]);
        ctx.strokeRect(-3 / zoom, -3 / zoom, boxW + 6 / zoom, o.h + 6 / zoom);
        ctx.setLineDash([]);

        if (!raw) {
            ctx.save();
            ctx.globalAlpha = .4;
            ctx.fillStyle = o.color || '#FFFFFF';
            ctx.font = m.font;
            ctx.textAlign = 'left';
            ctx.textBaseline = 'top';
            ctx.fillText(App.t('text_placeholder', 'Type the label…'), 0, 0);
            ctx.restore();
        }
        if (selW > 0.5) {
            ctx.fillStyle = uiAccent(.32);
            ctx.fillRect(preW, 0, selW, o.h);
        } else if (caretOn) {
            ctx.fillStyle = o.color || '#FFFFFF';
            ctx.fillRect(preW, 0, Math.max(1.5 / zoom, o.size * 0.045), o.h);
        }
    }

    /* Leitura de tamanho/ângulo colada à caixa, desenhada em espaço de
       ECRÃ para não encolher com o zoom. */
    function drawTransformHud(ctx, o) {
        let label;
        if (dragInfo.mode === 'rotate') { label = `${(o.rot || 0).toFixed(1)}°`; }
        else if (dragInfo.mode === 'move') { label = `${Math.round(o.x * 2)}, ${Math.round(o.y * 2)}`; }
        else if (o.type === 'text') { label = `${o.size} px`; }
        else { label = `${Math.round(o.w * 2)} × ${Math.round(o.h * 2)}`; }

        const k = window.devicePixelRatio || 1;
        const sx = (o.x + o.w / 2) * zoom + panX;
        const sy = o.y * zoom + panY;
        ctx.save();
        ctx.setTransform(1, 0, 0, 1, 0, 0);
        ctx.font = `600 ${11 * k}px "Geist Mono", monospace`;
        const tw = ctx.measureText(label).width;
        const bx = Math.round(sx - tw / 2 - 7 * k), by = Math.round(sy - 34 * k);
        ctx.fillStyle = 'rgba(10,10,11,.92)';
        ctx.strokeStyle = uiAccent(.5);
        ctx.lineWidth = k;
        roundRectPath(ctx, bx, by, tw + 14 * k, 20 * k, 5 * k);
        ctx.fill();
        ctx.stroke();
        ctx.fillStyle = '#F4F4F5';
        ctx.textAlign = 'left';
        ctx.textBaseline = 'middle';
        ctx.fillText(label, bx + 7 * k, by + 10.5 * k);
        ctx.restore();
        // a overlay é redesenhada de raiz a cada frame, mas quem vier a
        // seguir espera a transformação do mundo
        ctx.setTransform(zoom, 0, 0, zoom, panX, panY);
    }

    /* â”€â”€ coordinate transforms â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
       ⚠️ A tela tem DOIS tamanhos: o do CSS (px lógicos, que é o que o
       rato reporta) e o do buffer (px físicos = CSS × devicePixelRatio).
       O CEF do FiveM herda a escala do Windows, por isso num ecrã a 125%
       o devicePixelRatio é 1.25 e TUDO o que se desenhava ficava a 80% do
       sítio onde o rato estava. Todas as conversões passam por aqui. */
    function dpr() { return window.devicePixelRatio || 1; }

    function toAtlas(e) {
        const r = viewCv().getBoundingClientRect();
        const k = dpr();
        return {
            x: ((e.clientX - r.left) * k - panX) / zoom,
            y: ((e.clientY - r.top) * k - panY) / zoom,
        };
    }

    function clampPan() {
        const cv = viewCv();
        const w = AW * zoom, h = AH * zoom;
        const margin = 80;
        panX = Math.min(cv.width - margin, Math.max(margin - w, panX));
        panY = Math.min(cv.height - margin, Math.max(margin - h, panY));
    }

    function setZoom(z, cx, cy) {
        const cv = viewCv();
        cx = cx != null ? cx : cv.width / 2;
        cy = cy != null ? cy : cv.height / 2;
        const before = { x: (cx - panX) / zoom, y: (cy - panY) / zoom };
        zoom = Math.max(0.06, Math.min(6, z));
        panX = cx - before.x * zoom;
        panY = cy - before.y * zoom;
        clampPan();
        requestDraw();
        emit('zoom', zoom);
    }

    function zoomFit() {
        const cv = viewCv();
        const z = Math.min(cv.width / AW, cv.height / AH) * 0.94;
        zoom = Math.max(0.06, z);
        panX = (cv.width - AW * zoom) / 2;
        panY = (cv.height - AH * zoom) / 2;
        requestDraw();
        emit('zoom', zoom);
    }

    /* â•â•â•â•â•â•â•â• HISTORY â•â•â•â•â•â•â•â• */

    const history = [];
    let histPos = -1;          // last applied entry

    function pushHistory(entry) {
        history.splice(histPos + 1);
        history.push(entry);
        const limit = cfg().historyLimit || 25;
        while (history.length > limit) { history.shift(); }
        histPos = history.length - 1;
        emit('history');
        markDirty();
    }

    function undo() {
        if (histPos < 0) { return; }
        history[histPos].undo();
        histPos--;
        afterHistory();
    }

    function redo() {
        if (histPos >= history.length - 1) { return; }
        histPos++;
        history[histPos].redo();
        afterHistory();
    }

    function afterHistory() {
        // undo/redo escrevem direto no canvas da camada (putImageData), por
        // isso a redução em cache tem de ser considerada velha
        for (const o of objects) { if (o.type === 'paint') { o._mipRev = -1; } }
        invalidatePostals();
        requestDraw();
        schedulePreview();
        emit('layers');
        emit('history');
        markDirty();
    }

    function canUndo() { return histPos >= 0; }
    function canRedo() { return histPos < history.length - 1; }

    // paint patch helper: snapshot a region of ONE paint layer before a raster edit
    function paintPatch(cv, x, y, w, h) {
        x = Math.max(0, Math.floor(x)); y = Math.max(0, Math.floor(y));
        w = Math.min(AW - x, Math.ceil(w)); h = Math.min(AH - y, Math.ceil(h));
        if (w <= 0 || h <= 0 || !cv) { return null; }
        const ctx = cv.getContext('2d');
        const before = ctx.getImageData(x, y, w, h);
        return {
            commit() {
                const after = ctx.getImageData(x, y, w, h);
                pushHistory({
                    undo() { ctx.putImageData(before, x, y); },
                    redo() { ctx.putImageData(after, x, y); },
                });
            },
        };
    }

    // object list snapshot helper
    function objectsOp(mutate) {
        const before = objects.slice();
        const beforeSel = selectedId;
        mutate();
        const after = objects.slice();
        const afterSel = selectedId;
        pushHistory({
            undo() { objects = before.slice(); selectedId = beforeSel; },
            redo() { objects = after.slice(); selectedId = afterSel; },
        });
        emit('layers');
    }

    // property-change op (for the inspector â€” captures full object copies)
    function objectPatchOp(id, before, after) {
        pushHistory({
            undo() {
                const o = getObject(id);
                if (o) { Object.assign(o, before); }
            },
            redo() {
                const o = getObject(id);
                if (o) { Object.assign(o, after); }
            },
        });
    }

    /* â•â•â•â•â•â•â•â• OBJECTS â•â•â•â•â•â•â•â• */

    function getObject(id) { return objects.find(o => o.id === id) || null; }

    function addObject(o, select) {
        if (objects.length >= (cfg().maxLayers || 40)) {
            App.toast(App.t('err_layers', 'Layer limit reached'), 'warning');
            return null;
        }
        o.id = nextObjId++;
        objectsOp(() => {
            objects.push(o);
            if (select !== false) { selectedId = o.id; }
        });
        requestDraw();
        schedulePreview();
        return o;
    }

    function removeObject(id) {
        const victim = getObject(id);
        if (!victim) { return; }
        // apagar a camada dos postais = desligar os postais
        if (victim.type === 'postals') { postals.enabled = false; emit('postals', postals); }
        objectsOp(() => {
            objects = objects.filter(o => o.id !== id);
            if (selectedId === id) { selectedId = null; }
        });
        requestDraw();
        schedulePreview();
    }

    function duplicateObject(id) {
        const o = getObject(id);
        if (!o) { return; }
        // só pode haver UMA camada de postais (os dados são únicos)
        if (o.type === 'postals') { return; }
        const copy = Object.assign({}, o);
        if (Array.isArray(o.pts)) { copy.pts = o.pts.map(p => ({ x: p.x, y: p.y })); }
        if (o.type === 'paint') {
            // a duplicated paint layer needs its OWN canvas, not a shared ref
            copy.cv = makePaintCanvas();
            if (o.cv) { copy.cv.getContext('2d').drawImage(o.cv, 0, 0); }
            copy.x = 0; copy.y = 0;
        } else {
            copy.x += 24; copy.y += 24;
        }
        addObject(copy);
    }

    // Move an object to an absolute index in the stack (drag-reorder).
    function reorderObject(fromId, toIndex) {
        const i = objects.findIndex(o => o.id === fromId);
        if (i < 0) { return; }
        objectsOp(() => {
            const arr = objects.slice();
            const [o] = arr.splice(i, 1);
            const j = Math.max(0, Math.min(arr.length, toIndex));
            arr.splice(j, 0, o);
            objects = arr;
        });
        requestDraw();
        schedulePreview();
    }

    // Reorder the whole stack to match a list of ids (bottomâ†’top).
    function setObjectOrder(ids) {
        const map = {};
        objects.forEach(o => { map[o.id] = o; });
        const next = [];
        for (const id of ids) { if (map[id]) { next.push(map[id]); delete map[id]; } }
        for (const o of objects) { if (map[o.id]) { next.push(o); } }
        objectsOp(() => { objects = next; });
        requestDraw();
        schedulePreview();
    }

    // Render a layer's own content into a small thumbnail data URL.
    function objectThumb(o, size) {
        size = size || 44;
        const cv = document.createElement('canvas');
        cv.width = size; cv.height = size;
        const ctx = cv.getContext('2d');
        const pad = 5;
        const s = Math.min((size - pad * 2) / Math.max(2, o.w), (size - pad * 2) / Math.max(2, o.h), 2);
        ctx.translate(size / 2 - (o.w * s) / 2, size / 2 - (o.h * s) / 2);
        ctx.scale(s, s);
        if (o.type === 'paint') {
            if (o.cv) { ctx.drawImage(o.cv, 0, 0, o.w, o.h); }
            return cv.toDataURL('image/png');
        }
        const tmp = Object.assign({}, o, { x: 0, y: 0, rot: 0, hidden: false });
        if (tmp.opacity == null) { tmp.opacity = 1; }
        try { drawObject(ctx, tmp); } catch (e) { /* ignore */ }
        return cv.toDataURL('image/png');
    }

    function moveObjectLayer(id, dir) {
        const i = objects.findIndex(o => o.id === id);
        if (i < 0) { return; }
        const j = i + dir;
        if (j < 0 || j >= objects.length) { return; }
        objectsOp(() => {
            const arr = objects.slice();
            const [o] = arr.splice(i, 1);
            arr.splice(j, 0, o);
            objects = arr;
        });
        requestDraw();
        schedulePreview();
    }

    /* Selecionar deixou de reconstruir a lista de camadas inteira (com um
       thumbnail novo por linha, a cada clique). Agora emite 'select' e o
       painel só troca as classes da linha — é o que faz a seleção deixar
       de "piscar" e a lista de manter o scroll no sítio. */
    function selectObject(id) {
        if (textEdit && textEdit.id !== id) { commitTextEdit(); }
        if (selectedId === id) { emit('select', id); requestDraw(); return; }
        selectedId = id;
        emit('select', id);
        requestDraw();
    }

    /* ── espaço local do objeto ────────────────────────────────
       Todo o hit-test e todas as pegas trabalham no referencial do
       objeto (origem no canto superior-esquerdo, já sem rotação).
       Era isto que faltava: as pegas eram DESENHADAS rodadas mas
       testadas sem rotação, por isso num objeto rodado agarravam-se
       ao lado. */
    function localPoint(o, p) {
        const cx = o.x + o.w / 2, cy = o.y + o.h / 2;
        const ang = -(o.rot || 0) * Math.PI / 180;
        const dx = p.x - cx, dy = p.y - cy;
        return {
            x: dx * Math.cos(ang) - dy * Math.sin(ang) + o.w / 2,
            y: dx * Math.sin(ang) + dy * Math.cos(ang) + o.h / 2,
        };
    }

    // local → atlas (o inverso do de cima)
    function worldPoint(o, l) {
        const cx = o.x + o.w / 2, cy = o.y + o.h / 2;
        const ang = (o.rot || 0) * Math.PI / 180;
        const dx = l.x - o.w / 2, dy = l.y - o.h / 2;
        return {
            x: cx + dx * Math.cos(ang) - dy * Math.sin(ang),
            y: cy + dx * Math.sin(ang) + dy * Math.cos(ang),
        };
    }

    function distToSegment(px, py, x1, y1, x2, y2) {
        const dx = x2 - x1, dy = y2 - y1;
        const len2 = dx * dx + dy * dy;
        let t = len2 ? ((px - x1) * dx + (py - y1) * dy) / len2 : 0;
        t = Math.max(0, Math.min(1, t));
        return Math.hypot(px - (x1 + t * dx), py - (y1 + t * dy));
    }

    /* A caixa deixou de ser a resposta final: clicar DENTRO da caixa de
       um polígono mas FORA da forma já não o agarra, e uma linha só
       responde perto do próprio traço. É a diferença entre "não
       consigo clicar no que está por baixo" e uma seleção previsível. */
    function pointInShape(o, l, pad) {
        if (o.type === 'zone' && o.kind === 'poly' && Array.isArray(o.pts) && o.pts.length >= 3) {
            const pts = o.pts.map(pt => ({ x: pt.x * o.w, y: pt.y * o.h }));
            let inside = false;
            for (let i = 0, j = pts.length - 1; i < pts.length; j = i++) {
                const a = pts[i], b = pts[j];
                if ((a.y > l.y) !== (b.y > l.y) &&
                    l.x < (b.x - a.x) * (l.y - a.y) / ((b.y - a.y) || 1e-6) + a.x) { inside = !inside; }
            }
            if (inside) { return true; }
            // margem de tolerância junto às arestas (senão a borda é intocável)
            for (let i = 0, j = pts.length - 1; i < pts.length; j = i++) {
                if (distToSegment(l.x, l.y, pts[i].x, pts[i].y, pts[j].x, pts[j].y) <= pad) { return true; }
            }
            return false;
        }
        if ((o.type === 'zone' || o.type === 'shape') && o.kind === 'ellipse') {
            const rx = Math.max(1, o.w / 2) + pad, ry = Math.max(1, o.h / 2) + pad;
            const nx = (l.x - o.w / 2) / rx, ny = (l.y - o.h / 2) / ry;
            return nx * nx + ny * ny <= 1;
        }
        if (o.type === 'shape' && (o.kind === 'line' || o.kind === 'arrow')) {
            return distToSegment(l.x, l.y, 0, 0, o.w, o.h) <= (o.width || 4) / 2 + pad + 3;
        }
        if (o.type === 'blip') {
            const r = o.w / 2 + pad;
            return Math.hypot(l.x - o.w / 2, l.y - o.h / 2) <= r;
        }
        return true;   // texto, imagem, rect: a caixa É a forma
    }

    // Devolve TODOS os objetos sob o ponto, do topo para o fundo.
    function hitStack(p) {
        const out = [];
        const pad = 6 / zoom;
        for (let i = objects.length - 1; i >= 0; i--) {
            const o = objects[i];
            if (o.hidden || o.locked) { continue; }
            // pintura e postais cobrem o atlas todo — só pela lista
            if (o.type === 'paint' || o.type === 'postals') { continue; }
            const l = localPoint(o, p);
            if (l.x < -pad || l.y < -pad || l.x > o.w + pad || l.y > o.h + pad) { continue; }
            if (!pointInShape(o, l, pad)) { continue; }
            out.push(o);
        }
        return out;
    }

    /* Camada de pintura sob o ponto: a de cima que tenha ali um pixel
       pintado. Sem isto, clicar numa pincelada com a ferramenta de seleção
       não fazia NADA — a camada existia, via-se, e era inalcançável a não
       ser pela lista. É o comportamento que qualquer editor tem. */
    function paintAt(p) {
        const x = Math.floor(p.x), y = Math.floor(p.y);
        if (x < 0 || y < 0 || x >= AW || y >= AH) { return null; }
        for (let i = objects.length - 1; i >= 0; i--) {
            const o = objects[i];
            if (o.type !== 'paint' || o.hidden || o.locked || !o.cv) { continue; }
            try {
                const d = o.cv.getContext('2d').getImageData(x, y, 1, 1).data;
                if (d[3] > 8) { return o; }
            } catch (e) { /* canvas tainted — ignora */ }
        }
        return null;
    }

    // opts.below: com Alt, salta para o objeto SEGUINTE por baixo do
    // selecionado — a forma normal de chegar ao que está tapado.
    function hitTest(p, opts) {
        const stack = hitStack(p);
        if (!stack.length) { return (opts && opts.noPaint) ? null : paintAt(p); }
        if (opts && opts.below && selectedId != null) {
            const i = stack.findIndex(o => o.id === selectedId);
            if (i >= 0) { return stack[(i + 1) % stack.length]; }
        }
        return stack[0];
    }

    // Index of the polygon vertex under p (rotation-ignored â€” poly zones
    // aren't rotated in practice), or -1.
    function polyVertexAt(o, p) {
        if (!o || o.type !== 'zone' || o.kind !== 'poly' || !Array.isArray(o.pts)) { return -1; }
        const r = 9 / zoom;
        for (let i = 0; i < o.pts.length; i++) {
            const ax = o.x + o.pts[i].x * o.w, ay = o.y + o.pts[i].y * o.h;
            if (Math.abs(p.x - ax) <= r && Math.abs(p.y - ay) <= r) { return i; }
        }
        return -1;
    }

    // Move one polygon vertex to an absolute atlas point, then rebuild the
    // bbox + re-normalize every point so the model stays consistent.
    function updatePolyVertex(o, vi, ax, ay) {
        const abs = o.pts.map(p => ({ x: o.x + p.x * o.w, y: o.y + p.y * o.h }));
        abs[vi] = { x: ax, y: ay };
        const xs = abs.map(p => p.x), ys = abs.map(p => p.y);
        const minX = Math.min.apply(null, xs), maxX = Math.max.apply(null, xs);
        const minY = Math.min.apply(null, ys), maxY = Math.max.apply(null, ys);
        const w = Math.max(8, maxX - minX), h = Math.max(8, maxY - minY);
        o.x = minX; o.y = minY; o.w = w; o.h = h;
        o.pts = abs.map(p => ({ x: (p.x - minX) / w, y: (p.y - minY) / h }));
    }

    // Drop one polygon vertex, then rebuild the bbox + re-normalize like
    // updatePolyVertex does. A polygon needs 3 corners, so this refuses to
    // go below that (the caller tells the user why).
    function removePolyVertex(o, vi) {
        if (!o || o.type !== 'zone' || o.kind !== 'poly' || !Array.isArray(o.pts)) { return false; }
        if (o.pts.length <= 3 || vi < 0 || vi >= o.pts.length) { return false; }
        const abs = o.pts.map(p => ({ x: o.x + p.x * o.w, y: o.y + p.y * o.h }));
        abs.splice(vi, 1);
        const xs = abs.map(p => p.x), ys = abs.map(p => p.y);
        const minX = Math.min.apply(null, xs), maxX = Math.max.apply(null, xs);
        const minY = Math.min.apply(null, ys), maxY = Math.max.apply(null, ys);
        const w = Math.max(8, maxX - minX), h = Math.max(8, maxY - minY);
        o.x = minX; o.y = minY; o.w = w; o.h = h;
        o.pts = abs.map(p => ({ x: (p.x - minX) / w, y: (p.y - minY) / h }));
        return true;
    }

    function cloneObj(o) {
        const c = Object.assign({}, o);
        if (Array.isArray(o.pts)) { c.pts = o.pts.map(p => ({ x: p.x, y: p.y })); }
        return c;
    }

    /* ── caixa de transformação ────────────────────────────────
       8 pegas + pega de rotação, todas no espaço local do objeto.
       O texto só mostra os cantos: a largura dele é MEDIDA a partir
       das letras, por isso uma pega lateral não teria o que fazer. */
    const ROT_ARM = 26;        // px de ecrã acima do topo

    // px de ecrã → px do atlas (zoom já está em px FÍSICOS, ver dpr())
    function spx(n) { return n * (window.devicePixelRatio || 1) / zoom; }

    function handlePoints(o) {
        return {
            nw: { x: 0,       y: 0 },
            n:  { x: o.w / 2, y: 0 },
            ne: { x: o.w,     y: 0 },
            e:  { x: o.w,     y: o.h / 2 },
            se: { x: o.w,     y: o.h },
            s:  { x: o.w / 2, y: o.h },
            sw: { x: 0,       y: o.h },
            w:  { x: 0,       y: o.h / 2 },
            rot: { x: o.w / 2, y: -spx(ROT_ARM) },
        };
    }

    function handleKinds(o) {
        const corners = ['nw', 'ne', 'sw', 'se'];
        if (o.type === 'text') { return corners; }
        return corners.concat(['n', 's', 'e', 'w']);
    }

    /* Tolerância da pega. NUNCA pode passar de um terço do lado mais curto:
       num blip de 48px com o mapa afastado, uma tolerância fixa de 9px de
       ecrã cobria o objeto inteiro — todas as tentativas de o MOVER saíam
       como redimensionar. Fica sempre uma zona central para agarrar. */
    function handleSize(o) {
        const wanted = spx(9);
        const cap = Math.min(o.w, o.h) / 3;
        return Math.max(spx(4), Math.min(wanted, cap || wanted));
    }

    function handleAt(o, p) {
        if (!o || o.type === 'paint' || o.locked) { return null; }
        const l = localPoint(o, p);
        const hs = handleSize(o);
        const pts = handlePoints(o);
        // a rotação é testada primeiro: fica fora da caixa, nunca compete
        const order = ['rot'].concat(handleKinds(o));
        for (const k of order) {
            const c = pts[k];
            if (Math.abs(l.x - c.x) <= hs && Math.abs(l.y - c.y) <= hs) { return k; }
        }
        return null;
    }

    // cursor certo para cada pega, já rodado com o objeto
    const CURSOR_STEPS = ['ns-resize', 'nesw-resize', 'ew-resize', 'nwse-resize'];
    function handleCursor(k, rot) {
        if (k === 'rot') { return 'grab'; }
        const baseAngle = { n: 0, ne: 45, e: 90, se: 135, s: 180, sw: 225, w: 270, nw: 315 }[k];
        if (baseAngle == null) { return 'default'; }
        const a = ((baseAngle + (rot || 0)) % 360 + 360) % 360;
        return CURSOR_STEPS[Math.round(a / 45) % 4];
    }

    /* â•â•â•â•â•â•â•â• TOOL INTERACTIONS â•â•â•â•â•â•â•â• */

    let pointerDown = false;
    let panStart = null;
    let dragInfo = null;        // moving/scaling an object
    let marquee = null;         // zone/shape drag rect
    let polyDraft = null;       // custom-zone corner points (atlas coords)
    let cursorPos = null;
    let hoverId = null;         // objeto sob o rato (feedback antes do clique)

    /* O cursor é metade da usabilidade: diz o que o próximo clique faz
       antes de o dares. Sobre uma pega mostra a seta de redimensionar já
       rodada com o objeto; sobre um objeto, mover; no vazio, a mão. */
    function updateCursor(p) {
        const w = wrap();
        if (!w) { return; }
        let c = 'crosshair';
        if (spaceHeld || panStart) {
            c = 'grab';
        } else if (tool === 'pan') {
            const sel = getObject(selectedId);
            const h = handleAt(sel, p);
            if (polyVertexAt(sel, p) >= 0) { c = 'crosshair'; }
            else if (h) { c = handleCursor(h, sel ? sel.rot : 0); }
            else if (hitTest(p, { noPaint: true })) { c = 'move'; }
            else if (paintAt(p)) { c = 'pointer'; }   // dá para selecionar, não para arrastar
            else { c = 'grab'; }
        } else if (tool === 'brush' || tool === 'eraser') {
            // o anel desenhado É o cursor — esconder o do sistema só
            // quando o anel é grande que chegue para não perder o rato
            c = (brush.size * zoom >= 10) ? 'none' : 'crosshair';
        } else if (tool === 'text') {
            c = 'text';
        }
        if (w.style.cursor !== c) { w.style.cursor = c; }
    }

    // brush stroke buffering: the live stroke goes to its own canvas
    // so opacity composites once (no darkening at overlaps)
    const stroke = document.createElement('canvas');
    let strokeActive = false;
    let strokeErase = false;
    let strokeBounds = null;
    let lastPt = null;
    let strokeTarget = null;    // the paint layer the live stroke belongs to

    // Create a new empty paint layer on top and select it.
    function newPaintLayer() {
        return addObject({
            type: 'paint', cv: makePaintCanvas(),
            x: 0, y: 0, w: AW, h: AH, opacity: 1,
            name: nameFor('paint'),
        });
    }

    // The layer brush/eraser/fill write into: the selected paint layer,
    // else the topmost one, else a freshly created one.
    function activePaint() {
        const sel = getObject(selectedId);
        if (sel && sel.type === 'paint' && !sel.locked) { return sel; }
        for (let i = objects.length - 1; i >= 0; i--) {
            if (objects[i].type === 'paint' && !objects[i].locked) { return objects[i]; }
        }
        return newPaintLayer();
    }

    function compositeStrokePreview(ctx) {
        ctx.save();
        ctx.globalAlpha = strokeErase ? 1 : brush.opacity;
        if (strokeErase) {
            // preview erasing softly (the real erase happens on commit)
            ctx.globalAlpha = 0.9;
            ctx.globalCompositeOperation = 'destination-out';
        }
        ctx.drawImage(stroke, 0, 0);
        ctx.restore();
    }

    function growBounds(p) {
        const r = brush.size / 2 + 2;
        if (!strokeBounds) {
            strokeBounds = { x0: p.x - r, y0: p.y - r, x1: p.x + r, y1: p.y + r };
        } else {
            strokeBounds.x0 = Math.min(strokeBounds.x0, p.x - r);
            strokeBounds.y0 = Math.min(strokeBounds.y0, p.y - r);
            strokeBounds.x1 = Math.max(strokeBounds.x1, p.x + r);
            strokeBounds.y1 = Math.max(strokeBounds.y1, p.y + r);
        }
    }

    function strokeSegment(a, b) {
        const ctx = stroke.getContext('2d');
        ctx.lineCap = 'round';
        ctx.lineJoin = 'round';
        ctx.strokeStyle = strokeErase ? '#000' : brush.color;
        ctx.lineWidth = brush.size;
        if (brush.mode === 'marker' && !strokeErase) { ctx.globalAlpha = 0.55; }
        ctx.beginPath();
        ctx.moveTo(a.x, a.y);
        ctx.lineTo(b.x, b.y);
        ctx.stroke();
        ctx.globalAlpha = 1;
    }

    function beginStroke(p, erase) {
        strokeTarget = activePaint();
        if (!strokeTarget) { return; }
        strokeActive = true;
        strokeErase = erase;
        strokeBounds = null;
        const ctx = stroke.getContext('2d');
        ctx.clearRect(0, 0, AW, AH);
        lastPt = p;
        growBounds(p);
        strokeSegment(p, { x: p.x + 0.01, y: p.y + 0.01 });
    }

    function endStroke() {
        if (!strokeActive) { return; }
        strokeActive = false;
        const target = strokeTarget;
        strokeTarget = null;
        if (!strokeBounds || !target || !target.cv) { return; }
        const b = strokeBounds;
        const patch = paintPatch(target.cv, b.x0, b.y0, b.x1 - b.x0, b.y1 - b.y0);
        const ctx = target.cv.getContext('2d');
        ctx.save();
        if (strokeErase) {
            ctx.globalCompositeOperation = 'destination-out';
            ctx.globalAlpha = 1;
        } else {
            ctx.globalAlpha = brush.opacity;
        }
        ctx.drawImage(stroke, 0, 0);
        ctx.restore();
        if (patch) { patch.commit(); }
        target.rev = (target.rev || 0) + 1;   // invalida a redução da camada
        requestDraw();
        schedulePreview();
        emit('layers');   // refresh the layer thumbnail
    }

    /* â”€â”€ flood fill â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ */
    function floodFill(p) {
        const x0 = Math.floor(p.x), y0 = Math.floor(p.y);
        if (x0 < 0 || y0 < 0 || x0 >= AW || y0 >= AH) { return; }

        // reference = the whole rendered scene, so fills respect exactly
        // what you see; the RESULT goes into the active paint layer
        const target = activePaint();
        if (!target || !target.cv) { return; }
        const refCv = document.createElement('canvas');
        refCv.width = AW; refCv.height = AH;
        const refCtx = refCv.getContext('2d');
        drawScene(refCtx);
        const ref = refCtx.getImageData(0, 0, AW, AH).data;

        const idx0 = (y0 * AW + x0) * 4;
        const tr = ref[idx0], tg = ref[idx0 + 1], tb = ref[idx0 + 2], ta = ref[idx0 + 3];
        const tol = fillOpts.tolerance;
        const tol2 = tol * tol * 4;

        const fill = hexToRgb(brush.color);
        const mask = new Uint8Array(AW * AH);
        const stack = [x0 + y0 * AW];
        mask[x0 + y0 * AW] = 1;
        let minX = x0, maxX = x0, minY = y0, maxY = y0;

        while (stack.length) {
            const pos = stack.pop();
            const px = pos % AW, py = (pos / AW) | 0;
            if (px < minX) minX = px; if (px > maxX) maxX = px;
            if (py < minY) minY = py; if (py > maxY) maxY = py;
            for (const [nx, ny] of [[px + 1, py], [px - 1, py], [px, py + 1], [px, py - 1]]) {
                if (nx < 0 || ny < 0 || nx >= AW || ny >= AH) { continue; }
                const np = nx + ny * AW;
                if (mask[np]) { continue; }
                const ni = np * 4;
                const dr = ref[ni] - tr, dg = ref[ni + 1] - tg, db = ref[ni + 2] - tb, da = ref[ni + 3] - ta;
                if (dr * dr + dg * dg + db * db + da * da > tol2) { continue; }
                mask[np] = 1;
                stack.push(np);
            }
        }

        const w = maxX - minX + 1, h = maxY - minY + 1;
        const patch = paintPatch(target.cv, minX, minY, w, h);
        const pctx = target.cv.getContext('2d');
        const img = pctx.getImageData(minX, minY, w, h);
        const d = img.data;
        for (let y = 0; y < h; y++) {
            for (let x = 0; x < w; x++) {
                if (!mask[(minX + x) + (minY + y) * AW]) { continue; }
                const i = (y * w + x) * 4;
                d[i] = fill.r; d[i + 1] = fill.g; d[i + 2] = fill.b; d[i + 3] = 255;
            }
        }
        pctx.putImageData(img, minX, minY);
        if (patch) { patch.commit(); }
        target.rev = (target.rev || 0) + 1;   // invalida a redução da camada
        requestDraw();
        schedulePreview();
        emit('layers');
    }

    function hexToRgb(hex) {
        const m = /^#?([0-9a-f]{6})$/i.exec(hex) || [];
        const v = parseInt(m[1] || 'ffffff', 16);
        return { r: (v >> 16) & 255, g: (v >> 8) & 255, b: v & 255 };
    }

    function pickColor(p) {
        const x = Math.floor(p.x), y = Math.floor(p.y);
        if (x < 0 || y < 0 || x >= AW || y >= AH) { return null; }
        // sample the fully rendered scene at that pixel
        const cv = document.createElement('canvas');
        cv.width = 1; cv.height = 1;
        const ctx = cv.getContext('2d');
        ctx.translate(-x, -y);
        drawScene(ctx);
        ctx.setTransform(1, 0, 0, 1, 0, 0);
        const d = ctx.getImageData(0, 0, 1, 1).data;
        if (d[3] === 0) { return null; }
        const hex = '#' + [d[0], d[1], d[2]].map(v => v.toString(16).padStart(2, '0')).join('').toUpperCase();
        return hex;
    }

    /* â”€â”€ pointer handlers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ */

    function onPointerDown(e) {
        const p0 = toAtlas(e);

        // Estamos a escrever? Qualquer clique fora do próprio texto fecha a
        // edição PRIMEIRO (o blur do textarea só chega depois deste handler,
        // e aí já era tarde para decidir o que este clique faz).
        if (textEdit) {
            const editing = getObject(textEdit.id);
            const onIt = editing && hitStack(p0).indexOf(editing) >= 0;
            if (!onIt) { commitTextEdit(); }
            else if (tool === 'text' || tool === 'pan') { e.preventDefault(); return; }   // deixa o textarea tratar
        }

        /* Com a ferramenta de texto o clique NÃO pode deixar o browser mudar
           o foco: é o campo escondido que tem de o manter para as teclas lá
           chegarem. `preventDefault` no mousedown é precisamente o que trava
           essa mudança de foco. */
        if (e.button === 0 && (tool === 'text' || textEdit)) { e.preventDefault(); }

        const selNow = getObject(selectedId);
        const grabsNothing = tool === 'pan'
            && !hitTest(p0)                 // inclui pintura: clicar num traço seleciona-o
            && !handleAt(selNow, p0)
            && polyVertexAt(selNow, p0) < 0;
        if (e.button === 1 || (e.button === 0 && spaceHeld) || (e.button === 0 && grabsNothing)) {
            // middle mouse / space / pan tool on empty space â†’ pan
            if (grabsNothing && selectedId != null) { selectObject(null); }
            pointerDown = true;
            panStart = { x: e.clientX - panX, y: e.clientY - panY };
            wrap().classList.add('panning');
            return;
        }
        if (e.button !== 0) { return; }
        const p = p0;
        pointerDown = true;

        if (tool === 'pan') {
            const sel = getObject(selectedId);
            // dragging a polygon corner takes priority over the bbox handles
            const vi = polyVertexAt(sel, p);
            if (vi >= 0) {
                // Alt+click a corner deletes just that corner (undoable).
                if (e.altKey) {
                    pointerDown = false;
                    const before = cloneObj(sel);
                    if (removePolyVertex(sel, vi)) {
                        objectPatchOp(sel.id, before, cloneObj(sel));
                        markDirty();
                        requestDraw();
                    } else {
                        App.toast(App.t('zone_min_points', 'A zone needs at least 3 points'), 'warning');
                    }
                    return;
                }
                dragInfo = { mode: 'vertex', id: sel.id, vi, before: cloneObj(sel) };
                return;
            }
            const handle = handleAt(sel, p);
            if (handle && sel) {
                if (handle === 'rot') {
                    const cx = sel.x + sel.w / 2, cy = sel.y + sel.h / 2;
                    const pointer = Math.atan2(p.y - cy, p.x - cx) * 180 / Math.PI + 90;
                    dragInfo = {
                        mode: 'rotate', id: sel.id,
                        grab: pointer - (sel.rot || 0),
                        before: cloneObj(sel),
                    };
                } else {
                    dragInfo = {
                        mode: 'scale', id: sel.id, handle,
                        orig: cloneObj(sel),
                        startLocal: localPoint(sel, p),
                        before: cloneObj(sel),
                    };
                }
                return;
            }
            // Alt sem pega = escolher o objeto por BAIXO do selecionado
            const hit = hitTest(p, { below: e.altKey });
            if (hit && hit.type === 'paint') {
                // uma camada de pintura cobre o atlas inteiro: seleciona-se
                // para a poder editar, mas não se arrasta (não tem posição)
                selectObject(hit.id);
                pointerDown = false;
                return;
            }
            if (hit) {
                if (hit.id !== selectedId) { selectObject(hit.id); }
                dragInfo = {
                    mode: 'move', id: hit.id,
                    off: { x: p.x - hit.x, y: p.y - hit.y },
                    before: cloneObj(hit),
                    origin: { x: hit.x, y: hit.y },
                    moved: false,
                    // Alt+arrastar duplica, como em qualquer editor
                    dupPending: e.altKey && !e.shiftKey,
                };
            } else {
                selectObject(null);
            }
        } else if (tool === 'brush') {
            beginStroke(p, false);
        } else if (tool === 'eraser') {
            beginStroke(p, true);
        } else if (tool === 'fill') {
            /* O preenchimento lê o atlas inteiro (6 milhões de píxeis) e
               percorre-o — é inevitavelmente uma pausa. Damos um frame ao
               browser primeiro, para o cursor de "a trabalhar" aparecer em
               vez de o clique parecer perdido. */
            const w2 = wrap();
            const prev = w2.style.cursor;
            w2.style.cursor = 'progress';
            pointerDown = false;
            requestAnimationFrame(() => {
                requestAnimationFrame(() => {
                    try { floodFill(p); } finally { w2.style.cursor = prev; }
                });
            });
        } else if (tool === 'picker') {
            const hex = pickColor(p);
            if (hex) {
                brush.color = hex;
                emit('brush', brush);
                App.toast(hex, 'info');
            }
        } else if (tool === 'zone' && zoneOpts.kind === 'poly') {
            // custom zone â€” click each corner; click the first point (or
            // Enter / double-click) to close, Escape to cancel
            const near = 12 / zoom;
            // Alt+click an already-placed corner removes THAT corner, so a
            // misplaced point mid-way doesn't mean restarting the whole zone.
            if (e.altKey && polyDraft && polyDraft.length) {
                for (let i = 0; i < polyDraft.length; i++) {
                    if (Math.abs(p.x - polyDraft[i].x) <= near && Math.abs(p.y - polyDraft[i].y) <= near) {
                        polyDraft.splice(i, 1);
                        if (!polyDraft.length) { polyDraft = null; }
                        requestDraw();
                        pointerDown = false;
                        return;
                    }
                }
            }
            if (polyDraft && polyDraft.length >= 3) {
                const f = polyDraft[0];
                if (Math.abs(p.x - f.x) <= near && Math.abs(p.y - f.y) <= near) {
                    finalizePoly();
                    pointerDown = false;
                    return;
                }
            }
            if (!polyDraft) { polyDraft = []; }
            polyDraft.push({ x: p.x, y: p.y });
            requestDraw();
            pointerDown = false;   // it's a click, not a drag
        } else if (tool === 'postalmove') {
            // arrastar o conjunto inteiro de postais
            dragInfo = {
                mode: 'postals', start: p,
                before: getPostalOffset(), moved: false,
            };
        } else if (tool === 'zone' || tool === 'shape' || tool === 'ext') {
            cancelPoly();
            marquee = { x: p.x, y: p.y, w: 0, h: 0, sx: p.x, sy: p.y };
        } else if (tool === 'blip') {
            // Clicar EM CIMA de um blip que já existe seleciona-o em vez de
            // empilhar outro por cima (era o que fazia a ferramenta parecer
            // avariada: clicavas para o mexer e ganhavas um segundo blip).
            const onBlip = hitStack(p).find(o => o.type === 'blip');
            if (onBlip) {
                selectObject(onBlip.id);
                dragInfo = {
                    mode: 'move', id: onBlip.id,
                    off: { x: p.x - onBlip.x, y: p.y - onBlip.y },
                    before: cloneObj(onBlip),
                    origin: { x: onBlip.x, y: onBlip.y },
                    moved: false,
                };
                return;
            }
            const sz = blipOpts.size;
            addObject({
                type: 'blip', sprite: blipOpts.sprite, glyph: blipOpts.glyph,
                img: blipOpts.img || null, customImg: !!blipOpts.customImg,
                color: blipOpts.color, colorHex: blipOpts.colorHex, label: '',
                x: p.x - sz / 2, y: p.y - sz / 2, w: sz, h: sz, opacity: 1,
                // the sprite's catalogue name, falling back to "Blip N"
                name: blipOpts.name || nameFor('blip'),
            });
            pointerDown = false;
        } else if (tool === 'text') {
            // clicar num texto existente ABRE-O para edição em vez de criar outro
            const onText = hitStack(p).find(o => o.type === 'text');
            if (onText) { beginTextEdit(onText, false); }
            else { createText(p); }
            pointerDown = false;
        } else if (tool === 'image') {
            document.getElementById('file-image').click();
            pointerDown = false;
        }
    }

    /* ── snapping ──────────────────────────────────────────────
       Arestas e centro do objeto contra: as margens do atlas, o centro,
       as linhas dos tiles e as arestas/centros dos outros objetos.
       Ctrl desliga. As guias que "prenderam" são desenhadas para se
       perceber PORQUÊ é que colou. */
    const SNAP_PX = 7;
    let snapGuides = [];

    function snapPosition(o, nx, ny, off) {
        snapGuides = [];
        if (off) { return { x: nx, y: ny }; }
        const t = spx(SNAP_PX);
        const xs = [0, AW / 2, AW];
        const ys = [0, AH / 2, AH];
        for (let c = 1; c < COLS; c++) { xs.push(c * EDIT_TILE); }
        for (let r = 1; r < ROWS; r++) { ys.push(r * EDIT_TILE); }
        for (const other of objects) {
            if (other === o || other.hidden || other.type === 'paint') { continue; }
            xs.push(other.x, other.x + other.w / 2, other.x + other.w);
            ys.push(other.y, other.y + other.h / 2, other.y + other.h);
        }
        let bx = null, by = null;
        [nx, nx + o.w / 2, nx + o.w].forEach((v) => {
            for (const c of xs) {
                const d = Math.abs(v - c);
                if (d <= t && (!bx || d < bx.d)) { bx = { d, delta: c - v, at: c }; }
            }
        });
        [ny, ny + o.h / 2, ny + o.h].forEach((v) => {
            for (const c of ys) {
                const d = Math.abs(v - c);
                if (d <= t && (!by || d < by.d)) { by = { d, delta: c - v, at: c }; }
            }
        });
        if (bx) { nx += bx.delta; snapGuides.push({ axis: 'x', at: bx.at }); }
        if (by) { ny += by.delta; snapGuides.push({ axis: 'y', at: by.at }); }
        return { x: nx, y: ny };
    }

    function onPointerMove(e) {
        const p = toAtlas(e);
        cursorPos = p;
        emit('cursor', p);

        if (!pointerDown) {
            // feedback de hover: o que está por baixo do rato acende, e o
            // cursor diz o que vai acontecer se clicares
            const prevHover = hoverId;
            hoverId = null;
            if (tool === 'pan') {
                // camadas de pintura fora: a "caixa" delas é o atlas inteiro
                const h = hitTest(p, { noPaint: true });
                if (h && h.id !== selectedId) { hoverId = h.id; }
            }
            updateCursor(p);
            if (hoverId !== prevHover || tool === 'brush' || tool === 'eraser' || polyDraft || textEdit) {
                requestDraw();
            }
            return;
        }

        if (panStart) {
            panX = e.clientX - panStart.x;
            panY = e.clientY - panStart.y;
            clampPan();
            requestDraw();
            return;
        }

        if (dragInfo && dragInfo.mode === 'postals') {
            // px do atlas → unidades de mundo (o deslocamento vive em mundo)
            const a = pixelToWorld(dragInfo.start.x, dragInfo.start.y);
            const b = pixelToWorld(p.x, p.y);
            setPostalOffset(dragInfo.before.x + (b.x - a.x), dragInfo.before.y + (b.y - a.y));
            dragInfo.moved = true;
            return;
        }

        if (dragInfo) {
            const o = getObject(dragInfo.id);
            if (!o) { return; }
            if (dragInfo.mode === 'vertex') {
                updatePolyVertex(o, dragInfo.vi, p.x, p.y);
                dragInfo.moved = true;
                requestDraw();
                return;
            }
            if (dragInfo.mode === 'move') {
                // Alt+arrastar: à primeira fração de movimento nasce a cópia
                // e passamos a arrastar ESSA (o original fica onde estava)
                if (dragInfo.dupPending) {
                    dragInfo.dupPending = false;
                    const copy = cloneObj(o);
                    delete copy.id;
                    if (o.type === 'paint') { copy.cv = makePaintCanvas(); if (o.cv) { copy.cv.getContext('2d').drawImage(o.cv, 0, 0); } }
                    const made = addObject(copy);
                    if (made) {
                        dragInfo.id = made.id;
                        dragInfo.before = cloneObj(made);
                        return onPointerMove(e);
                    }
                }
                let nx = p.x - dragInfo.off.x;
                let ny = p.y - dragInfo.off.y;
                // Shift trava no eixo dominante
                if (e.shiftKey) {
                    const dx = Math.abs(nx - dragInfo.origin.x), dy = Math.abs(ny - dragInfo.origin.y);
                    if (dx > dy) { ny = dragInfo.origin.y; } else { nx = dragInfo.origin.x; }
                }
                const snapped = snapPosition(o, nx, ny, e.ctrlKey || e.metaKey);
                o.x = snapped.x; o.y = snapped.y;
                dragInfo.moved = true;
            } else if (dragInfo.mode === 'rotate') {
                const cx = o.x + o.w / 2, cy = o.y + o.h / 2;
                let a = Math.atan2(p.y - cy, p.x - cx) * 180 / Math.PI + 90 - dragInfo.grab;
                if (e.shiftKey) { a = Math.round(a / 15) * 15; }   // passos de 15°
                a = ((a + 180) % 360 + 360) % 360 - 180;
                o.rot = Math.round(a * 10) / 10;
                dragInfo.moved = true;
            } else {
                /* Escala no ESPAÇO LOCAL: com o objeto rodado, arrastar a
                   pega "se" tem de crescer na diagonal DELE, não na do ecrã.
                   Depois a caixa nova é reconvertida para o atlas, o que
                   mantém a pega oposta cravada no sítio. */
                const g = dragInfo.orig;
                const l = localPoint(g, p);
                const s = dragInfo.startLocal;
                const hk = dragInfo.handle;
                const sym = e.altKey;          // Alt = escala a partir do centro
                let lx = 0, ly = 0, lw = g.w, lh = g.h;
                const dx = l.x - s.x, dy = l.y - s.y;
                if (hk.includes('e')) { lw = g.w + dx * (sym ? 2 : 1); if (sym) { lx = -dx; } }
                if (hk.includes('w')) { lw = g.w - dx * (sym ? 2 : 1); lx = dx; }
                if (hk.includes('s')) { lh = g.h + dy * (sym ? 2 : 1); if (sym) { ly = -dy; } }
                if (hk.includes('n')) { lh = g.h - dy * (sym ? 2 : 1); ly = dy; }

                const corner = hk.length === 2;
                // Shift (ou texto) mantém a proporção
                if (corner && (e.shiftKey || o.type === 'text')) {
                    const k = Math.max(lw / g.w, lh / g.h);
                    const nw = g.w * k, nh = g.h * k;
                    if (hk.includes('w')) { lx += lw - nw; }
                    if (hk.includes('n')) { ly += lh - nh; }
                    lw = nw; lh = nh;
                }
                const MIN = 8;
                if (lw < MIN) { if (hk.includes('w')) { lx -= MIN - lw; } lw = MIN; }
                if (lh < MIN) { if (hk.includes('n')) { ly -= MIN - lh; } lh = MIN; }

                if (o.type === 'text') {
                    // o texto escala pelo CORPO da letra; a largura é medida
                    const k = lh / g.h;
                    o.size = Math.max(8, Math.round(g.size * k));
                    remeasureText(o);
                    lw = o.w; lh = o.h;
                }
                // centro novo, em local → atlas
                const lcx = lx + lw / 2, lcy = ly + lh / 2;
                const c = worldPoint(g, { x: lcx, y: lcy });
                o.w = lw; o.h = lh;
                o.x = c.x - lw / 2;
                o.y = c.y - lh / 2;
                dragInfo.moved = true;
            }
            emit('objectlive', o);
            requestDraw();
            return;
        }

        if (marquee) {
            marquee.x = Math.min(marquee.sx, p.x);
            marquee.y = Math.min(marquee.sy, p.y);
            marquee.w = Math.abs(p.x - marquee.sx);
            marquee.h = Math.abs(p.y - marquee.sy);
            requestDraw();
            return;
        }

        if (strokeActive) {
            growBounds(p);
            strokeSegment(lastPt, p);
            lastPt = p;
            requestDraw();
        }
    }

    function onPointerUp() {
        if (!pointerDown) { return; }
        pointerDown = false;

        if (panStart) {
            panStart = null;
            wrap().classList.remove('panning');
            return;
        }

        if (dragInfo && dragInfo.mode === 'postals') {
            const before = dragInfo.before;
            const after = getPostalOffset();
            if (dragInfo.moved) {
                pushHistory({
                    undo() { postals.offset = { x: before.x, y: before.y }; postalsChanged(); },
                    redo() { postals.offset = { x: after.x, y: after.y }; postalsChanged(); },
                });
            }
            dragInfo = null;
            requestDraw();
            return;
        }

        if (dragInfo) {
            const o = getObject(dragInfo.id);
            if (o && dragInfo.moved) {
                objectPatchOp(o.id, dragInfo.before, cloneObj(o));
                schedulePreview();
                emit('layers');
            }
            dragInfo = null;
            snapGuides = [];
            requestDraw();
            return;
        }

        if (marquee) {
            const m = marquee;
            marquee = null;
            if (m.w > 12 && m.h > 12) {
                if (tool === 'ext') {
                    // o retângulo desenhado no atlas vira uma área em
                    // coordenadas de MUNDO (é assim que o jogo a entende)
                    const a = pixelToWorld(m.x, m.y);
                    const b = pixelToWorld(m.x + m.w, m.y + m.h);
                    addExtension({
                        name: 'Extension ' + (extensions.length + 1),
                        x1: Math.round(a.x), y1: Math.round(a.y),
                        x2: Math.round(b.x), y2: Math.round(b.y),
                        z: 0, bounds: true,
                    });
                    setTool('pan');
                    marquee = null;
                    requestDraw();
                    return;
                }
                if (tool === 'zone') {
                    addObject({
                        type: 'zone', kind: zoneOpts.kind,
                        x: m.x, y: m.y, w: m.w, h: m.h,
                        color: zoneOpts.color, opacity: zoneOpts.opacity,
                        stroke: zoneOpts.stroke, label: '', labelColor: '#FFFFFF',
                        name: nameFor('zone'),
                    });
                } else {
                    addObject({
                        type: 'shape', kind: shapeOpts.kind,
                        x: m.x, y: m.y, w: m.w, h: m.h,
                        stroke: shapeOpts.stroke, width: shapeOpts.width,
                        fill: shapeOpts.fill, fillColor: shapeOpts.fillColor,
                        opacity: 1,
                        name: nameFor('shape'),
                    });
                }
                // Hand the new object straight to the select tool: staying on
                // zone/shape meant the next click drew ANOTHER one instead of
                // selecting the one just made, so its colour was unreachable.
                setTool('pan');
            }
            requestDraw();
            return;
        }

        endStroke();
    }

    /* â”€â”€ text / image creation â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ */

    const measureCv = document.createElement('canvas');
    function measureTextWidth(o) {
        const ctx = measureCv.getContext('2d');
        ctx.font = `${o.bold ? 700 : 400} ${o.size}px ${fontFamily(o.font)}`;
        const txt = o.upper ? String(o.text || '').toUpperCase() : String(o.text || '');
        return Math.max(20, ctx.measureText(txt).width);
    }

    let counters = { text: 0, shape: 0, zone: 0, image: 0 };
    function nameFor(type) {
        counters[type] = (counters[type] || 0) + 1;
        return type.charAt(0).toUpperCase() + type.slice(1) + ' ' + counters[type];
    }

    // Close the custom-zone polygon into a real zone object. Points are
    // stored normalized (0..1) inside the bbox so scaling handles work.
    function finalizePoly() {
        if (!polyDraft || polyDraft.length < 3) { polyDraft = null; requestDraw(); return; }
        const xs = polyDraft.map(p => p.x), ys = polyDraft.map(p => p.y);
        const minX = Math.min.apply(null, xs), maxX = Math.max.apply(null, xs);
        const minY = Math.min.apply(null, ys), maxY = Math.max.apply(null, ys);
        const w = Math.max(8, maxX - minX), h = Math.max(8, maxY - minY);
        const pts = polyDraft.map(p => ({ x: (p.x - minX) / w, y: (p.y - minY) / h }));
        polyDraft = null;
        addObject({
            type: 'zone', kind: 'poly',
            x: minX, y: minY, w, h, pts,
            color: zoneOpts.color, opacity: zoneOpts.opacity,
            stroke: zoneOpts.stroke, label: '', labelColor: '#FFFFFF',
            name: nameFor('zone'),
        });
        // Same reason as the marquee path: drop to the select tool so the new
        // zone is live in the inspector (colour, opacity, label) right away.
        setTool('pan');
        requestDraw();
    }
    function cancelPoly() { if (polyDraft) { polyDraft = null; requestDraw(); } }

    /* ══════════ EDIÇÃO DE TEXTO NA TELA ══════════
       Antes: clicar com a ferramenta de texto largava um "LOS SANTOS"
       fixo e a única forma de o mudar era ir procurar um campo no
       inspector que só aplicava ao sair. Agora escreve-se ONDE o texto
       vai ficar, com caret a piscar, e cada tecla redesenha o mapa.

       O campo real é um <textarea> invisível — é ele que dá backspace,
       setas, seleção, colar, teclado do sistema e IME de borla. Nós só
       espelhamos `value` + `selectionStart/End` para o canvas, por isso
       o que se vê a escrever é EXATAMENTE o que é exportado. */

    let textEdit = null;            // { id, before, isNew }
    let caretOn = true;
    let caretTimer = null;

    function blinkOn() {
        caretOn = true;
        clearInterval(caretTimer);
        caretTimer = setInterval(() => { caretOn = !caretOn; requestDraw(); }, 530);
    }
    function blinkOff() { clearInterval(caretTimer); caretTimer = null; caretOn = true; }

    function textField() {
        let el = document.getElementById('text-input');
        if (el) { return el; }
        el = document.createElement('textarea');
        el.id = 'text-input';
        el.rows = 1;
        el.spellcheck = false;
        el.autocomplete = 'off';
        document.body.appendChild(el);
        el.addEventListener('input', onTextInput);
        el.addEventListener('keydown', onTextKey);
        // clicar fora (na tela, num painel, onde for) fecha a edição —
        // o mesmo que o Photoshop faz ao mudar de ferramenta
        el.addEventListener('blur', () => commitTextEdit());
        // o caret vive na overlay: qualquer coisa que mexa na seleção
        // do textarea tem de repintar
        ['keyup', 'click', 'select'].forEach(ev => el.addEventListener(ev, () => { blinkOn(); requestDraw(); }));
        return el;
    }

    function isEditingText() { return !!textEdit; }

    function beginTextEdit(o, isNew) {
        if (!o || o.type !== 'text' || o.locked) { return; }
        if (textEdit && textEdit.id === o.id) { return; }
        commitTextEdit();
        selectedId = o.id;
        textEdit = { id: o.id, before: cloneObj(o), isNew: !!isNew };
        const el = textField();
        el.value = o.text || '';
        el.style.display = 'block';
        /* ⚠️ O foco tem de ser reposto DEPOIS da acção por omissão do
           mousedown. Ao carregar numa zona não-focável (a tela), o browser
           tira o foco a quem o tinha — e isso corre A SEGUIR aos nossos
           handlers. Focar só aqui era focar para o browser desfocar meio
           milissegundo depois: o `blur` fechava a edição, o texto vazio era
           descartado e não aparecia nada. Um teste com eventos sintéticos
           NUNCA apanha isto (eventos despachados por código não mexem no
           foco) — só um rato a sério. */
        const grabFocus = () => {
            if (!textEdit || textEdit.id !== o.id) { return; }
            if (document.activeElement === el) { return; }
            el.focus({ preventScroll: true });
            try { el.setSelectionRange(el.value.length, el.value.length); } catch (e) { /* */ }
        };
        el.focus({ preventScroll: true });
        try { el.setSelectionRange(el.value.length, el.value.length); } catch (e) { /* */ }
        setTimeout(grabFocus, 0);
        requestAnimationFrame(grabFocus);
        blinkOn();
        emit('select', o.id);
        emit('textedit', o);
        requestDraw();
    }

    function onTextInput() {
        const o = textEdit && getObject(textEdit.id);
        if (!o) { return; }
        // uma linha: o Enter confirma, não parte o rótulo ao meio
        o.text = textField().value.replace(/[\r\n]+/g, '');
        remeasureText(o);
        blinkOn();
        requestDraw();
        /* ⚠️ NADA de schedulePreview() aqui. Cada preview recompõe os 6
           tiles, faz 6 toDataURL e empurra megabytes pelo NUI — a cada
           pausa na escrita. Era isso que fazia o estúdio "prender". O
           minimapa em jogo é atualizado ao confirmar o texto. */
        emit('objectlive', o);  // o inspector segue, isso é barato
    }

    function onTextKey(e) {
        if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); commitTextEdit(); return; }
        if (e.key === 'Escape') { e.preventDefault(); e.stopPropagation(); commitTextEdit(true); return; }
        if (e.key === 'Tab') { e.preventDefault(); commitTextEdit(); return; }
        e.stopPropagation();    // as teclas de ferramenta (B, T, V…) não roubam
    }

    function commitTextEdit(cancel) {
        if (!textEdit) { return; }
        const st = textEdit;
        textEdit = null;
        blinkOff();
        const el = textField();
        el.style.display = 'none';
        if (document.activeElement === el) { el.blur(); }

        const o = getObject(st.id);
        if (!o) { requestDraw(); return; }
        const empty = !String(o.text || '').trim();

        if (st.isNew) {
            // O rascunho vive FORA do histórico até ter conteúdo: um texto
            // abandonado não deixa uma camada vazia nem entradas de undo.
            if (cancel || empty) {
                objects = objects.filter(x => x !== o);
                if (selectedId === o.id) { selectedId = null; }
            } else {
                const ref = o;
                pushHistory({
                    undo() {
                        objects = objects.filter(x => x !== ref);
                        if (selectedId === ref.id) { selectedId = null; }
                    },
                    redo() {
                        objects = objects.concat([ref]);
                        selectedId = ref.id;
                    },
                });
            }
        } else if (cancel) {
            Object.assign(o, st.before);
            remeasureText(o);
        } else if (empty) {
            // apagar tudo num texto que já existia = apagar o texto
            removeObject(o.id);
            emit('layers');
            requestDraw();
            schedulePreview();
            return;
        } else if (o.text !== st.before.text) {
            objectPatchOp(o.id, st.before, cloneObj(o));
        }

        emit('layers');
        requestDraw();
        schedulePreview();
    }

    function remeasureText(o) {
        if (!o || o.type !== 'text') { return; }
        o.w = measureTextWidth(o);
        o.h = o.size * 1.25;
    }

    // Clicar com a ferramenta de texto: nasce vazio e JÁ em edição.
    function createText(p) {
        if (objects.length >= (cfg().maxLayers || 40)) {
            App.toast(App.t('err_layers', 'Layer limit reached'), 'warning');
            return null;
        }
        const o = {
            id: nextObjId++,
            type: 'text', text: '',
            font: textOpts.font, size: textOpts.size, color: textOpts.color,
            bold: textOpts.bold, upper: textOpts.upper,
            outline: true, outlineColor: '#0A0A0B',
            x: p.x, y: p.y - (textOpts.size * 1.25) / 2, opacity: 1,
            rot: 0,
            name: nameFor('text'),
        };
        remeasureText(o);
        objects.push(o);            // rascunho: sem histórico até confirmar
        emit('layers');
        beginTextEdit(o, true);
        return o;
    }

    function addImageFromSrc(src, at) {
        const img = new Image();
        img.onload = () => {
            // depois de colocar a imagem volta-se à seleção: ficar na
            // ferramenta de imagem fazia o clique seguinte reabrir o
            // seletor de ficheiros em vez de agarrar o que acabou de entrar
            if (tool === 'image') { setTool('pan'); }
            const maxW = AW * 0.4;
            const scale = Math.min(1, maxW / img.width);
            const o = {
                type: 'image', img, src,
                x: at ? at.x : AW / 2 - (img.width * scale) / 2,
                y: at ? at.y : AH / 2 - (img.height * scale) / 2,
                w: img.width * scale, h: img.height * scale,
                opacity: 1,
                name: nameFor('image'),
            };
            addObject(o);
        };
        img.src = src;
    }

    /* â•â•â•â•â•â•â•â• LIVE PREVIEW / COMPOSE â•â•â•â•â•â•â•â• */

    let previewEnabled = true;
    let previewTimer = null;
    let previewBusy = false;
    let previewAgainWanted = false;

    // opts.forExport is ONLY for the package export, which ships a real
    // blips.lua â€” there the painted copy would sit under the real blip.
    // Live, the live preview and the PNG save all replace textures and
    // create no game blips, so they MUST bake the markers in or the blips
    // simply vanish.
    function composeTile(row, col, outSize, opts) {
        const cv = document.createElement('canvas');
        cv.width = outSize; cv.height = outSize;
        const ctx = cv.getContext('2d');
        const s = outSize / EDIT_TILE;
        ctx.setTransform(s, 0, 0, s, -col * EDIT_TILE * s, -row * EDIT_TILE * s);
        drawScene(ctx, opts || {});
        return cv;
    }

    /* ⚠️ `toDataURL` é SÍNCRONO: codificar um PNG de 4096×4096 trava o CEF
       durante segundos — e o estúdio faz isso SEIS vezes por export e a
       cada pré-visualização. `toBlob` codifica fora da thread principal;
       entre tiles devolvemos ainda um frame ao browser. É a diferença
       entre "o jogo pendurou" e uma barra de progresso a andar. */
    function encodeCanvas(cv, type, quality) {
        return new Promise((resolve) => {
            const fallback = () => {
                try { resolve(cv.toDataURL(type || 'image/png', quality)); }
                catch (e) { resolve(''); }
            };
            if (!cv.toBlob) { fallback(); return; }
            try {
                cv.toBlob((blob) => {
                    if (!blob) { fallback(); return; }
                    const fr = new FileReader();
                    fr.onload = () => resolve(String(fr.result || ''));
                    fr.onerror = fallback;
                    fr.readAsDataURL(blob);
                }, type || 'image/png', quality);
            } catch (e) { fallback(); }
        });
    }

    const nextFrame = () => new Promise(r => requestAnimationFrame(() => r()));

    async function composeTilesAsync(outSize, opts, onProgress) {
        commitTextEdit();          // o que sai é o que está escrito
        opts = opts || {};
        const tiles = [];
        const total = ROWS * COLS;
        // Acima da resolução de trabalho vale a pena ir buscar a base em
        // alta ao disco: o mapa exportado deixa de ser um upscale 4× do
        // atlas de edição. Um tile de cada vez, para a memória não subir.
        // No modo overlay-only a base nem sequer é desenhada.
        const wantHi = !opts.overlayOnly && outSize > EDIT_TILE;
        for (let r = 0; r < ROWS; r++) {
            for (let c = 0; c < COLS; c++) {
                let hiCv = null;
                if (wantHi) {
                    hiCv = await ensureHiTile(r, c);
                    opts = Object.assign({}, opts, { hi: !!hiCv, hiReady: () => hiCv });
                }
                const cv = composeTile(r, c, outSize, opts);
                const image = await encodeCanvas(cv);
                tiles.push({ row: r, col: c, image });
                cv.width = 0; cv.height = 0;   // liberta os MB do canvas já
                if (hiCv) { hiEvict(); }
                if (onProgress) { onProgress(tiles.length / total); }
                await nextFrame();
            }
        }
        return tiles;
    }

    // Versão síncrona mantida para quem precise dela fora do fluxo pesado.
    function composeTiles(outSize, opts) {
        commitTextEdit();
        const tiles = [];
        for (let r = 0; r < ROWS; r++) {
            for (let c = 0; c < COLS; c++) {
                tiles.push({ row: r, col: c, image: composeTile(r, c, outSize, opts).toDataURL('image/png') });
            }
        }
        return tiles;
    }

    function schedulePreview() {
        // The Cayo map is a scaleform overlay, not the LS raster tiles â€”
        // pushing it through the tile live-preview would wrongly repaint
        // Los Santos, so we skip live preview while editing Cayo.
        if (!previewEnabled || !baseReady || isCayo()) { return; }
        // Enquanto o rato está em baixo (traço, arrasto, escrita) não se
        // compõe nada: o preview é caro e só interessa o resultado final.
        if (pointerDown || strokeActive || textEdit) {
            previewAgainWanted = true;
            return;
        }
        clearTimeout(previewTimer);
        // Debounce hard: each run creates fresh runtime textures in game
        // (they can't be freed), so we only push once a change settles.
        previewTimer = setTimeout(runPreview, Math.max(450, cfg().frameThrottleMs || 450));
    }

    async function runPreview() {
        if (previewBusy) { previewAgainWanted = true; return; }
        previewBusy = true;
        try {
            /* 512 por tile (atlas de 1024×1536). O radar mostra um pedaço
               pequeno do mapa muito reduzido — 1024 por tile era 4× o custo
               de composição, de codificação E de transporte pelo NUI para
               detalhe que ninguém vê. */
            const tiles = await composeTilesAsync(512);
            await App.sendBlob('preview', { tiles });
        } finally {
            previewBusy = false;
            if (previewAgainWanted) {
                previewAgainWanted = false;
                schedulePreview();
            }
        }
    }

    function setPreviewEnabled(onoff) {
        previewEnabled = onoff;
        if (onoff) { schedulePreview(); }
        else { App.post('previewClear'); }
        emit('preview', onoff);
    }

    /* â•â•â•â•â•â•â•â• PROJECT (de)SERIALISATION â•â•â•â•â•â•â•â• */

    let dirty = false;
    function markDirty() {
        dirty = true;
        const dot = document.getElementById('project-dirty');
        if (dot) { dot.hidden = false; }
    }
    function markClean() {
        dirty = false;
        const dot = document.getElementById('project-dirty');
        if (dot) { dot.hidden = true; }
    }

    // â”€â”€ Postals API â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    function postalsChanged() {
        invalidatePostals();
        requestDraw();
        schedulePreview();
        markDirty();
        emit('postals', postals);
    }
    // ── Extensions API ──────────────────────────────────────────
    function extensionsChanged() {
        requestDraw();
        markDirty();
        emit('extensions', extensions);
    }

    function getExtensions() { return extensions; }

    function addExtension(ext) {
        const e = Object.assign({
            name: 'Extension ' + (extensions.length + 1),
            x1: 0, y1: 0, x2: 0, y2: 0, z: 0,
            bounds: true, blip: false,
        }, ext || {});
        // normalizar o retângulo (min/max) — o resto do código conta com isso
        const x1 = Math.min(e.x1, e.x2), x2 = Math.max(e.x1, e.x2);
        const y1 = Math.min(e.y1, e.y2), y2 = Math.max(e.y1, e.y2);
        e.x1 = x1; e.x2 = x2; e.y1 = y1; e.y2 = y2;
        e.id = nextExtId++;
        extensions.push(e);
        extensionsChanged();
        return e;
    }

    function updateExtension(id, patch) {
        const e = extensions.find(x => x.id === id);
        if (!e) { return null; }
        Object.assign(e, patch || {});
        if (patch && (patch.x1 != null || patch.x2 != null || patch.y1 != null || patch.y2 != null)) {
            const x1 = Math.min(e.x1, e.x2), x2 = Math.max(e.x1, e.x2);
            const y1 = Math.min(e.y1, e.y2), y2 = Math.max(e.y1, e.y2);
            e.x1 = x1; e.x2 = x2; e.y1 = y1; e.y2 = y2;
        }
        extensionsChanged();
        return e;
    }

    function removeExtension(id) {
        const n = extensions.length;
        extensions = extensions.filter(x => x.id !== id);
        if (extensions.length !== n) { extensionsChanged(); }
    }

    /* Mover o conjunto: em unidades de MUNDO, para o deslocamento continuar
       a ser o mesmo se depois se mudar de mapa base ou de resolução. */
    function setPostalOffset(x, y) {
        postals.offset = {
            x: Math.round((Number(x) || 0) * 10) / 10,
            y: Math.round((Number(y) || 0) * 10) / 10,
        };
        postalsChanged();
        return postals.offset;
    }
    function nudgePostals(dx, dy) {
        const o = postals.offset || { x: 0, y: 0 };
        return setPostalOffset(o.x + dx, o.y + dy);
    }
    function getPostalOffset() { return Object.assign({ x: 0, y: 0 }, postals.offset); }

    /* Pontos com o deslocamento já aplicado — é ISTO que vai para o
       `postals.lua` do export, senão o /gps em jogo mandava o jogador para
       o sítio antigo enquanto o mapa mostra o novo. */
    function getPostalPointsResolved() {
        const o = getPostalOffset();
        if (!o.x && !o.y) { return postals.points; }
        return postals.points.map(p => ({
            code: p.code,
            x: Math.round((p.x + o.x) * 10) / 10,
            y: Math.round((p.y + o.y) * 10) / 10,
        }));
    }

    /* ── a camada dos postais ────────────────────────────────
       Um objeto sem geometria que só marca a POSIÇÃO NA PILHA onde os
       códigos são desenhados. Os dados (pontos, estilo, deslocamento)
       continuam em `postals` — a camada é só o lugar na ordem. */
    function postalLayer() { return objects.find(o => o.type === 'postals') || null; }

    function ensurePostalLayer() {
        let o = postalLayer();
        if (o) { return o; }
        o = {
            id: nextObjId++, type: 'postals',
            x: 0, y: 0, w: AW, h: AH, opacity: 1,
            name: 'Postal codes',
        };
        objects.push(o);
        emit('layers');
        return o;
    }

    function removePostalLayer() {
        const o = postalLayer();
        if (!o) { return; }
        objects = objects.filter(x => x !== o);
        if (selectedId === o.id) { selectedId = null; }
        emit('layers');
    }

    function setPostalEnabled(v) {
        postals.enabled = !!v;
        if (postals.enabled) { ensurePostalLayer(); } else { removePostalLayer(); }
        postalsChanged();
    }
    function setPostalIngame(v) { postals.ingameScript = !!v; markDirty(); emit('postals', postals); }
    function setPostalStyle(patch) { Object.assign(postals.style, patch || {}); postalsChanged(); }
    function setPostalPoints(points, name) {
        postals.points = Array.isArray(points) ? points : [];
        if (name != null) { postals.setName = name; }
        // Carregar um conjunto NOVO limpa o deslocamento: ele é o
        // alinhamento DAQUELE conjunto, e herdá-lo punha o seguinte
        // ao lado sem se perceber porquê.
        postals.offset = { x: 0, y: 0 };
        postalsChanged();
    }
    function setPostalOverride(code, patch) {
        code = String(code);
        if (!patch || Object.keys(patch).length === 0) { delete postals.overrides[code]; }
        else { postals.overrides[code] = Object.assign(postals.overrides[code] || {}, patch); }
        postalsChanged();
    }
    function clearPostalOverride(code) { delete postals.overrides[String(code)]; postalsChanged(); }
    // Back to the shipped look: default style + no per-code overrides.
    // The imported set itself is left alone (that's what Clear is for).
    function resetPostalStyle() {
        postals.style = Object.assign({}, POSTAL_STYLE_DEFAULTS);
        postals.overrides = {};
        postalsChanged();
    }
    function getPostals() { return postals; }

    // Blips with world coordinates, for the exported in-game blip script.
    function getBlips() {
        // customImg blips are painted into the atlas instead â€” GTA blips can
        // only be one of its own sprite ids, so they cannot ship as a script.
        return objects.filter(o => o.type === 'blip' && !o.customImg).map(o => {
            const w = pixelToWorld(o.x + o.w / 2, o.y + o.h / 2);
            return {
                sprite: o.sprite || 1, color: o.color || 0,
                label: o.label || '', scale: +(o.w / 46).toFixed(2),
                x: Math.round(w.x * 10) / 10, y: Math.round(w.y * 10) / 10,
            };
        });
    }

    // opts.deferPaint: deixa `src` das camadas de pintura por preencher —
    // quem chama trata delas uma a uma (ver serializeAsync).
    function serialize(opts) {
        opts = opts || {};
        // fechar a edição em curso antes de fotografar o documento: um
        // rascunho a meio não deve entrar (nem faltar) num projeto guardado
        commitTextEdit();
        return {
            version: 1,
            map: currentMap,
            theme: Object.assign({}, theme),
            postals: {
                enabled: postals.enabled, ingameScript: postals.ingameScript,
                setName: postals.setName, points: postals.points,
                offset: getPostalOffset(),
                style: Object.assign({}, postals.style),
                overrides: JSON.parse(JSON.stringify(postals.overrides)),
            },
            extensions: extensions.map(e => Object.assign({}, e)),
            objects: objects.map(o => {
                const copy = Object.assign({}, o);
                // An IMAGE layer keeps a live HTMLImageElement in .img, which
                // JSON cannot hold. A BLIP keeps a sprite file name (or a
                // data: URL) there â€” a plain string that MUST survive, or the
                // blip comes back spriteless when the project is reopened.
                if (typeof copy.img !== 'string') { delete copy.img; }
                // caches de desenho NUNCA vão para o ficheiro (um canvas
                // serializa como {} e só inchava o projeto)
                delete copy._mip;
                delete copy._mipRev;
                if (o.type === 'paint') {
                    // rasterise the layer's canvas into the project file
                    copy.src = (opts.deferPaint || !o.cv) ? null : o.cv.toDataURL('image/png');
                    delete copy.cv;
                }
                return copy;
            }),
        };
    }

    /* Guardar um projeto codificava um PNG de 2048×3072 POR CAMADA de
       pintura, tudo de uma vez e a bloquear. Aqui é o mesmo resultado sem
       pendurar o jogo: uma camada de cada vez, fora da thread principal. */
    async function serializeAsync() {
        const st = serialize({ deferPaint: true });
        for (let i = 0; i < st.objects.length; i++) {
            const so = st.objects[i];
            if (so.type !== 'paint') { continue; }
            const live = objects.find(o => o.id === so.id);
            if (live && live.cv) {
                so.src = await encodeCanvas(live.cv);
                await nextFrame();
            }
        }
        return st;
    }

    function loadState(st, done) {
        objects = [];
        selectedId = null;
        history.length = 0;
        histPos = -1;
        Object.assign(theme, st.theme || {});

        // restore postals (keep defaults for anything missing)
        if (st.postals && typeof st.postals === 'object') {
            postals.enabled = !!st.postals.enabled;
            postals.ingameScript = st.postals.ingameScript !== false;
            postals.setName = st.postals.setName || 'New';
            postals.points = Array.isArray(st.postals.points) ? st.postals.points : [];
            const po = st.postals.offset;
            postals.offset = (po && isFinite(+po.x) && isFinite(+po.y))
                ? { x: +po.x, y: +po.y } : { x: 0, y: 0 };
            if (st.postals.style) { Object.assign(postals.style, st.postals.style); }
            postals.overrides = st.postals.overrides || {};
            invalidatePostals();
        }

        // restore map extensions (projetos antigos simplesmente não as têm)
        extensions = [];
        nextExtId = 1;
        if (Array.isArray(st.extensions)) {
            for (const e of st.extensions) {
                if (!e || !isFinite(+e.x1) || !isFinite(+e.y1)) { continue; }
                extensions.push({
                    id: nextExtId++,
                    name: String(e.name || 'Extension'),
                    x1: +e.x1, y1: +e.y1, x2: +e.x2, y2: +e.y2, z: +e.z || 0,
                    bounds: e.bounds !== false,
                    blip: !!e.blip,
                });
            }
        }
        emit('extensions', extensions);

        let pending = 1;
        const finish = () => {
            pending--;
            if (pending > 0) { return; }
            recomputeStyledBase();
            // projeto antigo: os postais estavam ligados mas ainda não
            // eram uma camada — cria-a por cima para a pilha ficar coerente
            if (postals.enabled) { ensurePostalLayer(); }
            emit('layers');
            emit('theme', theme);
            emit('map', currentMap);
            requestDraw();
            schedulePreview();
            markClean();
            if (done) { done(); }
        };

        // project remembers the base map it was painted on
        if (st.map && st.map !== currentMap) {
            currentMap = st.map;
            const cayo = st.map.indexOf('cayo-') === 0;
            if (cayo) {
                currentMapObj = { id: st.map, cayo: true, cayoStyle: st.map.slice(5), rows: 1, cols: 1, tileSize: 2048 };
                if (ROWS !== 1 || COLS !== 1) { applyDims(1, 1, 2048); }
            } else {
                currentMapObj = { id: st.map, rows: ROWS, cols: COLS, tileSize: FULL_TILE };
            }
            pending++;
            loadBaseTiles(currentMap).then(finish);
        }

        for (const so of (st.objects || [])) {
            const o = Object.assign({}, so);
            o.id = nextObjId++;
            if (o.type === 'image' && o.src) {
                pending++;
                const img = new Image();
                img.onload = () => { o.img = img; finish(); };
                img.onerror = finish;
                img.src = o.src;
            } else if (o.type === 'paint') {
                o.cv = makePaintCanvas();
                o.x = 0; o.y = 0; o.w = AW; o.h = AH;
                if (o.src) {
                    pending++;
                    const img = new Image();
                    const cvx = o.cv.getContext('2d');
                    img.onload = () => { cvx.drawImage(img, 0, 0, AW, AH); finish(); };
                    img.onerror = finish;
                    img.src = o.src;
                }
                delete o.src;
            }
            objects.push(o);
        }

        // legacy projects stored ONE flat paint canvas â€” import it as a layer
        if (st.paint) {
            const legacy = { id: nextObjId++, type: 'paint', cv: makePaintCanvas(), x: 0, y: 0, w: AW, h: AH, opacity: 1, name: 'Paint 1' };
            pending++;
            const img = new Image();
            const cvx = legacy.cv.getContext('2d');
            img.onload = () => { cvx.drawImage(img, 0, 0, AW, AH); finish(); };
            img.onerror = finish;
            img.src = st.paint;
            objects.unshift(legacy);
        }
        finish();
    }

    function resetAll() {
        objects = [];
        selectedId = null;
        history.length = 0;
        histPos = -1;
        postals.enabled = false;
        postals.points = [];
        postals.overrides = {};
        postals.setName = 'New';
        postals.offset = { x: 0, y: 0 };
        invalidatePostals();
        extensions = [];
        nextExtId = 1;
        emit('extensions', extensions);
        setTheme({ hue: 0, sat: 100, bri: 100, con: 100, tintAmt: 0 }, 'original');
        emit('layers');
        emit('history');
        emit('postals', postals);
        requestDraw();
        schedulePreview();
    }

    /* â•â•â•â•â•â•â•â• INIT â•â•â•â•â•â•â•â• */

    let spaceHeld = false;

    function applyDims(rows, cols, tileSize) {
        ROWS = rows; COLS = cols;
        FULL_TILE = tileSize;
        EDIT_TILE = FULL_TILE / 2;
        AW = COLS * EDIT_TILE;
        AH = ROWS * EDIT_TILE;
        for (const cv of [base, styledBase, stroke]) {
            cv.width = AW; cv.height = AH;
        }
    }

    function initDimensions() {
        const a = cfg().atlas || {};
        applyDims(a.rows || 3, a.cols || 2, a.tileSize || 2048);
    }

    /* A tile that fails to load used to leave a silent blank square, which is
       impossible to diagnose from the outside. Failures are now collected and
       reported by name, both to the console and to the UI. */
    function loadBaseTiles(mapId) {
        return new Promise((resolve) => {
            const ctx = base.getContext('2d');
            ctx.clearRect(0, 0, AW, AH);
            let left = ROWS * COLS;
            const failed = [];
            const finish = () => {
                if (--left > 0) { return; }
                if (failed.length) {
                    const msg = `${failed.length}/${ROWS * COLS} base tile(s) of "${mapId}" did not load: ${failed.join(', ')}`;
                    console.error('[apex_minimap] ' + msg);
                    emit('tileerror', { map: mapId, missing: failed, expected: ROWS * COLS });
                }
                resolve();
            };
            for (let r = 0; r < ROWS; r++) {
                for (let c = 0; c < COLS; c++) {
                    const img = new Image();
                    const name = `minimap_${r}_${c}.png`;
                    img.onload = () => {
                        ctx.drawImage(img, c * EDIT_TILE, r * EDIT_TILE, EDIT_TILE, EDIT_TILE);
                        finish();
                    };
                    img.onerror = () => { failed.push(name); finish(); };
                    img.src = `tiles/${mapId}/${name}`;
                }
            }
        });
    }

    // Swap the base map. A same-shape swap (LSâ†’LS) KEEPS the paint layer
    // and objects; a different-shape swap (LSâ†”Cayo) resets the document
    // because the canvas geometry changes.
    async function setMap(map) {
        const obj = (typeof map === 'string') ? { id: map } : (map || {});
        if (!obj.id || obj.id === currentMap) { return; }
        const newRows = obj.rows || (cfg().atlas || {}).rows || 3;
        const newCols = obj.cols || (cfg().atlas || {}).cols || 2;
        const newTile = obj.tileSize || (cfg().atlas || {}).tileSize || 2048;
        const shapeChanged = (newRows !== ROWS || newCols !== COLS || newTile !== FULL_TILE);

        currentMap = obj.id;
        currentMapObj = obj;
        dropHiTiles();          // as cópias em alta eram do mapa anterior

        if (shapeChanged) {
            // new geometry â†’ fresh document
            objects = []; selectedId = null;
            history.length = 0; histPos = -1;
            applyDims(newRows, newCols, newTile);
            emit('layers'); emit('history');
        }

        await loadBaseTiles(currentMap);
        recomputeStyledBase();   // re-applies the current theme over the new base
        if (shapeChanged) { zoomFit(); }
        requestDraw();
        schedulePreview();
        markDirty();
        emit('map', currentMap);
    }

    function isCayo() { return !!(currentMapObj && currentMapObj.cayo); }
    function cayoStyle() { return currentMapObj && currentMapObj.cayoStyle; }

    async function boot() {
        initDimensions();
        currentMap = (cfg().defaultMap) || 'original';
        currentMapObj = { id: currentMap, rows: ROWS, cols: COLS, tileSize: FULL_TILE };
        await loadBaseTiles(currentMap);
        baseReady = true;
        recomputeStyledBase();
        resizeView();
        zoomFit();
        emit('ready');
        emit('map', currentMap);

        /* As caixas de texto são MEDIDAS com a fonte real. Se medirmos antes
           de a webfont chegar, medimos a fonte de recurso e a caixa fica
           torta para sempre (e as pegas ao lado das letras). Re-medir quando
           as fontes ficam prontas custa nada e endireita tudo. */
        if (document.fonts && document.fonts.ready) {
            document.fonts.ready.then(() => {
                let touched = false;
                for (const o of objects) {
                    if (o.type !== 'text') { continue; }
                    const w0 = o.w;
                    remeasureText(o);
                    if (Math.abs(w0 - o.w) > 0.5) { touched = true; }
                }
                if (touched) { requestDraw(); emit('layers'); }
            });
        }
    }

    function bindInput() {
        const w = wrap();
        w.addEventListener('mousedown', onPointerDown);
        window.addEventListener('mousemove', onPointerMove);
        window.addEventListener('mouseup', onPointerUp);
        w.addEventListener('mouseleave', () => {
            cursorPos = null;
            hoverId = null;      // senão fica um contorno aceso sem rato em cima
            requestDraw();
        });

        // duplo-clique: fecha um polígono em curso, ou abre um texto para
        // edição (o gesto que toda a gente já tem nos dedos)
        w.addEventListener('dblclick', (e) => {
            if (polyDraft) { e.preventDefault(); finalizePoly(); return; }
            const p = toAtlas(e);
            const t = hitStack(p).find(o => o.type === 'text');
            if (t) { e.preventDefault(); setTool('text'); beginTextEdit(t, false); }
        });

        // Enter closes / Escape cancels the polygon â€” capture phase so it
        // beats app.js's Escape-to-close handler while drawing a zone.
        // Ctrl+Z is intercepted here too: mid-draw it must take back the last
        // CORNER, not run the global undo (which used to wipe the previous
        // object instead and leave the half-drawn zone on screen).
        window.addEventListener('keydown', (e) => {
            // a escrever na tela? o <textarea> trata do seu Enter/Escape
            if (textEdit) { return; }
            if (polyDraft) {
                if (e.key === 'Enter') { e.preventDefault(); e.stopImmediatePropagation(); finalizePoly(); }
                else if (e.key === 'Escape') { e.preventDefault(); e.stopImmediatePropagation(); cancelPoly(); }
                else if (e.ctrlKey && e.key.toLowerCase() === 'z') {
                    e.preventDefault(); e.stopImmediatePropagation();
                    polyDraft.pop();
                    if (!polyDraft.length) { polyDraft = null; }
                    requestDraw();
                }
                return;
            }
            /* Escape com algo selecionado LARGA a seleção; só fecha o estúdio
               quando não há nada por que responder. Tem de ser em CAPTURA: o
               handler do app.js está no `document`, que borbulha ANTES da
               window — sem isto, o Escape fechava o estúdio a meio do
               trabalho. */
            if (e.key === 'Escape' && selectedId != null) {
                e.preventDefault();
                e.stopImmediatePropagation();
                selectObject(null);
            }
        }, true);

        w.addEventListener('wheel', (e) => {
            e.preventDefault();
            const r = viewCv().getBoundingClientRect();
            const k = dpr();
            const factor = e.deltaY < 0 ? 1.15 : 1 / 1.15;
            setZoom(zoom * factor, (e.clientX - r.left) * k, (e.clientY - r.top) * k);
        }, { passive: false });

        window.addEventListener('resize', resizeView);

        /* Qualquer coisa que mude o tamanho da tela (barra de opções a
           abrir, rail a colapsar, dock, resolução) redimensiona o buffer.
           Sem isto ficava desalinhado até alguém mexer na janela. */
        if (typeof ResizeObserver === 'function') {
            let pending = false;
            new ResizeObserver(() => {
                if (pending) { return; }
                pending = true;
                requestAnimationFrame(() => { pending = false; resizeView(); });
            }).observe(w);
        }

        // drag & drop images
        w.addEventListener('dragover', (e) => {
            e.preventDefault();
            document.getElementById('drop-hint').hidden = false;
        });
        w.addEventListener('dragleave', () => {
            document.getElementById('drop-hint').hidden = true;
        });
        w.addEventListener('drop', (e) => {
            e.preventDefault();
            document.getElementById('drop-hint').hidden = true;
            const f = e.dataTransfer.files && e.dataTransfer.files[0];
            if (f && f.type.startsWith('image/')) {
                const rd = new FileReader();
                rd.onload = () => addImageFromSrc(rd.result, toAtlas(e));
                rd.readAsDataURL(f);
            }
        });

        document.getElementById('file-image').addEventListener('change', (e) => {
            const f = e.target.files && e.target.files[0];
            e.target.value = '';
            if (f) {
                const rd = new FileReader();
                rd.onload = () => addImageFromSrc(rd.result, null);
                rd.readAsDataURL(f);
            }
        });

        window.addEventListener('paste', (e) => {
            const items = (e.clipboardData || {}).items || [];
            for (const it of items) {
                if (it.type && it.type.startsWith('image/')) {
                    const f = it.getAsFile();
                    const rd = new FileReader();
                    rd.onload = () => addImageFromSrc(rd.result, null);
                    rd.readAsDataURL(f);
                    return;
                }
            }
        });

        // keyboard
        window.addEventListener('keydown', (e) => {
            const inField = /INPUT|TEXTAREA|SELECT/.test((e.target.tagName || ''));
            // a barra de espaços dentro de um campo é um espaço, não um pan
            if (e.code === 'Space' && !inField) { spaceHeld = true; }
            if (inField) { return; }
            if (e.ctrlKey && e.key.toLowerCase() === 'z') { e.preventDefault(); undo(); return; }
            if (e.ctrlKey && (e.key.toLowerCase() === 'y' || (e.shiftKey && e.key.toLowerCase() === 'z'))) { e.preventDefault(); redo(); return; }
            // Ctrl+D duplica, Ctrl+Enter/F2 entra no texto selecionado
            if (e.ctrlKey && e.key.toLowerCase() === 'd') {
                e.preventDefault();
                if (selectedId != null) { duplicateObject(selectedId); }
                return;
            }
            const selObj = getObject(selectedId);
            if ((e.key === 'F2' || (e.key === 'Enter' && !e.ctrlKey)) && selObj && selObj.type === 'text') {
                e.preventDefault();
                setTool('text');
                beginTextEdit(selObj, false);
                return;
            }
            const keys = { v: 'pan', b: 'brush', e: 'eraser', f: 'fill', i: 'picker', t: 'text', s: 'shape', z: 'zone', p: 'blip' };
            if (!e.ctrlKey && keys[e.key.toLowerCase()]) { setTool(keys[e.key.toLowerCase()]); return; }
            if (e.key === 'Delete' || e.key === 'Backspace') {
                if (selectedId != null) { removeObject(selectedId); }
                return;
            }
            // [ e ] = pincel mais fino / mais grosso, como em qualquer editor
            if (!e.ctrlKey && (e.key === '[' || e.key === ']')) {
                const step = brush.size > 40 ? 8 : (brush.size > 12 ? 4 : 1);
                brush.size = Math.max(1, Math.min(300, brush.size + (e.key === ']' ? step : -step)));
                emit('brush', brush);
                requestDraw();
                return;
            }
            if (!e.ctrlKey && (e.key === '+' || e.key === '=')) { setZoom(zoom * 1.2); }
            if (!e.ctrlKey && e.key === '-') { setZoom(zoom / 1.2); }
            if (e.key === '0') { zoomFit(); }
            if (selectedId != null && e.key.startsWith('Arrow')) {
                e.preventDefault();
                const o = getObject(selectedId);
                if (o && !o.locked) {
                    const step = e.shiftKey ? 10 : 1;
                    const before = cloneObj(o);
                    if (e.key === 'ArrowLeft') { o.x -= step; }
                    if (e.key === 'ArrowRight') { o.x += step; }
                    if (e.key === 'ArrowUp') { o.y -= step; }
                    if (e.key === 'ArrowDown') { o.y += step; }
                    objectPatchOp(o.id, before, cloneObj(o));
                    emit('objectlive', o);
                    requestDraw();
                    schedulePreview();
                }
            }
        });
        window.addEventListener('keyup', (e) => {
            if (e.code === 'Space') { spaceHeld = false; }
        });
    }

    function setTool(name) {
        if (name !== 'zone') { cancelPoly(); }
        if (textEdit && name !== 'text') { commitTextEdit(); }
        tool = name;
        document.querySelectorAll('#tool-rail .tool-btn[data-tool]').forEach(b => {
            b.classList.toggle('active', b.dataset.tool === name);
        });
        wrap().classList.toggle('panning', name === 'pan');
        emit('tool', name);
        requestDraw();
    }

    window.addEventListener('DOMContentLoaded', bindInput);

    /* â”€â”€ public surface â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ */
    return {
        boot, resizeView, requestDraw, zoomFit, setZoom,
        get zoom() { return zoom; },
        get tool() { return tool; },
        setTool,
        brush, shapeOpts, zoneOpts, textOpts, fillOpts, blipOpts,
        BLIP_SPRITES, BLIP_COLORS, getBlips,
        get BLIP_CATALOGUE() { return blipCatalogue(); },
        blipImage, blipSrc,
        theme, setTheme, themeFilter,
        undo, redo, canUndo, canRedo,
        get objects() { return objects; },
        get selectedId() { return selectedId; },
        getObject, selectObject, removeObject, duplicateObject, moveObjectLayer,
        reorderObject, setObjectOrder, objectThumb, newPaintLayer,
        beginTextEdit, commitTextEdit, isEditingText, remeasureText,
        objectPatchOp, addImageFromSrc,
        onEvent, emit,
        get currentMap() { return currentMap; },
        get currentMapObj() { return currentMapObj; },
        isCayo, cayoStyle,
        setMap,
        getExtensions, addExtension, updateExtension, removeExtension,
        getPostals, setPostalEnabled, setPostalIngame, setPostalStyle,
        setPostalOffset, nudgePostals, getPostalOffset, getPostalPointsResolved,
        setPostalPoints, setPostalOverride, clearPostalOverride, resetPostalStyle,
        worldToPixel, pixelToWorld,
        composeTiles, composeTilesAsync, encodeCanvas, serializeAsync,
        schedulePreview, setPreviewEnabled,
        get previewEnabled() { return previewEnabled; },
        serialize, loadState, resetAll,
        markClean, markDirty,
        get dirty() { return dirty; },
        setShowTiles(v) { showTiles = v; requestDraw(); },
        setShowGrid(v) { showGrid = v; requestDraw(); },
        dims() { return { ROWS, COLS, FULL_TILE, EDIT_TILE, AW, AH }; },
    };
})();
