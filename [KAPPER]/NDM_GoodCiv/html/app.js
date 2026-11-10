(() => {
    const resource = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'ndm_goodciv';
    const $ = (sel, root = document) => root.querySelector(sel);

    const post = (name, body = {}) =>
        fetch(`https://${resource}/${name}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify(body),
        }).catch(() => {});

    const escapeHtml = (s) =>
        String(s ?? '').replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));

    const tagsHtml = (tags = []) => tags.map((t) => `<span class="tag">${escapeHtml(t)}</span>`).join('');

    /* Toasts ---------------------------------------------------------- */
    function toast({ type = 'info', text }) {
        const el = document.createElement('div');
        el.className = `toast ${type}`;
        el.textContent = text;
        $('#toasts').appendChild(el);
        setTimeout(() => el.classList.add('out'), 5000);
        setTimeout(() => el.remove(), 5400);
    }

    /* Alerts ---------------------------------------------------------- */
    function alert(data) {
        dismissAlert({ id: data.id });
        const el = document.createElement('div');
        el.className = 'card alert';
        el.dataset.id = data.id;
        el.innerHTML = `
            <div class="eyebrow"><span class="dot"></span>${escapeHtml(data.title)}</div>
            <h2>Someone needs help nearby</h2>
            <div class="tags">${tagsHtml(data.tags)}</div>
            <div class="meta">${escapeHtml(data.street || 'Unknown location')} &middot; ${data.distance} m away</div>
            <div class="buttons">
                <button class="primary" data-alert="accept">Respond <kbd>${escapeHtml(data.acceptKey)}</kbd></button>
                <button data-alert="decline">Decline <kbd>${escapeHtml(data.declineKey)}</kbd></button>
            </div>
            <div class="timer"><div></div></div>`;
        $('#alerts').appendChild(el);
        const bar = $('.timer div', el);
        bar.animate([{ width: '100%' }, { width: '0%' }], { duration: data.timeout * 1000, fill: 'forwards' });
    }

    function dismissAlert({ id }) {
        const el = $(`.alert[data-id="${id}"]`);
        if (el) el.remove();
    }

    $('#alerts').addEventListener('click', (e) => {
        const btn = e.target.closest('[data-alert]');
        if (btn) post(btn.dataset.alert);
    });

    /* Patient card ---------------------------------------------------- */
    function patientStatus(data) {
        const el = $('#patient');
        if (!data) return el.classList.add('hidden');
        el.classList.remove('hidden');
        if (data.transport) {
            $('.patient-title', el).textContent = 'On the way to hospital';
            $('.patient-sub', el).textContent = data.transport;
        } else if (data.responders > 0) {
            $('.patient-title', el).textContent = 'Help is on the way';
            $('.patient-sub', el).textContent = `GoodCiv volunteer${data.responders > 1 ? 's' : ''}: ${(data.names || []).join(', ')}`;
        } else {
            $('.patient-title', el).textContent = 'Waiting for a volunteer';
            $('.patient-sub', el).textContent = 'No medics are on duty. Nearby GoodCiv volunteers have been alerted.';
        }
    }

    /* Advice ------------------------------------------------------------ */
    function nextStep(inc) {
        const s = inc.state;
        if (inc.transport && !s.breathing) return { text: 'Your patient has stopped breathing! Pull over, unload them and start CPR.', urgent: true, action: 'unload' };
        if (inc.transport) return { text: `Patient onboard. Drive carefully to ${inc.transport.hospital} and hand over.`, action: null };
        if (s.bleeding === 'major') return { text: 'Life-threatening bleeding. Apply a tourniquet first.', urgent: true, action: 'tourniquet' };
        if (!inc.assessed) return { text: 'Check the patient: are they responsive and breathing?', action: 'assess' };
        if (!s.breathing) return { text: 'Not breathing. Start CPR now and keep going until they breathe.', urgent: true, action: 'cpr' };
        if (!s.conscious && !s.recovery) return { text: 'Breathing but unresponsive. Place them in the recovery position.', action: 'recovery' };
        return { text: `Patient is stable. Bring them round, or load them into a vehicle and take them to ${inc.hospital || 'hospital'}.`, action: 'revive' };
    }

    /* Responder HUD -------------------------------------------------- */
    function responderHud(inc) {
        const el = $('#hud');
        if (!inc) return el.classList.add('hidden');
        el.classList.remove('hidden');
        $('.hud-tags', el).innerHTML = tagsHtml(inc.tags);
        $('.hud-step', el).textContent = inc.transport
            ? `Take the patient to ${inc.transport.hospital}. Press your treat key there to hand over.`
            : 'Get to the patient and press your treat key (default G).';
    }

    /* Treatment panel ------------------------------------------------ */
    let current = null;

    function setVital(name, text, cls) {
        const v = $(`.vital[data-vital="${name}"]`);
        v.className = `vital ${cls}`;
        $('strong', v).textContent = text;
    }

    function treatment(inc) {
        const el = $('#treatment');
        current = inc || null;
        if (!inc) {
            el.classList.add('hidden');
            stopCpr();
            return;
        }
        el.classList.remove('hidden');
        const s = inc.state;

        setVital('conscious', s.conscious ? 'Alert' : 'Unresponsive', s.conscious ? 'good' : 'bad');
        if (inc.assessed) {
            setVital('breathing', s.breathing ? 'Breathing' : 'None', s.breathing ? 'good' : 'bad');
        } else {
            setVital('breathing', 'Not checked', 'unknown');
        }
        const bleed = { none: ['None seen', 'good'], major: ['Catastrophic', 'bad'], controlled: ['Controlled', 'good'] }[s.bleeding];
        setVital('bleeding', bleed[0], bleed[1]);
        setVital('position', inc.transport ? 'In vehicle' : s.recovery ? 'Recovery' : 'On back', s.recovery || inc.transport ? 'good' : '');

        const step = nextStep(inc);
        const advice = $('.advice');
        advice.textContent = step.text;
        advice.classList.toggle('urgent', !!step.urgent);

        const enabled = {
            assess: !inc.transport,
            tourniquet: !inc.transport && s.bleeding === 'major',
            cpr: !inc.transport && inc.assessed && !s.breathing,
            recovery: !inc.transport && inc.assessed && s.breathing && !s.conscious && !s.recovery,
            revive: !inc.transport && inc.assessed && inc.stable,
            load: !inc.transport && inc.stable,
            unload: !!inc.transport,
        };
        document.querySelectorAll('.actions [data-action]').forEach((btn) => {
            const name = btn.dataset.action;
            btn.disabled = !enabled[name];
            btn.classList.toggle('recommended', step.action === name && enabled[name]);
        });
        $('.load-sub').textContent = inc.hospital ? `Nearest vehicle, to ${inc.hospital}` : 'Nearest vehicle, to hospital';
        $('.responders').textContent = `${inc.responders}/${inc.maxResponders} GoodCiv responders on this call`;
    }

    document.querySelector('.actions').addEventListener('click', (e) => {
        const btn = e.target.closest('[data-action]');
        if (btn && !btn.disabled) post('action', { name: btn.dataset.action });
    });

    document.querySelectorAll('[data-cb]').forEach((btn) =>
        btn.addEventListener('click', () => post(btn.dataset.cb)));

    /* Progress bar --------------------------------------------------- */
    let progressAnim = null;
    function progress(data) {
        const el = $('#progress');
        if (progressAnim) progressAnim.cancel();
        if (!data) return el.classList.add('hidden');
        el.classList.remove('hidden');
        $('.progress-label', el).textContent = data.label;
        progressAnim = $('.fill', el).animate([{ width: '0%' }, { width: '100%' }], {
            duration: data.duration * 1000,
            fill: 'forwards',
        });
    }

    /* CPR rhythm minigame ------------------------------------------- */
    let cpr = null;

    function startCpr({ duration, bpm }) {
        stopCpr();
        const [lo, hi] = bpm;
        const mid = (lo + hi) / 2;
        const el = $('#cpr');
        el.classList.remove('hidden');
        cpr = {
            lo, hi, duration,
            presses: [],
            scores: [],
            endsAt: performance.now() + duration * 1000,
            beat: setInterval(() => {
                const b = $('.beat', el);
                b.classList.remove('tick');
                void b.offsetWidth;
                b.classList.add('tick');
            }, 60000 / mid),
            done: setTimeout(finishCpr, duration * 1000),
        };
        $('.cpr-bpm').textContent = '--';
        $('.cpr-quality').textContent = '--';
        $('.cpr-count').textContent = '0';
        cpr.timeAnim = $('.cpr-time').animate([{ width: '0%' }, { width: '100%' }], { duration: duration * 1000, fill: 'forwards' });
    }

    function compress() {
        if (!cpr) return;
        const t = performance.now();
        const press = $('#cpr .press');
        const last = cpr.presses[cpr.presses.length - 1];
        cpr.presses.push(t);
        $('.cpr-count').textContent = cpr.presses.length;
        if (last !== undefined) {
            const rate = 60000 / (t - last);
            // Full marks inside the target band, falling to zero 25 bpm outside it.
            const off = rate < cpr.lo ? cpr.lo - rate : rate > cpr.hi ? rate - cpr.hi : 0;
            const score = Math.max(0, 1 - off / 25);
            cpr.scores.push(score);
            $('.cpr-bpm').textContent = Math.round(rate);
            $('.cpr-quality').textContent = `${Math.round(average() * 100)}%`;
            press.classList.toggle('good', score >= 0.8);
            press.classList.toggle('bad', score < 0.4);
        }
        press.classList.add('down');
        setTimeout(() => press.classList.remove('down'), 90);
    }

    function average() {
        if (!cpr || cpr.scores.length === 0) return 0;
        return cpr.scores.reduce((a, b) => a + b, 0) / cpr.scores.length;
    }

    function quality() {
        if (!cpr || cpr.scores.length === 0) return 0;
        const avg = average();
        // Too few compressions also hurts: expect ~80% of the ideal count.
        const expected = (cpr.duration * (cpr.lo + cpr.hi)) / 120;
        const coverage = Math.min(1, cpr.scores.length / (expected * 0.8));
        return avg * coverage;
    }

    function finishCpr() {
        if (!cpr) return;
        const q = quality();
        stopCpr();
        post('cprResult', { quality: q });
    }

    function stopCpr() {
        if (!cpr) return;
        clearInterval(cpr.beat);
        clearTimeout(cpr.done);
        if (cpr.timeAnim) cpr.timeAnim.cancel();
        cpr = null;
        $('#cpr').classList.add('hidden');
    }

    $('#cpr .metronome').addEventListener('mousedown', compress);

    window.addEventListener('keydown', (e) => {
        if (e.code === 'Space' && cpr) {
            e.preventDefault();
            if (!e.repeat) compress();
        } else if (e.key === 'Escape' && configOpen) {
            post('cfgClose');
        } else if (e.key === 'Escape' && current && !cpr) {
            post('close');
        }
    });

    /* Down card ------------------------------------------------------ */
    function down(data) {
        const el = $('#down');
        if (!data) return el.classList.add('hidden');
        el.classList.remove('hidden');
        $('.down-title', el).textContent = data.title;
        const hint = $('.down-hint', el);
        hint.textContent = data.hint || '';
        hint.classList.toggle('hidden', !data.hint);
        const respawn = $('.down-respawn', el);
        respawn.textContent = data.respawn || '';
        respawn.classList.toggle('hidden', !data.respawn);
        const hold = $('.down-hold', el);
        hold.classList.toggle('hidden', !(data.hold > 0));
        $('.fill', hold).style.width = `${Math.round((data.hold || 0) * 100)}%`;
    }

    /* Injury badge --------------------------------------------------- */
    function injury(data) {
        const el = $('#injury');
        if (!data) return el.classList.add('hidden');
        el.classList.remove('hidden');
        $('.injury-title', el).textContent = data.title;
        $('.injury-text', el).textContent = data.text;
    }

    /* Check-in point creator ------------------------------------------ */
    let configOpen = false;
    let configDefaults = { fee: 0, radius: 30 };

    function config(data) {
        const el = $('#config');
        configOpen = !!data;
        if (!data) return el.classList.add('hidden');
        const wasHidden = el.classList.contains('hidden');
        el.classList.remove('hidden');
        configDefaults = data.defaults || configDefaults;
        const form = $('.cfg-form', el);
        $('.cfg-fee', el).classList.toggle('hidden', !data.economy);
        if (wasHidden) {
            form.label.value = '';
            form.fee.value = configDefaults.fee;
            form.radius.value = configDefaults.radius;
        }

        const list = $('.cfg-list', el);
        if (!data.hospitals.length) {
            list.innerHTML = '<div class="cfg-empty">No check-in points yet.</div>';
            return;
        }
        list.innerHTML = data.hospitals.map((h) => `
            <div class="cfg-row" data-id="${escapeHtml(h.id)}">
                <div class="cfg-main">
                    ${h.custom
                        ? `<input class="cfg-label" value="${escapeHtml(h.label)}" maxlength="48">`
                        : `<strong>${escapeHtml(h.label)}</strong><span class="cfg-badge">config.lua</span>`}
                    <div class="cfg-meta">
                        ${data.economy ? (h.custom
                            ? `Fee $<input class="cfg-num cfg-rowfee" type="number" min="0" value="${h.fee ?? configDefaults.fee}">`
                            : `Fee $${h.fee ?? configDefaults.fee}`) : ''}
                        ${h.custom
                            ? `Zone <input class="cfg-num cfg-radius" type="number" min="5" max="250" value="${h.radius}"> m`
                            : `Zone ${h.radius} m`}
                        &middot; ${h.distance} m away
                    </div>
                </div>
                <div class="cfg-buttons">
                    <button data-row="tp">Go to</button>
                    ${h.custom ? `
                        <button data-row="save">Save</button>
                        <button data-row="move">Move here</button>
                        <button data-row="remove" class="danger">Delete</button>` : ''}
                </div>
            </div>`).join('');
    }

    $('.cfg-form').addEventListener('submit', (e) => {
        e.preventDefault();
        const f = e.target;
        post('cfgAdd', { label: f.label.value, fee: Number(f.fee.value), radius: Number(f.radius.value) });
        f.label.value = '';
    });

    $('.cfg-list').addEventListener('click', (e) => {
        const btn = e.target.closest('[data-row]');
        if (!btn) return;
        const row = btn.closest('.cfg-row');
        const id = row.dataset.id;
        const action = btn.dataset.row;
        if (action === 'tp') post('cfgTeleport', { id });
        else if (action === 'move') post('cfgMove', { id });
        else if (action === 'remove') {
            if (btn.dataset.confirm) post('cfgRemove', { id });
            else { btn.dataset.confirm = '1'; btn.textContent = 'Confirm?'; }
        } else if (action === 'save') {
            const fee = $('.cfg-rowfee', row);
            post('cfgUpdate', {
                id,
                label: $('.cfg-label', row).value,
                fee: fee ? Number(fee.value) : configDefaults.fee,
                radius: Number($('.cfg-radius', row).value),
            });
        }
    });

    $('[data-cfg="close"]').addEventListener('click', () => post('cfgClose'));

    /* Message router ------------------------------------------------- */
    const handlers = {
        toast,
        alert,
        dismissAlert,
        patientStatus,
        responderHud,
        treatment,
        progress,
        cpr: startCpr,
        cprCancel: stopCpr,
        down,
        injury,
        config,
    };

    window.addEventListener('message', (e) => {
        const { action, data } = e.data || {};
        if (handlers[action]) handlers[action](data);
    });
})();
