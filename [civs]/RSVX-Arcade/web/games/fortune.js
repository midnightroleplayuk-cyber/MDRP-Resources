(window.RSVXGames = window.RSVXGames || {}).fortune = {
    title: 'MYSTIC',
    help: 'SPACE  DRAW A CARD',
    noScore: true,
    noBoard: true,
    overTitle: 'FAREWELL',
    blurb: ['CROSS HER PALM WITH SILVER', 'AND LEARN WHAT IS COMING'],

    init(api) {
        const { W, TOP } = api;
        const LINES = [
            'A stranger in a hi-vis jacket will change your week.',
            'Money is coming. So is a parking ticket.',
            'Somebody you gave a lift to still owes you a favour.',
            'Avoid the motorway on a Thursday.',
            'You will be asked for your licence before the month is out.',
            'An old friend is closer than you think. Check the chippy.',
            'The thing you lost is in the boot of the car.',
            'Say yes to the next job offer, however odd it sounds.',
            'Your luck turns the moment you stop counting it.',
            'Someone nearby is pretending not to know you.',
            'A short journey will take much longer than planned.',
            'Trust the one who buys the first round.',
            'Rain tomorrow. This one is less a prophecy, more a habit.',
            'You already know the answer. You just want a second opinion.',
        ];
        const pick = LINES[Math.floor(Math.random() * LINES.length)];
        const wrapped = [];
        let row = '';
        for (const word of pick.split(' ')) {
            if ((row + ' ' + word).trim().length > 30) { wrapped.push(row); row = word; }
            else row = (row + ' ' + word).trim();
        }
        wrapped.push(row);

        let stage = 0, t = 0;

        return {
            key(code, down) {
                if (!down || (code !== 'Space' && code !== 'Enter')) return;
                if (stage === 0) { stage = 1; t = 0; api.beep(220, 0.4, 'triangle'); }
                else if (stage === 2 && t > 1) api.end();
            },

            update(dt) {
                t += dt;
                if (stage === 1 && t > 1.6) { stage = 2; t = 0; api.beep(660, 0.3, 'triangle'); }
                if (stage === 2 && t > 12) api.end();
            },

            draw(g) {
                const cx = W / 2;
                g.fillStyle = '#2a1c3a';
                g.fillRect(cx - 34, TOP + 14, 68, 60);
                g.fillStyle = stage === 1 && Math.floor(t * 8) % 2 ? '#c9a8e8' : '#a878c8';
                g.fillRect(cx - 18, TOP + 24, 36, 36);
                g.fillStyle = '#e6e6da';
                g.fillRect(cx - 10, TOP + 30, 8, 8);
                g.fillStyle = '#3a3628';
                g.fillRect(cx - 24, TOP + 60, 48, 8);

                if (stage === 0) api.text('PRESS SPACE TO DRAW A CARD', cx, TOP + 110, '#e6e6da', 9, 'center');
                else if (stage === 1) api.text('THE CARDS ARE TURNING', cx, TOP + 110, '#7d7350', 9, 'center');
                else {
                    wrapped.forEach((l, i) => api.text(l.toUpperCase(), cx, TOP + 100 + i * 14, '#e8c860', 9, 'center'));
                    if (t > 1) api.text('SPACE TO FINISH', cx, TOP + 196, '#7d7350', 8, 'center');
                }
            },
        };
    },
};
