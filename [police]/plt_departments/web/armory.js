window.addEventListener('message', function(event) {
    if (event.data.action === "openArmory") {
        setupArmory(event.data);
    }
});

let armoryPendingTake = null;

function escapeHtml(value) {
    return String(value || '')
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');
}

function normalizeItemName(itemName) {
    return String(itemName || '')
        .trim()
        .toLowerCase()
        .replace(/\s+/g, '_');
}

function getInventoryImageTemplates(inventoryType) {
    const inventory = String(inventoryType || 'qb').toLowerCase();
    const templatesByInventory = {
        ox: [
            'nui://ox_inventory/web/images/{item}.png'
        ],
        qb: [
            'nui://qb-inventory/html/images/{item}.png',
            'nui://lj-inventory/html/images/{item}.png',
            'nui://ps-inventory/html/images/{item}.png'
        ],
        qs: [
            'nui://qs-inventory/html/images/{item}.png'
        ],
        codem: [
            'nui://codem-inventory/html/images/{item}.png'
        ],
        tgiann: [
            'nui://tgiann-inventory/html/img/items/{item}.png',
            'nui://tgiann-inventory/html/images/{item}.png'
        ],
        core: [
            'nui://core_inventory/html/img/{item}.png',
            'nui://core_inventory/html/images/{item}.png'
        ]
    };

    const selectedTemplates = templatesByInventory[inventory] || templatesByInventory.qb;
    const globalFallbackTemplates = [
        'nui://ox_inventory/web/images/{item}.png',
        'nui://qb-inventory/html/images/{item}.png',
        'nui://qs-inventory/html/images/{item}.png'
    ];

    return [...selectedTemplates, ...globalFallbackTemplates];
}

function buildArmoryImageCandidates(entry, inventoryType) {
    const itemName = normalizeItemName(entry.name);
    const iconName = String(entry.icon || '').trim();
    const candidates = [];

    if (iconName) {
        if (/^(https?:\/\/|nui:\/\/)/i.test(iconName) || iconName.includes('/')) {
            candidates.push(iconName);
        } else {
            candidates.push(`img/${iconName}`);
        }
    }

    if (itemName) {
        candidates.push(`img/${itemName}.png`);
        candidates.push(`img/${itemName}.webp`);
    }

    getInventoryImageTemplates(inventoryType).forEach(template => {
        if (itemName) {
            candidates.push(template.replace('{item}', itemName));
        }
    });

    return [...new Set(candidates)];
}

function resolveFallbackIcon(itemType, itemName) {
    const name = String(itemName || '').toLowerCase();
    if (itemType === 'weapon') {
        if (name.includes('stungun')) return 'fas fa-bolt';
        if (name.includes('shotgun')) return 'fas fa-bullseye';
        if (name.includes('rifle')) return 'fas fa-rifle';
        return 'fas fa-gun';
    }
    if (name.includes('radio')) return 'fas fa-walkie-talkie';
    if (name.includes('handcuffs')) return 'fas fa-hands-bound';
    if (name.includes('armor')) return 'fas fa-shield-halved';
    return 'fas fa-box-open';
}

function tryLoadNextArmoryImage(imgEl) {
    if (!imgEl) return false;
    const candidatesRaw = imgEl.dataset.candidates || '';
    const candidates = candidatesRaw ? candidatesRaw.split('|').filter(Boolean) : [];
    let index = parseInt(imgEl.dataset.index || '0', 10);

    if (!Number.isInteger(index) || index < 0) index = 0;

    while (index < candidates.length) {
        const nextSrc = candidates[index];
        index += 1;
        imgEl.dataset.index = String(index);
        if (nextSrc) {
            imgEl.src = nextSrc;
            return true;
        }
    }
    return false;
}

window.handleArmoryImageError = function(imgEl) {
    if (tryLoadNextArmoryImage(imgEl)) return;
    const mediaEl = imgEl.closest('.armory-item-media');
    if (!mediaEl) return;
    imgEl.style.display = 'none';
    const fallbackIconEl = mediaEl.querySelector('.armory-item-fallback');
    if (fallbackIconEl) fallbackIconEl.classList.remove('hidden');
};

function createArmoryCard(entry, itemType, inventoryType) {
    const card = document.createElement('div');
    card.className = 'armory-item-card';

    const fallbackIcon = resolveFallbackIcon(itemType, entry.name);
    const limit = Number.isFinite(Number(entry.limit)) ? Number(entry.limit) : 0;
    const label = entry.label || entry.name || 'UNKNOWN';
    const category = entry.category || (itemType === 'weapon' ? 'Firearms' : 'Equipment');
    const imageCandidates = buildArmoryImageCandidates(entry, inventoryType);

    card.innerHTML = `
        <div class="armory-item-media">
            <img class="armory-item-image" alt="${escapeHtml(label)}">
            <div class="armory-item-fallback hidden"><i class="${fallbackIcon}"></i></div>
            <div class="armory-item-limit-badge">${limit > 0 ? `${limit} max` : 'Unlimited'}</div>
        </div>
        <div class="armory-item-meta">
            <div class="armory-item-label">${escapeHtml(label)}</div>
            <div class="armory-item-category">${escapeHtml(category)}</div>
        </div>
        <button class="armory-item-btn">${window.T('take')}</button>
    `;

    const imageEl = card.querySelector('.armory-item-image');
    imageEl.dataset.candidates = imageCandidates.join('|');
    imageEl.dataset.index = '0';
    imageEl.onerror = function() {
        window.handleArmoryImageError(imageEl);
    };
    if (!tryLoadNextArmoryImage(imageEl)) {
        window.handleArmoryImageError(imageEl);
    }

    const takeBtn = card.querySelector('.armory-item-btn');
    takeBtn.addEventListener('click', function() {
        openTakeQuantityModal(entry.name, itemType, limit, label);
    });

    return card;
}

function populateArmorySection(listEl, entries, itemType, inventoryType) {
    listEl.innerHTML = '';
    if (!Array.isArray(entries) || entries.length === 0) {
        const emptyEl = document.createElement('div');
        emptyEl.className = 'armory-empty-state';
        emptyEl.innerText = 'No items configured for this section';
        listEl.appendChild(emptyEl);
        return;
    }

    entries.forEach(entry => {
        listEl.appendChild(createArmoryCard(entry, itemType, inventoryType));
    });
}

function setupArmory(data) {
    const container = document.getElementById('armory-container');
    const weaponsList = document.getElementById('armory-weapons-list');
    const itemsList = document.getElementById('armory-items-list');

    const inventoryType = String(data.inventoryType || 'qb').toLowerCase();
    container.dataset.inventoryType = inventoryType;
    document.getElementById('armory-dept-name').innerText = data.deptName || window.T("dept_armory_header");

    populateArmorySection(weaponsList, data.weapons || [], 'weapon', inventoryType);
    populateArmorySection(itemsList, data.items || [], 'item', inventoryType);

    container.classList.remove('hidden');
    applyTranslations(container);
}

function closeArmory() {
    closeTakeQuantityModal();
    document.getElementById('armory-container').classList.add('hidden');
    fetch(`https://${GetParentResourceName()}/closeArmory`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

function ensureTakeModal() {
    let modal = document.getElementById('armory-take-modal');
    if (modal) return modal;

    modal = document.createElement('div');
    modal.id = 'armory-take-modal';
    modal.className = 'armory-take-modal hidden';
    modal.innerHTML = `
        <div class="armory-take-card">
            <div class="armory-take-title">SELECT QUANTITY</div>
            <div class="armory-take-item" id="armory-take-item-name">ITEM</div>
            <div class="armory-take-range" id="armory-take-range">Allowed: 1+</div>
            <input id="armory-take-input" class="armory-take-input" type="number" min="1" value="1" />
            <div class="armory-take-actions">
                <button class="armory-take-btn cancel" onclick="closeTakeQuantityModal()">${window.T ? window.T('cancel') : 'CANCEL'}</button>
                <button class="armory-take-btn confirm" onclick="confirmTakeQuantity()">${window.T ? window.T('take') : 'TAKE'}</button>
            </div>
        </div>
    `;
    document.getElementById('armory-container').appendChild(modal);
    return modal;
}

function openTakeQuantityModal(name, type, limit, label) {
    const parsedLimit = Number(limit) || 0;
    armoryPendingTake = {
        name: name,
        type: type,
        limit: parsedLimit
    };

    const modal = ensureTakeModal();
    const itemNameEl = document.getElementById('armory-take-item-name');
    const rangeEl = document.getElementById('armory-take-range');
    const inputEl = document.getElementById('armory-take-input');

    itemNameEl.textContent = (label || name || 'ITEM').toUpperCase();
    rangeEl.textContent = parsedLimit > 0 ? `Allowed: 1-${parsedLimit}` : 'Allowed: 1+';
    inputEl.value = '1';
    inputEl.min = '1';
    if (parsedLimit > 0) {
        inputEl.max = String(parsedLimit);
    } else {
        inputEl.removeAttribute('max');
    }

    modal.classList.remove('hidden');
    setTimeout(() => inputEl.focus(), 0);
}

function closeTakeQuantityModal() {
    const modal = document.getElementById('armory-take-modal');
    if (modal) modal.classList.add('hidden');
    armoryPendingTake = null;
}

function confirmTakeQuantity() {
    if (!armoryPendingTake) return;

    const inputEl = document.getElementById('armory-take-input');
    const quantity = parseInt(inputEl ? inputEl.value : '1', 10);
    if (!Number.isInteger(quantity) || quantity < 1) return;
    if (armoryPendingTake.limit > 0 && quantity > armoryPendingTake.limit) return;

    fetch(`https://${GetParentResourceName()}/takeArmoryItem`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            name: armoryPendingTake.name,
            type: armoryPendingTake.type,
            quantity: quantity
        })
    });

    closeTakeQuantityModal();
}

// ESC Key handling
window.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        const takeModal = document.getElementById('armory-take-modal');
        if (takeModal && !takeModal.classList.contains('hidden')) {
            closeTakeQuantityModal();
            return;
        }
        const container = document.getElementById('armory-container');
        if (!container.classList.contains('hidden')) {
            closeArmory();
        }
    }
});

