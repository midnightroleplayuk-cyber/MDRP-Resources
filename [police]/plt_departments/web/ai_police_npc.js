(function () {
    let activeRecorder = null;
    let speechStream = null;
    let speechStreamPromise = null;
    let pendingSpeechStop = false;
    let speechMonitorContext = null;

    function debug(message, ...args) {
        console.log(`[plt_departments][ai_police_npc][nui] ${message}`, ...args);
    }

    function resourceName() {
        return typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'plt_departments';
    }

    function postResult(result) {
        debug(`posting speechResult ok=${result && result.ok} duration=${result && result.durationMs} bytes64=${result && result.audioBase64 ? result.audioBase64.length : 0} error=${result && result.error || ''}`);
        fetch(`https://${resourceName()}/speechResult`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify(result || { ok: false, error: 'No speech result.' })
        }).catch(() => {});
    }

    function pickRecordingMimeType() {
        const types = [
            'audio/webm;codecs=opus',
            'audio/webm',
            'audio/ogg;codecs=opus',
            'audio/ogg'
        ];

        if (!window.MediaRecorder) return '';
        return types.find(type => MediaRecorder.isTypeSupported(type)) || '';
    }

    function hasLiveAudioTrack(stream) {
        return !!stream && stream.getAudioTracks().some(track => track.readyState === 'live');
    }

    async function getSpeechStream() {
        if (hasLiveAudioTrack(speechStream)) {
            debug('reusing existing microphone stream');
            return speechStream;
        }
        if (speechStreamPromise) {
            debug('awaiting existing microphone stream promise');
            return speechStreamPromise;
        }

        debug('requesting microphone stream');
        speechStreamPromise = navigator.mediaDevices.getUserMedia({
            audio: {
                echoCancellation: true,
                noiseSuppression: true,
                autoGainControl: true,
                channelCount: 1,
                sampleRate: 16000
            }
        }).then(stream => {
            speechStream = stream;
            debug(`microphone stream granted tracks=${stream.getAudioTracks().length}`);
            return stream;
        }).finally(() => {
            speechStreamPromise = null;
        });

        return speechStreamPromise;
    }

    function blobToBase64(blob) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.onloadend = () => {
                const value = String(reader.result || '');
                resolve(value.includes(',') ? value.split(',').pop() : value);
            };
            reader.onerror = reject;
            reader.readAsDataURL(blob);
        });
    }

    function audioUrlFromBase64(base64, mimeType) {
        const binary = atob(base64 || '');
        const bytes = new Uint8Array(binary.length);
        for (let i = 0; i < binary.length; i += 1) {
            bytes[i] = binary.charCodeAt(i);
        }
        const blob = new Blob([bytes], { type: mimeType || 'audio/wav' });
        return URL.createObjectURL(blob);
    }

    function pickSpeechVoice() {
        if (!window.speechSynthesis || typeof window.speechSynthesis.getVoices !== 'function') return null;
        const voices = window.speechSynthesis.getVoices() || [];
        if (!voices.length) return null;

        const preferred = ['aria', 'jenny', 'zira', 'samantha', 'susan', 'google us english', 'english united states'];
        for (const needle of preferred) {
            const match = voices.find(voice => `${voice.name} ${voice.lang}`.toLowerCase().includes(needle));
            if (match) return match;
        }

        return voices.find(voice => String(voice.lang || '').toLowerCase().startsWith('en')) || voices[0] || null;
    }

    async function playNpcAudio(data) {
        if (!data || !data.audioBase64) {
            debug('playback ignored: missing audio');
            return;
        }

        const url = audioUrlFromBase64(data.audioBase64, data.mimeType);
        debug(`playback start bytes64=${data.audioBase64.length} mime=${data.mimeType || 'audio/wav'}`);
        try {
            const player = new Audio(url);
            player.volume = Math.max(0, Math.min(1, Number(data.volume) || 1.0));
            await player.play();
            player.addEventListener('ended', () => {
                debug('playback ended');
                URL.revokeObjectURL(url);
            }, { once: true });
        } catch (err) {
            debug(`playback failed: ${err && err.message ? err.message : err}`);
            URL.revokeObjectURL(url);
        }
    }

    function speakNpc(data) {
        if (!window.speechSynthesis || !data || !data.text) {
            debug('speech synthesis unavailable or missing text');
            return;
        }

        try {
            window.speechSynthesis.cancel();
            const utterance = new SpeechSynthesisUtterance(String(data.text));
            const voice = pickSpeechVoice();
            if (voice) utterance.voice = voice;
            utterance.lang = data.language || (voice && voice.lang) || 'en-US';
            utterance.rate = Math.max(0.5, Math.min(1.5, Number(data.rate) || 0.96));
            utterance.pitch = Math.max(0.2, Math.min(2.0, Number(data.pitch) || 0.9));
            utterance.volume = Math.max(0, Math.min(1, Number(data.volume) || 1.0));
            debug(`speech synthesis start len=${String(data.text).length} voice=${voice ? voice.name : 'default'}`);
            window.speechSynthesis.speak(utterance);
        } catch (error) {
            debug(`speech synthesis failed: ${error && error.message ? error.message : error}`);
        }
    }

    function stopSpeechRecorder() {
        if (!activeRecorder) {
            debug('stop requested before recorder active; marking pending stop');
            pendingSpeechStop = true;
            return;
        }

        const recorder = activeRecorder;
        activeRecorder = null;
        pendingSpeechStop = false;
        debug(`stopping recorder state=${recorder.mediaRecorder && recorder.mediaRecorder.state}`);

        try {
            if (recorder.mediaRecorder && recorder.mediaRecorder.state !== 'inactive') {
                if (typeof recorder.mediaRecorder.requestData === 'function') {
                    recorder.mediaRecorder.requestData();
                }
                recorder.mediaRecorder.stop();
            }
        } catch (error) {}

        if (!recorder.keepStreamOpen) {
            try {
                for (const track of recorder.stream.getTracks()) {
                    track.stop();
                }
            } catch (error) {}

            if (recorder.stream === speechStream) {
                speechStream = null;
            }
        }

        try {
            if (recorder.source) recorder.source.disconnect();
        } catch (error) {}
    }

    function releaseSpeechStream() {
        if (!speechStream) return;
        try {
            for (const track of speechStream.getTracks()) {
                track.stop();
            }
        } catch (error) {}
        speechStream = null;
    }

    async function warmSpeechCapture() {
        try {
            await getSpeechStream();
            const AudioContextClass = window.AudioContext || window.webkitAudioContext;
            if (AudioContextClass) {
                speechMonitorContext = speechMonitorContext || new AudioContextClass();
                if (speechMonitorContext.state === 'suspended') {
                    await speechMonitorContext.resume().catch(() => {});
                }
            }
            if (window.speechSynthesis && typeof window.speechSynthesis.getVoices === 'function') {
                window.speechSynthesis.getVoices();
            }
            debug('speech capture warmed');
        } catch (error) {
            debug(`speech capture warm failed: ${error && error.message ? error.message : error}`);
        }
    }

    async function startSpeechRecording(data) {
        debug(`speech:record received max=${data && data.maxMs} min=${data && data.minMs} bits=${data && data.audioBitsPerSecond} stopOnSilence=${data && data.stopOnSilence}`);
        if (activeRecorder) {
            stopSpeechRecorder();
        }
        pendingSpeechStop = false;

        if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
            debug('recording failed: navigator.mediaDevices unavailable');
            postResult({ ok: false, error: 'Microphone capture is not available in this NUI browser.' });
            return;
        }

        if (!window.MediaRecorder) {
            debug('recording failed: MediaRecorder unavailable');
            postResult({ ok: false, error: 'MediaRecorder is not available in this NUI browser.' });
            return;
        }

        const mimeType = pickRecordingMimeType();
        if (!mimeType) {
            debug('recording failed: no supported mime type');
            postResult({ ok: false, error: 'No supported microphone recording format was found.' });
            return;
        }
        debug(`recording mime=${mimeType}`);

        try {
            const stream = await getSpeechStream();
            const chunks = [];
            const startedAt = performance.now();
            const keepStreamOpen = data.keepStreamOpen === true;
            const audioBitsPerSecond = Math.max(8000, Number(data.audioBitsPerSecond) || 24000);
            const mediaRecorder = new MediaRecorder(stream, { mimeType, audioBitsPerSecond });
            const AudioContextClass = window.AudioContext || window.webkitAudioContext;
            const requireDetectedVoice = data.requireDetectedVoice === true;
            const voiceDetectThreshold = Math.max(0.001, Number(data.voiceDetectThreshold) || Number(data.silenceThreshold) || 0.012);
            const minVoiceMs = Math.max(0, Number(data.minVoiceMs) || 140);
            const noVoiceTimeoutMs = Math.max(900, Number(data.noVoiceTimeoutMs) || 3500);
            let monitorContext = null;
            let monitorSource = null;
            let stopped = false;
            let voiceMs = 0;
            let peakRms = 0;
            let lastVoiceTick = 0;
            let voiceMonitorReady = false;
            let heardVoice = false;

            activeRecorder = {
                mediaRecorder,
                stream,
                keepStreamOpen
            };

            const stopOnce = () => {
                if (stopped) return;
                stopped = true;
                stopSpeechRecorder();
            };

            mediaRecorder.addEventListener('dataavailable', event => {
                if (event.data && event.data.size) {
                    chunks.push(event.data);
                    if (chunks.length === 1 || chunks.length % 25 === 0) {
                        debug(`data chunk size=${event.data.size} chunks=${chunks.length}`);
                    }
                }
            });

            mediaRecorder.addEventListener('stop', async () => {
                debug(`recorder stopped chunks=${chunks.length} voiceMs=${Math.round(voiceMs)} peakRms=${peakRms.toFixed(5)}`);
                try {
                    if (!keepStreamOpen) {
                        for (const track of stream.getTracks()) {
                            track.stop();
                        }
                        if (stream === speechStream) speechStream = null;
                    }
                    if (monitorSource) monitorSource.disconnect();
                } catch (error) {}

                activeRecorder = null;

                const blob = new Blob(chunks, { type: mimeType });
                if (!blob.size) {
                    debug('recording stopped with empty blob');
                    postResult({ ok: false, error: 'No microphone audio was recorded.' });
                    return;
                }

                if (requireDetectedVoice && voiceMonitorReady && voiceMs < minVoiceMs) {
                    debug(`recording rejected: no voice voiceMs=${Math.round(voiceMs)} peakRms=${peakRms.toFixed(5)}`);
                    postResult({
                        ok: false,
                        error: 'No speech was detected.',
                        durationMs: Math.round(performance.now() - startedAt),
                        voiceDetected: false,
                        voiceMs: Math.round(voiceMs),
                        peakRms: Number(peakRms.toFixed(5))
                    });
                    return;
                }

                postResult({
                    ok: true,
                    audioBase64: await blobToBase64(blob),
                    mimeType,
                    durationMs: Math.round(performance.now() - startedAt),
                    voiceDetected: !voiceMonitorReady || voiceMs >= minVoiceMs,
                    voiceMs: Math.round(voiceMs),
                    peakRms: Number(peakRms.toFixed(5))
                });
            });

            mediaRecorder.addEventListener('error', event => {
                debug(`recorder error=${event.error ? event.error.message : 'unknown'}`);
                postResult({ ok: false, error: event.error ? event.error.message : 'Microphone recording failed.' });
                stopOnce();
            });

            const timesliceMs = Math.max(0, Number(data.timesliceMs) || 0);
            if (timesliceMs > 0) {
                mediaRecorder.start(timesliceMs);
            } else {
                mediaRecorder.start();
            }
            debug(`recorder started timeslice=${timesliceMs}`);

            if (AudioContextClass && data.stopOnSilence === true) {
                try {
                    monitorContext = speechMonitorContext || new AudioContextClass();
                    speechMonitorContext = monitorContext;
                    if (monitorContext.state === 'suspended') {
                        await monitorContext.resume();
                    }

                    const analyser = monitorContext.createAnalyser();
                    analyser.fftSize = 512;
                    monitorSource = monitorContext.createMediaStreamSource(stream);
                    monitorSource.connect(analyser);
                    activeRecorder.source = monitorSource;
                    voiceMonitorReady = true;

                    const samples = new Uint8Array(analyser.fftSize);
                    const minMs = Math.max(80, Number(data.minMs) || 300);
                    const silenceMs = Math.max(80, Number(data.silenceMs) || 550);
                    const speechEndThreshold = Math.max(0.001, Number(data.silenceThreshold) || 0.022);
                    let lastVoiceAt = startedAt;
                    let softSilenceSince = 0;

                    const monitor = () => {
                        if (stopped || !activeRecorder || mediaRecorder.state === 'inactive') return;
                        analyser.getByteTimeDomainData(samples);
                        let sum = 0;
                        for (let i = 0; i < samples.length; i += 1) {
                            const centered = (samples[i] - 128) / 128;
                            sum += centered * centered;
                        }

                        const rms = Math.sqrt(sum / samples.length);
                        const now = performance.now();
                        peakRms = Math.max(peakRms, rms);
                        if (rms > voiceDetectThreshold) {
                            lastVoiceAt = now;
                            heardVoice = true;
                            voiceMs += lastVoiceTick > 0 ? Math.min(80, now - lastVoiceTick) : 16;
                            lastVoiceTick = now;
                        } else {
                            lastVoiceTick = 0;
                        }

                        if (!heardVoice && requireDetectedVoice && now - startedAt >= noVoiceTimeoutMs) {
                            stopOnce();
                            return;
                        }

                        if (heardVoice && now - startedAt >= minMs) {
                            const quietNow = rms <= speechEndThreshold || now - lastVoiceAt >= silenceMs;
                            if (quietNow) {
                                softSilenceSince = softSilenceSince || now;
                                if (now - softSilenceSince >= silenceMs) {
                                    stopOnce();
                                    return;
                                }
                            } else {
                                softSilenceSince = 0;
                            }
                        }

                        requestAnimationFrame(monitor);
                    };

                    requestAnimationFrame(monitor);
                } catch (error) {}
            }

            if (pendingSpeechStop) {
                pendingSpeechStop = false;
                debug('pending stop detected after recorder start');
                window.setTimeout(stopOnce, 25);
            }

            window.setTimeout(stopOnce, Math.max(900, Number(data.maxMs) || 12000));
        } catch (error) {
            debug(`recording exception=${error && error.message ? error.message : error}`);
            postResult({ ok: false, error: error && error.message ? error.message : String(error) });
        }
    }

    window.addEventListener('message', (event) => {
        const data = event.data || {};
        if (data.action) debug(`message action=${data.action}`);
        if (data.action === 'speech:record') {
            startSpeechRecording(data);
        } else if (data.action === 'speech:stop') {
            stopSpeechRecorder();
        } else if (data.action === 'speech:release') {
            stopSpeechRecorder();
            releaseSpeechStream();
        } else if (data.action === 'speech:warm') {
            warmSpeechCapture();
        } else if (data.action === 'ai_police_npc:play_audio') {
            playNpcAudio(data);
        } else if (data.action === 'ai_police_npc:speak') {
            speakNpc(data);
        }
    });

    window.setTimeout(warmSpeechCapture, 1200);
})();
