var qs = new URLSearchParams(window.location.search);
var vid = qs.get('vid') || '';
var initTime = parseInt(qs.get('t') || '0');
var isLive = qs.get('live') === '1';
var volume = parseInt(qs.get('vol') || '50');
var isSpatial = qs.get('spatial') === '1';
var player = null;
var _gainNode = null;
var _pannerNode = null;
var _filterNode = null;
var _pendingFilterFreq = null;
var _webAudioOk = false;

function trySetupWebAudio(ytPlayer, attempt) {
    attempt = attempt || 0;
    if (attempt > 20) return;
    try {
        var iframes = document.querySelectorAll('iframe');
        var found = false;
        for (var i = 0; i < iframes.length; i++) {
            var doc = iframes[i].contentDocument;
            if (!doc) continue;
            var video = doc.querySelector('video');
            if (!video) { found = true; break; }
            var ctx = new AudioContext();
            var gain = ctx.createGain();
            var filter = ctx.createBiquadFilter();
            filter.type = 'lowpass';
            filter.frequency.value = 20000;
            filter.Q.value = 1.2;
            var panner = ctx.createStereoPanner();
            gain.connect(filter);
            filter.connect(panner);
            panner.connect(ctx.destination);
            var src = ctx.createMediaElementSource(video);
            src.connect(gain);
            ctx.resume();
            ytPlayer.setVolume(100);
            gain.gain.value = 0;
            panner.pan.value = 0;
            _gainNode = gain;
            _filterNode = filter;
            _pannerNode = panner;
            _webAudioOk = true;
            if (_pendingFilterFreq !== null) {
                filter.frequency.value = _pendingFilterFreq;
                _pendingFilterFreq = null;
            }
            return;
        }
        if (found || iframes.length === 0) {
            setTimeout(function () { trySetupWebAudio(ytPlayer, attempt + 1); }, 500);
        }
    } catch (e) {
        if (attempt < 2) setTimeout(function () { trySetupWebAudio(ytPlayer, attempt + 1); }, 500);
    }
}

window.onYouTubeIframeAPIReady = function () {
    player = new YT.Player('player', {
        height: '200', width: '200', videoId: vid,
        host: 'https://www.youtube-nocookie.com',
        playerVars: {
            autoplay: 1, controls: 0, disablekb: 1, fs: 0,
            rel: 0, modestbranding: 1, iv_load_policy: 3,
            origin: 'https://www.youtube.com/',
        },
        events: {
            onReady: function (e) {
                e.target.unMute();
                e.target.setVolume(volume);
                if (isLive) {
                    var dur = e.target.getDuration ? e.target.getDuration() : 0;
                    if (dur > 1) e.target.seekTo(dur, true);
                } else if (initTime > 1) {
                    e.target.seekTo(initTime, true);
                }
                e.target.playVideo();
                window.yPlayer = e.target;
                window.parent.postMessage({
                    type: 'ytReady',
                    duration: Math.floor(e.target.getDuration ? e.target.getDuration() : 0),
                }, '*');
                if (isSpatial) setTimeout(function () { trySetupWebAudio(e.target); }, 500);
            },
            onStateChange: function (e) {
                var S = YT.PlayerState;
                if (e.data === S.PLAYING) window.parent.postMessage({ type: 'ytPlaying' }, '*');
                else if (e.data === S.PAUSED) window.parent.postMessage({ type: 'ytPaused' }, '*');
                else if (e.data === S.ENDED) window.parent.postMessage({ type: 'ytEnded' }, '*');
            },
            onError: function (e) {
                window.parent.postMessage({ type: 'ytError', code: e.data }, '*');
            },
        },
    });
};

setInterval(function () {
    try {
        if (player && player.getPlayerState && player.getPlayerState() === 1) {
            window.parent.postMessage({
                type: 'ytTime',
                currentTime: Math.floor(player.getCurrentTime ? player.getCurrentTime() : 0),
                duration: Math.floor(player.getDuration ? player.getDuration() : 0),
            }, '*');
        }
    } catch (x) {}
}, 500);

window.addEventListener('message', function (e) {
    try {
        var d = e.data;
        if (!player || !d || !d.cmd) return;
        if (d.cmd === 'pause') { player.pauseVideo(); }
        else if (d.cmd === 'resume') { player.playVideo(); }
        else if (d.cmd === 'seek') { player.seekTo(d.time, true); }
        else if (d.cmd === 'volume') {
            if (_webAudioOk) {
                if (_gainNode) _gainNode.gain.value = d.volume;
                if (_pannerNode && d.pan !== undefined && d.pan !== null) _pannerNode.pan.value = d.pan;
            } else {
                player.setVolume(Math.round(d.volume * 100));
            }
        } else if (d.cmd === 'filter') {
            var freq = typeof d.frequency === 'number' ? d.frequency : 20000;
            if (_filterNode && _filterNode.frequency) {
                var now = _filterNode.context.currentTime;
                _filterNode.frequency.cancelScheduledValues(now);
                _filterNode.frequency.setTargetAtTime(freq, now, 0.15);
            } else { _pendingFilterFreq = freq; }
        } else if (d.cmd === 'stop') {
            try { player.stopVideo(); } catch (x) {}
            try { player.destroy(); } catch (x) {}
            player = null;
        }
    } catch (x) {}
});
