// Vintage Boss Menu Logic (System 7 Inspired)

window.vintageApps = {
    dept_manager: { id: 'dept', title: window.T('dept_roster') },
    member_db: { id: 'members', title: window.T('personnel_records') },
    finances: { id: 'finances', title: window.T('dept_finances') },
    safari: { id: 'safari', title: window.T('netscape_navigator') }
};

window.openVintageApp = function(appId) {
    const config = window.vintageApps[appId];
    if (!config) return;

    const win = document.getElementById(`vintage-window-${config.id}`);
    if (win) {
        win.classList.remove('hidden');
        win.style.zIndex = 1000;
        
        // Render content into the correct container (automatically detected by theme variable)
        if (appId === 'dept_manager') {
            window.renderDepartmentMembers(true);
        } else if (appId === 'member_db') {
            window.renderMembersApp('main', true);
        } else if (appId === 'finances') {
            window.renderFinancesApp('main', true);
        } else if (appId === 'safari') {
            window.renderSafariApp('intranet', 'dashboard');
        }
    }
};

window.closeVintageApp = function(appId) {
    const win = document.getElementById(`vintage-window-${appId}`);
    if (win) win.classList.add('hidden');
};

// Netscape Navigation Logic
document.addEventListener('click', (e) => {
    if (!e.target.closest('.safari-nav')) return;
    
    const action = e.target.innerText.toLowerCase();
    if (action === 'home') {
        window.renderSafariApp('intranet', 'dashboard');
    } else if (action === 'reload') {
        // Just re-render current page
        const url = document.querySelector('#vintage-window-safari .safari-url').innerText;
        const parts = url.split('/');
        const page = parts[1] || 'intranet';
        const subPage = parts[2] || 'dashboard';
        window.renderSafariApp(page, subPage);
    }
});

// Draggable Windows for Vintage UI
window.setupVintageDraggable = function(id) {
    const win = document.getElementById(`vintage-window-${id}`);
    if (!win) return;
    const header = win.querySelector('.vintage-win-header');
    if (!header) return;
    let isDragging = false;
    let startMouseX, startMouseY, startWinX, startWinY;

    win.addEventListener('mousedown', () => {
        win.style.zIndex = ++window.highestZIndex;
    });

    header.addEventListener('mousedown', (e) => {
        if (e.target.classList.contains('vintage-win-close')) return;
        isDragging = true;
        startMouseX = e.clientX;
        startMouseY = e.clientY;
        startWinX = win.offsetLeft;
        startWinY = win.offsetTop;
        
        // Prevent text selection during drag
        e.preventDefault();
    });

    document.addEventListener('mousemove', (e) => {
        if (!isDragging) return;
        
        const desktop = document.querySelector('.vintage-desktop');
        if (!desktop) return;

        const scale = window.resolutionScale || 1.0;
        
        // Calculate movement delta adjusted for resolution scale
        let dx = (e.clientX - startMouseX) / scale;
        let dy = (e.clientY - startMouseY) / scale;

        let newX = startWinX + dx;
        let newY = startWinY + dy;

        // Bounds checking (using unscaled units)
        const desktopWidth = desktop.offsetWidth;
        const desktopHeight = desktop.offsetHeight;
        const winWidth = win.offsetWidth;
        const winHeight = win.offsetHeight;

        newX = Math.max(0, Math.min(newX, desktopWidth - winWidth));
        newY = Math.max(24, Math.min(newY, desktopHeight - winHeight)); // 24 is the topbar height

        win.style.left = newX + 'px';
        win.style.top = newY + 'px';
    });

    document.addEventListener('mouseup', () => {
        isDragging = false;
    });
};

// Initialize draggables
document.addEventListener('DOMContentLoaded', () => {
    ['dept', 'members', 'finances', 'safari'].forEach(window.setupVintageDraggable);
});

// Also try to initialize immediately in case DOMContentLoaded already fired
setTimeout(() => {
    ['dept', 'members', 'finances', 'safari'].forEach(window.setupVintageDraggable);
}, 500);

// Update Vintage Clock
function updateVintageClock() {
    const now = new Date();
    const clock = document.getElementById('vintage-clock');
    if (clock) {
        clock.textContent = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    }
}
setInterval(updateVintageClock, 1000);
updateVintageClock();

