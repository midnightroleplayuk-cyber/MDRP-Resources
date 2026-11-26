(window.RSVXGames = window.RSVXGames || {}).siege = {
    title: 'STAR SIEGE',
    help: 'LEFT / RIGHT  MOVE   SPACE  FIRE',

    init(api) {
        const { W, H, TOP } = api;
        const COLS = 8, ROWS = 4, AW = 12, AH = 8, GX = 22, GY = 16;
        const ROW_PTS = [30, 20, 20, 10];
        const ROW_COL = ['#d6553f', '#e09048', '#e8c860', '#7fc66a'];
        const SPRITE = [
            ['001000000100', '000100001000', '001111111100', '011011110110', '111111111111', '101111111101', '101000000101', '000110011000'],
            ['001000000100', '100100001001', '101111111101', '111011110111', '111111111111', '001111111100', '001000000100', '010000000010'],
        ];

        const ship = { x: W / 2 - 7, y: H - 14, w: 14, h: 6 };
        let aliens = [], shots = [], bombs = [];
        let wave = 0, lives = 3, safe = 0, dir = 1, stepT = 0, bombT = 1, frameNo = 0;

        function muster() {
            wave++;
            aliens = [];
            const left = (W - ((COLS - 1) * GX + AW)) / 2;
            for (let r = 0; r < ROWS; r++) {
                for (let c = 0; c < COLS; c++) {
                    aliens.push({ x: left + c * GX, y: TOP + 14 + Math.min(wave - 1, 4) * 6 + r * GY, r });
                }
            }
            dir = 1;
            stepT = 0;
            shots = [];
            bombs = [];
        }
        muster();

        function hit(a, b) {
            return a.x < b.x + b.w && a.x + a.w > b.x && a.y < b.y + b.h && a.y + a.h > b.y;
        }

        function march() {
            frameNo ^= 1;
            let edge = false;
            for (const a of aliens) {
                if ((dir > 0 && a.x + AW + 4 > W - 4) || (dir < 0 && a.x - 4 < 4)) { edge = true; break; }
            }
            for (const a of aliens) {
                if (edge) a.y += 8; else a.x += 4 * dir;
            }
            if (edge) dir = -dir;
            api.beep(edge ? 90 : 120, 0.03);
        }

        return {
            key(code, down) {
                if (down && code === 'Space' && shots.length < 2) {
                    shots.push({ x: ship.x + ship.w / 2 - 1, y: ship.y - 4, w: 2, h: 5 });
                    api.beep(900, 0.04);
                }
            },

            update(dt) {
                const dx = (api.held('ArrowRight') ? 1 : 0) - (api.held('ArrowLeft') ? 1 : 0);
                ship.x = Math.max(4, Math.min(W - ship.w - 4, ship.x + dx * 130 * dt));
                if (safe > 0) safe -= dt;

                const base = Math.max(0.25, 0.6 - wave * 0.05);
                const gap = Math.max(0.04, base * (aliens.length / (COLS * ROWS)));
                stepT += dt;
                while (stepT >= gap) { stepT -= gap; march(); }

                for (const s of shots) s.y -= 260 * dt;
                for (const b of bombs) b.y += (110 + wave * 8) * dt;
                shots = shots.filter(s => s.y > TOP);
                bombs = bombs.filter(b => b.y < H);

                for (const s of shots) {
                    for (const a of aliens) {
                        if (!a.dead && hit(s, { x: a.x, y: a.y, w: AW, h: AH })) {
                            a.dead = true;
                            s.y = -99;
                            api.add(ROW_PTS[a.r]);
                            api.beep(240, 0.05, 'sawtooth');
                            break;
                        }
                    }
                }
                aliens = aliens.filter(a => !a.dead);
                shots = shots.filter(s => s.y > TOP);

                bombT -= dt;
                if (bombT <= 0 && aliens.length) {
                    bombT = Math.max(0.45, 1.2 - wave * 0.08) * (0.6 + Math.random() * 0.8);
                    const a = aliens[Math.floor(Math.random() * aliens.length)];
                    let low = a;
                    for (const o of aliens) if (o.x === a.x && o.y > low.y) low = o;
                    bombs.push({ x: low.x + AW / 2 - 1, y: low.y + AH, w: 2, h: 5 });
                }

                if (safe <= 0) {
                    for (const b of bombs) {
                        if (hit(b, ship)) {
                            b.y = H + 99;
                            lives--;
                            safe = 1.2;
                            api.beep(120, 0.3, 'sawtooth');
                            if (lives <= 0) return api.end();
                            break;
                        }
                    }
                }

                for (const a of aliens) {
                    if (a.y + AH >= ship.y) {
                        api.beep(100, 0.4, 'sawtooth');
                        return api.end();
                    }
                }

                if (!aliens.length) {
                    api.add(200);
                    api.beep(880, 0.2);
                    muster();
                }
            },

            draw(g) {
                const spr = SPRITE[frameNo];
                for (const a of aliens) {
                    g.fillStyle = ROW_COL[a.r];
                    for (let y = 0; y < AH; y++) {
                        for (let x = 0; x < AW; x++) {
                            if (spr[y][x] === '1') g.fillRect(a.x + x, a.y + y, 1, 1);
                        }
                    }
                }
                if (safe <= 0 || Math.floor(safe * 10) % 2 === 0) {
                    g.fillStyle = '#5fc4d0';
                    g.fillRect(ship.x, ship.y + 2, ship.w, 4);
                    g.fillRect(ship.x + 5, ship.y - 1, 4, 3);
                }
                g.fillStyle = '#e6e6da';
                for (const s of shots) g.fillRect(s.x, s.y, s.w, s.h);
                g.fillStyle = '#d6553f';
                for (const b of bombs) g.fillRect(b.x, b.y, b.w, b.h);
                g.fillStyle = '#232a33';
                g.fillRect(0, H - 5, W, 1);
                api.text('WAVE ' + wave, 6, TOP + 2, '#7d7350');
                api.text('SHIPS ' + lives, W - 6, TOP + 2, '#7d7350', 8, 'right');
            },
        };
    },
};
