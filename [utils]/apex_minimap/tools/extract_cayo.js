/* ============================================================
   Apex Minimap Studio — Cayo Perico paint-base extractor
   ------------------------------------------------------------
   For every style under templates/<style>/gfx/int3232302352.gfx,
   decodes the island + sea bitmaps, composites them into ONE
   square PNG the studio can paint on:
       html/tiles/cayo-<style>/minimap_0_0.png
   and appends a "Cayo — <style>" entry to html/tiles/maps.json
   (cayo:true, 1×1 atlas) so it shows in the map picker.

   Run AFTER extract_tiles.js (which creates maps.json).
   Usage:  node tools/extract_cayo.js
   ============================================================ */
'use strict';
const fs = require('fs');
const path = require('path');
const zlib = require('zlib');
const gfx = require('./gfx');

const ROOT = path.resolve(__dirname, '..');
const TPL = path.join(ROOT, 'templates');
const TILES = path.join(ROOT, 'html', 'tiles');
const CAYO_GFX = path.join('gfx', 'int3232302352.gfx');
const WORK = 2048;   // square paint-base resolution

/* ── PNG encode (RGBA8, filter 0) ────────────────────────── */
function crc32(buf) {
    let c, table = crc32.table;
    if (!table) {
        table = crc32.table = new Int32Array(256);
        for (let n = 0; n < 256; n++) { c = n; for (let k = 0; k < 8; k++) { c = (c & 1) ? (0xedb88320 ^ (c >>> 1)) : (c >>> 1); } table[n] = c; }
    }
    c = 0xffffffff;
    for (let i = 0; i < buf.length; i++) { c = table[(c ^ buf[i]) & 0xff] ^ (c >>> 8); }
    return (c ^ 0xffffffff) >>> 0;
}
function chunk(type, data) {
    const out = Buffer.alloc(12 + data.length);
    out.writeUInt32BE(data.length, 0); out.write(type, 4, 'ascii'); data.copy(out, 8);
    out.writeUInt32BE(crc32(out.slice(4, 8 + data.length)), 8 + data.length);
    return out;
}
function encodePng(rgba, w, h) {
    const ihdr = Buffer.alloc(13);
    ihdr.writeUInt32BE(w, 0); ihdr.writeUInt32BE(h, 4); ihdr[8] = 8; ihdr[9] = 6;
    const stride = w * 4, raw = Buffer.alloc((stride + 1) * h);
    for (let y = 0; y < h; y++) { raw[y * (stride + 1)] = 0; rgba.copy(raw, y * (stride + 1) + 1, y * stride, (y + 1) * stride); }
    return Buffer.concat([
        Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]),
        chunk('IHDR', ihdr), chunk('IDAT', zlib.deflateSync(raw, { level: 6 })), chunk('IEND', Buffer.alloc(0)),
    ]);
}

/* ── bilinear resize (RGBA) ──────────────────────────────── */
function resize(src, w, h, tw, th) {
    const out = Buffer.alloc(tw * th * 4);
    const sx = w / tw, sy = h / th;
    for (let y = 0; y < th; y++) {
        const fy = (y + 0.5) * sy - 0.5, y0 = Math.max(0, Math.floor(fy)), y1 = Math.min(h - 1, y0 + 1), wy = fy - y0;
        for (let x = 0; x < tw; x++) {
            const fx = (x + 0.5) * sx - 0.5, x0 = Math.max(0, Math.floor(fx)), x1 = Math.min(w - 1, x0 + 1), wx = fx - x0;
            const d = (y * tw + x) * 4;
            for (let c = 0; c < 4; c++) {
                const p00 = src[(y0 * w + x0) * 4 + c], p10 = src[(y0 * w + x1) * 4 + c];
                const p01 = src[(y1 * w + x0) * 4 + c], p11 = src[(y1 * w + x1) * 4 + c];
                const top = p00 + (p10 - p00) * wx, bot = p01 + (p11 - p01) * wx;
                out[d + c] = Math.round(top + (bot - top) * wy);
            }
        }
    }
    return out;
}

// Composite the island centered over the sea, straight-alpha. Returns
// { rgba, w, h } at the sea's native dimensions.
function compositeCayo(buf) {
    const parsed = gfx.parse(buf);
    const bms = gfx.bitmaps(buf, parsed);
    const info = gfx.classify(bms);
    if (!info) { throw new Error('no compatible bitmaps'); }
    const W = info.sea.w, H = info.sea.h;
    const comp = Buffer.from(gfx.decode(buf, info.sea));   // start with sea
    const isl = info.islands[0];
    const land = gfx.decode(buf, isl);
    const { x: ox, y: oy } = info.offset;
    for (let y = 0; y < isl.h; y++) {
        for (let x = 0; x < isl.w; x++) {
            const s = (y * isl.w + x) * 4, A = land[s + 3];
            if (!A) { continue; }
            const dx = x + ox, dy = y + oy;
            if (dx < 0 || dy < 0 || dx >= W || dy >= H) { continue; }
            const d = (dy * W + dx) * 4, a = A / 255, ia = 1 - a;
            comp[d] = Math.round(land[s] * a + comp[d] * ia);
            comp[d + 1] = Math.round(land[s + 1] * a + comp[d + 1] * ia);
            comp[d + 2] = Math.round(land[s + 2] * a + comp[d + 2] * ia);
            comp[d + 3] = Math.max(comp[d + 3], A);
        }
    }
    return { rgba: comp, w: W, h: H };
}

/* ── main ────────────────────────────────────────────────── */
function main() {
    let catalog = [];
    const mapsJson = path.join(TILES, 'maps.json');
    if (fs.existsSync(mapsJson)) {
        try { catalog = JSON.parse(fs.readFileSync(mapsJson, 'utf8')); } catch (e) { catalog = []; }
    }
    // drop any previous cayo entries so re-runs stay clean
    catalog = catalog.filter(m => !m.cayo);
    const labelOf = {};
    catalog.forEach(m => { labelOf[m.id] = m.label; });

    const styles = fs.readdirSync(TPL, { withFileTypes: true })
        .filter(e => e.isDirectory() && fs.existsSync(path.join(TPL, e.name, CAYO_GFX)))
        .map(e => e.name);

    const cayoEntries = [];
    for (const style of styles) {
        try {
            const buf = fs.readFileSync(path.join(TPL, style, CAYO_GFX));
            const comp = compositeCayo(buf);
            const rgba = resize(comp.rgba, comp.w, comp.h, WORK, WORK);
            const outDir = path.join(TILES, 'cayo-' + style);
            fs.mkdirSync(outDir, { recursive: true });
            fs.writeFileSync(path.join(outDir, 'minimap_0_0.png'), encodePng(rgba, WORK, WORK));
            const baseLabel = labelOf[style] || style;
            cayoEntries.push({
                id: 'cayo-' + style,
                label: 'Cayo — ' + baseLabel,
                description: 'Paint the Cayo Perico island (' + baseLabel + ' style)',
                tiles: 1, format: 'GFX', native: comp.w,
                cayo: true, cayoStyle: style,
                rows: 1, cols: 1, tileSize: WORK,
            });
            console.log('✓ cayo-' + style + ' → html/tiles/cayo-' + style + '/minimap_0_0.png (' + comp.w + '×' + comp.h + ')');
        } catch (e) {
            console.log('✗ cayo-' + style + ': ' + e.message);
        }
    }

    fs.writeFileSync(mapsJson, JSON.stringify(catalog.concat(cayoEntries), null, 2));
    console.log('\nWrote ' + cayoEntries.length + ' Cayo map(s) into maps.json.');
}
main();
