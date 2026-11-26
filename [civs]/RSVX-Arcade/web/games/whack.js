(window.RSVXGames = window.RSVXGames || {}).whack = {
    title: 'MOLE MASH',
    help: 'KEYS 1-9  (NUMPAD LAYOUT)  BONK',

    init(api) {
        const { W, TOP } = api;
        const ORDER = [7, 8, 9, 4, 5, 6, 1, 2, 3];
        const holes = ORDER.map((n, i) => ({
            n, x: W / 2 - 84 + (i % 3) * 84, y: TOP + 44 + Math.floor(i / 3) * 62, up: 0, bonk: 0, miss: 0,
        }));
        let left = 30, spawn = 0.5;

        return {
            key(code, down) {
                if (!down) return;
                const m = /^(?:Digit|Numpad)([1-9])$/.exec(code);
                if (!m) return;
                const h = holes.find(o => o.n === Number(m[1]));
                if (h.up > 0) {
                    h.up = 0;
                    h.bonk = 0.25;
                    api.add(10);
                    api.beep(520, 0.06);
                } else {
                    h.miss = 0.15;
                    api.beep(130, 0.05, 'sawtooth');
                }
            },

            update(dt) {
                left -= dt;
                if (left <= 0) return api.end();
                const pace = 1 - left / 30;
                for (const h of holes) {
                    if (h.up > 0) h.up -= dt;
                    if (h.bonk > 0) h.bonk -= dt;
                    if (h.miss > 0) h.miss -= dt;
                }
                spawn -= dt;
                if (spawn <= 0) {
                    spawn = 0.8 - pace * 0.45;
                    const free = holes.filter(h => h.up <= 0 && h.bonk <= 0);
                    if (free.length) free[Math.floor(Math.random() * free.length)].up = 1.1 - pace * 0.5;
                }
            },

            draw(g) {
                for (const h of holes) {
                    g.fillStyle = h.miss > 0 ? '#3a1c18' : '#1a1410';
                    g.fillRect(h.x - 26, h.y - 4, 52, 16);
                    g.fillStyle = '#000';
                    g.fillRect(h.x - 22, h.y, 44, 8);
                    if (h.up > 0) {
                        g.fillStyle = '#9a6a3c';
                        g.fillRect(h.x - 12, h.y - 22, 24, 26);
                        g.fillStyle = '#c99a6a';
                        g.fillRect(h.x - 6, h.y - 10, 12, 8);
                        g.fillStyle = '#000';
                        g.fillRect(h.x - 7, h.y - 17, 3, 3);
                        g.fillRect(h.x + 4, h.y - 17, 3, 3);
                        g.fillRect(h.x - 2, h.y - 9, 4, 3);
                    } else if (h.bonk > 0) {
                        api.text('BONK', h.x, h.y - 18, '#e8c860', 9, 'center');
                    }
                    api.text(String(h.n), h.x, h.y + 15, '#7d7350', 9, 'center');
                }
                api.text('TIME ' + Math.ceil(Math.max(left, 0)), W / 2, TOP + 4, '#e6e6da', 9, 'center');
            },
        };
    },
};
