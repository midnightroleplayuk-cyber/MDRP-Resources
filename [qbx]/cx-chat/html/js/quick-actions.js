window.QuickActions = (function() {
    let currentMenu = null;

    function addContextMenu(msgEl, authorId, msgId, messages) {
        if (!window.CFG?.quickActions?.enabled) return;

        msgEl.addEventListener('contextmenu', (e) => {
            e.preventDefault();

            if (currentMenu) {
                currentMenu.remove();
                currentMenu = null;
            }

            const menu = document.createElement('div');
            currentMenu = menu;
            menu.className = 'quick-actions-menu';
            menu.style.cssText = `
                position: fixed;
                left: ${e.clientX}px;
                top: ${e.clientY}px;
                background: var(--bg2);
                border: 1px solid var(--line);
                border-radius: 6px;
                padding: 4px;
                z-index: 1000;
                min-width: 160px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.3);
            `;

            const actions = buildActions(authorId, msgId, messages, window.UIUtils.getPinnedMessages());

            actions.forEach(action => {
                const btn = document.createElement('button');
                btn.innerHTML = `<i class="fa-solid ${action.icon}" style="width:16px;margin-right:8px;font-size:12px;"></i><span style="font-size:13px;">${action.label}</span>`;
                btn.style.cssText = 'width:100%;text-align:left;padding:6px 10px;background:transparent;border:none;color:var(--text);cursor:pointer;border-radius:4px;transition:background 0.2s;display:flex;align-items:center;';
                btn.onmouseenter = () => btn.style.background = 'var(--line)';
                btn.onmouseleave = () => btn.style.background = 'transparent';
                btn.onclick = () => {
                    action.action();
                    menu.remove();
                    currentMenu = null;
                };
                menu.appendChild(btn);
            });

            document.body.appendChild(menu);

            const closeMenu = (e) => {
                if (!menu.contains(e.target)) {
                    menu.remove();
                    currentMenu = null;
                    document.removeEventListener('click', closeMenu);
                }
            };

            setTimeout(() => document.addEventListener('click', closeMenu), 10);
        });
    }

    function buildActions(authorId, msgId, messages, pinnedMsgs) {
        const actions = [];
        const inp = document.getElementById('chat-inp');

        if (window.CFG.quickActions.actions.pm) {
            actions.push({
                icon: 'fa-message',
                label: 'Send PM',
                action: () => { inp.value = `/pm ${authorId} `; inp.focus(); }
            });
        }

        if (window.CFG.quickActions.actions.report) {
            actions.push({
                icon: 'fa-flag',
                label: 'Report',
                action: () => {
                    const msg = messages.get(msgId);
                    setTimeout(() => {
                        window.dispatchEvent(new CustomEvent('cx:openPlayerReport', {
                            detail: { id: authorId, name: msg?.name || 'Unknown' }
                        }));
                    }, 10);
                }
            });
        }

        if (window.CFG.quickActions.actions.copy_id) {
            actions.push({
                icon: 'fa-id-card',
                label: 'Copy ID',
                action: () => copyToClipboard(authorId, 'ID Copied!')
            });
        }

        if (window.CFG.copyMessage?.enabled) {
            actions.push({
                icon: 'fa-copy',
                label: 'Copy Message',
                action: () => {
                    const msgEl = document.querySelector(`[data-msg-id="${msgId}"]`);
                    const text  = msgEl?.querySelector('.msg-text')?.textContent;
                    if (text) copyToClipboard(text.trim(), 'Copied!');
                }
            });
        }

        if (window.CFG.messageEditing?.enabled && messages.get(msgId)?.canEdit) {
            const msg = messages.get(msgId);
            const timeLimit = (window.CFG.messageEditing?.timeLimit || 120) * 1000;
            if (!msg.addedAt || Date.now() - msg.addedAt < timeLimit) {
                actions.push({
                    icon: 'fa-pen',
                    label: 'Edit',
                    action: () => {
                        inp.value = msg.text;
                        inp.dataset.editing = msgId;
                        inp.focus();
                    }
                });
            }
        }

        if (window.CFG.messageEditing?.enabled && messages.get(msgId)?.canDelete) {
            actions.push({
                icon: 'fa-trash',
                label: 'Delete',
                action: () => window.nui('deleteMessage', { msgId })
            });
        }

        if (window.CFG.pinning?.enabled && messages.get(msgId)?.canPin) {
            const isPinned = pinnedMsgs.some(m => m.id === msgId);
            actions.push({
                icon: isPinned ? 'fa-thumbtack-slash' : 'fa-thumbtack',
                label: isPinned ? 'Unpin' : 'Pin',
                action: () => {
                    window.nui(isPinned ? 'unpinMessage' : 'pinMessage', {
                        msgId,
                        msgData: messages.get(msgId)
                    });
                }
            });
        }

        if (window.CFG.canMute && authorId !== window.CFG.ownServerId) {
            const duration = window.CFG.messageEditing?.muteDuration || 300;
            const mins = Math.round(duration / 60);
            actions.push({
                icon: 'fa-microphone-slash',
                label: `Mute (${mins}m)`,
                action: () => window.nui('mutePlayer', { playerId: authorId, duration })
            });
        }

        return actions;
    }

    function copyToClipboard(text, successMsg) {
        const textarea = document.createElement('textarea');
        textarea.value = text;
        textarea.style.position = 'fixed';
        textarea.style.opacity  = '0';
        document.body.appendChild(textarea);
        textarea.select();
        try {
            document.execCommand('copy');
            if (successMsg) showTooltip(successMsg);
        } catch (_) {}
        document.body.removeChild(textarea);
    }

    return {
        addContextMenu,
        copyToClipboard
    };
})();
