let allPoses = {};
let activeKeybinds = {};
let selectedPoseForKb = null;

window.addEventListener('message', function(event) {
    const data = event.data;

    if (data.action === "openPoses") {
        allPoses = data.animations;
        activeKeybinds = data.keybinds;
        document.getElementById('poses-container').classList.remove('hidden');
        renderPoses();
    }
});

function renderPoses(filter = "") {
    const list = document.getElementById('poses-list');
    list.innerHTML = "";

    const sortedIds = Object.keys(allPoses).sort();
    
    sortedIds.forEach(id => {
        const pose = allPoses[id];
        if (filter && !pose.label.toLowerCase().includes(filter.toLowerCase()) && !id.toLowerCase().includes(filter.toLowerCase())) {
            return;
        }

        const kb = activeKeybinds[id];
        const card = document.createElement('div');
        card.className = "pose-card";
        card.innerHTML = `
            <div class="pose-icon"><i class="fas fa-person"></i></div>
            <div class="pose-info" onclick="window.playPose('${id}')">
                <span class="pose-label">${pose.label}</span>
                <span class="pose-id">${id}</span>
            </div>
            <div class="pose-keybind ${kb ? '' : 'empty'}" onclick="window.openKeybindModal('${id}')">
                ${kb ? kb : '<i class="fas fa-plus"></i>'}
            </div>
        `;
        list.appendChild(card);
        applyTranslations(card);
    });
}

window.closePoses = function() {
    document.getElementById('poses-container').classList.add('hidden');
    fetch(`https://${GetParentResourceName()}/closePoses`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
};

window.playPose = function(id) {
    fetch(`https://${GetParentResourceName()}/playPose`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id: id })
    });
};

window.stopPose = function() {
    fetch(`https://${GetParentResourceName()}/stopPose`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
};

window.openKeybindModal = function(id) {
    selectedPoseForKb = id;
    const existingKey = activeKeybinds[id];
    
    let modal = document.createElement('div');
    modal.className = "kb-overlay";
    modal.id = "kb-modal-overlay";
    
    let keysHtml = "";
    for(let i=1; i<=9; i++) {
        keysHtml += `<div class="kb-key ${existingKey == i ? 'active' : ''}" onclick="window.saveKeybind('${i}')">${i}</div>`;
    }
    keysHtml += `<div class="kb-key ${existingKey == '0' ? 'active' : ''}" onclick="window.saveKeybind('0')">0</div>`;

    modal.innerHTML = `
        <div class="kb-modal">
            <h3>${window.T('assign_keybind')}</h3>
            <p>${window.T('select_key_for', { label: allPoses[id].label })}</p>
            <div class="kb-grid">${keysHtml}</div>
            <div class="kb-actions">
                <button class="kb-btn clear" onclick="window.saveKeybind(null)">${window.T('clear_key')}</button>
                <button class="kb-btn cancel" onclick="window.closeKbModal()">${window.T('cancel')}</button>
            </div>
        </div>
    `;
    document.body.appendChild(modal);
};

window.closeKbModal = function() {
    const modal = document.getElementById('kb-modal-overlay');
    if (modal) modal.remove();
    selectedPoseForKb = null;
};

window.saveKeybind = function(key) {
    if (!selectedPoseForKb) return;

    fetch(`https://${GetParentResourceName()}/setKeybind`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id: selectedPoseForKb, key: key })
    }).then(() => {
        // Update local copy
        if (key === null) {
            delete activeKeybinds[selectedPoseForKb];
        } else {
            // Remove this key from any other pose
            for (let pid in activeKeybinds) {
                if (activeKeybinds[pid] === key) {
                    delete activeKeybinds[pid];
                }
            }
            activeKeybinds[selectedPoseForKb] = key;
        }
        renderPoses(document.getElementById('poses-search').value);
        window.closeKbModal();
    });
};

document.getElementById('poses-search').addEventListener('input', function(e) {
    renderPoses(e.target.value);
});

document.addEventListener('keydown', function(event) {
    if (event.key === "Escape") {
        if (document.getElementById('kb-modal-overlay')) {
            window.closeKbModal();
        } else if (!document.getElementById('poses-container').classList.contains('hidden')) {
            window.closePoses();
        }
    }
});

