(function () {
    const POS_KEY = 'cx_chat_pos_v1';
    const rootEl  = document.getElementById('root');

    let dragMode     = false;
    let dragging     = false;
    let ox = 0, oy = 0, startL = 0, startB = 0;
    let currentScale = 1.0;

    function clamp(v, lo, hi) { return Math.max(lo, Math.min(hi, v)); }

    function applyScale(s) {
        currentScale = s;
        rootEl.style.transform = s === 1 ? '' : 'scale(' + s + ')';
    }

    function applyPos(x, y, scale) {
        rootEl.style.left   = x + 'px';
        rootEl.style.bottom = y + 'px';
        rootEl.style.top    = '';
        applyScale(scale || 1.0);
    }

    function loadLocalPos() {
        try {
            const s = JSON.parse(localStorage.getItem(POS_KEY));
            if (s) applyPos(s.x, s.y, s.scale);
        } catch (_) {}
    }

    function savePos() {
        try {
            const r    = rootEl.getBoundingClientRect();
            const data = { x: r.left, y: window.innerHeight - r.bottom, scale: currentScale };
            localStorage.setItem(POS_KEY, JSON.stringify(data));
            window.nui('savePosition', data);
        } catch (_) {}
    }

    function clearPos() {
        try { localStorage.removeItem(POS_KEY); } catch (_) {}
        window.nui('clearSavedPosition', {});
    }

    const toast = document.createElement('div');
    toast.id = 'chat-drag-toast';
    toast.innerHTML = `
        <i class="fa-solid fa-up-down-left-right"></i>
        <span>Drag to move</span>
        <div class="drag-scale-wrap">
            <i class="fa-solid fa-magnifying-glass-minus"></i>
            <input type="range" id="chat-scale-slider" min="60" max="150" value="100" step="5" />
            <i class="fa-solid fa-magnifying-glass-plus"></i>
            <span id="chat-scale-val">100%</span>
        </div>
        <button id="chat-pos-reset" title="Reset to default position"><i class="fa-solid fa-rotate-left"></i></button>
        <button id="chat-drag-done">Done</button>
    `;
    document.body.appendChild(toast);

    const scaleSlider = document.getElementById('chat-scale-slider');
    const scaleVal    = document.getElementById('chat-scale-val');

    scaleSlider.addEventListener('input', () => {
        const s = scaleSlider.value / 100;
        applyScale(s);
        scaleVal.textContent = scaleSlider.value + '%';
    });

    document.getElementById('chat-pos-reset').addEventListener('click', () => {
        applyPos(20, Math.round(window.innerHeight * 0.5 - 60), 1.0);
        scaleSlider.value    = '100';
        scaleVal.textContent = '100%';
        clearPos();
    });

    document.getElementById('chat-drag-done').addEventListener('click', exitDragMode);

    function enterDragMode() {
        dragMode = true;
        rootEl.classList.add('drag-mode');
        toast.classList.add('visible');
        document.getElementById('btn-move').classList.add('active');
        scaleSlider.value    = Math.round(currentScale * 100);
        scaleVal.textContent = scaleSlider.value + '%';
    }

    function exitDragMode() {
        dragMode = false;
        dragging = false;
        rootEl.classList.remove('drag-mode');
        toast.classList.remove('visible');
        document.getElementById('btn-move').classList.remove('active');
        savePos();
    }

    rootEl.addEventListener('pointerdown', e => {
        if (!dragMode) return;
        dragging = true;
        ox = e.clientX;
        oy = e.clientY;
        const r = rootEl.getBoundingClientRect();
        startL = r.left;
        startB = window.innerHeight - r.bottom;
        rootEl.setPointerCapture(e.pointerId);
        e.preventDefault();
    });

    rootEl.addEventListener('pointermove', e => {
        if (!dragging) return;
        const scaledW = rootEl.offsetWidth  * currentScale;
        const scaledH = rootEl.offsetHeight * currentScale;
        rootEl.style.left   = clamp(startL + (e.clientX - ox), 0, Math.max(0, window.innerWidth  - scaledW)) + 'px';
        rootEl.style.bottom = clamp(startB - (e.clientY - oy), 0, Math.max(0, window.innerHeight - scaledH)) + 'px';
    });

    rootEl.addEventListener('pointerup', () => { dragging = false; });

    document.addEventListener('keydown', e => {
        if (e.key === 'Escape' && dragMode) exitDragMode();
    });

    document.getElementById('btn-move').addEventListener('click', () => {
        if (dragMode) exitDragMode(); else enterDragMode();
    });

    loadLocalPos();

    window.addEventListener('cx:posReady', e => {
        const s = e.detail;
        if (s && s.x != null) applyPos(s.x, s.y, s.scale || 1.0);
    });

    window.chatReposition = {
        reset() {
            applyPos(20, Math.round(window.innerHeight * 0.5 - 60), 1.0);
            clearPos();
        }
    };
})();
