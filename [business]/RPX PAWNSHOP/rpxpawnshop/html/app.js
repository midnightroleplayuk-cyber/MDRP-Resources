const app = document.getElementById("app");
const grid = document.getElementById("grid");
const titleEl = document.getElementById("title");
const subtitleEl = document.getElementById("subtitle");
const countEl = document.getElementById("count");
const totalEl = document.getElementById("total");
const closeBtn = document.getElementById("closeBtn");
const sellAllBtn = document.getElementById("sellAllBtn");

let currentItems = [];
let imageBase = "";

// Ensure hidden on first load (prevents stuck UI showing on join)
window.addEventListener("DOMContentLoaded", () => {
  app.classList.add("hidden");
});

function fmt(n) {
  return `$${Number(n || 0).toLocaleString()}`;
}

function recalc() {
  // Count only items with amount > 0 for summary
  let itemsToSell = 0;
  let total = 0;

  for (const item of currentItems) {
    const amt = Number(item.amount || 0);
    if (amt > 0) {
      itemsToSell += amt;
      total += (Number(item.price || 0) * amt);
    }
  }

  countEl.textContent = String(itemsToSell);
  totalEl.textContent = fmt(total);
}

function postNui(name, data = {}) {
  fetch(`https://${GetParentResourceName()}/${name}`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(data),
  }).catch(() => {});
}

function render(items) {
  currentItems = items || [];
  grid.innerHTML = "";

  for (const item of currentItems) {
    const owned = Number(item.amount || 0);

    const card = document.createElement("div");
    card.className = "card";

    const img = document.createElement("img");
    img.src = `${imageBase}${item.image || (item.name + ".png")}`;
    img.onerror = () => { img.src = ""; };

    const iconWrap = document.createElement("div");
    iconWrap.className = "iconWrap";
    iconWrap.appendChild(img);

    const right = document.createElement("div");

    const nameRow = document.createElement("div");
    nameRow.className = "nameRow";

    const name = document.createElement("div");
    name.className = "name";
    name.textContent = item.label || item.name;

    const qty = document.createElement("div");
    qty.className = "qty";
    qty.textContent = `x${owned}`;

    nameRow.appendChild(name);
    nameRow.appendChild(qty);

    const price = document.createElement("div");
    price.className = "price";
    price.innerHTML = `Sell Price: <b>${fmt(item.price)}</b>`;

    const controls = document.createElement("div");
    controls.className = "controls";

    const input = document.createElement("input");
    input.type = "number";
    input.min = "1";
    input.max = String(Math.max(1, owned));
    input.value = "1";
    input.disabled = owned <= 0;

    const sellBtn = document.createElement("button");
    sellBtn.className = "btn sell";
    sellBtn.textContent = owned > 0 ? "SELL" : "NO ITEMS";
    sellBtn.disabled = owned <= 0;

    sellBtn.onclick = () => {
      const amt = Math.max(1, Math.min(Number(input.value || 1), owned));
      postNui("sellItem", { name: item.name, amount: amt });
    };

    controls.appendChild(input);
    controls.appendChild(sellBtn);

    right.appendChild(nameRow);
    right.appendChild(price);
    right.appendChild(controls);

    card.appendChild(iconWrap);
    card.appendChild(right);

    grid.appendChild(card);
  }

  recalc();
}

window.addEventListener("message", (event) => {
  const data = event.data || {};

  if (data.action === "open") {
    app.classList.remove("hidden");
    titleEl.innerHTML = (data.title || "SELL ITEMS") + ` <span class="dollar">$</span>`;
    subtitleEl.textContent = data.subtitle || "Sell your items for cash.";
  }

  if (data.action === "close") {
    app.classList.add("hidden");
    grid.innerHTML = "";
    currentItems = [];
    recalc();
  }

  if (data.action === "setItems") {
    imageBase = data.imageBase || "";
    render(data.items || []);
  }
});

closeBtn.onclick = () => postNui("close");
sellAllBtn.onclick = () => postNui("sellAll");

document.addEventListener("keydown", (e) => {
  if (e.key === "Escape") postNui("close");
});
