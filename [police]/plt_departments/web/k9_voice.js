(function () {
    let activeRecorder = null;
    let speechStream = null;
    let speechStreamPromise = null;
    let pendingStop = false;

    function resourceName() {
        return typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'plt_departments';
    }

    function postResult(result) {
        fetch(`https://${resourceName()}/k9SpeechResult`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify(result || { ok: false, error: 'No K9 speech result.' })
        });
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
            let stopped = false;

            activeRecorder = { mediaRecorder };

            const stopOnce = () => {
                if (stopped) return;
                stopped = true;
                stopRecording();
            };

            mediaRecorder.addEventListener('dataavailable', (event) => {
                if (event.data && event.data.size) {
                    chunks.push(event.data);
                }
            });

            mediaRecorder.addEventListener('stop', async () => {
                activeRecorder = null;

                try {
                    const blob = new Blob(chunks, { type: mimeType });
                    if (!blob.size) {
                        postResult({ ok: false, error: 'No microphone audio was recorded.' });
                        return;
                    }

                    postResult({
                        ok: true,
                        audioBase64: await blobToBase64(blob),
                        mimeType,
                        durationMs: Math.round(performance.now() - startedAt)
                    });
                } catch (error) {
                    postResult({ ok: false, error: error && error.message ? error.message : String(error) });
                }
            });

            mediaRecorder.addEventListener('error', (event) => {
                postResult({ ok: false, error: event.error ? event.error.message : 'Microphone recording failed.' });
                stopOnce();
            });

            mediaRecorder.start();

            if (pendingStop) {
                pendingStop = false;
                window.setTimeout(stopOnce, 25);
            }

            window.setTimeout(stopOnce, Math.max(800, Number(data.maxMs) || 4500));
        } catch (error) {
            postResult({ ok: false, error: error && error.message ? error.message : String(error) });
        }
    }

    window.addEventListener('message', (event) => {
        const data = event.data || {};

        if (data.action === 'k9:speech:record') {
            startRecording(data);
        } else if (data.action === 'k9:speech:stop') {
            stopRecording();
        }
    });
}());
