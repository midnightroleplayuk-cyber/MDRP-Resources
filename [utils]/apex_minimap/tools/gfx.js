/* ============================================================
   Apex Minimap Studio — Scaleform .gfx bitmap surgery
   ------------------------------------------------------------
   Shared by extract_cayo.js (decode the Cayo island for painting)
   and make_ytd.js (re-embed the painted island back).

   The Cayo Perico map is a Scaleform GFX file (SWF-derived, magic
   "GFX"). It composites THREE 32-bit DefineBitsLossless2 bitmaps:
     • the sea ring   (larger, e.g. 1991×1995)
     • the island     (smaller, e.g. 1819×1773)
     • an island copy (sea variant)
   We decode them, composite the island centered over the sea into
   one paint base, and on export write the painted colours back
   into each bitmap WHILE KEEPING ITS ORIGINAL ALPHA — so the map
   silhouette is byte-safe and only the colours change (exactly how
   the .ytd pipeline stays valid by construction).

   Pure Node (zlib only). No dependencies.
   ============================================================ */
'use strict';
const zlib = require('zlib');

// ── header + tag walk ───────────────────────────────────────
function parse(buf) {
    if (buf.slice(0, 3).toString('latin1') !== 'GFX') {
        throw new Error('not an uncompressed GFX (magic != "GFX")');
    }
    // sig(3) + version(1) + fileLength(4) + RECT + frameRate(2) + frameCount(2)
    let p = 8;
    const nbits = buf[p] >> 3;
    p += Math.ceil((5 + nbits * 4) / 8);
    p += 4;
    const hdrEnd = p;
    const tags = [];
    while (p < buf.length) {
        const tagCodeAndLen = buf.readUInt16LE(p); p += 2;
        const code = tagCodeAndLen >> 6;
        let len = tagCodeAndLen & 0x3f;
        if (len === 0x3f) { len = buf.readUInt32LE(p); p += 4; }
        const dataStart = p;
        p = dataStart + len;
        tags.push({ code, len, dataStart });
        if (code === 0) { break; }
    }
    return { hdrEnd, tags };
}

// ── list the DefineBitsLossless2 (code 36) fmt-5 bitmaps ─────
function bitmaps(buf, parsed) {
    const out = [];
    parsed.tags.forEach((t, i) => {
        if (t.code !== 36) { return; }
        const q = t.dataStart;
        const fmt = buf[q + 2];
        if (fmt !== 5) { return; }         // only 32-bit ARGB handled
        out.push({
            tagIndex: i,
            id: buf.readUInt16LE(q),
            fmt,
            w: buf.readUInt16LE(q + 3),
            h: buf.readUInt16LE(q + 5),
            dataStart: q,
            len: t.len,
        });
    });
    return out;
}

// ARGB premultiplied → straight RGBA
function decode(buf, bm) {
    const raw = zlib.inflateSync(buf.slice(bm.dataStart + 7, bm.dataStart + bm.len));
    const n = bm.w * bm.h;
    const rgba = Buffer.alloc(n * 4);
    for (let i = 0; i < n; i++) {
        const A = raw[i * 4];
        let R = raw[i * 4 + 1], G = raw[i * 4 + 2], B = raw[i * 4 + 3];
        if (A > 0 && A < 255) {
            R = Math.min(255, Math.round(R * 255 / A));
            G = Math.min(255, Math.round(G * 255 / A));
            B = Math.min(255, Math.round(B * 255 / A));
        }
        rgba[i * 4] = R; rgba[i * 4 + 1] = G; rgba[i * 4 + 2] = B; rgba[i * 4 + 3] = A;
    }
    return rgba;
}

// straight RGBA → DefineBitsLossless2 tag data (id, fmt5, w, h, zlib ARGB premul)
function encodeTagData(id, w, h, rgba) {
    const n = w * h;
    const argb = Buffer.alloc(n * 4);
    for (let i = 0; i < n; i++) {
        const A = rgba[i * 4 + 3];
        const a = A / 255;
        argb[i * 4] = A;
        argb[i * 4 + 1] = Math.round(rgba[i * 4] * a);
        argb[i * 4 + 2] = Math.round(rgba[i * 4 + 1] * a);
        argb[i * 4 + 3] = Math.round(rgba[i * 4 + 2] * a);
    }
    const head = Buffer.alloc(7);
    head.writeUInt16LE(id, 0);
    head[2] = 5;
    head.writeUInt16LE(w, 3);
    head.writeUInt16LE(h, 5);
    return Buffer.concat([head, zlib.deflateSync(argb, { level: 8 })]);
}

// Rebuild the .gfx, swapping tag data by index. replacements: { [tagIndex]: Buffer }
function rebuild(buf, parsed, replacements) {
    function emit(code, data) {
        const long = data.length >= 0x3f;
        const head = Buffer.alloc(long ? 6 : 2);
        if (long) { head.writeUInt16LE((code << 6) | 0x3f, 0); head.writeUInt32LE(data.length, 2); }
        else { head.writeUInt16LE((code << 6) | data.length, 0); }
        return Buffer.concat([head, data]);
    }
    const parts = [buf.slice(0, parsed.hdrEnd)];
    parsed.tags.forEach((t, i) => {
        const data = replacements[i] || buf.slice(t.dataStart, t.dataStart + t.len);
        parts.push(emit(t.code, data));
    });
    const out = Buffer.concat(parts);
    out.writeUInt32LE(out.length, 4);   // fix the file-length field
    return out;
}

// Classify the fmt-5 bitmaps: the biggest is the sea ring, the rest
// (same size) are the island + its sea-variant. Returns
// { sea, islands: [...], offset } with the island offset centered
// inside the sea frame.
function classify(bms) {
    if (bms.length < 2) { return null; }
    const sorted = bms.slice().sort((a, b) => (b.w * b.h) - (a.w * a.h));
    const sea = sorted[0];
    const islands = sorted.slice(1);
    const isl = islands[0];
    const offset = { x: (sea.w - isl.w) >> 1, y: (sea.h - isl.h) >> 1 };
    return { sea, islands, offset };
}

module.exports = { parse, bitmaps, decode, encodeTagData, rebuild, classify };
