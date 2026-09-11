/*
    cDev Car Rental — NUI
*/

let vehicles = [];
let currencySymbol = '$';
let locationIndex = 1;
let requireSignature = true;
let rentalSettings = {
    minHours: 1,
    maxHours: 24,
    defaultHours: 1
};

let locale = {
    title: 'Vehicle Rental',
    hours: 'Hours',
    rent: 'Rent Now',
    testDrive: 'Test Drive',
    close: 'Close',
    duration: 'Duration',
    hourShort: 'h',
    hourOne: '1 Hour',
    hoursFmt: '%s Hours',
    depositFmt: '%s deposit',
    hourlyFmt: '+%s/hr',
    perHrFmt: '%s/hr',
    signModalTitle: 'Rental agreement',
    signModalSub: 'Sign below, then confirm.',
    signHere: 'Sign here',
    clearSignature: 'Clear',
    confirmRental: 'Confirm',
    cancel: 'Cancel',
    platePending: 'TBD'
};

let imageMap = null;

function getResourceName() {
    if (window.GetParentResourceName && typeof window.GetParentResourceName === 'function') {
        return window.GetParentResourceName();
    }
    return 'cDev_CarRental';
}

async function loadImageMap() {
    try {
        const response = await fetch('images/image_map.json');
        if (response.ok) {
            imageMap = await response.json();
        }
    } catch (e) {
        console.log('[cDev-CarRental] image map:', e);
    }
}

loadImageMap();

const rentalPanel = document.getElementById('rentalPanel');
const vehicleGrid = document.getElementById('vehicleGrid');
const closeBtn = document.getElementById('closeBtn');
const panelTitle = document.getElementById('panelTitle');
const snowfallContainer = document.getElementById('snowfall');

function formatHoursLabel(h) {
    if (h === 1) return locale.hourOne || '1 Hour';
    const fmt = locale.hoursFmt || '%s Hours';
    return fmt.replace('%s', String(h));
}

function initSnowfall() {
    for (let i = 0; i < 50; i++) {
        createSnowflake();
    }
}

function createSnowflake() {
    const snowflake = document.createElement('div');
    snowflake.className = 'snowflake';
    snowflake.innerHTML = '●';
    snowflake.style.left = Math.random() * 100 + '%';
    snowflake.style.animationDuration = (Math.random() * 3 + 4) + 's';
    snowflake.style.animationDelay = Math.random() * 5 + 's';
    snowflake.style.fontSize = (Math.random() * 8 + 4) + 'px';
    snowflake.style.opacity = Math.random() * 0.5 + 0.2;
    snowfallContainer.appendChild(snowflake);
    snowflake.addEventListener('animationend', () => {
        snowflake.remove();
        createSnowflake();
    });
}

function findVehicleImage(model) {
    const modelLower = model.toLowerCase();
    if (imageMap && imageMap[modelLower]) {
        return 'images/' + imageMap[modelLower];
    }
    return `images/${modelLower}.png`;
}

function createVehicleCard(vehicle) {
    const card = document.createElement('div');
    card.className = 'vehicle-card';
    card.dataset.model = vehicle.model;
    card.dataset.downpayment = vehicle.downpayment || 0;
    card.dataset.pricePerHour = vehicle.pricePerHour;

    const initialHours = rentalSettings.defaultHours;
    const downpayment = vehicle.downpayment || 0;
    const hourlyTotal = vehicle.pricePerHour * initialHours;
    const initialPrice = downpayment + hourlyTotal;

    const imagePath = findVehicleImage(vehicle.model);
    const imageHtml = imagePath
        ? `<img src="${imagePath}" alt="${vehicle.name}" onerror="this.parentElement.innerHTML='<span class=\\'no-image\\'>${vehicle.name}</span>'">`
        : `<span class="no-image">${vehicle.name}</span>`;

    const durLabel = locale.duration || 'Duration';
    const hs = locale.hourShort || 'h';
    const depositFmt = locale.depositFmt || '%s deposit';
    const hourlyFmt = locale.hourlyFmt || '+%s/hr';
    const perHrFmt = locale.perHrFmt || '%s/hr';

    const downpaymentHtml = downpayment > 0
        ? `<div class="price-info"><span class="price-deposit">${depositFmt.replace('%s', currencySymbol + downpayment)}</span><span class="price-hourly">${hourlyFmt.replace('%s', currencySymbol + vehicle.pricePerHour)}</span></div>`
        : `<div class="price-per-hour">${perHrFmt.replace('%s', currencySymbol + vehicle.pricePerHour)}</div>`;

    const progressPct = ((initialHours - rentalSettings.minHours) / (rentalSettings.maxHours - rentalSettings.minHours)) * 100;

    const durationHtml = `
        <div class="rental-duration-container">
            <div class="duration-header">
                <span class="duration-label">${durLabel}</span>
                <span class="duration-value" data-model="${vehicle.model}">${formatHoursLabel(initialHours)}</span>
            </div>
            <div class="slider-wrapper">
                <span class="slider-min">${rentalSettings.minHours}${hs}</span>
                <div class="slider-container">
                    <div class="slider-progress" style="width: ${progressPct}%"></div>
                    <input type="range" class="duration-slider" data-model="${vehicle.model}"
                           min="${rentalSettings.minHours}" max="${rentalSettings.maxHours}" value="${initialHours}">
                </div>
                <span class="slider-max">${rentalSettings.maxHours}${hs}</span>
            </div>
        </div>`;

    card.innerHTML = `
        <div class="vehicle-image">${imageHtml}</div>
        <div class="vehicle-info">
            <div class="vehicle-name">${vehicle.name}</div>
            ${downpaymentHtml}
        </div>
        ${durationHtml}
        <div class="vehicle-buttons">
            <button class="btn-rent" data-model="${vehicle.model}" data-price="${initialPrice}" data-hours="${initialHours}">
                <span class="btn-text">${locale.rent || 'Rent Now'}</span>
                <span class="btn-price">${currencySymbol}${initialPrice.toLocaleString()}</span>
            </button>
            <button class="btn-testdrive" data-model="${vehicle.model}">${locale.testDrive}</button>
        </div>
    `;

    return card;
}

function renderVehicles() {
    vehicleGrid.innerHTML = '';
    vehicles.forEach(vehicle => {
        vehicleGrid.appendChild(createVehicleCard(vehicle));
    });
    attachCardListeners();
}

function attachCardListeners() {
    document.querySelectorAll('.btn-rent').forEach(btn => btn.addEventListener('click', handleRent));
    document.querySelectorAll('.btn-testdrive').forEach(btn => btn.addEventListener('click', handleTestDrive));
    document.querySelectorAll('.duration-slider').forEach(slider => {
        slider.addEventListener('input', handleDurationChange);
    });
}

function handleDurationChange(e) {
    const model = e.target.dataset.model;
    const hours = parseInt(e.target.value, 10);
    const card = e.target.closest('.vehicle-card');
    const rentBtn = card.querySelector('.btn-rent');
    const durationValue = card.querySelector(`.duration-value[data-model="${model}"]`);
    const sliderProgress = card.querySelector('.slider-progress');
    const vehicle = vehicles.find(v => v.model === model);
    if (!vehicle) return;

    const downpayment = vehicle.downpayment || 0;
    const newPrice = downpayment + vehicle.pricePerHour * hours;
    const progressPercent = ((hours - rentalSettings.minHours) / (rentalSettings.maxHours - rentalSettings.minHours)) * 100;
    if (sliderProgress) sliderProgress.style.width = progressPercent + '%';

    durationValue.textContent = formatHoursLabel(hours);
    rentBtn.dataset.price = newPrice;
    rentBtn.dataset.hours = hours;
    rentBtn.querySelector('.btn-price').textContent = `${currencySymbol}${newPrice.toLocaleString()}`;
}

function getCompactSignatureDataUrl() {
    if (!sigCanvas || !sigCtx) return null;
    const dpr = window.devicePixelRatio || 1;
    const srcW = sigCanvas.width / dpr;
    const srcH = sigCanvas.height / dpr;
    const maxW = 400;
    const scale = Math.min(1, maxW / srcW);
    const dw = Math.max(1, Math.round(srcW * scale));
    const dh = Math.max(1, Math.round(srcH * scale));
    const c = document.createElement('canvas');
    c.width = dw;
    c.height = dh;
    const ctx = c.getContext('2d');
    ctx.fillStyle = '#faf8f3';
    ctx.fillRect(0, 0, dw, dh);
    ctx.drawImage(sigCanvas, 0, 0, sigCanvas.width, sigCanvas.height, 0, 0, dw, dh);
    return c.toDataURL('image/jpeg', 0.72);
}

function postRent(vehiclePayload, signed, signatureImage) {
    const resourceName = getResourceName();
    const body = {
        vehicle: vehiclePayload,
        rentalAgreementSigned: signed === true
    };
    if (signatureImage && typeof signatureImage === 'string' && signatureImage.length > 32) {
        body.signatureImage = signatureImage;
    }
    fetch(`https://${resourceName}/rent`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body)
    }).catch(err => console.log('[cDev-CarRental] rent:', err));
}

let pendingRentVehicle = null;

function handleRent(e) {
    e.preventDefault();
    e.stopPropagation();
    const btn = e.target.closest('.btn-rent');
    if (!btn) return;

    btn.classList.add('clicked');
    setTimeout(() => btn.classList.remove('clicked'), 300);

    const model = btn.dataset.model;
    const totalPrice = parseInt(btn.dataset.price, 10);
    const hours = parseInt(btn.dataset.hours, 10) || 1;
    const vehicle = vehicles.find(v => v.model === model);
    if (!vehicle) return;

    const downpayment = vehicle.downpayment || 0;
    const payload = {
        model: vehicle.model,
        name: vehicle.name,
        downpayment: downpayment,
        pricePerHour: vehicle.pricePerHour,
        hours: hours,
        totalPrice: totalPrice
    };

    if (requireSignature) {
        pendingRentVehicle = payload;
        openSignatureModal();
    } else {
        postRent(payload, true);
    }
}

function handleTestDrive(e) {
    e.preventDefault();
    e.stopPropagation();
    const btn = e.target.closest('.btn-testdrive');
    if (!btn) return;
    const model = btn.dataset.model;
    const vehicle = vehicles.find(v => v.model === model);
    if (!vehicle) return;

    fetch(`https://${getResourceName()}/testdrive`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ vehicle: { model: vehicle.model, name: vehicle.name } })
    }).catch(err => console.log('[cDev-CarRental] testdrive:', err));
}

let isClosing = false;

function closeUI() {
    if (isClosing) return;
    isClosing = true;
    rentalPanel.classList.add('closing');
    rentalPanel.classList.remove('visible');
    fetch(`https://${getResourceName()}/close`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    }).catch(() => {});
    setTimeout(() => {
        rentalPanel.classList.add('hidden');
        rentalPanel.classList.remove('closing');
        isClosing = false;
    }, 200);
}

function openUI(data) {
    if (data.vehicles) vehicles = data.vehicles;
    if (data.currencySymbol) currencySymbol = data.currencySymbol;
    if (data.locationIndex) locationIndex = data.locationIndex;
    if (data.rentalSettings) rentalSettings = { ...rentalSettings, ...data.rentalSettings };
    requireSignature = data.requireSignature !== false;

    if (data.locale) {
        locale = { ...locale, ...data.locale };
        panelTitle.textContent = (locale.title || 'Rental').toUpperCase();
    }

    renderVehicles();
    rentalPanel.classList.remove('hidden');
    void rentalPanel.offsetWidth;
    rentalPanel.classList.add('visible');
}

closeBtn.addEventListener('click', closeUI);

document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
        if (!signatureModal.classList.contains('hidden')) {
            closeSignatureModal();
        } else {
            closeUI();
            closePapers();
        }
    }
});

/* ---------- Signature modal ---------- */

const signatureModal = document.getElementById('signatureRentalModal');
const sigModalTitle = document.getElementById('sigModalTitle');
const sigModalSub = document.getElementById('sigModalSub');
const sigCanvas = document.getElementById('sigCanvas');
const sigCanvasHint = document.getElementById('sigCanvasHint');
const sigClearBtn = document.getElementById('sigClearBtn');
const sigCancelBtn = document.getElementById('sigCancelBtn');
const sigConfirmBtn = document.getElementById('sigConfirmBtn');

let sigCtx = null;
let sigDrawing = false;
let sigHasInk = false;

function resizeSigCanvas() {
    const wrap = sigCanvas.parentElement;
    const w = Math.min(520, wrap.clientWidth - 4);
    const h = 180;
    const dpr = window.devicePixelRatio || 1;
    sigCanvas.width = Math.floor(w * dpr);
    sigCanvas.height = Math.floor(h * dpr);
    sigCanvas.style.width = w + 'px';
    sigCanvas.style.height = h + 'px';
    sigCtx = sigCanvas.getContext('2d');
    sigCtx.setTransform(dpr, 0, 0, dpr, 0, 0);
    sigCtx.strokeStyle = '#111';
    sigCtx.lineWidth = 2.2;
    sigCtx.lineCap = 'round';
    sigCtx.lineJoin = 'round';
}

function openSignatureModal() {
    sigModalTitle.textContent = locale.signModalTitle || 'Rental agreement';
    sigModalSub.textContent = locale.signModalSub || '';
    sigClearBtn.textContent = locale.clearSignature || 'Clear';
    sigCancelBtn.textContent = locale.cancel || 'Cancel';
    sigConfirmBtn.textContent = locale.confirmRental || 'Confirm';
    sigCanvasHint.textContent = locale.signHere || 'Sign here';
    sigCanvasHint.classList.remove('hidden');
    sigHasInk = false;
    sigConfirmBtn.disabled = true;
    signatureModal.classList.remove('hidden');
    signatureModal.setAttribute('aria-hidden', 'false');
    requestAnimationFrame(() => {
        resizeSigCanvas();
        if (sigCtx) {
            const dpr = window.devicePixelRatio || 1;
            const lw = sigCanvas.width / dpr;
            const lh = sigCanvas.height / dpr;
            sigCtx.fillStyle = '#faf8f3';
            sigCtx.fillRect(0, 0, lw, lh);
        }
    });

    fetch(`https://${getResourceName()}/rentalAgreementOpened`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    }).catch(() => {});
}

function closeSignatureModal() {
    signatureModal.classList.add('hidden');
    signatureModal.setAttribute('aria-hidden', 'true');
    pendingRentVehicle = null;
    sigDrawing = false;
}

function clearSignatureCanvas() {
    if (!sigCtx) return;
    resizeSigCanvas();
    const dpr = window.devicePixelRatio || 1;
    const w = sigCanvas.width / dpr;
    const h = sigCanvas.height / dpr;
    sigCtx.fillStyle = '#faf8f3';
    sigCtx.fillRect(0, 0, w, h);
    sigHasInk = false;
    sigConfirmBtn.disabled = true;
    sigCanvasHint.classList.remove('hidden');
}

function getCanvasPos(ev) {
    const rect = sigCanvas.getBoundingClientRect();
    const clientX = ev.touches ? ev.touches[0].clientX : ev.clientX;
    const clientY = ev.touches ? ev.touches[0].clientY : ev.clientY;
    return {
        x: clientX - rect.left,
        y: clientY - rect.top
    };
}

function onSigStart(ev) {
    ev.preventDefault();
    if (!sigCtx) return;
    sigDrawing = true;
    const p = getCanvasPos(ev);
    sigCtx.beginPath();
    sigCtx.moveTo(p.x, p.y);
}

function onSigMove(ev) {
    if (!sigDrawing || !sigCtx) return;
    ev.preventDefault();
    const p = getCanvasPos(ev);
    sigCtx.lineTo(p.x, p.y);
    sigCtx.stroke();
    if (!sigHasInk) {
        sigHasInk = true;
        sigCanvasHint.classList.add('hidden');
        sigConfirmBtn.disabled = false;
    }
}

function onSigEnd(ev) {
    if (ev) ev.preventDefault();
    sigDrawing = false;
}

sigCanvas.addEventListener('mousedown', onSigStart);
sigCanvas.addEventListener('mousemove', onSigMove);
window.addEventListener('mouseup', onSigEnd);
sigCanvas.addEventListener('touchstart', onSigStart, { passive: false });
sigCanvas.addEventListener('touchmove', onSigMove, { passive: false });
sigCanvas.addEventListener('touchend', onSigEnd);

sigClearBtn.addEventListener('click', () => clearSignatureCanvas());
sigCancelBtn.addEventListener('click', () => closeSignatureModal());
document.getElementById('signatureModalBackdrop').addEventListener('click', () => closeSignatureModal());

sigConfirmBtn.addEventListener('click', () => {
    if (!pendingRentVehicle || !sigHasInk) return;
    const sigData = getCompactSignatureDataUrl();
    postRent(pendingRentVehicle, true, sigData);
    closeSignatureModal();
});

/* ---------- Rental papers ---------- */

const papersContainer = document.getElementById('papersContainer');
const papersCloseBtn = document.getElementById('papersCloseBtn');
const signatureLine = document.getElementById('signatureLine');
const papersSignatureImage = document.getElementById('papersSignatureImage');
const signPlaceholder = document.getElementById('signPlaceholder');
const signatureText = document.getElementById('signatureText');
const signatureName = document.getElementById('signatureName');
const signatureDate = document.getElementById('signatureDate');
const papersStamp = document.getElementById('papersStamp');

let currentRenterName = '';
let isSigned = false;

function openPapers(data) {
    isSigned = false;
    signatureLine.classList.remove('signed', 'has-drawn-sig');
    signatureText.textContent = '';
    signatureName.textContent = '';
    papersStamp.classList.remove('visible');

    papersSignatureImage.classList.add('hidden');
    papersSignatureImage.removeAttribute('src');
    signPlaceholder.classList.remove('hidden');
    signatureText.classList.remove('hidden');

    const sym = data.currencySymbol || '$';
    currentRenterName = data.renterName || 'Unknown';

    document.getElementById('renterName').textContent = currentRenterName;
    document.getElementById('rentalDate').textContent = data.rentalDate || '__________';
    document.getElementById('vehicleNamePaper').textContent = data.vehicleName || '-';
    document.getElementById('vehicleModelPaper').textContent = (data.vehicleModel || '-').toUpperCase();
    document.getElementById('vehiclePlatePaper').textContent = (data.vehiclePlate || '-').toUpperCase();

    const hours = data.hours || 1;
    document.getElementById('rentalHoursPaper').textContent = hours === 1 ? '1 Hour' : `${hours} Hours`;
    document.getElementById('downpaymentPaper').textContent = sym + (data.downpayment || 0).toLocaleString();
    document.getElementById('pricePerHourPaper').textContent = sym + (data.pricePerHour || 0) + '/hr';
    document.getElementById('returnDatePaper').textContent = data.returnDate || '-';
    document.getElementById('totalPricePaper').textContent = sym + (data.totalPrice || 0).toLocaleString();
    signatureDate.textContent = data.rentalDate || new Date().toLocaleDateString();

    const drawn = data.signatureImage && typeof data.signatureImage === 'string' && data.signatureImage.startsWith('data:image');
    if (drawn) {
        papersSignatureImage.src = data.signatureImage;
        papersSignatureImage.classList.remove('hidden');
        signPlaceholder.classList.add('hidden');
        signatureText.classList.add('hidden');
        signatureLine.classList.add('signed', 'has-drawn-sig');
        signatureName.textContent = currentRenterName;
        papersStamp.classList.add('visible');
        isSigned = true;
    }

    papersContainer.classList.add('visible');
}

function signDocument() {
    if (isSigned) return;
    if (papersSignatureImage && !papersSignatureImage.classList.contains('hidden') && papersSignatureImage.src) return;
    isSigned = true;
    signatureLine.classList.add('signed');
    signatureText.classList.remove('hidden');
    signatureText.textContent = currentRenterName;
    signatureName.textContent = currentRenterName;
    setTimeout(() => papersStamp.classList.add('visible'), 200);
}

function closePapers() {
    papersContainer.classList.remove('visible');
    fetch(`https://${getResourceName()}/closePapers`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    }).catch(() => {});
}

papersCloseBtn.addEventListener('click', closePapers);
signatureLine.addEventListener('click', signDocument);

window.addEventListener('message', (event) => {
    const data = event.data;
    switch (data.action) {
        case 'open':
            isClosing = false;
            openUI(data);
            break;
        case 'close':
            rentalPanel.classList.remove('visible');
            rentalPanel.classList.add('hidden');
            isClosing = false;
            break;
        case 'openPapers':
            openPapers(data);
            break;
        case 'closePapers':
            papersContainer.classList.remove('visible');
            break;
        default:
            break;
    }
});

document.addEventListener('DOMContentLoaded', () => {
    initSnowfall();
    rentalPanel.classList.add('hidden');
    signatureModal.classList.add('hidden');
});
