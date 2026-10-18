/* ============================================================
   Apex Minimap Studio — PNG → minimap resource generator
   ------------------------------------------------------------
   Turns the tiles the studio staged in tools/png_in/ into a
   COMPLETE, ready-to-ensure minimap resource in tools/out/,
   WITHOUT OpenIV / CodeWalker / any external tool or login.

   How it stays safe: it does NOT build a .ytd from scratch (the
   RSC7 struct layout is crash-prone). It takes the ORIGINAL
   tile .ytd in templates/ as a TEMPLATE and swaps ONLY the
   texture pixels — same format, same dimensions, same mip
   count, same byte length — then recompresses. Every struct,
   pointer and flag stays byte-identical to a file the game
   already loads, so the result is valid by construction.

   Pure Node (built-in zlib only). No dependencies.

   Usage:
     node make_ytd.js            (build from tools/png_in/)
     node make_ytd.js --stretch  (force the base map's own mould even when
                                  it is bigger than the staged design)
   Input (written by the in-game export):
     tools/png_in/minimap_<r>_<c>.png.b64   base64 of the tile PNG
     tools/png_in/minimap_<r>_<c>.png       …or a plain PNG you drop in
     tools/png_in/overlay_<r>_<c>.png.b64   native-res overlay (Full quality
                                            exports: base comes from the
                                            template itself, zero upscale)
     tools/png_in/export.json               { name, seaVariants, overlay, theme, … }
   Output:
     tools/out/<name>/  — complete resource (stream + lua files)
   ============================================================ */
'use strict';
const fs = require('fs');
const path = require('path');
const zlib = require('zlib');
const gfx = require('./gfx');

const ROOT = path.resolve(__dirname, '..');
const IN = path.join(__dirname, 'png_in');
const OUTROOT = path.join(__dirname, 'out');
const TPL = path.join(ROOT, 'templates');
const STRETCH = process.argv.includes('--stretch');

/* ── PNG decode (8-bit, colour type 2/6) ─────────────────── */
function decodePng(buf) {
    if (buf.readUInt32BE(0) !== 0x89504e47) { throw new Error('not a PNG'); }
    let off = 8, width = 0, height = 0, bitDepth = 0, colorType = 0;
    const idat = [];
    while (off < buf.length) {
        const len = buf.readUInt32BE(off);
        const type = buf.toString('ascii', off + 4, off + 8);
        const data = buf.slice(off + 8, off + 8 + len);
        if (type === 'IHDR') {
            width = data.readUInt32BE(0); height = data.readUInt32BE(4);
            bitDepth = data[8]; colorType = data[9];
        } else if (type === 'IDAT') { idat.push(data); }
        else if (type === 'IEND') { break; }
        off += 12 + len;
    }
    if (bitDepth !== 8 || (colorType !== 6 && colorType !== 2)) {
        throw new Error('PNG must be 8-bit RGB/RGBA (got depth ' + bitDepth + ' colour ' + colorType + ')');
    }
    const channels = colorType === 6 ? 4 : 3;
    const raw = zlib.inflateSync(Buffer.concat(idat));
    const stride = width * channels;
    const out = Buffer.alloc(width * height * 4);
    let prev = Buffer.alloc(stride);
    let p = 0;
    for (let y = 0; y < height; y++) {
        const filter = raw[p++];
        const line = Buffer.from(raw.slice(p, p + stride)); p += stride;
        for (let x = 0; x < stride; x++) {
            const a = x >= channels ? line[x - channels] : 0;
            const b = prev[x];
            const c = x >= channels ? prev[x - channels] : 0;
            let v = line[x];
            if (filter === 1) v += a;
            else if (filter === 2) v += b;
            else if (filter === 3) v += (a + b) >> 1;
            else if (filter === 4) {
                const pa = Math.abs(b - c), pb = Math.abs(a - c), pc = Math.abs(a + b - 2 * c);
                v += (pa <= pb && pa <= pc) ? a : (pb <= pc ? b : c);
            }
            line[x] = v & 0xff;
        }
        prev = line;
        for (let x = 0; x < width; x++) {
            const s = x * channels, d = (y * width + x) * 4;
            out[d] = line[s]; out[d + 1] = line[s + 1]; out[d + 2] = line[s + 2];
            out[d + 3] = channels === 4 ? line[s + 3] : 255;
        }
    }
    return { width, height, data: out };   // RGBA8
}

/* ── bilinear resize to target w×h ───────────────────────── */
function resize(img, tw, th) {
    if (img.width === tw && img.height === th) { return img.data; }
    const out = Buffer.alloc(tw * th * 4);
    const sx = img.width / tw, sy = img.height / th;
    for (let y = 0; y < th; y++) {
        const fy = (y + 0.5) * sy - 0.5, y0 = Math.max(0, Math.floor(fy));
        const y1 = Math.min(img.height - 1, y0 + 1), wy = fy - y0;
        for (let x = 0; x < tw; x++) {
            const fx = (x + 0.5) * sx - 0.5, x0 = Math.max(0, Math.floor(fx));
            const x1 = Math.min(img.width - 1, x0 + 1), wx = fx - x0;
            const d = (y * tw + x) * 4;
            for (let c = 0; c < 4; c++) {
                const p00 = img.data[(y0 * img.width + x0) * 4 + c];
                const p10 = img.data[(y0 * img.width + x1) * 4 + c];
                const p01 = img.data[(y1 * img.width + x0) * 4 + c];
                const p11 = img.data[(y1 * img.width + x1) * 4 + c];
                const top = p00 + (p10 - p00) * wx, bot = p01 + (p11 - p01) * wx;
                out[d + c] = Math.round(top + (bot - top) * wy);
            }
        }
    }
    return out;
}

/* ── half-size box downscale (for mips) ──────────────────── */
function halve(data, w, h) {
    const nw = Math.max(1, w >> 1), nh = Math.max(1, h >> 1);
    const out = Buffer.alloc(nw * nh * 4);
    for (let y = 0; y < nh; y++) {
        for (let x = 0; x < nw; x++) {
            const x0 = x * 2, y0 = y * 2, x1 = Math.min(w - 1, x0 + 1), y1 = Math.min(h - 1, y0 + 1);
            const d = (y * nw + x) * 4;
            for (let c = 0; c < 4; c++) {
                out[d + c] = (data[(y0 * w + x0) * 4 + c] + data[(y0 * w + x1) * 4 + c] +
                    data[(y1 * w + x0) * 4 + c] + data[(y1 * w + x1) * 4 + c] + 2) >> 2;
            }
        }
    }
    return { data: out, w: nw, h: nh };
}

/* ── BC1/BC3 block compression ───────────────────────────── */
function to565(r, g, b) { return ((r >> 3) << 11) | ((g >> 2) << 5) | (b >> 3); }

function encodeColorBlock(px) {
    let lo = [255, 255, 255], hi = [0, 0, 0];
    for (let i = 0; i < 16; i++) {
        for (let c = 0; c < 3; c++) { const v = px[i * 4 + c]; if (v < lo[c]) lo[c] = v; if (v > hi[c]) hi[c] = v; }
    }
    let c0 = to565(hi[0], hi[1], hi[2]), c1 = to565(lo[0], lo[1], lo[2]);
    if (c0 < c1) { const t = c0; c0 = c1; c1 = t; const tt = hi; hi = lo; lo = tt; }
    const pal = [hi, lo, [0, 0, 0], [0, 0, 0]];
    for (let c = 0; c < 3; c++) {
        pal[2][c] = Math.round((2 * hi[c] + lo[c]) / 3);
        pal[3][c] = Math.round((hi[c] + 2 * lo[c]) / 3);
    }
    let idx = 0;
    for (let i = 0; i < 16; i++) {
        let best = 0, bd = 1e9;
        for (let p = 0; p < 4; p++) {
            const dr = px[i * 4] - pal[p][0], dg = px[i * 4 + 1] - pal[p][1], db = px[i * 4 + 2] - pal[p][2];
            const d = dr * dr + dg * dg + db * db;
            if (d < bd) { bd = d; best = p; }
        }
        idx |= best << (i * 2);
    }
    const out = Buffer.alloc(8);
    out.writeUInt16LE(c0, 0); out.writeUInt16LE(c1, 2); out.writeUInt32LE(idx >>> 0, 4);
    return out;
}

function encodeAlphaBlock(px) {
    let a0 = 0, a1 = 255;
    for (let i = 0; i < 16; i++) { const a = px[i * 4 + 3]; if (a > a0) a0 = a; if (a < a1) a1 = a; }
    const out = Buffer.alloc(8); out[0] = a0; out[1] = a1;
    const al = [a0, a1];
    if (a0 > a1) { for (let j = 1; j <= 6; j++) al.push(Math.round(((7 - j) * a0 + j * a1) / 7)); }
    else { for (let j = 1; j <= 4; j++) al.push(Math.round(((5 - j) * a0 + j * a1) / 5)); al.push(0, 255); }
    let bits = 0n;
    for (let i = 0; i < 16; i++) {
        let best = 0, bd = 999;
        for (let p = 0; p < 8; p++) { const d = Math.abs(px[i * 4 + 3] - al[p]); if (d < bd) { bd = d; best = p; } }
        bits |= BigInt(best) << BigInt(i * 3);
    }
    for (let b = 0; b < 6; b++) { out[2 + b] = Number((bits >> BigInt(b * 8)) & 0xffn); }
    return out;
}

function compress(data, w, h, dxt5) {
    const bw = Math.ceil(w / 4), bh = Math.ceil(h / 4);
    const out = Buffer.alloc(bw * bh * (dxt5 ? 16 : 8));
    let o = 0;
    const px = new Uint8Array(64);
    for (let by = 0; by < bh; by++) {
        for (let bx = 0; bx < bw; bx++) {
            for (let py = 0; py < 4; py++) {
                for (let pxi = 0; pxi < 4; pxi++) {
                    const sx = Math.min(w - 1, bx * 4 + pxi), sy = Math.min(h - 1, by * 4 + py);
                    const s = (sy * w + sx) * 4, d = (py * 4 + pxi) * 4;
                    px[d] = data[s]; px[d + 1] = data[s + 1]; px[d + 2] = data[s + 2]; px[d + 3] = data[s + 3];
                }
            }
            if (dxt5) { encodeAlphaBlock(px).copy(out, o); o += 8; }
            encodeColorBlock(px).copy(out, o); o += 8;
        }
    }
    return out;
}

/* ── RSC7 helpers ────────────────────────────────────────── */
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

function mipTotal(w, h, levels, dxt5) {
    let n = 0, cw = w, ch = h;
    for (let i = 0; i < levels; i++) {
        n += Math.ceil(cw / 4) * Math.ceil(ch / 4) * (dxt5 ? 16 : 8);
        cw = Math.max(1, cw >> 1); ch = Math.max(1, ch >> 1);
    }
    return n;
}

/* What size is a mould? Reading it BEFORE the loop is what lets the
   build refuse to stretch — see the template-matching block in main(). */
function templateSize(templatePath) {
    try {
        const tpl = fs.readFileSync(templatePath);
        if (tpl.readUInt32LE(0) !== 0x37435352) { return null; }
        const desc = findDescriptor(zlib.inflateRawSync(tpl.slice(16)));
        return desc ? { w: desc.w, h: desc.h, fmt: FMT[desc.fmt] } : null;
    } catch (e) { return null; }
}

function readTemplate(templatePath) {
    const tpl = fs.readFileSync(templatePath);
    if (tpl.readUInt32LE(0) !== 0x37435352) { throw new Error(templatePath + ' is not an RSC7 .ytd'); }
    const sysFlags = tpl.readUInt32LE(8);
    const payload = zlib.inflateRawSync(tpl.slice(16));
    const sysSize = flagsToSize(sysFlags);
    const desc = findDescriptor(payload);
    if (!desc) { throw new Error('could not locate the texture descriptor in ' + templatePath); }
    return { tpl, payload, desc, gfxStart: sysSize + desc.dataOffset };
}

/* ── DXT1/3/5 decode (mip 0) — the reverse of compress() ─── */
function decodeDxt(data, w, h, fmtName) {
    const dxt5 = fmtName === 'DXT5', dxt3 = fmtName === 'DXT3';
    const bw = Math.ceil(w / 4), bh = Math.ceil(h / 4);
    const bs = (dxt5 || dxt3) ? 16 : 8;
    const out = Buffer.alloc(w * h * 4);
    let o = 0;
    for (let by = 0; by < bh; by++) {
        for (let bx = 0; bx < bw; bx++) {
            const block = data.slice(o, o + bs); o += bs;
            const cOff = (dxt5 || dxt3) ? 8 : 0;
            const c0 = block.readUInt16LE(cOff), c1 = block.readUInt16LE(cOff + 2);
            const idx = block.readUInt32LE(cOff + 4);
            const p0 = [((c0 >> 11) & 31) * 255 / 31, ((c0 >> 5) & 63) * 255 / 63, (c0 & 31) * 255 / 31];
            const p1 = [((c1 >> 11) & 31) * 255 / 31, ((c1 >> 5) & 63) * 255 / 63, (c1 & 31) * 255 / 31];
            // BC2/BC3 colour blocks are ALWAYS 4-colour mode; only bare DXT1
            // uses c0<=c1 to mean 3-colour + transparent.
            const four = dxt5 || dxt3 || c0 > c1;
            const p2 = four ? p0.map((v, i) => (2 * v + p1[i]) / 3) : p0.map((v, i) => (v + p1[i]) / 2);
            const p3 = four ? p0.map((v, i) => (v + 2 * p1[i]) / 3) : [0, 0, 0];
            const pal = [p0, p1, p2, p3];
            let alpha = null;
            if (dxt5) {
                const a0 = block[0], a1 = block[1];
                const al = [a0, a1];
                if (a0 > a1) { for (let j = 1; j <= 6; j++) al.push(Math.round(((7 - j) * a0 + j * a1) / 7)); }
                else { for (let j = 1; j <= 4; j++) al.push(Math.round(((5 - j) * a0 + j * a1) / 5)); al.push(0, 255); }
                let bits = 0n;
                for (let b = 0; b < 6; b++) { bits |= BigInt(block[2 + b]) << BigInt(b * 8); }
                alpha = [];
                for (let i = 0; i < 16; i++) { alpha.push(al[Number((bits >> BigInt(i * 3)) & 7n)]); }
            } else if (dxt3) {
                alpha = [];
                for (let i = 0; i < 16; i++) {
                    const nib = (block[i >> 1] >> ((i & 1) * 4)) & 0xF;
                    alpha.push(nib * 17);
                }
            }
            for (let py = 0; py < 4; py++) {
                for (let px = 0; px < 4; px++) {
                    const x = bx * 4 + px, y = by * 4 + py;
                    if (x >= w || y >= h) { continue; }
                    const i = py * 4 + px, pi = (idx >>> (i * 2)) & 3;
                    const d = (y * w + x) * 4;
                    out[d] = Math.round(pal[pi][0]);
                    out[d + 1] = Math.round(pal[pi][1]);
                    out[d + 2] = Math.round(pal[pi][2]);
                    out[d + 3] = alpha ? alpha[i] : ((!four && pi === 3) ? 0 : 255);
                }
            }
        }
    }
    return out;
}

/* The template's own texture as straight RGBA at native size — the
   sharpest possible base for the native-composite export path. */
function templatePixels(t) {
    const { desc, payload, gfxStart } = t;
    if (desc.fmt === 21) {
        const n = desc.w * desc.h;
        const out = Buffer.alloc(n * 4);
        for (let i = 0; i < n; i++) {
            const s = gfxStart + i * 4, d = i * 4;
            out[d] = payload[s + 2];        // R (stored BGRA)
            out[d + 1] = payload[s + 1];    // G
            out[d + 2] = payload[s];        // B
            out[d + 3] = payload[s + 3];    // A
        }
        return out;
    }
    const fmtName = FMT[desc.fmt];
    const size = Math.ceil(desc.w / 4) * Math.ceil(desc.h / 4) * (fmtName === 'DXT1' ? 8 : 16);
    return decodeDxt(payload.slice(gfxStart, gfxStart + size), desc.w, desc.h, fmtName);
}

/* Encode straight-RGBA pixels (already at the template's native w×h) into
   the template's EXACT format so the byte length is identical and the
   splice stays valid by construction. */
function writeYtdFromRGBA(t, rgba, outPath) {
    const { tpl, payload, desc, gfxStart } = t;
    let pixels;

    if (desc.fmt === 21) {
        // A8R8G8B8 — uncompressed, one mip, stored as B,G,R,A in memory.
        const N = desc.w * desc.h * 4;
        pixels = Buffer.alloc(N);
        for (let i = 0; i < desc.w * desc.h; i++) {
            const s = i * 4, d = i * 4;
            pixels[d] = rgba[s + 2];     // B
            pixels[d + 1] = rgba[s + 1]; // G
            pixels[d + 2] = rgba[s];     // R
            pixels[d + 3] = rgba[s + 3]; // A
        }
        if (pixels.length !== N) {
            throw new Error(`A8R8G8B8 encoded ${pixels.length} bytes but template expects ${N}`);
        }
    } else {
        // DXT1/3/5 — block compress every mip and concatenate.
        const dxt5 = desc.fmt === 894720068 || desc.fmt === 861165636;
        const N = mipTotal(desc.w, desc.h, desc.levels, dxt5);
        let data = rgba, cw = desc.w, ch = desc.h;
        const parts = [];
        for (let lvl = 0; lvl < desc.levels; lvl++) {
            parts.push(compress(data, cw, ch, dxt5));
            if (lvl < desc.levels - 1) { const hv = halve(data, cw, ch); data = hv.data; cw = hv.w; ch = hv.h; }
        }
        pixels = Buffer.concat(parts);
        if (pixels.length !== N) {
            throw new Error(`encoded ${pixels.length} bytes but template expects ${N} — aborting to stay safe`);
        }
    }

    pixels.copy(payload, gfxStart);
    const recompressed = zlib.deflateRawSync(payload, { level: 9 });
    fs.writeFileSync(outPath, Buffer.concat([tpl.slice(0, 16), recompressed]));
}

function makeYtd(png, templatePath, outPath) {
    const t = readTemplate(templatePath);
    // Resize the design to the template's exact tile dimensions.
    const resized = resize(png, t.desc.w, t.desc.h);   // RGBA8 at native size
    writeYtdFromRGBA(t, resized, outPath);
    // what the mould actually was, so main() can say when resize() had to
    // stretch the design to fill it
    return { w: t.desc.w, h: t.desc.h, fmt: FMT[t.desc.fmt] };
}

/* ── theme — replica pixel a pixel do styledBase da NUI ─────
   O editor aplica à base `hue-rotate() saturate() brightness() contrast()`
   e depois um tint 'source-atop'. As quatro funções de filtro CSS estão
   definidas por matrizes/afins em sRGB (spec Filter Effects), por isso o
   resultado reproduz-se aqui sobre o template NATIVO — com clamp entre
   passos, como o browser faz entre primitivas. */
function themeIsIdentity(th) {
    if (!th) { return true; }
    const hue = (((+th.hue || 0) % 360) + 360) % 360;
    const num = (v, dflt) => (v == null || !isFinite(+v)) ? dflt : +v;
    return hue === 0 && num(th.sat, 100) === 100 && num(th.bri, 100) === 100
        && num(th.con, 100) === 100 && !(num(th.tintAmt, 0) > 0);
}

function colorMatrixPass(data, n, m) {
    for (let i = 0; i < n; i++) {
        const d = i * 4, r = data[d], g = data[d + 1], b = data[d + 2];
        const nr = m[0] * r + m[1] * g + m[2] * b;
        const ng = m[3] * r + m[4] * g + m[5] * b;
        const nb = m[6] * r + m[7] * g + m[8] * b;
        data[d] = nr <= 0 ? 0 : nr >= 255 ? 255 : Math.round(nr);
        data[d + 1] = ng <= 0 ? 0 : ng >= 255 ? 255 : Math.round(ng);
        data[d + 2] = nb <= 0 ? 0 : nb >= 255 ? 255 : Math.round(nb);
    }
}

function parseHexColor(s) {
    const m = /^#?([0-9a-f]{6}|[0-9a-f]{3})$/i.exec(String(s || '').trim());
    if (!m) { return null; }
    let h = m[1];
    if (h.length === 3) { h = h[0] + h[0] + h[1] + h[1] + h[2] + h[2]; }
    return [parseInt(h.slice(0, 2), 16), parseInt(h.slice(2, 4), 16), parseInt(h.slice(4, 6), 16)];
}

function applyTheme(data, n, th) {
    if (themeIsIdentity(th)) { return; }
    const num = (v, dflt) => (v == null || !isFinite(+v)) ? dflt : +v;
    const hue = (((num(th.hue, 0)) % 360) + 360) % 360;
    if (hue !== 0) {
        const rad = hue * Math.PI / 180, cos = Math.cos(rad), sin = Math.sin(rad);
        colorMatrixPass(data, n, [
            0.213 + cos * 0.787 - sin * 0.213, 0.715 - cos * 0.715 - sin * 0.715, 0.072 - cos * 0.072 + sin * 0.928,
            0.213 - cos * 0.213 + sin * 0.143, 0.715 + cos * 0.285 + sin * 0.140, 0.072 - cos * 0.072 - sin * 0.283,
            0.213 - cos * 0.213 - sin * 0.787, 0.715 - cos * 0.715 + sin * 0.715, 0.072 + cos * 0.928 + sin * 0.072,
        ]);
    }
    const s = num(th.sat, 100) / 100;
    if (s !== 1) {
        colorMatrixPass(data, n, [
            0.213 + 0.787 * s, 0.715 - 0.715 * s, 0.072 - 0.072 * s,
            0.213 - 0.213 * s, 0.715 + 0.285 * s, 0.072 - 0.072 * s,
            0.213 - 0.213 * s, 0.715 - 0.715 * s, 0.072 + 0.928 * s,
        ]);
    }
    const bri = num(th.bri, 100) / 100, con = num(th.con, 100) / 100;
    if (bri !== 1 || con !== 1) {
        const lut = new Uint8Array(256);
        for (let v = 0; v < 256; v++) {
            let x = v * bri;
            x = x < 0 ? 0 : x > 255 ? 255 : x;              // clamp entre primitivas
            x = x * con + 127.5 * (1 - con);
            lut[v] = x <= 0 ? 0 : x >= 255 ? 255 : Math.round(x);
        }
        for (let i = 0; i < n; i++) {
            const d = i * 4;
            data[d] = lut[data[d]]; data[d + 1] = lut[data[d + 1]]; data[d + 2] = lut[data[d + 2]];
        }
    }
    const amt = num(th.tintAmt, 0) / 100;
    const tint = parseHexColor(th.tint);
    if (amt > 0 && tint) {
        // 'source-atop' com globalAlpha=amt: lerp da cor SÓ onde há mapa,
        // alpha intocado — exatamente o recomputeStyledBase() da NUI.
        const inv = 1 - amt;
        for (let i = 0; i < n; i++) {
            const d = i * 4;
            if (data[d + 3] === 0) { continue; }
            data[d] = Math.round(data[d] * inv + tint[0] * amt);
            data[d + 1] = Math.round(data[d + 1] * inv + tint[1] * amt);
            data[d + 2] = Math.round(data[d + 2] * inv + tint[2] * amt);
        }
    }
}

/* ── straight-alpha source-over: overlay sobre a base ────── */
function compositeOver(base, over, n) {
    for (let i = 0; i < n; i++) {
        const d = i * 4, sa = over[d + 3];
        if (sa === 0) { continue; }                       // base fica byte-intacta
        if (sa === 255) {
            base[d] = over[d]; base[d + 1] = over[d + 1];
            base[d + 2] = over[d + 2]; base[d + 3] = 255;
            continue;
        }
        const as = sa / 255, ab = base[d + 3] / 255;
        const ao = as + ab * (1 - as);
        if (ao <= 0) { base[d + 3] = 0; continue; }
        for (let c = 0; c < 3; c++) {
            base[d + c] = Math.round((over[d + c] * as + base[d + c] * ab * (1 - as)) / ao);
        }
        base[d + 3] = Math.round(ao * 255);
    }
}

/* Bilinear com PREMULTIPLICAÇÃO: interpolar RGBA "straight" arrasta o RGB
   preto dos pixels transparentes para as bordas (halo escuro). Só é usado
   se o overlay não vier já no tamanho do template. */
function resizeAlpha(img, tw, th) {
    if (img.width === tw && img.height === th) { return img.data; }
    const n = img.width * img.height;
    const pre = Buffer.alloc(n * 4);
    for (let i = 0; i < n; i++) {
        const d = i * 4, a = img.data[d + 3] / 255;
        pre[d] = Math.round(img.data[d] * a);
        pre[d + 1] = Math.round(img.data[d + 1] * a);
        pre[d + 2] = Math.round(img.data[d + 2] * a);
        pre[d + 3] = img.data[d + 3];
    }
    const out = resize({ width: img.width, height: img.height, data: pre }, tw, th);
    for (let i = 0; i < tw * th; i++) {
        const d = i * 4, a = out[d + 3];
        if (a > 0 && a < 255) {
            const k = 255 / a;
            out[d] = Math.min(255, Math.round(out[d] * k));
            out[d + 1] = Math.min(255, Math.round(out[d + 1] * k));
            out[d + 2] = Math.min(255, Math.round(out[d + 2] * k));
        }
    }
    return out;
}

/* ── in-game /gps postals script (bundled when the design has postals) ─ */
function writePostalsScript(resDir, postals) {
    const pts = (postals.points || []).filter(p => p && p.code != null && isFinite(+p.x) && isFinite(+p.y));
    if (!pts.length) { return false; }
    const rows = pts.map(p =>
        `  {c=${JSON.stringify(String(p.code))},x=${(+p.x).toFixed(1)},y=${(+p.y).toFixed(1)}}`).join(',\n');
    fs.writeFileSync(path.join(resDir, 'postals.lua'),
`--[[ Nearest-postal HUD + /gps command — generated by Apex Minimap Studio.
     Set "${postals.setName || 'postals'}" · ${pts.length} codes.
     Edit HUD position/scale below. ]]
local Postals = {
${rows}
}

local HUD = { x = 0.017, y = 0.925, scale = 0.5, font = 4 }  -- above the minimap
local nearest = nil

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local c = GetEntityCoords(ped)
        local best, bd = nil, 1e18
        for i = 1, #Postals do
            local p = Postals[i]
            local dx, dy = p.x - c.x, p.y - c.y
            local d = dx * dx + dy * dy
            if d < bd then bd = d; best = p end
        end
        nearest = best
        Wait(400)
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        if nearest and not IsPauseMenuActive() then
            SetTextFont(HUD.font)
            SetTextScale(HUD.scale, HUD.scale)
            SetTextColour(255, 255, 255, 215)
            SetTextOutline()
            SetTextEntry('STRING')
            AddTextComponentString('~w~Postal ~y~' .. nearest.c)
            DrawText(HUD.x, HUD.y)
        end
    end
end)

-- /gps <code> — sets a waypoint to that postal
RegisterCommand('gps', function(_, args)
    local code = args[1]
    if not code then
        if nearest then
            TriggerEvent('chat:addMessage', { args = { 'Postal', 'Nearest postal: ' .. nearest.c } })
        end
        return
    end
    for i = 1, #Postals do
        if Postals[i].c == tostring(code) then
            SetNewWaypoint(Postals[i].x, Postals[i].y)
            TriggerEvent('chat:addMessage', { args = { 'Postal', 'Waypoint set to postal ' .. code } })
            return
        end
    end
    TriggerEvent('chat:addMessage', { args = { 'Postal', 'Postal ' .. tostring(code) .. ' not found' } })
end, false)
`);
    return true;
}

/* ── Painted Cayo → re-embed into the style's .gfx ───────────
   The painted composite (island over sea) is written back into each
   DefineBitsLossless2 bitmap KEEPING its original alpha, so the island
   silhouette stays byte-safe and only the colours change. */
function cropResize(comp, cw, ch, rx, ry, rw, rh, tw, th) {
    // crop a sub-rect from comp (RGBA) then bilinear-resize to tw×th
    const sub = Buffer.alloc(Math.max(1, Math.round(rw)) * Math.max(1, Math.round(rh)) * 4);
    const sw = Math.max(1, Math.round(rw)), sh = Math.max(1, Math.round(rh));
    for (let y = 0; y < sh; y++) {
        for (let x = 0; x < sw; x++) {
            const sxp = Math.min(cw - 1, Math.max(0, Math.round(rx) + x));
            const syp = Math.min(ch - 1, Math.max(0, Math.round(ry) + y));
            const s = (syp * cw + sxp) * 4, d = (y * sw + x) * 4;
            sub[d] = comp[s]; sub[d + 1] = comp[s + 1]; sub[d + 2] = comp[s + 2]; sub[d + 3] = comp[s + 3];
        }
    }
    return resize({ width: sw, height: sh, data: sub }, tw, th);
}

function buildCayo(pngBuf, style, name) {
    const gfxPath = path.join(TPL, style, 'gfx', 'int3232302352.gfx');
    if (!fs.existsSync(gfxPath)) { throw new Error('no Cayo .gfx for style ' + style); }
    const buf = fs.readFileSync(gfxPath);
    const parsed = gfx.parse(buf);
    const bms = gfx.bitmaps(buf, parsed);
    const info = gfx.classify(bms);
    if (!info) { throw new Error('Cayo .gfx has no compatible bitmaps'); }

    const design = decodePng(pngBuf);          // painted composite (square, e.g. 2048)
    const cw = design.width, ch = design.height, comp = design.data;
    const W = info.sea.w, H = info.sea.h;      // composite frame = sea dims
    const sxr = cw / W, syr = ch / H;          // composite px per sea px

    const replacements = {};
    // helper: re-embed one bitmap sampling the composite region [rx,ry,rw,rh]
    // (in SEA-frame coords) with its ORIGINAL alpha preserved.
    function embed(bm, rx, ry) {
        const orig = gfx.decode(buf, bm);      // straight RGBA (for its alpha)
        const rgb = cropResize(comp, cw, ch, rx * sxr, ry * syr, bm.w * sxr, bm.h * syr, bm.w, bm.h);
        const out = Buffer.alloc(bm.w * bm.h * 4);
        for (let i = 0; i < bm.w * bm.h; i++) {
            out[i * 4] = rgb[i * 4]; out[i * 4 + 1] = rgb[i * 4 + 1]; out[i * 4 + 2] = rgb[i * 4 + 2];
            out[i * 4 + 3] = orig[i * 4 + 3];  // keep original alpha (silhouette)
        }
        replacements[bm.tagIndex] = gfx.encodeTagData(bm.id, bm.w, bm.h, out);
    }

    embed(info.sea, 0, 0);                       // sea ring covers the whole frame
    for (const isl of info.islands) { embed(isl, info.offset.x, info.offset.y); }

    return gfx.rebuild(buf, parsed, replacements);
}

/* ── in-game blips script (bundled when the design has blips) ─ */
function writeBlipsScript(resDir, blips) {
    const list = (blips || []).filter(b => b && isFinite(+b.x) && isFinite(+b.y));
    if (!list.length) { return false; }
    const rows = list.map(b =>
        `  {s=${(+b.sprite) | 0},c=${(+b.color) | 0},sc=${(+b.scale || 1).toFixed(2)},t=${JSON.stringify(String(b.label || ''))},x=${(+b.x).toFixed(1)},y=${(+b.y).toFixed(1)}}`).join(',\n');
    fs.writeFileSync(path.join(resDir, 'blips.lua'),
`--[[ Static map blips — generated by Apex Minimap Studio. ${list.length} blip(s). ]]
local Blips = {
${rows}
}

CreateThread(function()
    for i = 1, #Blips do
        local b = Blips[i]
        local blip = AddBlipForCoord(b.x + 0.0, b.y + 0.0, 0.0)
        SetBlipSprite(blip, b.s)
        SetBlipColour(blip, b.c)
        SetBlipScale(blip, b.sc + 0.0)
        SetBlipAsShortRange(blip, true)
        if b.t ~= '' then
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(b.t)
            EndTextCommandSetBlipName(blip)
        end
    end
end)
`);
    return true;
}

/* ── map extensions (add-on maps like Roxwood) ─
   GTA fences the player inside a fixed square. An add-on map placed
   outside it is visible but unreachable — you walk into an invisible
   wall. ExtendWorldBoundaryForPlayer pushes that fence out to include
   the given point, so one call per corner opens the whole area. It is
   a per-player setting that survives until ResetWorldBoundaryForPlayer,
   but a fresh spawn starts from the default fence, hence playerSpawned. */
function writeExtensionsScript(resDir, exts) {
    const list = (exts || []).filter(e =>
        e && isFinite(+e.x1) && isFinite(+e.y1) && isFinite(+e.x2) && isFinite(+e.y2));
    if (!list.length) { return false; }
    const rows = list.map(e =>
        `  {n=${JSON.stringify(String(e.name || 'Extension'))},` +
        `x1=${(+e.x1).toFixed(1)},y1=${(+e.y1).toFixed(1)},` +
        `x2=${(+e.x2).toFixed(1)},y2=${(+e.y2).toFixed(1)},` +
        `z=${(+e.z || 0).toFixed(1)},b=${e.bounds === false ? 'false' : 'true'}}`).join(',\n');

    fs.writeFileSync(path.join(resDir, 'extensions.lua'),
`--[[ Map extensions — generated by Apex Minimap Studio. ${list.length} area(s).

     Add-on maps (Roxwood, Liberty City, …) are built outside the square
     GTA lets a player leave. Without this the map is on the minimap but
     the player hits an invisible wall on the way there.

     ExtendWorldBoundaryForPlayer(x, y, z) grows that square to include
     the point, so we call it once per corner of each area. It is a
     per-player setting and a fresh spawn resets it, which is why it is
     re-applied on playerSpawned.
]]
local Areas = {
${rows}
}

local function applyBoundaries()
    for i = 1, #Areas do
        local a = Areas[i]
        if a.b then
            ExtendWorldBoundaryForPlayer(a.x1, a.y1, a.z)
            ExtendWorldBoundaryForPlayer(a.x2, a.y1, a.z)
            ExtendWorldBoundaryForPlayer(a.x1, a.y2, a.z)
            ExtendWorldBoundaryForPlayer(a.x2, a.y2, a.z)
        end
    end
end

AddEventHandler('onClientResourceStart', function(res)
    if res == GetCurrentResourceName() then applyBoundaries() end
end)

-- a fresh spawn starts from the default fence
AddEventHandler('playerSpawned', applyBoundaries)

-- Put the fence back where GTA had it when this resource stops, so a
-- restart never leaves a player with boundaries nobody asked for.
AddEventHandler('onClientResourceStop', function(res)
    if res == GetCurrentResourceName() then ResetWorldBoundaryForPlayer() end
end)

exports('ApplyMapExtensions', applyBoundaries)
`);
    return true;
}

/* ── resource scaffolding (mirrors the classic minimap pack) ─ */
function writeResourceFiles(resDir, name, hasPostals, enableCayo, hasBlips, hasExts) {
    fs.writeFileSync(path.join(resDir, 'fxmanifest.lua'),
`game 'gta5'
fx_version 'cerulean'
author 'Apex Scriptz - Minimap Studio'
description 'Custom minimap - ${name} (designed in-game with apex_minimap)'

client_scripts {
    'config.lua',
    'map.lua'${hasPostals ? ",\n    'postals.lua'" : ''}${hasBlips ? ",\n    'blips.lua'" : ''}${hasExts ? ",\n    'extensions.lua'" : ''}
}
`);
    fs.writeFileSync(path.join(resDir, 'config.lua'),
`Config = {}

-- Show the Cayo Perico blip and enable its minimap overlay
Config.EnableCayoMap = ${enableCayo ? 'true' : 'false'}

-- Interior map overrides
-- When inside a building, the minimap will switch to the matching interior view.
-- Add an entry per building: interiorId -> { name, x, y }
-- The interiorId is what GetInteriorFromPrimaryView() returns while inside.
Config.Interiors = {
    -- [120834] = { name = 'ex_cardealer_01',  x = 210.0,   y = -1002.0 },
}
`);
    fs.writeFileSync(path.join(resDir, 'map.lua'),
`-- Extends the map boundaries to allow for a larger cursor area.
CreateThread(function()
    if Config.EnableCayoMap then
        local blip = AddBlipForCoord(6500.0, -6500.0, 0.0)
        SetBlipAlpha(blip, 0)
        SetBlipAsShortRange(blip, true)
    end
end)

CreateThread(function()
    while true do
        local interior = GetInteriorFromPrimaryView()

        if interior == 0 then
            SetRadarZoom(1100)
            SetRadarAsExteriorThisFrame()
            if Config.EnableCayoMap then
                SetRadarAsInteriorThisFrame('h4_fake_islandx', vec(4700.0, -5145.0), 0, 0)
            end
        else
            local cfg = Config.Interiors[interior]
            if cfg then
                SetRadarAsInteriorThisFrame(cfg.name, vec(cfg.x, cfg.y), 0, 0)
            else
                SetRadarZoom(0)
            end
        end

        Citizen.Wait(0)
    end
end)
`);
    fs.writeFileSync(path.join(resDir, 'README.txt'),
`${name} - custom minimap
Designed in-game with Apex Minimap Studio (apex_minimap)

INSTALL
1. Drop the "${name}" folder into your server's resources/ directory.
2. Add this line to your server.cfg:
       ensure ${name}
3. Restart the server. Done.

NOTES
- The blank minimap_*.ydd files hide GTA's vector road overlay so your map
  shows cleanly on the pause map. Keep them next to the .ytd files.
- config.lua: toggle the Cayo Perico overlay and add interior map overrides.
- map.lua handles the radar zoom; tweak it freely.
`);
}

function copyDir(src, dst) {
    fs.mkdirSync(dst, { recursive: true });
    for (const e of fs.readdirSync(src, { withFileTypes: true })) {
        const s = path.join(src, e.name), d = path.join(dst, e.name);
        if (e.isDirectory()) { copyDir(s, d); }
        else { fs.copyFileSync(s, d); }
    }
}

/* ── main ────────────────────────────────────────────────── */
function main() {
    if (!fs.existsSync(IN)) { fs.mkdirSync(IN, { recursive: true }); }

    // manifest written by the in-game export (optional)
    let meta = { name: 'my_minimap', seaVariants: true, map: 'original' };
    const metaPath = path.join(IN, 'export.json');
    if (fs.existsSync(metaPath)) {
        try { meta = Object.assign(meta, JSON.parse(fs.readFileSync(metaPath, 'utf8'))); }
        catch (e) { console.log('! export.json unreadable, using defaults'); }
    }

    // The design was painted over a chosen BASE map — its .ytd/.ydd/.gfx
    // templates live in templates/<map>/. Fall back to templates/ root
    // (old single-map layout) if that folder is absent.
    let mapTpl = path.join(TPL, String(meta.map || 'original'));
    if (!fs.existsSync(mapTpl)) {
        // 'original' first: falling through to whatever readdir happens to
        // return would pick templates/_light (the small-export tile pack, and
        // first alphabetically), silently halving every export's resolution.
        const stock = path.join(TPL, 'original');
        const dirs = fs.existsSync(TPL)
            ? fs.readdirSync(TPL, { withFileTypes: true }).filter(e => e.isDirectory() && !e.name.startsWith('_'))
            : [];
        mapTpl = fs.existsSync(stock) ? stock : (dirs.length ? path.join(TPL, dirs[0].name) : TPL);
        console.log(`! base map "${meta.map}" has no templates/ folder — using ${path.basename(mapTpl)} as the mould`);
    }
    console.log(`Base map: ${path.basename(mapTpl)}`);

    // collect staged tiles: .png.b64 (from the studio) or plain .png
    const tiles = [];
    for (const f of fs.readdirSync(IN)) {
        let m = f.match(/^minimap_(\d+)_(\d+)\.png\.b64$/i);
        if (m) {
            tiles.push({ r: +m[1], c: +m[2], buf: Buffer.from(fs.readFileSync(path.join(IN, f), 'ascii'), 'base64') });
            continue;
        }
        m = f.match(/^minimap_(\d+)_(\d+)\.png$/i);
        if (m) {
            tiles.push({ r: +m[1], c: +m[2], buf: fs.readFileSync(path.join(IN, f)) });
        }
    }
    if (!tiles.length) {
        console.log('Nothing staged. Run the in-game export first (or drop minimap_<r>_<c>.png files in tools/png_in/).');
        return;
    }

    /* ── COMPOSIÇÃO NATIVA (qualidade máxima) ───────────────
       O export em jogo da qualidade "Full" também deixa overlay_<r>_<c>
       (a pilha por cima da base — pinturas, objetos, postais — sobre
       transparente, renderizada à resolução NATIVA) e o tema no
       export.json. Nesse caso a base NÃO vem do PNG composto a 2048:
       vem DIRETAMENTE do template .ytd em 4096, com o tema aplicado
       pixel a pixel e o overlay composto por cima. Zero upscale — onde
       o overlay é transparente e o tema é neutro, os bytes da base são
       os do próprio mapa original. `overlay` só vem true quando TODOS
       os overlays ficaram staged, por isso ou o pacote inteiro sai
       nativo ou nenhum tile sai (nunca misturado). */
    const overlays = new Map();
    if (meta.overlay === true && meta.quality !== 'light' && !meta.cayoPaint) {
        for (const f of fs.readdirSync(IN)) {
            let m = f.match(/^overlay_(\d+)_(\d+)\.png\.b64$/i);
            if (m) {
                overlays.set(`${+m[1]}_${+m[2]}`,
                    Buffer.from(fs.readFileSync(path.join(IN, f), 'ascii'), 'base64'));
                continue;
            }
            m = f.match(/^overlay_(\d+)_(\d+)\.png$/i);
            if (m) { overlays.set(`${+m[1]}_${+m[2]}`, fs.readFileSync(path.join(IN, f))); }
        }
    }
    const nativeMode = overlays.size > 0 && tiles.every(t => overlays.has(`${t.r}_${t.c}`));

    const name = String(meta.name).replace(/[^\w-]/g, '_').slice(0, 40) || 'my_minimap';

    // ── Painted Cayo Perico export ──────────────────────────
    if (meta.cayoPaint) {
        const style = String(meta.cayoStyle || 'satellite').replace(/[^\w-]/g, '_');
        const tile = tiles.find(t => t.r === 0 && t.c === 0) || tiles[0];
        const resDir = path.join(OUTROOT, name);
        const gfxDir = path.join(resDir, 'stream', 'apex_minimap', name, 'gfx');
        fs.mkdirSync(gfxDir, { recursive: true });
        console.log(`Building painted Cayo "${name}" (${style} style)\n`);
        try {
            const out = buildCayo(tile.buf, style, name);
            fs.writeFileSync(path.join(gfxDir, 'int3232302352.gfx'), out);
            writeResourceFiles(resDir, name, false, true);
            console.log(`✓ Cayo island re-coloured → int3232302352.gfx (${out.length} bytes)`);
            console.log(`\nDone. Resource ready: tools/out/${name}/`);
            console.log(`Install: copy it to resources/ and add "ensure ${name}" to server.cfg.`);
        } catch (e) {
            console.log(`✗ Cayo build failed: ${e.message}`);
        }
        return;
    }

    const resDir = path.join(OUTROOT, name);
    const streamDir = path.join(resDir, 'stream', 'apex_minimap', name);
    const ytdDir = path.join(streamDir, 'ytd');
    fs.mkdirSync(ytdDir, { recursive: true });

    /* Export quality.
       The tile template dictates the OUTPUT size and format: makeYtd()
       resizes the design into the template and encodes in the template's
       exact format, so the byte length always matches by construction.
       · full  → the base map's own template (4096, uncompressed) — sharp,
                 and 10-34 MB per tile.
       · light → templates/_light/ (the stock 2048 DXT5 pack) — the same
                 design in ~0.8 MB per tile. Same proven code path, just a
                 different template, so nothing about the .ytd is guesswork. */
    const lightTpl = path.join(TPL, '_light');
    const hasLight = fs.existsSync(lightTpl);
    let useLight = meta.quality === 'light' && hasLight;
    if (meta.quality === 'light' && !useLight) {
        console.log('! quality "light" asked for but templates/_light/ is missing — building at full size');
    }

    /* MOULD MATCHING. The studio composes at the editor's working
       resolution; a base map's own mould is bigger than that. Pouring one
       into the other is an upscale — the .ytd comes out at the mould's size
       carrying only the design's detail, costs 16x the VRAM for it, and the
       texture then misses its streaming budget in game: the map goes soft
       and only shows once the player zooms out far enough to fall back to
       the LOD. So when a mould the size of the design exists, THAT is the
       right mould. Same proven splice, nothing invented — just the one that
       does not stretch. --stretch forces the old behaviour. */
    if (!useLight && hasLight && !STRETCH && !nativeMode) {
        const first = `minimap_${tiles[0].r}_${tiles[0].c}`;
        const designW = tiles[0].buf.readUInt32BE(16);     // PNG IHDR width
        const own = templateSize(path.join(mapTpl, first + '.ytd'));
        const light = templateSize(path.join(lightTpl, first + '.ytd'));
        if (own && light && own.w > designW && light.w < own.w && light.w >= designW) {
            useLight = true;
            console.log(`! design staged at ${designW}px, ${path.basename(mapTpl)}/ mould is ${own.w}px — `
                + `stretching it would be a ${(own.w / designW).toFixed(1)}x upscale with no new detail.`);
            console.log(`  Building against templates/_light/ (${light.w}px ${light.fmt}) instead, which fits the `
                + `design exactly. Pass --stretch to force the ${own.w}px mould.`);
        }
    }

    const tileTplDir = useLight ? lightTpl : mapTpl;
    if (useLight) { console.log('Quality: LIGHT — 2048 DXT5 tiles (much smaller resource)\n'); }
    if (nativeMode) {
        console.log('Quality: NATIVE COMPOSITE — base direto do template do mapa '
            + '(zero upscale) + overlay do estúdio à resolução nativa. É a nitidez '
            + 'máxima possível; cada tile demora um pouco a comprimir.\n');
    }

    console.log(`Building "${name}" — ${tiles.length} tile(s)\n`);
    let ok = 0, upscaled = 0;
    for (const t of tiles.sort((a, b) => (a.r - b.r) || (a.c - b.c))) {
        const base = `minimap_${t.r}_${t.c}`;
        let tplPath = path.join(tileTplDir, base + '.ytd');
        // se o pack leve não tiver este tile, cai para o template do mapa
        if (!fs.existsSync(tplPath)) { tplPath = path.join(mapTpl, base + '.ytd'); }
        if (!fs.existsSync(tplPath)) { console.log(`✗ ${base}: no template ${base}.ytd in ${path.basename(tileTplDir)}/ — skipping`); continue; }
        let built = false;
        if (nativeMode) {
            try {
                const tt = readTemplate(tplPath);
                const n = tt.desc.w * tt.desc.h;
                const basePx = templatePixels(tt);
                applyTheme(basePx, n, meta.theme);
                const ov = decodePng(overlays.get(`${t.r}_${t.c}`));
                const ovPx = (ov.width === tt.desc.w && ov.height === tt.desc.h)
                    ? ov.data : resizeAlpha(ov, tt.desc.w, tt.desc.h);
                compositeOver(basePx, ovPx, n);
                writeYtdFromRGBA(tt, basePx, path.join(ytdDir, base + '.ytd'));
                console.log(`• ${base}  (base nativa ${tt.desc.w}×${tt.desc.h} ${FMT[tt.desc.fmt]}`
                    + ` + overlay ${ov.width}px)`);
                built = true;
            } catch (e) {
                console.log(`! ${base}: composição nativa falhou (${e.message}) — a usar o design composto`);
            }
        }
        try {
            if (!built) {
                const png = decodePng(t.buf);
                console.log(`• ${base}  (${png.width}×${png.height} → template)`);
                const mould = makeYtd(png, tplPath, path.join(ytdDir, base + '.ytd'));
                /* O estúdio compõe à resolução de trabalho do editor. Se o molde
                   for maior, resize() ESTICA o design: o .ytd sai com o tamanho
                   do molde mas só com o detalhe que o PNG trazia. Era silencioso
                   — e é exatamente o "o mapa está desfocado" que chega em ticket. */
                if (mould && mould.w > png.width) {
                    upscaled++;
                    console.log(`  ! esticado ${(mould.w / png.width).toFixed(1)}x para o molde `
                        + `${mould.w}×${mould.h} ${mould.fmt} — o tile fica com ${mould.w}px `
                        + `mas só ${png.width}px de detalhe real`);
                }
            }
            if (meta.seaVariants !== false) {
                fs.copyFileSync(path.join(ytdDir, base + '.ytd'), path.join(ytdDir, `minimap_sea_${t.r}_${t.c}.ytd`));
            }
            ok++;
        } catch (e) {
            console.log(`✗ ${base}: ${e.message}`);
        }
    }

    if (upscaled) {
        console.log(`\n! ${upscaled}/${tiles.length} tile(s) esticados. O molde ${path.basename(tileTplDir)}/ `
            + `é maior do que o design que o estúdio compôs, por isso o mapa fica suave/desfocado e `
            + `pesa muito mais do que o detalhe que carrega.`);
        console.log(`  Exporta em qualidade "Light" (molde 2048 igual ao design) ou faz o export `
            + `a partir de um mapa base cujos tiles tenham o tamanho do design.`);
    }

    // road-hiding blank .ydd files (optional) + Cayo .gfx (optional)
    const enableCayo = meta.cayo !== false;
    const hideRoads = meta.hideRoads !== false;
    /* Os .ydd em branco tapam a camada de estradas VETORIAIS da GTA, que é
       desenhada por cima do raster e só se impõe a partir de certo zoom.
       Sem eles o mapa parece "voltar ao original" quando o jogador aproxima
       — e este passo calava-se quando não tinha nada para copiar. */
    const yddSrc = path.join(mapTpl, 'ydd');
    if (hideRoads && fs.existsSync(yddSrc)) {
        copyDir(yddSrc, path.join(streamDir, 'ydd'));
        console.log('+ road-hiders (.ydd) — a camada vetorial vanilla fica tapada');
    } else if (hideRoads) {
        console.log(`! ${path.basename(mapTpl)}/ydd/ não existe — o pack vai SEM road-hiders, `
            + `por isso as estradas vetoriais da GTA desenham por cima do teu mapa quando se dá zoom.`);
    } else {
        console.log('! "Hide the vanilla vector road overlay" ficou desligado no export — as estradas '
            + 'vetoriais da GTA desenham por cima do teu mapa quando se dá zoom.');
    }
    if (enableCayo) {
        // Cayo island .gfx: a chosen style overrides the base map's, else
        // the base map's own styled Cayo is used.
        let cayoTpl = mapTpl;
        if (meta.cayoStyle) {
            const styled = path.join(TPL, String(meta.cayoStyle));
            if (fs.existsSync(path.join(styled, 'gfx'))) { cayoTpl = styled; }
        }
        if (fs.existsSync(path.join(cayoTpl, 'gfx'))) {
            copyDir(path.join(cayoTpl, 'gfx'), path.join(streamDir, 'gfx'));
            console.log(`+ Cayo Perico island (${path.basename(cayoTpl)} style)`);
        }
    }
    const lodSrc = fs.existsSync(path.join(tileTplDir, 'minimap_lod_128.ytd'))
        ? path.join(tileTplDir, 'minimap_lod_128.ytd')
        : path.join(mapTpl, 'minimap_lod_128.ytd');
    if (fs.existsSync(lodSrc)) {
        fs.copyFileSync(lodSrc, path.join(ytdDir, 'minimap_lod_128.ytd'));
    }
    let hasPostals = false;
    if (meta.postals && Array.isArray(meta.postals.points) && meta.postals.points.length) {
        hasPostals = writePostalsScript(resDir, meta.postals);
        if (hasPostals) { console.log(`+ postals.lua (/gps, ${meta.postals.points.length} codes)`); }
    }
    let hasBlips = false;
    if (Array.isArray(meta.blips) && meta.blips.length) {
        hasBlips = writeBlipsScript(resDir, meta.blips);
        if (hasBlips) { console.log(`+ blips.lua (${meta.blips.length} blip(s))`); }
    }
    let hasExts = false;
    if (Array.isArray(meta.extensions) && meta.extensions.length) {
        hasExts = writeExtensionsScript(resDir, meta.extensions);
        if (hasExts) { console.log(`+ extensions.lua (${meta.extensions.length} map extension(s))`); }
    }
    writeResourceFiles(resDir, name, hasPostals, enableCayo, hasBlips, hasExts);

    console.log(`\nDone — ${ok}/${tiles.length} tile(s) converted.`);
    console.log(`Resource ready: tools/out/${name}/`);
    console.log(`Install: copy it to resources/ and add "ensure ${name}" to server.cfg.`);
}
main();
