/* ===========================================================================
   BS PROP PLACER — script.js  (vanilla JS, no framework)
   Talks to client.lua via NUI messages (in) and fetch callbacks (out).
   =========================================================================== */

const state = {
    resource: 'bs-propplacer',
    props: [],
    categories: [],
    activeCat: 'All',
    search: '',
};

const el = {
    app:    document.getElementById('app'),
    grid:   document.getElementById('grid'),
    tabs:   document.getElementById('tabs'),
    search: document.getElementById('search'),
    count:  document.getElementById('count'),
    close:  document.getElementById('close'),
};

const PLACEHOLDER = 'img/_placeholder.svg';

/* ---------- talk back to Lua ---------- */
async function post(name, data = {}) {
    try {
        await fetch(`https://${state.resource}/${name}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify(data),
        });
    } catch (e) {
        /* running outside FiveM (dev preview) — ignore */
    }
}

/* ---------- open / close ---------- */
function openUI(payload) {
    state.resource   = payload.resource || state.resource;
    state.props      = payload.props || [];
    state.categories = payload.categories || [];
    state.activeCat  = 'All';
    state.search     = '';
    el.search.value  = '';
    renderTabs();
    renderGrid();
    el.app.classList.remove('hidden');
    el.search.focus();
}

function closeUI(notifyLua = true) {
    el.app.classList.add('hidden');
    if (notifyLua) post('close');
}

/* ---------- render ---------- */
function renderTabs() {
    const cats = ['All', ...state.categories];
    el.tabs.innerHTML = '';
    cats.forEach((cat) => {
        const b = document.createElement('button');
        b.className = 'tab' + (cat === state.activeCat ? ' active' : '');
        b.textContent = cat;
        b.onclick = () => {
            state.activeCat = cat;
            renderTabs();
            renderGrid();
        };
        el.tabs.appendChild(b);
    });
}

function filtered() {
    const q = state.search.trim().toLowerCase();
    return state.props.filter((p) => {
        const inCat = state.activeCat === 'All' || p.category === state.activeCat;
        const inSearch = !q
            || (p.label && p.label.toLowerCase().includes(q))
            || (p.category && p.category.toLowerCase().includes(q));
        return inCat && inSearch;
    });
}

function renderGrid() {
    const list = filtered();
    el.grid.innerHTML = '';
    el.count.textContent = `${list.length} sign${list.length === 1 ? '' : 's'}`;

    if (list.length === 0) {
        const e = document.createElement('div');
        e.className = 'empty';
        e.textContent = 'No signs match your search.';
        el.grid.appendChild(e);
        return;
    }

    list.forEach((p) => {
        const card = document.createElement('div');
        card.className = 'card';
        card.title = p.model;   // hover shows the archetype name (handy for spotting mismatches)

        if (p.closeRoad) {
            const badge = document.createElement('span');
            badge.className = 'badge';
            badge.textContent = 'Closes Road';
            card.appendChild(badge);
        }

        const thumb = document.createElement('div');
        thumb.className = 'card__thumb';
        const img = document.createElement('img');
        img.src = `img/${p.image}`;
        img.alt = p.label;
        img.loading = 'lazy';
        img.onerror = () => { img.onerror = null; img.src = PLACEHOLDER; }; // graceful fallback
        thumb.appendChild(img);

        const label = document.createElement('div');
        label.className = 'card__label';
        label.textContent = p.label;

        card.appendChild(thumb);
        card.appendChild(label);
        card.onclick = () => {
            closeUI(false);          // Lua unfocuses + starts placement
            post('select', { model: p.model });
        };
        el.grid.appendChild(card);
    });
}

/* ---------- events ---------- */
el.search.addEventListener('input', (e) => {
    state.search = e.target.value;
    renderGrid();
});
el.close.addEventListener('click', () => closeUI());
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && !el.app.classList.contains('hidden')) closeUI();
});

window.addEventListener('message', (event) => {
    const data = event.data || {};
    if (data.action === 'open')  openUI(data);
    if (data.action === 'close') closeUI(false);
});

/* ===========================================================================
   DEV-ONLY PREVIEW HARNESS
   FiveM's CEF injects GetParentResourceName(); a normal browser does not.
   When that's missing we self-drive an "open" message with sample data so the
   page can be designed/screenshotted outside the game. Never runs in FiveM.
   =========================================================================== */
if (typeof window.GetParentResourceName === 'undefined') {
    window.addEventListener('DOMContentLoaded', () => {
        window.postMessage({
            action: 'open',
            resource: 'bs-propplacer',
            categories: ['Warning', 'Prohibitory', 'Speed', 'Mandatory', 'Stop', 'Information'],
            props: [
                { model: 'a', label: 'Slippery Road',  category: 'Warning',     image: '01_slippery-road.png' },
                { model: 'b', label: 'Road Hump',      category: 'Warning',     image: '08_road-hump.png' },
                { model: 'c', label: 'Wild Animals',   category: 'Warning',     image: '13_wild-animals.png' },
                { model: 'd', label: 'Falling Rocks',  category: 'Warning',     image: '14_falling-rocks.png' },
                { model: 'e', label: 'No Entry',       category: 'Prohibitory', image: 'no-entry.png', closeRoad: true },
                { model: 'f', label: 'No Overtaking',  category: 'Prohibitory', image: '17_no-overtaking.png' },
                { model: 'g', label: 'Speed Limit 30', category: 'Speed',       image: '26_speed-30.png' },
                { model: 'h', label: 'Speed Limit 40', category: 'Speed',       image: '27_speed-40.png' },
                { model: 'i', label: 'Ahead Only',     category: 'Mandatory',   image: '33_ahead-only.png' },
                { model: 'j', label: 'Mini Roundabout',category: 'Mandatory',   image: '38_mini-roundabout.png' },
                { model: 'k', label: 'Stop',           category: 'Stop',        image: '42_stop.png', closeRoad: true },
                { model: 'l', label: 'Road Works',     category: 'Information', image: '50_road-works.png', closeRoad: true },
                { model: 'm', label: 'Warning (blank)', category: 'Warning', image: '_placeholder.svg' },
            ],
        }, '*');
    });
}
