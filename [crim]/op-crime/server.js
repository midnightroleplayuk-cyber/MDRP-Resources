const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

const resourceName = GetCurrentResourceName();
const resourcePath = GetResourcePath(resourceName);
const mainSavePath = path.join(resourcePath, 'web', 'build', 'images');

const PNG_SIGNATURE = Buffer.from([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]);

const CRC_TABLE = (function () {
  const table = new Uint32Array(256);
  for (let n = 0; n < 256; n++) {
    let c = n;
    for (let k = 0; k < 8; k++) {
      c = (c & 1) ? (0xEDB88320 ^ (c >>> 1)) : (c >>> 1);
    }
    table[n] = c;
  }
  return table;
})();

function crc32(buf) {
  let c = 0xFFFFFFFF;
  for (let i = 0; i < buf.length; i++) {
    c = CRC_TABLE[(c ^ buf[i]) & 0xFF] ^ (c >>> 8);
  }
  return (c ^ 0xFFFFFFFF) >>> 0;
}

function ensureDir(dirPath) {
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
  }
}

function sanitizeName(name, fallback) {
  let safe = String(name || fallback).replace(/[^a-zA-Z0-9_-]/g, '');
  return safe.length ? safe : fallback;
}

function decodePng(buf) {
  if (buf.length < 8 || !buf.subarray(0, 8).equals(PNG_SIGNATURE)) {
    throw new Error('Not a PNG file');
  }

  let width = 0;
  let height = 0;
  let bitDepth = 0;
  let colorType = 0;
  const idatChunks = [];
  let offset = 8;

  while (offset < buf.length) {
    const length = buf.readUInt32BE(offset);
    const type = buf.toString('ascii', offset + 4, offset + 8);
    const data = buf.subarray(offset + 8, offset + 8 + length);

    if (type === 'IHDR') {
      width = data.readUInt32BE(0);
      height = data.readUInt32BE(4);
      bitDepth = data[8];
      colorType = data[9];
    } else if (type === 'IDAT') {
      idatChunks.push(data);
    } else if (type === 'IEND') {
      break;
    }

    offset += 8 + length + 4;
  }

  if (bitDepth !== 8 || colorType !== 6) {
    throw new Error('Only 8-bit RGBA PNGs are supported (got bitDepth=' +
      bitDepth + ', colorType=' + colorType + ')');
  }

  const filtered = zlib.inflateSync(Buffer.concat(idatChunks));
  const bpp = 4;
  const stride = width * bpp;
  const pixels = Buffer.alloc(width * height * bpp);

  for (let y = 0; y < height; y++) {
    const filterByte = filtered[y * (stride + 1)];
    const rowStart = y * (stride + 1) + 1;
    const dstOffset = y * stride;
    const prevOffset = (y - 1) * stride;

    for (let x = 0; x < stride; x++) {
      const raw = filtered[rowStart + x];
      const left = x >= bpp ? pixels[dstOffset + x - bpp] : 0;
      const up = y > 0 ? pixels[prevOffset + x] : 0;
      const upLeft = (y > 0 && x >= bpp) ? pixels[prevOffset + x - bpp] : 0;

      let value;
      switch (filterByte) {
        case 0: value = raw; break;
        case 1: value = (raw + left) & 0xFF; break;
        case 2: value = (raw + up) & 0xFF; break;
        case 3: value = (raw + ((left + up) >> 1)) & 0xFF; break;
        case 4: {
          const p = left + up - upLeft;
          const pa = Math.abs(p - left);
          const pb = Math.abs(p - up);
          const pc = Math.abs(p - upLeft);
          let pred;
          if (pa <= pb && pa <= pc) pred = left;
          else if (pb <= pc) pred = up;
          else pred = upLeft;
          value = (raw + pred) & 0xFF;
          break;
        }
        default:
          throw new Error('Unsupported PNG row filter: ' + filterByte);
      }
      pixels[dstOffset + x] = value;
    }
  }

  return { width, height, data: pixels };
}

function encodePng(width, height, pixels) {
  const bpp = 4;
  const stride = width * bpp;
  const filtered = Buffer.alloc(height * (stride + 1));
  for (let y = 0; y < height; y++) {
    filtered[y * (stride + 1)] = 0;
    pixels.copy(filtered, y * (stride + 1) + 1, y * stride, (y + 1) * stride);
  }
  const compressed = zlib.deflateSync(filtered);

  const ihdr = Buffer.alloc(13);
  ihdr.writeUInt32BE(width, 0);
  ihdr.writeUInt32BE(height, 4);
  ihdr[8] = 8;   // bit depth
  ihdr[9] = 6;   // color type: RGBA
  ihdr[10] = 0;  // compression: deflate
  ihdr[11] = 0;  // filter: standard
  ihdr[12] = 0;  // interlace: none

  function chunk(type, data) {
    const typeBuf = Buffer.from(type, 'ascii');
    const lengthBuf = Buffer.alloc(4);
    lengthBuf.writeUInt32BE(data.length, 0);
    const crcBuf = Buffer.alloc(4);
    crcBuf.writeUInt32BE(crc32(Buffer.concat([typeBuf, data])), 0);
    return Buffer.concat([lengthBuf, typeBuf, data, crcBuf]);
  }

  return Buffer.concat([
    PNG_SIGNATURE,
    chunk('IHDR', ihdr),
    chunk('IDAT', compressed),
    chunk('IEND', Buffer.alloc(0)),
  ]);
}

// Chromakey thresholds. Tuned for the bright (0,255,0)-style greenscreen used
// by the in-game furniture preview. We:
//   1. Fully cut pixels where green strongly dominates over the other channels
//      AND the pixel is bright enough to be a real keyer pixel (avoids killing
//      dark greens on actual furniture).
//   2. Softly fade & suppress green spill on edge pixels (greenness between
//      EDGE and FULL) so the cropped object doesn't have a green halo.
const GREEN_FULL_THRESHOLD = 40;   // g - max(r,b) >= this -> alpha = 0
const GREEN_EDGE_THRESHOLD = 12;   // g - max(r,b) >= this -> soft alpha + spill removal
const MIN_KEYER_BRIGHTNESS = 120;  // r + g + b sum needed to count as keyer

function processFurnitureBuffer(rawPng, outPath) {
  try {
    const { width, height, data } = decodePng(rawPng);

    let minX = width;
    let maxX = -1;
    let minY = height;
    let maxY = -1;

    for (let y = 0; y < height; y++) {
      for (let x = 0; x < width; x++) {
        const idx = (y * width + x) << 2;
        const r = data[idx];
        const g = data[idx + 1];
        const b = data[idx + 2];

        const maxRB = r > b ? r : b;
        const greenness = g - maxRB;
        const brightness = r + g + b;

        if (greenness >= GREEN_FULL_THRESHOLD && brightness >= MIN_KEYER_BRIGHTNESS) {
          data[idx + 3] = 0;
        } else if (greenness >= GREEN_EDGE_THRESHOLD && brightness >= MIN_KEYER_BRIGHTNESS) {
          // Soft fade: closer to FULL threshold = more transparent.
          const t = (greenness - GREEN_EDGE_THRESHOLD) / (GREEN_FULL_THRESHOLD - GREEN_EDGE_THRESHOLD);
          const newAlpha = Math.round((1 - t) * data[idx + 3]);
          data[idx + 3] = newAlpha;
          // Spill suppression: clamp the green channel so the edge no longer
          // reads as green even when partially visible. This kills the halo.
          data[idx + 1] = maxRB;
        }

        if (data[idx + 3] > 0) {
          if (x < minX) minX = x;
          if (x > maxX) maxX = x;
          if (y < minY) minY = y;
          if (y > maxY) maxY = y;
        }
      }
    }

    let outWidth = width;
    let outHeight = height;
    let outPixels = data;

    if (maxX >= minX && maxY >= minY) {
      outWidth = maxX - minX + 1;
      outHeight = maxY - minY + 1;
      outPixels = Buffer.alloc(outWidth * outHeight * 4);
      for (let y = 0; y < outHeight; y++) {
        const srcStart = ((y + minY) * width + minX) << 2;
        data.copy(outPixels, y * outWidth * 4, srcStart, srcStart + outWidth * 4);
      }
    }

    fs.writeFileSync(outPath, encodePng(outWidth, outHeight, outPixels));
  } catch (err) {
    console.error('[op-crime] image post-processing failed:', err && err.message);
  }
}

// Accepts either a raw PNG Buffer or a "data:image/png;base64,..." URI string.
function bufferFromScreenshotPayload(payload) {
  if (Buffer.isBuffer(payload)) return payload;
  if (typeof payload !== 'string') return null;

  const commaIdx = payload.indexOf(',');
  const b64 = commaIdx >= 0 && payload.startsWith('data:') ? payload.slice(commaIdx + 1) : payload;
  try {
    return Buffer.from(b64, 'base64');
  } catch (e) {
    return null;
  }
}

ensureDir(mainSavePath);

onNet('gangsTakeScreenshotOfFurniture', (filename, opts) => {
  const src = global.source;
  const safeName = sanitizeName(filename, 'image');
  const mode = (opts && opts.mode) ? String(opts.mode) : 'auto';

  ensureDir(mainSavePath);

  const fullFilePath = path.join(mainSavePath, safeName + '.png');
  console.log('[op-crime] saving furniture screenshot: ' + fullFilePath + ' (mode=' + mode + ')');

  // No `fileName` option -> screenshot-basic streams back a data URI in the
  // callback instead of writing to disk. This avoids the cross-resource
  // filesystem sandbox (newer FiveM artifacts block screenshot-basic from
  // writing into op-crime's folder). We decode in-memory and write the
  // post-processed PNG ourselves, which is allowed because it's a same-
  // resource write.
  exports['screenshot-basic'].requestClientScreenshot(
    src,
    {
      encoding: 'png',
      quality: 1.0,
    },
    (err, payload) => {
      if (err) {
        console.error('[op-crime] screenshot-basic error:', err);
        return;
      }

      const rawPng = bufferFromScreenshotPayload(payload);
      if (!rawPng || rawPng.length === 0) {
        console.error('[op-crime] screenshot-basic returned empty payload');
        return;
      }

      processFurnitureBuffer(rawPng, fullFilePath);
    }
  );
});
