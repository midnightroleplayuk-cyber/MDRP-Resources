/* ============================================================
   Apex Minimap Studio — .ytd → PNG tile extractor (multi-map)
   ------------------------------------------------------------
   For EVERY base map under templates/<map>/, decodes its six
   minimap_<r>_<c>.ytd tiles and writes:
       html/tiles/<map>/minimap_<r>_<c>.png
   plus a catalog the NUI reads to build the map picker:
       html/tiles/maps.json   [{ id, label, description, tiles }]

   Labels/descriptions come from MAP_META below (fallback: the
   folder name). Pure Node (zlib only), no dependencies.

   Usage:  node tools/extract_tiles.js
   ============================================================ */
'use strict';
const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

const ROOT = path.resolve(__dirname, '..');
const TPL = path.join(ROOT, 'templates');
const OUT = path.join(ROOT, 'html', 'tiles');

// Friendly names + order for the picker. Any folder not listed still
// shows up (label = folder name) after the listed ones.
const MAP_META = {
    original:        { label: 'Original',       description: 'The stock GTA V atlas — clean vector style' },
    color:           { label: 'Color',          description: 'Vivid, high-saturation take on the atlas' },
    'past-gen':      { label: 'Past Gen',        description: 'The PS3 / Xbox 360 era map look' },
    'real-map':      { label: 'Realistic',       description: 'Satellite-style realistic terrain, daytime' },
    'real-map-dawn': { label: 'Realistic Dawn',  description: 'Realistic terrain with warm dawn light' },
    satellite:       { label: 'Satellite',       description: 'Top-down real satellite imagery' },
};
const ORDER = Object.keys(MAP_META);

/* ── RSC7 + DXT decode (shared with make_ytd.js) ─────────── */
function flagsToSize(flags) {
    const baseSize = 0x2000 << (flags & 0xF);
    return baseSize * (((flags >> 17) & 0x7F) + ((flags >> 11) & 0x3F) * 2 +
        ((flags >> 7) & 0xF) * 4 + ((flags >> 5) & 0x3) * 8 + ((flags >> 4) & 0x1) * 16);
}
const FMT = { 21: 'A8R8G8B8', 827611204: 'DXT1', 861165636: 'DXT3', 894720068: 'DXT5' };

function findDescriptor(payload) {
    for (let i = 64; i + 0x28 <= payload.length; i++) {
        const w = payload.readUInt16LE(i), h = payload.readUInt16LE(i + 2);
        if (w < 8 || h < 8 || w > 8192 || h > 8192) { continue; }
        if ((w & (w - 1)) || (h & (h - 1))) { continue; }
        const fmt = payload.readUInt32LE(i + 8);
        if (!FMT[fmt]) { continue; }
        const levels = payload.readUInt8(i + 0xD);
        if (levels < 1 || levels > 14) { continue; }
        const dptr = payload.readBigUInt64LE(i + 0x20);
        if (dptr < 0x60000000n || dptr >= 0x70000000n) { continue; }
        return { w, h, fmt, levels, dataOffset: Number(dptr - 0x60000000n) };
    }
    return null;
}

function from565(v) {
    const r = (v >> 11) & 0x1f, g = (v >> 5) & 0x3f, b = v & 0x1f;
    return [(r << 3) | (r >> 2), (g << 2) | (g >> 4), (b << 3) | (b >> 2)];
}

function decodeDxt(block, w, h, dxt5) {
    const out = Buffer.alloc(w * h * 4);
    const bw = Math.ceil(w / 4), bh = Math.ceil(h / 4);
    const bs = dxt5 ? 16 : 8;
    for (let by = 0; by < bh; by++) {
        for (let bx = 0; bx < bw; bx++) {
            const o = (by * bw + bx) * bs;
            let alpha = null;
            if (dxt5) {
                const a0 = block[o], a1 = block[o + 1];
                const al = [a0, a1];
                if (a0 > a1) { for (let j = 1; j <= 6; j++) al.push(Math.round(((7 - j) * a0 + j * a1) / 7)); }
                else { for (let j = 1; j <= 4; j++) al.push(Math.round(((5 - j) * a0 + j * a1) / 5)); al.push(0, 255); }
                let bits = 0n;
                for (let b = 0; b < 6; b++) { bits |= BigInt(block[o + 2 + b]) << BigInt(b * 8); }
                alpha = [];
                for (let i = 0; i < 16; i++) { alpha.push(al[Number((bits >> BigInt(i * 3)) & 7n)]); }
            }
            const co = o + (dxt5 ? 8 : 0);
            const c0 = block.readUInt16LE(co), c1 = block.readUInt16LE(co + 2);
            const p0 = from565(c0), p1 = from565(c1);
            const pal = [p0, p1, [0, 0, 0], [0, 0, 0]];
            const opaque = dxt5 || c0 > c1;
            if (opaque) {
                for (let c = 0; c < 3; c++) {
                    pal[2][c] = Math.round((2 * p0[c] + p1[c]) / 3);
                    pal[3][c] = Math.round((p0[c] + 2 * p1[c]) / 3);
                }
            } else {
                for (let c = 0; c < 3; c++) { pal[2][c] = (p0[c] + p1[c]) >> 1; }
            }
            const idx = block.readUInt32LE(co + 4);
            for (let py = 0; py < 4; py++) {
                for (let px = 0; px < 4; px++) {
                    const x = bx * 4 + px, y = by * 4 + py;
                    if (x >= w || y >= h) { continue; }
                    const i = py * 4 + px;
                    const sel = (idx >> (i * 2)) & 3;
                    const d = (y * w + x) * 4;
                    out[d] = pal[sel][0]; out[d + 1] = pal[sel][1]; out[d + 2] = pal[sel][2];
                    out[d + 3] = alpha ? alpha[i] : ((!opaque && sel === 3) ? 0 : 255);
                }
            }
        }
    }
    return out;
}

/* ── PNG encode (filter 0, RGBA8) ────────────────────────── */
function crc32(buf) {
    let c, table = crc32.table;
    if (!table) {
        table = crc32.table = new Int32Array(256);
        for (let n = 0; n < 256; n++) {
            c = n;
            for (let k = 0; k < 8; k++) { c = (c & 1) ? (0xedb88320 ^ (c >>> 1)) : (c >>> 1); }
            table[n] = c;
        }
    }
    c = 0xffffffff;
    for (let i = 0; i < buf.length; i++) { c = table[(c ^ buf[i]) & 0xff] ^ (c >>> 8); }
    return (c ^ 0xffffffff) >>> 0;
}
function chunk(type, data) {
    const out = Buffer.alloc(12 + data.length);
    out.writeUInt32BE(data.length, 0);
    out.write(type, 4, 'ascii');
    data.copy(out, 8);
    out.writeUInt32BE(crc32(out.slice(4, 8 + data.length)), 8 + data.length);
    return out;
}
function encodePng(rgba, w, h) {
    const ihdr = Buffer.alloc(13);
    ihdr.writeUInt32BE(w, 0); ihdr.writeUInt32BE(h, 4);
    ihdr[8] = 8; ihdr[9] = 6; ihdr[10] = 0; ihdr[11] = 0; ihdr[12] = 0;
    const stride = w * 4;
    const raw = Buffer.alloc((stride + 1) * h);
    for (let y = 0; y < h; y++) {
        raw[y * (stride + 1)] = 0;
        rgba.copy(raw, y * (stride + 1) + 1, y * stride, (y + 1) * stride);
    }
    return Buffer.concat([
        Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]),
        chunk('IHDR', ihdr),
        chunk('IDAT', zlib.deflateSync(raw, { level: 6 })),
        chunk('IEND', Buffer.alloc(0)),
    ]);
}

// D3DFMT_A8R8G8B8 stores pixels as B,G,R,A in memory → RGBA.
function decodeBgra(block, w, h) {
    const out = Buffer.alloc(w * h * 4);
    for (let i = 0; i < w * h; i++) {
        const s = i * 4, d = i * 4;
        out[d] = block[s + 2];      // R
        out[d + 1] = block[s + 1];  // G
        out[d + 2] = block[s];      // B
        out[d + 3] = block[s + 3];  // A
    }
    return out;
}

// Box-average downscale RGBA to a target size (used to bring the huge
// 4096 uncompressed tiles down to the 2048 working resolution — plenty
// for a minimap and light enough for the CEF canvas editor).
function downscale(rgba, w, h, tw, th) {
    if (w === tw && h === th) { return rgba; }
    const out = Buffer.alloc(tw * th * 4);
    const sx = w / tw, sy = h / th;
    for (let y = 0; y < th; y++) {
        const y0 = Math.floor(y * sy), y1 = Math.min(h, Math.floor((y + 1) * sy));
        for (let x = 0; x < tw; x++) {
            const x0 = Math.floor(x * sx), x1 = Math.min(w, Math.floor((x + 1) * sx));
            let r = 0, g = 0, b = 0, a = 0, n = 0;
            for (let yy = y0; yy < y1; yy++) {
                for (let xx = x0; xx < x1; xx++) {
                    const s = (yy * w + xx) * 4;
                    r += rgba[s]; g += rgba[s + 1]; b += rgba[s + 2]; a += rgba[s + 3]; n++;
                }
            }
            const d = (y * tw + x) * 4;
            out[d] = (r / n) | 0; out[d + 1] = (g / n) | 0;
            out[d + 2] = (b / n) | 0; out[d + 3] = (a / n) | 0;
        }
    }
    return out;
}

const WORK_SIZE = 2048;   // editor/base working resolution per tile

function decodeTile(ytdPath) {
    const buf = fs.readFileSync(ytdPath);
    if (buf.readUInt32LE(0) !== 0x37435352) { throw new Error('not RSC7'); }
    const payload = zlib.inflateRawSync(buf.slice(16));
    const sysSize = flagsToSize(buf.readUInt32LE(8));
    const desc = findDescriptor(payload);
    if (!desc) { throw new Error('descriptor not found'); }
    const gfx = payload.slice(sysSize + desc.dataOffset);
    let rgba;
    if (desc.fmt === 21) {
        rgba = decodeBgra(gfx, desc.w, desc.h);           // A8R8G8B8 (raw)
    } else {
        const dxt5 = desc.fmt === 894720068 || desc.fmt === 861165636;
        rgba = decodeDxt(gfx, desc.w, desc.h, dxt5);      // DXT1/3/5
    }
    // downscale big tiles to the working resolution
    const tw = Math.min(WORK_SIZE, desc.w), th = Math.min(WORK_SIZE, desc.h);
    rgba = downscale(rgba, desc.w, desc.h, tw, th);
    return { png: encodePng(rgba, tw, th), fmt: FMT[desc.fmt] || String(desc.fmt), native: desc.w };
}

/* ── main ────────────────────────────────────────────────── */
// A map installed by tools/import_map.js carries its own name and its
// tiles are ALREADY in html/tiles/<id>/. Re-extracting it here would
// overwrite them with whatever .ytd the importer had to borrow, so this
// reads the folder's map.json instead and leaves the PNGs alone.
function importedMeta(dir) {
    const p = path.join(dir, 'map.json');
    if (!fs.existsSync(p)) { return null; }
    try {
        const m = JSON.parse(fs.readFileSync(p, 'utf8'));
        return m && m.imported ? m : null;
    } catch (e) { return null; }
}

function main() {
    if (!fs.existsSync(TPL)) { console.log('No templates/ folder.'); return; }
    const mapDirs = fs.readdirSync(TPL, { withFileTypes: true })
        .filter(e => e.isDirectory())
        // folders starting with "_" are build assets, not base maps
        // (templates/_light is the small-export tile pack)
        .filter(e => !e.name.startsWith('_'))
        .map(e => e.name);
    if (!mapDirs.length) { console.log('No map folders under templates/.'); return; }

    // whatever is already in the catalog — Cayo entries are appended by
    // extract_cayo.js and must survive a re-run of this script
    let previous = [];
    try { previous = JSON.parse(fs.readFileSync(path.join(OUT, 'maps.json'), 'utf8')) || []; }
    catch (e) { previous = []; }

    // stable order: listed first, then any extras alphabetically
    mapDirs.sort((a, b) => {
        const ia = ORDER.indexOf(a), ib = ORDER.indexOf(b);
        if (ia !== -1 || ib !== -1) { return (ia === -1 ? 99 : ia) - (ib === -1 ? 99 : ib); }
        return a.localeCompare(b);
    });

    const catalog = [];
    for (const map of mapDirs) {
        const mapTpl = path.join(TPL, map);

        const imported = importedMeta(mapTpl);
        if (imported) {
            const dir = path.join(OUT, map);
            const have = fs.existsSync(dir) ? fs.readdirSync(dir).filter(f => /^minimap_\d+_\d+\.png$/i.test(f)).length : 0;
            const old = previous.find(m => m.id === map) || {};
            catalog.push({
                id: map,
                label: imported.label || map,
                description: imported.description || '',
                tiles: have,
                format: old.format || 'PNG',
                native: old.native || WORK_SIZE,
                imported: true,
            });
            console.log(`· ${map}: imported map, left as-is (${have} tiles)`);
            continue;
        }

        const tiles = fs.readdirSync(mapTpl).filter(f => /^minimap_\d+_\d+\.ytd$/i.test(f));
        if (!tiles.length) { console.log(`- ${map}: no tiles, skipping`); continue; }
        const mapOut = path.join(OUT, map);
        fs.mkdirSync(mapOut, { recursive: true });
        let ok = 0, fmt = '?', native = WORK_SIZE;
        for (const f of tiles) {
            try {
                const r = decodeTile(path.join(mapTpl, f));
                fs.writeFileSync(path.join(mapOut, f.replace(/\.ytd$/i, '.png')), r.png);
                fmt = r.fmt; native = r.native;
                ok++;
            } catch (e) {
                console.log(`  ✗ ${map}/${f}: ${e.message}`);
            }
        }
        const meta = MAP_META[map] || { label: map, description: '' };
        catalog.push({ id: map, label: meta.label, description: meta.description, tiles: ok, format: fmt, native });
        console.log(`✓ ${map}: ${ok}/${tiles.length} tiles (${fmt} ${native}px) → html/tiles/${map}/`);
    }

    // keep anything we did not regenerate (the Cayo entries) at the end
    const seen = new Set(catalog.map(m => m.id));
    const kept = previous.filter(m => m && m.id && !seen.has(m.id));
    const merged = catalog.concat(kept);

    fs.writeFileSync(path.join(OUT, 'maps.json'), JSON.stringify(merged, null, 2));
    console.log(`\nWrote html/tiles/maps.json (${catalog.length} maps${kept.length ? `, ${kept.length} kept` : ''}).`);
}
main();
