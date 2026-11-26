(window.RSVXGames = window.RSVXGames || {}).snake = {
    title: 'VIPER',
    help: 'ARROWS / WASD  MOVE',

    init(api) {
        const C = 8;
        const cols = Math.floor(api.W / C);
        const rows = Math.floor((api.H - api.TOP) / C);
        const DIRS = { ArrowUp: [0, -1], ArrowDown: [0, 1], ArrowLeft: [-1, 0], ArrowRight: [1, 0] };

        const body = [{ x: 12, y: 14 }, { x: 11, y: 14 }, { x: 10, y: 14 }];
        let dir = { x: 1, y: 0 };
        const queue = [];
        let food, timer = 0, step = 0.11;

        function drop() {
            do {
                food = { x: Math.floor(Math.random() * cols), y: Math.floor(Math.random() * rows) };
            } while (body.some(b => b.x === food.x && b.y === food.y));
        }
        drop();

        function tick() {
            if (queue.length) dir = queue.shift();
            const head = { x: body[0].x + dir.x, y: body[0].y + dir.y };
            const dead = head.x < 0 || head.y < 0 || head.x >= cols || head.y >= rows ||
                body.some(b => b.x === head.x && b.y === head.y);
            if (dead) {
                api.beep(110, 0.35, 'sawtooth');
                api.end();
                return false;
            }
            body.unshift(head);
            if (head.x === food.x && head.y === food.y) {
                api.add(10);
                api.beep(700, 0.05);
                step = Math.max(0.05, step * 0.985);
                drop();
            } else {
                body.pop();
            }
            return true;
        }

        return {
            key(code, down) {
                const d = down && DIRS[code];
                if (!d) return;
                const last = queue.length ? queue[queue.length - 1] : dir;
                if (d[0] === -last.x && d[1] === -last.y) return;
                if (d[0] === last.x && d[1] === last.y) return;
                if (queue.length < 3) queue.push({ x: d[0], y: d[1] });
            },

            update(dt) {
                timer += dt;
                while (timer >= step) {
                    timer -= step;
                    if (!tick()) return;
                }
            },

            draw(g) {
                const oy = api.TOP;
                g.fillStyle = '#0a1410';
                g.fillRect(0, oy, api.W, rows * C);
                g.fillStyle = '#d6553f';
                g.fillRect(food.x * C + 1, oy + food.y * C + 1, C - 2, C - 2);
                body.forEach((b, i) => {
                    g.fillStyle = i === 0 ? '#c9f08a' : '#6fb04e';
                    g.fillRect(b.x * C, oy + b.y * C, C - 1, C - 1);
                });
            },
        };
    },
};
