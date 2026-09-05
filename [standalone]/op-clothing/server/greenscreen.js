const fs = require('fs');
const zlib = require('zlib');

function outputCfg() {
    const maxSize = parseInt((typeof GetConvar === 'function' && GetConvar('opc_thumbs_maxsize', '256')) || '256', 10);
    const pngLevel = parseInt((typeof GetConvar === 'function' && GetConvar('opc_thumbs_png_level', '9')) || '9', 10);
    return {
        maxSize: Number.isFinite(maxSize) && maxSize > 0 ? maxSize : 384,
        pngLevel: Math.min(9, Math.max(0, pngLevel || 9)),
    };
}

function outputExt() {
    return 'png';
}

const CRC_TABLE = (() => {
    const t = new Array(256);
    for (let n = 0; n < 256; n++) {
        let c = n;
        for (let k = 0; k < 8; k++) c = (c & 1) ? (0xEDB88320 ^ (c >>> 1)) : (c >>> 1);
        t[n] = c >>> 0;
    }
    return t;
})();

function crc32(buf) {
    let c = 0xFFFFFFFF;
    for (let i = 0; i < buf.length; i++) c = CRC_TABLE[(c ^ buf[i]) & 0xFF] ^ (c >>> 8);
    return (c ^ 0xFFFFFFFF) >>> 0;
}

function paeth(a, b, c) {
    const p = a + b - c;
    const pa = Math.abs(p - a), pb = Math.abs(p - b), pc = Math.abs(p - c);
    if (pa <= pb && pa <= pc) return a;
    if (pb <= pc) return b;
    return c;
}

function decodePNG(buffer) {
    if (buffer.length < 8) throw new Error('not a png');
    let pos = 8;
    let width = 0, height = 0, bitDepth = 8, colorType = 6;
    const idat = [];
    while (pos + 8 <= buffer.length) {
        const len = buffer.readUInt32BE(pos); pos += 4;
        const type = buffer.toString('ascii', pos, pos + 4); pos += 4;
        const data = buffer.slice(pos, pos + len); pos += len + 4; // skip crc
        if (type === 'IHDR') {
            width = data.readUInt32BE(0);
            height = data.readUInt32BE(4);
            bitDepth = data[8];
            colorType = data[9];
        } else if (type === 'IDAT') {
            idat.push(data);
        } else if (type === 'IEND') {
            break;
        }
    }
    if (bitDepth !== 8) throw new Error('unsupported bit depth ' + bitDepth);

    const channels = colorType === 6 ? 4 : colorType === 2 ? 3 : colorType === 4 ? 2 : colorType === 0 ? 1 : 4;
    const raw = zlib.inflateSync(Buffer.concat(idat));
    const stride = width * channels;
    const out = Buffer.alloc(height * stride);
    let rp = 0;
    for (let y = 0; y < height; y++) {
        const filter = raw[rp++];
        const row = y * stride;
        const prev = (y - 1) * stride;
        for (let x = 0; x < stride; x++) {
            const rawByte = raw[rp++];
            const a = x >= channels ? out[row + x - channels] : 0;
            const b = y > 0 ? out[prev + x] : 0;
            const c = (x >= channels && y > 0) ? out[prev + x - channels] : 0;
            let val;
            switch (filter) {
                case 1: val = rawByte + a; break;
                case 2: val = rawByte + b; break;
                case 3: val = rawByte + ((a + b) >> 1); break;
                case 4: val = rawByte + paeth(a, b, c); break;
                default: val = rawByte; // 0 = none
            }
            out[row + x] = val & 0xFF;
        }
    }
    return { width, height, channels, data: out };
}

function filterRowNone(row) {
    const out = Buffer.alloc(row.length + 1);
    out[0] = 0;
    row.copy(out, 1);
    return out;
}

function filterRowSub(row, bpp) {
    const out = Buffer.alloc(row.length + 1);
    out[0] = 1;
    for (let i = 0; i < row.length; i++) {
        const left = i >= bpp ? row[i - bpp] : 0;
        out[i + 1] = (row[i] - left) & 0xFF;
    }
    return out;
}

function filterRowUp(row, prevRow) {
    const out = Buffer.alloc(row.length + 1);
    out[0] = 2;
    for (let i = 0; i < row.length; i++) {
        const up = prevRow ? prevRow[i] : 0;
        out[i + 1] = (row[i] - up) & 0xFF;
    }
    return out;
}

function filterRowAvg(row, prevRow, bpp) {
    const out = Buffer.alloc(row.length + 1);
    out[0] = 3;
    for (let i = 0; i < row.length; i++) {
        const left = i >= bpp ? row[i - bpp] : 0;
        const up = prevRow ? prevRow[i] : 0;
        out[i + 1] = (row[i] - ((left + up) >> 1)) & 0xFF;
    }
    return out;
}

function filterRowPaeth(row, prevRow, bpp) {
    const out = Buffer.alloc(row.length + 1);
    out[0] = 4;
    for (let i = 0; i < row.length; i++) {
        const left = i >= bpp ? row[i - bpp] : 0;
        const up = prevRow ? prevRow[i] : 0;
        const upLeft = (prevRow && i >= bpp) ? prevRow[i - bpp] : 0;
        out[i + 1] = (row[i] - paeth(left, up, upLeft)) & 0xFF;
    }
    return out;
}

function pickBestFilterRow(row, prevRow, bpp) {
    const rowCopy = Buffer.from(row);
    const candidates = [
        filterRowNone(rowCopy),
        filterRowSub(rowCopy, bpp),
        filterRowUp(rowCopy, prevRow),
        filterRowAvg(rowCopy, prevRow, bpp),
        filterRowPaeth(rowCopy, prevRow, bpp),
    ];
    let best = candidates[0];
    let bestSize = Infinity;
    for (const c of candidates) {
        const sz = zlib.deflateSync(c, { level: 1 }).length;
        if (sz < bestSize) {
            bestSize = sz;
            best = c;
        }
    }
    return best;
}

function encodePNG(width, height, rgba, level) {
    const stride = width * 4;
    const bpp = 4;
    const rows = [];
    let prevRow = null;
    for (let y = 0; y < height; y++) {
        const row = rgba.subarray(y * stride, y * stride + stride);
        rows.push(pickBestFilterRow(row, prevRow, bpp));
        prevRow = row;
    }
    const raw = Buffer.concat(rows);
    const compressed = zlib.deflateSync(raw, { level: level ?? 9 });
    const chunk = (type, data) => {
        const len = Buffer.alloc(4); len.writeUInt32BE(data.length, 0);
        const typeBuf = Buffer.from(type, 'ascii');
        const crcBuf = Buffer.alloc(4);
        crcBuf.writeUInt32BE(crc32(Buffer.concat([typeBuf, data])), 0);
        return Buffer.concat([len, typeBuf, data, crcBuf]);
    };
    const ihdr = Buffer.alloc(13);
    ihdr.writeUInt32BE(width, 0);
    ihdr.writeUInt32BE(height, 4);
    ihdr[8] = 8;
    ihdr[9] = 6;
    return Buffer.concat([
        Buffer.from([137, 80, 78, 71, 13, 10, 26, 10]),
        chunk('IHDR', ihdr),
        chunk('IDAT', compressed),
        chunk('IEND', Buffer.alloc(0)),
    ]);
}

function resizeRGBA(rgba, width, height, maxSize) {
    if (!maxSize || maxSize <= 0 || (width <= maxSize && height <= maxSize)) {
        return { rgba, width, height };
    }
    const scale = maxSize / Math.max(width, height);
    const nw = Math.max(1, Math.round(width * scale));
    const nh = Math.max(1, Math.round(height * scale));
    const out = Buffer.alloc(nw * nh * 4);
    for (let y = 0; y < nh; y++) {
        const sy = (y + 0.5) / scale - 0.5;
        const y0 = Math.max(0, Math.floor(sy));
        const y1 = Math.min(height - 1, y0 + 1);
        const fy = sy - y0;
        for (let x = 0; x < nw; x++) {
            const sx = (x + 0.5) / scale - 0.5;
            const x0 = Math.max(0, Math.floor(sx));
            const x1 = Math.min(width - 1, x0 + 1);
            const fx = sx - x0;
            const i = (y * nw + x) * 4;
            for (let c = 0; c < 4; c++) {
                const v00 = rgba[((y0 * width) + x0) * 4 + c];
                const v10 = rgba[((y0 * width) + x1) * 4 + c];
                const v01 = rgba[((y1 * width) + x0) * 4 + c];
                const v11 = rgba[((y1 * width) + x1) * 4 + c];
                const top = v00 + (v10 - v00) * fx;
                const bot = v01 + (v11 - v01) * fx;
                out[i + c] = Math.round(top + (bot - top) * fy);
            }
        }
    }
    return { rgba: out, width: nw, height: nh };
}

const COLOR_BUCKETS = [
    'black', 'white', 'gray', 'brown', 'beige',
    'red', 'blue', 'green', 'yellow', 'purple',
];

function rgbToHsl(r, g, b) {
    r /= 255; g /= 255; b /= 255;
    const max = Math.max(r, g, b);
    const min = Math.min(r, g, b);
    const l = (max + min) / 2;
    let h = 0;
    let s = 0;
    if (max !== min) {
        const d = max - min;
        s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
        switch (max) {
            case r: h = ((g - b) / d + (g < b ? 6 : 0)) / 6; break;
            case g: h = ((b - r) / d + 2) / 6; break;
            default: h = ((r - g) / d + 4) / 6;
        }
    }
    return { h: h * 360, s, l };
}

function classifyRgb(r, g, b) {
    const { h, s, l } = rgbToHsl(r, g, b);
    if (l < 0.12 && s < 0.35) return 'black';
    if (l > 0.88 && s < 0.12) return 'white';
    if (s < 0.12) return 'gray';
    if (h >= 15 && h < 45) return l < 0.45 ? 'brown' : 'beige';
    if (h >= 45 && h < 70) return 'yellow';
    if (h >= 70 && h < 165) return 'green';
    if (h >= 165 && h < 255) return 'blue';
    if (h >= 255 && h < 330) return 'purple';
    if (h >= 330 && h < 345) return 'red';
    return 'red';
}

function dominantColorBucket(rgba, width, height) {
    let rSum = 0;
    let gSum = 0;
    let bSum = 0;
    let n = 0;
    for (let i = 0; i < width * height; i++) {
        const o = i * 4;
        const a = rgba[o + 3];
        if (a < 32) continue;
        const r = rgba[o];
        const g = rgba[o + 1];
        const b = rgba[o + 2];
        if (g > r + 28 && g > b + 28) continue;
        rSum += r;
        gSum += g;
        bSum += b;
        n++;
    }
    if (n < 8) return 'gray';
    const bucket = classifyRgb(
        Math.round(rSum / n),
        Math.round(gSum / n),
        Math.round(bSum / n),
    );
    return COLOR_BUCKETS.includes(bucket) ? bucket : 'gray';
}

function saveColorEntry(key, bucket) {
    const dir = thumbsDir();
    if (!dir || !key || !bucket) return;
    const file = `${dir}/colors.json`;
    let data = {};
    try { data = JSON.parse(fs.readFileSync(file, 'utf8')); } catch (e) { data = {}; }
    if (typeof data !== 'object' || !data) data = {};
    data[key] = bucket;
    fs.mkdirSync(dir, { recursive: true });
    fs.writeFileSync(file, JSON.stringify(data));
}

function cleanRgbaForEncode(rgba) {
    for (let i = 0; i < rgba.length; i += 4) {
        let r = rgba[i];
        let g = rgba[i + 1];
        let b = rgba[i + 2];
        let a = rgba[i + 3];

        if (a <= 32) {
            rgba[i] = 0;
            rgba[i + 1] = 0;
            rgba[i + 2] = 0;
            rgba[i + 3] = 0;
            continue;
        }

        const maxRB = Math.max(r, b);
        if (g > maxRB + 4) {
            g = maxRB;
        }
        if (g > maxRB + 12 || (g > 90 && g > r + 18 && g > b + 18)) {
            rgba[i] = 0;
            rgba[i + 1] = 0;
            rgba[i + 2] = 0;
            rgba[i + 3] = 0;
            continue;
        }
        if (isEngineMagenta(r, g, b)) {
            rgba[i] = 0;
            rgba[i + 1] = 0;
            rgba[i + 2] = 0;
            rgba[i + 3] = 0;
            continue;
        }

        rgba[i] = r;
        rgba[i + 1] = g;
        rgba[i + 2] = b;
        rgba[i + 3] = 255;
    }
}

// ── Greenscreen key + spill removal ─────────────────────────────────────────
// Key colour matches Config.Thumbnails.Background (0, 255, 0). Edge pixels often
// have g only slightly above max(r,b) — the old `g > r + b` test missed them.
function chromaCfg() {
    const hard = parseInt((typeof GetConvar === 'function' && GetConvar('opc_thumbs_key_hard', '64')) || '64', 10);
    const soft = parseInt((typeof GetConvar === 'function' && GetConvar('opc_thumbs_key_soft', '36')) || '36', 10);
    return {
        hard: Number.isFinite(hard) ? hard : 64,
        soft: Number.isFinite(soft) ? soft : 36,
    };
}

function excessGreen(r, g, b) {
    return g - Math.max(r, b);
}

// Engine magenta is purple: red AND blue both strong, green weak. Scoring off the
// WEAKER of r/b (instead of their average) means pure red (low b) and pure blue
// (low r) garments score ~0 and are never mistaken for the magenta void.
function magentaScore(r, g, b) {
    return Math.min(r, b) - g;
}

function isEngineMagenta(r, g, b) {
    const score = magentaScore(r, g, b);
    if (score < 28) return false;
    // Engine magenta is purple — red AND blue are both strong. Pure red (high r,
    // low b) and pure blue (low r, high b) garments would otherwise score high on
    // (r+b)/2 - g and get wrongly keyed out, so require the weaker of r/b to be at
    // least half the stronger before treating a pixel as magenta.
    if (Math.min(r, b) < Math.max(r, b) * 0.5) return false;
    if (g > Math.max(r, b) * 0.72) return false;
    if (r > 45 && b > 45 && g < Math.max(r, b) * 0.58) return true;
    if (score > 55 && g < 95) return true;
    if (b > 65 && r > 35 && g < 55 && b >= r * 0.55) return true;
    return false;
}

function chromaKeyRgb(r, g, b, cfg) {
    if (isEngineMagenta(r, g, b)) {
        return { r: 0, g: 0, b: 0, a: 0 };
    }
    const ex = excessGreen(r, g, b);
    if (ex >= cfg.hard) {
        return { r: 0, g: 0, b: 0, a: 0 };
    }
    let a = 255;
    const softStart = cfg.hard - cfg.soft;
    if (ex > softStart) {
        a = Math.round(255 * (cfg.hard - ex) / cfg.soft);
        if (a < 0) a = 0;
    }
    return despillRgb(r, g, b, a);
}

function despillRgb(r, g, b, a) {
    if (a <= 0) return { r: 0, g: 0, b: 0, a: 0 };
    const maxRB = Math.max(r, b);
    let gOut = g;
    if (gOut > maxRB) {
        const spill = gOut - maxRB;
        const strength = 0.35 + 0.65 * (a / 255);
        gOut = Math.round(maxRB + spill * (1 - strength));
        if (gOut > maxRB) gOut = maxRB;
    }
    return { r, g: gOut, b, a };
}

function despillBuffer(rgba, width, height) {
    for (let i = 0; i < width * height; i++) {
        const o = i * 4;
        const d = despillRgb(rgba[o], rgba[o + 1], rgba[o + 2], rgba[o + 3]);
        rgba[o] = d.r;
        rgba[o + 1] = d.g;
        rgba[o + 2] = d.b;
        rgba[o + 3] = d.a;
    }
}

function removeEnclosedHoles(rgba, width, height) {
    const n = width * height;
    const exterior = new Uint8Array(n);
    const queue = [];

    const seed = (x, y) => {
        const i = y * width + x;
        if (exterior[i] || rgba[i * 4 + 3] === 0) return;
        exterior[i] = 1;
        queue.push(i);
    };

    for (let x = 0; x < width; x++) {
        seed(x, 0);
        seed(x, height - 1);
    }
    for (let y = 0; y < height; y++) {
        seed(0, y);
        seed(width - 1, y);
    }

    for (let qi = 0; qi < queue.length; qi++) {
        const idx = queue[qi];
        const x = idx % width;
        const y = (idx / width) | 0;
        if (x > 0) seed(x - 1, y);
        if (x < width - 1) seed(x + 1, y);
        if (y > 0) seed(x, y - 1);
        if (y < height - 1) seed(x, y + 1);
    }

    const seen = new Uint8Array(n);
    const maxHole = Math.max(64, Math.floor(n * 0.4));

    for (let start = 0; start < n; start++) {
        if (exterior[start] || seen[start] || rgba[start * 4 + 3] === 0) continue;

        const blob = [];
        const stack = [start];
        seen[start] = 1;

        while (stack.length) {
            const idx = stack.pop();
            blob.push(idx);
            const x = idx % width;
            const y = (idx / width) | 0;
            if (x > 0) {
                const ni = idx - 1;
                if (!seen[ni] && !exterior[ni] && rgba[ni * 4 + 3] > 0) {
                    seen[ni] = 1;
                    stack.push(ni);
                }
            }
            if (x < width - 1) {
                const ni = idx + 1;
                if (!seen[ni] && !exterior[ni] && rgba[ni * 4 + 3] > 0) {
                    seen[ni] = 1;
                    stack.push(ni);
                }
            }
            if (y > 0) {
                const ni = idx - width;
                if (!seen[ni] && !exterior[ni] && rgba[ni * 4 + 3] > 0) {
                    seen[ni] = 1;
                    stack.push(ni);
                }
            }
            if (y < height - 1) {
                const ni = idx + width;
                if (!seen[ni] && !exterior[ni] && rgba[ni * 4 + 3] > 0) {
                    seen[ni] = 1;
                    stack.push(ni);
                }
            }
        }

        if (blob.length > maxHole) continue;

        let scoreSum = 0;
        let magCount = 0;
        for (const idx of blob) {
            const o = idx * 4;
            const r = rgba[o];
            const g = rgba[o + 1];
            const b = rgba[o + 2];
            scoreSum += magentaScore(r, g, b);
            if (isEngineMagenta(r, g, b)) magCount++;
        }
        const avgScore = scoreSum / blob.length;
        if (avgScore < 18 && magCount < blob.length * 0.35) continue;

        for (const idx of blob) {
            const o = idx * 4;
            rgba[o] = 0;
            rgba[o + 1] = 0;
            rgba[o + 2] = 0;
            rgba[o + 3] = 0;
        }
    }
}

function removeCenterMagentaVoid(rgba, width, height) {
    const cx = Math.floor(width / 2);
    const cy = Math.floor(height / 2);
    const start = cy * width + cx;
    const so = start * 4;
    if (rgba[so + 3] === 0) return;

    const sr = rgba[so];
    const sg = rgba[so + 1];
    const sb = rgba[so + 2];
    if (!isEngineMagenta(sr, sg, sb) && magentaScore(sr, sg, sb) < 32) return;

    const visited = new Uint8Array(width * height);
    const stack = [start];
    const maxBlob = Math.min(6000, Math.floor(width * height * 0.15));
    let count = 0;

    while (stack.length && count < maxBlob) {
        const idx = stack.pop();
        if (visited[idx]) continue;
        const o = idx * 4;
        if (rgba[o + 3] === 0) continue;

        const r = rgba[o];
        const g = rgba[o + 1];
        const b = rgba[o + 2];
        if (!isEngineMagenta(r, g, b) && magentaScore(r, g, b) < 18) continue;

        visited[idx] = 1;
        count++;
        rgba[o] = 0;
        rgba[o + 1] = 0;
        rgba[o + 2] = 0;
        rgba[o + 3] = 0;

        const x = idx % width;
        const y = (idx / width) | 0;
        if (x > 0) stack.push(idx - 1);
        if (x < width - 1) stack.push(idx + 1);
        if (y > 0) stack.push(idx - width);
        if (y < height - 1) stack.push(idx + width);
    }
}

function removeMagentaArtifacts(rgba, width, height) {
    for (let i = 0; i < width * height; i++) {
        const o = i * 4;
        if (rgba[o + 3] === 0) continue;
        const r = rgba[o];
        const g = rgba[o + 1];
        const b = rgba[o + 2];
        if (isEngineMagenta(r, g, b)) {
            rgba[o] = 0;
            rgba[o + 1] = 0;
            rgba[o + 2] = 0;
            rgba[o + 3] = 0;
        }
    }
}

function erodeGreenFringe(rgba, width, height) {
    const alpha = Buffer.alloc(width * height);
    for (let i = 0; i < width * height; i++) alpha[i] = rgba[i * 4 + 3];

    for (let y = 0; y < height; y++) {
        for (let x = 0; x < width; x++) {
            const idx = y * width + x;
            const o = idx * 4;
            if (alpha[idx] === 0) continue;

            const r = rgba[o];
            const g = rgba[o + 1];
            const b = rgba[o + 2];
            const ex = excessGreen(r, g, b);

            let neighborMin = alpha[idx];
            if (x > 0) neighborMin = Math.min(neighborMin, alpha[idx - 1]);
            if (x < width - 1) neighborMin = Math.min(neighborMin, alpha[idx + 1]);
            if (y > 0) neighborMin = Math.min(neighborMin, alpha[idx - width]);
            if (y < height - 1) neighborMin = Math.min(neighborMin, alpha[idx + width]);

            if (ex > 10 || (neighborMin < alpha[idx] && ex > 4)) {
                const newA = Math.min(alpha[idx], neighborMin);
                if (newA < 140 || ex > 22) {
                    rgba[o] = 0;
                    rgba[o + 1] = 0;
                    rgba[o + 2] = 0;
                    rgba[o + 3] = 0;
                } else {
                    rgba[o + 3] = newA;
                }
            }
        }
    }
}

function toRGBA(img) {
    const { width, height, channels, data } = img;
    if (channels === 4) {
        return { rgba: Buffer.from(data), width, height };
    }
    const rgba = Buffer.alloc(width * height * 4);
    for (let i = 0; i < width * height; i++) {
        const s = i * channels;
        const d = i * 4;
        const r = data[s];
        rgba[d] = r;
        rgba[d + 1] = channels >= 2 ? data[s + 1] : r;
        rgba[d + 2] = channels >= 3 ? data[s + 2] : r;
        rgba[d + 3] = channels === 4 ? data[s + 3] : (channels === 2 ? data[s + 1] : 255);
    }
    return { rgba, width, height };
}

function encodeOutput(rgba, width, height) {
    const cfg = outputCfg();
    const resized = resizeRGBA(rgba, width, height, cfg.maxSize);
    rgba = resized.rgba;
    width = resized.width;
    height = resized.height;
    despillBuffer(rgba, width, height);
    removeMagentaArtifacts(rgba, width, height);
    removeEnclosedHoles(rgba, width, height);
    removeCenterMagentaVoid(rgba, width, height);
    erodeGreenFringe(rgba, width, height);
    cleanRgbaForEncode(rgba);

    return {
        ext: 'png',
        buffer: encodePNG(width, height, rgba, cfg.pngLevel),
    };
}

function processImage(img, outPathBase) {
    const { width, height, channels, data } = img;
    const rgba = Buffer.alloc(width * height * 4);
    const keyCfg = chromaCfg();

    let minX = width, minY = height, maxX = -1, maxY = -1;
    for (let i = 0; i < width * height; i++) {
        const s = i * channels;
        const r = data[s];
        const g = channels >= 2 ? data[s + 1] : r;
        const b = channels >= 3 ? data[s + 2] : r;

        const keyed = chromaKeyRgb(r, g, b, keyCfg);
        const d = i * 4;
        rgba[d] = keyed.r;
        rgba[d + 1] = keyed.g;
        rgba[d + 2] = keyed.b;
        rgba[d + 3] = keyed.a;

        if (keyed.a > 0) {
            const x = i % width;
            const y = (i / width) | 0;
            if (x < minX) minX = x;
            if (x > maxX) maxX = x;
            if (y < minY) minY = y;
            if (y > maxY) maxY = y;
        }
    }

    despillBuffer(rgba, width, height);
    removeMagentaArtifacts(rgba, width, height);
    removeEnclosedHoles(rgba, width, height);
    removeCenterMagentaVoid(rgba, width, height);
    erodeGreenFringe(rgba, width, height);

    let crop = rgba;
    let cw = width;
    let ch = height;
    if (maxX >= minX && maxY >= minY) {
        cw = maxX - minX + 1;
        ch = maxY - minY + 1;
        crop = Buffer.alloc(cw * ch * 4);
        for (let y = 0; y < ch; y++) {
            const src = ((minY + y) * width + minX) * 4;
            crop.set(rgba.subarray(src, src + cw * 4), y * cw * 4);
        }
    }

    const bucket = dominantColorBucket(crop, cw, ch);
    const { ext, buffer } = encodeOutput(crop, cw, ch);
    const outPath = `${outPathBase}.${ext}`;
    fs.mkdirSync(outPath.slice(0, outPath.lastIndexOf('/')), { recursive: true });
    fs.writeFileSync(outPath, buffer);
    return { ext, bucket };
}

function processBuffer(buffer, outPathBase) {
    return processImage(decodePNG(buffer), outPathBase);
}

function processFile(rawPath, outPathBase) {
    return processBuffer(fs.readFileSync(rawPath), outPathBase);
}

// Push a freshly written thumbnail inline to the capturing client so open NUI
// panels update instantly (without waiting for a resource remount / nui:// URL).
function pushInlineThumb(src, key, dir, ext, bucket) {
    if (!src || src <= 0) return;
    // Never ship the PNG as a data-URL net event: after ~30 shots that clogs
    // CEF (the same process screenshot-basic / screencapture use) and the batch
    // hangs waiting for a callback that never comes. Cache-bust is enough.
    try {
        emitNet('opc:client:thumbReady', src, key, Date.now(), '', bucket);
    } catch (pushErr) {
        console.log(`^3 thumb ready push failed for '${key}': ${pushErr.message}^0`);
    }
}

// screencapture hands the frame back through a cross-resource export callback,
// and the FiveM bridge does NOT preserve the Node Buffer type — depending on the
// runtime/version `data` arrives as a base64 (data URI) string, an ArrayBuffer, a
// typed-array view, a { type:'Buffer', data:[...] } shape, or a numeric-keyed
// object. Coerce every shape into a real Buffer so PNG decoding never blows up.
function toImageBuffer(data) {
    if (data == null) return null;
    if (Buffer.isBuffer(data)) return data;
    if (typeof data === 'string') {
        const comma = data.indexOf(',');
        const b64 = (data.startsWith('data:') && comma >= 0) ? data.slice(comma + 1) : data;
        return Buffer.from(b64, 'base64');
    }
    if (data instanceof ArrayBuffer) return Buffer.from(data);
    if (ArrayBuffer.isView(data)) return Buffer.from(data.buffer, data.byteOffset, data.byteLength);
    if (Array.isArray(data)) return Buffer.from(data);
    if (typeof data === 'object') {
        // JSON-serialized Buffer: { type: 'Buffer', data: [...] }
        if (Array.isArray(data.data)) return Buffer.from(data.data);
        if (typeof data.data === 'string') return toImageBuffer(data.data);
        // Array-like object with numeric byte values.
        const vals = Object.values(data);
        if (vals.length && vals.every((v) => typeof v === 'number')) return Buffer.from(vals);
    }
    return null;
}

// Identify the image container from its magic bytes — our pure-JS decoder only
// understands PNG, so anything else (webp/jpg) must be surfaced loudly.
function sniffFormat(buf) {
    if (!buf || buf.length < 12) return 'empty';
    if (buf[0] === 0x89 && buf[1] === 0x50 && buf[2] === 0x4E && buf[3] === 0x47) return 'png';
    if (buf[0] === 0xFF && buf[1] === 0xD8) return 'jpg';
    if (buf[0] === 0x52 && buf[1] === 0x49 && buf[2] === 0x46 && buf[3] === 0x46
        && buf[8] === 0x57 && buf[9] === 0x45 && buf[10] === 0x42 && buf[11] === 0x50) return 'webp';
    return 'unknown';
}

let _capDiagLogged = false;
function logCaptureShape(key, data) {
    if (_capDiagLogged) return;
    _capDiagLogged = true;
    let shape;
    if (data === null || data === undefined) shape = String(data);
    else if (typeof data === 'string') shape = `string(len=${data.length}) head="${data.slice(0, 40)}"`;
    else if (Buffer.isBuffer(data)) shape = `Buffer(len=${data.length})`;
    else if (typeof data === 'object') {
        const keys = Object.keys(data).slice(0, 6).join(',');
        shape = `${data.constructor ? data.constructor.name : 'Object'} keys=[${keys}]`;
    } else shape = typeof data;
    console.log(`^3 first capture for '${key}': capture backend returned ${shape}^0`);
}

function captureBackend() {
    const b = (typeof GetConvar === 'function' && GetConvar('opc_thumbs_capture_backend', 'screencapture')) || 'screencapture';
    return (b === 'screenshot-basic' || b === 'screenshot_basic') ? 'screenshot-basic' : 'screencapture';
}

function runGreenscreen(src, key, data) {
    const dir = thumbsDir();
    if (!dir) {
        console.log(`^1 cannot save thumbnail '${key}': store path not found. `
            + `Check Config.Thumbnails.StoreResource / StorePath.^0`);
        return false;
    }

    logCaptureShape(key, data);
    const buf = toImageBuffer(data);
    if (!buf || buf.length === 0) {
        console.log(`^1 capture returned no usable data for '${key}' `
            + `(got ${data === null ? 'null' : typeof data})^0`);
        return false;
    }
    const fmt = sniffFormat(buf);
    if (fmt !== 'png') {
        console.log(`^1 capture for '${key}' came back as '${fmt}', not PNG — `
            + `the greenscreener can only key PNG. Force encoding='png' on `
            + `Config.Thumbnails.Screenshot.Backend ('${captureBackend()}').^0`);
        return false;
    }
    const { ext, bucket } = processBuffer(buf, `${dir}/${key}`);
    if (bucket) saveColorEntry(key, bucket);
    pushInlineThumb(src, key, dir, ext, bucket);
    return true;
}

function finishCapture(src, key, ok, token) {
    emitNet('opc:client:thumbnailCaptureDone', src, key, ok, token);
    scheduleManifest();
}

on('opc:thumbs:processData', (src, key, data, token) => {
    const run = () => {
        let ok = false;
        try {
            ok = runGreenscreen(src, key, data);
        } catch (err) {
            console.log(`^1 greenscreen post-process failed for '${key}': ${err && err.stack ? err.stack : err}^0`);
        }
        finishCapture(src, key, ok, token);
    };
    // Don't chroma-key on the screenshot callback stack — a 1280² PNG decode
    // can stall the capture backend so the next requestClientScreenshot never fires.
    if (typeof setImmediate === 'function') setImmediate(run);
    else setTimeout(run, 0);
});

on('opc:thumbs:capture', (src, key) => {
    let finished = false;
    const finish = (ok) => {
        if (finished) return;
        finished = true;
        finishCapture(src, key, ok);
    };

    try {
        const resName = (typeof GetConvar === 'function'
            && GetConvar('opc_thumbs_capture_res', 'screencapture')) || 'screencapture';
        const backend = captureBackend();
        const maxW = parseInt((typeof GetConvar === 'function' && GetConvar('opc_thumbs_cap_w', '1280')) || '1280', 10) || 1280;
        const maxH = parseInt((typeof GetConvar === 'function' && GetConvar('opc_thumbs_cap_h', '1280')) || '1280', 10) || 1280;
        const opts = { encoding: 'png', maxWidth: maxW, maxHeight: maxH };

        const onData = (data) => {
            try {
                finish(runGreenscreen(src, key, data));
            } catch (err) {
                console.log(`^1 greenscreen post-process failed for '${key}': ${err && err.stack ? err.stack : err}^0`);
                finish(false);
            }
        };

        if (backend === 'screenshot-basic') {
            // Omit fileName so screenshot-basic returns a data URI instead of writing a file.
            exports[resName].requestClientScreenshot(src, opts, (err, data) => {
                if (err) {
                    console.log(`^1 screenshot-basic error for '${key}': ${err}^0`);
                    return finish(false);
                }
                onData(data);
            });
            return;
        }

        exports[resName].serverCapture(src, opts, onData, 'base64');
    } catch (err) {
        console.log(`^1 capture failed for '${key}': ${err && err.stack ? err.stack : err}^0`);
        finish(false);
    }
});

on('opc:thumbs:process', (rawPath, src, key) => {
    let ok = false;
    const finish = () => {
        emitNet('opc:client:thumbnailCaptureDone', src, key, ok);
        scheduleManifest();
    };

    try {
        const dir = thumbsDir();
        if (!dir) {
            console.log(`^1 cannot save thumbnail '${key}': store path not found. `
                + `Check Config.Thumbnails.StoreResource / StorePath.^0`);
            return finish();
        }
        if (!fs.existsSync(rawPath)) {
            console.log(`^1 cannot process '${key}': raw screenshot missing at ${rawPath}. `
                + `Check 'add_filesystem_permission screenshot-basic write op-clothing' in server.cfg.^0`);
            return finish();
        }

        const { ext, bucket } = processFile(rawPath, `${dir}/${key}`);
        try { fs.unlinkSync(rawPath); } catch (e) { /* raw cleanup is best-effort */ }
        ok = true;
        if (bucket) saveColorEntry(key, bucket);

        if (src && src > 0) {
            try {
                const outPath = `${dir}/${key}.${ext}`;
                const raw = fs.readFileSync(outPath);
                if (raw.length > 0 && raw.length <= 512 * 1024) {
                    const mime = ext === 'webp' ? 'image/webp' : 'image/png';
                    emitNet('opc:client:thumbReady', src, key, Date.now(),
                        `data:${mime};base64,${raw.toString('base64')}`, bucket);
                }
            } catch (pushErr) {
                console.log(`^3 thumb inline push failed for '${key}': ${pushErr.message}^0`);
            }
        }

        finish();
    } catch (err) {
        console.log(`^1 greenscreen post-process failed for '${key}': ${err && err.stack ? err.stack : err}^0`);
        finish();
    }
});

function thumbsDir() {
    const store = (typeof GetConvar === 'function' && GetConvar('opc_thumbs_store', 'op-clothing')) || 'op-clothing';
    const sub = ((typeof GetConvar === 'function' && GetConvar('opc_thumbs_store_path', 'thumbnails')) || 'thumbnails').replace(/^\/+/, '');
    const root = (GetResourcePath(store) || '').replace(/\\/g, '/');
    return root ? `${root}/${sub}` : null;
}

function rawDir() {
    const root = (GetResourcePath(GetCurrentResourceName()) || '').replace(/\\/g, '/');
    return root ? `${root}/web/thumbnails-raw` : null;
}

function buildManifest() {
    const dir = thumbsDir();
    if (!dir || !fs.existsSync(dir)) return;
    const keys = fs.readdirSync(dir)
        .filter((f) => /\.png$/i.test(f))
        .map((f) => f.replace(/\.png$/i, ''));
    const json = JSON.stringify({ generatedAt: Math.floor(Date.now() / 1000), count: keys.length, keys });
    fs.writeFileSync(`${dir}/manifest.json`, json);
}

let manifestTimer = null;
function scheduleManifest() {
    if (manifestTimer) clearTimeout(manifestTimer);
    manifestTimer = setTimeout(() => {
        manifestTimer = null;
        try { buildManifest(); } catch (e) { console.log(`^3 manifest build failed: ${e.message}^0`); }
    }, 4000);
}

setTimeout(() => {
    const raw = rawDir();
    if (raw) {
        try {
            fs.mkdirSync(raw, { recursive: true });
        } catch (e) {
            console.log(`^1 could not create raw staging dir ${raw}: ${e.message}^0`);
        }
    }

    const dir = thumbsDir();
    if (!dir) {
        console.log('^1 thumbnail store path NOT found — check Config.Thumbnails.StoreResource '
            + 'and StorePath in MainConfig.lua.^0');
        return;
    }
    try {
        fs.mkdirSync(dir, { recursive: true });
        const probe = `${dir}/.write-test`;
        fs.writeFileSync(probe, 'ok');
        fs.unlinkSync(probe);
    } catch (e) {
        console.log(`^1 thumbnail store NOT writable at ${dir}: ${e.message}^0`);
    }
    try { buildManifest(); } catch (e) { /* dir may not exist yet */ }
}, 2000);

on('opc:thumbs:manifest', () => { try { buildManifest(); } catch (e) {} });

function loadJsonFile(file, fallback) {
    try { return JSON.parse(fs.readFileSync(file, 'utf8')); } catch (e) { return fallback; }
}

function defaultHashMap(dir) {
    return loadJsonFile(`${dir}/default-hashmap.json`, { male: {}, female: {} });
}

function localHashMap(dir) {
    const data = loadJsonFile(`${dir}/hashmap-local.json`, { male: {}, female: {} });
    if (typeof data !== 'object' || !data) return { male: {}, female: {} };
    if (typeof data.male !== 'object') data.male = {};
    if (typeof data.female !== 'object') data.female = {};
    return data;
}

function writeLocalHashMap(dir, data) {
    fs.mkdirSync(dir, { recursive: true });
    fs.writeFileSync(`${dir}/hashmap-local.json`, JSON.stringify(data));
    writeHashMapExport(dir);
}

function writeHashMapExport(dir) {
    const defaults = defaultHashMap(dir);
    const local = localHashMap(dir);
    const merged = {
        male: { ...(defaults.male || {}), ...(local.male || {}) },
        female: { ...(defaults.female || {}), ...(local.female || {}) },
    };
    const maleN = Object.keys(merged.male).length;
    const femaleN = Object.keys(merged.female).length;
    fs.writeFileSync(`${dir}/hashmap-export.json`, JSON.stringify(merged));
    console.log(`^2 hashmap-export.json ready for CDN upload (${maleN} male + ${femaleN} female entries)^0`);
}

on('opc:thumbs:saveHashMap', (gender, map, localOnly) => {
    try {
        const dir = thumbsDir();
        if (!dir || !map) return;
        fs.mkdirSync(dir, { recursive: true });

        if (localOnly) {
            const data = localHashMap(dir);
            const defaults = defaultHashMap(dir);
            const defGender = (defaults[gender] && typeof defaults[gender] === 'object') ? defaults[gender] : {};
            const locGender = (data[gender] && typeof data[gender] === 'object') ? data[gender] : {};
            let added = 0;
            for (const [h, key] of Object.entries(map)) {
                if (defGender[h]) continue;
                locGender[h] = key;
                added++;
            }
            data[gender] = locGender;
            writeLocalHashMap(dir, data);
            console.log(`^2 local hash map merged for ${gender}: +${added} addon entries^0`);
            return;
        }

        const file = `${dir}/hashmap.json`;
        let data = loadJsonFile(file, {});
        if (typeof data !== 'object' || !data) data = {};
        data[gender] = map;
        fs.writeFileSync(file, JSON.stringify(data));
        const n = Object.keys(map).length;
        console.log(`^2 hash map saved for ${gender}: ${n} items → ${file}^0`);
    } catch (err) {
        console.log(`^3 hash map save failed: ${err.message}^0`);
    }
});

on('opc:thumbs:saveHashMapLocal', (gender, entries) => {
    try {
        const dir = thumbsDir();
        if (!dir || !entries || typeof entries !== 'object') return;
        const data = localHashMap(dir);
        const locGender = (data[gender] && typeof data[gender] === 'object') ? data[gender] : {};
        for (const [h, key] of Object.entries(entries)) {
            if (h && key) locGender[h] = key;
        }
        data[gender] = locGender;
        writeLocalHashMap(dir, data);
        console.log(`^2 local hash override for ${gender}: ${Object.keys(entries).length} item(s)^0`);
    } catch (err) {
        console.log(`^3 local hash map save failed: ${err.message}^0`);
    }
});

on('opc:thumbs:recompressAll', () => {
    const dir = thumbsDir();
    if (!dir || !fs.existsSync(dir)) {
        console.log('^1 recompress: thumbnail store not found^0');
        return;
    }
    const files = fs.readdirSync(dir).filter((f) => /\.png$/i.test(f));
    if (!files.length) {
        console.log('^3 recompress: no PNG files in store^0');
        return;
    }
    console.log(`^2 recompressing ${files.length} thumbnails (max ${outputCfg().maxSize}px)...^0`);
    let idx = 0;
    let before = 0;
    let after = 0;
    let ok = 0;
    const step = () => {
        if (idx >= files.length) {
            const saved = before - after;
            console.log(`^2 recompress done: ${ok}/${files.length} files, `
                + `${(before / 1048576).toFixed(1)} MB → ${(after / 1048576).toFixed(1)} MB `
                + `(−${(saved / 1048576).toFixed(1)} MB)^0`);
            try { buildManifest(); } catch (e) { /* ignore */ }
            return;
        }
        const name = files[idx++];
        const fp = `${dir}/${name}`;
        let oldSz = 0;
        try {
            oldSz = fs.statSync(fp).size;
            before += oldSz;
            const img = decodePNG(fs.readFileSync(fp));
            const { rgba, width, height } = toRGBA(img);
            const { buffer } = encodeOutput(rgba, width, height);
            fs.writeFileSync(fp, buffer);
            after += buffer.length;
            ok++;
            if (ok % 250 === 0) {
                console.log(`^2 recompress progress: ${ok}/${files.length}^0`);
            }
        } catch (e) {
            after += oldSz;
            console.log(`^3 recompress skip ${name}: ${e.message}^0`);
        }
        setImmediate(step);
    };
    setImmediate(step);
});