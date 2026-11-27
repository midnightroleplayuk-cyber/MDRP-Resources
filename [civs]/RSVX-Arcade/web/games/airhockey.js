(() => {
    const root = typeof window !== 'undefined' ? window : globalThis;

    const HALF_W = 0.5, HALF_L = 1.0;
    const PUCK = 0.04, MALLET = 0.055, GOAL = 0.19;
    const MALLET_SPEED = 2.4, MALLET_ACCEL = 18, PUCK_MAX = 5.0, STEP = 1 / 240;

    const layout = { HALF_W, HALF_L, PUCK, MALLET, GOAL };

    function create(opts) {
        opts = opts || {};
        const target = opts.goals || 7;
        const skill = opts.ai == null ? 0.6 : opts.ai;
        let clock = opts.time == null ? 180 : opts.time;

        const puck = { x: 0, y: -0.35, vx: 0, vy: 0 };
        const m = [
            { x: 0, y: -0.75, vx: 0, vy: 0, ax: 0, ay: 0, to: null },
            { x: 0, y: 0.75, vx: 0, vy: 0, ax: 0, ay: 0, to: null },
        ];
        const score = [0, 0];
        let p2 = 'ai', over = false, carry = 0, idle = 0, aimX = 0, slice = 0, lastSide = -1;
        let events = [];

        function limit(i) {
            const a = m[i];
            a.x = Math.max(-HALF_W + MALLET, Math.min(HALF_W - MALLET, a.x));
            if (i === 0) a.y = Math.max(-HALF_L + MALLET, Math.min(-MALLET, a.y));
            else a.y = Math.max(MALLET, Math.min(HALF_L - MALLET, a.y));
        }

        function think(h) {
            const a = m[1];
            aimX += (puck.x - aimX) * Math.min(1, h * (4 + 10 * skill));
            const side = puck.y > 0 ? 1 : -1;
            if (side !== lastSide) { lastSide = side; slice = (Math.random() - 0.5) * 0.07; }
            let tx, ty;
            if (puck.y > 0.02 && puck.y < a.y + 0.02) { tx = aimX + slice; ty = puck.y + 0.02; }
            else if (puck.y >= a.y + 0.02) { tx = aimX * 0.4; ty = Math.min(HALF_L - MALLET, puck.y + 0.18); }
            else { tx = Math.max(-0.25, Math.min(0.25, aimX * 0.7)); ty = 0.72; }
            const dx = tx - a.x, dy = ty - a.y, d = Math.hypot(dx, dy);
            const s = d > 0.02 ? skill : (skill * d) / 0.02;
            a.ax = d > 0 ? (dx / d) * s : 0;
            a.ay = d > 0 ? (dy / d) * s : 0;
        }

        function drive(i, h) {
            const a = m[i];
            if (a.to) {
                let vx = (a.to.x - a.x) / Math.max(h, 0.05), vy = (a.to.y - a.y) / Math.max(h, 0.05);
                const sp = Math.hypot(vx, vy), cap = MALLET_SPEED * 1.4;
                if (sp > cap) { vx *= cap / sp; vy *= cap / sp; }
                a.vx = vx; a.vy = vy;
            } else {
                const wx = a.ax * MALLET_SPEED, wy = a.ay * MALLET_SPEED;
                const dx = wx - a.vx, dy = wy - a.vy, d = Math.hypot(dx, dy), max = MALLET_ACCEL * h;
                if (d <= max) { a.vx = wx; a.vy = wy; } else { a.vx += (dx / d) * max; a.vy += (dy / d) * max; }
            }
            const bx = a.x, by = a.y;
            a.x += a.vx * h; a.y += a.vy * h;
            limit(i);
            a.vx = (a.x - bx) / h; a.vy = (a.y - by) / h;
        }

        function strike(i) {
            const a = m[i];
            let nx = puck.x - a.x, ny = puck.y - a.y;
            const d = Math.hypot(nx, ny), min = PUCK + MALLET;
            if (d >= min) return;
            if (d === 0) { nx = 0; ny = i === 0 ? 1 : -1; } else { nx /= d; ny /= d; }
            puck.x = a.x + nx * min; puck.y = a.y + ny * min;
            const vn = (puck.vx - a.vx) * nx + (puck.vy - a.vy) * ny;
            if (vn < 0) {
                puck.vx -= 1.8 * vn * nx; puck.vy -= 1.8 * vn * ny;
                if (vn < -0.3) events.push('hit');
            }
        }

        function goal(side) {
            score[side] += 1;
            events.push('goal');
            if (score[side] >= target) { over = true; return; }
            puck.x = (Math.random() - 0.5) * 0.3; puck.y = side === 0 ? 0.35 : -0.35; puck.vx = 0; puck.vy = 0;
            idle = 0;
        }

        function substep(h) {
            if (p2 === 'ai') think(h);
            drive(0, h); drive(1, h);

            puck.vx *= 1 - 0.18 * h; puck.vy *= 1 - 0.18 * h;
            puck.x += puck.vx * h; puck.y += puck.vy * h;
            strike(0); strike(1);

            const sp = Math.hypot(puck.vx, puck.vy);
            if (sp > PUCK_MAX) { puck.vx *= PUCK_MAX / sp; puck.vy *= PUCK_MAX / sp; }

            if (puck.x > HALF_W - PUCK) { puck.x = HALF_W - PUCK; if (puck.vx > 0) { puck.vx *= -0.9; events.push('wall'); } }
            if (puck.x < -HALF_W + PUCK) { puck.x = -HALF_W + PUCK; if (puck.vx < 0) { puck.vx *= -0.9; events.push('wall'); } }

            const open = Math.abs(puck.x) < GOAL - PUCK * 0.5;
            if (puck.y > HALF_L - PUCK) {
                if (open) { if (puck.y > HALF_L + PUCK) return goal(0); }
                else { puck.y = HALF_L - PUCK; if (puck.vy > 0) { puck.vy *= -0.9; events.push('wall'); } }
            }
            if (puck.y < -HALF_L + PUCK) {
                if (open) { if (puck.y < -HALF_L - PUCK) return goal(1); }
                else { puck.y = -HALF_L + PUCK; if (puck.vy < 0) { puck.vy *= -0.9; events.push('wall'); } }
            }
        }

        return {
            layout,
            input(v) {
                if (!v) return;
                if (v.p1) { m[0].ax = v.p1.x || 0; m[0].ay = v.p1.y || 0; }
                if (v.p2 === 'ai') { p2 = 'ai'; m[1].to = null; }
                else if (v.p2 === 'remote') { p2 = 'remote'; m[1].ax = 0; m[1].ay = 0; }
                else if (v.p2) { p2 = 'remote'; m[1].to = { x: +v.p2.x || 0, y: +v.p2.y || 0 }; }
            },
            step(dt) {
                if (over) return;
                if (clock > 0) { clock -= dt; if (clock <= 0) { clock = 0; over = true; events.push('goal'); return; } }
                carry += Math.min(dt, 0.05);
                while (carry >= STEP && !over) {
                    substep(STEP);
                    carry -= STEP;
                }
                if (Math.hypot(puck.vx, puck.vy) < 0.03 && Math.abs(puck.y) < 0.03) {
                    idle += dt;
                    if (idle > 4) { puck.vy = puck.y >= 0 ? 0.4 : -0.4; idle = 0; }
                } else idle = 0;
            },
            events() { const e = events; events = []; return e; },
            snapshot() {
                return {
                    px: puck.x, py: puck.y, ax: m[0].x, ay: m[0].y, bx: m[1].x, by: m[1].y,
                    s1: score[0], s2: score[1], over, target, time: Math.ceil(clock),
                };
            },
            get over() { return over; },
        };
    }

    (root.RSVXSims = root.RSVXSims || {}).airhockey = { layout, create };

    if (typeof window === 'undefined') return;

    (window.RSVXGames = window.RSVXGames || {}).airhockey = {
        title: 'AIR HOCKEY',
        help: 'W A S D  MOVE YOUR MALLET',
        noScore: true,
        overTitle: 'FULL TIME',

        init(api) {
            const { W, H, TOP: HUD } = api;
            const sim = create(api.tune);
            const S = 140, CX = W / 2, CY = HUD + 22 + 70;
            const px = y => CX + y * S, py = x => CY + x * S;
            let endTimer = 0, counted = 0;

            function axes() {
                sim.input({ p1: {
                    x: (api.held('ArrowDown') ? 1 : 0) - (api.held('ArrowUp') ? 1 : 0),
                    y: (api.held('ArrowRight') ? 1 : 0) - (api.held('ArrowLeft') ? 1 : 0),
                } });
            }

            return {
                key() { axes(); },

                update(dt) {
                    axes();
                    sim.step(dt);
                    sim.events().forEach(e => {
                        if (e === 'hit') api.beep(300, 0.04);
                        else if (e === 'wall') api.beep(180, 0.03);
                        else if (e === 'goal') api.beep(880, 0.3, 'triangle');
                    });
                    const s = sim.snapshot();
                    if (s.over && !counted && s.s1 > s.s2) { api.add(1); counted = 1; }
                    if (s.over) { endTimer += dt; if (endTimer > 1.5) api.end(); }
                },

                draw(g) {
                    const s = sim.snapshot();
                    g.fillStyle = '#e6e6da';
                    g.fillRect(px(-1) - 3, py(-0.5) - 3, 2 * S + 6, S + 6);
                    g.fillStyle = '#16303f';
                    g.fillRect(px(-1), py(-0.5), 2 * S, S);
                    g.fillStyle = '#2a4a5c';
                    g.fillRect(px(0) - 0.5, py(-0.5), 1, S);
                    g.strokeStyle = '#2a4a5c'; g.lineWidth = 1;
                    g.beginPath(); g.arc(px(0), py(0), 0.16 * S, 0, Math.PI * 2); g.stroke();
                    g.fillStyle = '#05070a';
                    g.fillRect(px(-1) - 3, py(-layout.GOAL), 3, layout.GOAL * 2 * S);
                    g.fillRect(px(1), py(-layout.GOAL), 3, layout.GOAL * 2 * S);

                    const disc = (x, y, r, c) => { g.fillStyle = c; g.beginPath(); g.arc(px(y), py(x), r * S, 0, Math.PI * 2); g.fill(); };
                    disc(s.ax, s.ay, layout.MALLET, '#d6553f');
                    disc(s.bx, s.by, layout.MALLET, '#4a90c2');
                    disc(s.px, s.py, layout.PUCK, '#e8c860');

                    api.text('YOU ' + s.s1, 24, HUD + 4, '#d6553f', 10);
                    api.text(s.s2 + ' CPU', W - 24, HUD + 4, '#4a90c2', 10, 'right');
                    api.text(Math.floor(s.time / 60) + ':' + String(s.time % 60).padStart(2, '0'), W / 2, HUD + 4, '#e6e6da', 10, 'center');
                    if (s.over) api.text(s.s1 > s.s2 ? 'YOU WIN' : s.s1 < s.s2 ? 'YOU LOSE' : 'DRAW', W / 2, H - 30, '#e8c860', 14, 'center');
                },
            };
        },
    };
})();
