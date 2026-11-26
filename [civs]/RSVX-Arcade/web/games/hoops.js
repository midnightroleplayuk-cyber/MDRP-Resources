(window.RSVXGames = window.RSVXGames || {}).hoops = {
    title: 'HOOPS',
    help: 'LEFT / RIGHT  LINE UP   SPACE  SHOOT',

    init(api) {
        const { W, H, TOP } = api;
        const HOOP_Y = TOP + 46, HOOP_W = 30;
        const hoop = { x: W / 2, dir: 1 };
        const me = { x: W / 2 };
        let ball = null, left = 40, made = 0, flash = 0, note = '';

        return {
            key(code, down) {
                if (down && code === 'Space' && !ball) {
                    ball = { x: me.x, y: H - 30, scored: false };
                    api.beep(380, 0.04);
                }
            },

            update(dt) {
                left -= dt;
                if (left <= 0) return api.end();
                if (flash > 0) flash -= dt;

                const dx = (api.held('ArrowRight') ? 1 : 0) - (api.held('ArrowLeft') ? 1 : 0);
                me.x = Math.max(20, Math.min(W - 20, me.x + dx * 150 * dt));

                const speed = Math.min(150, 40 + made * 9);
                hoop.x += hoop.dir * speed * dt;
                if (hoop.x > W - 40) { hoop.x = W - 40; hoop.dir = -1; }
                if (hoop.x < 40) { hoop.x = 40; hoop.dir = 1; }

                if (ball) {
                    const before = ball.y;
                    ball.y -= 300 * dt;
                    if (!ball.scored && before > HOOP_Y && ball.y <= HOOP_Y) {
                        const off = Math.abs(ball.x - hoop.x);
                        if (off < HOOP_W / 2 - 3) {
                            const swish = off < 4;
                            api.add(swish ? 3 : 2);
                            made++;
                            note = swish ? 'SWISH +3' : '+2';
                            flash = 0.6;
                            api.beep(swish ? 880 : 660, 0.1);
                            ball = null;
                            return;
                        }
                        if (off < HOOP_W / 2 + 3) { note = 'RIM'; flash = 0.4; api.beep(160, 0.06); }
                        ball.scored = true;
                    }
                    if (ball.y < TOP - 6) ball = null;
                }
            },

            draw(g) {
                g.fillStyle = '#e6e6da';
                g.fillRect(hoop.x - 22, HOOP_Y - 30, 44, 26);
                g.fillStyle = '#05070a';
                g.fillRect(hoop.x - 20, HOOP_Y - 28, 40, 22);
                g.fillStyle = '#d6553f';
                g.fillRect(hoop.x - HOOP_W / 2, HOOP_Y - 2, HOOP_W, 3);
                g.fillStyle = '#7d7350';
                for (let i = 0; i < 5; i++) g.fillRect(hoop.x - 12 + i * 6, HOOP_Y + 1, 1, 10);

                g.fillStyle = '#5fc4d0';
                g.fillRect(me.x - 6, H - 22, 12, 16);
                g.fillRect(me.x - 3, H - 28, 6, 6);
                g.fillStyle = '#e09048';
                if (ball) g.fillRect(ball.x - 4, ball.y - 4, 8, 8);
                else g.fillRect(me.x - 4, H - 38, 8, 8);

                if (flash > 0) api.text(note, hoop.x, HOOP_Y + 16, '#e8c860', 9, 'center');
                api.text('TIME ' + Math.ceil(Math.max(left, 0)), W / 2, TOP + 2, '#e6e6da', 9, 'center');
            },
        };
    },
};
