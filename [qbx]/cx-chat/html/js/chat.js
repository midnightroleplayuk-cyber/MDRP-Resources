let CFG = { formatting: { enabled: true }, timestamps: { enabled: true }, maxMessages: 100 };
window.OWN_CMDS = [];
let hideTimer = null;
let hist = [];
let hIdx = -1;

const root = document.getElementById('root');
const mWrap = document.getElementById('msg-wrap');
const msgs = document.getElementById('msgs');
const inpPan = document.getElementById('inp-panel');
const inp = document.getElementById('chat-inp');

function nui(callback, data = {}) {
    return fetch(`https://${GetParentResourceName()}/${callback}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    })
    .then(r => r.json())
    .catch(() => null);
}

window.nui = nui;

function escapeHtml(str) {
    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;');
}

window.escapeHtml = escapeHtml;

function hidePop() {
    const popup = document.getElementById('cmd-popup');
    if (popup) popup.style.display = 'none';
}

function formatMessage(raw) {
    if (!CFG.formatting?.enabled) return escapeHtml(raw);

    const tokens = [];

    const hold = raw
        .replace(/\*\*(.*?)\*\*/g, (_, m) => { tokens.push(`<b>${escapeHtml(m)}</b>`); return `\x00${tokens.length - 1}\x00`; })
        .replace(/\*(.*?)\*/g,     (_, m) => { tokens.push(`<i>${escapeHtml(m)}</i>`); return `\x00${tokens.length - 1}\x00`; })
        .replace(/__(.*?)__/g,     (_, m) => { tokens.push(`<u>${escapeHtml(m)}</u>`); return `\x00${tokens.length - 1}\x00`; })
        .replace(/`(.*?)`/g,       (_, m) => { tokens.push(`<code>${escapeHtml(m)}</code>`); return `\x00${tokens.length - 1}\x00`; });

    return escapeHtml(hold).replace(/\x00(\d+)\x00/g, (_, i) => tokens[Number(i)]);
}

window.formatMessage = formatMessage;

function startHideTimer() {
    clearTimeout(hideTimer);
    hideTimer = setTimeout(() => {
        mWrap.classList.remove('show');
    }, 5000);
}

function cancelHideTimer() {
    clearTimeout(hideTimer);
}

window.startHideTimer = startHideTimer;
window.cancelHideTimer = cancelHideTimer;

function openChat(channel, channelColor) {
    cancelHideTimer();
    mWrap.classList.add('show');
    inpPan.classList.add('open');

    const label = document.getElementById('ch-label');
    label.innerHTML = `<i class="fa-solid fa-earth-americas"></i> ${escapeHtml(channel || 'Global')}`;

    if (channelColor) {
        label.style.color       = channelColor;
        label.style.background  = channelColor + '20';
        label.style.borderColor = channelColor + '40';
    } else {
        label.style.color       = 'var(--dim)';
        label.style.background  = 'rgba(125,125,125,0.1)';
        label.style.borderColor = 'transparent';
    }

    setTimeout(() => inp.focus(), 40);
}

function closeChat() {
    inpPan.classList.remove('open');
    hidePop();

    if (msgs.childElementCount > 0) {
        startHideTimer();
    } else {
        mWrap.classList.remove('show');
    }
}

function clearMessages() {
    msgs.innerHTML = '';
    mWrap.classList.remove('show');
    cancelHideTimer();
}

function applyTheme(theme, customTheme) {
    const root = document.documentElement;
    const vars = ['--bg','--bg2','--bg3','--line','--hi','--text','--bright','--dim','--r'];

    vars.forEach(v => root.style.removeProperty(v));
    document.body.className = '';

    if (theme === 'custom' && customTheme) {
        root.style.setProperty('--bg',     customTheme.bg     || '');
        root.style.setProperty('--bg2',    customTheme.bg2    || '');
        root.style.setProperty('--bg3',    customTheme.bg3    || '');
        root.style.setProperty('--line',   customTheme.line   || '');
        root.style.setProperty('--hi',     customTheme.hi     || '');
        root.style.setProperty('--text',   customTheme.text   || '');
        root.style.setProperty('--bright', customTheme.bright || '');
        root.style.setProperty('--dim',    customTheme.dim    || '');
        root.style.setProperty('--r',      customTheme.radius || '10px');
    } else if (theme && theme !== 'custom') {
        document.body.className = 'theme-' + theme;
    }
}

window.applyTheme = applyTheme;

window.addEventListener('message', e => {
    const d = e.data;
    if (!d || !d.type) return;

    if (d.type === 'init') {
        CFG = d.config;
        root.style.width     = CFG.chatWidth  + 'px';
        msgs.style.maxHeight = CFG.chatHeight + 'px';

        window.CFG = CFG;

        if (CFG.ownCommands) {
            window.OWN_CMDS = CFG.ownCommands;
        }

        const chLabel = document.getElementById('ch-label');
        if (chLabel) chLabel.style.display = CFG.disableChatMessages ? 'none' : '';

        const chatInp = document.getElementById('chat-inp');
        if (chatInp && CFG.disableChatMessages) chatInp.placeholder = 'Type a /command...';

        const reportBtn = document.getElementById('btn-quick-report');
        if (reportBtn) reportBtn.style.display = CFG.reportEnabled === false ? 'none' : '';

        if (CFG.reportCats) {
            window.dispatchEvent(new CustomEvent('cx:initReport', { detail: { cats: CFG.reportCats, locked: CFG.reportEnabled === false } }));
        }

        nui('getSavedTheme', {}).then(res => {
            const savedTheme = (res && res.theme && res.theme !== '') ? res.theme
                : (() => { try { return localStorage.getItem('cx_chat_theme_v1'); } catch(_) { return null; } })();
            const themeToUse = savedTheme || CFG.theme;
            applyTheme(themeToUse, CFG.customTheme);
            window.dispatchEvent(new CustomEvent('cx:themeReady', { detail: themeToUse }));
        });

        nui('getSavedPosition', {}).then(res => {
            if (res) window.dispatchEvent(new CustomEvent('cx:posReady', { detail: res }));
        });

        nui('uiReady');

    } else if (d.type === 'open') {
        openChat(d.channel, d.channelColor);

    } else if (d.type === 'close') {
        closeChat();

    } else if (d.type === 'addMessage') {
        window.addMsg(d.data);

    } else if (d.type === 'clearMessages') {
        clearMessages();

    } else if (d.type === 'setCommands') {
        setTimeout(() => {
            window.dispatchEvent(new CustomEvent('cx:setCommands', { detail: d.commands || [] }));
        }, 0);

    } else if (d.type === 'applyTheme') {
        const themeToUse = d.theme || CFG.theme;
        try { localStorage.setItem('cx_chat_theme_v1', themeToUse); } catch(_) {}
        applyTheme(themeToUse, CFG.customTheme);
        window.dispatchEvent(new CustomEvent('cx:themeReady', { detail: themeToUse }));
    }
});

inp.addEventListener('keydown', e => {
    if (e.key === 'Tab') {
        e.preventDefault();
        if (!CFG.disableChatMessages) nui('cycleChatTabs');
        return;
    }

    if (e.key === 'Enter') {
    e.preventDefault();
    const msg = inp.value.trim();
    if (msg !== '') {
        if (inp.dataset.editing) {
            nui('editMessage', { msgId: inp.dataset.editing, newText: msg });
            delete inp.dataset.editing;
        } else {
            hist.unshift(msg);
            if (hist.length > 50) hist.pop();
            hIdx = -1;
            nui('chatResult', { message: msg });
        }
        inp.value = '';
    } else {
        nui('closeChat');
    }
    return;
}

    if (e.key === 'Escape') {
        nui('closeChat');
        return;
    }

    if (e.key === 'ArrowUp' && document.getElementById('cmd-popup').style.display !== 'block') {
        e.preventDefault();
        if (hIdx < hist.length - 1) { hIdx++; inp.value = hist[hIdx]; }
        return;
    }

    if (e.key === 'ArrowDown' && document.getElementById('cmd-popup').style.display !== 'block') {
        e.preventDefault();
        if (hIdx > 0) { hIdx--; inp.value = hist[hIdx]; }
        else { hIdx = -1; inp.value = ''; }
        return;
    }

    if (e.key === 'PageUp')   { e.preventDefault(); msgs.scrollTop -= 60; return; }
    if (e.key === 'PageDown') { e.preventDefault(); msgs.scrollTop += 60; return; }
});

setTimeout(() => nui('uiReady'), 0);
