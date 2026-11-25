const app = document.getElementById('app');
const toastEl = document.getElementById('toast');

const PERMISSION_LABELS = {
    work: 'Work',
    sell: 'Sell',
    manage_venue: 'Manage venue',
    manage_staff: 'Manage staff',
    manage_stock: 'Manage stock',
    view_finances: 'View finances',
    manage_finances: 'Move funds',
    security: 'Club security',
};

const state = {
    venues: [],
    data: null,
    tab: 'overview',
    busy: false,
    nearby: [],
    drafts: {},
    armedFire: null,
    armedPoint: null,
    cart: {},
    view: 'panel',
    isAdmin: false,
    admin: null,
};

let toastTimer = null;

const esc = (value) => String(value ?? '').replace(/[&<>"']/g, (c) => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
}[c]));

const list = (value) => (Array.isArray(value) ? value : []);
const money = (value) => (value === null || value === undefined
    ? 'Unavailable'
    : `$${Number(value).toLocaleString('en-GB')}`);
const resource = () => (window.GetParentResourceName ? window.GetParentResourceName() : 'NDM_Business');

async function post(endpoint, body) {
    const response = await fetch(`https://${resource()}/${endpoint}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify(body || {}),
    });
    return response.json();
}

function toast(message, isError) {
    if (!message) return;
    clearTimeout(toastTimer);
    toastEl.textContent = message;
    toastEl.classList.toggle('error', Boolean(isError));
    toastEl.hidden = false;
    toastTimer = setTimeout(() => { toastEl.hidden = true; }, 3500);
}

function visibleTabs() {
    const data = state.data;
    const tabs = [['overview', 'Overview']];
    if (data && data.staff) tabs.push(['staff', 'Staff']);
    if (data && data.ranks) tabs.push(['ranks', 'Ranks']);
    if (data && data.finance) tabs.push(['finance', 'Finances']);
    if (data && data.stock) tabs.push(['stock', 'Stock']);
    if (data && data.menu) tabs.push(['menu', 'Menu']);
    if (data && data.club) tabs.push(['club', 'Club']);
    if (data && data.ownership) tabs.push(['ownership', 'Ownership']);
    if (data && data.points) tabs.push(['points', 'Locations']);
    return tabs;
}

async function request(action, payload) {
    if (state.busy || !state.data) return null;
    state.busy = true;
    render();
    let result;
    try {
        result = await post('request', {
            action,
            payload: { venue: state.data.venue.id, ...(payload || {}) },
        });
    } catch (error) {
        result = { ok: false, error: 'The server did not respond.' };
    }
    state.busy = false;
    if (result.data) state.data = result.data;
    if (!result.ok) toast(result.error, true);
    else toast(result.message, false);
    if (!visibleTabs().some(([id]) => id === state.tab)) state.tab = 'overview';
    render();
    return result;
}

function renderOverview() {
    const { staff, finance, me } = state.data;
    const members = staff ? list(staff.members) : [];
    const online = members.filter((member) => member.online).length;
    return `<div class="stack">
        <div class="stats">
            <div class="card"><div class="label">Business balance</div><div class="value">${finance ? esc(money(finance.balance)) : 'Restricted'}</div></div>
            <div class="card"><div class="label">Staff</div><div class="value">${staff ? members.length : 'Restricted'}</div></div>
            <div class="card"><div class="label">Staff online</div><div class="value">${staff ? online : 'Restricted'}</div></div>
        </div>
        <div class="card"><h2>Your access</h2><div class="muted">${me.isBoss ? 'You have full control of this venue.' : 'You have limited management access.'}</div></div>
    </div>`;
}

function renderStaff() {
    const { members, assignable } = state.data.staff;
    const gradeList = list(assignable);
    const gradeOptions = gradeList.map((g) => `<option value="${g.grade}">${esc(g.label)}</option>`).join('');
    const nearby = state.nearby.map((p) => `<option value="${p.id}">${esc(p.name)} (${p.id})</option>`).join('');
    const rows = list(members).map((member) => {
        const options = gradeList.some((g) => g.grade === member.grade)
            ? gradeList.map((g) => `<option value="${g.grade}" ${g.grade === member.grade ? 'selected' : ''}>${esc(g.label)}</option>`).join('')
            : `<option value="${member.grade}" selected>${esc(member.gradeLabel)}</option>${gradeOptions}`;
        const armed = state.armedFire === member.citizenid;
        return `<tr>
            <td><span class="dot ${member.online ? 'on' : ''}"></span>${esc(member.name)}</td>
            <td class="grade">${member.canManage
        ? `<select data-change="grade" data-citizenid="${esc(member.citizenid)}" ${state.busy ? 'disabled' : ''}>${options}</select>`
        : esc(member.gradeLabel)}</td>
            <td class="actions">${member.canManage
        ? `<button class="danger ${armed ? 'armed' : ''}" data-act="fire" data-citizenid="${esc(member.citizenid)}" ${state.busy ? 'disabled' : ''}>${armed ? 'Confirm' : 'Fire'}</button>`
        : ''}</td>
        </tr>`;
    }).join('');

    return `<div class="stack">
        <div class="card">
            <h2>Hire someone nearby</h2>
            <div class="row">
                <label class="field"><span>Player</span><select id="hire-player" ${nearby ? '' : 'disabled'}>${nearby || '<option>Search for nearby players</option>'}</select></label>
                <label class="field"><span>Starting rank</span><select id="hire-grade" ${gradeOptions ? '' : 'disabled'}>${gradeOptions || '<option>No ranks available</option>'}</select></label>
                <button data-act="nearby" ${state.busy ? 'disabled' : ''}>Find players</button>
                <button class="primary" data-act="hire" ${state.busy || !nearby || !gradeOptions ? 'disabled' : ''}>Send offer</button>
            </div>
        </div>
        <div class="card">
            <h2>Employees</h2>
            ${rows ? `<table><thead><tr><th>Name</th><th>Rank</th><th></th></tr></thead><tbody>${rows}</tbody></table>` : '<div class="muted">No employees yet.</div>'}
        </div>
    </div>`;
}

function rankValues(rank) {
    return state.drafts[rank.grade] || {
        permissions: { ...(Array.isArray(rank.permissions) ? {} : rank.permissions) },
        commission: rank.commission,
        salary: rank.salary,
    };
}

function renderRanks() {
    const permissions = list(state.data.permissions);
    const cards = list(state.data.ranks).map((rank) => {
        const values = rankValues(rank);
        const disabled = !rank.canEdit || state.busy ? 'disabled' : '';
        const checks = permissions.map((permission) => `<label class="check">
            <input type="checkbox" data-rank="${rank.grade}" data-permission="${esc(permission)}" ${rank.boss || values.permissions[permission] ? 'checked' : ''} ${disabled}>
            ${esc(PERMISSION_LABELS[permission] || permission)}
        </label>`).join('');
        return `<div class="card">
            <h2>${esc(rank.label)}${rank.boss ? ' <span class="muted">(boss, full access)</span>' : ''}</h2>
            <div class="perms">${checks}</div>
            <div class="row">
                <label class="field"><span>Commission %</span><input type="number" min="0" max="100" data-rank="${rank.grade}" data-field="commission" value="${esc(values.commission)}" ${disabled}></label>
                <button class="primary" data-act="saveRank" data-grade="${rank.grade}" ${disabled}>Save rank</button>
            </div>
        </div>`;
    }).join('');
    return `<div class="stack">
        <div class="card muted">Wages are paid by Apex Banking. Set them in the bank's Business tab.</div>
        ${cards || '<div class="card muted">This job has no ranks.</div>'}
    </div>`;
}

function renderFinance() {
    const { balance, canMove, ledger } = state.data.finance;
    const rows = list(ledger).map((entry) => {
        const when = new Date(Number(entry.time) * 1000).toLocaleString('en-GB');
        const amount = Number(entry.amount);
        return `<tr>
            <td>${esc(when)}</td>
            <td>${esc(entry.kind)}</td>
            <td>${esc(entry.description)}</td>
            <td class="num ${amount >= 0 ? 'in' : 'out'}">${amount >= 0 ? '+' : '-'}${esc(money(Math.abs(amount)))}</td>
        </tr>`;
    }).join('');
    return `<div class="stack">
        <div class="card"><div class="label">Business balance</div><div class="value">${esc(money(balance))}</div></div>
        ${canMove ? `<div class="card">
            <h2>Move funds</h2>
            <div class="row">
                <label class="field"><span>Amount</span><input id="fund-amount" type="number" min="1" step="1"></label>
                <label class="field"><span>Your account</span><select id="fund-account"><option value="bank">Bank</option><option value="cash">Cash</option></select></label>
                <button class="primary" data-act="deposit" ${state.busy ? 'disabled' : ''}>Deposit</button>
                <button data-act="withdraw" ${state.busy ? 'disabled' : ''}>Withdraw</button>
            </div>
        </div>` : ''}
        <div class="card">
            <h2>Recent activity</h2>
            ${rows ? `<table><thead><tr><th>Date</th><th>Type</th><th>Details</th><th class="num">Amount</th></tr></thead><tbody>${rows}</tbody></table>` : '<div class="muted">No activity yet.</div>'}
        </div>
    </div>`;
}

function pointModelOptions(typeId, selected) {
    const type = list(state.data && state.data.pointTypes).find((entry) => entry.id === typeId);
    const props = type ? list(type.props) : [];
    const choices = [{ model: '', label: 'Interaction point (invisible)' }, ...props];
    return choices.map((choice) => `<option value="${esc(choice.model)}" ${choice.model === (selected || '') ? 'selected' : ''}>${esc(choice.label)}</option>`).join('');
}

document.addEventListener('change', (event) => {
    if (event.target.id !== 'point-type') return;
    const select = document.getElementById('point-model');
    if (select) select.innerHTML = pointModelOptions(event.target.value, '');
});

function renderPoints() {
    const types = list(state.data.pointTypes);
    const options = types.map((type) => `<option value="${esc(type.id)}">${esc(type.label)}</option>`).join('');
    const rows = list(state.data.points).map((point) => {
        const armed = state.armedPoint === point.id;
        return `<tr>
            <td>${esc(point.label)}</td>
            <td>${esc(point.typeLabel)}</td>
            <td><select id="point-model-${point.id}">${pointModelOptions(point.type, point.model)}</select></td>
            <td class="muted">${Number(point.x).toFixed(1)}, ${Number(point.y).toFixed(1)}, ${Number(point.z).toFixed(1)}</td>
            <td class="actions"><button data-act="movePoint" data-point="${point.id}" ${state.busy ? 'disabled' : ''}>Move</button></td>
            <td class="actions"><button class="danger ${armed ? 'armed' : ''}" data-act="deletePoint" data-point="${point.id}" ${state.busy ? 'disabled' : ''}>${armed ? 'Confirm' : 'Remove'}</button></td>
        </tr>`;
    }).join('');

    return `<div class="stack">
        <div class="card">
            <h2>Add a location</h2>
            <div class="row">
                <label class="field"><span>Type</span><select id="point-type">${options}</select></label>
                <label class="field"><span>Appearance</span><select id="point-model">${pointModelOptions(types[0] && types[0].id, '')}</select></label>
                <label class="field"><span>Name (optional)</span><input id="point-label" maxlength="40" placeholder="Front counter"></label>
                <button class="primary" data-act="placePoint" ${state.busy ? 'disabled' : ''}>Place in world</button>
            </div>
        </div>
        <div class="card">
            <h2>Placed locations</h2>
            ${rows ? `<table><thead><tr><th>Name</th><th>Type</th><th>Appearance</th><th>Position</th><th></th><th></th></tr></thead><tbody>${rows}</tbody></table>` : '<div class="muted">Nothing has been placed yet.</div>'}
        </div>
    </div>`;
}

function cartSummary() {
    const stock = state.data.stock;
    let units = 0;
    let cost = 0;
    list(stock.items).forEach((item) => {
        const quantity = Number(state.cart[item.item]) || 0;
        units += quantity;
        cost += quantity * item.price;
    });
    const boxes = units > 0 ? Math.ceil(units / stock.unitsPerBox) : 0;
    return { units, cost, boxes, tooBig: boxes > stock.maxBoxes };
}

function cartSummaryText() {
    const summary = cartSummary();
    if (!summary.units) return 'Add quantities to build an order.';
    const limit = summary.tooBig ? ` · limit is ${state.data.stock.maxBoxes} boxes` : '';
    return `${summary.units} items · ${summary.boxes} ${summary.boxes === 1 ? 'box' : 'boxes'} · ${money(summary.cost)}${limit}`;
}

function renderSupplyOrder(order) {
    if (!order) return '';
    const armed = state.armedPoint === 'cancel-order';
    const step = order.atDepot > 0 ? `Collect from ${order.depot.label}` : 'Deliver to the stock room';
    return `<div class="card">
        <h2>Active delivery</h2>
        <div class="stats">
            <div><div class="label">At depot</div><div class="value">${order.atDepot}</div></div>
            <div><div class="label">In vehicle${order.plate ? ` (${esc(order.plate)})` : ''}</div><div class="value">${order.loaded}</div></div>
            <div><div class="label">Delivered</div><div class="value">${order.delivered} / ${order.boxes}</div></div>
        </div>
        <p class="muted">Next: ${esc(step)}.</p>
        <div class="row">
            <button data-act="stockReset" ${state.busy || !order.loaded ? 'disabled' : ''}>Vehicle lost, return boxes</button>
            <button class="danger ${armed ? 'armed' : ''}" data-act="stockCancel" ${state.busy || order.delivered > 0 || order.carried > 0 ? 'disabled' : ''}>${armed ? 'Confirm cancel' : 'Cancel and refund'}</button>
        </div>
    </div>`;
}

function renderStock() {
    const stock = state.data.stock;
    const items = list(stock.items);
    const depots = list(stock.depots);
    const canOrder = !stock.order && stock.hasStockRoom && depots.length > 0;
    let notice = '';
    if (!stock.hasStockRoom) notice = 'Place a stock room in Locations before ordering.';
    else if (!depots.length) notice = 'An admin needs to place a supplier depot before you can order.';

    const rows = items.map((item) => `<tr>
        <td>${esc(item.label)}${item.onOrder ? ` <span class="muted">(+${item.onOrder} on order)</span>` : ''}</td>
        <td class="num">${item.quantity}</td>
        <td class="num">${item.crafted ? 'Crafted' : esc(money(item.price))}</td>
        <td class="qty"><input type="number" min="0" step="1" aria-label="Order ${esc(item.label)}" data-cart="${esc(item.item)}" value="${esc(state.cart[item.item] || '')}" ${canOrder && !item.crafted ? '' : 'disabled'}></td>
        <td class="qty"><input id="move-${esc(item.item)}" type="number" min="1" step="1" aria-label="Move ${esc(item.label)}" ${stock.atStockRoom ? '' : 'disabled'}></td>
        <td class="actions"><button data-act="stockTake" data-item="${esc(item.item)}" ${stock.atStockRoom && !state.busy ? '' : 'disabled'}>Take</button></td>
        <td class="actions"><button data-act="stockStore" data-item="${esc(item.item)}" ${stock.atStockRoom && !state.busy ? '' : 'disabled'}>Store</button></td>
    </tr>`).join('');

    return `<div class="stack">
        ${renderSupplyOrder(stock.order)}
        ${notice ? `<div class="card muted">${esc(notice)}</div>` : ''}
        ${!stock.order && canOrder ? `<div class="card">
            <h2>New stock order</h2>
            <div class="row">
                <label class="field"><span>Supplier depot</span><select id="stock-depot">${depots.map((depot) => `<option value="${depot.id}">${esc(depot.label)}</option>`).join('')}</select></label>
                <div class="field"><span>Order total</span><div id="cart-summary">${esc(cartSummaryText())}</div></div>
                <button class="primary" data-act="stockOrder" ${state.busy ? 'disabled' : ''}>Pay and order</button>
            </div>
        </div>` : ''}
        <div class="card">
            <h2>Stock room</h2>
            ${stock.atStockRoom ? '' : '<p class="muted">Go to the stock room to take or store items.</p>'}
            ${rows ? `<table><thead><tr><th>Item</th><th class="num">In stock</th><th class="num">Price</th><th>Order</th><th>Move</th><th></th><th></th></tr></thead><tbody>${rows}</tbody></table>` : '<div class="muted">No supply items are available for this venue.</div>'}
        </div>
    </div>`;
}

function renderClub() {
    const club = state.data.club;
    const drinks = list(club.drinks).map((drink) => `<tr>
        <td>${esc(drink.label)}</td>
        <td class="num">${drink.alcohol}%</td>
        <td class="qty"><input type="number" min="0" step="1" aria-label="Price for ${esc(drink.label)}" data-club-drink="${esc(drink.id)}" value="${drink.price}"></td>
    </tr>`).join('');
    const bans = list(club.bans).map((ban) => `<tr>
        <td>${esc(ban.name)}</td>
        <td class="actions"><button data-act="clubUnban" data-citizenid="${esc(ban.citizenid)}" ${state.busy ? 'disabled' : ''}>Unban</button></td>
    </tr>`).join('');
    return `<div class="stack">
        <div class="stats">
            <div class="card"><div class="label">Active passes</div><div class="value">${club.activePasses}</div></div>
            <div class="card"><div class="label">Pass length</div><div class="value">${club.passHours} hours</div></div>
            <div class="card"><div class="label">VIP drink discount</div><div class="value">${club.vipEnabled ? `${club.vipDiscount}%` : 'Off'}</div></div>
        </div>
        <div class="card">
            <h2>Entry prices</h2>
            <div class="row">
                <label class="field"><span>Entry pass</span><input id="club-entry" type="number" min="0" step="1" value="${club.entryPrice}"></label>
                <label class="field"><span>VIP pass</span><input id="club-vip" type="number" min="0" step="1" value="${club.vipPrice}"></label>
                <button class="primary" data-act="clubSave" ${state.busy ? 'disabled' : ''}>Save prices</button>
            </div>
        </div>
        <div class="card">
            <h2>Drink prices</h2>
            <table><thead><tr><th>Drink</th><th class="num">Alcohol</th><th>Price</th></tr></thead><tbody>${drinks}</tbody></table>
        </div>
        <div class="card">
            <h2>Banned customers</h2>
            ${bans ? `<table><tbody>${bans}</tbody></table>` : '<div class="muted">Nobody is banned.</div>'}
        </div>
    </div>`;
}

function renderOwnership() {
    const { purchasePrice, sellValue, sellScale, balance } = state.data.ownership;
    const armed = state.armedPoint === 'sell-business';
    const canSell = balance === 0 && !state.busy;
    return `<div class="stack">
        <div class="stats">
            <div class="card"><div class="label">Purchase price</div><div class="value">${esc(money(purchasePrice))}</div></div>
            <div class="card"><div class="label">Sell-back value</div><div class="value">${esc(money(sellValue))}</div></div>
            <div class="card"><div class="label">Business balance</div><div class="value">${esc(money(balance))}</div></div>
        </div>
        <div class="card">
            <h2>Transfer ownership</h2>
            <p class="muted">The player must be nearby and accept. The business account, stock and staff go with it.</p>
            <div class="row">
                <label class="field"><span>Player server ID</span><input id="transfer-target" type="number" min="1" step="1"></label>
                <button class="primary" data-act="ownerTransfer" ${state.busy ? 'disabled' : ''}>Offer business</button>
            </div>
        </div>
        <div class="card">
            <h2>Sell to the state</h2>
            <p class="muted">You receive ${Math.round(Number(sellScale) * 100)}% of the purchase price. Withdraw all funds and finish any stock order first.</p>
            <button class="danger ${armed ? 'armed' : ''}" data-act="ownerSell" ${canSell ? '' : 'disabled'}>${armed ? `Confirm sale for ${esc(money(sellValue))}` : 'Sell business'}</button>
        </div>
    </div>`;
}

function renderMenu() {
    const rows = list(state.data.menu).map((item) => `<tr>
        <td>${esc(item.label)}</td>
        <td class="num">${item.quantity}</td>
        <td class="num">${item.crafted ? 'Crafted' : esc(money(item.cost))}</td>
        <td class="qty"><input id="price-${esc(item.item)}" type="number" min="0" step="1" aria-label="Sale price for ${esc(item.label)}" value="${item.price || ''}" placeholder="Off"></td>
        <td class="actions"><button data-act="savePrice" data-item="${esc(item.item)}" ${state.busy ? 'disabled' : ''}>Save</button></td>
    </tr>`).join('');
    return `<div class="card">
        <h2>Register menu</h2>
        <p class="muted">Set a sale price to sell an item. Leave it empty or use 0 to take it off sale.</p>
        ${rows ? `<table><thead><tr><th>Item</th><th class="num">In stock</th><th class="num">Supply cost</th><th>Sale price</th><th></th></tr></thead><tbody>${rows}</tbody></table>` : '<div class="muted">No items are available for this venue.</div>'}
    </div>`;
}

function beginPlacement(body) {
    const venue = state.data.venue.id;
    app.hidden = true;
    toastEl.hidden = true;
    state.data = null;
    state.armedPoint = null;
    post('place', { venue, ...body }).catch(() => {});
}

function adminHeader() {
    const back = state.data ? `<button data-act="leaveAdmin" ${state.busy ? 'disabled' : ''}>Back to venue</button>` : '';
    return `<header class="head">
            <div class="grow"><h1>Business setup</h1><p>Admin only</p></div>
            ${back}
            <button data-act="close">Close</button>
        </header>`;
}

function renderAdmin() {
    const scroll = app.querySelector('.content')?.scrollTop || 0;
    const admin = state.admin;
    if (!admin) {
        app.innerHTML = `${adminHeader()}<section class="content"><div class="muted">Loading…</div></section>`;
        return;
    }
    const disabled = state.busy ? 'disabled' : '';
    const typeOptions = list(admin.types).map((t) => `<option value="${esc(t.id)}">${esc(t.label)}</option>`).join('');
    const jobOptions = list(admin.jobs).map((j) => `<option value="${esc(j.name)}">${esc(j.label)} (${esc(j.name)})</option>`).join('');
    const playerOptions = list(admin.players).map((p) => `<option value="${p.id}">${esc(p.name)} (${p.id})</option>`).join('');

    const venueRows = list(admin.venues).map((venue) => {
        const clearKey = `clear-${venue.id}`;
        const armed = state.armedPoint === clearKey;
        const deleteArmed = state.armedPoint === `delete-${venue.id}`;
        const ownerControls = venue.owner
            ? `<button class="danger ${armed ? 'armed' : ''}" data-act="adminClearOwner" data-venue="${venue.id}" ${disabled}>${armed ? 'Confirm' : 'Remove owner'}</button>`
            : `<div class="row"><select id="owner-${venue.id}" aria-label="Choose new owner" ${playerOptions ? '' : 'disabled'}>${playerOptions || '<option>Nobody online</option>'}</select>
                <button data-act="adminSetOwner" data-venue="${venue.id}" ${state.busy || !playerOptions ? 'disabled' : ''}>Give</button></div>`;
        const priceControls = venue.owner
            ? '<span class="muted">Owned</span>'
            : `<div class="row"><input id="sale-${venue.id}" type="number" min="0" step="1" aria-label="Sale price for ${esc(venue.label)}" value="${venue.salePrice || ''}" placeholder="Not for sale">
                <button data-act="adminSetPrice" data-venue="${venue.id}" ${disabled}>Save</button></div>`;
        return `<tr>
            <td>${esc(venue.label)}<div class="muted">${esc(venue.typeLabel)} · ${esc(venue.jobLabel)}</div></td>
            <td>${venue.owner ? esc(venue.owner) : '<span class="muted">None</span>'}</td>
            <td class="num">${esc(money(venue.balance))}</td>
            <td>${priceControls}</td>
            <td>${ownerControls}</td>
            <td class="actions"><button data-act="adminManage" data-venue="${venue.id}" ${disabled}>Manage</button></td>
            <td class="actions"><button class="danger ${deleteArmed ? 'armed' : ''}" data-act="adminDelete" data-venue="${venue.id}" ${disabled}>${deleteArmed ? 'Confirm' : 'Delete'}</button></td>
        </tr>`;
    }).join('');

    const depotRows = list(admin.depots).map((depot) => {
        const key = `depot-${depot.id}`;
        const armed = state.armedPoint === key;
        return `<tr>
            <td>${esc(depot.label)}</td>
            <td class="muted">${Number(depot.x).toFixed(1)}, ${Number(depot.y).toFixed(1)}, ${Number(depot.z).toFixed(1)}</td>
            <td class="num">${depot.openOrders}</td>
            <td class="actions"><button class="danger ${armed ? 'armed' : ''}" data-act="adminRemoveDepot" data-depot="${depot.id}" ${disabled}>${armed ? 'Confirm' : 'Remove'}</button></td>
        </tr>`;
    }).join('');

    app.innerHTML = `${adminHeader()}
        <section class="content"><div class="stack">
            <div class="card">
                <h2>Create a business</h2>
                <p class="muted">Staff are hired into the job you choose. After creating it, press Manage and place its locations in the Locations tab.</p>
                <div class="row">
                    <label class="field"><span>Name</span><input id="new-label" maxlength="64" placeholder="Burger Shot"></label>
                    <label class="field"><span>Type</span><select id="new-type">${typeOptions}</select></label>
                    <label class="field"><span>Job</span><select id="new-job" ${jobOptions ? '' : 'disabled'}>${jobOptions || '<option>No jobs found</option>'}</select></label>
                    <button class="primary" data-act="adminCreate" ${state.busy || !jobOptions ? 'disabled' : ''}>Create</button>
                </div>
            </div>
            <div class="card">
                <h2>Businesses</h2>
                ${venueRows ? `<table><thead><tr><th>Business</th><th>Owner</th><th class="num">Balance</th><th>Sale price</th><th>Ownership</th><th></th><th></th></tr></thead><tbody>${venueRows}</tbody></table>` : '<div class="muted">No businesses exist yet.</div>'}
            </div>
            <div class="card">
                <h2>Supplier depots</h2>
                <p class="muted">Staff collect stock orders here. Stand near where the depot should be, then place it.</p>
                <div class="row">
                    <label class="field"><span>Depot name</span><input id="depot-label" maxlength="40" placeholder="Docks warehouse"></label>
                    <button class="primary" data-act="adminPlaceDepot" ${disabled}>Place in world</button>
                </div>
                ${depotRows ? `<table><thead><tr><th>Depot</th><th>Position</th><th class="num">Open orders</th><th></th></tr></thead><tbody>${depotRows}</tbody></table>` : '<div class="muted">No depots have been placed yet.</div>'}
            </div>
        </div></section>`;
    app.querySelector('.content').scrollTop = scroll;
}

async function adminRequest(action, payload) {
    if (state.busy) return null;
    state.busy = true;
    render();
    let result;
    try {
        result = await post('admin', { action, payload: payload || {} });
    } catch (error) {
        result = { ok: false, error: 'The server did not respond.' };
    }
    state.busy = false;
    if (result.admin) state.admin = result.admin;
    if (Array.isArray(result.venues)) state.venues = result.venues;
    if (!result.ok) toast(result.error, true);
    else toast(result.message, false);
    render();
    return result;
}

function openAdmin() {
    state.view = 'admin';
    state.armedPoint = null;
    render();
    adminRequest('data');
}

async function openVenue(id) {
    const previous = state.data;
    state.data = { venue: { id } };
    const result = await request('getData');
    if (!result || !result.ok || !result.data) {
        state.data = previous;
        render();
        return;
    }
    state.view = 'panel';
    state.tab = 'overview';
    state.nearby = [];
    state.drafts = {};
    state.armedFire = null;
    state.armedPoint = null;
    render();
}

function adminClick(action, button) {
    if (action === 'close') {
        closePanel();
        return;
    }
    if (action === 'leaveAdmin') {
        state.view = 'panel';
        state.armedPoint = null;
        if (!visibleTabs().some(([id]) => id === state.tab)) state.tab = 'overview';
        render();
        return;
    }
    const venue = Number(button.dataset.venue);
    if (action === 'adminCreate') {
        const label = document.getElementById('new-label').value.trim();
        if (!label) {
            toast('Enter a business name.', true);
            return;
        }
        adminRequest('createVenue', {
            label,
            type: document.getElementById('new-type').value,
            job: document.getElementById('new-job').value,
        });
        return;
    }
    if (action === 'adminSetPrice') {
        const raw = document.getElementById(`sale-${venue}`).value;
        const price = raw === '' ? 0 : Number(raw);
        if (!Number.isInteger(price) || price < 0) {
            toast('Enter a whole price, or 0 to remove the listing.', true);
            return;
        }
        adminRequest('setSalePrice', { venue, price });
        return;
    }
    if (action === 'adminSetOwner') {
        adminRequest('setOwner', { venue, target: Number(document.getElementById(`owner-${venue}`).value) });
        return;
    }
    if (action === 'adminClearOwner') {
        const key = `clear-${venue}`;
        if (state.armedPoint !== key) {
            state.armedPoint = key;
            render();
            return;
        }
        state.armedPoint = null;
        adminRequest('clearOwner', { venue });
        return;
    }
    if (action === 'adminManage') {
        openVenue(venue);
        return;
    }
    if (action === 'adminDelete') {
        const key = `delete-${venue}`;
        if (state.armedPoint !== key) {
            state.armedPoint = key;
            toast('This removes its locations, stock, prices and history. Press Confirm to delete it.', true);
            render();
            return;
        }
        state.armedPoint = null;
        adminRequest('deleteVenue', { venue }).then((result) => {
            if (result && result.ok && state.data && state.data.venue && state.data.venue.id === venue) {
                state.data = null;
                render();
            }
        });
        return;
    }
    if (action === 'adminPlaceDepot') {
        const label = document.getElementById('depot-label').value.trim();
        if (!label) {
            toast('Enter a depot name.', true);
            return;
        }
        app.hidden = true;
        toastEl.hidden = true;
        state.data = null;
        state.admin = null;
        post('placeDepot', { label }).catch(() => {});
        return;
    }
    if (action === 'adminRemoveDepot') {
        const depot = Number(button.dataset.depot);
        const key = `depot-${depot}`;
        if (state.armedPoint !== key) {
            state.armedPoint = key;
            render();
            return;
        }
        state.armedPoint = null;
        adminRequest('removeDepot', { depot });
    }
}

function render() {
    if (state.view === 'register') {
        renderRegister();
        return;
    }
    if (state.view === 'admin') {
        renderAdmin();
        return;
    }
    if (!state.data) return;
    const { venue } = state.data;
    const scroll = app.querySelector('.content')?.scrollTop || 0;
    const views = {
        overview: renderOverview,
        staff: renderStaff,
        ranks: renderRanks,
        finance: renderFinance,
        stock: renderStock,
        menu: renderMenu,
        club: renderClub,
        ownership: renderOwnership,
        points: renderPoints,
    };
    const selector = state.venues.length > 1
        ? `<select class="venue-select" data-change="venue" aria-label="Choose venue" ${state.busy ? 'disabled' : ''}>${state.venues.map((v) => `<option value="${v.id}" ${v.id === venue.id ? 'selected' : ''}>${esc(v.label)}</option>`).join('')}</select>`
        : '';
    app.innerHTML = `<header class="head">
            <div class="grow"><h1>${esc(venue.label)}</h1><p>${esc(venue.type)} · ${esc(venue.jobLabel)}</p></div>
            ${selector}
            ${state.isAdmin ? '<button data-act="openAdmin">Business setup</button>' : ''}
            <button data-act="close">Close</button>
        </header>
        <nav class="tabs">${visibleTabs().map(([id, label]) => `<button class="tab ${state.tab === id ? 'active' : ''}" data-tab="${id}">${label}</button>`).join('')}</nav>
        <section class="content">${(views[state.tab] || renderOverview)()}</section>`;
    app.querySelector('.content').scrollTop = scroll;
}

function closePanel() {
    app.hidden = true;
    toastEl.hidden = true;
    state.view = 'panel';
    state.data = null;
    state.admin = null;
    state.nearby = [];
    state.drafts = {};
    state.armedFire = null;
    post('close').catch(() => {});
}

async function findNearby() {
    if (state.busy) return;
    state.busy = true;
    render();
    let result;
    try {
        result = await post('request', { action: 'nearbyPlayers', payload: { venue: state.data.venue.id } });
    } catch (error) {
        result = { ok: false, error: 'The server did not respond.' };
    }
    state.busy = false;
    state.nearby = result.ok ? list(result.players) : [];
    if (!result.ok) toast(result.error, true);
    else if (!state.nearby.length) toast('Nobody available is nearby.', true);
    render();
}

function moveFunds(action) {
    const amount = Number(document.getElementById('fund-amount').value);
    const account = document.getElementById('fund-account').value;
    if (!Number.isInteger(amount) || amount <= 0) {
        toast('Enter a whole amount above zero.', true);
        return;
    }
    request(action, { amount, account });
}

app.addEventListener('click', async (event) => {
    const tab = event.target.closest('[data-tab]');
    if (tab) {
        state.tab = tab.dataset.tab;
        state.armedFire = null;
        state.armedPoint = null;
        render();
        return;
    }

    const button = event.target.closest('[data-act]');
    if (!button || button.disabled) return;
    const action = button.dataset.act;

    if (state.view === 'admin') {
        adminClick(action, button);
        return;
    }
    if (action === 'openAdmin') {
        openAdmin();
        return;
    }
    if (action === 'close') closePanel();
    if (action === 'nearby') findNearby();
    if (action === 'stockOrder') {
        const summary = cartSummary();
        if (!summary.units) {
            toast('Add something to the order first.', true);
            return;
        }
        if (summary.tooBig) {
            toast(`Orders are limited to ${state.data.stock.maxBoxes} boxes.`, true);
            return;
        }
        const result = await request('stockOrder', {
            depot: Number(document.getElementById('stock-depot').value),
            cart: { ...state.cart },
        });
        if (result && result.ok) {
            state.cart = {};
            render();
        }
        return;
    }
    if (action === 'clubSave') {
        const entryPrice = Number(document.getElementById('club-entry').value);
        const vipPrice = Number(document.getElementById('club-vip').value);
        const drinks = {};
        let valid = Number.isInteger(entryPrice) && entryPrice >= 0 && Number.isInteger(vipPrice) && vipPrice >= 0;
        app.querySelectorAll('[data-club-drink]').forEach((input) => {
            const price = Number(input.value);
            if (input.value === '' || !Number.isInteger(price) || price < 0) valid = false;
            drinks[input.dataset.clubDrink] = price;
        });
        if (!valid) {
            toast('Prices must be whole numbers of 0 or more.', true);
            return;
        }
        request('clubSettings', { entryPrice, vipPrice, drinks });
        return;
    }
    if (action === 'clubUnban') {
        request('clubUnban', { citizenid: button.dataset.citizenid });
        return;
    }
    if (action === 'ownerSell') {
        if (state.armedPoint !== 'sell-business') {
            state.armedPoint = 'sell-business';
            render();
            return;
        }
        state.armedPoint = null;
        const result = await request('ownerSell');
        if (result && result.ok && !result.data) {
            closePanel();
            toast(result.message, false);
        }
        return;
    }
    if (action === 'ownerTransfer') {
        const target = Number(document.getElementById('transfer-target').value);
        if (!Number.isInteger(target) || target <= 0) {
            toast('Enter a player server ID.', true);
            return;
        }
        toast('Offer sent. Waiting for a reply.', false);
        const result = await request('ownerTransfer', { target });
        if (result && result.ok && !result.data) {
            closePanel();
            toast(result.message, false);
        }
        return;
    }
    if (action === 'savePrice') {
        const { item } = button.dataset;
        const raw = document.getElementById(`price-${item}`).value;
        const price = raw === '' ? 0 : Number(raw);
        if (!Number.isInteger(price) || price < 0) {
            toast('Enter a whole price, or 0 to take it off sale.', true);
            return;
        }
        request('setPrice', { item, price });
        return;
    }
    if (action === 'stockReset') {
        request('stockReset');
        return;
    }
    if (action === 'stockCancel') {
        if (state.armedPoint !== 'cancel-order') {
            state.armedPoint = 'cancel-order';
            render();
            return;
        }
        state.armedPoint = null;
        request('stockCancel');
        return;
    }
    if (action === 'stockTake' || action === 'stockStore') {
        const { item } = button.dataset;
        const quantity = Number(document.getElementById(`move-${item}`).value);
        if (!Number.isInteger(quantity) || quantity <= 0) {
            toast('Enter a whole amount above zero.', true);
            return;
        }
        request('stockMove', { item, quantity, direction: action === 'stockTake' ? 'take' : 'store' });
        return;
    }
    if (action === 'placePoint') {
        beginPlacement({
            type: document.getElementById('point-type').value,
            label: document.getElementById('point-label').value,
            model: document.getElementById('point-model').value,
        });
        return;
    }
    if (action === 'movePoint') {
        const pointId = Number(button.dataset.point);
        const model = document.getElementById(`point-model-${pointId}`).value;
        beginPlacement({ pointId, model });
        return;
    }
    if (action === 'deletePoint') {
        const pointId = Number(button.dataset.point);
        if (state.armedPoint !== pointId) {
            state.armedPoint = pointId;
            render();
            return;
        }
        state.armedPoint = null;
        request('deletePoint', { pointId });
    }
    if (action === 'deposit' || action === 'withdraw') moveFunds(action);
    if (action === 'hire') {
        const target = Number(document.getElementById('hire-player').value);
        const grade = Number(document.getElementById('hire-grade').value);
        toast('Offer sent. Waiting for a reply.', false);
        const result = await request('hire', { target, grade });
        if (result && result.ok) state.nearby = state.nearby.filter((player) => player.id !== target);
        render();
    }
    if (action === 'fire') {
        const { citizenid } = button.dataset;
        if (state.armedFire !== citizenid) {
            state.armedFire = citizenid;
            render();
            return;
        }
        state.armedFire = null;
        request('fire', { citizenid });
    }
    if (action === 'saveRank') {
        const grade = Number(button.dataset.grade);
        const rank = list(state.data.ranks).find((item) => item.grade === grade);
        const values = rankValues(rank);
        const result = await request('setRank', {
            grade,
            permissions: values.permissions,
            commission: Number(values.commission) || 0,
            salary: Number(values.salary) || 0,
        });
        if (result && result.ok) {
            delete state.drafts[grade];
            render();
        }
    }
});

app.addEventListener('change', async (event) => {
    const target = event.target;
    if (target.dataset.rank !== undefined) {
        const grade = Number(target.dataset.rank);
        const rank = list(state.data.ranks).find((item) => item.grade === grade);
        const draft = rankValues(rank);
        if (target.dataset.permission) draft.permissions[target.dataset.permission] = target.checked;
        if (target.dataset.field) draft[target.dataset.field] = target.value;
        state.drafts[grade] = draft;
        return;
    }
    if (target.dataset.change === 'grade') {
        request('setGrade', { citizenid: target.dataset.citizenid, grade: Number(target.value) });
    }
    if (target.dataset.change === 'venue') {
        const id = Number(target.value);
        const previous = state.data;
        state.data = { ...previous, venue: { ...previous.venue, id } };
        state.nearby = [];
        state.drafts = {};
        state.armedFire = null;
        const result = await request('getData');
        if (!result || !result.ok || !result.data) state.data = previous;
        state.tab = 'overview';
        render();
    }
});

app.addEventListener('input', (event) => {
    const item = event.target.dataset.cart;
    if (!item) return;
    const quantity = Math.max(0, Math.floor(Number(event.target.value) || 0));
    if (quantity) state.cart[item] = quantity;
    else delete state.cart[item];
    const summary = document.getElementById('cart-summary');
    if (summary) summary.textContent = cartSummaryText();
});

window.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && !app.hidden) closePanel();
});

window.addEventListener('message', ({ data: message }) => {
    if (message.action === 'open') {
        state.view = 'panel';
        state.venues = list(message.venues);
        state.data = message.data;
        state.tab = visibleTabs().some(([id]) => id === message.tab) ? message.tab : 'overview';
        state.nearby = [];
        state.drafts = {};
        state.armedFire = null;
        state.armedPoint = null;
        state.busy = false;
        state.isAdmin = Boolean(message.admin);
        state.admin = null;
        app.hidden = false;
        if (state.isAdmin && (message.tab === 'admin' || !state.data)) {
            openAdmin();
            return;
        }
        render();
    }
    if (message.action === 'close') {
        app.hidden = true;
        toastEl.hidden = true;
        state.view = 'panel';
        state.data = null;
    }
});
