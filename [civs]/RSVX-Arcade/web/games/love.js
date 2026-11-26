(window.RSVXGames = window.RSVXGames || {}).love = {
    title: 'HEART METER',
    help: 'HOLD SPACE  GRIP THE HANDLE',
    noScore: true,
    noBoard: true,
    overTitle: 'HEART METER',
    blurb: ['GRIP THE HANDLE', 'AND FIND OUT HOW YOU RATE'],

    init(api) {
        const { W, TOP } = api;
        const TIERS = [
            [90, 'HEARTBREAKER'], [75, 'SMITTEN'], [55, 'A BIT OF A CHARMER'],
            [35, 'JUST GOOD FRIENDS'], [15, 'LUKEWARM'], [0, 'COLD FISH'],
        ];
        const final = Math.floor(Math.random() * 101);
        let grip = 0, shown = 0, stage = 0, t = 0, tick = 0;

        return {
            key() {},

            update(dt) {
                t += dt;
                if (stage === 0) {
                    if (api.held('Space')) {
                        grip += dt;
                        tick -= dt;
                        if (tick <= 0) { tick = 0.12; shown = Math.floor(Math.random() * 101); api.beep(300 + shown * 6, 0.03); }
                        if (grip >= 2.5) { stage = 1; t = 0; shown = final; api.beep(final >= 75 ? 990 : 440, 0.3, 'triangle'); }
                    } else if (grip > 0) {
                        grip = Math.max(0, grip - dt * 2);
                    }
                } else if (t > 4) {
                    api.end();
                }
            },

            draw(g) {
                const cx = W / 2, bx = cx - 100, by = TOP + 86;
                g.fillStyle = stage === 1 || Math.floor(t * 3) % 2 ? '#d6553f' : '#8a3528';
                g.fillRect(cx - 18, TOP + 22, 14, 10);
                g.fillRect(cx + 4, TOP + 22, 14, 10);
                g.fillRect(cx - 22, TOP + 28, 44, 14);
                g.fillRect(cx - 16, TOP + 42, 32, 8);
                g.fillRect(cx - 9, TOP + 50, 18, 7);
                g.fillRect(cx - 3, TOP + 57, 6, 5);

                g.fillStyle = '#0d1118';
                g.fillRect(bx, by, 200, 14);
                g.fillStyle = '#d6553f';
                g.fillRect(bx, by, 2 * shown, 14);
                g.fillStyle = '#232a33';
                for (let i = 1; i < 10; i++) g.fillRect(bx + i * 20, by, 1, 14);

                if (stage === 0) {
                    api.text(grip > 0 ? 'KEEP HOLDING' : 'HOLD SPACE', cx, by + 30, '#e6e6da', 9, 'center');
                } else {
                    api.text(final + '%', cx, by + 26, '#e6e6da', 18, 'center');
                    api.text(TIERS.find(r => final >= r[0])[1], cx, by + 54, '#e8c860', 10, 'center');
                }
            },
        };
    },
};
