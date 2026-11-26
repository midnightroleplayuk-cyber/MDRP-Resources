(window.RSVXGames = window.RSVXGames || {}).strength = {
    title: 'BELL RINGER',
    help: 'SPACE  SWING WHEN THE BAR IS FULL',

    init(api) {
        const { W, H, TOP } = api;
        const BASE = H - 20, TOWER = 170;
        const T = Object.assign({ bell: 965, speed: 2.2, step: 0.3, maxSpeed: 3.8, jitter: 0.2 }, api.tune);
        let base = T.speed;
        const pace = () => base * (1 + (Math.random() * 2 - 1) * T.jitter);
        let pos = 0, dir = 1, speed = pace(), struck = false, power = 0, puck = 0, done = 0;

        function rank(p) {
            if (p >= T.bell) return 'RANG THE BELL';
            if (p >= 800) return 'STRONGMAN';
            if (p >= 550) return 'NOT BAD';
            if (p >= 300) return 'KEEP TRYING';
            return 'WEAKLING';
        }

        return {
            key(code, down) {
                if (!down || code !== 'Space' || struck) return;
                struck = true;
                power = Math.round(pos * 1000);
                api.add(power);
                api.beep(200, 0.08, 'sawtooth');
            },

            update(dt) {
                if (!struck) {
                    pos += dir * speed * dt;
                    if (pos >= 1) { pos = 1; dir = -1; base = Math.min(T.maxSpeed, base + T.step); speed = pace(); }
                    if (pos <= 0) { pos = 0; dir = 1; speed = pace(); }
                    return;
                }
                const target = power / 1000;
                if (puck < target) {
                    puck = Math.min(target, puck + 1.6 * dt);
                    if (puck === target) { if (power >= T.bell) api.bell(); else api.beep(300, 0.1, 'square'); }
                    return;
                }
                done += dt;
                if (done > 2) api.end();
            },

            draw(g) {
                const x = W / 2;
                g.fillStyle = '#232a33';
                g.fillRect(x - 6, BASE - TOWER, 12, TOWER);
                g.fillStyle = '#7d7350';
                for (let i = 1; i < 10; i++) g.fillRect(x - 10, BASE - (TOWER * i) / 10, 20, 1);
                g.fillStyle = '#e8c860';
                g.fillRect(x - 10, BASE - TOWER - 12, 20, 10);
                g.fillStyle = '#d6553f';
                g.fillRect(x - 5, BASE - puck * TOWER - 4, 10, 4);
                g.fillStyle = '#3a3628';
                g.fillRect(x - 30, BASE, 60, 6);

                g.fillStyle = '#0d1118';
                g.fillRect(40, TOP + 30, 14, TOWER);
                g.fillStyle = pos >= T.bell / 1000 ? '#7fc66a' : '#e09048';
                g.fillRect(40, TOP + 30 + TOWER * (1 - pos), 14, TOWER * pos);
                g.fillStyle = '#e6e6da';
                g.fillRect(38, TOP + 30 + TOWER * (1 - T.bell / 1000), 18, 1);
                api.text('POWER', 47, TOP + 16, '#7d7350', 8, 'center');

                if (struck && puck >= power / 1000) {
                    api.text(String(power), W - 70, TOP + 70, '#e6e6da', 18, 'center');
                    api.text(rank(power), W - 70, TOP + 96, '#e8c860', 8, 'center');
                }
            },
        };
    },
};
