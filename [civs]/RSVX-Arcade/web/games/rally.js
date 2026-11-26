(window.RSVXGames = window.RSVXGames || {}).rally = {
    title: 'RALLY',
    help: 'UP / DOWN  MOVE BAT   FIRST TO LOSE 5 IS OUT',

    init(api) {
        const { W, H, TOP } = api;
        const PH = 28, PW = 4, BS = 4, LIVES = 5;
        const you = { x: 10, y: (TOP + H) / 2 - PH / 2 };
        const cpu = { x: W - 10 - PW, y: (TOP + H) / 2 - PH / 2 };
        const ball = { x: 0, y: 0, vx: 0, vy: 0, speed: 150 };
        let won = 0, lost = 0, serve = 0.8, towards = 1;

        function reset(dir) {
            ball.x = W / 2 - BS / 2;
            ball.y = (TOP + H) / 2 - BS / 2;
            ball.vx = 0; ball.vy = 0;
            ball.speed = 150;
            towards = dir;
            serve = 0.8;
        }
        reset(Math.random() < 0.5 ? 1 : -1);

        function launch() {
            const a = (Math.random() * 0.8 - 0.4);
            ball.vx = Math.cos(a) * ball.speed * towards;
            ball.vy = Math.sin(a) * ball.speed;
        }

        function bounce(p, dir) {
            const off = ((ball.y + BS / 2) - (p.y + PH / 2)) / (PH / 2);
            const a = Math.max(-1, Math.min(1, off)) * 0.95;
            ball.speed = Math.min(330, ball.speed + 6);
            ball.vx = Math.cos(a) * ball.speed * dir;
            ball.vy = Math.sin(a) * ball.speed;
        }

        function clamp(p) {
            p.y = Math.max(TOP, Math.min(H - PH, p.y));
        }

        return {
            key() {},

            update(dt) {
                const dy = (api.held('ArrowDown') ? 1 : 0) - (api.held('ArrowUp') ? 1 : 0);
                you.y += dy * 190 * dt;
                clamp(you);

                const cpuSpeed = Math.min(230, 95 + won * 12);
                const target = ball.vx > 0 ? ball.y + BS / 2 : (TOP + H) / 2;
                const diff = target - (cpu.y + PH / 2);
                if (Math.abs(diff) > 3) cpu.y += Math.sign(diff) * Math.min(cpuSpeed * dt, Math.abs(diff));
                clamp(cpu);

                if (serve > 0) {
                    serve -= dt;
                    if (serve <= 0) launch();
                    return;
                }

                const px = ball.x;
                ball.x += ball.vx * dt;
                ball.y += ball.vy * dt;

                if (ball.y < TOP) { ball.y = TOP; ball.vy = Math.abs(ball.vy); api.beep(300, 0.03); }
                if (ball.y > H - BS) { ball.y = H - BS; ball.vy = -Math.abs(ball.vy); api.beep(300, 0.03); }

                if (ball.vx < 0 && px >= you.x + PW && ball.x <= you.x + PW &&
                    ball.y + BS >= you.y && ball.y <= you.y + PH) {
                    ball.x = you.x + PW;
                    bounce(you, 1);
                    api.add(5);
                    api.beep(480, 0.04);
                } else if (ball.vx > 0 && px + BS <= cpu.x && ball.x + BS >= cpu.x &&
                    ball.y + BS >= cpu.y && ball.y <= cpu.y + PH) {
                    ball.x = cpu.x - BS;
                    bounce(cpu, -1);
                    api.beep(420, 0.04);
                }

                if (ball.x > W) {
                    won++;
                    api.add(100);
                    api.beep(760, 0.15);
                    reset(-1);
                } else if (ball.x < -BS) {
                    lost++;
                    api.beep(140, 0.25, 'sawtooth');
                    if (lost >= LIVES) return api.end();
                    reset(1);
                }
            },

            draw(g) {
                g.fillStyle = '#232a33';
                for (let y = TOP + 4; y < H; y += 12) g.fillRect(W / 2 - 1, y, 2, 6);
                api.text(String(won), W / 2 - 24, TOP + 8, '#3a4450', 20, 'right');
                api.text(String(lost), W / 2 + 24, TOP + 8, '#3a4450', 20, 'left');
                g.fillStyle = '#e6e6da';
                g.fillRect(you.x, you.y, PW, PH);
                g.fillRect(cpu.x, cpu.y, PW, PH);
                g.fillStyle = '#e8c860';
                g.fillRect(ball.x, ball.y, BS, BS);
                api.text('LIVES ' + (LIVES - lost), 6, H - 12, '#7d7350');
            },
        };
    },
};
