const $ = (id) => document.getElementById(id);
const app = $('app'), view = $('view'), tabsEl = $('tabs'), toastEl = $('toast');

let state = { mode: 'full', data: null, command: false, can: {}, tab: 'checkout', page: 1, filters: {}, lookup: '', stockFilter: 'attention' };
let signCtx = null;
let weaponImages = {};

const post = (name, body = {}) =>
    fetch(`https://${GetParentResourceName()}/${name}`, {
        method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body),
    }).then((r) => r.json());

function el(tag, cls, text) {
    const e = document.createElement(tag);
    if (cls) e.className = cls;
    if (text !== undefined) e.textContent = text;
    return e;
}

function imgEl(name) {
    const img = document.createElement('img');
    img.src = weaponImages[name] || '';
    img.alt = '';

    img.onerror = () => {
        const lower = img.src.replace(/[^/]+$/, (f) => f.toLowerCase());
        if (img.src !== lower) img.src = lower; else img.remove();
    };
    return img;
}

function weaponImg(name) {
    const box = el('div', 'w-img');
    box.append(imgEl(name));
    return box;
}

function toast(msg, ok = true) {
    toastEl.textContent = msg;
    toastEl.className = 'toast' + (ok ? '' : ' err');
    clearTimeout(toast.t);
    toast.t = setTimeout(() => toastEl.classList.add('hidden'), 3500);
}

let cancelAsk = null;
function ask(title, text, label = 'Confirm') {
    return new Promise((resolve) => {
        $('confirm-title').textContent = title;
        $('confirm-text').textContent = text;
        $('confirm-yes').textContent = label;
        $('confirm').classList.remove('hidden');
        const done = (v) => { $('confirm').classList.add('hidden'); cancelAsk = null; resolve(v); };
        cancelAsk = () => done(false);
        $('confirm-yes').onclick = () => done(true);
        $('confirm-no').onclick = () => done(false);
    });
}

async function refresh() {
    const d = await post('getData');
    if (d.denied) return close();
    state.data = d;
    render();
}

function tabsFor() {
    if (state.mode === 'admin') return [['armories', 'Armories'], ['weapons', 'Weapons'], ['ammotypes', 'Ammo Types']];
    const t = [];
    if (state.mode !== 'log') t.push(['checkout', 'Retrieve Weapon'], ['ammo', 'Ammo'], ['mine', 'My Weapons'], ['myhistory', 'My History']);
    if (state.command) t.push(['out', 'Signed Out'], ['history', 'History']);
    if (state.can.lookup) t.push(['lookup', 'Serial Lookup']);
    if (state.can.stock) t.push(['stock', 'Stock']);
    if (state.can.rules) t.push(['rules', 'Rank Access']);
    return t;
}

const ICONS = {
    checkout: '<path d="M3 8h13l2-2h3v6h-3l-1 2h-5l-1 5H7l1-5H3z"/>',
    ammo: '<path d="M9 21V10c0-3 1.5-5 3-7 1.5 2 3 4 3 7v11z"/><path d="M9 15h6"/>',
    mine: '<circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 4-6 8-6s8 2 8 6"/>',
    myhistory: '<path d="M4 5h16v14H4z"/><path d="M8 10h8M8 14h5"/>',
    out: '<path d="M4 6h16M4 12h16M4 18h10"/>',
    history: '<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>',
    lookup: '<circle cx="11" cy="11" r="6"/><path d="M16 16l5 5"/>',
    stock: '<path d="M3 8l9-5 9 5v9l-9 5-9-5z"/><path d="M3 8l9 5 9-5M12 13v9"/>',
    ammotypes: '<path d="M9 21V10c0-3 1.5-5 3-7 1.5 2 3 4 3 7v11z"/><path d="M9 15h6"/>',
    weapons: '<path d="M3 8h13l2-2h3v6h-3l-1 2h-5l-1 5H7l1-5H3z"/>',
    armories: '<path d="M3 21V9l9-6 9 6v12z"/><path d="M9 21v-7h6v7"/>',
    rules: '<path d="M12 3l8 3v6c0 5-3.5 8-8 9-4.5-1-8-4-8-9V6z"/><path d="M9 12l2 2 4-4"/>',
};
const SECTIONS = {
    checkout: ['Retrieve Weapon', 'Choose a weapon, then sign for it with your full name.'],
    ammo: ['Ammo', 'Take ammunition. Free, with no signature and nothing logged.'],
    mine: ['My Weapons', 'Weapons currently signed out to you.'],
    myhistory: ['My History', 'Everything you have signed out and returned.'],
    out: ['Signed Out', 'Every weapon currently out of the armory.'],
    history: ['History', 'Full sign-out and return log. Filter by officer, serial or date.'],
    lookup: ['Serial Lookup', 'Find a weapon by serial number and see who has held it.'],
    stock: ['Stock', 'Add weapons, send them for maintenance, retire them or restore lost ones.'],
    rules: ['Rank Access', 'Control which ranks can sign out each weapon.'],
    ammotypes: ['Ammo Types', 'Add, edit or remove the ammunition armories can hand out. Free and untracked.'],
    weapons: ['Weapons', 'Add, edit or remove the weapon types that can be issued, with serial prefix, stock and approval rules.'],
    armories: ['Armories', 'Add armories, choose ped or third-eye only, set clothing, position and what each one stores.'],
};

function render() {
    tabsEl.replaceChildren(...tabsFor().map(([key, label]) => {
        const t = el('div', 'tab' + (state.tab === key ? ' active' : ''));
        const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
        svg.setAttribute('viewBox', '0 0 24 24');
        svg.innerHTML = ICONS[key];
        t.append(svg, el('span', '', label));
        t.onclick = () => { state.tab = key; state.page = 1; render(); };
        return t;
    }));

    const name = state.data ? state.data.name : state.mode === 'admin' ? 'Admin' : 'Command';
    $('o-name').textContent = name;
    $('avatar').textContent = name.split(' ').map((p) => p[0]).slice(0, 2).join('').toUpperCase();
    $('o-role').textContent = state.mode === 'admin' ? 'Administrator' : state.command ? 'Command staff' : 'Officer';
    $('sec-title').textContent = SECTIONS[state.tab][0];
    $('sec-sub').textContent = SECTIONS[state.tab][1];

    view.replaceChildren();
    view.classList.toggle('grid', state.tab === 'checkout' || state.tab === 'ammo');
    ({
        checkout: renderCheckout, ammo: renderAmmo, mine: renderMine, myhistory: renderHistory, out: renderOut, history: renderHistory,
        lookup: renderLookup, stock: renderStock, rules: renderRules, armories: renderArmories, weapons: renderWeapons, ammotypes: renderAmmoTypes,
    })[state.tab]();
}

function tag(text, cls = '') { return el('span', 'tag ' + cls, text); }

function chips(w) {
    const c = el('div', 'chips');
    if (w.approval) c.append(tag('Needs approval', 'warn'));
    if (w.reason) c.append(tag('Reason required'));
    if (w.kit) c.append(tag('Includes ' + w.kit, 'kit'));
    return c;
}

const STATUS_LABEL = { in: 'IN ARMORY', out: 'SIGNED OUT', lost: 'LOST', maint: 'MAINTENANCE', retired: 'RETIRED' };
const statusBadge = (s) => el('span', 'badge st-' + s, STATUS_LABEL[s] || s.toUpperCase());

function logBadge(h) {
    if (!h.in_str) return el('span', 'badge st-out', 'OUT');
    const r = h.returned_by || '';
    if (/lost/i.test(r)) return el('span', 'badge st-lost', 'LOST');
    if (/^AUTO-RETURN/.test(r)) return el('span', 'badge st-auto', 'AUTO-RETURNED');
    return el('span', 'badge st-in', 'RETURNED');
}

function historyRow(h, withHolder = true) {
    const row = el('div', 'row');
    const body = el('div', 'w-body');
    const lines = [`Out: ${h.out_str}`, h.in_str ? `Returned: ${h.in_str}` : 'Not yet returned', `Held for: ${h.duration_str}`];
    if (h.returned_by && h.returned_by !== h.holder_name) lines.push(`Returned by: ${h.returned_by}`);
    const extra = [];
    if (h.reason) extra.push(`Reason: ${h.reason}`);
    if (h.kit) extra.push(`Issued with: ${h.kit}`);
    if (h.approved_by) extra.push(`Approved by: ${h.approved_by}`);
    body.append(
        el('div', 'w-name', `${h.label}  |  ${h.serial}`),
        el('div', 'w-meta', withHolder ? `${h.holder_name} (signed: ${h.signature || '-'})` : `Signed: ${h.signature || '-'}`),
        el('div', 'w-desc', lines.join('  •  ')),
    );
    if (extra.length) body.append(el('div', 'w-desc dim', extra.join('  •  ')));
    const side = el('div', 'w-side');
    side.append(logBadge(h));
    row.append(body, side);
    return row;
}

function pager(r) {
    const p = el('div', 'pager');
    const prev = el('button', 'btn', 'Previous'); prev.disabled = r.page <= 1;
    const next = el('button', 'btn', 'Next'); next.disabled = !r.more;
    prev.onclick = () => { state.page--; render(); };
    next.onclick = () => { state.page++; render(); };
    p.append(prev, next);
    return p;
}

function renderCheckout() {
    const { available } = state.data;
    if (!available.length) return view.append(el('div', 'empty', 'This armory has no weapons.'));
    available.forEach((w) => {
        const n = w.serials.length;
        const ok = w.allowed && n > 0;
        const card = el('div', 'card' + (ok ? '' : ' locked'));
        const top = el('div', 'card-top');
        top.append(el('div', 'w-name', w.label), el('span', 'pill' + (n <= 2 ? ' low' : ''), `${n} in stock`));
        const b = el('button', 'btn gold', !w.allowed ? `Requires grade ${w.minGrade}+` : n === 0 ? 'Out of stock' : 'Retrieve Weapon');
        b.disabled = !ok;
        b.onclick = () => openSign(w);
        card.append(weaponImg(w.name), top, el('div', 'w-desc', w.desc), chips(w), b);
        view.append(card);
    });
}

function renderAmmo() {
    const list = state.data.ammo;
    if (!list.length) return view.append(el('div', 'empty', 'This armory does not hand out ammo.'));
    list.forEach((a) => {
        const card = el('div', 'card');
        const top = el('div', 'card-top');
        top.append(el('div', 'w-name', a.label), el('span', 'pill', `x${a.amount}`));
        const b = el('button', 'btn gold', 'Take Ammo');
        const left = el('div', 'w-desc dim');
        const showLeft = () => {
            left.textContent = a.left === undefined || a.left === null ? '' : `${a.left} left this shift`;
            b.disabled = a.left === 0;
        };
        b.onclick = async () => {
            b.disabled = true;
            const r = await post('takeAmmo', { item: a.item });
            toast(r.msg, r.ok);
            if (r.ok && r.left !== undefined) a.left = r.left;
            showLeft();
        };
        showLeft();
        card.append(weaponImg(a.item), top, el('div', 'w-desc', a.desc), left, b);
        view.append(card);
    });
}

function renderMine() {
    const list = state.data.mine;
    if (!list.length) return view.append(el('div', 'empty', 'You have no weapons signed out.'));
    list.forEach((m) => {
        const row = el('div', 'row');
        const body = el('div', 'w-body');
        body.append(el('div', 'w-name', m.label), el('div', 'w-meta', `Serial ${m.serial}`), el('div', 'w-desc', `Signed out ${m.since}`));
        const side = el('div', 'w-side');
        const ret = el('button', 'btn gold', 'Return Weapon');
        ret.onclick = async () => {
            const r = await post('return', { serial: m.serial });
            toast(r.msg, r.ok);
            refresh();
        };
        const lost = el('button', 'btn red', 'Report Lost');
        lost.onclick = async () => {
            if (!await ask('Report weapon lost', `Report ${m.label} (${m.serial}) as lost or stolen? It is taken out of circulation, removed from your inventory and listed as lost for command staff.`, 'Report lost')) return;
            const r = await post('reportLost', { serial: m.serial });
            toast(r.msg, r.ok);
            refresh();
        };
        side.append(ret, lost);
        row.append(weaponImg(m.weapon), body, side);
        view.append(row);
    });
}

async function renderOut() {
    const r = await post('getOut');
    if (state.tab !== 'out') return;
    if (!r.rows.length) return view.append(el('div', 'empty', 'Nothing is signed out.'));
    r.rows.forEach((o) => {
        const row = el('div', 'row');
        const body = el('div', 'w-body');
        const who = el('div', 'w-meta', o.holder_name + '  ');
        who.append(tag(o.online ? 'Online' : 'Offline', o.online ? 'ok' : 'warn'));
        body.append(el('div', 'w-name', `${o.label}  |  ${o.serial}`), who, el('div', 'w-desc', `Out since ${o.since} (${o.elapsed})`));
        const side = el('div', 'w-side');
        const force = el('button', 'btn red', 'Force Return');
        force.onclick = async () => {
            if (!await ask('Force return', `Return ${o.label} (${o.serial}) to the armory? It is also taken out of ${o.holder_name}'s inventory.`, 'Force return')) return;
            const res = await post('forceReturn', { serial: o.serial });
            toast(res.msg, res.ok);
            render();
        };
        const lost = el('button', 'btn', 'Mark Lost');
        lost.onclick = async () => {
            if (!await ask('Mark lost', `Mark ${o.label} (${o.serial}) as lost? It leaves circulation until you restore it on the Stock tab.`, 'Mark lost')) return;
            const res = await post('markLost', { serial: o.serial });
            toast(res.msg, res.ok);
            render();
        };
        side.append(force, lost);
        row.append(body, side);
        view.append(row);
    });
}

function filterBar() {
    const bar = el('div', 'filters');
    const field = (key, ph, type = 'text') => {
        const i = document.createElement('input');
        i.type = type; i.placeholder = ph; i.title = ph; i.value = state.filters[key] || '';
        i.onkeydown = (e) => { if (e.key === 'Enter') apply(); };
        return i;
    };
    const officer = field('officer', 'Officer name'), serial = field('serial', 'Serial'),
        from = field('from', 'From date', 'date'), to = field('to', 'To date', 'date');
    const apply = () => {
        state.filters = { officer: officer.value, serial: serial.value, from: from.value, to: to.value };
        state.page = 1;
        render();
    };
    const go = el('button', 'btn gold', 'Filter'); go.onclick = apply;
    const clear = el('button', 'btn', 'Clear'); clear.onclick = () => { state.filters = {}; state.page = 1; render(); };
    bar.append(officer, serial, from, to, go, clear);
    return bar;
}

async function renderHistory() {
    const tab = state.tab, mine = tab === 'myhistory';
    if (!mine) view.append(filterBar());
    const r = await post('getHistory', { page: state.page, filters: mine ? { mine: true } : state.filters });
    if (state.tab !== tab) return;
    if (!r.rows.length) return view.append(el('div', 'empty', mine ? 'You have not signed anything out yet.' : 'No history matches.'));
    r.rows.forEach((h) => view.append(historyRow(h, !mine)));
    view.append(pager(r));
}

async function renderLookup() {
    const bar = el('div', 'filters');
    const input = document.createElement('input');
    input.type = 'text'; input.placeholder = 'Serial number, e.g. PD-K7M2Q9XA'; input.value = state.lookup;
    const go = el('button', 'btn gold', 'Search');
    const box = el('div', 'results');
    const run = async () => {
        state.lookup = input.value;
        box.replaceChildren();
        if (!state.lookup.trim()) return;
        const r = await post('lookup', { serial: state.lookup });
        if (state.tab !== 'lookup') return;
        if (!r.found) return box.append(el('div', 'empty', 'No weapon with that serial number.'));
        const w = r.weapon;
        const row = el('div', 'row');
        const body = el('div', 'w-body');
        body.append(el('div', 'w-name', `${w.label}  |  ${w.serial}`),
            el('div', 'w-desc', w.status === 'out' ? `With ${w.holder_name} since ${w.since}` : 'Not currently signed out'));
        const side = el('div', 'w-side');
        side.append(statusBadge(w.status));
        row.append(weaponImg(w.weapon), body, side);
        box.append(row, el('h3', 'grid-title', `History (${r.rows.length})`));
        if (!r.rows.length) box.append(el('div', 'empty', 'This weapon has never been signed out.'));
        r.rows.forEach((h) => box.append(historyRow(h)));
    };
    go.onclick = run;
    input.onkeydown = (e) => { if (e.key === 'Enter') run(); };
    bar.append(input, go);
    view.append(bar, box);
    if (state.lookup) run();
}

const NEXT = {
    in: [['maint', 'Send to maintenance'], ['retired', 'Retire']],
    maint: [['in', 'Return to service'], ['retired', 'Retire']],
    lost: [['in', 'Found - restore'], ['retired', 'Retire']],
    retired: [['in', 'Reinstate']],
};

async function renderStock() {
    const r = await post('getStock', { filter: state.stockFilter });
    if (state.tab !== 'stock') return;
    if (!r.summary) return view.append(el('div', 'empty', 'You do not have access to stock.'));

    const levels = [];
    r.summary.forEach((w) => {
        const row = el('div', 'row');
        const body = el('div', 'w-body');
        const c = el('div', 'chips');
        [['in', 'In'], ['out', 'Out'], ['maint', 'Maintenance'], ['lost', 'Lost'], ['retired', 'Retired']].forEach(([k, l]) => {
            if (w.counts[k]) c.append(tag(`${l} ${w.counts[k]}`, k === 'lost' ? 'bad' : k === 'maint' ? 'warn' : ''));
        });
        body.append(el('div', 'w-name', w.label), c);
        const side = el('div', 'w-side add');
        const qty = document.createElement('input');
        qty.type = 'number'; qty.min = 1; qty.max = 50; qty.value = 1; qty.title = 'Quantity';
        const add = el('button', 'btn gold', 'Add');
        add.onclick = async () => {
            const res = await post('addStock', { weapon: w.name, qty: Number(qty.value) });
            toast(res.msg, res.ok);
            render();
        };
        side.append(qty, add);
        row.append(weaponImg(w.name), body, side);
        levels.push(row);
    });

    const bar = el('div', 'filters');
    const sel = document.createElement('select');
    [['attention', 'Needs attention (maintenance / lost)'], ['in', 'In the armory'], ['retired', 'Retired']].forEach(([v, l]) => {
        const o = el('option', '', l); o.value = v; sel.append(o);
    });
    sel.value = state.stockFilter;
    sel.onchange = () => { state.stockFilter = sel.value; render(); };
    bar.append(sel);
    view.append(bar);

    if (!r.rows.length) view.append(el('div', 'empty', 'Nothing to show here.'));
    r.rows.forEach((x) => {
        const row = el('div', 'row');
        const body = el('div', 'w-body');
        body.append(el('div', 'w-name', `${x.label}  |  ${x.serial}`), statusBadge(x.status));
        const side = el('div', 'w-side');
        (NEXT[x.status] || []).forEach(([status, label]) => {
            const b = el('button', 'btn' + (status === 'retired' ? ' red' : ''), label);
            b.onclick = async () => {
                const res = await post('setStatus', { serial: x.serial, status });
                toast(res.msg, res.ok);
                render();
            };
            side.append(b);
        });
        row.append(body, side);
        view.append(row);
    });
    view.append(el('h3', 'grid-title', 'Stock levels and new serials'), ...levels);
}

async function renderRules() {
    const r = await post('getRules');
    if (state.tab !== 'rules') return;
    if (!r.weapons) return view.append(el('div', 'empty', 'You do not have access to rank settings.'));
    view.append(el('div', 'muted note', `Set the minimum rank per job that may sign out each weapon. "Default" means grade ${r.default}+. Changes save instantly.`));
    r.weapons.forEach((w) => {
        const row = el('div', 'row');
        const body = el('div', 'w-body');
        body.append(el('div', 'w-name', w.label));
        const grid = el('div', 'rule-grid');
        r.jobs.forEach((j) => {
            const field = el('label', 'rule-field');
            field.append(el('span', 'field-label', j.label));
            const sel = document.createElement('select');
            const def = el('option', '', `Default (${r.default}+)`);
            def.value = '';
            sel.append(def);
            j.grades.forEach((g) => {
                const o = el('option', '', `${g.level} - ${g.name}`);
                o.value = g.level;
                sel.append(o);
            });
            sel.value = w.rules[j.name] ?? '';
            sel.onchange = async () => {
                const res = await post('setRule', { weapon: w.name, job: j.name, grade: sel.value === '' ? null : Number(sel.value) });
                toast(res.msg, res.ok);
            };
            field.append(sel);
            grid.append(field);
        });
        body.append(grid);
        row.append(weaponImg(w.name), body);
        view.append(row);
    });
}

function newDraft() {
    return {
        id: null, label: '', mode: 'ped', coords: { x: '', y: '', z: '', w: '' }, radius: 1,
        model: 's_m_y_cop_01', scenario: 'WORLD_HUMAN_CLIPBOARD', blip: true,
        allWeapons: true, weapons: [], allAmmo: true, ammo: [], jobs: [], outfit: null,
    };
}

function draftFrom(a) {
    return {
        id: a.id, label: a.label, mode: a.mode, radius: a.radius || 1, blip: !!a.blip,
        coords: { x: a.coords.x, y: a.coords.y, z: a.coords.z, w: a.coords.w },
        model: a.model || '', scenario: a.scenario || '',
        allWeapons: !a.weapons, weapons: a.weapons || [], allAmmo: !a.ammo, ammo: a.ammo || [],
        jobs: a.jobs || [], outfit: a.outfit || null,
    };
}

const outfitCount = (o) => (o ? Object.keys(o.components || {}).length + Object.keys(o.props || {}).length : 0);

function formRow(label, ...kids) {
    const w = el('div', 'form-row');
    w.append(el('label', 'field-label', label), ...kids);
    return w;
}

function textInput(obj, key, type = 'text', extra = {}) {
    const i = document.createElement('input');
    i.type = type;
    i.value = obj[key] ?? '';
    Object.assign(i, extra);
    i.oninput = () => { obj[key] = type === 'number' ? (i.value === '' ? '' : Number(i.value)) : i.value; };
    return i;
}

function chipPicker(list, options, nameKey, labelKey) {
    const box = el('div', 'chips pick');
    options.forEach((o) => {
        const c = el('button', 'chip-toggle' + (list.includes(o[nameKey]) ? ' on' : ''), o[labelKey]);
        c.type = 'button';
        c.onclick = () => {
            const at = list.indexOf(o[nameKey]);
            if (at >= 0) list.splice(at, 1); else list.push(o[nameKey]);
            c.classList.toggle('on');
        };
        box.append(c);
    });
    return box;
}

function allOrPick(d, flag, listKey, options, nameKey, labelKey, allText) {
    const wrap = el('div', 'form-stack');
    const toggle = el('label', 'check');
    const cb = document.createElement('input');
    cb.type = 'checkbox';
    cb.checked = d[flag];
    toggle.append(cb, el('span', '', allText));
    const picker = chipPicker(d[listKey], options, nameKey, labelKey);
    picker.classList.toggle('hidden', d[flag]);
    cb.onchange = () => { d[flag] = cb.checked; picker.classList.toggle('hidden', cb.checked); };
    wrap.append(toggle, picker);
    return wrap;
}

function renderArmories() {
    if (!state.admin) return view.append(el('div', 'empty', 'Nothing to show.'));
    if (state.draft) return renderArmoryForm();

    const top = el('div', 'filters');
    const add = el('button', 'btn gold', '+ New armory');
    add.onclick = () => { state.draft = newDraft(); render(); };
    top.append(add);
    view.append(top);

    if (!state.admin.points.length) view.append(el('div', 'empty', 'No armories yet. Create one to get started.'));
    state.admin.points.forEach((a) => {
        const row = el('div', 'row');
        const body = el('div', 'w-body');
        body.append(el('div', 'w-name', a.label));
        const c = el('div', 'chips');
        c.append(tag(a.mode === 'target' ? 'Third-eye only' : 'Ped + third-eye', a.mode === 'target' ? 'kit' : 'ok'));
        c.append(tag(a.weapons ? `${a.weapons.length} weapon types` : 'All weapons'));
        c.append(tag(a.ammo ? `${a.ammo.length} ammo types` : 'All ammo'));
        if (a.mode === 'ped' && a.outfit) c.append(tag('Custom clothing', 'warn'));
        body.append(c);
        body.append(el('div', 'w-desc dim', `${a.coords.x.toFixed(1)}, ${a.coords.y.toFixed(1)}, ${a.coords.z.toFixed(1)}`));
        const side = el('div', 'w-side');
        const edit = el('button', 'btn', 'Edit');
        edit.onclick = () => { state.draft = draftFrom(a); render(); };
        const del = el('button', 'btn red', 'Delete');
        del.onclick = async () => {
            if (!(await ask('Delete armory', `Delete "${a.label}"? Its ped or third-eye point is removed immediately. Weapon stock and logs are not affected.`, 'Delete'))) return;
            const res = await post('adminDelete', { id: a.id });
            toast(res.msg, res.ok);
            if (res.ok) { state.admin.points = res.points; render(); }
        };
        const go = el('button', 'btn', 'Go to');
        go.onclick = () => post('adminGoto', { coords: a.coords });
        side.append(go, edit, del);
        row.append(body, side);
        view.append(row);
    });
}

function draftCoords(d) {
    const n = (v) => (v === '' || v === null ? null : Number(v));
    return { x: n(d.coords.x), y: n(d.coords.y), z: n(d.coords.z), w: n(d.coords.w) };
}

function renderArmoryForm() {
    const d = state.draft, a = state.admin;
    const form = el('div', 'form');
    form.append(el('h3', 'grid-title', d.id ? 'Edit armory' : 'New armory'));

    form.append(formRow('Name', textInput(d, 'label', 'text', { maxLength: 40, placeholder: 'e.g. Main Armory' })));

    const type = document.createElement('select');
    [['ped', 'Ped + third-eye'], ['target', 'Third-eye only (no ped)']].forEach(([v, l]) => {
        const o = el('option', '', l); o.value = v; type.append(o);
    });
    type.value = d.mode;
    type.onchange = () => { d.mode = type.value; render(); };
    form.append(formRow('Type', type));

    const pos = el('div', 'pos-grid');
    [['x', 'X'], ['y', 'Y'], ['z', 'Z'], ['w', 'Heading']].forEach(([k, l]) => {
        const f = el('div', 'form-row');
        f.append(el('label', 'field-label', l), textInput(d.coords, k, 'number', { step: '0.01' }));
        pos.append(f);
    });
    const grab = el('button', 'btn', 'Set from my position');
    grab.onclick = async () => {
        const r = await post('adminCapture', { kind: 'pos' });
        if (r.ok) { d.coords = { x: +r.value.x.toFixed(2), y: +r.value.y.toFixed(2), z: +r.value.z.toFixed(2), w: +r.value.w.toFixed(1) }; render(); }
    };
    const prev = el('button', 'btn', d.mode === 'target' ? 'Preview zone' : 'Preview ped');
    prev.onclick = async () => {
        const r = await post('adminPreview', {
            id: d.id, mode: d.mode, coords: draftCoords(d), radius: Number(d.radius) || 1,
            model: d.model, scenario: d.scenario, outfit: d.outfit,
        });
        if (!r.ok) toast(r.msg, false);
    };
    const posActs = el('div', 'inline-actions');
    posActs.append(grab, prev);
    form.append(formRow(d.mode === 'target' ? 'Third-eye position' : 'Ped position', pos, posActs));

    if (d.mode === 'target') {
        form.append(formRow('Third-eye radius (metres, 0.5 - 2)', textInput(d, 'radius', 'number', { step: '0.1', min: 0.5, max: 2 })));
    } else {
        form.append(formRow('Ped model', textInput(d, 'model', 'text', { maxLength: 50, placeholder: 's_m_y_cop_01 or mp_m_freemode_01' })));
        form.append(formRow('Ped animation (scenario, optional)', textInput(d, 'scenario', 'text', { maxLength: 60, placeholder: 'WORLD_HUMAN_CLIPBOARD' })));

        const n = outfitCount(d.outfit);
        const cap = el('button', 'btn', 'Capture what I am wearing');
        cap.onclick = async () => {
            const r = await post('adminCapture', { kind: 'outfit' });
            if (r.ok) { d.outfit = r.value; render(); }
        };
        const clr = el('button', 'btn', 'Clear clothing');
        clr.disabled = !n;
        clr.onclick = () => { d.outfit = null; render(); };
        const actions = el('div', 'inline-actions');
        actions.append(el('span', 'muted', n ? `Custom clothing set (${n} items)` : 'Model default clothing'), cap, clr);
        form.append(formRow('Ped clothing (works best with a freemode model)', actions));
    }

    const blip = el('label', 'check');
    const bcb = document.createElement('input');
    bcb.type = 'checkbox'; bcb.checked = d.blip;
    bcb.onchange = () => { d.blip = bcb.checked; };
    blip.append(bcb, el('span', '', 'Show a map blip'));
    form.append(formRow('Map', blip));

    form.append(formRow('Jobs allowed (none ticked = all police jobs)', chipPicker(d.jobs, a.jobs, 'name', 'label')));
    form.append(formRow('Weapons stored here', allOrPick(d, 'allWeapons', 'weapons', a.weapons, 'name', 'label', 'Issue every weapon')));
    form.append(formRow('Ammo stored here', allOrPick(d, 'allAmmo', 'ammo', a.ammo, 'item', 'label', 'Hand out every ammo type')));

    const acts = el('div', 'confirm-actions');
    const cancel = el('button', 'btn', 'Cancel');
    cancel.onclick = () => { state.draft = null; render(); };
    const save = el('button', 'btn gold', 'Save armory');
    save.onclick = async () => {
        const n = (v) => (v === '' || v === null ? null : Number(v));
        save.disabled = true;
        const res = await post('adminSave', {
            id: d.id, label: d.label, mode: d.mode, radius: n(d.radius), blip: d.blip,
            coords: draftCoords(d),
            model: d.model, scenario: d.scenario, outfit: d.mode === 'ped' ? d.outfit : null,
            weapons: d.allWeapons ? null : d.weapons, ammo: d.allAmmo ? null : d.ammo, jobs: d.jobs,
        });
        save.disabled = false;
        toast(res.msg, res.ok);
        if (res.ok) { state.admin.points = res.points; state.draft = null; render(); }
    };
    acts.append(cancel, save);
    form.append(acts);
    view.append(form);
}

function newWeaponDraft() {
    return { isNew: true, name: 'WEAPON_', label: '', prefix: '', stock: 5, desc: '', requireReason: false, approval: false, kit: '' };
}

function weaponDraftFrom(w) {
    return {
        isNew: false, name: w.name, label: w.label, prefix: w.prefix, stock: w.stock || 0, desc: w.desc || '',
        requireReason: !!w.requireReason, approval: !!w.approval,
        kit: Object.entries(w.kit || {}).map(([k, v]) => `${k}:${v}`).join(', '),
    };
}

function parseKit(text) {
    const kit = {};
    for (const part of text.split(',').map((p) => p.trim()).filter(Boolean)) {
        const [item, amount] = part.split(':').map((p) => p.trim());
        if (!item || !/^\d+$/.test(amount || '')) return null;
        kit[item] = Number(amount);
    }
    return kit;
}

function checkRow(obj, key, text) {
    const label = el('label', 'check');
    const cb = document.createElement('input');
    cb.type = 'checkbox';
    cb.checked = obj[key];
    cb.onchange = () => { obj[key] = cb.checked; };
    label.append(cb, el('span', '', text));
    return label;
}

function renderWeapons() {
    if (!state.admin) return view.append(el('div', 'empty', 'Nothing to show.'));
    if (state.wdraft) return renderWeaponForm();

    const top = el('div', 'filters');
    const add = el('button', 'btn gold', '+ New weapon');
    add.onclick = () => { state.wdraft = newWeaponDraft(); render(); };
    top.append(add);
    view.append(top);

    if (!state.admin.catalog.length) view.append(el('div', 'empty', 'No weapons yet. Add one to get started.'));
    state.admin.catalog.forEach((w) => {
        const row = el('div', 'row');
        const body = el('div', 'w-body');
        body.append(el('div', 'w-name', w.label));
        const c = el('div', 'chips');
        c.append(tag(w.name), tag('Prefix ' + w.prefix), tag(`Stock ${w.stock || 0}`));
        if (w.requireReason) c.append(tag('Reason required'));
        if (w.approval) c.append(tag('Needs approval', 'warn'));
        if (w.kit) c.append(tag('Includes ' + Object.entries(w.kit).map(([k, v]) => `${k} x${v}`).join(', '), 'kit'));
        body.append(c);
        if (w.desc) body.append(el('div', 'w-desc dim', w.desc));
        const side = el('div', 'w-side');
        const edit = el('button', 'btn', 'Edit');
        edit.onclick = () => { state.wdraft = weaponDraftFrom(w); render(); };
        const del = el('button', 'btn red', 'Remove');
        del.onclick = async () => {
            if (!(await ask('Remove weapon', `Remove "${w.label}"? Every unissued serial is retired and its rank rules are deleted. Armories stop offering it immediately. Not possible while any are signed out.`, 'Remove'))) return;
            const res = await post('adminDeleteWeapon', { name: w.name });
            toast(res.msg, res.ok);
            if (res.ok) applyCatalog(res);
        };
        side.append(edit, del);
        row.append(weaponImg(w.name), body, side);
        view.append(row);
    });
}

function applyCatalog(res) {
    if (res.images) Object.assign(weaponImages, res.images);
    state.admin.catalog = res.catalog;
    state.admin.weapons = res.weapons;
    state.wdraft = null;
    render();
}

function renderWeaponForm() {
    const d = state.wdraft;
    const form = el('div', 'form');
    form.append(el('h3', 'grid-title', d.isNew ? 'New weapon' : 'Edit weapon'));

    const name = textInput(d, 'name', 'text', { maxLength: 64, placeholder: 'WEAPON_SMG', disabled: !d.isNew });
    form.append(formRow('ox_inventory item name' + (d.isNew ? '' : ' (cannot be changed)'), name));
    form.append(formRow('Display name', textInput(d, 'label', 'text', { maxLength: 40, placeholder: 'e.g. MP5' })));
    form.append(formRow('Serial prefix (2-4 letters or numbers)', textInput(d, 'prefix', 'text', { maxLength: 4, placeholder: 'e.g. SM' })));
    form.append(formRow('Stock to hold (new serials are added up to this number, nothing is removed)', textInput(d, 'stock', 'number', { min: 0, max: 500 })));
    form.append(formRow('Description', textInput(d, 'desc', 'text', { maxLength: 120 })));
    form.append(formRow('Ammo issued with it (item:amount, comma separated, optional)', textInput(d, 'kit', 'text', { maxLength: 120, placeholder: 'ammo-9:48, ammo-rifle:90' })));
    form.append(formRow('Rules', checkRow(d, 'requireReason', 'Officer must give a reason'), checkRow(d, 'approval', 'A supervisor must approve it')));

    const acts = el('div', 'confirm-actions');
    const cancel = el('button', 'btn', 'Cancel');
    cancel.onclick = () => { state.wdraft = null; render(); };
    const save = el('button', 'btn gold', 'Save weapon');
    save.onclick = async () => {
        const kit = parseKit(d.kit);
        if (!kit) return toast('Ammo must look like ammo-9:48, ammo-rifle:90', false);
        save.disabled = true;
        const res = await post('adminSaveWeapon', {
            isNew: d.isNew, name: d.name, label: d.label, prefix: d.prefix, stock: d.stock === '' ? null : Number(d.stock),
            desc: d.desc, kit, requireReason: d.requireReason, approval: d.approval,
        });
        save.disabled = false;
        toast(res.msg, res.ok);
        if (res.ok) applyCatalog(res);
    };
    acts.append(cancel, save);
    form.append(acts);
    view.append(form);
}

function renderAmmoTypes() {
    if (!state.admin) return view.append(el('div', 'empty', 'Nothing to show.'));
    if (state.adraft) return renderAmmoForm();

    const top = el('div', 'filters');
    const add = el('button', 'btn gold', '+ New ammo');
    add.onclick = () => { state.adraft = { isNew: true, item: '', label: '', amount: 50, desc: '' }; render(); };
    top.append(add);
    view.append(top);

    if (!state.admin.ammoCatalog.length) view.append(el('div', 'empty', 'No ammo yet. Add some to get started.'));
    state.admin.ammoCatalog.forEach((a) => {
        const row = el('div', 'row');
        const body = el('div', 'w-body');
        body.append(el('div', 'w-name', a.label));
        const c = el('div', 'chips');
        c.append(tag(a.item), tag(`${a.amount} per click`));
        body.append(c);
        if (a.desc) body.append(el('div', 'w-desc dim', a.desc));
        const side = el('div', 'w-side');
        const edit = el('button', 'btn', 'Edit');
        edit.onclick = () => { state.adraft = { isNew: false, item: a.item, label: a.label, amount: a.amount, desc: a.desc || '' }; render(); };
        const del = el('button', 'btn red', 'Remove');
        del.onclick = async () => {
            if (!(await ask('Remove ammo', `Remove "${a.label}"? Armories stop handing it out immediately.`, 'Remove'))) return;
            const res = await post('adminDeleteAmmo', { item: a.item });
            toast(res.msg, res.ok);
            if (res.ok) applyAmmo(res);
        };
        side.append(edit, del);
        row.append(weaponImg(a.item), body, side);
        view.append(row);
    });
}

function applyAmmo(res) {
    if (res.images) Object.assign(weaponImages, res.images);
    state.admin.ammoCatalog = res.ammoCatalog;
    state.admin.ammo = res.ammo;
    state.adraft = null;
    render();
}

function renderAmmoForm() {
    const d = state.adraft;
    const form = el('div', 'form');
    form.append(el('h3', 'grid-title', d.isNew ? 'New ammo' : 'Edit ammo'));
    form.append(formRow('ox_inventory item name' + (d.isNew ? '' : ' (cannot be changed)'), textInput(d, 'item', 'text', { maxLength: 64, placeholder: 'ammo-9', disabled: !d.isNew })));
    form.append(formRow('Display name', textInput(d, 'label', 'text', { maxLength: 40, placeholder: 'e.g. 9mm Rounds' })));
    form.append(formRow('Amount handed out per click', textInput(d, 'amount', 'number', { min: 1, max: 1000 })));
    form.append(formRow('Description', textInput(d, 'desc', 'text', { maxLength: 80 })));

    const acts = el('div', 'confirm-actions');
    const cancel = el('button', 'btn', 'Cancel');
    cancel.onclick = () => { state.adraft = null; render(); };
    const save = el('button', 'btn gold', 'Save ammo');
    save.onclick = async () => {
        save.disabled = true;
        const res = await post('adminSaveAmmo', { isNew: d.isNew, item: d.item, label: d.label, amount: d.amount === '' ? null : Number(d.amount), desc: d.desc });
        save.disabled = false;
        toast(res.msg, res.ok);
        if (res.ok) applyAmmo(res);
    };
    acts.append(cancel, save);
    form.append(acts);
    view.append(form);
}

const norm = (s) => s.replace(/\s+/g, ' ').trim().toLowerCase();

function updateSignBtn() {
    const nameOk = norm($('sign-input').value) === norm(state.data.name);
    const reasonOk = !signCtx.item.reason || $('sign-reason').value.trim().length >= 3;
    $('sign-confirm').disabled = !(nameOk && reasonOk);
}

function openSign(item) {
    signCtx = { item };
    $('sign-label').textContent = item.label;
    $('sign-img').replaceChildren(...weaponImg(item.name).childNodes);
    $('sign-name').textContent = state.data.name;

    $('sign-serial').replaceChildren(...item.serials.map((s) => { const o = el('option', '', s); o.value = s; return o; }));

    $('reason-wrap').classList.toggle('hidden', !item.reason);
    $('sign-reason').value = '';
    $('sign-input').value = '';

    const notes = [];
    if (item.approval) notes.push('A supervisor must approve this before it is issued.');
    if (item.kit) notes.push(`Issued with: ${item.kit}. Unused items are taken back on return.`);
    $('sign-notes').textContent = notes.join(' ');
    $('sign-notes').classList.toggle('hidden', !notes.length);

    $('sign-confirm').textContent = 'Sign & Retrieve';
    $('sign-confirm').disabled = true;
    $('sign').classList.remove('hidden');
    (item.reason ? $('sign-reason') : $('sign-input')).focus();
}

$('sign-input').oninput = updateSignBtn;
$('sign-reason').oninput = updateSignBtn;
$('sign-close').onclick = () => $('sign').classList.add('hidden');
$('sign-confirm').onclick = async () => {
    const btn = $('sign-confirm');
    btn.disabled = true;
    btn.textContent = 'Processing...';
    const signature = $('sign-input').value, reason = $('sign-reason').value;
    const r = await post('checkout', { serial: $('sign-serial').value, signature, reason });
    toast(r.msg, r.ok);
    $('sign').classList.add('hidden');
    refresh();
};

function close() {
    app.classList.add('hidden');
    $('sign').classList.add('hidden');
    $('confirm').classList.add('hidden');
    post('close');
}
$('close').onclick = close;
document.addEventListener('keydown', (e) => {
    if (e.key !== 'Escape') return;
    if (cancelAsk) cancelAsk();
    else if (!$('sign').classList.contains('hidden')) $('sign').classList.add('hidden');
    else close();
});

window.addEventListener('message', (e) => {
    const m = e.data;
    if (m.action === 'close') return app.classList.add('hidden');
    if (m.action === 'hide') return app.classList.add('invisible');
    if (m.action === 'show') return app.classList.remove('invisible');
    if (m.action !== 'open') return;
    weaponImages = m.images || {};
    state = {
        mode: m.mode, data: m.data || null, command: m.command,
        can: m.can || {},
        tab: 'checkout',
        page: 1, filters: {}, lookup: m.lookup || '', stockFilter: 'attention',
        admin: m.admin || null, draft: null, wdraft: null, adraft: null,
    };
    if (m.mode === 'admin') state.tab = 'armories';
    if (m.mode === 'log') {
        const tabs = tabsFor().map((t) => t[0]);
        state.tab = m.lookup && tabs.includes('lookup') ? 'lookup' : tabs[0];
    }
    $('title').textContent = m.department;
    $('subtitle').textContent = m.title;
    app.classList.remove('hidden', 'invisible');
    render();
});
