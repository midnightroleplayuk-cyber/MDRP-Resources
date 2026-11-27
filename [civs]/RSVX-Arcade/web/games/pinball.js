(() => {
    const root = typeof window !== 'undefined' ? window : globalThis;

    const R = 0.016;
    const HALF = 0.25, TOP = 0.80, ARCH = 0.19;
    const LANE = 0.205, LANE_X = 0.2275, REST = 0.03;
    const PIVOT_L = { x: -0.1237, y: 0.12 }, PIVOT_R = { x: 0.0787, y: 0.12 };
    const FLIP_LEN = 0.075, FLIP_R = 0.011, FLIP_DOWN = -28, FLIP_UP = 28;
    const FLIP_UP_TIME = 0.045, FLIP_DOWN_TIME = 0.09;
    const GRAVITY = 1.7, MAX_SPEED = 4.5, STEP = 1 / 600;

    const BUMPERS = [
        { x: -0.09, y: 0.70, r: 0.032 },
        { x: 0.045, y: 0.70, r: 0.032 },
        { x: -0.0225, y: 0.58, r: 0.032 },
    ];
    const TARGETS = [
        { x: -0.232, y: 0.50 }, { x: -0.232, y: 0.42 },
        { x: 0.187, y: 0.50 }, { x: 0.187, y: 0.42 },
    ];
    const TARGET_R = 0.014;
    const ROLLOVERS = [{ x: -0.105, y: 0.88 }, { x: -0.0225, y: 0.90 }, { x: 0.06, y: 0.88 }];
    const ROLLOVER_R = 0.022;

    const WALLS = [];
    function wall(x1, y1, x2, y2) { WALLS.push({ x1, y1, x2, y2 }); }
    wall(-HALF, -0.05, -HALF, TOP);
    wall(HALF, REST, HALF, TOP);
    for (let i = 0; i < 14; i++) {
        const a = (Math.PI * i) / 14, b = (Math.PI * (i + 1)) / 14;
        wall(HALF * Math.cos(a), TOP + ARCH * Math.sin(a), HALF * Math.cos(b), TOP + ARCH * Math.sin(b));
    }
    wall(LANE, -0.05, LANE, 0.74);
    wall(LANE, REST, HALF, REST);
    wall(-HALF, 0.27, -0.131, 0.128);
    wall(LANE, 0.27, 0.086, 0.128);
    const GATE = { x1: LANE, y1: 0.74, x2: HALF, y2: 0.795 };

    const layout = {
        R, HALF, TOP, ARCH, LANE, LANE_X, REST, PIVOT_L, PIVOT_R, FLIP_LEN, FLIP_R, FLIP_DOWN, FLIP_UP,
        BUMPERS, TARGETS, TARGET_R, ROLLOVERS, ROLLOVER_R, WALLS, GATE, LENGTH: TOP + ARCH,
    };

    function create(opts) {
        opts = opts || {};
        const totalBalls = opts.balls || 3;
        const saveTime = opts.ballSave == null ? 5 : opts.ballSave;

        const ball = { x: LANE_X, y: REST + R, vx: 0, vy: 0 };
        const flip = [{ a: 0, w: 0 }, { a: 0, w: 0 }];
        const input = { left: false, right: false, plunge: false };
        const lit = { targets: [false, false, false, false], rollovers: [false, false, false] };
        const cool = { bumpers: [0, 0, 0], targets: [0, 0, 0, 0] };
        let score = 0, ballsLeft = totalBalls, mult = 1, over = false;
        let inPlay = false, charge = 0, wasPlunge = false, save = 0, saved = false, still = 0, pause = 0, carry = 0;
        let events = [];

        function flipAngle(i) {
            const deg = FLIP_DOWN + (FLIP_UP - FLIP_DOWN) * flip[i].a;
            return i === 0 ? deg : 180 - deg;
        }

        function serve() {
            ball.x = LANE_X; ball.y = REST + R; ball.vx = 0; ball.vy = 0;
            inPlay = false; charge = 0; still = 0;
        }

        function hitSegment(s, rad, bounce) {
            const dx = s.x2 - s.x1, dy = s.y2 - s.y1;
            const len2 = dx * dx + dy * dy;
            let t = ((ball.x - s.x1) * dx + (ball.y - s.y1) * dy) / len2;
            t = t < 0 ? 0 : t > 1 ? 1 : t;
            const cx = s.x1 + dx * t, cy = s.y1 + dy * t;
            let nx = ball.x - cx, ny = ball.y - cy;
            const d = Math.hypot(nx, ny), min = R + rad;
            if (d >= min || d === 0) return null;
            nx /= d; ny /= d;
            ball.x = cx + nx * min; ball.y = cy + ny * min;
            if (bounce != null) {
                const vn = ball.vx * nx + ball.vy * ny;
                if (vn < 0) { ball.vx -= (1 + bounce) * vn * nx; ball.vy -= (1 + bounce) * vn * ny; }
            }
            return { nx, ny, cx, cy };
        }

        function hitFlipper(i) {
            const p = i === 0 ? PIVOT_L : PIVOT_R;
            const ang = (flipAngle(i) * Math.PI) / 180;
            const seg = { x1: p.x, y1: p.y, x2: p.x + Math.cos(ang) * FLIP_LEN, y2: p.y + Math.sin(ang) * FLIP_LEN };
            const c = hitSegment(seg, FLIP_R, null);
            if (!c) return;
            const w = flip[i].w * (i === 0 ? 1 : -1);
            const sx = -w * (c.cy - p.y), sy = w * (c.cx - p.x);
            const rx = ball.vx - sx, ry = ball.vy - sy;
            const vn = rx * c.nx + ry * c.ny;
            if (vn < 0) {
                ball.vx = rx - 1.35 * vn * c.nx + sx;
                ball.vy = ry - 1.35 * vn * c.ny + sy;
                if (flip[i].w > 0 && Math.hypot(sx, sy) > 0.4) events.push('flip');
            }
        }

        function hitCircle(c, rad, kick) {
            let nx = ball.x - c.x, ny = ball.y - c.y;
            const d = Math.hypot(nx, ny), min = R + rad;
            if (d >= min || d === 0) return false;
            nx /= d; ny /= d;
            ball.x = c.x + nx * min; ball.y = c.y + ny * min;
            const vn = ball.vx * nx + ball.vy * ny;
            if (vn < 0) { ball.vx -= 1.6 * vn * nx; ball.vy -= 1.6 * vn * ny; }
            if (kick) {
                const out = ball.vx * nx + ball.vy * ny;
                if (out < kick) { ball.vx += (kick - out) * nx; ball.vy += (kick - out) * ny; }
            }
            return true;
        }

        function add(points) { score += points * mult; }

        function substep(h) {
            for (let i = 0; i < 2; i++) {
                const want = (i === 0 ? input.left : input.right) ? 1 : 0;
                const f = flip[i], before = f.a;
                if (want > f.a) f.a = Math.min(1, f.a + h / FLIP_UP_TIME);
                else if (want < f.a) f.a = Math.max(0, f.a - h / FLIP_DOWN_TIME);
                f.w = (((f.a - before) / h) * (FLIP_UP - FLIP_DOWN) * Math.PI) / 180;
            }

            if (!inPlay && ball.y <= REST + R + 0.002 && Math.abs(ball.vy) < 0.05 && ball.x > LANE) {
                ball.y = REST + R; ball.vx = 0; ball.vy = 0;
                if (input.plunge) {
                    charge = Math.min(1, charge + h / 0.9);
                    wasPlunge = true;
                } else if (wasPlunge) {
                    ball.vy = 1.95 + 1.0 * charge;
                    wasPlunge = false; charge = 0;
                    events.push('launch');
                }
                if (ball.vy === 0) return;
            }

            ball.vy -= GRAVITY * h;
            ball.vx *= 1 - 0.03 * h; ball.vy *= 1 - 0.03 * h;
            const sp = Math.hypot(ball.vx, ball.vy);
            if (sp > MAX_SPEED) { ball.vx *= MAX_SPEED / sp; ball.vy *= MAX_SPEED / sp; }
            ball.x += ball.vx * h; ball.y += ball.vy * h;

            for (let i = 0; i < WALLS.length; i++) hitSegment(WALLS[i], 0, 0.45);
            if (inPlay) hitSegment(GATE, 0, 0.45);
            hitFlipper(0); hitFlipper(1);

            for (let i = 0; i < BUMPERS.length; i++) {
                cool.bumpers[i] -= h;
                if (hitCircle(BUMPERS[i], BUMPERS[i].r, 1.3) && cool.bumpers[i] <= 0) {
                    cool.bumpers[i] = 0.08; add(100); events.push('bumper');
                }
            }
            for (let i = 0; i < TARGETS.length; i++) {
                cool.targets[i] -= h;
                if (hitCircle(TARGETS[i], TARGET_R, 0) && cool.targets[i] <= 0) {
                    cool.targets[i] = 0.3; add(lit.targets[i] ? 50 : 250); lit.targets[i] = true; events.push('target');
                    if (lit.targets.every(Boolean)) { add(1000); lit.targets.fill(false); events.push('bonus'); }
                }
            }
            for (let i = 0; i < ROLLOVERS.length; i++) {
                if (!lit.rollovers[i] && Math.hypot(ball.x - ROLLOVERS[i].x, ball.y - ROLLOVERS[i].y) < ROLLOVER_R) {
                    lit.rollovers[i] = true; add(150); events.push('target');
                    if (lit.rollovers.every(Boolean)) { mult = Math.min(5, mult + 1); lit.rollovers.fill(false); events.push('bonus'); }
                }
            }

            if (!inPlay && ball.x < LANE - R) { inPlay = true; save = saved ? 0 : saveTime; }
            if (inPlay && ball.x > LANE + R * 0.5 && ball.y < 0.74) inPlay = false;

            if (ball.y < -0.04) {
                if (inPlay && save > 0) {
                    saved = true;
                    events.push('saved');
                } else if (inPlay) {
                    ballsLeft -= 1; mult = 1; saved = false; lit.rollovers.fill(false);
                    events.push('drain');
                    if (ballsLeft <= 0) { over = true; return; }
                }
                pause = 0.8;
                serve();
            }
        }

        return {
            layout,
            input(v) {
                if (!v) return;
                if ('left' in v) input.left = !!v.left;
                if ('right' in v) input.right = !!v.right;
                if ('plunge' in v) input.plunge = !!v.plunge;
            },
            step(dt) {
                if (over) return;
                if (pause > 0) { pause -= dt; return; }
                if (save > 0 && inPlay) save -= dt;
                carry += Math.min(dt, 0.05);
                while (carry >= STEP && !over && pause <= 0) { substep(STEP); carry -= STEP; }

                if (inPlay && Math.hypot(ball.vx, ball.vy) < 0.03 && !input.left && !input.right) {
                    still += dt;
                    if (still > 3) { ball.vx = (Math.random() - 0.5) * 0.6; ball.vy = 0.5; still = 0; }
                } else still = 0;
            },
            events() { const e = events; events = []; return e; },
            snapshot() {
                return {
                    x: ball.x, y: ball.y, la: flipAngle(0), ra: flipAngle(1),
                    score, balls: ballsLeft, mult, over, charge, save: inPlay && save > 0,
                };
            },
            lit,
            get over() { return over; },
        };
    }

    (root.RSVXSims = root.RSVXSims || {}).pinball = { layout, create };

    if (typeof window === 'undefined') return;

    (window.RSVXGames = window.RSVXGames || {}).pinball = {
        title: 'PINBALL',
        help: 'A / D  FLIPPERS   HOLD SPACE  LAUNCH',

        init(api) {
            const { W, H, TOP: HUD } = api;
            const sim = create(api.tune);
            const S = (H - HUD - 8) / layout.LENGTH;
            const OX = 118, OY = H - 4;
            const px = x => OX + x * S, py = y => OY - y * S;
            let shown = 0, endTimer = 0;

            function line(g, s, color, width) {
                g.strokeStyle = color; g.lineWidth = width;
                g.beginPath(); g.moveTo(px(s.x1), py(s.y1)); g.lineTo(px(s.x2), py(s.y2)); g.stroke();
            }
            function disc(g, x, y, r, color) {
                g.fillStyle = color;
                g.beginPath(); g.arc(px(x), py(y), r * S, 0, Math.PI * 2); g.fill();
            }

            return {
                key(code, down) {
                    if (code === 'ArrowLeft') sim.input({ left: down });
                    else if (code === 'ArrowRight') sim.input({ right: down });
                    else if (code === 'Space' || code === 'ArrowDown') sim.input({ plunge: down });
                },

                update(dt) {
                    sim.step(dt);
                    sim.events().forEach(e => {
                        if (e === 'bumper') api.beep(660, 0.05);
                        else if (e === 'target') api.beep(880, 0.06, 'triangle');
                        else if (e === 'bonus') api.beep(1320, 0.25, 'triangle');
                        else if (e === 'flip') api.beep(140, 0.03, 'sawtooth');
                        else if (e === 'launch') api.beep(220, 0.12, 'sawtooth');
                        else if (e === 'drain') api.beep(110, 0.4, 'sawtooth');
                        else if (e === 'saved') api.beep(520, 0.15);
                    });
                    const s = sim.snapshot();
                    if (s.score !== shown) { api.add(s.score - shown); shown = s.score; }
                    if (s.over) { endTimer += dt; if (endTimer > 1.2) api.end(); }
                },

                draw(g) {
                    const s = sim.snapshot();
                    g.fillStyle = '#101820';
                    g.fillRect(px(-layout.HALF) - 2, py(layout.LENGTH) - 2, layout.HALF * 2 * S + 4, layout.LENGTH * S + 6);
                    layout.WALLS.forEach(w => line(g, w, '#7d7350', 1.5));
                    layout.ROLLOVERS.forEach((r, i) => disc(g, r.x, r.y, 0.012, sim.lit.rollovers[i] ? '#e8c860' : '#2a3038'));
                    layout.TARGETS.forEach((t, i) => disc(g, t.x, t.y, layout.TARGET_R, sim.lit.targets[i] ? '#7fc66a' : '#d6553f'));
                    layout.BUMPERS.forEach(b => { disc(g, b.x, b.y, b.r, '#d6553f'); disc(g, b.x, b.y, b.r * 0.55, '#e6e6da'); });
                    [[layout.PIVOT_L, s.la], [layout.PIVOT_R, s.ra]].forEach(([p, deg]) => {
                        const a = (deg * Math.PI) / 180;
                        line(g, { x1: p.x, y1: p.y, x2: p.x + Math.cos(a) * layout.FLIP_LEN, y2: p.y + Math.sin(a) * layout.FLIP_LEN },
                            '#e8c860', layout.FLIP_R * 2 * S);
                    });
                    if (!s.over) disc(g, s.x, s.y, layout.R, '#e6e6da');

                    api.text('BALLS', 250, HUD + 20, '#7d7350', 8, 'center');
                    api.text(String(Math.max(0, s.balls)), 250, HUD + 32, '#e6e6da', 16, 'center');
                    api.text('BONUS', 250, HUD + 66, '#7d7350', 8, 'center');
                    api.text('x' + s.mult, 250, HUD + 78, '#e8c860', 16, 'center');
                    if (s.save) api.text('BALL SAVE', 250, HUD + 112, '#7fc66a', 8, 'center');
                    if (s.charge > 0) {
                        g.fillStyle = '#0d1118'; g.fillRect(244, HUD + 130, 12, 60);
                        g.fillStyle = '#e09048'; g.fillRect(244, HUD + 130 + 60 * (1 - s.charge), 12, 60 * s.charge);
                    }
                },
            };
        },
    };
})();
