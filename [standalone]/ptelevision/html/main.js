/* ptelevision: DUI-friendly video playback */
let player = null;
let playerData = null;
let volume = 100;
let generation = 0;
let notificationTimer = null;

$(function () {
    $.post('https://ptelevision/pageLoaded', JSON.stringify({}));
    ChannelDisplay();
});

function GetURLID(link) {
    if (typeof link !== 'string' || !link.trim()) return null;
    try {
        const u = new URL(link.trim().match(/^https?:\/\//i) ? link.trim() : 'https://' + link.trim());
        const host = u.hostname.toLowerCase().replace(/^www\./, '').replace(/^m\./, '');
        if (host === 'youtube.com' || host === 'youtube-nocookie.com' || host === 'youtu.be' || host === 'music.youtube.com') {
            let id = host === 'youtu.be' ? u.pathname.split('/')[1] :
                (u.searchParams.get('v') || u.pathname.match(/^\/(?:embed|shorts|live|v)\/([^/]+)/)?.[1]);
            if (id && /^[a-zA-Z0-9_-]{11}$/.test(id)) return {type: 'youtube', id};
        }
        if (host === 'twitch.tv' || host === 'clips.twitch.tv') {
            const parts = u.pathname.split('/').filter(Boolean);
            if (host === 'clips.twitch.tv' && parts[0]) return {type: 'twitch', clip: parts[0]};
            if (parts[0] === 'videos' && /^\d+$/.test(parts[1] || '')) return {type: 'twitch', video: 'v' + parts[1]};
            if (parts[1] === 'clip' && parts[2]) return {type: 'twitch', clip: parts[2]};
            if (parts[0] && /^[a-zA-Z0-9_]{1,25}$/.test(parts[0])) return {type: 'twitch', channel: parts[0]};
        }
    } catch (e) { console.warn('[ptelevision] Invalid URL:', e); }
    return null;
}

function ChannelDisplay(channel, channelFound) {
    $('#overlay span').text(channel ? 'CH ' + String(channel).padStart(2, '0') : '').toggle(!!channel);
    $('#tv-container').toggle(!channelFound);
}

function status(message) {
    $('#tv-container').removeClass('notify').show().children('div').removeClass('notify').text(message);
}

function clearPlayer() {
    if (player) {
        try { if (typeof player.destroy === 'function') player.destroy(); } catch (e) {}
        player = null;
    }
    // Both SDKs replace the host element with an iframe; restore a clean host.
    $('#twitch-embed').empty();
    playerData = null;
}

function SetVideo(video_data) {
    const token = ++generation;
    clearPlayer();
    const data = GetURLID(video_data && video_data.url);
    if (!data) {
        status('UNSUPPORTED VIDEO LINK');
        return;
    }
    playerData = data;
    $('#overlay span').hide();
    $('#tv-container').hide();
    const start = Math.max(0, Number(video_data.time) || 0);

    if (data.type === 'youtube') {
        if (!window.YT || !YT.Player) {
            status('YOUTUBE PLAYER UNAVAILABLE');
            return;
        }
        player = new YT.Player('twitch-embed', {
            width: '100%', height: '100%', videoId: data.id,
            playerVars: {
                autoplay: 1, mute: 1, playsinline: 1, controls: 0,
                rel: 0, fs: 0, disablekb: 1, start: Math.floor(start),
                origin: window.location.origin
            },
            events: {
                onReady: function (event) {
                    if (token !== generation) return;
                    // Muted autoplay is permitted by Chromium much more often than audible autoplay.
                    event.target.mute();
                    event.target.setVolume(volume);
                    event.target.playVideo();
                },
                onStateChange: function (event) {
                    if (token !== generation) return;
                    if (event.data === YT.PlayerState.PLAYING) {
                        $('#tv-container').hide();
                        // Keep muted until playback has started; attempt audio only afterwards.
                        if (volume > 0) {
                            try { event.target.unMute(); event.target.setVolume(volume); } catch (e) {}
                        }
                    } else if (event.data === YT.PlayerState.CUED) {
                        event.target.mute();
                        event.target.playVideo();
                    }
                },
                onError: function (event) {
                    if (token !== generation) return;
                    const messages = {
                        2: 'INVALID YOUTUBE VIDEO', 5: 'YOUTUBE HTML5 ERROR',
                        100: 'YOUTUBE VIDEO UNAVAILABLE',
                        101: 'YOUTUBE EMBEDDING DISABLED', 150: 'YOUTUBE EMBEDDING DISABLED',
                        153: 'YOUTUBE EMBED CLIENT BLOCKED'
                    };
                    status(messages[event.data] || 'YOUTUBE PLAYBACK ERROR');
                    console.warn('[ptelevision] YouTube error:', event.data);
                }
            }
        });
    } else {
        if (!window.Twitch || !Twitch.Player) {
            status('TWITCH PLAYER UNAVAILABLE');
            return;
        }
        // Twitch enforces its own parent-domain policy. The cfx-nui:// origin may be rejected.
        const opts = {width: '100%', height: '100%', autoplay: true, muted: true,
            parent: [window.location.hostname]};
        if (data.channel) opts.channel = data.channel;
        if (data.video) opts.video = data.video;
        if (data.clip) {
            status('TWITCH CLIPS REQUIRE A SUPPORTED EMBED HOST');
            return;
        }
        player = new Twitch.Player('twitch-embed', opts);
        player.addEventListener(Twitch.Player.READY, function () {
            if (token !== generation) return;
            try { player.setMuted(true); player.setVolume(volume / 100); player.play(); } catch (e) {}
        });
        player.addEventListener(Twitch.Player.PLAY, function () {
            if (token !== generation) return;
            $('#tv-container').hide();
            if (volume > 0) {
                try { player.setMuted(false); player.setVolume(volume / 100); } catch (e) {}
            }
        });
    }
    if (video_data.channel) ChannelDisplay(video_data.channel, true);
}

function SetVolume(value) {
    volume = Math.max(0, Math.min(100, Number(value) || 0));
    if (!player || !playerData) return;
    try {
        if (playerData.type === 'twitch') {
            player.setVolume(volume / 100);
            player.setMuted(volume === 0);
        } else {
            player.setVolume(volume);
            if (volume === 0) player.mute();
            else player.unMute();
        }
    } catch (e) { console.warn('[ptelevision] Volume update failed:', e); }
}

function ShowNotification(channel, data) {
    clearTimeout(notificationTimer);
    const wasVisible = $('#tv-container').is(':visible');
    $('#tv-container').addClass('notify').show().children('div').addClass('notify')
        .text('Channel #' + channel + (data ? ' (' + data.name + ')' : '') +
            ' is now ' + (data ? 'live!' : 'offline.'));
    notificationTimer = setTimeout(function () {
        $('#tv-container').removeClass('notify').children('div').removeClass('notify').text('NO SIGNAL');
        if (!wasVisible) $('#tv-container').hide();
    }, 3500);
}

window.addEventListener('message', function (ev) {
    if (!ev.data) return;
    if (ev.data.setVideo) SetVideo(ev.data.data);
    else if (ev.data.setVolume) SetVolume(ev.data.data);
    else if (ev.data.showNotification) ShowNotification(ev.data.channel, ev.data.data);
});
