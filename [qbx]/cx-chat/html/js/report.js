let selCat      = '';
let selCatLabel = '';
let selPlayer   = '';
let reportLocked = false;

const ui  = document.getElementById('report-ui');
const ta  = document.getElementById('rep-ta');
const len = document.getElementById('rep-len');

window.addEventListener('cx:initReport', e => {
    const detail = e.detail || {};
    const cats   = Array.isArray(detail) ? detail : (detail.cats || []);
    const locked = Array.isArray(detail) ? false  : (detail.locked === true);

    reportLocked = locked;

    const ddCat = document.getElementById('dd-cat');
    const list  = document.getElementById('dd-cat-list');
    list.innerHTML = '';

    if (locked) {
        selCat = 'player';
        selCatLabel = 'Player';
        document.getElementById('dd-cat-val').textContent = 'Player';
        ddCat.style.display = 'none';
        return;
    }

    ddCat.style.display = '';

    cats.forEach((cat, i) => {
        if (i === 0) {
            selCat      = cat.value;
            selCatLabel = cat.label;
            document.getElementById('dd-cat-val').textContent = cat.label;
        }

        const item = document.createElement('div');
        item.className    = 'dd-item';
        item.dataset.val  = cat.value;
        item.dataset.label = cat.label;
        item.textContent  = cat.label;

        item.addEventListener('click', () => {
            selCat      = cat.value;
            selCatLabel = cat.label;
            document.getElementById('dd-cat-val').textContent = cat.label;
            document.getElementById('dd-cat').classList.remove('open');

            const pdd = document.getElementById('dd-player');
            pdd.style.display = cat.value === 'player' ? 'block' : 'none';
            if (cat.value !== 'player') selPlayer = '';
        });

        list.appendChild(item);
    });
});

function openReportUI() {
    ui.classList.add('show');
    selPlayer = '';

    const pval = document.getElementById('dd-player-val');
    const plist = document.getElementById('dd-player-list');
    pval.textContent = 'Scanning for nearby players...';
    delete pval.dataset.selectedId;
    plist.innerHTML = '';

    nui('getNearbyPlayers', {}).then(data => {
        plist.innerHTML = '';

        if (data?.length) {
            pval.textContent = '-- Select a player --';

            data.forEach(p => {
                const item = document.createElement('div');
                item.className   = 'dd-item';
                item.dataset.val = p.id;
                item.textContent = `[ID: ${p.id}] ${p.name}`;

                item.addEventListener('click', () => {
                    selPlayer = String(p.id);
                    pval.textContent = item.textContent;
                    document.getElementById('dd-player').classList.remove('open');
                });

                plist.appendChild(item);
            });
        } else {
            pval.textContent = 'No players nearby.';
        }
    });

    document.getElementById('dd-player').style.display = (reportLocked || selCat === 'player') ? 'block' : 'none';

    setTimeout(() => ta.focus(), 80);
}

document.getElementById('btn-quick-report').addEventListener('click', openReportUI);

window.addEventListener('cx:openPlayerReport', e => {
    const { id, name } = e.detail || {};

    if (!reportLocked) {
        selCat = 'player';
        const playerItem = document.querySelector('#dd-cat-list [data-val="player"]');
        selCatLabel = playerItem?.dataset.label || 'Report a Player';
        document.getElementById('dd-cat-val').textContent = selCatLabel;
        document.getElementById('dd-cat').classList.remove('open');
    }

    ui.classList.add('show');
    selPlayer = String(id);

    const pval  = document.getElementById('dd-player-val');
    const plist = document.getElementById('dd-player-list');
    pval.textContent = `[ID: ${id}] ${name || 'Unknown'}`;
    pval.dataset.selectedId = String(id);
    plist.innerHTML = '';

    const item = document.createElement('div');
    item.className   = 'dd-item';
    item.dataset.val = String(id);
    item.textContent = `[ID: ${id}] ${name || 'Unknown'}`;
    item.addEventListener('click', () => {
        selPlayer = String(id);
        pval.textContent = item.textContent;
        document.getElementById('dd-player').classList.remove('open');
    });
    plist.appendChild(item);

    document.getElementById('dd-player').style.display = 'block';

    setTimeout(() => ta.focus(), 80);
});

function close() {
    ui.classList.remove('show');
    ta.value = '';
    len.textContent = '0 / 512';
    selPlayer = '';
    const pval = document.getElementById('dd-player-val');
    delete pval.dataset.selectedId;
}

document.getElementById('rep-close').addEventListener('click', close);

document.querySelector('#dd-cat .dd-header').addEventListener('click', () => {
    document.getElementById('dd-cat').classList.toggle('open');
    document.getElementById('dd-player').classList.remove('open');
});

document.querySelector('#dd-player .dd-header').addEventListener('click', () => {
    const list = document.getElementById('dd-player-list');
    if (list.children.length) {
        document.getElementById('dd-player').classList.toggle('open');
    }
    document.getElementById('dd-cat').classList.remove('open');
});

document.addEventListener('click', e => {
    if (!e.target.closest('#dd-cat'))    document.getElementById('dd-cat').classList.remove('open');
    if (!e.target.closest('#dd-player')) document.getElementById('dd-player').classList.remove('open');
    if (!e.target.closest('#report-ui') && !e.target.closest('#btn-quick-report')) {
        if (ui.classList.contains('show')) close();
    }
});

ta.addEventListener('input', () => {
    if (ta.value.length > 512) ta.value = ta.value.slice(0, 512);
    len.textContent = `${ta.value.length} / 512`;
});

document.getElementById('rep-send').addEventListener('click', () => {
    const msg = ta.value.trim();
    if (!msg) return;

    const pval     = document.getElementById('dd-player-val');
    const targetId = pval.dataset.selectedId || selPlayer;

    nui('submitReport', {
        message: msg,
        target:  selCat === 'player' ? targetId : null,
        type:    selCatLabel,
    });

    close();

    addMsg({
        message:  'Report submitted. Thank you.',
        color:    '#3dd68c',
        tag:      'SYSTEM',
        tagColor: '#3dd68c',
        isSystem: true,
    });
});
