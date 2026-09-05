window.showTooltip = function(text) {
    const tooltip = document.createElement('div');
    tooltip.textContent = text;
    tooltip.style.cssText = 'position:fixed;top:20px;right:20px;background:var(--hi);color:white;padding:12px 20px;border-radius:8px;font-weight:600;z-index:9999;animation:slideIn 0.3s;';
    document.body.appendChild(tooltip);

    setTimeout(() => {
        tooltip.style.animation = 'slideOut 0.3s';
        setTimeout(() => tooltip.remove(), 300);
    }, 2000);
};

window.UIUtils = (function() {
    let pinnedMsgs = [];
    let typingPlayers = new Set();
    let typingTimeouts = new Map();
    let inputDebounce = null;

    function updatePinnedMessages(pinned) {
        pinnedMsgs = pinned;

        let pinnedContainer = document.getElementById('pinned-msgs');
        if (!pinnedContainer) {
            pinnedContainer = document.createElement('div');
            pinnedContainer.id = 'pinned-msgs';
            pinnedContainer.style.cssText = 'background:var(--bg2);border-bottom:1px solid var(--line);padding:8px 12px;display:none;';
            const mWrap = document.getElementById('msg-wrap');
            const msgs  = document.getElementById('msgs');
            mWrap.insertBefore(pinnedContainer, msgs);
        }

        if (pinned.length === 0) {
            pinnedContainer.style.display = 'none';
            return;
        }

        pinnedContainer.style.display = 'block';
        pinnedContainer.innerHTML = '<div style="color:var(--hi);font-weight:600;font-size:12px;margin-bottom:4px;"><i class="fa-solid fa-thumbtack" style="margin-right:5px;"></i>PINNED</div>';

        pinned.forEach(msg => {
            const el = document.createElement('div');
            el.style.cssText = 'font-size:13px;color:var(--text);margin-bottom:4px;padding:4px;background:var(--bg3);border-radius:4px;cursor:context-menu;';
            el.innerHTML = `<b style="color:var(--bright);">${window.escapeHtml(msg.name)}:</b> ${window.escapeHtml(msg.message)}`;

            if (window.CFG.pinning?.enabled) {
                el.addEventListener('contextmenu', (e) => {
                    e.preventDefault();

                    const existing = document.getElementById('pinned-ctx-menu');
                    if (existing) existing.remove();

                    const menu = document.createElement('div');
                    menu.id = 'pinned-ctx-menu';
                    menu.style.cssText = `position:fixed;left:${e.clientX}px;top:${e.clientY}px;background:var(--bg2);border:1px solid var(--line);border-radius:6px;padding:4px;z-index:1001;min-width:140px;box-shadow:0 4px 12px rgba(0,0,0,0.3);`;

                    const btn = document.createElement('button');
                    btn.innerHTML = `<i class="fa-solid fa-thumbtack-slash" style="width:16px;margin-right:8px;font-size:12px;"></i><span style="font-size:13px;">Unpin</span>`;
                    btn.style.cssText = 'width:100%;text-align:left;padding:6px 10px;background:transparent;border:none;color:var(--text);cursor:pointer;border-radius:4px;transition:background 0.2s;display:flex;align-items:center;';
                    btn.onmouseenter = () => btn.style.background = 'var(--line)';
                    btn.onmouseleave = () => btn.style.background = 'transparent';
                    btn.onclick = () => {
                        window.nui('unpinMessage', { msgId: msg.id });
                        menu.remove();
                    };

                    menu.appendChild(btn);
                    document.body.appendChild(menu);

                    const close = (ev) => {
                        if (!menu.contains(ev.target)) {
                            menu.remove();
                            document.removeEventListener('click', close);
                        }
                    };
                    setTimeout(() => document.addEventListener('click', close), 10);
                });
            }

            pinnedContainer.appendChild(el);
        });
    }

    function showTypingIndicator(playerId) {
        if (!window.CFG?.typingIndicators?.enabled) return;

        typingPlayers.add(playerId);

        let typingEl = document.getElementById('typing-indicator');
        if (!typingEl) {
            typingEl = document.createElement('div');
            typingEl.id = 'typing-indicator';
            typingEl.style.cssText = 'padding:4px 12px;font-size:12px;color:var(--dim);font-style:italic;';
            const msgs = document.getElementById('msgs');
            msgs.parentElement.insertBefore(typingEl, msgs.nextSibling);
        }

        typingEl.textContent = typingPlayers.size === 1
            ? 'Someone is typing...'
            : `${typingPlayers.size} people are typing...`;

        if (typingTimeouts.has(playerId)) clearTimeout(typingTimeouts.get(playerId));

        typingTimeouts.set(playerId, setTimeout(() => {
            typingPlayers.delete(playerId);
            typingTimeouts.delete(playerId);
            typingEl.textContent = typingPlayers.size === 0 ? '' :
                typingPlayers.size === 1 ? 'Someone is typing...' : `${typingPlayers.size} people are typing...`;
        }, window.CFG.typingIndicators.timeout || 3000));
    }

    function handleTypingInput(inp) {
        if (window.CFG?.typingIndicators?.enabled && inp.value.startsWith('/pm ')) {
            const match = inp.value.match(/^\/pm (\d+)/);
            if (match) {
                clearTimeout(inputDebounce);
                inputDebounce = setTimeout(() => {
                    window.nui('typing', { targetId: parseInt(match[1]) });
                }, 500);
            }
        }
    }

    const style = document.createElement('style');
    style.textContent = `
        @keyframes slideIn {
            from { transform: translateX(100%); opacity: 0; }
            to   { transform: translateX(0);    opacity: 1; }
        }
        @keyframes slideOut {
            from { transform: translateX(0);    opacity: 1; }
            to   { transform: translateX(100%); opacity: 0; }
        }
    `;
    document.head.appendChild(style);

    return {
        updatePinnedMessages,
        showTypingIndicator,
        handleTypingInput,
        getPinnedMessages: () => pinnedMsgs
    };
})();
