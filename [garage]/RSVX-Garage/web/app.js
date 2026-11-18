const resource = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'RSVX_Garage';
const garageEl = document.getElementById('garage');
const adminEl = document.getElementById('admin');

const state = {
    view: null,
    garage: null,
    selected: null,
    garages: [],
    draft: null,
    editing: null,
    status: '',
    error: false,
};

const MODS = [
    ['engine', 'Engine'],
    ['brakes', 'Brakes'],
    ['transmission', 'Transmission'],
    ['suspension', 'Suspension'],
    ['armour', 'Armour'],
];

const COMPONENTS = ['Head', 'Mask', 'Hair', 'Arms', 'Legs', 'Bag', 'Shoes', 'Accessory', 'Undershirt', 'Body armour', 'Decals', 'Top'];
const PROPS = [[0, 'Hat'], [1, 'Glasses'], [2, 'Ear'], [6, 'Watch'], [7, 'Bracelet']];

function post(name, data = {}) {
    return fetch(`https://${resource}/${name}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data),
    }).then((r) => r.json()).catch(() => null);
}

function esc(value) {
    return String(value ?? '').replace(/[&<>"']/g, (c) => (
        { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]
    ));
}

function coordText(c) {
    return `${c.x.toFixed(2)}, ${c.y.toFixed(2)}, ${c.z.toFixed(2)}  h ${Math.round(c.w)}`;
}

function setStatus(text, error = false) {
    state.status = text;
    state.error = error;
}

/* ---------- officer view ---------- */

function canTake() {
    const vehicle = state.garage.vehicles.find((v) => v.index === state.selected);
    return !!vehicle && !vehicle.locked;
}

function renderGarage() {
    const g = state.garage;
    const rows = g.vehicles.map((v) => `
        <li class="${v.locked ? 'locked' : ''} ${state.selected === v.index ? 'selected' : ''}"
            data-action="select" data-index="${v.index}">
            <span class="name">${esc(v.label)}</span>
            <span class="tag">${v.locked ? `Grade ${v.grade}+` : ''}</span>
            <span class="mono">${esc(v.model)}</span>
        </li>`).join('');

    garageEl.innerHTML = `
        <header>
            <div>
                <h1>${esc(g.label)}</h1>
                <p>${esc(g.job)} / ${esc(g.rank)}</p>
            </div>
            <button class="small" data-action="close">Close</button>
        </header>
        <ul class="rows">${rows || '<li class="empty">No vehicles are available to you here.</li>'}</ul>
        <footer>
            <button data-action="return">Return vehicle</button>
            <button class="primary" data-action="takeout" ${canTake() ? '' : 'disabled'}>Take out</button>
        </footer>`;
}

/* ---------- setup view ---------- */

function blankVehicle() {
    return {
        label: '', model: '', job: '', grade: 0, livery: '',
        extrasMode: 'default', extras: '',
        mods: { engine: -1, brakes: -1, transmission: -1, suspension: -1, armour: -1, turbo: false, windowTint: 0 },
        primary: '', secondary: '',
    };
}

function toDraftOutfit(outfit) {
    const components = Array.isArray(outfit?.components) ? outfit.components : [];
    const props = Array.isArray(outfit?.props) ? outfit.props : [];
    return {
        components: COMPONENTS.map((_, id) => {
            const c = components.find((x) => x.id === id);
            return { drawable: c?.drawable ?? 0, texture: c?.texture ?? 0 };
        }),
        props: PROPS.map(([id]) => {
            const c = props.find((x) => x.id === id);
            return { id, drawable: c?.drawable ?? -1, texture: c?.texture ?? 0 };
        }),
        hairColour: outfit?.hair?.colour ?? 0,
        hairHighlight: outfit?.hair?.highlight ?? 0,
    };
}

function fromDraftOutfit(o) {
    const n = (value, fallback) => (Number.isFinite(Number(value)) && value !== '' ? Number(value) : fallback);
    return {
        components: o.components.map((c, id) => ({ id, drawable: n(c.drawable, 0), texture: n(c.texture, 0) })),
        props: o.props.map((c) => ({ id: c.id, drawable: n(c.drawable, -1), texture: n(c.texture, 0) })),
        hair: { colour: n(o.hairColour, 0), highlight: n(o.hairHighlight, 0) },
    };
}

function toDraftVehicle(v) {
    const mods = v.mods && !Array.isArray(v.mods) ? v.mods : {};
    const draft = blankVehicle();
    draft.label = v.label || '';
    draft.model = v.model || '';
    draft.job = v.job || '';
    draft.grade = v.grade ?? 0;
    draft.livery = v.livery ?? '';
    draft.extrasMode = v.extras != null ? 'set' : 'default';
    draft.extras = Array.isArray(v.extras) ? v.extras.join(', ') : '';
    for (const [key] of MODS) draft.mods[key] = mods[key] ?? -1;
    draft.mods.turbo = !!mods.turbo;
    draft.mods.windowTint = mods.windowTint ?? 0;
    draft.primary = v.colour?.primary ?? '';
    draft.secondary = v.colour?.secondary ?? '';
    return draft;
}

function toDraft(g) {
    const jobs = g.jobs && !Array.isArray(g.jobs) ? g.jobs : {};
    return {
        id: g.id ?? null,
        label: g.label || '',
        platePrefix: g.platePrefix || '',
        pedModel: g.ped?.model || 's_m_y_cop_01',
        ped: g.ped ? { x: g.ped.x, y: g.ped.y, z: g.ped.z, w: g.ped.w } : null,
        outfitMode: g.ped?.outfit ? 'custom' : 'default',
        outfit: toDraftOutfit(g.ped?.outfit),
        jobs: Object.entries(jobs).map(([name, grade]) => ({ name, grade })),
        spawns: Array.isArray(g.spawns) ? g.spawns.map((s) => ({ ...s })) : [],
        vehicles: Array.isArray(g.vehicles) ? g.vehicles.map(toDraftVehicle) : [],
    };
}

function numberOrNull(value) {
    if (value === '' || value == null) return null;
    const n = Number(value);
    return Number.isFinite(n) ? n : null;
}

function fromDraft(d) {
    return {
        id: d.id,
        label: d.label,
        platePrefix: d.platePrefix,
        ped: d.ped ? {
            ...d.ped,
            model: d.pedModel,
            outfit: d.outfitMode === 'custom' ? fromDraftOutfit(d.outfit) : null,
        } : null,
        jobs: Object.fromEntries(
            d.jobs.filter((j) => j.name.trim()).map((j) => [j.name.trim(), Number(j.grade) || 0]),
        ),
        spawns: d.spawns,
        vehicles: d.vehicles.map((v) => {
            const primary = numberOrNull(v.primary);
            const secondary = numberOrNull(v.secondary);
            const mods = { turbo: !!v.mods.turbo, windowTint: Number(v.mods.windowTint) || 0 };
            for (const [key] of MODS) mods[key] = Number(v.mods[key]);
            return {
                label: v.label,
                model: v.model,
                job: v.job || null,
                grade: Number(v.grade) || 0,
                livery: numberOrNull(v.livery),
                extras: v.extrasMode === 'set'
                    ? v.extras.split(/[\s,]+/).filter(Boolean).map(Number).filter(Number.isInteger)
                    : null,
                mods,
                colour: primary != null && secondary != null ? { primary, secondary } : null,
            };
        }),
    };
}

function levelSelect(path, value, label) {
    const options = ['<option value="-1">Stock</option>'];
    for (let i = 0; i <= 4; i++) options.push(`<option value="${i}">Level ${i + 1}</option>`);
    return `<label>${label}<select data-path="${path}">${
        options.join('').replace(`value="${Number(value)}"`, `value="${Number(value)}" selected`)
    }</select></label>`;
}

function vehicleForm(v, i) {
    const p = `vehicles.${i}`;
    const jobs = state.draft.jobs.map((j) => j.name.trim()).filter(Boolean)
        .map((name) => `<option value="${esc(name)}" ${v.job === name ? 'selected' : ''}>${esc(name)} only</option>`)
        .join('');
    const tints = ['None', 'Pure black', 'Dark smoke', 'Light smoke', 'Stock', 'Limo', 'Green']
        .map((name, n) => `<option value="${n}" ${Number(v.mods.windowTint) === n ? 'selected' : ''}>${name}</option>`)
        .join('');

    return `
        <div class="vehicle-form">
            <div class="grid cols-4">
                <label>Name<input data-path="${p}.label" value="${esc(v.label)}" maxlength="40"></label>
                <label>Spawn model<input data-path="${p}.model" value="${esc(v.model)}" maxlength="40"></label>
                <label>Shown to<select data-path="${p}.job"><option value="">Every job on this garage</option>${jobs}</select></label>
                <label>Minimum grade<input type="number" min="0" data-path="${p}.grade" value="${esc(v.grade)}"></label>
            </div>
            <div class="grid cols-3">
                <label>Livery<input type="number" min="0" data-path="${p}.livery" value="${esc(v.livery)}" placeholder="model default"></label>
                <label>Extras
                    <select data-path="${p}.extrasMode" data-rerender>
                        <option value="default" ${v.extrasMode === 'default' ? 'selected' : ''}>Leave as model default</option>
                        <option value="set" ${v.extrasMode === 'set' ? 'selected' : ''}>Only switch on the ones listed</option>
                    </select>
                </label>
                <label>Extras switched on
                    <input data-path="${p}.extras" value="${esc(v.extras)}" placeholder="1, 2, 5" ${v.extrasMode === 'set' ? '' : 'disabled'}>
                </label>
            </div>
            <div class="grid cols-4">
                ${MODS.map(([key, label]) => levelSelect(`${p}.mods.${key}`, v.mods[key], label)).join('')}
                <label>Window tint<select data-path="${p}.mods.windowTint">${tints}</select></label>
                <label class="check"><input type="checkbox" data-path="${p}.mods.turbo" ${v.mods.turbo ? 'checked' : ''}> Turbo</label>
            </div>
            <div class="grid cols-4">
                <label>Primary colour<input type="number" min="0" max="255" data-path="${p}.primary" value="${esc(v.primary)}" placeholder="default"></label>
                <label>Secondary colour<input type="number" min="0" max="255" data-path="${p}.secondary" value="${esc(v.secondary)}" placeholder="default"></label>
            </div>
            <div class="actions">
                <button data-action="capture" data-index="${i}">Copy from the vehicle I'm sitting in</button>
                <button data-action="done-vehicle">Done</button>
            </div>
        </div>`;
}

function outfitBlock(d) {
    const cell = (label, path, c) => `
        <label>${label}
            <span class="pair">
                <input type="number" min="-1" data-path="${path}.drawable" value="${esc(c.drawable)}" title="Drawable">
                <input type="number" min="0" data-path="${path}.texture" value="${esc(c.texture)}" title="Texture">
            </span>
        </label>`;

    const custom = d.outfitMode === 'custom' ? `
        <div class="grid cols-4">
            ${COMPONENTS.map((name, i) => cell(name, `outfit.components.${i}`, d.outfit.components[i])).join('')}
            ${d.outfit.props.map((c, i) => cell(PROPS[i][1], `outfit.props.${i}`, c)).join('')}
            <label>Hair colour
                <span class="pair">
                    <input type="number" min="0" data-path="outfit.hairColour" value="${esc(d.outfit.hairColour)}" title="Colour">
                    <input type="number" min="0" data-path="outfit.hairHighlight" value="${esc(d.outfit.hairHighlight)}" title="Highlight">
                </span>
            </label>
        </div>
        <p class="hint">Each pair is drawable then texture. Hat, glasses, ear, watch and bracelet use -1 for none.</p>` : '';

    return `
        <div class="block">
            <h2>Attendant clothing</h2>
            <div class="line">
                <select data-path="outfitMode" data-rerender>
                    <option value="default" ${d.outfitMode === 'default' ? 'selected' : ''}>Model default</option>
                    <option value="custom" ${d.outfitMode === 'custom' ? 'selected' : ''}>Custom clothing</option>
                </select>
                <button class="small" data-action="capture-outfit">Copy what I'm wearing</button>
            </div>
            ${custom}
        </div>`;
}

function editor() {
    const d = state.draft;
    if (!d) return '<p>Pick a garage on the left, or create a new one.</p>';

    const jobs = d.jobs.map((j, i) => `
        <div class="line">
            <input data-path="jobs.${i}.name" value="${esc(j.name)}" placeholder="job name, e.g. police" maxlength="30">
            <input class="narrow" type="number" min="0" data-path="jobs.${i}.grade" value="${esc(j.grade)}" title="Minimum grade">
            <button class="small danger" data-action="remove-job" data-index="${i}">Remove</button>
        </div>`).join('');

    const spawns = d.spawns.map((s, i) => `
        <div class="line">
            <span class="grow mono">Bay ${i + 1}: ${coordText(s)}</span>
            <button class="small danger" data-action="remove-spawn" data-index="${i}">Remove</button>
        </div>`).join('');

    const vehicles = d.vehicles.map((v, i) => `
        <div class="line">
            <span class="grow"><strong>${esc(v.label) || 'Unnamed vehicle'}</strong> <span class="mono">${esc(v.model)}</span></span>
            <span class="mono">${v.job ? `${esc(v.job)} ` : ''}grade ${esc(Number(v.grade) || 0)}+</span>
            <button class="small" data-action="move-vehicle" data-index="${i}" data-step="-1" ${i === 0 ? 'disabled' : ''}>Up</button>
            <button class="small" data-action="move-vehicle" data-index="${i}" data-step="1" ${i === d.vehicles.length - 1 ? 'disabled' : ''}>Down</button>
            <button class="small" data-action="edit-vehicle" data-index="${i}">${state.editing === i ? 'Editing' : 'Edit'}</button>
            <button class="small danger" data-action="remove-vehicle" data-index="${i}">Remove</button>
        </div>`).join('');

    return `
        <div class="block">
            <h2>Garage</h2>
            <div class="grid cols-3">
                <label>Name<input data-path="label" value="${esc(d.label)}" maxlength="50"></label>
                <label>Plate prefix<input data-path="platePrefix" value="${esc(d.platePrefix)}" maxlength="4" placeholder="PD"></label>
                <label>Attendant ped model<input data-path="pedModel" value="${esc(d.pedModel)}" maxlength="40"></label>
            </div>
            <div class="line">
                <span class="grow mono">${d.ped ? `Attendant: ${coordText(d.ped)}` : 'Attendant position not set'}</span>
                <button class="small" data-action="set-ped">Use where I'm standing</button>
            </div>
        </div>

        ${outfitBlock(d)}

        <div class="block">
            <h2>Jobs and minimum grade</h2>
            ${jobs || '<p class="hint">No jobs yet. Nobody can use this garage.</p>'}
            <div class="actions"><button class="small" data-action="add-job">Add job</button></div>
        </div>

        <div class="block">
            <h2>Bays</h2>
            ${spawns || '<p class="hint">No bays yet. Park or stand where a vehicle should appear, then add it.</p>'}
            <div class="actions"><button class="small" data-action="add-spawn">Add bay where I am</button></div>
            <p class="hint">Unsaved changes are kept if you close this panel to move, then reopen it.</p>
        </div>

        <div class="block">
            <h2>Vehicles</h2>
            ${vehicles || '<p class="hint">No vehicles yet.</p>'}
            <div class="actions"><button class="small" data-action="add-vehicle">Add vehicle</button></div>
            ${state.editing != null && d.vehicles[state.editing] ? vehicleForm(d.vehicles[state.editing], state.editing) : ''}
        </div>`;
}

function renderAdmin() {
    const groups = {};
    for (const g of state.garages) {
        const jobs = g.jobs && !Array.isArray(g.jobs) ? Object.keys(g.jobs) : [];
        (groups[jobs.sort().join(' / ') || 'no job'] ??= []).push(g);
    }
    const list = Object.keys(groups).sort().map((name) => `
        <h2>${esc(name)}</h2>${groups[name].map((g) => `
        <button data-action="pick" data-id="${esc(g.id)}" class="${state.draft?.id === g.id ? 'selected' : ''}">${esc(g.label)}</button>`).join('')}`).join('');

    const scroll = adminEl.querySelector('main')?.scrollTop ?? 0;

    adminEl.innerHTML = `
        <header>
            <h1>Garage setup</h1>
            <button class="small" data-action="close">Close</button>
        </header>
        <aside>
            ${list}
            <button class="new ${state.draft && !state.draft.id ? 'selected' : ''}" data-action="new">New garage</button>
        </aside>
        <main>${editor()}</main>
        <footer>
            <span class="status ${state.error ? 'error' : ''}">${esc(state.status)}</span>
            ${state.draft?.id ? '<button class="danger" data-action="delete">Delete garage</button>' : ''}
            <button class="primary" data-action="save" ${state.draft ? '' : 'disabled'}>Save garage</button>
        </footer>`;

    adminEl.querySelector('main').scrollTop = scroll;
}

/* ---------- shared ---------- */

function render() {
    garageEl.hidden = state.view !== 'garage';
    adminEl.hidden = state.view !== 'admin';
    if (state.view === 'garage') renderGarage();
    if (state.view === 'admin') renderAdmin();
}

function close() {
    state.view = null;
    render();
    post('close');
}

const actions = {
    close,

    select(el) {
        const index = Number(el.dataset.index);
        if (state.selected === index) return;
        state.selected = index;
        post('preview', { garage: state.garage.id, index });
    },
    takeout() {
        if (!canTake()) return;
        state.view = null;
        post('takeOut', { garage: state.garage.id, index: state.selected });
    },
    return() {
        state.view = null;
        post('return', { garage: state.garage.id });
    },

    pick(el) {
        const garage = state.garages.find((g) => g.id === el.dataset.id);
        if (!garage) return;
        state.draft = toDraft(garage);
        state.editing = null;
        setStatus('');
    },
    new() {
        state.draft = toDraft({});
        state.editing = null;
        setStatus('');
    },
    async 'set-ped'() {
        const pos = await post('position');
        if (pos) state.draft.ped = pos;
    },
    async 'capture-outfit'() {
        const captured = await post('captureOutfit');
        if (!captured) return setStatus('Could not read your outfit.', true);
        state.draft.pedModel = captured.model;
        state.draft.outfit = toDraftOutfit(captured);
        state.draft.outfitMode = 'custom';
        setStatus(`Copied clothing from ${captured.model}.`);
    },
    'add-job'() { state.draft.jobs.push({ name: '', grade: 0 }); },
    'remove-job'(el) { state.draft.jobs.splice(Number(el.dataset.index), 1); },
    async 'add-spawn'() {
        const pos = await post('position');
        if (pos) state.draft.spawns.push(pos);
    },
    'remove-spawn'(el) { state.draft.spawns.splice(Number(el.dataset.index), 1); },
    'add-vehicle'() {
        state.draft.vehicles.push(blankVehicle());
        state.editing = state.draft.vehicles.length - 1;
    },
    'move-vehicle'(el) {
        const from = Number(el.dataset.index);
        const to = from + Number(el.dataset.step);
        const list = state.draft.vehicles;
        if (to < 0 || to >= list.length) return;
        [list[from], list[to]] = [list[to], list[from]];
        if (state.editing === from) state.editing = to;
        else if (state.editing === to) state.editing = from;
    },
    'edit-vehicle'(el) { state.editing = Number(el.dataset.index); },
    'done-vehicle'() { state.editing = null; },
    'remove-vehicle'(el) {
        state.draft.vehicles.splice(Number(el.dataset.index), 1);
        state.editing = null;
    },
    async capture(el) {
        const captured = await post('capture');
        if (!captured) return setStatus('Sit in the vehicle you want to copy first.', true);
        const current = state.draft.vehicles[Number(el.dataset.index)];
        const next = toDraftVehicle(captured);
        next.label = current.label;
        next.grade = current.grade;
        next.job = current.job;
        state.draft.vehicles[Number(el.dataset.index)] = next;
        setStatus(`Copied setup from ${captured.model}.`);
    },
    async save() {
        const result = await post('save', fromDraft(state.draft));
        if (!result?.ok) return setStatus(result?.error || 'Save failed.', true);
        state.garages = result.garages;
        state.draft = toDraft(result.garages.find((g) => g.id === result.id));
        state.editing = null;
        setStatus('Saved.');
    },
    async delete(el) {
        if (el.dataset.armed !== '1') {
            el.dataset.armed = '1';
            el.textContent = 'Click again to delete';
            return false;
        }
        const result = await post('delete', { id: state.draft.id });
        if (!result?.ok) return setStatus(result?.error || 'Delete failed.', true);
        state.garages = result.garages;
        state.draft = null;
        state.editing = null;
        setStatus('Garage deleted.');
    },
};

document.addEventListener('click', async (event) => {
    const el = event.target.closest('[data-action]');
    if (!el || el.disabled) return;
    const action = actions[el.dataset.action];
    if (!action) return;
    if ((await action(el)) !== false && state.view) render();
});

document.addEventListener('dblclick', (event) => {
    if (state.view === 'garage' && event.target.closest('[data-action="select"]') && canTake()) {
        actions.takeout();
        render();
    }
});

function writeDraft(target) {
    const path = target.dataset.path;
    if (!path || !state.draft) return;
    const keys = path.split('.');
    let node = state.draft;
    for (let i = 0; i < keys.length - 1; i++) node = node[keys[i]];
    node[keys[keys.length - 1]] = target.type === 'checkbox' ? target.checked : target.value;
}

document.addEventListener('input', (event) => writeDraft(event.target));
document.addEventListener('change', (event) => {
    writeDraft(event.target);
    if (event.target.dataset.rerender !== undefined) render();
});

document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && state.view) close();
});

window.addEventListener('message', ({ data }) => {
    if (data.action === 'garage') {
        state.view = 'garage';
        state.garage = data.garage;
        state.garage.vehicles = Array.isArray(data.garage.vehicles) ? data.garage.vehicles : [];
        state.selected = null;
    } else if (data.action === 'admin') {
        state.view = 'admin';
        state.garages = Array.isArray(data.garages) ? data.garages : [];
    } else if (data.action === 'close') {
        state.view = null;
    } else {
        return;
    }
    render();
});
