const hud = document.getElementById('hud');
const controls = document.getElementById('controls');
const blood = document.getElementById('blood');

window.addEventListener('message', (ev) => {
    const { type, data } = ev.data || {};
    if (type === 'showHud') {
        blood.textContent = data.blood + 'ml';
        hud.classList.remove('hidden');
        controls.classList.toggle('hidden', !data.showInfo);
    } else if (type === 'hideHud') {
        hud.classList.add('hidden');
        controls.classList.add('hidden');
    } else if (type === 'updateHud') {
        blood.textContent = data.blood + 'ml';
    }
});
