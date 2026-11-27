(window.RSVXGames = window.RSVXGames || {}).kapperman = {
    title: 'KAPPERMAN',
    help: 'W A S D  MOVE   GRAB THE TEA TO CHASE THE GULLS',

    init(api) {
        const { W, H, TOP } = api;
        const CW = 11, CH = 9, COLS = CW * 2 + 1, ROWS = CH * 2 + 1, T = 11;
        const OX = Math.floor((W - COLS * T) / 2) - 26, OY = TOP + Math.floor((H - TOP - ROWS * T) / 2);
        const DIRS = { ArrowUp: [0, -1], ArrowDown: [0, 1], ArrowLeft: [-1, 0], ArrowRight: [1, 0] };
        const ALL = [[0, -1], [1, 0], [0, 1], [-1, 0]];
        const NEST = { x: CW, y: CH }, START = { x: CW, y: ROWS - 2 };

        let level = 1, lives = 3, wall, coin, coins, tea, hero, gulls, power = 0, combo = 0, pause = 1.2, state = 'ready', clock = 0, dead = false;

        function rng(seed) {
            let s = seed >>> 0;
            return () => ((s = (s * 1664525 + 1013904223) >>> 0) / 4294967296);
        }

        function build() {
            const rnd = rng(level * 7919 + 13);
            const half = (CW + 1) / 2;
            wall = [];
            for (let y = 0; y < ROWS; y++) wall.push(new Array(COLS).fill(true));
            const seen = [];
            for (let y = 0; y < CH; y++) seen.push(new Array(half).fill(false));
            const open = (cx, cy) => { wall[cy * 2 + 1][cx * 2 + 1] = false; };
            const link = (ax, ay, bx, by) => { wall[ay + by + 1][ax + bx + 1] = false; };
            const stack = [[half - 1, CH - 1]];
            seen[CH - 1][half - 1] = true; open(half - 1, CH - 1);
            while (stack.length) {
                const [cx, cy] = stack[stack.length - 1];
                const next = ALL.map(d => [cx + d[0], cy + d[1]]).filter(([x, y]) => x >= 0 && y >= 0 && x < half && y < CH && !seen[y][x]);
                if (!next.length) { stack.pop(); continue; }
                const [nx, ny] = next[Math.floor(rnd() * next.length)];
                seen[ny][nx] = true; open(nx, ny); link(cx, cy, nx, ny);
                stack.push([nx, ny]);
            }
            const exits = (cx, cy) => ALL.filter(d => !wall[cy * 2 + 1 + d[1]][cx * 2 + 1 + d[0]]).length;
            for (let cy = 0; cy < CH; cy++) for (let cx = 0; cx < half; cx++) {
                const centre = cx === half - 1;
                let guard = 0;
                while (exits(cx, cy) + (centre && !wall[cy * 2 + 1][cx * 2] ? 1 : 0) < 2 && guard++ < 8) {
                    const opts = ALL.filter(d => {
                        const x = cx + d[0], y = cy + d[1];
                        return x >= 0 && y >= 0 && x < half && y < CH && wall[cy * 2 + 1 + d[1]][cx * 2 + 1 + d[0]];
                    });
                    if (!opts.length) break;
                    const d = opts[Math.floor(rnd() * opts.length)];
                    link(cx, cy, cx + d[0], cy + d[1]);
                }
            }
            for (let i = 0; i < 5; i++) {
                const cx = Math.floor(rnd() * (half - 1)), cy = Math.floor(rnd() * (CH - 1));
                if (rnd() < 0.5) link(cx, cy, cx + 1, cy); else link(cx, cy, cx, cy + 1);
            }
            for (let y = 0; y < ROWS; y++) for (let x = 0; x <= CW; x++) wall[y][COLS - 1 - x] = wall[y][x];

            coin = []; coins = 0; tea = [];
            for (let y = 0; y < ROWS; y++) {
                coin.push(new Array(COLS).fill(false));
                for (let x = 0; x < COLS; x++) {
                    if (!wall[y][x] && !(x === NEST.x && y === NEST.y) && !(x === START.x && y === START.y)) { coin[y][x] = true; coins++; }
                }
            }
            [[1, 1], [COLS - 2, 1], [1, ROWS - 2], [COLS - 2, ROWS - 2]].forEach(([x, y]) => {
                if (coin[y][x]) { coin[y][x] = false; coins--; }
                tea.push({ x, y, on: true });
            });
        }

        function place() {
            hero = { x: START.x, y: START.y, dx: 0, dy: 0, p: 0, want: null, face: [1, 0] };
            gulls = [];
            const n = Math.min(4, 2 + Math.ceil(level / 2));
            for (let i = 0; i < n; i++) gulls.push({ x: NEST.x, y: NEST.y, dx: 0, dy: 0, p: 0, kind: i, home: 1.5 + i * 2.5, scared: false });
            power = 0; combo = 0;
        }

        const free = (x, y) => y >= 0 && y < ROWS && x >= 0 && x < COLS && !wall[y][x];
        const px = e => OX + (e.x + e.dx * e.p) * T + T / 2;
        const py = e => OY + (e.y + e.dy * e.p) * T + T / 2;

        function steerHero() {
            const w = hero.want;
            if (w && free(hero.x + w[0], hero.y + w[1])) { hero.dx = w[0]; hero.dy = w[1]; hero.face = w; return; }
            if (!free(hero.x + hero.dx, hero.y + hero.dy)) { hero.dx = 0; hero.dy = 0; }
        }

        function steerGull(gl) {
            let opts = ALL.filter(d => free(gl.x + d[0], gl.y + d[1]));
            const back = opts.filter(d => !(d[0] === -gl.dx && d[1] === -gl.dy));
            if (back.length) opts = back;
            if (!opts.length) { gl.dx = 0; gl.dy = 0; return; }
            let tx = hero.x, ty = hero.y;
            if (gl.kind === 1) { tx += hero.face[0] * 3; ty += hero.face[1] * 3; }
            const far = Math.abs(gl.x - hero.x) + Math.abs(gl.y - hero.y);
            let pick;
            if (gl.kind === 2 || (gl.kind === 3 && far < 6) || Math.random() < 0.12) {
                pick = opts[Math.floor(Math.random() * opts.length)];
            } else {
                const score = d => (gl.x + d[0] - tx) ** 2 + (gl.y + d[1] - ty) ** 2;
                opts.sort((a, b) => score(a) - score(b));
                pick = gl.scared ? opts[opts.length - 1] : opts[0];
            }
            gl.dx = pick[0]; gl.dy = pick[1];
        }

        function advance(e, speed, dt, steer) {
            if (e.dx === 0 && e.dy === 0) { steer(e); if (e.dx === 0 && e.dy === 0) return; }
            e.p += speed * dt;
            let guard = 0;
            while (e.p >= 1 && guard++ < 4) {
                e.x += e.dx; e.y += e.dy; e.p -= 1;
                if (e === hero) eat();
                steer(e);
                if (e.dx === 0 && e.dy === 0) { e.p = 0; break; }
            }
        }

        function eat() {
            if (coin[hero.y][hero.x]) {
                coin[hero.y][hero.x] = false; coins--; api.add(10);
                api.beep(coins % 2 ? 520 : 440, 0.03);
            }
            tea.forEach(t => {
                if (t.on && t.x === hero.x && t.y === hero.y) {
                    t.on = false; api.add(50); power = Math.max(3.5, 7 - level * 0.4); combo = 0;
                    gulls.forEach(gl => { if (gl.home <= 0) { gl.scared = true; gl.dx = -gl.dx; gl.dy = -gl.dy; if (gl.p > 0) { gl.x -= gl.dx; gl.y -= gl.dy; gl.p = 1 - gl.p; } } });
                    api.beep(880, 0.2, 'triangle');
                }
            });
        }

        build(); place();

        return {
            key(code, down) {
                if (!down || !DIRS[code] || !hero) return;
                const d = DIRS[code];
                hero.want = d;
                if (d[0] === -hero.dx && d[1] === -hero.dy && (hero.dx || hero.dy)) {
                    hero.x += hero.dx; hero.y += hero.dy; hero.dx = d[0]; hero.dy = d[1]; hero.p = 1 - hero.p; hero.face = d;
                }
            },

            update(dt) {
                clock += dt;
                if (pause > 0) {
                    pause -= dt;
                    if (pause > 0) return;
                    if (state === 'dead') {
                        if (lives <= 0) { dead = true; return api.end(); }
                        place();
                    } else if (state === 'clear') { level++; build(); place(); }
                    state = 'play';
                }
                if (dead) return;

                const hs = 6.2 + Math.min(level, 8) * 0.15;
                advance(hero, hs, dt, steerHero);
                if (power > 0) { power -= dt; if (power <= 0) gulls.forEach(gl => { gl.scared = false; }); }

                for (const gl of gulls) {
                    if (gl.home > 0) { gl.home -= dt; continue; }
                    advance(gl, gl.scared ? 3.4 : 5.0 + Math.min(level, 8) * 0.25 - gl.kind * 0.25, dt, steerGull);
                    if (Math.hypot(px(gl) - px(hero), py(gl) - py(hero)) < T * 0.7) {
                        if (gl.scared) {
                            combo++; api.add(100 * 2 ** combo);
                            api.beep(660 + combo * 120, 0.12, 'triangle');
                            Object.assign(gl, { x: NEST.x, y: NEST.y, dx: 0, dy: 0, p: 0, home: 3, scared: false });
                        } else {
                            lives--; state = 'dead'; pause = 1.4;
                            api.beep(160, 0.5, 'sawtooth');
                            return;
                        }
                    }
                }
                if (coins <= 0) { state = 'clear'; pause = 1.6; api.add(250 * level); api.beep(1040, 0.4, 'triangle'); }
            },

            draw(g) {
                g.fillStyle = '#0c0818';
                g.fillRect(OX - 3, OY - 3, COLS * T + 6, ROWS * T + 6);
                g.fillStyle = state === 'clear' && Math.floor(clock * 6) % 2 ? '#e6e6da' : '#7a4df5';
                for (let y = 0; y < ROWS; y++) for (let x = 0; x < COLS; x++) {
                    if (!wall[y][x]) continue;
                    const l = x > 0 && wall[y][x - 1], r = x < COLS - 1 && wall[y][x + 1], u = y > 0 && wall[y - 1][x], d = y < ROWS - 1 && wall[y + 1][x];
                    const cx = OX + x * T + 4, cy = OY + y * T + 4;
                    g.fillRect(cx, cy, 3, 3);
                    if (l) g.fillRect(OX + x * T, cy, 4, 3);
                    if (r) g.fillRect(cx + 3, cy, 4, 3);
                    if (u) g.fillRect(cx, OY + y * T, 3, 4);
                    if (d) g.fillRect(cx, cy + 3, 3, 4);
                }
                g.fillStyle = '#e8c860';
                for (let y = 0; y < ROWS; y++) for (let x = 0; x < COLS; x++) {
                    if (coin[y][x]) g.fillRect(OX + x * T + 4, OY + y * T + 4, 3, 3);
                }
                tea.forEach(t => {
                    if (!t.on || Math.floor(clock * 4) % 2) return;
                    const x = OX + t.x * T + 2, y = OY + t.y * T + 3;
                    g.fillStyle = '#e6e6da'; g.fillRect(x, y, 6, 6); g.fillRect(x + 6, y + 1, 2, 3);
                    g.fillStyle = '#a5632a'; g.fillRect(x + 1, y + 1, 4, 2);
                });

                gulls.forEach(gl => {
                    const x = Math.round(px(gl)), y = Math.round(py(gl));
                    const flash = gl.scared && power < 1.5 && Math.floor(clock * 8) % 2;
                    const flap = Math.floor(clock * 6 + gl.kind) % 2;
                    g.fillStyle = gl.scared ? (flash ? '#e6e6da' : '#4a90c2') : '#e6e6da';
                    g.fillRect(x - 3, y - 2, 7, 5);
                    g.fillRect(x - 2, y - 4, 4, 2);
                    g.fillStyle = gl.scared ? '#2a5a80' : '#8a9199';
                    g.fillRect(x - 5, y - 1 - flap * 2, 2, 3); g.fillRect(x + 4, y - 1 - flap * 2, 2, 3);
                    if (!gl.scared) { g.fillStyle = '#e0702a'; g.fillRect(x - 1, y - 2, 2, 2); }
                    g.fillStyle = '#141210'; g.fillRect(x - 2, y - 3, 1, 1); g.fillRect(x + 1, y - 3, 1, 1);
                });

                if (state !== 'dead' || Math.floor(clock * 10) % 2) {
                    const x = Math.round(px(hero)), y = Math.round(py(hero)), f = hero.face;
                    g.fillStyle = '#f0c8a0'; g.fillRect(x - 3, y - 2, 7, 6);
                    g.fillStyle = '#3a2470'; g.fillRect(x - 3, y - 6, 7, 3);
                    g.fillStyle = '#7a4df5'; g.fillRect(x - 3, y - 4, 7, 1);
                    g.fillStyle = '#3a2470'; g.fillRect(x - 5, y - 3, 11, 1);
                    g.fillStyle = '#141210'; g.fillRect(x - 3 + f[0], y - 1, 7, 2);
                    g.fillStyle = '#b3261c'; g.fillRect(x - 1, y + 2, 3, 1);
                }

                const sx = OX + COLS * T + 30;
                api.text('LEVEL', sx, TOP + 20, '#7d7350', 8, 'center');
                api.text(String(level), sx, TOP + 32, '#e6e6da', 16, 'center');
                api.text('LIVES', sx, TOP + 66, '#7d7350', 8, 'center');
                api.text(String(Math.max(0, lives)), sx, TOP + 78, '#e8c860', 16, 'center');
                if (power > 0) { api.text('TEA', sx, TOP + 112, '#4a90c2', 8, 'center'); api.text(power.toFixed(0), sx, TOP + 124, '#4a90c2', 16, 'center'); }
                if (state === 'ready' && pause > 0) api.text('READY', OX + COLS * T / 2, OY + ROWS * T / 2 + 14, '#e8c860', 10, 'center');
            },
        };
    },
};
