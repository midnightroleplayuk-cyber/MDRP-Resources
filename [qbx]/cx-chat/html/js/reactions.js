window.ReactionSystem = (function() {
    let messages = new Map();
    let activeReactionBar = null;
    let currentMsgEl = null;
    let messageHovered = false;
    let barHovered = false;

    function maybeHide() {
        setTimeout(() => {
            if (!messageHovered && !barHovered) {
                if (activeReactionBar) activeReactionBar.style.display = 'none';
            }
        }, 150);
    }

    function addReactionBar(msgEl, msgId) {
        if (!window.CFG?.reactions?.enabled) return;

        msgEl.dataset.hasReactionBar = 'true';

        msgEl.onmouseenter = () => {
            if (msgEl.classList.contains('sys')) return;
            messageHovered = true;

            if (!activeReactionBar) {
                activeReactionBar = document.createElement('div');
                activeReactionBar.className = 'reaction-bar';
                activeReactionBar.style.cssText = 'display:none;position:fixed;background:var(--bg2);border:1px solid var(--line);border-radius:6px;padding:4px;gap:3px;z-index:1000;display:grid;grid-template-columns:repeat(3, 1fr);';

                window.CFG.reactions.emojis.forEach(emoji => {
                    const btn = document.createElement('button');
                    btn.textContent = emoji;
                    btn.style.cssText = 'background:transparent;border:none;cursor:pointer;font-size:18px;padding:6px;border-radius:4px;transition:all 0.15s;display:flex;align-items:center;justify-content:center;';
                    btn.onmouseenter = () => btn.style.background = 'var(--line)';
                    btn.onmouseleave = () => btn.style.background = 'transparent';
                    btn.dataset.emoji = emoji;
                    activeReactionBar.appendChild(btn);
                });

                document.body.appendChild(activeReactionBar);

                activeReactionBar.onmouseenter = () => { barHovered = true; };
                activeReactionBar.onmouseleave = () => { barHovered = false; maybeHide(); };
            }

            const rect = msgEl.getBoundingClientRect();
            activeReactionBar.style.top = rect.top + 'px';
            activeReactionBar.style.left = (rect.right + 8) + 'px';
            activeReactionBar.style.display = 'grid';

            currentMsgEl = msgEl;
            const currentMsgId = msgId;

            activeReactionBar.querySelectorAll('button').forEach(btn => {
                btn.onclick = () => {
                    window.nui('addReaction', { msgId: currentMsgId, emoji: btn.dataset.emoji });
                    activeReactionBar.style.display = 'none';
                    messageHovered = false;
                    barHovered = false;
                };
            });
        };

        msgEl.onmouseleave = () => {
            messageHovered = false;
            maybeHide();
        };
    }
    
    function updateReactions(msgId, reactions) {
        const msgEl = document.querySelector(`[data-msg-id="${msgId}"]`);
        if (!msgEl) return;
        
        let reactContainer = msgEl.querySelector('.reactions');
        if (!reactContainer) {
            reactContainer = document.createElement('div');
            reactContainer.className = 'reactions';
            reactContainer.style.cssText = 'display:flex;gap:3px;flex-wrap:wrap;';
            msgEl.appendChild(reactContainer);
        }
        
        reactContainer.innerHTML = '';
        
        for (const [emoji, users] of Object.entries(reactions)) {
            if (users.length === 0) continue;
            
            const reactBtn = document.createElement('button');
            reactBtn.className = 'reaction-item';
            reactBtn.style.cssText = 'background:var(--bg3);border:1px solid var(--line);border-radius:10px;padding:2px 6px;font-size:13px;cursor:pointer;display:flex;align-items:center;gap:3px;transition:all 0.15s;line-height:1;';
            reactBtn.innerHTML = `<span>${emoji}</span>${window.CFG.reactions.showCount ? `<span style="font-size:11px;color:var(--dim);">${users.length}</span>` : ''}`;
            reactBtn.onclick = () => window.nui('addReaction', { msgId, emoji });
            reactBtn.onmouseenter = () => {
                reactBtn.style.background = 'var(--hi)';
                reactBtn.style.borderColor = 'var(--hi)';
            };
            reactBtn.onmouseleave = () => {
                reactBtn.style.background = 'var(--bg3)';
                reactBtn.style.borderColor = 'var(--line)';
            };
            
            reactContainer.appendChild(reactBtn);
        }
    }
    
    return {
        addReactionBar,
        updateReactions
    };
})();
