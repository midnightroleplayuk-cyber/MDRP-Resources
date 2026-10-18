/* ============================================================
   Apex Minimap Studio — import ANY minimap you already have
   ------------------------------------------------------------
   Turns a minimap you downloaded, bought or made into a base
   map you can paint on inside the studio.

   Usage (Windows):  drag the folder/zip onto tools\import_map.bat
                     — or just double-click it after dropping the
                     files into tools\map_in\
   Usage (Linux):    bash tools/import_map.sh /path/to/map
                     — or drop the files in tools/map_in/ and run
                     bash tools/import_map.sh

   It accepts, and auto-detects, whatever the pack happens to be:
     · a whole resource folder (it digs through stream/ for you)
     · minimap_<r>_<c>.ytd     — the usual FiveM minimap pack
     · minimap_<r>_<c>.dds     — raw textures (DXT1/3/5 or 32-bit)
     · minimap_<r>_<c>.png     — already-extracted tiles
     · a .zip of any of the above
     · ONE big PNG of the whole atlas — it gets sliced into the
       six tiles for you

   What it installs:
     templates/<id>/minimap_<r>_<c>.ytd   → so exports can use the
                                            pack's own tiles as the
                                            .ytd template
     templates/<id>/map.json              → its name in the picker
     html/tiles/<id>/minimap_<r>_<c>.png  → what the editor paints on
     html/tiles/maps.json                 → the picker catalog entry

   Other commands:
     node import_map.js --list
     node import_map.js --remove <id>

   Pure Node (zlib only). No dependencies, no OpenIV, no
   CodeWalker, and it runs headless over SSH on Linux.
   ============================================================ */
'use strict';
const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

const ROOT = path.resolve(__dirname, '..');
const IN_DIR = path.join(__dirname, 'map_in');
const TPL = path.join(ROOT, 'templates');
const TILES = path.join(ROOT, 'html', 'tiles');

const WORK = 2048;      // editor working resolution per tile
const ROWS = 3;         // minimap_<row>_<col> — 3 rows × 2 cols = the atlas
const COLS = 2;
// Stock map ids: re-importing over one of these would overwrite what
// ships with the studio, so an import that lands on one gets suffixed.
const STOCK = new Set(['original', 'color', 'past-gen', 'real-map', 'real-map-dawn', 'satellite', '_light']);

const notes = [];
const say = (s) => console.log(s);
const note = (s) => { notes.push(s); };

/* ════════════════════════════════════════════════════════════
   PNG decode — deliberately more forgiving than the one in
   make_ytd.js: a map someone downloaded can be palette-based,
   greyscale or 16-bit, and "your PNG is the wrong flavour" is a
   terrible thing to tell someone who just wants their map in.
   ════════════════════════════════════════════════════════════ */
function decodePng(buf) {
    if (buf.length < 8 || buf.readUInt32BE(0) !== 0x89504e47) { throw new Error('not a PNG'); }
    let off = 8, w = 0, h = 0, depth = 0, color = 0, interlace = 0;
    let palette = null, trns = null;
    const idat = [];
    while (off + 8 <= buf.length) {
        const len = buf.readUInt32BE(off);
        const type = buf.toString('ascii', off + 4, off + 8);
        const data = buf.slice(off + 8, off + 8 + len);
        if (type === 'IHDR') {
            w = data.readUInt32BE(0); h = data.readUInt32BE(4);
            depth = data[8]; color = data[9]; interlace = data[12];
        } else if (type === 'PLTE') { palette = data; }
        else if (type === 'tRNS') { trns = data; }
        else if (type === 'IDAT') { idat.push(data); }
        else if (type === 'IEND') { break; }
        off += 12 + len;
    }
    if (!w || !h) { throw new Error('PNG header missing'); }
    if (interlace) { throw new Error('interlaced PNG — re-save it without "interlace"/"progressive"'); }
    if (![1, 2, 4, 8, 16].includes(depth)) { throw new Error('unsupported bit depth ' + depth); }
    if (color === 3 && !palette) { throw new Error('palette PNG without a palette'); }

    const chan = { 0: 1, 2: 3, 3: 1, 4: 2, 6: 4 }[color];
    if (!chan) { throw new Error('unsupported colour type ' + color); }

    const bpp = Math.max(1, (chan * depth) >> 3);        // filter step, in bytes
    const stride = Math.ceil(w * chan * depth / 8);
    const raw = zlib.inflateSync(Buffer.concat(idat));
    if (raw.length < (stride + 1) * h) { throw new Error('PNG data truncated'); }

    // undo the per-scanline filters
    const lines = Buffer.alloc(stride * h);
    let p = 0;
    for (let y = 0; y < h; y++) {
        const f = raw[p++];
        raw.copy(lines, y * stride, p, p + stride); p += stride;
        const cur = y * stride, prev = (y - 1) * stride;
        for (let x = 0; x < stride; x++) {
            const a = x >= bpp ? lines[cur + x - bpp] : 0;
            const b = y > 0 ? lines[prev + x] : 0;
            const c = (y > 0 && x >= bpp) ? lines[prev + x - bpp] : 0;
            let v = lines[cur + x];
            if (f === 1) { v += a; }
            else if (f === 2) { v += b; }
            else if (f === 3) { v += (a + b) >> 1; }
            else if (f === 4) {
                const pa = Math.abs(b - c), pb = Math.abs(a - c), pc = Math.abs(a + b - 2 * c);
                v += (pa <= pb && pa <= pc) ? a : (pb <= pc ? b : c);
            }
            lines[cur + x] = v & 0xff;
        }
    }

    // sample any depth/colour type into straight RGBA8
    const out = Buffer.alloc(w * h * 4);
    const max = (1 << depth) - 1;
    const sample = (row, i) => {
        if (depth === 16) { return lines[row + i * 2]; }             // take the high byte
        if (depth === 8) { return lines[row + i]; }
        const bitPos = i * depth;
        const byte = lines[row + (bitPos >> 3)];
        const shift = 8 - depth - (bitPos & 7);
        return (byte >> shift) & max;
    };
    for (let y = 0; y < h; y++) {
        const row = y * stride;
        for (let x = 0; x < w; x++) {
            const d = (y * w + x) * 4;
            if (color === 3) {
                const idx = sample(row, x);
                out[d] = palette[idx * 3] || 0;
                out[d + 1] = palette[idx * 3 + 1] || 0;
                out[d + 2] = palette[idx * 3 + 2] || 0;
                out[d + 3] = trns && idx < trns.length ? trns[idx] : 255;
            } else if (color === 0 || color === 4) {
                let g = sample(row, x * chan);
                if (depth < 8) { g = Math.round(g * 255 / max); }
                out[d] = out[d + 1] = out[d + 2] = g;
                out[d + 3] = color === 4 ? sample(row, x * chan + 1) : 255;
            } else {
                const s = x * chan;
                out[d] = sample(row, s);
                out[d + 1] = sample(row, s + 1);
                out[d + 2] = sample(row, s + 2);
                out[d + 3] = chan === 4 ? sample(row, s + 3) : 255;
            }
        }
    }
    return { w, h, rgba: out };
}

/* ── PNG encode (filter 0, RGBA8) — same as extract_tiles.js ── */
function crc32(buf) {
    let table = crc32.table;
    if (!table) {
        table = crc32.table = new Int32Array(256);
        for (let n = 0; n < 256; n++) {
            let c = n;
            for (let k = 0; k < 8; k++) { c = (c & 1) ? (0xedb88320 ^ (c >>> 1)) : (c >>> 1); }
            table[n] = c;
        }
    }
    let c = 0xffffffff;
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
    ihdr[8] = 8; ihdr[9] = 6;
    const stride = w * 4;
    const rawBuf = Buffer.alloc((stride + 1) * h);
    for (let y = 0; y < h; y++) {
        rawBuf[y * (stride + 1)] = 0;
        rgba.copy(rawBuf, y * (stride + 1) + 1, y * stride, (y + 1) * stride);
    }
    return Buffer.concat([
        Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]),
        chunk('IHDR', ihdr),
        chunk('IDAT', zlib.deflateSync(rawBuf, { level: 6 })),
        chunk('IEND', Buffer.alloc(0)),
    ]);
}

/* ════════════════════════════════════════════════════════════
   DXT + .ytd + .dds decode
   The .ytd path is byte-for-byte the one in extract_tiles.js, so
   an imported pack lands in exactly the same shape as the maps
   that ship with the studio.
   ════════════════════════════════════════════════════════════ */
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

function decodeDxt(block, w, h, dxt5, dxt3) {
    const out = Buffer.alloc(w * h * 4);
    const bw = Math.ceil(w / 4), bh = Math.ceil(h / 4);
    const bs = (dxt5 || dxt3) ? 16 : 8;
    if (block.length < bw * bh * bs) { throw new Error('texture data truncated'); }
    for (let by = 0; by < bh; by++) {
        for (let bx = 0; bx < bw; bx++) {
            const o = (by * bw + bx) * bs;
            let alpha = null;
            if (dxt3) {
                // DXT3: 16 explicit 4-bit alphas
                alpha = [];
                for (let i = 0; i < 16; i++) {
                    const b = block[o + (i >> 1)];
                    const a4 = (i & 1) ? (b >> 4) : (b & 0xF);
                    alpha.push(a4 * 17);
                }
            } else if (dxt5) {
                const a0 = block[o], a1 = block[o + 1];
                const al = [a0, a1];
                if (a0 > a1) { for (let j = 1; j <= 6; j++) { al.push(Math.round(((7 - j) * a0 + j * a1) / 7)); } }
                else { for (let j = 1; j <= 4; j++) { al.push(Math.round(((5 - j) * a0 + j * a1) / 5)); } al.push(0, 255); }
                let bits = 0n;
                for (let b = 0; b < 6; b++) { bits |= BigInt(block[o + 2 + b]) << BigInt(b * 8); }
                alpha = [];
                for (let i = 0; i < 16; i++) { alpha.push(al[Number((bits >> BigInt(i * 3)) & 7n)]); }
            }
            const co = o + ((dxt5 || dxt3) ? 8 : 0);
            const c0 = block.readUInt16LE(co), c1 = block.readUInt16LE(co + 2);
            const p0 = from565(c0), p1 = from565(c1);
            const pal = [p0, p1, [0, 0, 0], [0, 0, 0]];
            const opaque = dxt5 || dxt3 || c0 > c1;
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

// D3DFMT_A8R8G8B8 stores pixels B,G,R,A in memory.
function decodeBgra(block, w, h) {
    if (block.length < w * h * 4) { throw new Error('texture data truncated'); }
    const out = Buffer.alloc(w * h * 4);
    for (let i = 0; i < w * h; i++) {
        const s = i * 4, d = i * 4;
        out[d] = block[s + 2]; out[d + 1] = block[s + 1];
        out[d + 2] = block[s]; out[d + 3] = block[s + 3];
    }
    return out;
}

function decodeYtd(buf) {
    if (buf.length < 20 || buf.readUInt32LE(0) !== 0x37435352) {
        throw new Error('not a real .ytd (missing the RSC7 header) — if it came out of an .rpf, export it properly first');
    }
    let payload;
    try { payload = zlib.inflateRawSync(buf.slice(16)); }
    catch (e) { throw new Error('the .ytd is compressed in a way this tool cannot read'); }
    const sysSize = flagsToSize(buf.readUInt32LE(8));
    const desc = findDescriptor(payload);
    if (!desc) { throw new Error('no texture found inside the .ytd'); }
    const gfx = payload.slice(sysSize + desc.dataOffset);
    const dxt5 = desc.fmt === 894720068, dxt3 = desc.fmt === 861165636;
    const rgba = desc.fmt === 21 ? decodeBgra(gfx, desc.w, desc.h) : decodeDxt(gfx, desc.w, desc.h, dxt5, dxt3);
    return { w: desc.w, h: desc.h, rgba, format: FMT[desc.fmt] || String(desc.fmt) };
}

// .dds — plain DirectDraw Surface, including the DX10 extension header.
const DXGI = { 70: 'DXT1', 71: 'DXT1', 72: 'DXT1', 73: 'DXT3', 74: 'DXT3', 75: 'DXT3',
               76: 'DXT5', 77: 'DXT5', 78: 'DXT5', 87: 'BGRA', 88: 'BGRA', 28: 'RGBA', 29: 'RGBA' };
function decodeDds(buf) {
    if (buf.length < 128 || buf.readUInt32LE(0) !== 0x20534444) { throw new Error('not a .dds'); }
    const h = buf.readUInt32LE(12), w = buf.readUInt32LE(16);
    const fourCC = buf.toString('ascii', 84, 88);
    let dataOff = 128, kind = fourCC;
    if (fourCC === 'DX10') {
        if (buf.length < 148) { throw new Error('.dds DX10 header truncated'); }
        kind = DXGI[buf.readUInt32LE(128)] || '';
        dataOff = 148;
        if (!kind) { throw new Error('.dds uses a DXGI format this tool cannot read'); }
    }
    const data = buf.slice(dataOff);
    if (kind === 'DXT1' || kind === 'DXT3' || kind === 'DXT5') {
        return { w, h, rgba: decodeDxt(data, w, h, kind === 'DXT5', kind === 'DXT3'), format: kind };
    }
    const bits = buf.readUInt32LE(88);
    const rMask = buf.readUInt32LE(92), bMask = buf.readUInt32LE(100);
    if (kind === 'BGRA' || (bits === 32 && rMask === 0x00ff0000)) {
        return { w, h, rgba: decodeBgra(data, w, h), format: 'A8R8G8B8' };
    }
    if (kind === 'RGBA' || (bits === 32 && bMask === 0x00ff0000)) {
        if (data.length < w * h * 4) { throw new Error('texture data truncated'); }
        return { w, h, rgba: Buffer.from(data.slice(0, w * h * 4)), format: 'A8B8G8R8' };
    }
    throw new Error('.dds pixel format not supported (needs DXT1/3/5 or 32-bit)');
}

/* ── box-average downscale / bilinear upscale to a target size ── */
function scaleTo(img, tw, th) {
    const { w, h, rgba } = img;
    if (w === tw && h === th) { return rgba; }
    const out = Buffer.alloc(tw * th * 4);
    if (w >= tw && h >= th) {                       // shrinking: average, no aliasing
        const sx = w / tw, sy = h / th;
        for (let y = 0; y < th; y++) {
            const y0 = Math.floor(y * sy), y1 = Math.max(y0 + 1, Math.min(h, Math.floor((y + 1) * sy)));
            for (let x = 0; x < tw; x++) {
                const x0 = Math.floor(x * sx), x1 = Math.max(x0 + 1, Math.min(w, Math.floor((x + 1) * sx)));
                let r = 0, g = 0, b = 0, a = 0, n = 0;
                for (let yy = y0; yy < y1; yy++) {
                    for (let xx = x0; xx < x1; xx++) {
                        const s = (yy * w + xx) * 4;
                        r += rgba[s]; g += rgba[s + 1]; b += rgba[s + 2]; a += rgba[s + 3]; n++;
                    }
                }
                const d = (y * tw + x) * 4;
                out[d] = (r / n) | 0; out[d + 1] = (g / n) | 0; out[d + 2] = (b / n) | 0; out[d + 3] = (a / n) | 0;
            }
        }
        return out;
    }
    const sx = w / tw, sy = h / th;                 // growing: bilinear
    for (let y = 0; y < th; y++) {
        const fy = (y + 0.5) * sy - 0.5, y0 = Math.max(0, Math.floor(fy));
        const y1 = Math.min(h - 1, y0 + 1), wy = fy - y0;
        for (let x = 0; x < tw; x++) {
            const fx = (x + 0.5) * sx - 0.5, x0 = Math.max(0, Math.floor(fx));
            const x1 = Math.min(w - 1, x0 + 1), wx = fx - x0;
            const d = (y * tw + x) * 4;
            for (let c = 0; c < 4; c++) {
                const p00 = rgba[(y0 * w + x0) * 4 + c], p10 = rgba[(y0 * w + x1) * 4 + c];
                const p01 = rgba[(y1 * w + x0) * 4 + c], p11 = rgba[(y1 * w + x1) * 4 + c];
                const top = p00 + (p10 - p00) * wx, bot = p01 + (p11 - p01) * wx;
                out[d + c] = Math.round(top + (bot - top) * wy);
            }
        }
    }
    return out;
}

function crop(img, x0, y0, cw, ch) {
    const out = Buffer.alloc(cw * ch * 4);
    for (let y = 0; y < ch; y++) {
        const s = ((y0 + y) * img.w + x0) * 4;
        img.rgba.copy(out, y * cw * 4, s, s + cw * 4);
    }
    return { w: cw, h: ch, rgba: out };
}

/* ════════════════════════════════════════════════════════════
   ZIP reader — stored + deflate, straight from the central
   directory. Enough for "I downloaded a minimap.zip".
   ════════════════════════════════════════════════════════════ */
function readZip(buf) {
    let eocd = -1;
    for (let i = buf.length - 22; i >= 0 && i >= buf.length - 66000; i--) {
        if (buf.readUInt32LE(i) === 0x06054b50) { eocd = i; break; }
    }
    if (eocd < 0) { throw new Error('not a .zip (or it is split across several files)'); }
    const count = buf.readUInt16LE(eocd + 10);
    let off = buf.readUInt32LE(eocd + 16);
    if (off === 0xffffffff) { throw new Error('ZIP64 archive — please extract it yourself and point the tool at the folder'); }
    const out = [];
    for (let i = 0; i < count && off + 46 <= buf.length; i++) {
        if (buf.readUInt32LE(off) !== 0x02014b50) { break; }
        const method = buf.readUInt16LE(off + 10);
        const cSize = buf.readUInt32LE(off + 20);
        const nLen = buf.readUInt16LE(off + 28);
        const eLen = buf.readUInt16LE(off + 30);
        const cLen = buf.readUInt16LE(off + 32);
        const lho = buf.readUInt32LE(off + 42);
        const name = buf.toString('utf8', off + 46, off + 46 + nLen);
        off += 46 + nLen + eLen + cLen;
        if (name.endsWith('/') || cSize === 0) { continue; }
        if (lho + 30 > buf.length || buf.readUInt32LE(lho) !== 0x04034b50) { continue; }
        const lN = buf.readUInt16LE(lho + 26), lE = buf.readUInt16LE(lho + 28);
        const start = lho + 30 + lN + lE;
        const comp = buf.slice(start, start + cSize);
        out.push({
            name,
            read: () => {
                if (method === 0) { return comp; }
                if (method === 8) { return zlib.inflateRawSync(comp); }
                throw new Error('compression method ' + method + ' not supported — extract the zip yourself');
            },
        });
    }
    return out;
}

/* ════════════════════════════════════════════════════════════
   Finding the map in whatever the user dropped
   ════════════════════════════════════════════════════════════ */
const IMAGEY = /\.(ytd|dds|png)$/i;
const SKIP_DIR = /^(node_modules|\.git|__MACOSX)$/i;

function walk(dir, base, out, depth) {
    if (depth > 10) { return; }
    let entries;
    try { entries = fs.readdirSync(dir, { withFileTypes: true }); }
    catch (e) { return; }
    for (const e of entries) {
        if (e.name.startsWith('.') || SKIP_DIR.test(e.name)) { continue; }
        const p = path.join(dir, e.name);
        if (e.isDirectory()) { walk(p, base, out, depth + 1); continue; }
        out.push({ name: e.name, rel: path.relative(base, p).replace(/\\/g, '/'), read: () => fs.readFileSync(p) });
    }
}

function collect(input) {
    const found = [];
    const st = fs.statSync(input);
    if (st.isDirectory()) { walk(input, input, found, 0); }
    else { found.push({ name: path.basename(input), rel: path.basename(input), read: () => fs.readFileSync(input) }); }

    // expand any zips in place
    const files = [];
    for (const f of found) {
        if (/\.zip$/i.test(f.name)) {
            try {
                for (const z of readZip(f.read())) {
                    if (SKIP_DIR.test(z.name.split('/')[0] || '')) { continue; }
                    files.push({ name: path.basename(z.name), rel: f.rel + '!/' + z.name, read: z.read });
                }
                say(`  unpacked ${f.name}`);
            } catch (e) { note(`could not read ${f.name}: ${e.message}`); }
            continue;
        }
        if (/\.(rar|7z|tar|gz)$/i.test(f.name)) {
            note(`${f.name} is a ${path.extname(f.name).slice(1).toUpperCase()} archive — this tool only opens .zip. Extract it and run again.`);
            continue;
        }
        files.push(f);
    }
    return files;
}

// "minimap_sea_1_0.ytd", "minimap_1_0.dds", "1_0.png" → { r:1, c:0 }
function tileIndex(name) {
    const base = name.replace(/\.[^.]+$/, '');
    if (/lod/i.test(base)) { return null; }
    const m = base.match(/(\d+)[ _-](\d+)$/);
    if (!m) { return null; }
    const r = +m[1], c = +m[2];
    if (r >= ROWS || c >= COLS) { return null; }
    return { r, c };
}

const RANK = { ytd: 3, dds: 2, png: 1 };
function extOf(name) { return (name.match(/\.([^.]+)$/) || [, ''])[1].toLowerCase(); }

function decodeFile(f) {
    const ext = extOf(f.name);
    const buf = f.read();
    if (ext === 'ytd') { return decodeYtd(buf); }
    if (ext === 'dds') { return decodeDds(buf); }
    const png = decodePng(buf);
    return { w: png.w, h: png.h, rgba: png.rgba, format: 'PNG' };
}

/* ════════════════════════════════════════════════════════════
   Install
   ════════════════════════════════════════════════════════════ */
function slug(s) {
    return String(s).toLowerCase()
        .replace(/\.(zip|ytd|dds|png)$/i, '')
        .replace(/[^a-z0-9]+/g, '-')
        .replace(/^-+|-+$/g, '')
        .slice(0, 32) || 'my-map';
}
function titleCase(s) {
    return s.replace(/-+/g, ' ').replace(/\b\w/g, ch => ch.toUpperCase()).trim();
}

function readMapsJson() {
    const p = path.join(TILES, 'maps.json');
    if (!fs.existsSync(p)) { return []; }
    try { const j = JSON.parse(fs.readFileSync(p, 'utf8')); return Array.isArray(j) ? j : []; }
    catch (e) { return []; }
}
// Upsert, never rewrite: Cayo entries and the stock maps must survive.
function writeMapsJson(list) {
    fs.mkdirSync(TILES, { recursive: true });
    fs.writeFileSync(path.join(TILES, 'maps.json'), JSON.stringify(list, null, 2));
}

function copyIfMissing(src, dst) {
    if (!fs.existsSync(src) || fs.existsSync(dst)) { return false; }
    const st = fs.statSync(src);
    if (st.isDirectory()) {
        fs.mkdirSync(dst, { recursive: true });
        for (const f of fs.readdirSync(src)) { copyIfMissing(path.join(src, f), path.join(dst, f)); }
    } else {
        fs.mkdirSync(path.dirname(dst), { recursive: true });
        fs.copyFileSync(src, dst);
    }
    return true;
}

function uniqueId(want) {
    let id = want;
    if (STOCK.has(id)) { id = id + '-custom'; }
    let n = 2;
    while (STOCK.has(id) || (fs.existsSync(path.join(TPL, id)) && !isImported(id))) {
        id = want + '-' + n++;
    }
    return id;
}
function isImported(id) {
    const p = path.join(TPL, id, 'map.json');
    if (!fs.existsSync(p)) { return false; }
    try { return !!JSON.parse(fs.readFileSync(p, 'utf8')).imported; } catch (e) { return false; }
}

function importMap(input, opts) {
    say(`Reading ${input}`);
    const files = collect(input).filter(f => IMAGEY.test(f.name));
    if (!files.length) {
        throw new Error('nothing importable in there.\n'
            + '  Expected minimap_<r>_<c>.ytd / .dds / .png, a .zip of them,\n'
            + '  or a single PNG of the whole atlas.\n'
            + '  (JPG is not supported — open it and re-save as PNG.)');
    }

    /* pick the best file for each of the six tiles */
    const best = new Map();
    const loose = [];
    for (const f of files) {
        const idx = tileIndex(f.name);
        if (!idx) { loose.push(f); continue; }
        const key = idx.r + '_' + idx.c;
        const prev = best.get(key);
        if (!prev || RANK[extOf(f.name)] > RANK[extOf(prev.f.name)]) { best.set(key, { f, ...idx }); }
    }

    const decoded = new Map();      // "r_c" → { w,h,rgba,format }
    let srcFormat = '', srcNative = 0;
    const ytdSources = new Map();   // "r_c" → Buffer, to reuse as the export template

    if (best.size) {
        say(`Found ${best.size} tile${best.size === 1 ? '' : 's'}`);
        for (const [key, t] of best) {
            try {
                const img = decodeFile(t.f);
                decoded.set(key, img);
                srcFormat = img.format; srcNative = Math.max(srcNative, img.w);
                if (extOf(t.f.name) === 'ytd') { ytdSources.set(key, t.f.read()); }
                say(`  ok  ${t.f.rel}  ${img.w}x${img.h} ${img.format}`);
            } catch (e) {
                note(`${t.f.rel}: ${e.message}`);
                say(`  --  ${t.f.rel}  (${e.message})`);
            }
        }
    }

    /* nothing tile-shaped? maybe it is one big atlas image */
    if (!decoded.size) {
        const images = loose.filter(f => /\.(png|dds)$/i.test(f.name));
        // the biggest one is the atlas; a pack rarely ships two full maps
        let atlas = null;
        for (const f of images) {
            try {
                const img = decodeFile(f);
                if (!atlas || img.w * img.h > atlas.img.w * atlas.img.h) { atlas = { f, img }; }
            } catch (e) { note(`${f.rel}: ${e.message}`); }
        }
        if (!atlas) {
            throw new Error('found files but none of them could be read.\n  ' + notes.slice(-3).join('\n  '));
        }
        const { img, f } = atlas;
        const ratio = img.w / img.h;
        say(`Using ${f.rel} as one whole-atlas image (${img.w}x${img.h})`);
        if (Math.abs(ratio - COLS / ROWS) > 0.08) {
            note(`the image is ${img.w}x${img.h}; the GTA atlas is 2:3 (e.g. 4096x6144). It was stretched to fit — expect some distortion.`);
        }
        // normalise to an exact 2:3 atlas, then cut the six tiles
        const full = { w: WORK * COLS, h: WORK * ROWS, rgba: scaleTo(img, WORK * COLS, WORK * ROWS) };
        for (let r = 0; r < ROWS; r++) {
            for (let c = 0; c < COLS; c++) {
                decoded.set(r + '_' + c, { ...crop(full, c * WORK, r * WORK, WORK, WORK), format: 'PNG' });
            }
        }
        srcFormat = 'PNG'; srcNative = Math.max(img.w / COLS, WORK) | 0;
    }

    /* fill any gaps from the stock map so the atlas is never half-blank */
    const missing = [];
    for (let r = 0; r < ROWS; r++) {
        for (let c = 0; c < COLS; c++) {
            const key = r + '_' + c;
            if (decoded.has(key)) { continue; }
            missing.push(`minimap_${r}_${c}`);
            const stock = path.join(TILES, 'original', `minimap_${r}_${c}.png`);
            if (fs.existsSync(stock)) {
                const img = decodePng(fs.readFileSync(stock));
                decoded.set(key, { ...img, format: 'PNG' });
            }
        }
    }
    if (missing.length) {
        note(`the pack had no ${missing.join(', ')} — those tiles were filled with the stock map so the atlas stays complete.`);
    }

    /* ---- write it ---- */
    const id = opts.id ? slug(opts.id) : uniqueId(slug(opts.name || path.basename(input)));
    const label = opts.label || titleCase(id);
    const tileDir = path.join(TILES, id);
    const tplDir = path.join(TPL, id);
    fs.mkdirSync(tileDir, { recursive: true });
    fs.mkdirSync(tplDir, { recursive: true });

    say('');
    say(`Installing as "${label}"  (id: ${id})`);
    let written = 0;
    for (let r = 0; r < ROWS; r++) {
        for (let c = 0; c < COLS; c++) {
            const key = r + '_' + c;
            const img = decoded.get(key);
            if (!img) { continue; }
            const rgba = scaleTo(img, WORK, WORK);
            fs.writeFileSync(path.join(tileDir, `minimap_${r}_${c}.png`), encodePng(rgba, WORK, WORK));
            // the pack's own .ytd becomes the export template for this map,
            // so a full-quality export keeps its native size and format
            const ytd = ytdSources.get(key);
            if (ytd) { fs.writeFileSync(path.join(tplDir, `minimap_${r}_${c}.ytd`), ytd); }
            written++;
        }
    }

    // whatever the pack did not bring, borrow from the stock templates:
    // without these an export of this map would have no mould to pour into
    const stockTpl = path.join(TPL, 'original');
    let borrowed = 0;
    for (let r = 0; r < ROWS; r++) {
        for (let c = 0; c < COLS; c++) {
            if (copyIfMissing(path.join(stockTpl, `minimap_${r}_${c}.ytd`), path.join(tplDir, `minimap_${r}_${c}.ytd`))) { borrowed++; }
        }
    }
    copyIfMissing(path.join(stockTpl, 'minimap_lod_128.ytd'), path.join(tplDir, 'minimap_lod_128.ytd'));
    copyIfMissing(path.join(stockTpl, 'gfx'), path.join(tplDir, 'gfx'));
    copyIfMissing(path.join(stockTpl, 'ydd'), path.join(tplDir, 'ydd'));
    if (borrowed) { note(`${borrowed} export template(s) were borrowed from the stock map — exports still work, they just won't be sharper than 4096.`); }

    fs.writeFileSync(path.join(tplDir, 'map.json'), JSON.stringify({
        label,
        description: opts.desc || 'Imported map',
        imported: true,
        source: path.basename(input),
    }, null, 2));

    // upsert into the picker catalog, leaving every other entry alone
    const list = readMapsJson();
    const entry = {
        id, label,
        description: opts.desc || 'Imported map',
        tiles: written,
        format: srcFormat || 'PNG',
        native: srcNative || WORK,
        imported: true,
    };
    const at = list.findIndex(m => m.id === id);
    if (at >= 0) { list[at] = { ...list[at], ...entry }; } else { list.push(entry); }
    writeMapsJson(list);

    say(`  ${written} tiles  → html/tiles/${id}/`);
    say(`  templates      → templates/${id}/`);
    say(`  picker entry   → html/tiles/maps.json`);
    return { id, label, written };
}

/* ── list / remove ───────────────────────────────────────── */
function listMaps() {
    const list = readMapsJson();
    if (!list.length) { say('No maps installed (run tools/extract_tiles.js first).'); return; }
    say('Installed base maps:');
    for (const m of list) {
        const tag = m.imported ? '  [imported]' : (m.cayo ? '  [cayo]' : '');
        say(`  ${String(m.id).padEnd(22)} ${m.label}${tag}`);
    }
    say('\nRemove one you imported with:  node import_map.js --remove <id>');
}

function rmrf(p) {
    if (!fs.existsSync(p)) { return; }
    fs.rmSync(p, { recursive: true, force: true });
}

function removeMap(id) {
    if (STOCK.has(id)) { throw new Error(`"${id}" ships with the studio and cannot be removed.`); }
    if (!isImported(id)) { throw new Error(`"${id}" was not imported by this tool — refusing to delete it.`); }
    rmrf(path.join(TPL, id));
    rmrf(path.join(TILES, id));
    writeMapsJson(readMapsJson().filter(m => m.id !== id));
    say(`Removed "${id}".`);
}

/* ── CLI ─────────────────────────────────────────────────── */
function parseArgs(argv) {
    const o = { positional: [] };
    for (let i = 0; i < argv.length; i++) {
        const a = argv[i];
        if (a === '--list') { o.list = true; }
        else if (a === '--remove') { o.remove = argv[++i]; }
        else if (a === '--in') { o.in = argv[++i]; }
        else if (a === '--id') { o.id = argv[++i]; }
        else if (a === '--label') { o.label = argv[++i]; }
        else if (a === '--desc') { o.desc = argv[++i]; }
        else if (a === '--help' || a === '-h') { o.help = true; }
        else if (!a.startsWith('--')) { o.positional.push(a); }
    }
    return o;
}

const HELP = `
Apex Minimap Studio — import a minimap you already have

  node import_map.js                     import whatever is in tools/map_in/
  node import_map.js <folder|zip|png>    import that instead
  node import_map.js --list              show the installed base maps
  node import_map.js --remove <id>       delete a map you imported

  --label "Roxwood"    name shown in the studio's Maps rail
  --desc  "..."        one-line description under the name
  --id    roxwood      folder id (defaults to the file/folder name)

Windows: you can just drag a folder or a .zip onto import_map.bat.
`;

function main() {
    const opts = parseArgs(process.argv.slice(2));
    if (opts.help) { say(HELP); return; }
    if (opts.list) { listMaps(); return; }
    if (opts.remove) { removeMap(slug(opts.remove)); return; }

    let input = opts.in || opts.positional[0] || IN_DIR;
    input = path.resolve(input);

    if (!fs.existsSync(input)) {
        say(`[!] ${input} does not exist.`);
        say('    Put your minimap files in tools/map_in/ and run this again,');
        say('    or drag the folder / .zip straight onto import_map.bat.');
        process.exitCode = 1;
        return;
    }
    // an empty drop folder is the most likely first-run mistake
    if (input === IN_DIR && fs.statSync(input).isDirectory()) {
        const inside = fs.readdirSync(input).filter(f => !f.startsWith('.') && !/^readme/i.test(f));
        if (!inside.length) {
            say('tools/map_in/ is empty.');
            say('');
            say('  1. Put your minimap in there — the whole resource folder,');
            say('     the six minimap_<r>_<c>.ytd files, a .zip, or one big PNG');
            say('     of the map.');
            say('  2. Run this again.');
            say('');
            say('Or drag the folder / .zip straight onto import_map.bat (Windows)');
            say('or run:  bash import_map.sh /path/to/your/map   (Linux)');
            process.exitCode = 1;
            return;
        }
    }

    say('');
    say('=== Apex Minimap Studio — map import ===');
    say('');
    let res;
    try {
        res = importMap(input, {
            id: opts.id,
            label: opts.label,
            desc: opts.desc,
            name: path.basename(input) === 'map_in'
                ? (fs.readdirSync(input).find(f => !f.startsWith('.') && !/^readme/i.test(f)) || 'my-map')
                : path.basename(input),
        });
    } catch (e) {
        say('');
        say('[x] Import failed: ' + e.message);
        process.exitCode = 1;
        return;
    }

    if (notes.length) {
        say('');
        say('Notes:');
        for (const n of notes) { say('  - ' + n); }
    }
    say('');
    say('Done.');
    say('');
    say('  1. Restart the resource:   restart apex_minimap');
    say(`  2. Open the studio, go to Maps, and pick "${res.label}".`);
    say('');
}

main();
