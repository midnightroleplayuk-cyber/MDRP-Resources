let currentBone = 'head';
const cursor = document.getElementById('cursor');
const app = document.getElementById('app');
const xrayImage = document.getElementById('xray-image');
const scanningBar = document.getElementById('scanning-bar');
const medicalOverlay = document.getElementById('medical-overlay');
const boneResults = document.getElementById('bone-results');
const noDataMsg = document.getElementById('no-data-msg');
const patientName = document.getElementById('patient-name');
const patientId = document.getElementById('patient-id');

// Medical X-Ray Images Mapping
const XRAY_IMAGES = {
    head: { healthy: '../assets/head-healthy.png', broken: '../assets/head-broken.png' },
    chest: { healthy: '../assets/chest-healthy.png', broken: '../assets/chest-broken.png' },
    left_arm: { healthy: '../assets/left-hand-healthy.png', broken: '../assets/left-hand-broken.png' },
    right_arm: { healthy: '../assets/right-hand-healthy.png', broken: '../assets/right-hand-broken.png' },
    left_leg: { healthy: '../assets/left-leg-healthy.png', broken: '../assets/left-leg-broken.png' },
    right_leg: { healthy: '../assets/right-leg-healthy.png', broken: '../assets/right-leg-broken.png' }
};

const IS_MONITOR = window.location.search.includes('monitor=true');
const IS_ETA = window.location.search.includes('eta=true');

// ECG Drawing Variables
let waveHrCanvas, waveHrCtx;
let waveSpo2Canvas, waveSpo2Ctx;
let waveBpCanvas, waveBpCtx;
let waveX = 0;
let lastX = 0;
let ecgActive = false;
let monitorPulse = 0;
let monitorSpo2 = 0;
let etaDispatchVisible = false;
let latestDispatchCall = null;
let etaArrivalTimestampMs = null;
let etaInitialMinutes = null;

// Persistent points for smooth lines
let lastYHr = 0, lastYSpo2 = 0, lastYBp = 0;
let smoothHrY = 0;
let smoothSpo2Y = 0;
let smoothBpY = 0;
let hrPhase = 0;
let spo2Phase = 0;
let bpPhase = 0;
let lastFrameTs = 0;

// Auto-show if DUI
if (window.location.search.includes('dui=true')) {
    if (IS_MONITOR) {
        app.style.display = 'none';
        document.getElementById('vitals-app').style.display = 'flex';
        initECG();
    } else if (IS_ETA) {
        app.style.display = 'none';
        document.getElementById('eta-app').style.display = 'flex';
    } else {
        app.style.display = 'flex';
    }
}

function initECG() {
    waveHrCanvas = document.getElementById('wave-hr');
    waveSpo2Canvas = document.getElementById('wave-spo2');
    waveBpCanvas = document.getElementById('wave-bp');
    if (!waveHrCanvas || !waveSpo2Canvas || !waveBpCanvas) return;

    waveHrCtx = waveHrCanvas.getContext('2d');
    waveSpo2Ctx = waveSpo2Canvas.getContext('2d');
    waveBpCtx = waveBpCanvas.getContext('2d');
    
    const resize = () => {
        [waveHrCanvas, waveSpo2Canvas, waveBpCanvas].forEach((canvas) => {
            canvas.width = canvas.offsetWidth;
            canvas.height = canvas.offsetHeight;
        });
        lastYHr = waveHrCanvas.height / 2;
        lastYSpo2 = waveSpo2Canvas.height / 2;
        lastYBp = waveBpCanvas.height / 2;
        smoothHrY = lastYHr;
        smoothSpo2Y = lastYSpo2;
        smoothBpY = lastYBp;
    };
    window.addEventListener('resize', resize);
    resize();
    
    requestAnimationFrame(drawECG);
}

function drawECG() {
    if (!waveHrCtx || !waveSpo2Ctx || !waveBpCtx) return;

    const w = waveHrCanvas.width;
    const now = performance.now();
    const dt = lastFrameTs > 0 ? Math.min(50, now - lastFrameTs) : 16.67;
    lastFrameTs = now;

    if (w <= 0) {
        requestAnimationFrame(drawECG);
        return;
    }

    const drawTrace = (ctx, canvas, color, currentY, lastY) => {
        const h = canvas.height;
        // Trail wipe: Clear the trace layer without affecting the CSS background grid
        ctx.clearRect(waveX, 0, 20, h); 
        
        ctx.strokeStyle = color;
        ctx.lineWidth = 2.5;
        ctx.lineJoin = 'round';
        ctx.lineCap = 'round';
        ctx.shadowBlur = 4;
        ctx.shadowColor = color;

        ctx.beginPath();
        ctx.moveTo(lastX, lastY);
        ctx.lineTo(waveX, currentY);
        ctx.stroke();
    };

    // Calculate new X
    lastX = waveX;
    waveX += 2;
    if (waveX > w) {
        waveX = 0;
        lastX = 0;
        // Clear canvases on wrap to avoid residual artifacts.
        waveHrCtx.clearRect(0, 0, waveHrCanvas.width, waveHrCanvas.height);
        waveSpo2Ctx.clearRect(0, 0, waveSpo2Canvas.width, waveSpo2Canvas.height);
        waveBpCtx.clearRect(0, 0, waveBpCanvas.width, waveBpCanvas.height);
        lastYHr = waveHrCanvas.height / 2;
        lastYSpo2 = waveSpo2Canvas.height / 2;
        lastYBp = waveBpCanvas.height / 2;
        smoothHrY = lastYHr;
        smoothSpo2Y = lastYSpo2;
        smoothBpY = lastYBp;
    }

    // ECG / HR trace (green)
    const hrMid = waveHrCanvas.height / 2;
    let targetHrY = hrMid;
    if (ecgActive && monitorPulse > 0) {
        const beatMs = Math.max(360, Math.floor(60000 / monitorPulse));
        hrPhase = (hrPhase + (dt / beatMs)) % 1;
        // Continuous ECG model using gaussian waves (P, Q, R, S, T).
        const g = (x, mu, sigma) => {
            const d = (x - mu) / sigma;
            return Math.exp(-0.5 * d * d);
        };
        const ecg = 0.015 * Math.sin(2 * Math.PI * hrPhase)
            + 0.12 * g(hrPhase, 0.18, 0.030)   // P
            - 0.16 * g(hrPhase, 0.39, 0.012)   // Q
            + 1.05 * g(hrPhase, 0.42, 0.010)   // R
            - 0.28 * g(hrPhase, 0.45, 0.013)   // S
            + 0.30 * g(hrPhase, 0.70, 0.060);  // T
        targetHrY = hrMid - (ecg * 42.0) + (Math.random() * 0.6 - 0.3);
    } else {
        hrPhase = 0;
        targetHrY = hrMid + (Math.random() * 2 - 1);
    }
    // Low-pass filtering removes micro-jitter and keeps the line smooth.
    smoothHrY = (smoothHrY * 0.72) + (targetHrY * 0.28);
    drawTrace(waveHrCtx, waveHrCanvas, '#58e19f', smoothHrY, lastYHr);
    lastYHr = smoothHrY;

    // SpO2 pleth wave (blue)
    const spo2Mid = waveSpo2Canvas.height / 2;
    let targetSpo2Y = spo2Mid;
    if (ecgActive && monitorPulse > 0) {
        const beatMs = Math.max(380, Math.floor(60000 / Math.max(45, monitorPulse - 3)));
        spo2Phase = (spo2Phase + (dt / beatMs)) % 1;
        const amp = monitorSpo2 > 0 ? Math.max(8, Math.min(18, (monitorSpo2 - 82))) : 10;
        const rise = Math.sin(Math.PI * Math.min(1, spo2Phase * 1.25));
        const notch = spo2Phase > 0.46 && spo2Phase < 0.56 ? 3.0 : 0.0;
        targetSpo2Y = spo2Mid + 5 - (rise * amp) + notch + (Math.random() * 0.5 - 0.25);
    } else {
        spo2Phase = 0;
        targetSpo2Y = spo2Mid + (Math.random() * 2 - 1);
    }
    smoothSpo2Y = (smoothSpo2Y * 0.68) + (targetSpo2Y * 0.32);
    drawTrace(waveSpo2Ctx, waveSpo2Canvas, '#6ab7ff', smoothSpo2Y, lastYSpo2);
    lastYSpo2 = smoothSpo2Y;

    // NIBP trend wave (yellow)
    const bpMid = waveBpCanvas.height / 2;
    let targetBpY = bpMid;
    if (ecgActive && monitorPulse > 0) {
        // Slow smooth NIBP-like trend movement
        const cycleMs = 4000;
        bpPhase = (bpPhase + (dt / cycleMs)) % 1;
        const wave = 0.55 * Math.sin(2 * Math.PI * bpPhase) + 0.45 * Math.sin(4 * Math.PI * bpPhase - 0.8);
        targetBpY = bpMid + 7 - (wave * 11) + (Math.random() * 0.35 - 0.175);
    } else {
        bpPhase = 0;
        targetBpY = bpMid + (Math.random() * 2 - 1);
    }
    smoothBpY = (smoothBpY * 0.74) + (targetBpY * 0.26);
    drawTrace(waveBpCtx, waveBpCanvas, '#ffd27b', smoothBpY, lastYBp);
    lastYBp = smoothBpY;

    requestAnimationFrame(drawECG);
}

// Clock and Date Update
function updateClock() {
    const now = new Date();
    const timeStr = now.toLocaleTimeString();
    if (document.getElementById('overlay-time')) document.getElementById('overlay-time').innerText = timeStr;
    if (document.getElementById('overlay-date')) document.getElementById('overlay-date').innerText = now.toLocaleDateString();
    
    if (IS_MONITOR && document.getElementById('vitals-timestamp')) {
        document.getElementById('vitals-timestamp').innerText = timeStr;
    }

    if (IS_ETA && document.getElementById('eta-timestamp')) {
        document.getElementById('eta-timestamp').innerText = timeStr;
    }
}
setInterval(updateClock, 1000);
updateClock();

function setMonitorStatus(level, text) {
    if (!IS_MONITOR) return;
    const monitor = document.getElementById('vitals-app');
    const status = document.getElementById('vitals-status-msg');
    if (!monitor || !status) return;
    monitor.classList.remove('status-ok', 'status-watch', 'status-alert');
    monitor.classList.add(level);
    status.innerText = text;
}

function updateEtaCountdown() {
    if (!IS_ETA || etaArrivalTimestampMs === null || etaInitialMinutes === null) return;
    const now = Date.now();
    const elapsedMinutes = Math.floor((now - etaArrivalTimestampMs) / 60000);
    const remaining = Math.max(0, etaInitialMinutes - elapsedMinutes);
    const minutesEl = document.getElementById('eta-minutes');
    if (minutesEl) {
        minutesEl.innerText = `${remaining} MIN`;
    }
}

window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.type === 'show') {
        if (IS_MONITOR) {
            document.getElementById('vitals-app').style.display = data.state ? 'flex' : 'none';
        } else if (IS_ETA) {
            document.getElementById('eta-app').style.display = data.state ? 'flex' : 'none';
        } else {
            app.style.display = data.state ? 'flex' : 'none';
        }
    }

    if (data.type === 'showETA') {
        if (IS_ETA) {
            document.getElementById('eta-app').style.display = data.state ? 'flex' : 'none';
        }
    }

    if (data.type === 'updateETA') {
        if (!IS_ETA) return;
        document.getElementById('eta-patient-name').innerText = (data.name || 'UNIDENTIFIED').toUpperCase();
        document.getElementById('eta-type').innerText = (data.emergencyType || 'STANDARD').toUpperCase();
        const parsedMinutes = Number(data.minutes);
        if (Number.isFinite(parsedMinutes) && parsedMinutes >= 0) {
            etaInitialMinutes = Math.floor(parsedMinutes);
            etaArrivalTimestampMs = Date.now();
            updateEtaCountdown();
        } else {
            etaInitialMinutes = null;
            etaArrivalTimestampMs = null;
            document.getElementById('eta-minutes').innerText = '-- MIN';
        }
        document.getElementById('eta-status-msg').innerText = 'INCOMING EMERGENCY - CLEAR THE BAY';
        
        if (data.emergencyType && data.emergencyType.toLowerCase() === 'critical') {
            document.getElementById('eta-type').style.color = '#ff3b3b';
        } else {
            document.getElementById('eta-type').style.color = '#fff';
        }
    }

    if (data.type === 'updateDispatch') {
        if (!IS_ETA) return;
        const section = document.getElementById('eta-dispatch-section');
        latestDispatchCall = data.call || null;
        if (data.call && etaDispatchVisible) {
            section.style.display = 'block';
            document.getElementById('eta-dispatch-code').innerText = data.call.code || '10-52';
            document.getElementById('eta-dispatch-title').innerText = (data.call.title || 'MEDICAL ALERT').toUpperCase();
            document.getElementById('eta-dispatch-info').innerText = data.call.info || '';
            document.getElementById('eta-dispatch-location').innerText = (data.call.location || 'UNKNOWN').toUpperCase();
        } else {
            section.style.display = 'none';
        }
    }

    if (data.type === 'setDispatchVisibility') {
        if (!IS_ETA) return;
        etaDispatchVisible = data.visible === true;
        const section = document.getElementById('eta-dispatch-section');
        if (!section) return;

        if (etaDispatchVisible && latestDispatchCall) {
            section.style.display = 'block';
            document.getElementById('eta-dispatch-code').innerText = latestDispatchCall.code || '10-52';
            document.getElementById('eta-dispatch-title').innerText = (latestDispatchCall.title || 'MEDICAL ALERT').toUpperCase();
            document.getElementById('eta-dispatch-info').innerText = latestDispatchCall.info || '';
            document.getElementById('eta-dispatch-location').innerText = (latestDispatchCall.location || 'UNKNOWN').toUpperCase();
        } else {
            section.style.display = 'none';
        }
    }

    if (data.type === 'updateVitals') {
        if (!IS_MONITOR) return;
        const pulse = Number(data.pulse || 0);
        const o2 = Number(data.o2 || 0);

        monitorPulse = pulse;
        monitorSpo2 = o2;
        document.getElementById('pulse-val').innerText = String(pulse);
        document.getElementById('bp-val').innerText = data.bp || '0/0';
        document.getElementById('o2-val').innerText = String(o2);

        if (pulse > 0) {
            ecgActive = true;
            document.getElementById('vitals-app').classList.add('vitals-active');
            if (pulse < 40 || pulse > 130 || o2 < 90) {
                setMonitorStatus('status-alert', 'ALARM - CHECK PATIENT');
            } else if (pulse < 55 || pulse > 110 || o2 < 94) {
                setMonitorStatus('status-watch', 'MONITORING - WATCH CLOSELY');
            } else {
                setMonitorStatus('status-ok', 'MONITORING - STABLE');
            }
        } else {
            ecgActive = false;
            monitorPulse = 0;
            monitorSpo2 = 0;
            document.getElementById('vitals-app').classList.remove('vitals-active');
            setMonitorStatus('status-watch', 'PATIENT DETECTED - NO SIGNAL');
        }
    }

    if (data.type === 'setPatient') {
        if (data.patient) {
            const safeName = String(data.patient.name || 'Unknown Patient');
            const safeId = String(data.patient.id || 'N/A');
            if (IS_MONITOR) {
                document.getElementById('vitals-name').innerText = safeName.toUpperCase();
                document.getElementById('vitals-id').innerText = 'SID: ' + safeId;
                setMonitorStatus('status-watch', 'PATIENT CONNECTED');
            } else {
                patientName.innerText = safeName.toUpperCase();
                patientId.innerText = 'SID_' + safeId;
                clearDisplay();
            }
        } else {
            if (IS_MONITOR) {
                document.getElementById('vitals-name').innerText = 'NO PATIENT';
                document.getElementById('vitals-id').innerText = 'SID: N/A';
                document.getElementById('pulse-val').innerText = '0';
                document.getElementById('bp-val').innerText = '0/0';
                document.getElementById('o2-val').innerText = '0';
                ecgActive = false;
                monitorPulse = 0;
                monitorSpo2 = 0;
                document.getElementById('vitals-app').classList.remove('vitals-active');
                setMonitorStatus('status-watch', 'WAITING FOR PATIENT...');
            } else {
                patientName.innerText = 'NO PATIENT DETECTED';
                patientId.innerText = 'N/A';
                clearDisplay();
                boneResults.innerHTML = '<p class="status-text">Waiting for patient on scanning bed...</p>';
            }
        }
    }

    if (data.type === 'scanResults') {
        showResults(data.injuries);
    }

    if (data.type === 'dui_cursor') {
        if (data.show) {
            cursor.style.display = 'block';
            cursor.style.left = (data.u * 100) + '%';
            cursor.style.top = (data.v * 100) + '%';
        } else {
            cursor.style.display = 'none';
        }
    }
});

// Keep ETA countdown ticking every second (display changes once per minute).
setInterval(updateEtaCountdown, 1000);

// Bone Selection
document.querySelectorAll('.bone-btn').forEach(btn => {
    btn.addEventListener('click', () => {
        document.querySelectorAll('.bone-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        currentBone = btn.dataset.bone;
        
        // If we already have results for this bone, update the view
        if (lastResults) {
            updateXrayView(currentBone);
        }
    });
});

let lastResults = null;

function hasFractureForBone(bone, injuries) {
    if (!Array.isArray(injuries)) return false;
    return injuries.some((injury) => injury && injury.part === bone && injury.type === 'fracture');
}

// Scan Button
document.getElementById('scan-btn').addEventListener('click', () => {
    if (patientName.innerText === 'NO PATIENT DETECTED') {
        boneResults.innerHTML = '<p style="color: red;">ERROR: No patient in range.</p>';
        return;
    }

    triggerScan();
});

document.getElementById('print-btn').addEventListener('click', async () => {
    if (patientName.innerText === 'NO PATIENT DETECTED') {
        boneResults.innerHTML = '<p style="color: red;">ERROR: No patient in range.</p>';
        return;
    }

    if (!lastResults) {
        boneResults.innerHTML = '<p style="color: red;">ERROR: Run a scan before printing.</p>';
        return;
    }

    if (!hasFractureForBone(currentBone, lastResults)) {
        boneResults.innerHTML = '<p style="color: red;">ERROR: Printing is available only for fractured bones.</p>';
        return;
    }

    try {
        await fetch(`https://plt_xray/syncInteraction`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ type: 'printFracture', bone: currentBone })
        });
        boneResults.innerHTML = '<p class="status-text">Fracture print sent to clipboard printer.</p>';
    } catch (e) {
        boneResults.innerHTML = '<p style="color: red;">ERROR: Failed to print fracture clipboard.</p>';
    }
});

function triggerScan() {
    startScanning();
    
    // Notify client to fetch real data
    fetch(`https://plt_xray/syncInteraction`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ type: 'startScan' })
    });
}

function startScanning() {
    lastResults = null;
    clearDisplay();
    scanningBar.style.display = 'block';
    noDataMsg.innerText = 'SCANNING...';
    boneResults.innerHTML = '<p class="status-text">Initializing radiation sequence...<br>Scanning bone density...<br>Analyzing trauma patterns...</p>';
}

function clearDisplay() {
    xrayImage.style.display = 'none';
    scanningBar.style.display = 'none';
    medicalOverlay.style.display = 'none';
    noDataMsg.style.display = 'block';
    noDataMsg.innerText = 'NO SIGNAL';
}

function showResults(injuries) {
    lastResults = injuries;
    scanningBar.style.display = 'none';
    noDataMsg.style.display = 'none';
    medicalOverlay.style.display = 'block';
    
    updateXrayView(currentBone);
    
    // Build report
    let html = '<div style="margin-top: 5px;">';
    
    const parts = [
        { key: 'head', label: 'Cranium/Head' },
        { key: 'chest', label: 'Thorax/Chest' },
        { key: 'left_arm', label: 'L-Humerus' },
        { key: 'right_arm', label: 'R-Humerus' },
        { key: 'left_leg', label: 'L-Femur' },
        { key: 'right_leg', label: 'R-Femur' }
    ];

    parts.forEach(part => {
        const injury = injuries.find(i => i.part === part.key);
        let statusClass = 'color-clear';
        let statusText = 'HEALTHY';

        if (injury) {
            if (injury.type === 'fracture') {
                statusClass = 'color-fracture';
                statusText = 'BROKEN';
            } else if (injury.type === 'bullet') {
                statusClass = 'color-bullet';
                statusText = 'FOREIGN OBJECT';
            }
        }

        html += `
            <div class="data-row">
                <span class="data-label" style="font-size: 10px;">${part.label}:</span>
                <span class="${statusClass}" style="font-size: 10px;">${statusText}</span>
            </div>
        `;
    });

    html += '</div>';
    boneResults.innerHTML = html;
}

function updateXrayView(bone) {
    const images = XRAY_IMAGES[bone];
    if (images) {
        let isBroken = false;
        if (lastResults) {
            const injury = lastResults.find(i => i.part === bone);
            if (injury && injury.type === 'fracture') {
                isBroken = true;
            }
        }
        xrayImage.src = isBroken ? images.broken : images.healthy;
        xrayImage.style.display = 'block';
    }
}

// Close UI on Escape
window.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
        fetch(`https://plt_xray/closeUI`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({})
        });
    }
});
