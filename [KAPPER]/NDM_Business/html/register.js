const reg = {
    data: null,
    cart: {},
    customer: null,
    account: 'cash',
    busy: false,
};

function registerTotal() {
    return list(reg.data && reg.data.items).reduce((total, item) => total + (reg.cart[item.item] || 0) * item.price, 0);
}

function pruneRegisterCart() {
    const items = list(reg.data.items);
    Object.keys(reg.cart).forEach((key) => {
        const item = items.find((entry) => entry.item === key);
        if (!item || item.available <= 0) delete reg.cart[key];
        else if (reg.cart[key] > item.available) reg.cart[key] = item.available;
    });
    const customers = list(reg.data.customers);
    if (!customers.some((customer) => customer.id === reg.customer)) {
        reg.customer = customers.length ? customers[0].id : null;
    }
}

function renderRegister() {
    if (!reg.data) return;
    const items = list(reg.data.items);
    const products = items.map((item) => {
        const remaining = item.available - (reg.cart[item.item] || 0);
        return `<button class="product" data-reg="add" data-item="${esc(item.item)}" ${remaining <= 0 || reg.busy ? 'disabled' : ''}>
            <strong>${esc(item.label)}</strong>
            <span>${esc(money(item.price))}</span>
            <small>${item.available > 0 ? `${item.available} in stock` : 'Out of stock'}</small>
        </button>`;
    }).join('');

    const lines = items.filter((item) => reg.cart[item.item]).map((item) => `<div class="ticket-line">
        <div class="grow"><strong>${esc(item.label)}</strong><small>${esc(money(item.price))} each</small></div>
        <button class="step" aria-label="Remove one ${esc(item.label)}" data-reg="dec" data-item="${esc(item.item)}" ${reg.busy ? 'disabled' : ''}>-</button>
        <span class="count">${reg.cart[item.item]}</span>
        <button class="step" aria-label="Add one ${esc(item.label)}" data-reg="add" data-item="${esc(item.item)}" ${reg.busy || reg.cart[item.item] >= item.available ? 'disabled' : ''}>+</button>
    </div>`).join('');

    const customers = list(reg.data.customers).map((customer) => `<option value="${customer.id}" ${customer.id === reg.customer ? 'selected' : ''}>${esc(customer.name)} (${customer.id})</option>`).join('');
    const total = registerTotal();
    const isShop = reg.data.mode === 'shop';

    app.innerHTML = `<header class="head">
            <div class="grow"><h1>${esc(reg.data.venue.label)}</h1><p>${isShop ? 'Shop' : 'Register'}</p></div>
            <button data-reg="refresh" ${reg.busy ? 'disabled' : ''}>Refresh</button>
            <button data-act="close">Close</button>
        </header>
        <section class="content register">
            <div class="products">${products || `<div class="card muted">${isShop ? 'Nothing is for sale right now.' : 'Nothing is for sale. Set prices in the Menu tab of /business.'}</div>`}</div>
            <aside class="card ticket">
                <h2>Current order</h2>
                <div class="ticket-lines">${lines || '<div class="muted">Select items to start an order.</div>'}</div>
                ${isShop ? '' : `<label class="field"><span>Customer</span><select data-reg-change="customer" ${reg.busy ? 'disabled' : ''}>${customers}</select></label>`}
                <label class="field"><span>Payment</span><select data-reg-change="account" ${reg.busy ? 'disabled' : ''}>
                    <option value="cash" ${reg.account === 'cash' ? 'selected' : ''}>Cash</option>
                    <option value="bank" ${reg.account === 'bank' ? 'selected' : ''}>Card</option>
                </select></label>
                <div class="ticket-total"><span>Total</span><strong>${esc(money(total))}</strong></div>
                <button class="primary" data-reg="charge" ${reg.busy || !total || !reg.customer ? 'disabled' : ''}>${reg.busy ? 'Waiting...' : (isShop ? 'Pay now' : 'Charge customer')}</button>
            </aside>
        </section>`;
}

async function registerRequest(action, payload) {
    if (reg.busy || !reg.data) return null;
    reg.busy = true;
    renderRegister();
    let result;
    try {
        result = await post('registerRequest', { action, payload: { point: reg.data.point, ...(payload || {}) } });
    } catch (error) {
        result = { ok: false, error: 'The server did not respond.' };
    }
    reg.busy = false;
    if (state.view !== 'register') return result;
    if (result.data) {
        reg.data = result.data;
        pruneRegisterCart();
    }
    if (!result.ok) toast(result.error, true);
    else toast(result.message, false);
    renderRegister();
    return result;
}

app.addEventListener('click', async (event) => {
    if (state.view !== 'register') return;
    const button = event.target.closest('[data-reg]');
    if (!button || button.disabled) return;
    const action = button.dataset.reg;
    const key = button.dataset.item;

    if (action === 'add') {
        const item = list(reg.data.items).find((entry) => entry.item === key);
        if (item && (reg.cart[key] || 0) < item.available) reg.cart[key] = (reg.cart[key] || 0) + 1;
        renderRegister();
    }
    if (action === 'dec') {
        reg.cart[key] = (reg.cart[key] || 0) - 1;
        if (reg.cart[key] <= 0) delete reg.cart[key];
        renderRegister();
    }
    if (action === 'refresh') registerRequest('refresh');
    if (action === 'charge') {
        if (reg.customer !== reg.data.customers[0].id) toast('Waiting for the customer to accept.', false);
        const result = await registerRequest('charge', {
            customer: reg.customer,
            account: reg.account,
            cart: { ...reg.cart },
        });
        if (result && result.ok && state.view === 'register') {
            reg.cart = {};
            renderRegister();
        }
    }
});

app.addEventListener('change', (event) => {
    if (state.view !== 'register') return;
    const field = event.target.dataset.regChange;
    if (field === 'customer') reg.customer = Number(event.target.value);
    if (field === 'account') reg.account = event.target.value;
});

window.addEventListener('message', ({ data: message }) => {
    if (message.action !== 'openRegister') return;
    state.view = 'register';
    state.data = null;
    reg.data = message.data;
    reg.cart = {};
    reg.customer = null;
    reg.account = 'cash';
    reg.busy = false;
    pruneRegisterCart();
    app.hidden = false;
    renderRegister();
});
