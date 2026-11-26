(window.RSVXGames = window.RSVXGames || {}).claw = {
    title: 'GRABBER',
    help: 'LEFT / RIGHT  MOVE   SPACE  DROP',
    noScore: true,
    noBoard: true,
    overTitle: 'GRABBER',
    blurb: ['LINE THE CLAW UP OVER A PRIZE', 'ONE DROP PER CREDIT'],

    init(api) {
        const { W, H, TOP } = api;
        const FLOOR = H - 26, RAIL = TOP + 16;
        const COLORS = ['#d6553f', '#e8c860', '#5fc4d0', '#a878c8', '#7fc66a'];
        const prizes = [];
        for (let i = 0; i < 5; i++) {
            prizes.push({ x: 40 + i * 60 + Math.floor(Math.random() * 24) - 12, c: COLORS[i] });
        }
        const claw = { x: 30, y: RAIL + 10 };
        let left = 20, dropping = false;

        return {
            key(code, down) {
                if (down && code === 'Space' && !dropping) {
                    dropping = true;
                    api.beep(300, 0.1);
                }
            },

            update(dt) {
                if (!dropping) {
                    left -= dt;
                    if (left <= 0) dropping = true;
                    const dx = (api.held('ArrowRight') ? 1 : 0) - (api.held('ArrowLeft') ? 1 : 0);
                    claw.x = Math.max(20, Math.min(W - 20, claw.x + dx * 90 * dt));
                    return;
                }
                claw.y += 110 * dt;
                if (claw.y >= FLOOR - 14) {
                    claw.y = FLOOR - 14;
                    let best = 999;
                    for (const p of prizes) best = Math.min(best, Math.abs(p.x - claw.x));
                    api.add(Math.max(0, Math.round(100 - best * 5)));
                    api.beep(180, 0.15, 'sawtooth');
                    api.end();
                }
            },

            draw(g) {
                g.fillStyle = '#0d1118';
                g.fillRect(10, RAIL - 6, W - 20, FLOOR - RAIL + 22);
                g.fillStyle = '#232a33';
                g.fillRect(10, RAIL, W - 20, 3);
                for (const p of prizes) {
                    g.fillStyle = p.c;
                    g.fillRect(p.x - 9, FLOOR - 16, 18, 16);
                    g.fillStyle = 'rgba(255,255,255,.2)';
                    g.fillRect(p.x - 9, FLOOR - 16, 18, 3);
                }
                g.fillStyle = '#3a3628';
                g.fillRect(10, FLOOR, W - 20, 6);

                g.fillStyle = '#8d8468';
                g.fillRect(claw.x - 1, RAIL, 2, claw.y - RAIL);
                g.fillStyle = '#e6e6da';
                g.fillRect(claw.x - 8, claw.y, 16, 3);
                g.fillRect(claw.x - 8, claw.y, 2, 12);
                g.fillRect(claw.x + 6, claw.y, 2, 12);

                if (!dropping) api.text('TIME ' + Math.ceil(Math.max(left, 0)), W / 2, TOP + 2, '#e6e6da', 9, 'center');
            },
        };
    },
};
