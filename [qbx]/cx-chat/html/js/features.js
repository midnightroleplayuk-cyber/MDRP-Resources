let messages = new Map();

window.addMsg = function(m) {
    window.cancelHideTimer();
    const mWrap = document.getElementById('msg-wrap');
    mWrap.classList.add('show');

    const msgs = document.getElementById('msgs');
    const inpPan = document.getElementById('inp-panel');
    const el = document.createElement('div');
    el.className = 'msg' + (m.isSystem ? ' sys' : '');
    if (m.id) el.dataset.msgId = m.id;

    let html = '';

    if (window.CFG?.timestamps?.enabled) {
        const now = new Date();
        const h   = String(now.getHours()).padStart(2, '0');
        const min = String(now.getMinutes()).padStart(2, '0');
        html += `<span class="time">[${h}:${min}]</span>`;
    }

    if (m.tag) {
        html += `<span class="msg-tag" style="background:${m.tagColor}22;color:${m.tagColor};border-color:${m.tagColor}44;">${window.escapeHtml(m.tag)}</span>`;
    }

    if (m.name) {
        html += `<span class="p-name" style="color:${m.color || 'var(--bright)'};">${window.escapeHtml(m.name)}:</span>`;
    }

    const processedMsg = window.MentionSystem.highlightMentions(window.formatMessage(m.message));
    html += `<span class="msg-text">${processedMsg}</span>`;

    if (m.edited && window.CFG.messageEditing?.showEditTag) {
        html += ` <span style="color:var(--dim);font-size:11px;font-style:italic;">(edited)</span>`;
    }

    el.innerHTML = html;
    msgs.appendChild(el);

    if (m.id) {
        messages.set(m.id, {
            text: m.message,
            canEdit: !m.isSystem && m.authorId === window.CFG?.ownServerId,
            canDelete: !m.isSystem && window.CFG?.canDelete === true,
            canPin: !m.isSystem,
            addedAt: Date.now(),
            ...m
        });

        if (!m.isSystem) {
            window.ReactionSystem.addReactionBar(el, m.id);
            if (m.authorId) {
                window.QuickActions.addContextMenu(el, m.authorId, m.id, messages);
            }
        }
    }

    const limit = window.CFG.maxMessages || 100;
    while (msgs.childElementCount > limit) {
        msgs.removeChild(msgs.firstChild);
    }

    msgs.scrollTop = msgs.scrollHeight;

    if (!inpPan.classList.contains('open')) {
        window.startHideTimer();
    }
};

window.addEventListener('message', e => {
    const d = e.data;
    if (!d || !d.type) return;

    if (d.type === 'updateReactions') {
        window.ReactionSystem.updateReactions(d.msgId, d.reactions);

    } else if (d.type === 'updatePinned') {
        window.UIUtils.updatePinnedMessages(d.pinned);

    } else if (d.type === 'showTyping') {
        window.UIUtils.showTypingIndicator(d.playerId);

    } else if (d.type === 'messageEdited') {
        const msgEl = document.querySelector(`[data-msg-id="${d.msgId}"]`);
        if (msgEl) {
            const textSpan = msgEl.querySelector('.msg-text');
            if (textSpan) {
                textSpan.innerHTML = window.MentionSystem.highlightMentions(window.formatMessage(d.newText));

                if (window.CFG.messageEditing?.showEditTag) {
                    let editTag = msgEl.querySelector('.edit-tag');
                    if (!editTag) {
                        editTag = document.createElement('span');
                        editTag.className = 'edit-tag';
                        editTag.style.cssText = 'color:var(--dim);font-size:11px;font-style:italic;margin-left:4px;';
                        editTag.textContent = '(edited)';
                        textSpan.parentElement.appendChild(editTag);
                    }
                }
            }
        }

    } else if (d.type === 'messageDeleted') {
        const msgEl = document.querySelector(`[data-msg-id="${d.msgId}"]`);
        if (msgEl) msgEl.remove();
        messages.delete(d.msgId);

    } else if (d.type === 'mentioned') {
        window.MentionSystem.handleMention(d.name);
    }
});

document.addEventListener('DOMContentLoaded', () => {
    const chatInp = document.getElementById('chat-inp');
    if (chatInp) {
        chatInp.addEventListener('input', () => {
            window.UIUtils.handleTypingInput(chatInp);
        });
    }
});
