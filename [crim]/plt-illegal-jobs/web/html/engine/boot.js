window.addEventListener('load', () => {
    try {
        window.parent.postMessage({ type: 'pluto:minigame-ready' }, '*');
    } catch (e) {}
});
