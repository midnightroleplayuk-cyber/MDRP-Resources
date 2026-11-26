(() => {
    const W = 320, H = 240, TOP = 16, SCALE = 3;
    const FONT = '"Courier New", Consolas, monospace';
    const AMBER = '#e8c860', DIM = '#7d7350', WHITE = '#e6e6da', RED = '#d6553f', GREEN = '#7fc66a';

    const cab = document.getElementById('cab');
    const cv = document.getElementById('screen');
    const g = cv.getContext('2d');
    cv.width = W * SCALE;
    cv.height = H * SCALE;
    g.scale(SCALE, SCALE);
    g.imageSmoothingEnabled = false;

    const inGame = typeof GetParentResourceName === 'function';
    const resName = inGame ? GetParentResourceName() : 'RSVX_Arcade';

    function post(name, data) {
        if (!inGame) return Promise.resolve(null);
        return fetch(`https://${resName}/${name}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data || {}),
        }).then(r => r.json()).catch(() => null);
    }

    let actx;
    function beep(freq, dur, type) {
        try {
            actx = actx || new (window.AudioContext || window.webkitAudioContext)();
            const o = actx.createOscillator(), v = actx.createGain();
            o.type = type || 'square';
            o.frequency.value = freq;
            v.gain.value = 0.04;
            v.gain.exponentialRampToValueAtTime(0.0001, actx.currentTime + dur);
            o.connect(v); v.connect(actx.destination);
            o.start(); o.stop(actx.currentTime + dur);
        } catch (e) { }
    }

    function bell(volume) {
        try {
            actx = actx || new (window.AudioContext || window.webkitAudioContext)();
            if (actx.state === 'suspended') actx.resume();
            const now = actx.currentTime, out = actx.createGain();
            out.gain.value = Math.max(0, Math.min(1, volume == null ? 0.6 : volume));
            out.connect(actx.destination);
            const root = 1320;
            [[0.5, 0.25, 2.6], [1, 1, 2.2], [2.0, 0.6, 1.5], [2.76, 0.45, 1.1], [4.07, 0.3, 0.7], [5.43, 0.2, 0.45], [6.8, 0.12, 0.3]]
                .forEach(([ratio, level, life]) => {
                    const o = actx.createOscillator(), v = actx.createGain();
                    o.frequency.value = root * ratio;
                    v.gain.setValueAtTime(0.0001, now);
                    v.gain.exponentialRampToValueAtTime(level * 0.3, now + 0.004);
                    v.gain.exponentialRampToValueAtTime(0.0001, now + life);
                    o.connect(v); v.connect(out);
                    o.start(now); o.stop(now + life + 0.05);
                });
        } catch (e) { }
    }

    function text(str, x, y, color, size, align) {
        g.font = `bold ${size || 8}px ${FONT}`;
        g.textAlign = align || 'left';
        g.textBaseline = 'top';
        g.fillStyle = color || WHITE;
        g.fillText(str, x, y);
    }

    let mode = 'off';
    let def, game, score = 0, board = [], result = null, info = {}, clock = 0;
    const held = {};

    const api = {
        W, H, TOP, text, beep, bell,
        get tune() { return (info && info.tune) || {}; },
        add(n) { score += n; },
        get score() { return score; },
        held: code => !!held[code],
        end() { if (mode === 'play') finish(); },
    };

    function hiScore() {
        return Math.max(board.length ? board[0].score : 0, score);
    }

    function begin() {
        score = 0;
        result = null;
        for (const k in held) delete held[k];
        game = def.init(api);
        mode = 'play';
        beep(520, 0.08);
    }

    function finish() {
        mode = 'wait';
        post('gameOver', { score }).then(r => {
            if (mode !== 'wait') return;
            result = r || {};
            if (result.board) board = result.board;
            mode = 'over';
        });
    }

    function retry() {
        mode = 'wait';
        result = null;
        post('retry').then(r => {
            if (mode !== 'wait') return;
            if (r && r.ok) {
                if (r.board) board = r.board;
                begin();
            } else if (!inGame) {
                begin();
            } else {
                result = { error: (r && r.error) || 'NO CREDIT' };
                mode = 'over';
            }
        });
    }

    function close() {
        mode = 'off';
        game = null;
        cab.hidden = true;
        post('close');
    }

    function open(data) {
        def = (window.RSVXGames || {})[data.game];
        if (!def) return post('close');
        info = data;
        board = data.board || [];
        score = 0;
        result = null;
        document.getElementById('title').textContent = def.title;
        document.getElementById('help').textContent = def.help;
        document.getElementById('credit').textContent =
            data.price > 0 ? `${data.currency}${data.price} PER PLAY` : 'FREE PLAY';
        cab.hidden = false;
        mode = 'title';
    }

    function drawBoard(y) {
        text('TOP TEN', W / 2, y, DIM, 8, 'center');
        if (!board.length) {
            text('NO SCORES YET', W / 2, y + 16, DIM, 8, 'center');
            return;
        }
        board.forEach((row, i) => {
            const yy = y + 14 + i * 10;
            const c = i === 0 ? AMBER : WHITE;
            text(String(i + 1).padStart(2, ' '), 84, yy, DIM);
            text(String(row.name).toUpperCase().slice(0, 16), 104, yy, c);
            text(String(row.score), 236, yy, c, 8, 'right');
        });
    }

    function drawHud() {
        g.fillStyle = '#0c1016';
        g.fillRect(0, 0, W, TOP - 2);
        g.fillStyle = '#232a33';
        g.fillRect(0, TOP - 2, W, 1);
        text('SCORE ' + score, 6, 3, WHITE);
        text('HI ' + hiScore(), W - 6, 3, AMBER, 8, 'right');
    }

    function frame(dt) {
        g.fillStyle = '#05070a';
        g.fillRect(0, 0, W, H);
        const blink = Math.floor(clock * 2) % 2 === 0;

        if (mode === 'title') {
            text(def.title, W / 2, 26, AMBER, 22, 'center');
            if (def.noBoard) (def.blurb || []).forEach((l, i) => text(l, W / 2, 96 + i * 14, WHITE, 9, 'center'));
            else drawBoard(70);
            if (blink) text('PRESS ENTER TO START', W / 2, 206, WHITE, 9, 'center');
        } else if (mode === 'play') {
            game.update(dt);
            if (game) game.draw(g);
            if (!def.noScore) drawHud();
        } else if (mode === 'wait') {
            if (game) game.draw(g);
            if (!def.noScore) drawHud();
            g.fillStyle = 'rgba(5,7,10,.75)';
            g.fillRect(0, 100, W, 40);
            text('PLEASE WAIT', W / 2, 116, WHITE, 9, 'center');
        } else if (mode === 'over') {
            text(def.overTitle || 'GAME OVER', W / 2, 18, def.overTitle ? AMBER : RED, 18, 'center');
            if (!def.noScore) text('SCORE ' + score, W / 2, 42, WHITE, 10, 'center');
            let line = '';
            let color = GREEN;
            if (result.error) { line = String(result.error).toUpperCase(); color = RED; }
            else if (result.rejected) { line = 'SCORE NOT SAVED'; color = RED; }
            else if (result.best) line = 'NEW PERSONAL BEST';
            if (result.tickets > 0) line += (line ? '   ' : '') + `+${result.tickets} TICKETS`;
            if (result.reward) line += (line ? '   ' : '') + 'BONUS ' + String(result.reward).toUpperCase();
            if (result.prize) line = 'YOU WON ' + String(result.prize).toUpperCase();
            else if (result.prize === false) { line = 'IT SLIPPED. NO PRIZE THIS TIME'; color = DIM; }
            if (line) text(line, W / 2, 56, color, 8, 'center');
            if (!def.noBoard) drawBoard(74);
            if (blink) {
                const cost = info.price > 0 ? ` (${info.currency}${info.price})` : '';
                text('ENTER  PLAY AGAIN' + cost, W / 2, 212, WHITE, 9, 'center');
            }
        }
    }

    let last = 0;
    function loop(t) {
        const dt = Math.min((t - last) / 1000, 0.05);
        last = t;
        clock += dt;
        if (mode !== 'off') frame(dt);
        requestAnimationFrame(loop);
    }
    requestAnimationFrame(loop);

    const ALIAS = { KeyW: 'ArrowUp', KeyS: 'ArrowDown', KeyA: 'ArrowLeft', KeyD: 'ArrowRight', NumpadEnter: 'Enter' };

    window.addEventListener('keydown', e => {
        if (mode === 'off') return;
        e.preventDefault();
        const code = ALIAS[e.code] || e.code;
        if (code === 'Escape') return close();
        if (mode === 'play') {
            if (!e.repeat) {
                held[code] = true;
                game.key(code, true);
            }
        } else if (code === 'Enter' && !e.repeat) {
            if (mode === 'title') begin();
            else if (mode === 'over') retry();
        }
    });

    window.addEventListener('keyup', e => {
        const code = ALIAS[e.code] || e.code;
        delete held[code];
        if (mode === 'play') game.key(code, false);
    });

    window.addEventListener('message', e => {
        const d = e.data || {};
        if (d.action === 'open') open(d);
        else if (d.action === 'bell') bell(d.volume);
        else if (d.action === 'close') { mode = 'off'; game = null; cab.hidden = true; }
    });

    const dev = new URLSearchParams(location.search).get('dev');
    if (dev) {
        document.body.style.background = '#333';
        open({ game: dev, price: 2, currency: '£', board: [{ name: 'Test P.', score: 120 }] });
    }
})();
