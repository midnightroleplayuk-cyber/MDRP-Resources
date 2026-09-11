const Locale = {};
function t(key) {
    return Locale[key] !== undefined ? Locale[key] : key;
}
function applyLocale(strings) {
    if (!strings || typeof strings !== 'object') return;
    Object.assign(Locale, strings);
    document.querySelectorAll('[data-i18n]').forEach(function(el) {
        var key = el.getAttribute('data-i18n');
        if (Locale[key] !== undefined) el.textContent = Locale[key];
    });
    document.querySelectorAll('[data-i18n-placeholder]').forEach(function(el) {
        var key = el.getAttribute('data-i18n-placeholder');
        if (Locale[key] !== undefined) el.placeholder = Locale[key];
    });
    var docCopy = document.getElementById('docCopyText');
    if (docCopy && Locale['contractCopy']) docCopy.textContent = Locale['contractCopy'];
    if (summaryVehicle && !state.selectedVehicle) summaryVehicle.textContent = t('noVehicleChosen');
    if (summaryDuration && !state.selectedDuration) summaryDuration.textContent = t('selectDuration');
}
const app               = document.getElementById('app');
const timer             = document.getElementById('timer');
const vehicleList       = document.getElementById('vehicleList');
const durationList      = document.getElementById('durationList');
const stationLabel      = document.getElementById('stationLabel');
const brandLogo         = document.getElementById('brandLogo');
const brandSubtitle     = document.getElementById('brandSubtitle');
const pricePreview      = document.getElementById('pricePreview');
const summaryVehicle    = document.getElementById('summaryVehicle');
const summaryDuration   = document.getElementById('summaryDuration');
const bookingModal      = document.getElementById('bookingModal');
const bookingBrand      = document.getElementById('bookingBrand');
const bookingCloseBtn   = document.getElementById('bookingCloseBtn');
const selectedImage     = document.getElementById('selectedImage');
const selectedImageWrap = document.getElementById('selectedImageWrap');
const openContractBtn   = document.getElementById('openContractBtn');
const paymentButtons    = document.querySelectorAll('.payment-option');
const contractModal     = document.getElementById('contractModal');
const paper             = document.getElementById('paper');
const signAnimation     = document.getElementById('signAnimation');
const animatedSignature = document.getElementById('animatedSignature');
const signatureInput    = document.getElementById('signatureInput');
const rentBtn           = document.getElementById('rentBtn');
let isSigning     = false;
let timerEndsAtMs = 0;
let timerInterval = null;
let state = {
    currency: '$',
    stationLabel: '',
    style: null,
    vehicles: [],
    durations: [],
    selectedVehicle: null,
    selectedDuration: null,
    paymentMethod: 'cash'
};
function post(name, data) {
    fetch('https://' + GetParentResourceName() + '/' + name, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify(data || {})
    });
}
function applyStyle(style) {
    var s         = style || {};
    var accent    = s.accent     || '#ffe033';
    var accentTxt = s.accentText || '#111111';
    var label     = s.label      || '';
    var subtitle  = s.subtitle   || '';
    var logo      = s.logo       || label;
    var logoImage = s.logoImage  || '';
    document.documentElement.style.setProperty('--accent', accent);
    document.documentElement.style.setProperty('--accent-text', accentTxt);
    if (brandLogo)     brandLogo.textContent     = logo;
    if (brandSubtitle) brandSubtitle.textContent = subtitle;
    if (bookingBrand)  bookingBrand.textContent  = logo;
    var docBrand = document.getElementById('docBrand');
    if (docBrand) docBrand.textContent = label;
    var heroBrandImage  = document.getElementById('heroBrandImage');
    var heroBrandText   = document.getElementById('heroBrandText');
    var heroBrandLogoEl = document.getElementById('heroBrandLogo');
    var heroBrandSubEl  = document.getElementById('heroBrandSub');
    if (heroBrandLogoEl) heroBrandLogoEl.textContent = logo;
    if (heroBrandSubEl)  heroBrandSubEl.textContent  = subtitle;
    if (heroBrandImage && heroBrandText) {
        heroBrandImage.removeAttribute('src');
        heroBrandImage.classList.add('hidden');
        heroBrandText.classList.remove('hidden');
        if (logoImage) {
            heroBrandImage.onload  = function() { heroBrandImage.classList.remove('hidden'); heroBrandText.classList.add('hidden'); };
            heroBrandImage.onerror = function() { heroBrandImage.classList.add('hidden');    heroBrandText.classList.remove('hidden'); };
            heroBrandImage.src = logoImage;
        }
    }
}
function setImage(imgEl, wrapper, src) {
    if (!imgEl || !wrapper) return;
    wrapper.classList.remove('has-image');
    imgEl.removeAttribute('src');
    imgEl.alt = '';
    if (!src) return;
    wrapper.classList.add('has-image');
    imgEl.onload  = function() { wrapper.classList.add('has-image'); };
    imgEl.onerror = function() { wrapper.classList.remove('has-image'); imgEl.removeAttribute('src'); };
    imgEl.src = src;
}
function money(value) {
    return Math.floor(value).toLocaleString('de-DE') + state.currency;
}
function ratePrice() {
    if (!state.selectedVehicle || !state.selectedDuration) return 0;
    return state.selectedVehicle.basePrice * state.selectedDuration.priceMultiplier;
}
function totalPrice() {
    if (!state.selectedVehicle || !state.selectedDuration) return 0;
    return ratePrice() + state.selectedVehicle.deposit;
}
function hasSelection() {
    return !!(state.selectedVehicle && state.selectedDuration);
}
function todayLabel() {
    return new Intl.DateTimeFormat('de-DE', {
        day: '2-digit', month: '2-digit', year: 'numeric',
        hour: '2-digit', minute: '2-digit'
    }).format(new Date());
}
function paymentLabel(method) {
    return method === 'card' ? t('card') : t('cash');
}
function updateSummary() {
    var selected  = hasSelection();
    var signature = signatureInput.value.trim();
    pricePreview.textContent    = money(totalPrice());
    summaryVehicle.textContent  = state.selectedVehicle  ? state.selectedVehicle.label  : t('noVehicleChosen');
    summaryDuration.textContent = state.selectedDuration ? state.selectedDuration.label : t('selectDuration');
    setImage(selectedImage, selectedImageWrap, state.selectedVehicle ? state.selectedVehicle.image : null);
    openContractBtn.disabled = !selected;
    rentBtn.disabled = !selected || signature.length < 3 || isSigning;
}
function setPaymentMethod(method) {
    state.paymentMethod = method === 'card' ? 'card' : 'cash';
    paymentButtons.forEach(function(btn) {
        btn.classList.toggle('active', btn.dataset.payment === state.paymentMethod);
    });
}
function openBooking(vehicle) {
    state.selectedVehicle  = vehicle;
    state.selectedDuration = null;
    renderVehicles();
    renderDurations();
    updateSummary();
    bookingModal.classList.remove('hidden');
}
function closeBooking() {
    bookingModal.classList.add('hidden');
}
function fillContractDocument() {
    var vehicle  = state.selectedVehicle;
    var duration = state.selectedDuration;
    if (!vehicle || !duration) return;
    document.getElementById('docStation').textContent  = state.stationLabel;
    document.getElementById('docDate').textContent     = todayLabel();
    document.getElementById('docStatus').textContent   = t('statusUnsigned');
    document.getElementById('docVehicle').textContent  = vehicle.label;
    document.getElementById('docCategory').textContent = vehicle.category;
    document.getElementById('docDuration').textContent = duration.label;
    document.getElementById('docRate').textContent     = money(vehicle.basePrice) + ' x ' + duration.priceMultiplier;
    document.getElementById('docDeposit').textContent  = money(vehicle.deposit);
    document.getElementById('docPayment').textContent  = paymentLabel(state.paymentMethod);
    document.getElementById('docTotal').textContent    = money(totalPrice());
    var docCopy = document.getElementById('docCopyText');
    if (docCopy) docCopy.textContent = t('contractCopy');
}
function openContract() {
    if (!hasSelection()) return;
    isSigning = false;
    fillContractDocument();
    signAnimation.classList.add('hidden');
    animatedSignature.textContent = '';
    paper.classList.remove('signing');
    signatureInput.value = '';
    updateSummary();
    closeBooking();
    contractModal.classList.remove('hidden');
    setTimeout(function() { signatureInput.focus(); }, 50);
}
function closeContract() {
    if (isSigning) return;
    contractModal.classList.add('hidden');
    signAnimation.classList.add('hidden');
    animatedSignature.textContent = '';
    paper.classList.remove('signing');
}
function finishRental() {
    post('rentVehicle', {
        vehicleModel:    state.selectedVehicle.model,
        durationMinutes: state.selectedDuration.minutes,
        paymentMethod:   state.paymentMethod,
        signature:       signatureInput.value.trim()
    });
    isSigning = false;
    closeContract();
    post('close');
}
function playSigningAnimation() {
    if (rentBtn.disabled || isSigning) return;
    isSigning = true;
    rentBtn.disabled = true;
    document.getElementById('docStatus').textContent = t('statusSigning');
    animatedSignature.textContent = signatureInput.value.trim();
    animatedSignature.style.animation = 'none';
    void animatedSignature.offsetWidth;
    animatedSignature.style.animation = '';
    paper.classList.add('signing');
    signAnimation.classList.remove('hidden');
    setTimeout(function() {
        document.getElementById('docStatus').textContent = t('statusSigned');
        finishRental();
    }, 1350);
}
function renderVehicles() {
    vehicleList.innerHTML = '';
    var emptyState = document.getElementById('emptyState');
    if (!state.vehicles.length) {
        if (emptyState) { vehicleList.appendChild(emptyState); emptyState.classList.remove('hidden'); }
        return;
    }
    if (emptyState) emptyState.classList.add('hidden');
    state.vehicles.forEach(function(vehicle) {
        var button = document.createElement('button');
        button.type = 'button';
        button.className = 'vehicle-card' + (state.selectedVehicle && state.selectedVehicle.model === vehicle.model ? ' active' : '');
        button.style.setProperty('--accent', vehicle.accent || '#39d7ff');
        button.innerHTML = '<div class="vehicle-visual"></div><div class="vehicle-title"><div><span>' + vehicle.label + '</span><strong>' + money(vehicle.basePrice) + '</strong></div></div>';
        var visual = button.querySelector('.vehicle-visual');
        if (vehicle.image) {
            var img = new Image();
            img.alt = vehicle.label;
            visual.classList.add('has-image');
            img.onload  = function() { visual.classList.add('has-image'); };
            img.onerror = function() { visual.classList.remove('has-image'); img.remove(); };
            img.src = vehicle.image;
            visual.appendChild(img);
        }
        button.addEventListener('click', function() { openBooking(vehicle); });
        vehicleList.appendChild(button);
    });
}
function renderDurations() {
    durationList.innerHTML = '';
    state.durations.forEach(function(duration) {
        var button = document.createElement('button');
        button.type = 'button';
        button.className = 'duration-card' + (state.selectedDuration && state.selectedDuration.minutes === duration.minutes ? ' active' : '');
        button.innerHTML = '<div class="duration-title"><span>' + duration.label + '</span></div><div class="duration-meta"><span>' + duration.minutes + ' ' + t('minutesShort') + '</span></div>';
        button.addEventListener('click', function() {
            state.selectedDuration = duration;
            renderDurations();
            updateSummary();
        });
        durationList.appendChild(button);
    });
}
function setData(data) {
    state = {
        currency:         data.currency     || '$',
        stationLabel:     data.stationLabel || '',
        style:            data.style        || null,
        vehicles:         data.vehicles     || [],
        durations:        data.durations    || [],
        selectedVehicle:  null,
        selectedDuration: null,
        paymentMethod:    'cash'
    };
    if (data.locale && typeof data.locale === 'object') {
        applyLocale(data.locale);
    }
    isSigning = false;
    setPaymentMethod(state.paymentMethod);
    stationLabel.textContent = state.stationLabel;
    applyStyle(state.style);
    closeBooking();
    contractModal.classList.add('hidden');
    signAnimation.classList.add('hidden');
    animatedSignature.textContent = '';
    paper.classList.remove('signing');
    signatureInput.value = '';
    renderVehicles();
    renderDurations();
    updateSummary();
}
function formatRemaining(seconds) {
    var safe    = Math.max(0, Number(seconds) || 0);
    var hours   = Math.floor(safe / 3600);
    var minutes = Math.floor((safe % 3600) / 60);
    var secs    = safe % 60;
    if (hours > 0) return hours + ':' + String(minutes).padStart(2, '0') + ':' + String(secs).padStart(2, '0');
    return String(minutes).padStart(2, '0') + ':' + String(secs).padStart(2, '0');
}
function updateTimerDisplay() {
    if (!timerEndsAtMs) return;
    var nowMs     = Date.now();
    var diffMs    = timerEndsAtMs - nowMs;
    var overdue   = diffMs < 0;
    var absSecs   = Math.ceil(Math.abs(diffMs) / 1000);
    timer.classList.remove('hidden');
    timer.classList.toggle('overdue', overdue);
    document.getElementById('timerValue').textContent = (overdue ? '+' : '') + formatRemaining(absSecs);
}
function stopRentalTimer() {
    if (timerInterval) { clearInterval(timerInterval); timerInterval = null; }
    timerEndsAtMs = 0;
    timer.classList.add('hidden');
    timer.classList.remove('overdue');
    var outTimer = document.getElementById('outTimer');
    if (outTimer) outTimer.classList.add('hidden');
}
function showRentalHud(data) {
    var endsAt    = Number(data.endsAt    || 0);
    var remaining = Number(data.remaining || 0);
    timerEndsAtMs = endsAt > 0 ? endsAt * 1000 : Date.now() + (remaining * 1000);
    // Out-of-vehicle timer
    var outTimer      = document.getElementById('outTimer');
    var outTimerValue = document.getElementById('outTimerValue');
    if (outTimer && outTimerValue) {
        if (data.outOfVehicle && data.outRemaining !== undefined && data.outRemaining !== null) {
            outTimerValue.textContent = formatRemaining(Number(data.outRemaining));
            var outTimerLabel = document.getElementById('outTimerLabel');
            if (outTimerLabel) outTimerLabel.textContent = t('outOfVehicleHud');
            outTimer.classList.remove('hidden');
            outTimer.classList.toggle('urgent', Number(data.outRemaining) <= 60);
        } else {
            outTimer.classList.add('hidden');
        }
    }
    updateTimerDisplay();
    if (!timerInterval) timerInterval = setInterval(updateTimerDisplay, 1000);
}
document.getElementById('closeBtn').addEventListener('click', function() { if (!isSigning) post('close'); });
document.getElementById('contractCloseBtn').addEventListener('click', closeContract);
document.getElementById('cancelContractBtn').addEventListener('click', closeContract);
bookingCloseBtn.addEventListener('click', closeBooking);
openContractBtn.addEventListener('click', openContract);
paymentButtons.forEach(function(btn) { btn.addEventListener('click', function() { setPaymentMethod(btn.dataset.payment); }); });
signatureInput.addEventListener('input', updateSummary);
rentBtn.addEventListener('click', playSigningAnimation);
window.addEventListener('keydown', function(event) {
    if (event.key !== 'Escape' || isSigning) return;
    if (!contractModal.classList.contains('hidden')) { closeContract(); return; }
    if (!bookingModal.classList.contains('hidden'))  { closeBooking();  return; }
    post('close');
});
window.addEventListener('message', function(event) {
    var action = event.data && event.data.action;
    var data   = event.data && event.data.data;
    if (action === 'open')    app.classList.remove('hidden');
    if (action === 'close')   { isSigning = false; closeBooking(); closeContract(); app.classList.add('hidden'); }
    if (action === 'setData') setData(data || {});
    if (action === 'timer')   showRentalHud(data || {});
    if (action === 'rentalStarted') showRentalHud({ remaining: Number(data.durationMinutes || 0) * 60, endsAt: data.endsAt });
    if (action === 'rentalEnded')   stopRentalTimer();
});
// ── Rental Paper Viewer ──────────────────────────────────────────
const paperViewer        = document.getElementById('paperViewer');
const paperViewerClose1  = document.getElementById('paperViewerCloseBtn');
const paperViewerClose2  = document.getElementById('paperViewerCloseBtn2');

function openPaperViewer(data) {
    var locale = data.locale;
    if (locale && typeof locale === 'object') applyLocale(locale);

    var currency = data.currency || '$';
    function fmt(v) { return v !== undefined && v !== null ? Math.floor(Number(v) || 0).toLocaleString('de-DE') + currency : '-'; }

    var docBrand = document.getElementById('viewerDocBrand');
    if (docBrand) docBrand.textContent = data.stationLabel || '';

    document.getElementById('viewerStation').textContent    = data.stationLabel || '-';
    document.getElementById('viewerDate').textContent       = data.startedAt    || '-';
    document.getElementById('viewerValidUntil').textContent = data.endsAt       || '-';
    document.getElementById('viewerVehicle').textContent    = data.vehicle      || '-';
    document.getElementById('viewerCategory').textContent   = data.category     || '-';
    document.getElementById('viewerDuration').textContent   = data.duration     || '-';
    document.getElementById('viewerDeposit').textContent    = fmt(data.deposit);
    document.getElementById('viewerPayment').textContent    = data.payment      || '-';
    document.getElementById('viewerTotal').textContent      = fmt(data.total);
    document.getElementById('viewerPlate').textContent      = data.plate        || '-';
    document.getElementById('viewerRenter').textContent     = data.renterName   || '-';
    document.getElementById('viewerSignature').textContent  = data.signature    || '';

    var docCopy = document.getElementById('viewerDocCopy');
    if (docCopy) docCopy.textContent = t('contractCopy');

    paperViewer.classList.remove('hidden');
}

function closePaperViewer() {
    paperViewer.classList.add('hidden');
    post('closePaper');
}

if (paperViewerClose1) paperViewerClose1.addEventListener('click', closePaperViewer);
if (paperViewerClose2) paperViewerClose2.addEventListener('click', closePaperViewer);

window.addEventListener('keydown', function(e) {
    if (e.key === 'Escape' && !paperViewer.classList.contains('hidden')) {
        closePaperViewer();
    }
});

// Listen for showRentalPaper from client.lua
var _origMessage = window.onmessage;
window.addEventListener('message', function(event) {
    var action = event.data && event.data.action;
    var data   = event.data && event.data.data;
    if (action === 'showRentalPaper') openPaperViewer(data || {});
    if (action === 'closeAll') { closePaperViewer(); }
});
