// Windows 98 Forensic Ballistics Analyzer Logic
console.log("Forensic Evidence Script Loaded");

window.openForensicPC = function() {
    console.log("NUI: Opening Forensic PC");
    const container = document.getElementById('forensic-pc-container');
    if (container) {
        container.style.setProperty('display', 'flex', 'important');
        container.classList.remove('hidden');
        window.showPCSelection(); // Always show selection screen first
    }
};

window.closeForensicPC = function() {
    const container = document.getElementById('forensic-pc-container');
    if (container) {
        container.style.setProperty('display', 'none', 'important');
        container.classList.add('hidden');
    }
    fetch(`https://${GetParentResourceName()}/closeForensicPC`, {
        method: 'POST',
        body: JSON.stringify({})
    });
};

window.showPCSelection = function() {
    console.log("NUI: Showing PC Selection Screen");
    const selectionScreen = document.getElementById('pc-selection-screen');
    const analysisScreen = document.getElementById('pc-analysis-screen');
    
    if (selectionScreen) selectionScreen.style.display = 'flex';
    if (analysisScreen) analysisScreen.style.display = 'none';
    
    fetch(`https://${GetParentResourceName()}/getAvailableEvidence`, {
        method: 'POST',
        body: JSON.stringify({})
    })
    .then(res => res.json())
    .then(data => {
        const list = document.getElementById('pc-evidence-list');
        if (!list) return;
        list.innerHTML = '';
        
        if (!data || data.length === 0) {
            list.innerHTML = '<div style="color:#808080; padding:20px; font-style:italic; width: 100%; text-align: center;">' + window.T("evidence_no_samples") + '</div>';
            return;
        }
        
        data.forEach((evidence, index) => {
            const item = document.createElement('div');
            item.className = 'win98-file-item';
            const displaySerial = (evidence.serial && evidence.serial !== "UNKNOWN" && evidence.serial !== "Unknown") ? evidence.serial.slice(-4) : Math.floor(Math.random() * 9000 + 1000);
            item.innerHTML = `
                <i class="fas fa-file-alt"></i>
                <span title="Sample_${displaySerial}">Samp_${displaySerial}</span>
            `;
            item.onclick = () => window.startAnalysisFromSelection(evidence);
            list.appendChild(item);
        });
    })
    .catch(err => {
        console.error("Error fetching evidence:", err);
    });
};

window.startAnalysisFromSelection = function(evidence) {
    console.log("NUI: Starting analysis for sample", evidence);
    const selectionScreen = document.getElementById('pc-selection-screen');
    const analysisScreen = document.getElementById('pc-analysis-screen');
    
    if (selectionScreen) selectionScreen.style.display = 'none';
    if (analysisScreen) analysisScreen.style.display = 'flex';
    
    resetPC();
    window.currentEvidence = evidence; // Store selected evidence
};

window.addEventListener('message', (event) => {
    if (event.data.action === 'openForensicPC') {
        window.openForensicPC();
    } else if (event.data.action === 'viewForensicReport') {
        window.viewForensicReport(event.data.report);
    }
});

function resetPC() {
    document.getElementById('pc-status').innerText = window.T("evidence_ready");
    document.getElementById('pc-object-type').innerText = window.T("evidence_none_detected");
    document.getElementById('pc-caliber').innerText = "--------";
    document.getElementById('pc-serial-result').innerText = "--------";
    document.getElementById('pc-timestamp').innerText = "--------";
    document.getElementById('pc-confidence').innerText = "--%";
    document.getElementById('pc-laser').classList.add('hidden');
    document.getElementById('pc-progress-box').classList.remove('show');
    document.getElementById('pc-progress-fill').style.width = "0%";
    document.getElementById('pc-start-btn').classList.remove('disabled');
    document.getElementById('pc-print-btn').classList.add('disabled');
    document.getElementById('pc-bottom-status').innerText = window.T("evidence_system_ready");
}

const weaponCalibers = {
    'WEAPON_PISTOL': '9x19mm Parabellum',
    'WEAPON_COMBATPISTOL': '9x19mm Parabellum',
    'WEAPON_APPISTOL': '9x19mm Parabellum',
    'WEAPON_PISTOL50': '.50 Action Express',
    'WEAPON_REVOLVER': '.44 Magnum',
    'WEAPON_SMG': '9x19mm Parabellum',
    'WEAPON_MICROSMG': '9x19mm Parabellum',
    'WEAPON_ASSAULTSMG': '5.7x28mm',
    'WEAPON_CARBINERIFLE': '5.56x45mm NATO',
    'WEAPON_ASSAULTRIFLE': '7.62x39mm',
    'WEAPON_ADVANCEDRIFLE': '5.56x45mm NATO',
    'WEAPON_SNIPERRIFLE': '.308 Winchester',
    'WEAPON_HEAVYSNIPER': '.50 BMG',
    'WEAPON_PUMPSHOTGUN': '12-Gauge',
    'WEAPON_SAWNOFFSHOTGUN': '12-Gauge',
};

window.startForensicScan = function() {
    const evidence = window.currentEvidence;
    if (!evidence) {
        document.getElementById('pc-status').innerText = window.T("evidence_error");
        document.getElementById('pc-bottom-status').innerText = window.T("evidence_no_sample_selected");
        return;
    }

    // Start animation
    document.getElementById('pc-status').innerText = window.T("evidence_scanning");
    document.getElementById('pc-bottom-status').innerText = window.T("evidence_analyzing_patterns");
    document.getElementById('pc-laser').classList.remove('hidden');
    document.getElementById('pc-progress-box').classList.add('show');
    document.getElementById('pc-start-btn').classList.add('disabled');

    let progress = 0;
    const interval = setInterval(() => {
        progress += Math.random() * 5;
        if (progress >= 100) {
            progress = 100;
            clearInterval(interval);
            finishScan(evidence);
        }
        document.getElementById('pc-progress-fill').style.width = progress + "%";
    }, 200);
};

function finishScan(evidence) {
    document.getElementById('pc-status').innerText = window.T("evidence_complete");
    document.getElementById('pc-object-type').innerText = evidence.type || window.T("evidence_bullet_casing");
    
    // Guess caliber based on weapon name or hash
    const weaponName = (evidence.weapon || "Unknown").toUpperCase();
    let caliber = "9mm / .38 Special"; // Default fallback
    for (const [key, val] of Object.entries(weaponCalibers)) {
        if (weaponName.includes(key) || weaponName.includes(key.replace('WEAPON_', ''))) {
            caliber = val;
            break;
        }
    }
    
    document.getElementById('pc-caliber').innerText = caliber;
    document.getElementById('pc-serial-result').innerText = (evidence.serial && evidence.serial !== "UNKNOWN" && evidence.serial !== "Unknown") ? evidence.serial : "W-882-X99";
    document.getElementById('pc-timestamp').innerText = evidence.date || "Unknown Date";
    document.getElementById('pc-confidence').innerText = (Math.floor(Math.random() * 5) + 95) + ".82%"; // 95-99% confidence
    
    document.getElementById('pc-laser').classList.add('hidden');
    document.getElementById('pc-bottom-status').innerText = window.T("evidence_matching_verified");
    document.getElementById('pc-print-btn').classList.remove('disabled');
}

window.printEvidenceReport = function() {
    const reportData = {
        serial: document.getElementById('pc-serial-result').innerText,
        weapon: window.currentEvidence ? window.currentEvidence.weapon : "Unknown",
        caliber: document.getElementById('pc-caliber').innerText,
        date: document.getElementById('pc-timestamp').innerText
    };

    fetch(`https://${GetParentResourceName()}/printEvidenceReport`, {
        method: 'POST',
        body: JSON.stringify(reportData)
    });
    window.closeForensicPC();
};

window.viewForensicReport = function(data) {
    if (!data) return;
    
    document.getElementById('report-id').innerText = data.reportId || "N/A";
    document.getElementById('report-date').innerText = data.date || "N/A";
    document.getElementById('report-officer').innerText = (data.officer || "N/A").toUpperCase();
    document.getElementById('report-caliber').innerText = data.caliber || "N/A";
    document.getElementById('report-weapon').innerText = (data.weapon || "N/A").toUpperCase();
    document.getElementById('report-serial').innerText = data.serial || "N/A";
    
    const container = document.getElementById('forensic-report-container');
    if (container) {
        container.style.display = 'flex';
        container.classList.remove('hidden');
    }
};

window.closeForensicReport = function() {
    const container = document.getElementById('forensic-report-container');
    if (container) {
        container.style.display = 'none';
        container.classList.add('hidden');
    }
    
    fetch(`https://${GetParentResourceName()}/closeForensicReport`, {
        method: 'POST',
        body: JSON.stringify({})
    });
};

// Global ESC listener for Forensic PC and Report
window.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        // If report is open, close it
        const report = document.getElementById('forensic-report-container');
        if (report && !report.classList.contains('hidden')) {
            window.closeForensicReport();
            return;
        }

        // If PC is open, close it
        const pc = document.getElementById('forensic-pc-container');
        if (pc && !pc.classList.contains('hidden')) {
            window.closeForensicPC();
            return;
        }
    }
});
