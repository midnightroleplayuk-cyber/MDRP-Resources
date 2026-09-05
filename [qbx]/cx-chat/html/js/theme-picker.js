const THEME_SAVE_KEY = 'cx_chat_theme_v1';

const THEMES = [
    { id: 'cx-hud',    name: 'CX-HUD',    bg: '#06090f', hi: '#7ee8ca' },
    { id: 'dracula',   name: 'Dracula',   bg: '#1e1e2e', hi: '#bd93f9' },
    { id: 's4',        name: 'S4',        bg: '#0a0c10', hi: '#0ea5e9' },
    { id: 'midnight',  name: 'Midnight',  bg: '#0f111a', hi: '#6366f1' },
    { id: 'cyberpunk', name: 'Cyberpunk', bg: '#08080c', hi: '#00f0ff' },
    { id: 'retrowave', name: 'Retrowave', bg: '#0f0514', hi: '#22d3ee' },
    { id: 'tokyo',     name: 'Tokyo',     bg: '#0f0f14', hi: '#f472b6' },
    { id: 'amethyst',  name: 'Amethyst',  bg: '#0c0a12', hi: '#a855f7' },
    { id: 'quartz',    name: 'Quartz',    bg: '#140f19', hi: '#d946ef' },
    { id: 'vapor',     name: 'Vapor',     bg: '#0a0a0f', hi: '#fb7185' },
    { id: 'crimson',   name: 'Crimson',   bg: '#050505', hi: '#dc2626' },
    { id: 'emerald',   name: 'Emerald',   bg: '#0a140f', hi: '#10b981' },
    { id: 'zen',       name: 'Zen',       bg: '#080a08', hi: '#84cc16' },
    { id: 'sapphire',  name: 'Sapphire',  bg: '#05080f', hi: '#2563eb' },
    { id: 'oled',      name: 'OLED',      bg: '#000000', hi: '#0ea5e9' },
    { id: 'arctic',    name: 'Arctic',    bg: '#0a0f19', hi: '#f0f9ff' },
    { id: 'luxury',    name: 'Luxury',    bg: '#0c0c0c', hi: '#eab308' },
    { id: 'light',     name: 'Light',     bg: '#f8f9fa', hi: '#4f46e5' },
];

let currentThemeId  = null;
let selectedThemeId = null;

const picker   = document.getElementById('theme-picker');
const grid     = document.getElementById('tp-grid');
const applyBtn = document.getElementById('tp-apply');

function buildGrid() {
    grid.innerHTML = '';

    THEMES.forEach(theme => {
        const swatch = document.createElement('div');
        swatch.className        = 'tp-swatch';
        swatch.dataset.id       = theme.id;
        swatch.style.background = theme.bg;

        if (theme.id === selectedThemeId) swatch.classList.add('active');

        swatch.innerHTML = `
            <div class="tp-swatch-dot" style="background:${theme.hi};border-color:${theme.hi}44;"></div>
            <div class="tp-swatch-name" style="color:rgba(255,255,255,${theme.id === 'light' ? '0.6' : '0.85'})">${theme.name}</div>
            <div class="tp-swatch-bar" style="background:${theme.hi};"></div>
        `;

        swatch.addEventListener('click', () => {
            selectedThemeId = theme.id;
            applyTheme(theme.id, null);
            grid.querySelectorAll('.tp-swatch').forEach(s => s.classList.remove('active'));
            swatch.classList.add('active');
        });

        grid.appendChild(swatch);
    });
}

function openPicker() {
    selectedThemeId = currentThemeId;
    buildGrid();
    picker.classList.add('open');
    document.getElementById('msg-wrap').classList.add('show');
}

function closePicker(keepTheme) {
    if (!keepTheme) {
        applyTheme(currentThemeId, null);
    }
    picker.classList.remove('open');
    nui('closeChat');
}

document.getElementById('btn-theme-picker').addEventListener('click', openPicker);
document.getElementById('tp-close').addEventListener('click', () => closePicker(false));
document.getElementById('tp-backdrop').addEventListener('click', () => closePicker(false));

applyBtn.addEventListener('click', () => {
    if (!selectedThemeId) { closePicker(false); return; }

    currentThemeId = selectedThemeId;

    try { localStorage.setItem(THEME_SAVE_KEY, selectedThemeId); } catch (_) {}

    applyTheme(selectedThemeId, null);
    nui('setTheme', { theme: selectedThemeId });

    closePicker(true);
});

window.addEventListener('cx:themeReady', e => {
    const saved = (() => { try { return localStorage.getItem(THEME_SAVE_KEY); } catch(_) { return null; } })();
    currentThemeId  = saved || e.detail || 'cx-hud';
    selectedThemeId = currentThemeId;
});
