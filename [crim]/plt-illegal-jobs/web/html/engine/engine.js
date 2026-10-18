const MG = (function () {
    const games = {};
    let current = null;
    let raf = null;
    let timer = null;
    let ended = false;
    let sessionNonce = null;   // per-game token from Lua; required to report a result

    const $ = (id) => document.getElementById(id);

    /* ---- Result bridge (embedded in illegal-jobs NUI parent) ---- */
    function post(name, body) {
        if (name === 'result') {
            try {
                window.parent.postMessage({
                    type: 'pluto:minigame-result',
                    success: !!(body && body.success),
                }, '*');
            } catch (e) {}
            return;
        }
    }

    /* ---- Timer ---- */
    function startTimer(seconds, onExpire) {
        timer = { duration: seconds * 1000, start: performance.now(), onExpire };
        tick();
    }
    function tick() {
        if (!timer) return;
        const elapsed = performance.now() - timer.start;
        const remain = Math.max(0, timer.duration - elapsed);
        const pct = remain / timer.duration;
        $('timer-fill').style.width = (pct * 100) + '%';
        $('timer-text').textContent = (remain / 1000).toFixed(1);
        $('timer-fill').style.background = pct < 0.25
            ? 'linear-gradient(90deg, var(--danger), #fff)'
            : 'linear-gradient(90deg, var(--accent), #fff)';
        if (remain <= 0) {
            const fn = timer.onExpire; timer = null;
            if (fn) fn();
            return;
        }
        raf = requestAnimationFrame(tick);
    }
    function stopTimer() {
        if (raf) cancelAnimationFrame(raf);
        raf = null; timer = null;
    }
    function addTime(ms) {
        if (timer) timer.start += ms;
    }

    /* ---- Round dots ---- */
    function setDots(total, states) {
        const c = $('dots'); c.innerHTML = '';
        for (let i = 0; i < total; i++) {
            const d = document.createElement('div');
            d.className = 'dot' + (states && states[i] ? ' ' + states[i] : '');
            c.appendChild(d);
        }
    }

    /* ---- Lifecycle ---- */
    function open(payload) {
        ended = false;
        sessionNonce = payload.nonce || null;
        if (typeof SFX !== 'undefined') {
            if (payload.sound === false) SFX.setEnabled(false);
            else SFX.setEnabled(true);
            if (typeof payload.volume === 'number') SFX.setVolume(payload.volume);
        }
        const game = games[payload.game];
        $('root').classList.remove('hidden');
        $('flash').className = 'hidden';

        const name = game ? game.title : payload.game;
        $('hud-name').textContent = name;
        $('hud-tag').textContent = 'SECURE TASK';
        $('hint').textContent = (game && game.hint) ? game.hint : '';
        $('board').innerHTML = '';
        setDots(0);

        if (!game) { return end(false); }

        const api = {
            board: $('board'),
            cfg: payload,
            startTimer, stopTimer, addTime, setDots,
            setHint: (t) => { $('hint').textContent = t || ''; },
            setTag:  (t) => { $('hud-tag').textContent = t || ''; },
            succeed: () => end(true),
            fail:    () => end(false),
            shake:   () => { $('stage').classList.add('shake');
                             if (typeof SFX !== 'undefined') SFX.play('bad');
                             setTimeout(() => $('stage').classList.remove('shake'), 320); },
            sfx:     (name) => { if (typeof SFX !== 'undefined') SFX.play(name); },
            rand: (a, b) => a + Math.random() * (b - a),
            randInt: (a, b) => Math.floor(a + Math.random() * (b - a + 1))
        };

        current = game.run(api) || {};
        current.__allowCancel = payload.allowCancel !== false;
        $('hud-timer').style.visibility = 'visible';
    }

    function cleanup() {
        stopTimer();
        if (current && typeof current.destroy === 'function') {
            try { current.destroy(); } catch (e) {}
        }
        current = null;
        document.onkeydown = null;
    }

    function end(success) {
        if (ended) return;
        ended = true;
        cleanup();
        if (typeof SFX !== 'undefined') SFX.play(success ? 'success' : 'fail');

        const flash = $('flash');
        flash.className = success ? 'win' : 'lose';
        $('flash-text').textContent = success ? 'Success' : 'Failed';

        setTimeout(() => {
            $('root').classList.add('hidden');
            flash.className = 'hidden';
            $('board').innerHTML = '';
            post('result', { success: success, nonce: sessionNonce });
            sessionNonce = null;
        }, 850);
    }

    /* ---- Global cancel key ---- */
    document.addEventListener('keydown', (e) => {
        if (ended || !current) return;
        if (e.key === 'Escape') {
            const allow = current.__allowCancel !== false;
            if (allow) end(false);
        }
    });

    /* Resolve letter from key / code (CEF sometimes gives odd key values) */
    function resolveKeyLetter(data) {
        if (!data) return '';
        const key = data.key || '';
        if (key && key.length === 1) return key;
        const code = data.code || '';
        const m = /^Key([A-Z])$/i.exec(code);
        if (m) return m[1];
        return key;
    }

    /* Replay a parent-forwarded key into this iframe document */
    function dispatchForwardedKey(data) {
        if (ended || !current || !data) return;
        const type = data.type === 'keyup' ? 'keyup' : 'keydown';
        const key = resolveKeyLetter(data) || data.key || '';
        const init = {
            key: key,
            code: data.code || '',
            keyCode: data.keyCode || 0,
            which: data.which || data.keyCode || 0,
            bubbles: true,
            cancelable: true,
            repeat: !!data.repeat,
        };
        try {
            document.dispatchEvent(new KeyboardEvent(type, init));
        } catch (err) {
            /* Older CEF fallback */
            const ev = document.createEvent('Event');
            ev.initEvent(type, true, true);
            ev.key = key;
            ev.code = data.code || '';
            ev.keyCode = data.keyCode || 0;
            ev.which = data.which || data.keyCode || 0;
            document.dispatchEvent(ev);
        }
    }

    /* ---- Message in from Lua / parent React host ---- */
    window.addEventListener('message', (ev) => {
        const d = ev.data || {};
        if (d.action === 'open') open(d.payload || {});
        else if (d.action === 'pluto:engine-key') dispatchForwardedKey(d);
    });

    return {
        games,
        register(id, def) { games[id] = def; },
        open,
        _internal: { end }
    };
})();

window.MG = MG;
