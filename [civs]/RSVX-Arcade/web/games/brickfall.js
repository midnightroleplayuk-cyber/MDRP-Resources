(window.RSVXGames = window.RSVXGames || {}).brickfall = {
    title: 'BRICKFALL',
    help: 'LEFT/RIGHT MOVE   UP TURN   DOWN DROP   SPACE SLAM',

    init(api) {
        const COLS = 10, ROWS = 20, C = 11;
        const OX = Math.floor((api.W - COLS * C) / 2), OY = api.TOP + 2;
        const SHAPES = [
            { c: '#5fc4d0', m: [[1, 1, 1, 1]] },
            { c: '#e8c860', m: [[1, 1], [1, 1]] },
            { c: '#a878c8', m: [[0, 1, 0], [1, 1, 1]] },
            { c: '#7fc66a', m: [[0, 1, 1], [1, 1, 0]] },
            { c: '#d6553f', m: [[1, 1, 0], [0, 1, 1]] },
            { c: '#5878d0', m: [[1, 0, 0], [1, 1, 1]] },
            { c: '#e09048', m: [[0, 0, 1], [1, 1, 1]] },
        ];
        const LINE_PTS = [0, 100, 300, 500, 800];

        const grid = [];
        for (let y = 0; y < ROWS; y++) grid.push(new Array(COLS).fill(null));

        let bag = [], cur, next, lines = 0, level = 1, fall = 0, shift = 0, shiftDir = 0;

        function pull() {
            if (!bag.length) {
                bag = SHAPES.map((_, i) => i);
                for (let i = bag.length - 1; i > 0; i--) {
                    const j = Math.floor(Math.random() * (i + 1));
                    [bag[i], bag[j]] = [bag[j], bag[i]];
                }
            }
            const s = SHAPES[bag.pop()];
            return { c: s.c, m: s.m.map(r => r.slice()) };
        }

        function fits(m, x, y) {
            for (let r = 0; r < m.length; r++) {
                for (let c = 0; c < m[r].length; c++) {
                    if (!m[r][c]) continue;
                    const gx = x + c, gy = y + r;
                    if (gx < 0 || gx >= COLS || gy >= ROWS) return false;
                    if (gy >= 0 && grid[gy][gx]) return false;
                }
            }
            return true;
        }

        function spawn() {
            cur = next || pull();
            next = pull();
            cur.x = Math.floor((COLS - cur.m[0].length) / 2);
            cur.y = 0;
            if (!fits(cur.m, cur.x, cur.y)) {
                api.beep(110, 0.4, 'sawtooth');
                api.end();
                return false;
            }
            return true;
        }

        function lock() {
            cur.m.forEach((row, r) => row.forEach((v, c) => {
                if (v && cur.y + r >= 0) grid[cur.y + r][cur.x + c] = cur.c;
            }));
            let cleared = 0;
            for (let y = ROWS - 1; y >= 0; y--) {
                if (grid[y].every(Boolean)) {
                    grid.splice(y, 1);
                    grid.unshift(new Array(COLS).fill(null));
                    cleared++;
                    y++;
                }
            }
            if (cleared) {
                api.add(LINE_PTS[cleared] * level);
                lines += cleared;
                level = Math.min(10, 1 + Math.floor(lines / 10));
                api.beep(cleared === 4 ? 880 : 600, 0.12);
            } else {
                api.beep(180, 0.04);
            }
            return spawn();
        }

        function move(dx) {
            if (fits(cur.m, cur.x + dx, cur.y)) cur.x += dx;
        }

        function turn() {
            const m = cur.m[0].map((_, i) => cur.m.map(r => r[i]).reverse());
            for (const kick of [0, -1, 1, -2, 2]) {
                if (fits(m, cur.x + kick, cur.y)) {
                    cur.m = m;
                    cur.x += kick;
                    return;
                }
            }
        }

        spawn();

        function cell(g, x, y, color) {
            g.fillStyle = color;
            g.fillRect(x, y, C - 1, C - 1);
            g.fillStyle = 'rgba(255,255,255,.18)';
            g.fillRect(x, y, C - 1, 2);
        }

        return {
            key(code, down) {
                if (!down) {
                    if ((code === 'ArrowLeft' && shiftDir === -1) || (code === 'ArrowRight' && shiftDir === 1)) shiftDir = 0;
                    return;
                }
                if (code === 'ArrowLeft') { move(-1); shiftDir = -1; shift = 0.18; }
                else if (code === 'ArrowRight') { move(1); shiftDir = 1; shift = 0.18; }
                else if (code === 'ArrowUp') turn();
                else if (code === 'Space') {
                    while (fits(cur.m, cur.x, cur.y + 1)) cur.y++;
                    fall = 0;
                    lock();
                }
            },

            update(dt) {
                if (shiftDir) {
                    shift -= dt;
                    while (shift <= 0) { move(shiftDir); shift += 0.05; }
                }
                const gap = api.held('ArrowDown') ? 0.04 : Math.max(0.08, 0.7 - (level - 1) * 0.065);
                fall += dt;
                while (fall >= gap) {
                    fall -= gap;
                    if (fits(cur.m, cur.x, cur.y + 1)) cur.y++;
                    else { fall = 0; if (!lock()) return; break; }
                }
            },

            draw(g) {
                g.fillStyle = '#0d1118';
                g.fillRect(OX - 2, OY - 1, COLS * C + 3, ROWS * C + 2);
                g.fillStyle = '#232a33';
                g.fillRect(OX - 3, OY - 1, 1, ROWS * C + 2);
                g.fillRect(OX + COLS * C + 1, OY - 1, 1, ROWS * C + 2);

                for (let y = 0; y < ROWS; y++) {
                    for (let x = 0; x < COLS; x++) {
                        if (grid[y][x]) cell(g, OX + x * C, OY + y * C, grid[y][x]);
                    }
                }
                cur.m.forEach((row, r) => row.forEach((v, c) => {
                    if (v) cell(g, OX + (cur.x + c) * C, OY + (cur.y + r) * C, cur.c);
                }));

                const px = OX + COLS * C + 18;
                api.text('NEXT', px, OY + 4, '#7d7350');
                next.m.forEach((row, r) => row.forEach((v, c) => {
                    if (v) cell(g, px + c * C, OY + 18 + r * C, next.c);
                }));
                api.text('LEVEL', px, OY + 62, '#7d7350');
                api.text(String(level), px, OY + 73, '#e6e6da', 10);
                api.text('LINES', px, OY + 94, '#7d7350');
                api.text(String(lines), px, OY + 105, '#e6e6da', 10);
            },
        };
    },
};
