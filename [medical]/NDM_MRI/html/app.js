const audio = document.getElementById('mri-audio');
const report = document.getElementById('report');
const RESOURCE = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'NDM_MRI';

const esc = (s) => String(s ?? '').replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
const fmt = (v, d = 0, unit = '') => (v === null || v === undefined || isNaN(v)) ? '—' : Number(v).toFixed(d) + unit;

function setText(id, v) { document.getElementById(id).textContent = v ?? '—'; }

function showReport(r, scanner) {
    setText('r-scanner', scanner || 'MRI');
    setText('r-patient', r.patient);
    setText('r-medic', r.medic);
    setText('r-time', r.time);
    setText('r-state', r.state);

    const v = r.vitals || {};
    const vitals = [
        ['Pulse', fmt(v.pulse, 0, ' bpm')],
        ['BP', v.bp || '—'],
        ['SpO2', fmt(v.spo2, 0, '%')],
        ['Temp', fmt(v.temp, 1, '°C')],
        ['Pain', fmt(v.pain, 1)],
        ['Blood', fmt(v.blood, 1, ' L')],
        ['Rhythm', v.rhythm || '—'],
    ];
    document.getElementById('r-vitals').innerHTML = vitals
        .map(([k, val]) => `<div class="vital"><span>${k}</span><b>${esc(val)}</b></div>`).join('');

    const regions = r.regions || [];
    document.getElementById('r-regions').innerHTML = regions.map((reg) => {
        const items = reg.findings.length
            ? reg.findings.map((f) => `<li class="${esc(f.level)}">${esc(f.text)}</li>`).join('')
            : '<li class="clear">No abnormality detected</li>';
        return `<div class="region sev${reg.severity}"><h4>${esc(reg.label)}</h4><ul>${items}</ul></div>`;
    }).join('');

    document.querySelectorAll('#r-figure [data-part]').forEach((el) => {
        const reg = regions.find((x) => x.part === el.dataset.part);
        el.setAttribute('class', 's' + (reg ? reg.severity : 0));
    });

    document.getElementById('r-impressions').innerHTML = (r.impressions || []).map((i) => `<li>${esc(i)}</li>`).join('');
    document.getElementById('r-conditions').textContent =
        (r.conditions && r.conditions.length) ? 'Active conditions: ' + r.conditions.join(', ') : '';

    report.classList.remove('hidden');
}

function closeReport() {
    report.classList.add('hidden');
    fetch(`https://${RESOURCE}/close`, { method: 'POST', body: '{}' });
}

document.getElementById('r-close').addEventListener('click', closeReport);
document.addEventListener('keyup', (e) => { if (e.key === 'Escape' && !report.classList.contains('hidden')) closeReport(); });

window.addEventListener('message', ({ data }) => {
    switch (data.action) {
        case 'soundStart':
            audio.src = data.file;
            audio.volume = data.volume || 0;
            audio.currentTime = 0;
            audio.play().catch(() => {});
            break;
        case 'soundVolume':
            audio.volume = Math.max(0, Math.min(1, data.volume));
            if (audio.paused && audio.src) audio.play().catch(() => {});
            break;
        case 'soundStop':
            audio.pause();
            audio.currentTime = 0;
            break;
        case 'showReport':
            showReport(data.report, data.scanner);
            break;
    }
});
