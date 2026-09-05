let cmds = [];
let sel  = -1;
let waiting = false;

const pop = document.getElementById('cmd-popup');

function getOwn() {
    const own    = window.OWN_CMDS || [];
    const ownSet = new Set(own.map(c => (c.command || '').toLowerCase()));

    if (!cmds.length) return own;

    const filtered = cmds.filter(c => c.own || ownSet.has((c.command || '').toLowerCase()));
    return filtered.length ? filtered : own;
}

window.addEventListener('cx:setCommands', e => {
    cmds = e.detail || [];
    const chatInp = document.getElementById('chat-inp');
    if (waiting && chatInp.value === '/') {
        waiting = false;
        show(getOwn());
    }
});

function hide() {
    pop.style.display = 'none';
    sel = -1;
}

function show(list) {
    pop.innerHTML = '';
    if (!list.length) { pop.style.display = 'none'; return; }

    sel = 0;

    list.slice(0, 8).forEach((cmd, i) => {
        const item = document.createElement('div');
        item.className = 'cmd-item' + (i === 0 ? ' sel' : '');

        let html = `<span class="cmd-name">/${window.escapeHtml(cmd.command)}</span>`;

        if (cmd.params?.length) {
            cmd.params.forEach(p => {
                html += `<span class="cmd-param">&lt;${window.escapeHtml(p.name)}&gt;</span>`;
            });
        }

        if (cmd.help) {
            html += `<span class="cmd-help">${window.escapeHtml(cmd.help)}</span>`;
        }

        item.innerHTML = html;

        const chatInp = document.getElementById('chat-inp');
        item.addEventListener('click', () => {
            chatInp.value = '/' + cmd.command + ' ';
            hide();
            chatInp.focus();
        });

        pop.appendChild(item);
    });

    pop.style.display = 'block';
}

function move(dir) {
    const items = pop.querySelectorAll('.cmd-item');
    if (!items.length) return;
    items[sel]?.classList.remove('sel');
    sel = (sel + dir + items.length) % items.length;
    items[sel]?.classList.add('sel');
}

document.getElementById('chat-inp').addEventListener('input', e => {
    const val = e.target.value;
    if (!val.startsWith('/')) { hide(); return; }

    const parts   = val.slice(1).split(' ');
    const q       = parts[0].toLowerCase();
    const hasSpace = val.includes(' ');

    if (hasSpace) {
        const exact = cmds.find(c => (c.command || '').toLowerCase() === q);
        if (exact?.params?.length) {
            show([exact]);
        } else {
            hide();
        }
        return;
    }

    if (!q) {
        const own = getOwn();
        if (!own.length) {
            waiting = true;
            hide();
        } else {
            waiting = false;
            show(own);
        }
        return;
    }

    const ownSet     = new Set((window.OWN_CMDS || []).map(c => (c.command || '').toLowerCase()));
    const matchOwn   = cmds.filter(c =>  (c.own || ownSet.has((c.command || '').toLowerCase())) && (c.command || '').toLowerCase().startsWith(q));
    const matchOther = cmds.filter(c => !(c.own || ownSet.has((c.command || '').toLowerCase())) && (c.command || '').toLowerCase().startsWith(q));

    const all = [...matchOwn, ...matchOther];
    all.length ? show(all) : hide();
});

document.getElementById('chat-inp').addEventListener('keydown', e => {
    if (pop.style.display !== 'block') return;

    if (e.key === 'ArrowUp') {
        e.preventDefault();
        move(-1);
    } else if (e.key === 'ArrowDown') {
        e.preventDefault();
        move(1);
    } else if (e.key === 'Tab') {
        e.preventDefault();
        const items = pop.querySelectorAll('.cmd-item');
        const item  = items[sel];
        if (item) {
            const name = item.querySelector('.cmd-name')?.textContent?.replace('/', '');
            const chatInp = document.getElementById('chat-inp');
            if (name) { chatInp.value = '/' + name + ' '; hide(); }
        }
    } else if (e.key === 'Escape') {
        hide();
    }
});

document.addEventListener('click', e => {
    if (!e.target.closest('#cmd-popup') && !e.target.closest('#chat-inp')) hide();
});

window.hidePop = hide;
