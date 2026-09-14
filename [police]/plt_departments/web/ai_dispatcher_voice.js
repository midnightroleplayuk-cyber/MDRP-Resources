(function () {
    let activeRecorder = null;
    let speechStream = null;
    let speechStreamPromise = null;
    let pendingStop = false;
    let radioAudioContext = null;
    let speechMonitorContext = null;
    let activeRadioNoise = null;
    let frequencySpeakerMonitor = null;

    function resourceName() {
        return typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'plt_departments';
    }

    function postResult(result) {
        fetch(`https://${resourceName()}/aiDispatcherSpeechResult`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify(result || { ok: false, error: 'No dispatcher speech result.' })
        });
    }

    function postPlaybackResult(result) {
        fetch(`https://${resourceName()}/aiDispatcherPlaybackResult`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify(result || { ok: false, stage: 'unknown', error: 'No playback result.' })
        }).catch(() => {});
    }

    function audioUrlFromBase64(base64, mimeType) {
        try {
            const binary = atob(base64);
            const chunkSize = 32768;
            const chunks = [];
            for (let offset = 0; offset < binary.length; offset += chunkSize) {
                const slice = binary.slice(offset, offset + chunkSize);
                const bytes = new Uint8Array(slice.length);
                for (let i = 0; i < slice.length; i += 1) {
                    bytes[i] = slice.charCodeAt(i);
                }
                chunks.push(bytes);
            }
            return URL.createObjectURL(new Blob(chunks, { type: mimeType || 'audio/wav' }));
        } catch (error) {
            postPlaybackResult({ ok: false, stage: 'decode', error: String(error && error.message ? error.message : error) });
            return '';
        }
    }

    function pickSpeechVoice() {
        if (!window.speechSynthesis || typeof window.speechSynthesis.getVoices !== 'function') return null;
        const voices = window.speechSynthesis.getVoices() || [];
        if (!voices.length) return null;

        const preferred = ['aria', 'jenny', 'zira', 'samantha', 'susan', 'google us english', 'english united states'];
        for (const needle of preferred) {
            const match = voices.find((voice) => `${voice.name} ${voice.lang}`.toLowerCase().includes(needle));
            if (match) return match;
        }

        return voices.find((voice) => String(voice.lang || '').toLowerCase().startsWith('en')) || voices[0] || null;
    }

    function pickRecordingMimeType() {
        const options = [
            'audio/webm;codecs=opus',
            'audio/webm',
            'audio/ogg;codecs=opus',
            'audio/ogg'
        ];

        if (!window.MediaRecorder) return '';
        return options.find((type) => MediaRecorder.isTypeSupported(type)) || '';
    }

    function hasLiveAudioTrack(stream) {
        return !!stream && stream.getAudioTracks().some((track) => track.readyState === 'live');
    }

    async function getSpeechStream() {
        if (hasLiveAudioTrack(speechStream)) return speechStream;
        if (speechStreamPromise) return speechStreamPromise;

        speechStreamPromise = navigator.mediaDevices.getUserMedia({
            audio: {
                echoCancellation: true,
                noiseSuppression: true,
                autoGainControl: true,
                channelCount: 1,
                sampleRate: 16000
            }
        }).then((stream) => {
            speechStream = stream;
            speechStreamPromise = null;
            return stream;
        }).catch((error) => {
            speechStreamPromise = null;
            throw error;
        });

        return speechStreamPromise;
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
        } catch (error) {}
    }

    function blobToBase64(blob) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.onloadend = () => {
                const result = String(reader.result || '');
                resolve(result.includes(',') ? result.split(',').pop() : result);
            };
            reader.onerror = reject;
            reader.readAsDataURL(blob);
        });
    }

    function stopRecording() {
        if (!activeRecorder) {
            pendingStop = true;
            return;
        }

        const recorder = activeRecorder;
        activeRecorder = null;
        pendingStop = false;

        try {
            if (recorder.mediaRecorder && recorder.mediaRecorder.state !== 'inactive') {
                if (typeof recorder.mediaRecorder.requestData === 'function') {
                    recorder.mediaRecorder.requestData();
                }
                recorder.mediaRecorder.stop();
            }
        } catch (error) {}
    }

    function getRadioAudioContext() {
        const AudioContextClass = window.AudioContext || window.webkitAudioContext;
        if (!AudioContextClass) return null;
        if (!radioAudioContext) radioAudioContext = new AudioContextClass();
        if (radioAudioContext.state === 'suspended') radioAudioContext.resume().catch(() => {});
        return radioAudioContext;
    }

    function playSquelch(volume, duration) {
        const ctx = getRadioAudioContext();
        if (!ctx) return;

        const bufferSize = Math.max(1, Math.floor(ctx.sampleRate * duration));
        const buffer = ctx.createBuffer(1, bufferSize, ctx.sampleRate);
        const data = buffer.getChannelData(0);
        for (let i = 0; i < bufferSize; i += 1) {
            const fade = 1 - (i / bufferSize);
            data[i] = (Math.random() * 2 - 1) * fade;
        }

        const source = ctx.createBufferSource();
        const highpass = ctx.createBiquadFilter();
        const lowpass = ctx.createBiquadFilter();
        const gain = ctx.createGain();
        highpass.type = 'highpass';
        highpass.frequency.value = 500;
        lowpass.type = 'lowpass';
        lowpass.frequency.value = 2600;
        gain.gain.value = Math.max(0, Math.min(1, Number(volume) || 0.16));

        source.buffer = buffer;
        source.connect(highpass);
        highpass.connect(lowpass);
        lowpass.connect(gain);
        gain.connect(ctx.destination);
        source.start();
    }

    function startRadioNoise(volume) {
        const ctx = getRadioAudioContext();
        if (!ctx || activeRadioNoise) return;

        const bufferSize = ctx.sampleRate * 2;
        const buffer = ctx.createBuffer(1, bufferSize, ctx.sampleRate);
        const data = buffer.getChannelData(0);
        for (let i = 0; i < bufferSize; i += 1) {
            data[i] = Math.random() * 2 - 1;
        }

        const source = ctx.createBufferSource();
        const highpass = ctx.createBiquadFilter();
        const lowpass = ctx.createBiquadFilter();
        const gain = ctx.createGain();
        source.buffer = buffer;
        source.loop = true;
        highpass.type = 'highpass';
        highpass.frequency.value = 700;
        lowpass.type = 'lowpass';
        lowpass.frequency.value = 2300;
        gain.gain.value = Math.max(0, Math.min(0.2, Number(volume) || 0.045));

        source.connect(highpass);
        highpass.connect(lowpass);
        lowpass.connect(gain);
        gain.connect(ctx.destination);
        source.start();
        activeRadioNoise = { source, gain };
    }

    async function startFrequencySpeakerMonitor(data) {
        if (frequencySpeakerMonitor) return;

        const ctx = getRadioAudioContext();
        if (!ctx || !navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
            postPlaybackResult({ ok: false, stage: 'speaker_monitor', error: 'Microphone monitor is not available.' });
            return;
        }

        try {
            const stream = await navigator.mediaDevices.getUserMedia({
                audio: {
                    echoCancellation: false,
                    noiseSuppression: false,
                    autoGainControl: false
                }
            });
            const source = ctx.createMediaStreamSource(stream);
            const highpass = ctx.createBiquadFilter();
            const lowpass = ctx.createBiquadFilter();
            const compressor = ctx.createDynamicsCompressor();
            const distortion = ctx.createWaveShaper();
            const gain = ctx.createGain();
            const panner = ctx.createStereoPanner ? ctx.createStereoPanner() : null;

            highpass.type = 'highpass';
            highpass.frequency.value = 420;
            lowpass.type = 'lowpass';
            lowpass.frequency.value = 2850;
            compressor.threshold.value = -30;
            compressor.knee.value = 14;
            compressor.ratio.value = 7;
            compressor.attack.value = 0.004;
            compressor.release.value = 0.16;
            distortion.curve = makeRadioCurve(8);
            distortion.oversample = '2x';
            gain.gain.value = Math.max(0, Math.min(1, Number(data && data.volume) || 0.38));

            source.connect(highpass);
            highpass.connect(lowpass);
            lowpass.connect(compressor);
            compressor.connect(distortion);
            distortion.connect(gain);
            if (panner) {
                panner.pan.value = Math.max(-1, Math.min(1, Number(data && data.pan) || 0));
                gain.connect(panner);
                panner.connect(ctx.destination);
            } else {
                gain.connect(ctx.destination);
            }

            if (data && data.radioEffect !== false) {
                playSquelch(data.squelchVolume, 0.08);
                startRadioNoise(data.noiseVolume);
            }

            frequencySpeakerMonitor = { stream, source, highpass, lowpass, compressor, distortion, gain, panner };
            postPlaybackResult({ ok: true, stage: 'speaker_monitor_started' });
        } catch (error) {
            stopRadioNoise();
            postPlaybackResult({ ok: false, stage: 'speaker_monitor', error: String(error && error.message ? error.message : error) });
        }
    }

    function updateFrequencySpeakerMonitor(data) {
        if (!frequencySpeakerMonitor) return;

        const volume = Number(data && data.volume);
        if (Number.isFinite(volume)) {
            frequencySpeakerMonitor.gain.gain.value = Math.max(0, Math.min(1, volume));
        }

        const pan = Number(data && data.pan);
        if (frequencySpeakerMonitor.panner && Number.isFinite(pan)) {
            frequencySpeakerMonitor.panner.pan.value = Math.max(-1, Math.min(1, pan));
        }
    }

    function stopFrequencySpeakerMonitor(data) {
        if (!frequencySpeakerMonitor) return;

        try {
            frequencySpeakerMonitor.gain.disconnect();
            if (frequencySpeakerMonitor.panner) {
                frequencySpeakerMonitor.panner.disconnect();
            }
            frequencySpeakerMonitor.distortion.disconnect();
            frequencySpeakerMonitor.compressor.disconnect();
            frequencySpeakerMonitor.lowpass.disconnect();
            frequencySpeakerMonitor.highpass.disconnect();
            frequencySpeakerMonitor.source.disconnect();
        } catch (error) {}

        try {
            frequencySpeakerMonitor.stream.getTracks().forEach((track) => track.stop());
        } catch (error) {}

        frequencySpeakerMonitor = null;
        stopRadioNoise();
        if (!data || data.radioEffect !== false) {
            playSquelch(data && data.squelchVolume, 0.06);
        }
        postPlaybackResult({ ok: true, stage: 'speaker_monitor_stopped' });
    }

    function stopRadioNoise() {
        if (!activeRadioNoise) return;
        const noise = activeRadioNoise;
        activeRadioNoise = null;
        try {
            noise.gain.gain.setTargetAtTime(0, getRadioAudioContext().currentTime, 0.035);
            window.setTimeout(() => {
                try { noise.source.stop(); } catch (error) {}
            }, 120);
        } catch (error) {
            try { noise.source.stop(); } catch (stopError) {}
        }
    }

    function makeRadioCurve(amount) {
        const samples = 44100;
        const curve = new Float32Array(samples);
        const k = Number(amount) || 18;
        for (let i = 0; i < samples; i += 1) {
            const x = (i * 2 / samples) - 1;
            curve[i] = ((3 + k) * x * 20 * Math.PI / 180) / (Math.PI + k * Math.abs(x));
        }
        return curve;
    }

    function playDispatcherAudio(data) {
        if (!data || !data.audioBase64) return;
        const mimeType = data.mimeType || 'audio/mpeg';
        const audioUrl = audioUrlFromBase64(data.audioBase64, mimeType);
        if (!audioUrl) return;

        const audio = new Audio(audioUrl);
        audio.volume = Math.max(0, Math.min(1, Number(data.volume) || 0.95));
        let started = false;

        const cleanup = () => {
            try {
                URL.revokeObjectURL(audioUrl);
            } catch (error) {}
        };

        stopRadioNoise();
        if (data.radioEffect !== false) {
            playSquelch(data.squelchVolume, 0.18);
            startRadioNoise(data.noiseVolume);
        }

        const ctx = data.radioEffect !== false ? getRadioAudioContext() : null;
        if (ctx) {
            try {
                const source = ctx.createMediaElementSource(audio);
                const highpass = ctx.createBiquadFilter();
                const lowpass = ctx.createBiquadFilter();
                const compressor = ctx.createDynamicsCompressor();
                const distortion = ctx.createWaveShaper();
                const gain = ctx.createGain();

                highpass.type = 'highpass';
                highpass.frequency.value = 420;
                lowpass.type = 'lowpass';
                lowpass.frequency.value = 2850;
                compressor.threshold.value = -28;
                compressor.knee.value = 16;
                compressor.ratio.value = 6;
                compressor.attack.value = 0.003;
                compressor.release.value = 0.18;
                distortion.curve = makeRadioCurve(10);
                distortion.oversample = '2x';
                gain.gain.value = Math.max(0, Math.min(1.2, Number(data.volume) || 0.95));

                source.connect(highpass);
                highpass.connect(lowpass);
                lowpass.connect(compressor);
                compressor.connect(distortion);
                distortion.connect(gain);
                gain.connect(ctx.destination);
            } catch (error) {}
        }

        audio.addEventListener('playing', () => {
            if (started) return;
            started = true;
            postPlaybackResult({
                ok: true,
                stage: 'playing',
                detail: `${mimeType} bytes64=${String(data.audioBase64 || '').length}`
            });
        });
        audio.addEventListener('ended', () => {
            if (data.radioEffect !== false) {
                stopRadioNoise();
                playSquelch(data.squelchVolume, 0.11);
            }
            postPlaybackResult({ ok: true, stage: 'ended' });
            cleanup();
        });
        audio.addEventListener('error', () => {
            stopRadioNoise();
            postPlaybackResult({ ok: false, stage: 'audio_error', error: audio.error ? String(audio.error.code || audio.error.message || 'audio error') : 'audio error' });
            cleanup();
        });

        audio.play().catch((error) => {
            stopRadioNoise();
            postPlaybackResult({ ok: false, stage: 'play_rejected', error: String(error && error.message ? error.message : error) });
            cleanup();
        });
    }

    async function startRecording(data) {
        stopRecording();
        pendingStop = false;

        if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
            postResult({ ok: false, error: 'Microphone capture is not available in this NUI browser.' });
            return;
        }

        if (!window.MediaRecorder) {
            postResult({ ok: false, error: 'MediaRecorder is not available in this NUI browser.' });
            return;
        }

        const mimeType = pickRecordingMimeType();
        if (!mimeType) {
            postResult({ ok: false, error: 'No supported microphone recording format was found.' });
            return;
        }

        try {
            const stream = await getSpeechStream();
            const chunks = [];
            const startedAt = performance.now();
            const audioBitsPerSecond = Math.max(8000, Number(data.audioBitsPerSecond) || 24000);
            const mediaRecorder = new MediaRecorder(stream, { mimeType, audioBitsPerSecond });
            const AudioContextClass = window.AudioContext || window.webkitAudioContext;
            const minMs = Math.max(0, Number(data.minMs) || 350);
            const silenceMs = Math.max(80, Number(data.silenceMs) || 500);
            const silenceThreshold = Math.max(0.001, Number(data.silenceThreshold) || 0.014);
            const stopOnSilence = data.stopOnSilence === true;
            const detectVoice = data.detectVoice !== false;
            const requireDetectedVoice = data.requireDetectedVoice === true;
            const voiceDetectThreshold = Math.max(0.001, Number(data.voiceDetectThreshold) || 0.012);
            const minVoiceMs = Math.max(0, Number(data.minVoiceMs) || 140);
            let monitorContext = null;
            let monitorSource = null;
            let monitorTimer = null;
            let silentSince = 0;
            let hasDetectedVoice = false;
            let voiceMs = 0;
            let peakRms = 0;
            let lastVoiceTick = 0;
            let voiceMonitorReady = false;
            let stopped = false;

            activeRecorder = { mediaRecorder };

            const stopSilenceMonitor = () => {
                if (monitorTimer) {
                    window.clearInterval(monitorTimer);
                    monitorTimer = null;
                }
                try { if (monitorSource) monitorSource.disconnect(); } catch (error) {}
                monitorSource = null;
                monitorContext = null;
            };

            const stopOnce = () => {
                if (stopped) return;
                stopped = true;
                stopSilenceMonitor();
                stopRecording();
            };

            mediaRecorder.addEventListener('dataavailable', (event) => {
                if (event.data && event.data.size) {
                    chunks.push(event.data);
                }
            });

            mediaRecorder.addEventListener('stop', async () => {
                activeRecorder = null;
                stopSilenceMonitor();

                try {
                    const blob = new Blob(chunks, { type: mimeType });
                    if (!blob.size) {
                        postResult({ ok: false, error: 'No microphone audio was recorded.' });
                        return;
                    }

                    if (requireDetectedVoice && voiceMonitorReady && voiceMs < minVoiceMs) {
                        postResult({
                            ok: false,
                            error: 'No dispatcher speech was detected.',
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
                } catch (error) {
                    postResult({ ok: false, error: error && error.message ? error.message : String(error) });
                }
            });

            mediaRecorder.addEventListener('error', (event) => {
                postResult({ ok: false, error: event.error ? event.error.message : 'Microphone recording failed.' });
                stopOnce();
            });

            mediaRecorder.start(100);

            if (AudioContextClass && (stopOnSilence || detectVoice)) {
                try {
                    monitorContext = speechMonitorContext || new AudioContextClass();
                    speechMonitorContext = monitorContext;
                    if (monitorContext.state === 'suspended') {
                        monitorContext.resume().catch(() => {});
                    }
                    const analyser = monitorContext.createAnalyser();
                    analyser.fftSize = 512;
                    monitorSource = monitorContext.createMediaStreamSource(stream);
                    monitorSource.connect(analyser);
                    voiceMonitorReady = true;

                    const samples = new Uint8Array(analyser.fftSize);
                    monitorTimer = window.setInterval(() => {
                        if (stopped) return;
                        const elapsed = performance.now() - startedAt;
                        if (elapsed < minMs) return;

                        analyser.getByteTimeDomainData(samples);
                        let sum = 0;
                        for (let i = 0; i < samples.length; i += 1) {
                            const centered = (samples[i] - 128) / 128;
                            sum += centered * centered;
                        }

                        const rms = Math.sqrt(sum / samples.length);
                        peakRms = Math.max(peakRms, rms);
                        if (rms > voiceDetectThreshold) {
                            hasDetectedVoice = true;
                            const now = performance.now();
                            voiceMs += lastVoiceTick > 0 ? Math.min(80, now - lastVoiceTick) : 35;
                            lastVoiceTick = now;
                        } else {
                            lastVoiceTick = 0;
                        }

                        if (!stopOnSilence || !hasDetectedVoice) return;

                        if (rms <= silenceThreshold) {
                            silentSince = silentSince || performance.now();
                            if (performance.now() - silentSince >= silenceMs) {
                                stopOnce();
                            }
                        } else {
                            silentSince = 0;
                        }
                    }, 35);
                } catch (error) {
                    stopSilenceMonitor();
                }
            }

            if (pendingStop) {
                pendingStop = false;
                window.setTimeout(stopOnce, 25);
            }

            window.setTimeout(stopOnce, Math.max(900, Number(data.maxMs) || 30000));
        } catch (error) {
            postResult({ ok: false, error: error && error.message ? error.message : String(error) });
        }
    }

    function speakDispatcher(data) {
        if (!window.speechSynthesis || !data || !data.text) return;

        window.speechSynthesis.cancel();
        stopRadioNoise();
        if (data.radioEffect !== false) {
            playSquelch(data.squelchVolume, 0.18);
            startRadioNoise(data.noiseVolume);
        }

        const utterance = new SpeechSynthesisUtterance(String(data.text));
        const voice = pickSpeechVoice();
        if (voice) utterance.voice = voice;
        utterance.lang = data.language || (voice && voice.lang) || 'en-US';
        utterance.rate = Math.max(0.5, Math.min(1.5, Number(data.rate) || 0.92));
        utterance.pitch = Math.max(0.2, Math.min(2.0, Number(data.pitch) || 0.82));
        utterance.volume = Math.max(0, Math.min(1, Number(data.volume) || 0.95));
        utterance.onend = () => {
            if (data.radioEffect !== false) {
                stopRadioNoise();
                playSquelch(data.squelchVolume, 0.11);
            }
        };
        utterance.onerror = () => {
            stopRadioNoise();
        };
        window.speechSynthesis.speak(utterance);
    }

    window.addEventListener('message', (event) => {
        const data = event.data || {};

        if (data.action === 'ai_dispatcher:speech:record') {
            startRecording(data);
        } else if (data.action === 'ai_dispatcher:speech:stop') {
            stopRecording();
        } else if (data.action === 'ai_dispatcher:speech:warm') {
            warmSpeechCapture();
        } else if (data.action === 'ai_dispatcher:play_audio') {
            playDispatcherAudio(data);
        } else if (data.action === 'ai_dispatcher:speak') {
            speakDispatcher(data);
        } else if (data.action === 'frequency_radio:speaker_monitor:start') {
            startFrequencySpeakerMonitor(data);
        } else if (data.action === 'frequency_radio:speaker_monitor:update') {
            updateFrequencySpeakerMonitor(data);
        } else if (data.action === 'frequency_radio:speaker_monitor:stop') {
            stopFrequencySpeakerMonitor(data);
        }
    });

    window.setTimeout(warmSpeechCapture, 1200);
}());
