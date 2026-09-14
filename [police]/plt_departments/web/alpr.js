window.addEventListener('message', function(event) {
    const item = event.data;

    if (item.action === "openALPR") {
        document.getElementById('alpr-container').classList.remove('hidden');
        if (item.speedUnit) window.pltSpeedUnit = item.speedUnit;
        if (item.speedLock) {
            document.getElementById('alpr-lock-speed').value = item.speedLock;
            document.getElementById('alpr-limit-display').innerText = item.speedLock.toString().padStart(3, '0');
        }
    } else if (item.action === "closeALPR") {
        document.getElementById('alpr-container').classList.add('hidden');
    } else if (item.action === "openAlprMove") {
        // This action is now handled by the F6 menu
    } else if (item.action === "setAlprSize") {
        window.setAlprSize(item.size);
    } else if (item.action === "updateALPR") {
        if (item.speedUnit) window.pltSpeedUnit = item.speedUnit;
        document.getElementById('alpr-my-speed').innerText = item.mySpeed.toString().padStart(3, '0');
        document.getElementById('alpr-target-speed').innerText = item.targetSpeed.toString().padStart(3, '0');
        document.getElementById('alpr-target-plate').innerText = item.targetPlate || window.T("unknown");

        const lockSpeed = parseInt(document.getElementById('alpr-lock-speed').value);
        const wrapper = document.getElementById('target-speed-wrapper');
        const lockIndicator = document.getElementById('indicator-lock');
        
        if (item.targetSpeed > lockSpeed) {
            wrapper.classList.add('speeding');
        } else {
            wrapper.classList.remove('speeding');
        }

        if (item.targetSpeed > lockSpeed || item.isLocked) {
            lockIndicator.classList.add('active');
        } else {
            lockIndicator.classList.remove('active');
        }
    } else if (item.action === "updateBoloScanner") {
        const boloScanner = document.getElementById('alpr-bolo-scanner');
        const plateEl = document.getElementById('alpr-mini-plate');
        const statusEl = document.getElementById('alpr-mini-status');
        const scanIndicator = document.getElementById('indicator-scan');

        plateEl.innerText = item.plate || "---";
        
        if (item.status === "SCANNING") {
            boloScanner.classList.remove('wanted');
            boloScanner.classList.add('scanning');
            statusEl.innerText = window.T("scanning_dots");
            if (scanIndicator) scanIndicator.classList.add('active');
        } else if (item.isBolo) {
            boloScanner.classList.remove('scanning');
            boloScanner.classList.add('wanted');
            statusEl.innerText = window.T("bolo_alert");
            if (scanIndicator) scanIndicator.classList.add('active');
        } else {
            boloScanner.classList.remove('scanning', 'wanted');
            statusEl.innerText = window.T("monitoring");
            if (scanIndicator) scanIndicator.classList.remove('active');
        }
    }
});

// --- Sizing Logic (Global) ---
window.setAlprSize = function(size) {
    const container = document.getElementById('alpr-container');
    if (!container) return;

    // Clear previous classes
    container.classList.remove('size-small', 'size-large');
    
    // Set scale variable directly for maximum reliability
    let scale = 1.0;
    if (size === 'small') {
        scale = 0.8;
        container.classList.add('size-small');
    } else if (size === 'large') {
        scale = 1.2;
        container.classList.add('size-large');
    }
    
    container.style.setProperty('--alpr-scale', scale);
    
    // If not manually dragged yet, keep it centered but apply scale
    if (!localStorage.getItem('alprX_v7')) {
        container.style.transform = `translate(-50%, 0) scale(${scale})`;
    } else {
        container.style.transform = `scale(${scale})`;
    }
    
    // Update button states
    const btns = document.querySelectorAll('.alpr-size-btn');
    btns.forEach(b => {
        b.classList.remove('active');
        if (b.getAttribute('data-size') === size) {
            b.classList.add('active');
        }
    });

    localStorage.setItem('alprSize', size);
};

// Main ALPR Logic Initialization
document.addEventListener('DOMContentLoaded', () => {
    const container = document.getElementById('alpr-container');
    if (!container) return;

    // --- Dragging Logic ---
    let isDragging = false;
    let initialX, initialY;
    
    // Position is saved as absolute px values from the left/top of screen
    let savedX = localStorage.getItem('alprX_v7');
    let savedY = localStorage.getItem('alprY_v7');

    if (savedX !== null && savedY !== null) {
        container.style.left = savedX + 'px';
        container.style.top = savedY + 'px';
        container.style.bottom = 'auto';
        // When absolutely positioned, we don't need translate(-50%, 0)
        container.style.transform = `scale(var(--alpr-scale))`;
    }

    container.addEventListener('mousedown', (e) => {
        const officerMenu = document.getElementById('officer-menu-container');
        const isOfficerMenuOpen = officerMenu && (officerMenu.classList.contains('visible') || (officerMenu.style.display && officerMenu.style.display !== 'none'));
        
        if (!isOfficerMenuOpen) return;
        // Don't drag if clicking input or certain interactive sections
        if (e.target.tagName === 'INPUT' || e.target.closest('.speed-lock-input') || e.target.closest('.plate-block')) return;

        isDragging = true;
        
        // Get current position correctly accounting for transforms
        const rect = container.getBoundingClientRect();
        initialX = e.clientX - rect.left;
        initialY = e.clientY - rect.top;
        
        container.style.transition = 'none';
        container.classList.add('is-dragging');
    });

    document.addEventListener('mousemove', (e) => {
        if (!isDragging) return;
        
        e.preventDefault();
        
        let x = e.clientX - initialX;
        let y = e.clientY - initialY;

        container.style.left = x + 'px';
        container.style.top = y + 'px';
        container.style.bottom = 'auto';
        container.style.transform = `scale(var(--alpr-scale))`;
    });

    document.addEventListener('mouseup', () => {
        if (!isDragging) return;
        isDragging = false;
        container.classList.remove('is-dragging');
        
        localStorage.setItem('alprX_v7', parseInt(container.style.left));
        localStorage.setItem('alprY_v7', parseInt(container.style.top));
    });

    // Apply saved size on load
    const savedSize = localStorage.getItem('alprSize');
    if (savedSize) window.setAlprSize(savedSize);

    // Speed lock listener
    const lockInput = document.getElementById('alpr-lock-speed');
    if (lockInput) {
        lockInput.addEventListener('change', function() {
            setSpeedLock(this.value);
        });
    }
});

function setSpeedLock(val) {
    const limitDisplay = document.getElementById('alpr-limit-display');
    if (limitDisplay) limitDisplay.innerText = val.toString().padStart(3, '0');
    fetch(`https://${GetParentResourceName()}/setSpeedLock`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ speed: val })
    });
}
