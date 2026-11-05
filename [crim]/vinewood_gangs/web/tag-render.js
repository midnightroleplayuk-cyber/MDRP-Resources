'use strict';

/* Draws a tag design onto a canvas. Shared by the in-world DUI (tag.html) and the tablet previews.
   Text is painted with fillText, so design text can never inject markup. */

const TAG_FONTS = {
  handstyle: "'Sedgwick Ave Display'",
  spray: "'Rubik Spray Paint'",
  marker: "'Permanent Marker'",
  block: "'Bungee'",
};

async function loadTagFont(family) {
  try { await document.fonts.load(`120px ${family}`); } catch (e) { /* fall back to Impact */ }
}

const imageCache = {};
const imageLoaded = {};
function imageCacheHas(url) { return imageLoaded[url] === true; }
function loadImage(url) {
  if (!imageCache[url]) {
    imageCache[url] = new Promise((resolve) => {
      const img = new Image();
      img.onload = () => { imageLoaded[url] = true; resolve(img); };
      img.onerror = () => { imageLoaded[url] = false; resolve(null); };
      img.src = url;
    });
  }
  return imageCache[url];
}

/* A picture tag: the image fitted to the wall space, slightly tilted, with soft sprayed edges */
async function drawPicture(canvas, spec) {
  const ctx = canvas.getContext('2d');
  const W = canvas.width, H = canvas.height;
  const img = await loadImage(spec.url);
  ctx.clearRect(0, 0, W, H);
  if (!img || !img.width) return;
  const scale = Math.min((W * 0.86) / img.width, (H * 0.86) / img.height);
  const w = img.width * scale, h = img.height * scale;
  ctx.save();
  ctx.translate(W / 2, H / 2);
  ctx.rotate(-0.04);
  ctx.shadowColor = 'rgba(0, 0, 0, 0.35)';
  ctx.shadowBlur = Math.max(4, w * 0.015);
  ctx.globalAlpha = 0.94; // a touch of the wall shows through, like paint
  ctx.drawImage(img, -w / 2, -h / 2, w, h);
  ctx.restore();
}

async function drawTag(canvas, spec) {
  const ctx = canvas.getContext('2d');
  const W = canvas.width, H = canvas.height;
  if (spec && spec.kind === 'image') return drawPicture(canvas, spec);
  ctx.clearRect(0, 0, W, H);
  if (!spec || !spec.text) return;

  const family = TAG_FONTS[spec.font] || TAG_FONTS.spray;
  await loadTagFont(family);

  let size = H * 0.62;
  const setFont = () => { ctx.font = `${size}px ${family}, Impact, sans-serif`; };
  setFont();
  const maxWidth = W * 0.86;
  const measured = ctx.measureText(spec.text).width;
  if (measured > maxWidth) { size *= maxWidth / measured; setFont(); }

  ctx.save();
  ctx.translate(W / 2, H / 2);
  ctx.rotate(-0.05);
  ctx.textAlign = 'center';
  ctx.textBaseline = 'middle';
  ctx.lineJoin = 'round';

  if (spec.style === 'outline') {
    ctx.lineWidth = size * 0.14;
    ctx.strokeStyle = spec.outline;
    ctx.shadowColor = spec.outline;
    ctx.shadowBlur = size * 0.06;
    ctx.strokeText(spec.text, 0, 0);
  } else if (spec.style === 'shadow') {
    ctx.fillStyle = spec.outline;
    ctx.shadowColor = spec.outline;
    ctx.shadowBlur = size * 0.05;
    ctx.fillText(spec.text, size * 0.07, size * 0.07);
  }

  // Soft overspray on the fill makes it read as paint rather than type
  ctx.fillStyle = spec.fill;
  ctx.shadowColor = spec.fill;
  ctx.shadowBlur = size * 0.04;
  ctx.fillText(spec.text, 0, 0);
  ctx.restore();
}

/* Two rough strokes in the crossing gang's colour */
function drawCross(canvas, colour) {
  const ctx = canvas.getContext('2d');
  const W = canvas.width, H = canvas.height;
  ctx.clearRect(0, 0, W, H);
  ctx.strokeStyle = colour;
  ctx.shadowColor = colour;
  ctx.shadowBlur = 14;
  ctx.lineCap = 'round';
  ctx.lineWidth = H * 0.09;

  const stroke = (x1, y1, x2, y2) => {
    ctx.beginPath();
    ctx.moveTo(x1, y1);
    ctx.quadraticCurveTo((x1 + x2) / 2 + 30, (y1 + y2) / 2 - 20, x2, y2);
    ctx.stroke();
  };
  stroke(W * 0.12, H * 0.15, W * 0.88, H * 0.85);
  stroke(W * 0.86, H * 0.12, W * 0.16, H * 0.88);
}
