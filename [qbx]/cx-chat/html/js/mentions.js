window.MentionSystem = (function() {
    function highlightMentions(text) {
        if (!window.CFG?.mentions?.enabled) return text;
        const ownFirst = (window.CFG?.ownName || '').split(' ')[0].toLowerCase();
        return text.replace(/@(\w+)/g, (match, name) => {
            const isSelf = ownFirst && name.toLowerCase() === ownFirst;
            const color  = isSelf ? window.CFG.mentions.highlightColor : 'var(--hi)';
            return `<span class="mention" style="color:${color};background:${color}22;padding:2px 6px;border-radius:4px;font-weight:600;">${match}</span>`;
        });
    }

    function handleMention(name) {
        if (window.CFG?.mentions?.sound) {
            const audio = new Audio('data:audio/wav;base64,UklGRnoGAABXQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YQoGAACBhYqFbF1fdJivrJBhNjVgodDbq2EcBj+a2/LDciUFLIHO8tiJNwgZaLvt559NEAxQp+PwtmMcBjiR1/LMeSwFJHfH8N2QQAoUXrTp66hVFApGnOLyvmwhBSuBzvLZiTcIGmi77eefTRAMUKfj8LZjHAY4ktfyzHksBSR3x/DdkEAKFF606+uoVRQKRpzi8r5sIQUrjKnp3qJOEgxSqOTwsWkcBjiP1/TKdysFI3fH8N+RQAoUXrTq7KlVFApGneLyvmwhBSuHzvLZiTcIGmi77eefTRAMUqjk8LFpHAY4jdby0HgsBSR3x/DdkEAKFF606+uoVRQKRpzj8r5sIQUrjM3y2Yk3CBlou+3nn00QDFKn4/C2YhwGOI7W8sx5LAUkd8fw3ZBACgA=');
            audio.volume = 0.3;
            audio.play().catch(() => {});
        }
        showTooltip(`${name} mentioned you!`);
    }

    return {
        highlightMentions,
        handleMention
    };
})();
