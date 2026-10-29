import { useEffect, useRef, useState } from "react";
import { useNuiEvent } from "../../providers/nui/useNui";
import RangeControl, { VuMeter } from "./RangeControl";
import { Mic, MicOff, Plus, Square } from "lucide-react";
import { fetchNui } from "@/providers/nui/fetchNui";
import LightControls from "./LightControls";
import MasterLightControls from "./MasterLightControls";
import ParticleEffectsControls from "./ParticleEffectsControls";
import { useLocale } from "../../providers/locale/Locale";
type Deck = {
    audio: HTMLAudioElement;
    isPlaying: boolean;
    tempo: number;
    baseBpm: number | null;
    currentTime?: number;
    duration?: number;
    objectUrl?: string;
    deckVolume?: number; // 0..1
    playlist?: PlaylistItem[];
    currentItemId?: string | null;
}

type PlaylistItem = {
    id: string;
    title: string;
    src: string; // object URL or remote URL
    sourceType: "file";
    baseBpm?: number | null;
};

type LibraryItem = {
    id: number;
    title: string;
    url: string;
    mime?: string;
    file_size?: number;
    created_at?: string;
};

export default function MusicController() {
    const locale = useLocale();
    const [decks, setDecks] = useState<Record<string, Deck>>({});
    const decksRef = useRef<Record<string, Deck>>({});
    const [crossfade, setCrossfade] = useState(0.5); // 0 = left only, 1 = right only
    const [masterVolume, setMasterVolume] = useState(1); // overall gain cap

    useEffect(() => {
        console.log("MusicController: mounted");
        return () => console.log("MusicController: unmounted");
    }, []);
    // Web Audio routing
    const audioCtxRef = useRef<AudioContext | null>(null);
    const nodesRef = useRef<Record<string, { source: MediaElementAudioSourceNode; gain: GainNode; panner: StereoPannerNode; analyser?: AnalyserNode; altSource?: MediaElementAudioSourceNode }>>({});
    const masterBusRef = useRef<GainNode | null>(null);
    const broadcastBusRef = useRef<GainNode | null>(null);
    const streamDestRef = useRef<MediaStreamAudioDestinationNode | null>(null);
    const masterAnalyserRef = useRef<AnalyserNode | null>(null);
    const monitorConnectedRef = useRef<boolean>(true);
	const micAnalyserRef = useRef<AnalyserNode | null>(null);
    const [isBroadcasting, setIsBroadcasting] = useState(false);
    // Mic capture/mix
    const micStreamRef = useRef<MediaStream | null>(null);
    const micSourceRef = useRef<MediaStreamAudioSourceNode | null>(null);
    const micGainRef = useRef<GainNode | null>(null);
    const [isMicOn, setIsMicOn] = useState(false);
    const [micDevices, setMicDevices] = useState<MediaDeviceInfo[]>([]);
    const [selectedMicId, setSelectedMicId] = useState<string | "default" | null>(null);

    const peerMapRef = useRef<Record<number, RTCPeerConnection>>({});
    const outboundTrackRef = useRef<MediaStreamTrack | null>(null);
    const streamIdRef = useRef<string | null>(null);

    // Monitor state: only one deck at a time; first deck -> Left, second -> Right
    const [monitorDeck, setMonitorDeck] = useState<string | null>(null);
    const [visible, setVisible] = useState(false);
    const [currentStationId, setCurrentStationId] = useState<number | null>(null);
    // VU meters (0..1 normalized)
    const [vuLevels, setVuLevels] = useState<Record<string, number>>({ track_1: 0, track_2: 0, mic: 0 });
    const [masterVu, setMasterVu] = useState<number>(0);

    // Keep latest decks in a ref for event handlers
    useEffect(() => { decksRef.current = decks; }, [decks]);

    // Tempo and BPM states
    useEffect(() => {
        const t1 = new Audio();
        const t2 = new Audio();
        t1.loop = false;
        t2.loop = false;
        t1.preload = "auto";
        t2.preload = "auto";
        // Ensure tempo affects pitch (disable pitch preservation where supported)
        try {
            (t1 as any).preservesPitch = false;
            (t1 as any).mozPreservesPitch = false;
            (t1 as any).webkitPreservesPitch = false;
        } catch {}
        try {
            (t2 as any).preservesPitch = false;
            (t2 as any).mozPreservesPitch = false;
            (t2 as any).webkitPreservesPitch = false;
        } catch {}
        setDecks({
            track_1: {
                audio: t1,
                isPlaying: false,
                tempo: 1,
                baseBpm: null,
                currentTime: 0,
                duration: 0,
                deckVolume: 1,
                playlist: [],
                currentItemId: null,
            },
            track_2: {
                audio: t2,
                isPlaying: false,
                tempo: 1,
                baseBpm: null,
                currentTime: 0,
                duration: 0,
                deckVolume: 1,
                playlist: [],
                currentItemId: null,
            },
        });

        // Create Web Audio graph
        const AudioCtx = (window as any).AudioContext || (window as any).webkitAudioContext;
        const ctx: AudioContext = audioCtxRef.current ?? new AudioCtx();
        audioCtxRef.current = ctx;

        // Create master bus (for local monitoring) and a separate broadcast bus (for recording/stream)
        const masterBus = ctx.createGain();
        masterBus.gain.value = 1.0;
        masterBus.connect(ctx.destination);
        masterBusRef.current = masterBus;
        monitorConnectedRef.current = true;
        const broadcastBus = ctx.createGain();
        broadcastBus.gain.value = 1.0;
        broadcastBusRef.current = broadcastBus;
        // Master analyser (tap the master bus)
        try {
            const masterAnalyser = ctx.createAnalyser();
            masterAnalyser.smoothingTimeConstant = 0.8;
            masterAnalyser.fftSize = 1024;
            masterBus.connect(masterAnalyser);
            masterAnalyserRef.current = masterAnalyser;
        } catch {}
        try {
            const streamDest = ctx.createMediaStreamDestination();
            streamDestRef.current = streamDest;
            // Route broadcast bus to the recording stream; keep master bus for headphones/room
            broadcastBus.connect(streamDest);
        } catch {}

        const makeChain = (el: HTMLAudioElement) => {
            const source = ctx.createMediaElementSource(el);
            const gain = ctx.createGain();
            const panner = ctx.createStereoPanner();
            let analyser: AnalyserNode | undefined;
            try {
                analyser = ctx.createAnalyser();
                analyser.smoothingTimeConstant = 0.8;
                analyser.fftSize = 1024;
            } catch {}
            // Route each deck into master bus (for monitoring via panners)
            // and also into broadcast bus (pre-panner) so monitoring pan doesn't affect stream
            source.connect(gain);
            gain.connect(panner).connect(masterBus);
            try { if (analyser) { gain.connect(analyser); } } catch {}
            try {
                broadcastBusRef.current && gain.connect(broadcastBusRef.current);
            } catch {}
            return { source, gain, panner, analyser };
        };

        nodesRef.current["track_1"] = makeChain(t1);
        nodesRef.current["track_2"] = makeChain(t2);

        // Wire metadata and progress
        const onLoaded1 = () => setDecks(prev => prev.track_1 ? ({ ...prev, track_1: { ...prev.track_1, duration: t1.duration || 0 } }) : prev);
        const onLoaded2 = () => setDecks(prev => prev.track_2 ? ({ ...prev, track_2: { ...prev.track_2, duration: t2.duration || 0 } }) : prev);
        const onTime1 = () => setDecks(prev => prev.track_1 ? ({ ...prev, track_1: { ...prev.track_1, currentTime: t1.currentTime } }) : prev);
        const onTime2 = () => setDecks(prev => prev.track_2 ? ({ ...prev, track_2: { ...prev.track_2, currentTime: t2.currentTime } }) : prev);
        t1.addEventListener("loadedmetadata", onLoaded1);
        t2.addEventListener("loadedmetadata", onLoaded2);
        t1.addEventListener("timeupdate", onTime1);
        t2.addEventListener("timeupdate", onTime2);
        const onEnded1 = () => { try { advancePlaylist("track_1"); } catch {} };
        const onEnded2 = () => { try { advancePlaylist("track_2"); } catch {} };
        t1.addEventListener("ended", onEnded1);
        t2.addEventListener("ended", onEnded2);

        let cancelled = false;
        return () => {
            t1.removeEventListener("loadedmetadata", onLoaded1);
            t2.removeEventListener("loadedmetadata", onLoaded2);
            t1.removeEventListener("timeupdate", onTime1);
            t2.removeEventListener("timeupdate", onTime2);
            t1.removeEventListener("ended", onEnded1);
            t2.removeEventListener("ended", onEnded2);
            t1.pause();
            t2.pause();
            try {
                nodesRef.current["track_1"]?.source.disconnect();
                nodesRef.current["track_1"]?.gain.disconnect();
                nodesRef.current["track_1"]?.panner.disconnect();
                nodesRef.current["track_1"]?.altSource?.disconnect();
                nodesRef.current["track_2"]?.source.disconnect();
                nodesRef.current["track_2"]?.gain.disconnect();
                nodesRef.current["track_2"]?.panner.disconnect();
                nodesRef.current["track_2"]?.altSource?.disconnect();
            } catch {}
            // do not close ctx to avoid pops; it will be GC'ed on page unload
            cancelled = true;
        };
    }, []);

    // Expose helpers for debugging / programmatic access
    useEffect(() => {
        (window as any).__getMusicAudioContext = () => audioCtxRef.current;
        (window as any).__getMusicMixStream = () => streamDestRef.current?.stream ?? null;
    }, []);

    // NUI helpers
    const getParentResource = (): string => {
        try {
            const fn = (window as any).GetParentResourceName;
            if (typeof fn === "function") return fn();
        } catch {}
        return "pickle_dj";
    };
    const nuiPost = async (name: string, data?: any) => {
        const resource = getParentResource();
        try {
            await fetch(`https://${resource}/${name}`, {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=utf-8" },
                body: JSON.stringify(data ?? {}),
            });
        } catch (e) {
            console.error("MusicController: NUI POST failed", name, e);
        }
    };
    const nuiPostJson = async <T,>(name: string, data?: any): Promise<T | null> => {
        const resource = getParentResource();
        try {
            const res = await fetch(`https://${resource}/${name}`, {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=utf-8" },
                body: JSON.stringify(data ?? {}),
            });
            const txt = await res.text();
            try { return JSON.parse(txt) as T; } catch { return null; }
        } catch (e) {
            console.error("MusicController: NUI POST JSON failed", name, e);
            return null;
        }
    };
    type TurnConfig = {
        iceServers?: Array<{ urls: string[] | string; username?: string; credential?: string; }>;
    };
    const sleep = (ms: number) => new Promise<void>(r => setTimeout(r, ms));
    const fetchTurnConfig = async (): Promise<RTCConfiguration> => {
        let requested = false;
        for (let i = 0; i < 15; i++) {
            const cfg = await nuiPostJson<{ ok: boolean; config?: TurnConfig }>("music_rtc_get_turn_config", {});
            const c = (cfg && cfg.config) ? cfg.config : null;
            const valid = !!(c && Array.isArray(c.iceServers) && c.iceServers.length > 0);
            if (valid) {
                return { iceServers: c!.iceServers as any };
            }
            if (!requested) {
                requested = true;
                await nuiPost("music_rtc_request_turn_config", {});
            }
            await sleep(200);
        }
        return {};
    };

    // (no-op placeholder removed: chunk-based streaming is no longer used)

    // Legacy startBroadcast function - should not be used anymore
    // Broadcasting is now handled automatically via music:startAutoBroadcast event
    // This function is kept for backwards compatibility but will not start broadcasts
    const startBroadcast = async (providedStreamId?: string, instanceId?: number) => {
        // This function should never be called - broadcasting is handled via music:startAutoBroadcast event
        console.warn("MusicController: startBroadcast() called - this is legacy code and should not be used. Broadcasting is handled via music:startAutoBroadcast event.");
        return;
    };

    // Reset controller to default state
    const resetController = () => {
        console.log("MusicController: Resetting to default state");
        
        // Stop all playing tracks and reset audio elements
        setDecks(prev => {
            const updated: Record<string, Deck> = {};
            for (const [key, deck] of Object.entries(prev)) {
                try {
                    deck.audio.pause();
                    deck.audio.currentTime = 0;
                    // Reset playback rate (tempo)
                    deck.audio.playbackRate = 1.0;
                    // Unmute audio element (in case it was muted during stopBroadcast)
                    deck.audio.muted = false;
                } catch {}
                
                updated[key] = {
                    ...deck,
                    isPlaying: false,
                    tempo: 1,
                    currentTime: 0,
                    deckVolume: 1,
                    playlist: [],
                };
            }
            return updated;
        });
        
        // Reset settings
        setCrossfade(0.5);
        setMasterVolume(1);
        setMonitorDeck(null);
        setVuLevels({ track_1: 0, track_2: 0, mic: 0 });
        setMasterVu(0);
        
        // Reset audio node gains and panners
        try {
            if (nodesRef.current["track_1"]) {
                if (nodesRef.current["track_1"].gain) {
                    nodesRef.current["track_1"].gain.gain.value = 1;
                }
                if (nodesRef.current["track_1"].panner) {
                    nodesRef.current["track_1"].panner.pan.value = 0;
                }
            }
            if (nodesRef.current["track_2"]) {
                if (nodesRef.current["track_2"].gain) {
                    nodesRef.current["track_2"].gain.gain.value = 1;
                }
                if (nodesRef.current["track_2"].panner) {
                    nodesRef.current["track_2"].panner.pan.value = 0;
                }
            }
            if (masterBusRef.current) {
                masterBusRef.current.gain.value = 1.0;
            }
            if (broadcastBusRef.current) {
                broadcastBusRef.current.gain.value = 1.0;
            }
        } catch {}
    };

    const stopBroadcast = async () => {
        if (!isBroadcasting) return;
        setIsBroadcasting(false);
        
        // Immediately stop all audio playback before cleaning up
        // This prevents audio from continuing to play after stopBroadcast is called
        try {
            // Mute all audio buses immediately to prevent any audio leakage or glitches
            if (broadcastBusRef.current) {
                broadcastBusRef.current.gain.value = 0;
            }
            if (masterBusRef.current) {
                masterBusRef.current.gain.value = 0;
            }
            
            // Mute individual deck gain nodes to stop audio at the source
            const nodes = nodesRef.current;
            if (nodes["track_1"]?.gain) {
                nodes["track_1"].gain.gain.value = 0;
            }
            if (nodes["track_2"]?.gain) {
                nodes["track_2"].gain.gain.value = 0;
            }
            
            // Pause all audio elements immediately
            const currentDecks = decksRef.current;
            for (const deck of Object.values(currentDecks)) {
                try {
                    if (deck.audio) {
                        deck.audio.pause();
                        deck.audio.currentTime = 0;
                        // Also mute the audio element as an additional safeguard
                        deck.audio.muted = true;
                    }
                } catch {}
            }
        } catch {}
        
        await nuiPost("music_rtc_stop_broadcast", {});
        const map = peerMapRef.current;
        for (const k of Object.keys(map)) {
            const id = Number(k);
            const pc = map[id];
            try { pc.onicecandidate = null; } catch {}
            try { pc.ontrack = null; } catch {}
            try { pc.getSenders().forEach(s => { try { pc.removeTrack(s); } catch {} }); } catch {}
            try { pc.close(); } catch {}
            delete map[id];
        }
        peerMapRef.current = {};
        outboundTrackRef.current = null;
        streamIdRef.current = null;
        try {
            (window as any).__musicIsBroadcaster = false;
            (window as any).__musicBroadcastStreamId = null;
        } catch {}
        
        // Reset controller to default state (clear playlists and reset settings)
        resetController();
        
        // turn off mic if enabled
        try {
            if (isMicOn) {
                // disconnect and stop
                try { micSourceRef.current?.disconnect(); } catch {}
                try { micGainRef.current?.disconnect(); } catch {}
				try { micAnalyserRef.current?.disconnect(); } catch {}
                try { micStreamRef.current?.getTracks().forEach(t => { try { t.stop(); } catch {} }); } catch {}
                micSourceRef.current = null;
                micGainRef.current = null;
                micStreamRef.current = null;
				micAnalyserRef.current = null;
                setIsMicOn(false);
            }
        } catch {}
    };

    const stopBroadcastAndClose = async () => {
        // Open confirmation dialog
        setIsStopBroadcastDialogOpen(true);
    };

    const confirmStopBroadcast = async () => {
        setIsStopBroadcastDialogOpen(false);
        await stopBroadcast();
        // Close the UI - set visible state first, then notify client
        setVisible(false);
        await fetchNui("setVisible", { visible: false });
    };

    const ensureBroadcasterPeer = async (listenerId: number): Promise<RTCPeerConnection | null> => {
        const existing = peerMapRef.current[listenerId];
        if (existing) return existing;
        const cfg = await fetchTurnConfig();
        const pc = new RTCPeerConnection(cfg);
        try {
            pc.onconnectionstatechange = () => console.log("MusicController RTC connectionState:", pc.connectionState, "to", listenerId);
            pc.oniceconnectionstatechange = () => console.log("MusicController RTC iceConnectionState:", pc.iceConnectionState, "to", listenerId);
            pc.onicegatheringstatechange = () => console.log("MusicController RTC gatheringState:", pc.iceGatheringState, "to", listenerId);
        } catch {}
        pc.onicecandidate = (ev) => {
            if (ev.candidate) {
                nuiPost("music_rtc_ice_to_listener", { to: listenerId, candidate: ev.candidate });
            }
        };
        const stream = streamDestRef.current?.stream || null;
        const track = outboundTrackRef.current || (stream ? stream.getAudioTracks()[0] : null);
        if (track && stream) {
            try { 
                pc.addTrack(track, stream);
                console.log("MusicController: added outbound track to peer", { listenerId, enabled: track.enabled, muted: (track as any).muted });
                try {
                    (track as any).onmute = () => console.warn("MusicController: outbound track muted");
                    (track as any).onunmute = () => console.warn("MusicController: outbound track unmuted");
                    (track as any).onended = () => console.warn("MusicController: outbound track ended");
                } catch {}
            } catch (e) {
                console.error("MusicController: addTrack failed", e);
            }
            outboundTrackRef.current = track;
        }
        peerMapRef.current[listenerId] = pc;
        return pc;
    };

    useNuiEvent("music:rtc:offer", async (msg: any) => {
        if (!isBroadcasting) return;
        const payload = (msg && (msg.payload || msg.data)) || {};
        const from = Number(payload.from);
        const sdp = payload.sdp;
        if (!from || !sdp) return;
        console.log("MusicController: received offer from", from);
        const pc = await ensureBroadcasterPeer(from);
        if (!pc) return;
        try {
            await pc.setRemoteDescription({ type: "offer", sdp });
            const answer = await pc.createAnswer();
            await pc.setLocalDescription(answer);
            await nuiPost("music_rtc_answer", { to: from, sdp: answer.sdp });
            console.log("MusicController: sent answer to", from);
        } catch {}
    });

    useNuiEvent("music:rtc:iceFromListener", async (msg: any) => {
        if (!isBroadcasting) return;
        const payload = (msg && (msg.payload || msg.data)) || {};
        const from = Number(payload.from);
        let candidate = payload.candidate;
        if (!from || !candidate) return;
        const pc = peerMapRef.current[from];
        if (!pc) return;
        try {
            // Normalize candidate possibly sent as JSON string
            if (typeof candidate === "string") {
                try { candidate = JSON.parse(candidate); } catch {}
            }
            await pc.addIceCandidate(candidate as RTCIceCandidateInit);
            console.log("MusicController: added ICE candidate from", from);
        } catch {}
    });

    // REMOVED: Auto-start broadcasting on mount
    // Broadcasting should only start when a player opens the DJ controller via music:startAutoBroadcast event
    // This prevents broadcasts from starting on resource start
    // useEffect(() => {
    //     // Start once when both decks are initialized and stream node exists
    //     if (isBroadcasting) return;
    //     if (!decks.track_1 || !decks.track_2) return;
    //     if (!audioCtxRef.current || !streamDestRef.current) return;
    //     // Best-effort kickoff (safe to call if already recording due to guard above)
    //     startBroadcast();
    //     // eslint-disable-next-line react-hooks/exhaustive-deps
    // }, [!!decks.track_1, !!decks.track_2]);

    // Stop broadcasting on unmount if still active
    useEffect(() => {
        return () => {
            if (isBroadcasting) {
                stopBroadcast();
            }
            // mic cleanup on unmount
            try { micSourceRef.current?.disconnect(); } catch {}
            try { micGainRef.current?.disconnect(); } catch {}
            try { micStreamRef.current?.getTracks().forEach(t => { try { t.stop(); } catch {} }); } catch {}
            try { navigator.mediaDevices?.removeEventListener?.("devicechange", onDeviceChange); } catch {}
        };
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [isBroadcasting]);

    // While broadcasting, prevent any local monitor output for the broadcaster,
    // but keep the broadcast bus feeding the MediaStream destination.
    useEffect(() => {
        const ctx = audioCtxRef.current;
        const master = masterBusRef.current;
        if (!ctx || !master) return;
        try {
            if (isBroadcasting) {
                if (monitorConnectedRef.current) {
                    try { master.disconnect(ctx.destination); } catch {}
                    monitorConnectedRef.current = false;
                }
            } else {
                if (!monitorConnectedRef.current) {
                    try { master.connect(ctx.destination); } catch {}
                    monitorConnectedRef.current = true;
                }
            }
        } catch {}
    }, [isBroadcasting]);

    // (YouTube IFrame API removed)

    // Apply equal-power crossfade to gain nodes; also apply playbackRate
    useEffect(() => {
        if (!decks.track_1?.audio || !decks.track_2?.audio) return;
        const n1 = nodesRef.current["track_1"];
        const n2 = nodesRef.current["track_2"];
        const vol1 = decks.track_1.deckVolume ?? 1;
        const vol2 = decks.track_2.deckVolume ?? 1;
        if (monitorDeck) {
            // When monitoring, bypass crossfader balance: both decks at half volume
            const half1 = Math.max(0, Math.min(1, 0.5 * masterVolume * vol1));
            const half2 = Math.max(0, Math.min(1, 0.5 * masterVolume * vol2));
            if (n1) n1.gain.gain.value = half1;
            if (n2) n2.gain.gain.value = half2;
        } else {
            const theta = crossfade * 0.5 * Math.PI;
            const leftGain = Math.cos(theta);
            const rightGain = Math.sin(theta);
            if (n1) n1.gain.gain.value = Math.max(0, Math.min(1, leftGain * masterVolume * vol1));
            if (n2) n2.gain.gain.value = Math.max(0, Math.min(1, rightGain * masterVolume * vol2));
        }
        decks.track_1.audio.playbackRate = decks.track_1.tempo;
        decks.track_2.audio.playbackRate = decks.track_2.tempo;
    }, [decks, crossfade, masterVolume, monitorDeck]);


    // Apply monitor routing via stereo panners
    useEffect(() => {
        const n1 = nodesRef.current["track_1"];
        const n2 = nodesRef.current["track_2"];
        if (!n1 || !n2) return;
        if (!monitorDeck) {
            n1.panner.pan.value = 0;
            n2.panner.pan.value = 0;
            return;
        }
        // track_1 monitored -> hard left, other hard right; track_2 opposite
        const isFirst = monitorDeck === "track_1";
        const monitored = isFirst ? n1 : n2;
        const other = isFirst ? n2 : n1;
        monitored.panner.pan.value = isFirst ? -1 : 1;
        other.panner.pan.value = isFirst ? 1 : -1;
    }, [monitorDeck]);


    // --- BPM Analysis Utilities ---

    async function analyzeBpmFromBlob(blob: Blob): Promise<number | null> {
        try {
            const arrayBuffer = await blob.arrayBuffer();
            const AudioCtx = (window as any).AudioContext || (window as any).webkitAudioContext;
            const ctx: AudioContext = new AudioCtx();
            const audioBuffer = await ctx.decodeAudioData(arrayBuffer);
            const bpm = estimateBpmFromBuffer(audioBuffer);
            await ctx.close();
            return bpm;
        } catch {
            return null;
        }
    }

    // --- Playlist helpers ---

    const deriveTitleFromUrlOrName = (input: string): string => {
        try {
            const noQuery = input.split("?")[0].split("#")[0];
            const parts = noQuery.split("/");
            const file = parts[parts.length - 1] || "track";
            const withoutExt = file.includes(".") ? file.substring(0, file.lastIndexOf(".")) : file;
            return decodeURIComponent(withoutExt).trim() || "track";
        } catch {
            return "track";
        }
    };


    const getNextPlaylistItemId = (deck: "track_1" | "track_2"): string | null => {
        const d = decksRef.current[deck];
        const list = d?.playlist || [];
        if (list.length === 0) return null;
        const currId = d?.currentItemId;
        const idx = list.findIndex(it => it.id === currId);
        const nextIdx = idx >= 0 ? (idx + 1) % list.length : 0;
        const nextItem = list[nextIdx];
        return nextItem ? nextItem.id : null;
    };

    const advancePlaylist = async (deck: "track_1" | "track_2") => {
        const nextId = getNextPlaylistItemId(deck);
        if (!nextId) return;
        await loadPlaylistItem(deck, nextId);
    };


    const addFileToPlaylist = async (deck: string, file: File) => {
        const url = URL.createObjectURL(file);
        const item: PlaylistItem = {
            id: `${Date.now()}_${Math.random().toString(36).slice(2)}`,
            title: deriveTitleFromUrlOrName(file.name),
            src: url,
            sourceType: "file",
            baseBpm: null,
        };
        setDecks(prev => {
            const list = prev[deck]?.playlist || [];
            return { ...prev, [deck]: { ...prev[deck], playlist: [...list, item] } };
        });
        const bpm = await analyzeBpmFromBlob(file);
        if (bpm) {
            setDecks(prev => {
                const list = prev[deck]?.playlist || [];
                const idx = list.findIndex(it => it.id === item.id);
                if (idx === -1) return prev;
                const next = [...list];
                next[idx] = { ...next[idx], baseBpm: bpm };
                return { ...prev, [deck]: { ...prev[deck], playlist: next } };
            });
        }
    };

    const loadPlaylistItem = async (deck: string, itemId: string) => {
    	const d = decksRef.current[deck];
    	if (!d?.audio) return;
    	const item = (d.playlist || []).find(x => x.id === itemId);
    	if (!item) return;
    	const wasPlaying = d.isPlaying === true;
    	// Configure audio element
            try { d.audio.pause(); } catch {}
            try {
                d.audio.src = item.src;
                d.audio.currentTime = 0;
                d.audio.loop = false;
                d.audio.preload = "auto";
            } catch {}
            try {
                (d.audio as any).preservesPitch = false;
                (d.audio as any).mozPreservesPitch = false;
                (d.audio as any).webkitPreservesPitch = false;
            } catch {}
            try { d.audio.load(); } catch {}
            // Commit selection state
            setDecks(prev => {
                const prevDeck = prev[deck];
                if (!prevDeck) return prev;
                return {
                    ...prev,
                    [deck]: {
                        ...prevDeck,
                        baseBpm: item.baseBpm ?? null,
                        currentTime: 0,
                        duration: 0,
                        isPlaying: false,
                        objectUrl: item.sourceType === "file" ? item.src : undefined,
                        currentItemId: item.id,
                    }
                };
            });
            // Autoplay only if previously playing; guard current item
            const resumeIfNeeded = async () => {
                const latest = decksRef.current[deck];
                if (!latest || latest.currentItemId !== itemId) return;
                if (!wasPlaying) return;
                try { await audioCtxRef.current?.resume?.(); } catch {}
                try {
                    await latest.audio.play();
                    setDecks(prev => {
                        const pd = prev[deck];
                        if (!pd || pd.currentItemId !== itemId) return prev;
                        return { ...prev, [deck]: { ...pd, isPlaying: true } };
                    });
                } catch {}
            };
            try { d.audio.addEventListener("canplay", resumeIfNeeded, { once: true } as any); } catch {}
            // BPM analysis if missing
            if (item.baseBpm == null) {
                let bpm: number | null = null;
                if (item.sourceType === "file") {
                    bpm = await (async () => {
                        try { const res = await fetch(item.src); const b = await res.blob(); return await analyzeBpmFromBlob(b); } catch { return null; }
                    })();
                }
                if (bpm) {
                    setDecks(prev => {
                        const list = prev[deck]?.playlist || [];
                        const idx = list.findIndex(it => it.id === itemId);
                        const nextList = [...list];
                        if (idx !== -1) nextList[idx] = { ...nextList[idx], baseBpm: bpm };
                        const isCurrent = prev[deck]?.currentItemId === itemId;
                        return {
                            ...prev,
                            [deck]: { ...prev[deck], playlist: nextList, baseBpm: isCurrent ? bpm : prev[deck].baseBpm }
                        };
                    });
                }
            }
    };

    const removePlaylistItem = (deck: string, itemId: string) => {
        const d = decks[deck];
        if (!d) return;
        const item = d.playlist?.find(x => x.id === itemId);
        const wasCurrent = d.currentItemId === itemId;

        if (item) {
            // Revoke object URLs where appropriate
            if (item.sourceType === "file") {
                if (wasCurrent) {
                    try { if (d.objectUrl) URL.revokeObjectURL(d.objectUrl); } catch {}
                } else if (item.src !== d.audio.src) {
                    try { URL.revokeObjectURL(item.src); } catch {}
                }
            }
            // If removing the currently loaded item, stop playback and clear sources
            if (wasCurrent) {
                try { d.audio.pause(); } catch {}
                try { d.audio.src = ""; } catch {}
                try { d.audio.removeAttribute("src"); } catch {}
                try { d.audio.currentTime = 0; d.audio.load(); } catch {}
            }
        }

        setDecks(prev => {
            const list = prev[deck]?.playlist || [];
            const next = list.filter(it => it.id !== itemId);
            const wasCurrentPrev = prev[deck]?.currentItemId === itemId;
            if (!prev[deck]) return prev;
            const nextDeck = wasCurrentPrev
                ? { ...prev[deck], playlist: next, currentItemId: null, isPlaying: false, currentTime: 0, duration: 0, objectUrl: undefined }
                : { ...prev[deck], playlist: next };
            return { ...prev, [deck]: nextDeck };
        });
    };

    const [isAddDialogOpen, setIsAddDialogOpen] = useState(false);
    const [addDialogDeck, setAddDialogDeck] = useState<"track_1" | "track_2">("track_1");
    const addDialogSessionRef = useRef(0);
    const [libraryItems, setLibraryItems] = useState<LibraryItem[]>([]);
    const [libraryLoading, setLibraryLoading] = useState(false);
    const [libraryUploading, setLibraryUploading] = useState(false);
    const [libraryAvailable, setLibraryAvailable] = useState(true);
    const [libraryUploadEnabled, setLibraryUploadEnabled] = useState(false);
    const [libraryError, setLibraryError] = useState<string | null>(null);
    const playlistUploadRef = useRef<HTMLButtonElement>(null);
    const libraryUploadRef = useRef<HTMLButtonElement>(null);
    const [playlistUploadFocused, setPlaylistUploadFocused] = useState(false);
    const [libraryUploadFocused, setLibraryUploadFocused] = useState(false);
    const [pendingPastedFiles, setPendingPastedFiles] = useState<File[] | null>(null);
    const [libraryStatusChecked, setLibraryStatusChecked] = useState(false);
    const [librarySearch, setLibrarySearch] = useState("");
    const [librarySort, setLibrarySort] = useState<"newest" | "az" | "size">("newest");
    const [libraryItemPendingDelete, setLibraryItemPendingDelete] = useState<number | null>(null);

    const refreshLibrary = async () => {
        setLibraryLoading(true);
        try {
            const res = await fetchNui<{ ok: boolean; items?: LibraryItem[]; error?: string; uploadEnabled?: boolean }>("library_list", {});
            if (res && res.ok && Array.isArray(res.items)) {
                setLibraryItems(res.items);
                setLibraryAvailable(true);
                setLibraryUploadEnabled(!!res.uploadEnabled);
            } else if (res && res.error === "disabled") {
                setLibraryAvailable(false);
                setLibraryUploadEnabled(false);
            }
            setLibraryStatusChecked(true);
        } catch {
            // NUI not reachable in dev; ignore
        } finally {
            setLibraryLoading(false);
        }
    };

    useEffect(() => {
        if (!isAddDialogOpen) return;
        refreshLibrary();
        // Auto-focus the upload target so the visual cue shows immediately
        const t = setTimeout(() => {
            (playlistUploadRef.current || libraryUploadRef.current)?.focus();
        }, 0);
        return () => clearTimeout(t);
    }, [isAddDialogOpen]);

    // Document-level paste handler. Browsers / CEF do not fire `paste` events
    // on focused <button> elements, so we listen on document instead while the
    // add-song dialog is open. We always buffer the pasted files and show the
    // choice dialog; the dialog itself decides which options to render based on
    // current library availability (avoids races where the user pastes before
    // the async `library_list` status check resolves).
    useEffect(() => {
        if (!isAddDialogOpen) return;
        const handler = (e: ClipboardEvent) => {
            const files = Array.from(e.clipboardData?.files || []).filter(f =>
                f.type.startsWith("audio/") ||
                /\.(mp3|wav|ogg|flac|m4a|aac|opus|webm)$/i.test(f.name)
            );
            if (files.length === 0) return;
            e.preventDefault();
            setPendingPastedFiles(files);
            // Re-poll library status so the prompt reflects current reality
            // (the dialog-open refresh may not have settled yet).
            refreshLibrary();
        };
        document.addEventListener("paste", handler);
        return () => document.removeEventListener("paste", handler);
    }, [isAddDialogOpen]);

    const handlePasteChoice = async (target: "playlist" | "library" | "both") => {
        const files = pendingPastedFiles;
        setPendingPastedFiles(null);
        if (!files || files.length === 0) return;
        if (target === "playlist" || target === "both") {
            const session = addDialogSessionRef.current;
            for (const file of files) await addFileToPlaylist(addDialogDeck, file);
            if (target === "playlist" && addDialogSessionRef.current === session) {
                setIsAddDialogOpen(false);
            }
        }
        if (target === "library" || target === "both") {
            for (const f of files) await uploadToLibrary(f);
        }
    };

    // CEF/NUI loses keyboard+mouse focus on the overlay when an OS file
    // dialog opens. When the dialog closes the window regains focus, but
    // SetNuiFocus state isn't automatically restored, so subsequent clicks
    // bypass the NUI. Re-assert focus on every focus event, but only while
    // the controller is visible — otherwise a focus event that fires during
    // or just after the UI close sequence would erroneously re-assert
    // SetNuiFocus(true,true) and cause a stuck cursor.
    useEffect(() => {
        const reassert = () => {
            if (visible) {
                fetchNui("keepFocus", {}).catch(() => {});
            }
        };
        window.addEventListener("focus", reassert);
        document.addEventListener("visibilitychange", reassert);
        return () => {
            window.removeEventListener("focus", reassert);
            document.removeEventListener("visibilitychange", reassert);
        };
    }, [visible]);

    const uploadToLibrary = async (file: File) => {
        setLibraryUploading(true);
        setLibraryError(null);
        try {
            const mimeType = file.type || "audio/mpeg";
            const title = deriveTitleFromUrlOrName(file.name);

            // 1) Ask the server for a presigned upload URL.
            const reqRes = await fetchNui<{
                ok: boolean;
                presignedUrl?: string;
                remoteId?: string;
                contentType?: string;
                error?: string;
                maxFileSizeMB?: number;
            }>("library_upload_request", {
                filename: file.name,
                mimeType,
                title,
                totalBytes: file.size,
            });
            if (!reqRes?.ok || !reqRes.presignedUrl || !reqRes.remoteId) {
                if (reqRes?.error === "too_large") setLibraryError(locale("ui_file_too_large"));
                else if (reqRes?.error === "library_full") setLibraryError(locale("ui_library_full"));
                else if (reqRes?.error === "disabled") setLibraryAvailable(false);
                else setLibraryError(locale("ui_upload_failed"));
                return;
            }

            // 2) Upload the file blob directly to Fivemanage. The presigned URL
            // endpoint expects POST multipart/form-data (per Fivemanage docs).
            // Bytes never transit through FiveM events.
            const formData = new FormData();
            formData.append("file", file, file.name);
            const putRes = await fetch(reqRes.presignedUrl, {
                method: "POST",
                body: formData,
            });
            if (!putRes.ok) {
                setLibraryError(locale("ui_upload_failed"));
                return;
            }

            // Fivemanage response shape: { status: "ok", data: { id, url, originalUrl } }
            let fmId = "";
            let fmUrl = "";
            try {
                const fmJson = await putRes.json();
                fmId = fmJson?.data?.id || "";
                fmUrl = fmJson?.data?.url || fmJson?.data?.originalUrl || "";
            } catch {
                setLibraryError(locale("ui_upload_failed"));
                return;
            }
            if (!fmUrl) {
                setLibraryError(locale("ui_upload_failed"));
                return;
            }

            // 3) Tell the server the upload finished so it can record the DB row.
            const confirmRes = await fetchNui<{ ok: boolean; item?: LibraryItem; error?: string }>(
                "library_upload_confirm",
                {
                    remoteId: reqRes.remoteId,
                    fileId: fmId,
                    url: fmUrl,
                    title,
                    filename: file.name,
                    mimeType,
                    fileSize: file.size,
                }
            );
            if (confirmRes?.ok && confirmRes.item) {
                setLibraryItems(prev => [confirmRes.item!, ...prev]);
            } else {
                setLibraryError(locale("ui_upload_failed"));
            }
        } catch {
            setLibraryError(locale("ui_upload_failed"));
        } finally {
            setLibraryUploading(false);
        }
    };

    const deleteLibraryItem = async (id: number) => {
        try {
            const res = await fetchNui<{ ok: boolean }>("library_delete", { id });
            if (res && res.ok) {
                setLibraryItems(prev => prev.filter(x => x.id !== id));
            }
        } catch {}
    };

    const addLibraryItemToPlaylist = async (deck: string, lib: LibraryItem) => {
        const item: PlaylistItem = {
            id: `${Date.now()}_${Math.random().toString(36).slice(2)}`,
            title: lib.title,
            src: lib.url,
            sourceType: "file",
            baseBpm: null,
        };
        setDecks(prev => {
            const list = prev[deck]?.playlist || [];
            return { ...prev, [deck]: { ...prev[deck], playlist: [...list, item] } };
        });
        try {
            const res = await fetch(lib.url);
            const blob = await res.blob();
            const bpm = await analyzeBpmFromBlob(blob);
            if (bpm) {
                setDecks(prev => {
                    const list = prev[deck]?.playlist || [];
                    const idx = list.findIndex(it => it.id === item.id);
                    if (idx === -1) return prev;
                    const next = [...list];
                    next[idx] = { ...next[idx], baseBpm: bpm };
                    return { ...prev, [deck]: { ...prev[deck], playlist: next } };
                });
            }
        } catch {}
    };
    const [isStopBroadcastDialogOpen, setIsStopBroadcastDialogOpen] = useState(false);

    // Estimate BPM via simple onset-envelope autocorrelation (downsampled to ~200 Hz)
    function estimateBpmFromBuffer(buffer: AudioBuffer): number | null {
        const duration = Math.min(buffer.duration, 30); // analyze up to 30s
        const sampleRate = buffer.sampleRate;
        const totalSamples = Math.min(Math.floor(duration * sampleRate), buffer.length);

        // Mixdown to mono (lightweight)
        const tmp = new Float32Array(totalSamples);
        const numChannels = buffer.numberOfChannels;
        for (let ch = 0; ch < numChannels; ch++) {
            const chData = buffer.getChannelData(ch);
            for (let i = 0; i < totalSamples; i++) {
                tmp[i] += chData[i];
            }
        }
        if (numChannels > 0) {
            for (let i = 0; i < totalSamples; i++) tmp[i] /= numChannels;
        }

        // Build simple onset envelope at ~200 Hz by sampling abs signal
        const envRate = 200; // Hz
        const step = sampleRate / envRate;
        const envLength = Math.max(1, Math.floor(totalSamples / step));
        const envelope = new Float32Array(envLength);
        for (let k = 0; k < envLength; k++) {
            const idx = Math.min(totalSamples - 1, Math.floor(k * step));
            envelope[k] = Math.abs(tmp[idx]);
        }

        // Smooth envelope with small moving average (~20 ms at 200 Hz ≈ 4 samples)
        const smooth = new Float32Array(envLength);
        const win = 4;
        let acc = 0;
        for (let i = 0; i < envLength; i++) {
            acc += envelope[i];
            if (i >= win) acc -= envelope[i - win];
            smooth[i] = acc / Math.min(i + 1, win);
        }

        // Normalize and mean-center
        let mean = 0;
        for (let i = 0; i < envLength; i++) mean += smooth[i];
        mean /= envLength || 1;
        for (let i = 0; i < envLength; i++) smooth[i] -= mean;

        // Autocorrelation over plausible BPS range [1, 3] => lags [envRate/3, envRate/1]
        const minLag = Math.max(1, Math.floor(envRate / 3)); // fastest: 3 bps
        const maxLag = Math.min(envLength - 1, Math.floor(envRate / 1)); // slowest: 1 bps
        if (maxLag <= minLag + 2) return null;

        let bestLag = -1;
        let bestVal = -Infinity;
        // Precompute energy for normalization (optional simple)
        for (let lag = minLag; lag <= maxLag; lag++) {
            let sum = 0;
            const limit = envLength - lag;
            for (let i = 0; i < limit; i++) {
                sum += smooth[i] * smooth[i + lag];
            }
            if (sum > bestVal) {
                bestVal = sum;
                bestLag = lag;
            }
        }
        if (bestLag <= 0) return null;

        const bps = envRate / bestLag;
        let bpm = bps * 60;

        // Fold to typical DJ ranges (60–180 BPM) heuristically
        while (bpm < 60) bpm *= 2;
        while (bpm > 180) bpm /= 2;

        if (!isFinite(bpm) || bpm <= 0) return null;
        return bpm;
    }

    const toggleDeck = async (deck: string) => {
        const d = decks[deck];
        if (!d?.audio) return;
        const currentItem = d.playlist?.find(x => x.id === d.currentItemId);

        // If no current item (e.g., it was deleted), allow stopping any lingering playback
        if (!currentItem) {
            try { d.audio.pause(); } catch {}
            setDecks(prev => ({ ...prev, [deck]: { ...prev[deck], isPlaying: false } }));
            return;
        }

        // HTML audio handling
        const ctx = audioCtxRef.current;
        if (d.isPlaying) {
            d.audio.pause();
            setDecks(prev => ({ ...prev, [deck]: { ...prev[deck], isPlaying: false } }));
        } else {
            try { await ctx?.resume?.(); } catch {}
            try {
                await d.audio.play();
                setDecks(prev => ({ ...prev, [deck]: { ...prev[deck], isPlaying: true } }));
            } catch {
                // autoplay blocked or play failed; keep state unchanged
            }
        }
    };

    // onUploadFile removed; we use addFileToPlaylist in the dialog

    const formatTime = (secs?: number) => {
        const s = Math.max(0, Math.floor(secs || 0));
        const m = Math.floor(s / 60);
        const r = s % 60;
        return `${m}:${r.toString().padStart(2, "0")}`;
    };

    // (VU Meter moved into RangeControl component)

    useNuiEvent("music:setControllerVisible", (data: any) => {
        setVisible(data.visible);
        if (data.stationId) {
            setCurrentStationId(data.stationId);
        }
        // Note: We don't stop broadcasting when controller closes
        // Broadcasting continues until player leaves range of all speakers
    });
    
    // Listen for server-initiated broadcast start/stop
    useNuiEvent("music:startAutoBroadcast", async (eventData: any) => {
        // The useNuiEvent hook passes event.data, which for this message is:
        // { type: 'music:startAutoBroadcast', data: { instanceId, streamId } }
        // So we need to extract the nested data field
        const data = eventData.data || eventData;
        console.log("MusicController: Received music:startAutoBroadcast", { eventData, data, isBroadcasting, currentStreamId: streamIdRef.current });
        
        // Validate that we have both instanceId and streamId
        if (!data || !data.instanceId || !data.streamId) {
            console.error("MusicController: Invalid startAutoBroadcast data - missing instanceId or streamId", data);
            return;
        }
        
        // If already broadcasting with the same streamId, don't do anything
        // The server already knows we're broadcasting, no need to re-announce (which would reset connections)
        if (isBroadcasting && streamIdRef.current === data.streamId) {
            console.log("MusicController: Already broadcasting with same streamId, skipping (server already knows)");
            return;
        }
        // Wait for audio context to be ready (retry if needed)
        let retries = 0;
        const maxRetries = 10;
        while (retries < maxRetries) {
            const ctx = audioCtxRef.current;
            const streamNode = streamDestRef.current;
            if (ctx && streamNode) {
                try {
                    // Resume audio context if suspended
                    if (ctx.state === 'suspended') {
                        await ctx.resume();
                    }
                    
                    // Set the streamId ref
                    streamIdRef.current = data.streamId;
                    
                    // Get the audio track
                    const stream = streamNode.stream;
                    const audioTracks = stream.getAudioTracks();
                    outboundTrackRef.current = (audioTracks && audioTracks[0]) ? audioTracks[0] : null;

                    // Announce broadcast to server
                    // Ensure instanceId is a number (not string)
                    const instanceIdNum = typeof data.instanceId === 'string' ? parseInt(data.instanceId, 10) : data.instanceId;
                    console.log("MusicController: Sending announceBroadcast", { instanceId: instanceIdNum, streamId: data.streamId });
                    await nuiPost("music_rtc_announce_broadcast", { 
                        instanceId: instanceIdNum,
                        streamId: data.streamId 
                    });
                    
                    console.log("MusicController: auto-broadcast started", { 
                        streamId: data.streamId, 
                        instanceId: data.instanceId, 
                        hasTrack: !!outboundTrackRef.current,
                        ctxState: ctx.state
                    });
                    
                    setIsBroadcasting(true);
                    try {
                        (window as any).__musicBroadcastStreamId = data.streamId;
                        (window as any).__musicIsBroadcaster = true;
                    } catch {}
                    return; // Success, exit retry loop
                } catch (error) {
                    console.error("MusicController: Error starting broadcast", error);
                }
            }
            
            // Wait a bit before retrying
            await new Promise(resolve => setTimeout(resolve, 100));
            retries++;
        }
        
        console.error("MusicController: Failed to start broadcast - audio context not ready after retries");
    });
    
    useNuiEvent("music:stopAutoBroadcast", async (event: any) => {
        console.log("MusicController: Received music:stopAutoBroadcast", event);
        if (isBroadcasting) {
            await stopBroadcast();
        } else {
            // Even if not broadcasting, reset controller state
            resetController();
        }
    });

    // Receive initial light controls state
    useNuiEvent("music:lightControlsState", (data: any) => {
        if (data.stationId && data.controls) {
            // Store initial state - will be used by LightControls components
            // The components will receive this via props or context
        }
    });

    // Horizontal VU meter (mic-only) using same segment style as vertical
    function HorizontalVu({ level }: { level: number }) {
        const segments = 12;
        const lit = Math.max(0, Math.min(segments, Math.round(level * segments)));
        const segs: JSX.Element[] = [];
        for (let i = 0; i < segments; i++) {
            const idxFromLeft = i + 1;
            const on = idxFromLeft <= lit;
            let color = "#18a058";
            const frac = idxFromLeft / segments;
            if (frac >= 0.85) color = "#d64545";
            else if (frac >= 0.65) color = "#c8a43b";
            segs.push(
                <div
                    key={i}
                    style={{
                        flex: 1,
                        minWidth: 4,
                        height: 6,
                        borderRadius: 1,
                        background: on ? color : "#1e1e1e",
                    }}
                />
            );
        }
        return (
            <div
                style={{
                    width: "100%",
                    height: 10,
                    background: "#0b0b0b",
                    border: "1px solid #333",
                    borderRadius: 3,
                    display: "flex",
                    flexDirection: "row",
                    alignItems: "center",
                    padding: 1,
                    gap: 1,
                }}
            >
                {segs}
            </div>
        );
    }

    // Mic toggle handlers
    const enableMic = async () => {
        if (isMicOn) return;
        try {
            const ctx = audioCtxRef.current;
            const bus = broadcastBusRef.current;
            if (!ctx || !bus) return;
            try { await ctx.resume?.(); } catch {}
            const audioConstraints: MediaTrackConstraints = { echoCancellation: true, noiseSuppression: true, autoGainControl: true } as any;
            if (selectedMicId && selectedMicId !== "default") {
                (audioConstraints as any).deviceId = { exact: selectedMicId };
            }
            const stream = await navigator.mediaDevices.getUserMedia({ audio: audioConstraints });
            const source = ctx.createMediaStreamSource(stream);
            const gain = ctx.createGain();
            gain.gain.value = 1.0;
            source.connect(gain);
            gain.connect(bus);
			// Tap mic signal for VU meter
			try {
				const analyser = ctx.createAnalyser();
				analyser.smoothingTimeConstant = 0.8;
				analyser.fftSize = 1024;
				gain.connect(analyser);
				micAnalyserRef.current = analyser;
			} catch {}
            micStreamRef.current = stream;
            micSourceRef.current = source;
            micGainRef.current = gain;
            setIsMicOn(true);
            // After permission, refresh device labels
            try { await enumerateMicDevices(); } catch {}
        } catch (e) {
            console.error("MusicController: enableMic failed", e);
        }
    };
    const disableMic = () => {
        if (!isMicOn) return;
        try { micSourceRef.current?.disconnect(); } catch {}
        try { micGainRef.current?.disconnect(); } catch {}
		try { micAnalyserRef.current?.disconnect(); } catch {}
        try { micStreamRef.current?.getTracks().forEach(t => { try { t.stop(); } catch {} }); } catch {}
        micSourceRef.current = null;
        micGainRef.current = null;
        micStreamRef.current = null;
		micAnalyserRef.current = null;
        setIsMicOn(false);
    };
    const toggleMic = async () => {
        if (isMicOn) return disableMic();
        await enableMic();
    };
    // When changing device while mic is on, hot-switch by restarting mic
    useEffect(() => {
        (async () => {
            if (isMicOn) {
                try { disableMic(); } catch {}
                await enableMic();
            }
        })();
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [selectedMicId]);

    // Enumerate audio input devices
    const enumerateMicDevices = async () => {
        try {
            const list = await navigator.mediaDevices?.enumerateDevices?.();
            if (!list) return;
            const inputs = list.filter(d => d.kind === "audioinput");
            setMicDevices(inputs);
            // Initialize selection if none yet
            if (selectedMicId == null) {
                const def = inputs.find(d => d.deviceId === "default") || inputs[0];
                setSelectedMicId(def ? def.deviceId : null);
            }
        } catch {}
    };
    const onDeviceChange = () => { enumerateMicDevices(); };
    useEffect(() => {
        enumerateMicDevices();
        try { navigator.mediaDevices?.addEventListener?.("devicechange", onDeviceChange); } catch {}
        return () => { try { navigator.mediaDevices?.removeEventListener?.("devicechange", onDeviceChange); } catch {} };
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, []);

    // --- VU meter sampling loop ---
    useEffect(() => {
        let raf = 0;
        const computeLevel = (an: AnalyserNode | null | undefined): number => {
            if (!an) return 0;
            const size = an.fftSize || 1024;
            const buf = new Float32Array(size);
            try {
                an.getFloatTimeDomainData(buf);
            } catch {
                return 0;
            }
            let sumSq = 0;
            let peak = 0;
            for (let i = 0; i < buf.length; i++) {
                const v = buf[i];
                sumSq += v * v;
                const a = v < 0 ? -v : v;
                if (a > peak) peak = a;
            }
            const rms = Math.sqrt(sumSq / (buf.length || 1));
            // Map to 0..1 with ~60 dB dynamic window; mix RMS and peak for responsiveness
            const db = 20 * Math.log10(rms + 1e-8);
            let norm = (db + 60) / 60;
            if (norm < 0) norm = 0;
            if (norm > 1) norm = 1;
            const mixed = Math.max(norm * 0.7 + peak * 0.3, 0);
            return mixed > 1 ? 1 : mixed;
        };
        const tick = () => {
            const a1 = nodesRef.current["track_1"]?.analyser;
            const a2 = nodesRef.current["track_2"]?.analyser;
            const am = masterAnalyserRef.current;
			const ami = micAnalyserRef.current;
			const l1 = computeLevel(a1);
			const l2 = computeLevel(a2);
			const lm = computeLevel(am);
			const lmi = computeLevel(ami);
            setVuLevels(prev => {
				const n = { ...prev, track_1: l1, track_2: l2, mic: lmi };
				return (prev.track_1 !== n.track_1 || prev.track_2 !== n.track_2 || prev.mic !== n.mic) ? n : prev;
            });
            setMasterVu(prev => (Math.abs(prev - lm) > 0.01 ? lm : prev));
            raf = requestAnimationFrame(tick);
        };
        raf = requestAnimationFrame(tick);
        return () => cancelAnimationFrame(raf);
    }, []);

    // Keyboard shortcut handler: ESC to hide controller. Backspace was
    // intentionally removed because it would close the UI mid-typing in any
    // input field (search, etc.).
    useEffect(() => {
        const handleKeyDown = (e: KeyboardEvent) => {
            if (
                (e.key === "Escape" || e.key === "Esc")
                && visible
            ) {
                setVisible(false);
                fetchNui("setVisible", { visible: false }).then(() => {
                    e.preventDefault();
                });
            }
        };
        window.addEventListener("keydown", handleKeyDown);
        return () => {
            window.removeEventListener("keydown", handleKeyDown);
        };
    }, [visible]);

    return (decks.track_1 && decks.track_2 && visible) ? (
        <div className="bg-background p-4 rounded-md absolute bottom-[20px] left-[50%] translate-x-[-50%]" style={{ display: "flex", flexDirection: "column", width: "1280px" }}>
            {/* Local styles for vinyl visuals and controls */}
            <style>
                {`
                @keyframes spin {
                    0% { transform: rotate(0deg); }
                    100% { transform: rotate(360deg); }
                }
                .deck {
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    gap: 8px;
                    flex: 1;
                    min-width: 0;
                }
                .vinyl {
                    width: 180px;
                    height: 180px;
                    border-radius: 50%;
                    background: radial-gradient(circle at 50% 50%, #333 0%, #111 40%, #000 70%);
                    box-shadow: inset 0 0 0 3px #222, inset 0 0 0 6px #111;
                    position: relative;
                    cursor: pointer;
                    transition: transform 120ms ease, box-shadow 200ms ease;
                }
                .vinyl::after {
                    content: "";
                    position: absolute;
                    top: 50%;
                    left: 50%;
                    transform: translate(-50%, -50%);
                    width: 48px;
                    height: 48px;
                    border-radius: 50%;
                    background: #e23d3d; /* label */
                    box-shadow: inset 0 0 0 4px rgba(0,0,0,0.25);
                }
                .spinning {
                    animation: spin 3.5s linear infinite;
                }
                /* Wobble effect */
                @keyframes wobble {
                    0% { transform: translate(-50%, -50%) scaleX(1.000) scaleY(1.000); }
                    50% { transform: translate(-50%, -50%) scaleX(0.992) scaleY(1.008); }
                    100% { transform: translate(-50%, -50%) scaleX(1.000) scaleY(1.000); }
                }
                .wobbleMask {
                    position: absolute;
                    top: 50%;
                    left: 50%;
                    width: 100%;
                    height: 100%;
                    border-radius: 50%;
                    pointer-events: none;
                    /* Subtle moving highlight that becomes perceptible with wobble */
                    background: radial-gradient(ellipse at 62% 38%, rgba(255,255,255,0.06) 0%, rgba(255,255,255,0.0) 35%),
                                radial-gradient(ellipse at 30% 70%, rgba(255,255,255,0.035) 0%, rgba(255,255,255,0.0) 35%);
                    transform: translate(-50%, -50%);
                    animation: wobble 1200ms ease-in-out infinite;
                }
                .vinyl:hover {
                    box-shadow: inset 0 0 0 3px #222, inset 0 0 0 6px #111, 0 8px 20px rgba(0,0,0,0.35);
                }
                .vinyl:active {
                    transform: scale(0.98);
                }
                .vinylOverlay {
                    position: absolute;
                    top: 50%;
                    left: 50%;
                    width: 64px;
                    height: 64px;
                    transform: translate(-50%, -50%) scale(0.92);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    border-radius: 50%;
                    background: rgba(0,0,0,0.45);
                    box-shadow: 0 6px 18px rgba(0,0,0,0.35), inset 0 0 0 1px rgba(255,255,255,0.08);
                    backdrop-filter: blur(2px);
                    color: white;
                    opacity: 0.85;
                    transition: opacity 140ms ease, transform 140ms ease, background 200ms ease;
                    pointer-events: none;
                }
                .vinyl:hover .vinylOverlay {
                    opacity: 1;
                    transform: translate(-50%, -50%) scale(1);
                    background: rgba(0,0,0,0.55);
                }
                @keyframes pulseGlow {
                    0% { box-shadow: 0 0 0 rgba(226,61,61,0.0), inset 0 0 0 1px rgba(255,255,255,0.08); }
                    50% { box-shadow: 0 0 28px rgba(226,61,61,0.35), inset 0 0 0 1px rgba(255,255,255,0.1); }
                    100% { box-shadow: 0 0 0 rgba(226,61,61,0.0), inset 0 0 0 1px rgba(255,255,255,0.08); }
                }
                .playing .vinylOverlay {
                    animation: pulseGlow 1600ms ease-in-out infinite;
                }
                .controls {
                    display: flex;
                    gap: 8px;
                    align-items: center;
                }
                .resetBtn {
                    width: 30px;
                    height: 30px;
                    min-width: 30px;
                    min-height: 30px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    border: 1px solid #555;
                    border-radius: 4px;
                    background: #1e1e1e;
                    color: #ddd;
                    cursor: pointer;
                    transition: background 120ms ease, transform 80ms ease;
                }
                .resetBtn:hover {
                    background: #262626;
                }
                .resetBtn:active {
                    transform: translateY(1px);
                }
                .mixerRow {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                }
                .range {
                    width: 280px;
                }
                .deckRow {
                    display: flex;
                    gap: 16px;
                    width: 100%;
                    align-items: flex-start;
                }
                .playlistCol {
                    width: 232px;
                    display: flex;
                    flex-direction: column;
                    gap: 8px;
                    overflow-y: scroll;
                }
                .controlsCol {
                    flex: 1;
                    display: flex;
                    flex-direction: column;
                    gap: 8px;
                    align-items: center;
                }
                /* Vertical slider helpers */
                .vGroup {
                    width: 37px;
                    height: 100%;
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    gap: 6px;
                }
                .vRange {
                    -webkit-appearance: slider-vertical; /* Chrome/Edge/Safari */
                    appearance: auto;
                    writing-mode: bt-lr; /* Firefox */
                    width: 100%; /* thickness; keep in sync with thumb width for look */
                    height: 12px; /* fill the group */
                    transform: rotate(90deg);
                    flex: 1; /* take remaining vertical space between label and bottom info */
                    transform: rotate(-90deg);
                }
                /* Custom range styling with image thumb */
                .range {
                    -webkit-appearance: none;
                    appearance: none;
                    background: transparent;
                    outline: none;
                }
                /* WebKit track */
                .range::-webkit-slider-runnable-track {
                    height: 6px;
                    background: linear-gradient(180deg, #2a2a2a, #1a1a1a);
                    border-radius: 999px;
                    box-shadow: inset 0 0 0 1px rgba(255,255,255,0.06), 0 1px 2px rgba(0,0,0,0.4);
                }
                /* Firefox track */
                .range::-moz-range-track {
                    height: 6px;
                    background: linear-gradient(180deg, #2a2a2a, #1a1a1a);
                    border-radius: 999px;
                    box-shadow: inset 0 0 0 1px rgba(255,255,255,0.06), 0 1px 2px rgba(0,0,0,0.4);
                }
                /* IE/Edge (legacy) track */
                .range::-ms-track {
                    height: 6px;
                    background: transparent;
                    border-color: transparent;
                    color: transparent;
                }
                .range::-ms-fill-lower,
                .range::-ms-fill-upper {
                    background: linear-gradient(180deg, #2a2a2a, #1a1a1a);
                    border-radius: 999px;
                    box-shadow: inset 0 0 0 1px rgba(255,255,255,0.06), 0 1px 2px rgba(0,0,0,0.4);
                }
                /* WebKit thumb */
                .range::-webkit-slider-thumb {
                    -webkit-appearance: none;
                    appearance: none;
                    width: 12px;
                    height: 28px;
                    border: none;
                    background: url('/nui/images/slider.png') no-repeat center center / contain;
                    transform: rotate(90deg);
                    cursor: pointer;
                    margin-top: -11px; /* centers thumb on 6px track */
                    box-shadow: 0 2px 6px rgba(0,0,0,0.5);
                }
                /* Firefox thumb */
                .range::-moz-range-thumb {
                    width: 28px;
                    height: 28px;
                    border: none;
                    border-radius: 4px;
                    background: url('/nui/images/slider.png') no-repeat center center / contain;
                    cursor: pointer;
                    box-shadow: 0 2px 6px rgba(0,0,0,0.5);
                }
                /* IE/Edge (legacy) thumb */
                .range::-ms-thumb {
                    width: 28px;
                    height: 28px;
                    border: none;
                    border-radius: 4px;
                    background: url('/nui/images/slider.png') no-repeat center center / contain;
                    cursor: pointer;
                    box-shadow: 0 2px 6px rgba(0,0,0,0.5);
                }
                /* Focus styles */
                .range:focus-visible {
                    outline: none;
                }
                .range:focus::-webkit-slider-runnable-track {
                    box-shadow: inset 0 0 0 1px rgba(255,255,255,0.12), 0 0 0 2px rgba(226,61,61,0.25);
                }
                .range:focus::-moz-range-track {
                    box-shadow: inset 0 0 0 1px rgba(255,255,255,0.12), 0 0 0 2px rgba(226,61,61,0.25);
                }
                /* Modal */
                .modalBackdrop {
                    position: fixed;
                    inset: 0;
                    background: rgba(0,0,0,0.55);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    z-index: 9999;
                }
                .modal {
                    width: 520px;
                    max-width: calc(100vw - 32px);
                    max-height: calc(100vh - 48px);
                    background: #0f0f0f;
                    color: #eee;
                    border: 1px solid #333;
                    border-radius: 10px;
                    box-shadow: 0 20px 60px rgba(0,0,0,0.6);
                    padding: 16px;
                    display: flex;
                    flex-direction: column;
                    overflow: hidden;
                }
                .modalHeader {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    margin-bottom: 12px;
                    flex-shrink: 0;
                }
                .modalBody {
                    display: flex;
                    flex-direction: column;
                    gap: 12px;
                    flex: 1 1 auto;
                    min-height: 0;
                    overflow: hidden;
                }
                .modalActions {
                    display: flex;
                    justify-content: flex-end;
                    gap: 8px;
                    margin-top: 8px;
                }
                .fieldRow {
                    display: flex;
                    gap: 8px;
                    align-items: center;
                }
                .radioRow {
                    display: flex;
                    gap: 16px;
                    align-items: center;
                }
                .divider {
                    height: 1px;
                    background: #222;
                    margin: 6px 0;
                    border: none;
                }
                /* Digital VU meter */
                .vu {
                    width: 10px;
                    height: 100%;
                    background: #0b0b0b;
                    border: 1px solid #333;
                    border-radius: 3px;
                    display: flex;
                    flex-direction: column-reverse;
                    padding: 1px;
                    gap: 1px;
                }
                .vuSeg {
                    flex: 1;
                    min-height: 4px;
                    border-radius: 1px;
                    background: #1e1e1e;
                }
                `}
            </style>
            <div style={{ display: "flex", gap: 16 }}>
                {Object.keys({track_1: decks.track_1, controls: decks.controls, track_2: decks.track_2}).map(function(deck) {
                    if (deck === "controls") {
                        return (
                            <div style={{ display: "flex", flexDirection: "column", gap: 8, alignItems: "center", justifyContent: "center"  }}>
                                <div className="mixerRow" style={{ gap: 24, justifyContent: "space-between", width: "100%" }}>
                                    <div className="vGroup h-full">
                                        <RangeControl
                                            orientation="vertical"
                                            barStyle={{
                                                left: "-142px",
                                                width: "265px",
                                            }}
                                            vuMeterStyle={{
                                                top: "6px",
                                                height: "265px",
                                                transform: "none",
                                            }}
                                            min={0}
                                            max={100}
                                            step={1}
                                            value={Math.round(masterVolume * 100)}
                                            onChange={(v) => setMasterVolume(v / 100)}
                                            ariaLabel={locale("ui_master_volume")}
                                            showVu={true}
                                            vuLevel={masterVu}
                                            label={locale("ui_master")}
                                            valueText={`${Math.round(masterVolume * 100)}%`}
                                        />
                                        <button
                                            className="resetBtn"
                                            onClick={() => setMasterVolume(1)}
                                            aria-label={locale("ui_reset_master_volume")}
                                            title={locale("ui_reset_master_volume")}
                                        >
                                            ↺
                                        </button>
                                    </div>
                                    <div style={{ display: "flex", gap: 8, alignItems: "flex-start" }}>
                                        <MasterLightControls stationId={currentStationId} />
                                        <LightControls lightType="ambient" label={locale("ui_ambient")} stationId={currentStationId} />
                                        <LightControls lightType="spotlight" label={locale("ui_spotlight")} stationId={currentStationId} />
                                        <LightControls lightType="barlight" label={locale("ui_bar_light")} stationId={currentStationId} />
                                    </div>
                                    <ParticleEffectsControls stationId={currentStationId} />
                                </div>
                                <div style={{ display: "flex", flexDirection: "row", alignItems: "center", gap: 6, width: "100%", justifyContent: "center", marginTop: 8 }}>
                                    <span style={{ fontSize: 12, color: "#ddd", paddingRight: 8, textAlign: "left" }}>{locale("ui_left")}</span>
                                    <RangeControl
                                        min={0}
                                        max={100}
                                        step={1}
                                        value={Math.round(crossfade * 100)}
                                        onChange={(v) => setCrossfade(v / 100)}
                                        ariaLabel={locale("ui_balance")}
                                        style={{ flex: 1, maxWidth: 400 }}
                                        className="!w-full"
                                    />
                                    <span style={{ fontSize: 12, color: "#ddd", paddingLeft: 8, textAlign: "right" }}>{locale("ui_right")}</span>
                                    <button
                                        className="resetBtn"
                                        onClick={() => setCrossfade(0.5)}
                                        aria-label={locale("ui_reset_balance")}
                                        title={locale("ui_reset_balance")}
                                    >
                                        ↺
                                    </button>
                                </div>
                                <div style={{ display: "flex", flexDirection: "column", gap: 6, width: "100%" }}>
                                    <div style={{ display: "flex", flexDirection: "row", alignItems: "center", gap: 6, width: "100%" }}>
                                    <button
                                        className="resetBtn"
                                        onClick={toggleMic}
                                        aria-label={isMicOn ? locale("ui_turn_off_mic") : locale("ui_turn_on_mic")}
                                        title={isMicOn ? locale("ui_turn_off_mic") : locale("ui_turn_on_mic")}
                                    >
                                        {isMicOn ? 
                                            <Mic className="w-4 h-4 text-green-500" />
                                        :
                                            <MicOff className="w-4 h-4 text-red-500" />
                                        }
                                    </button>
                                        <select
                                        id="micDevice"
                                        value={selectedMicId ?? ""}
                                        onChange={(e) => setSelectedMicId(e.target.value || null)}
                                        style={{ width: "100%", background: "#0f0f0f", color: "#eee", border: "1px solid #333", borderRadius: 6, padding: "4px 6px" }}
                                    >
                                        {micDevices.length === 0 ? (
                                            <option value="">{locale("ui_no_inputs")}</option>
                                        ) : (
                                            micDevices.map((d, idx) => (
                                                <option key={d.deviceId || idx} value={d.deviceId}>
                                                    {d.label || locale("ui_microphone", idx + 1)}
                                                </option>
                                            ))
                                        )}
                                    </select>
                                    </div>
                                    <HorizontalVu level={vuLevels.mic} />
                                </div>
                                <button
                                    onClick={stopBroadcastAndClose}
                                    style={{
                                        background: "#dc2626",
                                        color: "white",
                                        border: "none",
                                        borderRadius: "6px",
                                        padding: "8px 16px",
                                        cursor: "pointer",
                                        display: "flex",
                                        alignItems: "center",
                                        gap: "6px",
                                        fontSize: "14px",
                                        fontWeight: "500",
                                        transition: "background 0.2s",
                                        width: "100%",
                                        justifyContent: "center",
                                    }}
                                    onMouseEnter={(e) => e.currentTarget.style.background = "#b91c1c"}
                                    onMouseLeave={(e) => e.currentTarget.style.background = "#dc2626"}
                                    title={locale("ui_stop_broadcasting_title")}
                                >
                                    <Square className="w-4 h-4" />
                                    {locale("ui_stop_broadcasting")}
                                </button>
                            </div>
                        )
                    } else {
                        const playlistCol = (
                            <div className="playlistCol bg-secondary h-full">
                                <div style={{ display: "flex", flexDirection: "column", gap: 6, width: "100%", alignItems: "stretch" }}>
                                    <div
                                        className="cursor-pointer hover:bg-primary/10 transition-colors duration-200 px-4"
                                        style={{ display: "flex", alignItems: "center", justifyContent: "space-between", gap: 8, width: "100%", paddingTop: 8, paddingBottom: 8, borderBottom: "1px solid #222" }}
                                        onClick={(e) => { e.stopPropagation(); setAddDialogDeck(deck as "track_1" | "track_2"); addDialogSessionRef.current += 1; setIsAddDialogOpen(true); }}
                                    >
                                        <div style={{ display: "flex", alignItems: "center", gap: 8, minWidth: 0 }}>
                                            <div className="text-sm" style={{ display: "flex", alignItems: "center", gap: 8, whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis", maxWidth: 220 }}>
                                                <Plus className="w-4 h-4" />
                                                {locale("ui_add_song_to_playlist")}
                                            </div>
                                        </div>
                                    </div>
                                    {(decks[deck].playlist ?? []).map(item => (
                                        <div className="cursor-pointer hover:bg-primary/10 transition-colors duration-200 px-4" key={item.id} onClick={() => loadPlaylistItem(deck, item.id)} style={{ display: "flex", alignItems: "center", justifyContent: "space-between", gap: 8, width: "100%" }}>
                                            <div style={{ display: "flex", alignItems: "center", gap: 8, minWidth: 0 }}>
                                                <div style={{ minWidth: 6, width: 6, minHeight: 6, height: 6, borderRadius: 999, background: decks[deck].currentItemId === item.id ? "#60d394" : "#555" }} />
                                                <div className="text-xs" style={{ whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis", maxWidth: 220 }}>{item.title}</div>
                                                {typeof item.baseBpm === "number" ? (
                                                    <span style={{ opacity: 0.7, fontSize: 12, whiteSpace: "nowrap" }}>• {item.baseBpm.toFixed(0)} BPM</span>
                                                ) : (null)}
                                            </div>
                                            <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
                                                <button
                                                    className="text-xs hover:text-red-500"
                                                    onClick={(e) => { e.stopPropagation(); removePlaylistItem(deck, item.id); }}
                                                    title={locale("ui_remove")}
                                                >
                                                    ✕
                                                </button>
                                            </div>
                                        </div>
                                    ))}
                                </div>
                            </div>
                        );
                        return (
                            <div className="deck" key={deck}>
                                <div className="deckRow">
                                    <div className="controlsCol">
                                        <div
                                            className={`vinyl ${decks[deck].isPlaying ? "spinning playing" : ""}`}
                                            onClick={() => toggleDeck(deck)}
                                            onKeyDown={(e) => {
                                                if (e.key === "Enter" || e.key === " ") {
                                                    e.preventDefault();
                                                    toggleDeck(deck);
                                                }
                                            }}
                                            role="button"
                                            aria-label={decks[deck].isPlaying ? locale("ui_pause_deck") : locale("ui_play_deck")}
                                            tabIndex={0}
                                        >
                                            <div className="wobbleMask" />
                                            <div className="vinylOverlay" style={{ zIndex: 10 }}>
                                                {decks[deck].isPlaying ? (
                                                    <svg width="28" height="28" viewBox="0 0 24 24" aria-hidden="true">
                                                        <rect x="5" y="4" width="5" height="16" rx="1" fill="currentColor"></rect>
                                                        <rect x="14" y="4" width="5" height="16" rx="1" fill="currentColor"></rect>
                                                    </svg>
                                                ) : (
                                                    <svg width="28" height="28" viewBox="0 0 24 24" aria-hidden="true">
                                                        <path d="M8 5v14l11-7z" fill="currentColor"></path>
                                                    </svg>
                                                )}
                                            </div>
                                        </div>
                                        <div className="controls">
                                            <span>{locale("ui_now_playing")}</span>
                                            <strong style={{ maxWidth: 220, whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>
                                                {decks[deck].playlist?.find(x => x.id === decks[deck].currentItemId)?.title || "—"}
                                            </strong>
                                        </div>
                                        <div className="controls" style={{ width: "100%", justifyContent: "center" }}>
                                            <span>{formatTime(decks[deck].currentTime)}</span>
                                            <RangeControl
                                                min={0}
                                                max={Math.max(0, decks[deck].duration || 0)}
                                                step={0.01}
                                                value={Math.min(decks[deck].currentTime || 0, decks[deck].duration || 0)}
                                                onChange={(to) => {
                                                    const curr = decks[deck];
                                                    curr.audio.currentTime = to;
                                                    setDecks(prev => ({ ...prev, [deck]: { ...prev[deck], currentTime: to } }));
                                                }}
                                                ariaLabel={`${deck} position`}
                                                disabled={!decks[deck].duration || decks[deck].duration === 0}
                                            />
                                            <span>{formatTime(decks[deck].duration)}</span>
                                        </div>
                                        {/* (YouTube container removed) */}
                                        <div className="controls h-[254px]" style={{ width: "100%", justifyContent: "center", gap: 24 }}>
                                            {deck === "track_2" && playlistCol}
                                            <div className="vGroup">
                                                <RangeControl
                                                    barStyle={{
                                                        left: "-79.5px",
                                                        width: "160px",
                                                    }}
                                                    orientation="vertical"
                                                    min={50}
                                                    max={150}
                                                    step={1}
                                                    value={Math.round(decks[deck].tempo * 100)}
                                                    onChange={(v) => {
                                                        const nextTempo = v / 100;
                                                        setDecks(prev => ({ ...prev, [deck]: { ...prev[deck], tempo: nextTempo } }));
                                                    }}
                                                    ariaLabel={`${deck} tempo`}
													label={locale("ui_tempo")}
													valueText={decks[deck].baseBpm ? `${Math.round(decks[deck].baseBpm * decks[deck].tempo)} BPM` : "—"}
                                                />
                                                <button
                                                    className="resetBtn"
                                                    onClick={() => setDecks(prev => ({ ...prev, [deck]: { ...prev[deck], tempo: 1 } }))}
                                                    aria-label={`${deck} reset tempo`}
                                                    title={locale("ui_reset_tempo")}
                                                >
                                                    ↺
                                                </button>
                                            </div>
                                            <div className="vGroup">
                                                <RangeControl
                                                    orientation="vertical"
                                                    barStyle={{
                                                        left: "-86px",
                                                        width: "160px",
                                                    }}
                                                    vuMeterStyle={{
                                                        height: "162px",
                                                    }}
                                                    min={0}
                                                    max={100}
                                                    step={1}
                                                    value={Math.round((decks[deck].deckVolume ?? 1) * 100)}
                                                    onChange={(raw) => {
                                                        const v = raw / 100;
                                                        setDecks(prev => ({ ...prev, [deck]: { ...prev[deck], deckVolume: v } }));
                                                    }}
                                                    ariaLabel={`${deck} volume`}
                                                    showVu={true}
                                                    vuLevel={vuLevels[deck] ?? 0}
													label={locale("ui_volume")}
													valueText={`${Math.round((decks[deck].deckVolume ?? 1) * 100)}%`}
                                                />
                                                <button
                                                    className="resetBtn"
                                                    onClick={() => setDecks(prev => ({ ...prev, [deck]: { ...prev[deck], deckVolume: 1 } }))}
                                                    aria-label={`${deck} reset volume`}
                                                    title={locale("ui_reset_volume")}
                                                >
                                                    ↺
                                                </button>
                                            </div>
                                            {deck === "track_1" && playlistCol}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        );
                    }
                })}
            </div>
            {isAddDialogOpen && (
                <div className="modalBackdrop" role="dialog" aria-modal="true" aria-labelledby="add-song-title">
                    <div className="modal">
                        <div className="modalHeader">
                            <h3 id="add-song-title" style={{ margin: 0, fontSize: 16 }}>{locale("ui_add_song_to_playlist")}</h3>
                            <button className="resetBtn" onClick={() => setIsAddDialogOpen(false)} aria-label={locale("ui_close_add_song_dialog")}>✕</button>
                        </div>
                        <div className="modalBody">
                            {pendingPastedFiles && pendingPastedFiles.length > 0 ? (
                                <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
                                    <div style={{ fontWeight: 600, fontSize: 14 }}>
                                        {locale("ui_paste_choice_title")}
                                    </div>
                                    <div style={{ fontSize: 12, opacity: 0.8 }}>
                                        {pendingPastedFiles.length === 1
                                            ? pendingPastedFiles[0].name
                                            : `${pendingPastedFiles.length} ${locale("ui_paste_choice_count_suffix")}`}
                                    </div>
                                    {!libraryStatusChecked ? (
                                        <div style={{ fontSize: 12, opacity: 0.7, padding: "16px 4px", textAlign: "center" }}>
                                            {locale("ui_paste_choice_checking")}
                                        </div>
                                    ) : libraryAvailable && libraryUploadEnabled ? (
                                        <>
                                            <button
                                                type="button"
                                                onClick={() => handlePasteChoice("both")}
                                                style={{ padding: "10px 12px", borderRadius: 6, border: "1px solid #4a9eff", background: "rgba(74,158,255,0.10)", color: "#cfe2ff", cursor: "pointer", textAlign: "left" }}
                                            >
                                                <div style={{ fontWeight: 700, fontSize: 13 }}>{locale("ui_paste_choice_both")}</div>
                                                <div style={{ fontSize: 11, opacity: 0.75, marginTop: 2 }}>{locale("ui_paste_choice_both_desc")}</div>
                                            </button>
                                            <button
                                                type="button"
                                                onClick={() => handlePasteChoice("library")}
                                                style={{ padding: "10px 12px", borderRadius: 6, border: "1px solid #444", background: "#1c1c1c", color: "inherit", cursor: "pointer", textAlign: "left" }}
                                            >
                                                <div style={{ fontWeight: 600, fontSize: 13 }}>{locale("ui_paste_choice_library")}</div>
                                                <div style={{ fontSize: 11, opacity: 0.6, marginTop: 2 }}>{locale("ui_paste_choice_library_desc")}</div>
                                            </button>
                                            <button
                                                type="button"
                                                onClick={() => handlePasteChoice("playlist")}
                                                style={{ padding: "10px 12px", borderRadius: 6, border: "1px solid #444", background: "#1c1c1c", color: "inherit", cursor: "pointer", textAlign: "left" }}
                                            >
                                                <div style={{ fontWeight: 600, fontSize: 13 }}>{locale("ui_paste_choice_playlist")}</div>
                                                <div style={{ fontSize: 11, opacity: 0.6, marginTop: 2 }}>{locale("ui_paste_choice_playlist_desc")}</div>
                                            </button>
                                        </>
                                    ) : (
                                        <>
                                            <button
                                                type="button"
                                                onClick={() => handlePasteChoice("playlist")}
                                                style={{ padding: "10px 12px", borderRadius: 6, border: "1px solid #4a9eff", background: "rgba(74,158,255,0.10)", color: "#cfe2ff", cursor: "pointer", textAlign: "left" }}
                                            >
                                                <div style={{ fontWeight: 700, fontSize: 13 }}>{locale("ui_paste_choice_playlist")}</div>
                                                <div style={{ fontSize: 11, opacity: 0.75, marginTop: 2 }}>{locale("ui_paste_choice_playlist_desc")}</div>
                                            </button>
                                            <div style={{ fontSize: 11, opacity: 0.55, padding: "6px 4px 0", lineHeight: 1.4 }}>
                                                {locale("ui_paste_choice_library_unavailable")}
                                            </div>
                                        </>
                                    )}
                                    <button
                                        type="button"
                                        onClick={() => setPendingPastedFiles(null)}
                                        style={{ padding: "8px 12px", borderRadius: 6, border: "1px solid #333", background: "transparent", color: "#bbb", cursor: "pointer", textAlign: "center", marginTop: 4, fontSize: 12 }}
                                    >
                                        {locale("ui_paste_choice_cancel") || "Cancel"}
                                    </button>
                                </div>
                            ) : (
                            <>
                            <div className="radioRow" role="group" aria-label={locale("ui_choose_target_deck")}>
                                <label style={{ display: "flex", alignItems: "center", gap: 6 }}>
                                    <input
                                        type="radio"
                                        name="deckPick"
                                        checked={addDialogDeck === "track_1"}
                                        onChange={() => setAddDialogDeck("track_1")}
                                    />
                                    <span>{locale("ui_left_deck")}</span>
                                </label>
                                <label style={{ display: "flex", alignItems: "center", gap: 6 }}>
                                    <input
                                        type="radio"
                                        name="deckPick"
                                        checked={addDialogDeck === "track_2"}
                                        onChange={() => setAddDialogDeck("track_2")}
                                    />
                                    <span>{locale("ui_right_deck")}</span>
                                </label>
                            </div>
                            <hr className="divider" />
							<div>
								<div style={{ marginBottom: 4, opacity: 0.8 }}>{locale("ui_upload_files")}</div>
								<div style={{ marginBottom: 6, opacity: 0.7, fontSize: 11 }}>{locale("ui_click_then_paste_hint")}</div>
								<button
									type="button"
									ref={playlistUploadRef}
									onClick={() => playlistUploadRef.current?.focus()}
									onFocus={() => setPlaylistUploadFocused(true)}
									onBlur={() => setPlaylistUploadFocused(false)}
									aria-label={playlistUploadFocused ? locale("ui_click_then_paste_focused") : locale("ui_click_then_paste")}
									className="pasteTarget"
									style={{
										display: "block",
										width: "100%",
										border: `1px ${playlistUploadFocused ? "solid" : "dashed"} ${playlistUploadFocused ? "#4a9eff" : "#444"}`,
										background: playlistUploadFocused ? "rgba(74,158,255,0.08)" : "transparent",
										color: playlistUploadFocused ? "#cfe2ff" : "inherit",
										borderRadius: 6,
										padding: 14,
										textAlign: "center",
										fontSize: 12,
										fontWeight: playlistUploadFocused ? 600 : 400,
										letterSpacing: playlistUploadFocused ? "0.06em" : "normal",
										opacity: 0.95,
										cursor: "pointer",
										transition: "all 160ms ease",
									}}
								>
									{playlistUploadFocused ? locale("ui_click_then_paste_focused") : locale("ui_click_then_paste")}
								</button>
							</div>
                            {libraryAvailable && (() => {
                                const q = librarySearch.trim().toLowerCase();
                                const filtered = libraryItems
                                    .filter(item => !q || item.title.toLowerCase().includes(q))
                                    .sort((a, b) => {
                                        if (librarySort === "az") return a.title.localeCompare(b.title);
                                        if (librarySort === "size") return (b.file_size || 0) - (a.file_size || 0);
                                        // newest first via created_at, fallback to id desc
                                        const at = a.created_at ? new Date(a.created_at).getTime() : a.id;
                                        const bt = b.created_at ? new Date(b.created_at).getTime() : b.id;
                                        return bt - at;
                                    });
                                const formatBytes = (n?: number) => {
                                    if (!n || n <= 0) return "";
                                    if (n < 1024) return `${n} B`;
                                    if (n < 1024 * 1024) return `${(n / 1024).toFixed(1)} KB`;
                                    return `${(n / 1024 / 1024).toFixed(1)} MB`;
                                };
                                const formatDate = (s?: string) => {
                                    if (!s) return "";
                                    try {
                                        const d = new Date(s);
                                        const now = Date.now();
                                        const diff = now - d.getTime();
                                        const day = 86400000;
                                        if (diff < day) return locale("ui_library_today") || "Today";
                                        if (diff < 2 * day) return locale("ui_library_yesterday") || "Yesterday";
                                        if (diff < 7 * day) return `${Math.floor(diff / day)}d ago`;
                                        return d.toLocaleDateString();
                                    } catch { return ""; }
                                };
                                return (
                                <>
                                    <hr className="divider" style={{ flexShrink: 0 }} />
                                    <div style={{ display: "flex", flexDirection: "column", gap: 8, flex: "1 1 auto", minHeight: 0 }}>
                                        {/* Header row: title + count + refresh */}
                                        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
                                            <div style={{ display: "flex", alignItems: "baseline", gap: 8 }}>
                                                <div style={{ fontWeight: 600, fontSize: 13 }}>{locale("ui_my_library")}</div>
                                                <div style={{ opacity: 0.5, fontSize: 11 }}>
                                                    {libraryLoading
                                                        ? "…"
                                                        : `${filtered.length}${q || librarySort !== "newest" ? " / " + libraryItems.length : ""}`}
                                                </div>
                                            </div>
                                            <button
                                                type="button"
                                                onClick={() => refreshLibrary()}
                                                disabled={libraryLoading}
                                                title={locale("ui_refresh") || "Refresh"}
                                                style={{
                                                    background: "transparent",
                                                    border: "1px solid #333",
                                                    color: libraryLoading ? "#555" : "#bbb",
                                                    borderRadius: 4,
                                                    padding: "3px 8px",
                                                    fontSize: 11,
                                                    cursor: libraryLoading ? "default" : "pointer",
                                                }}
                                            >
                                                {libraryLoading ? "…" : "↻"}
                                            </button>
                                        </div>

                                        {/* Upload affordance */}
                                        {libraryUploadEnabled && (
                                            <button
                                                type="button"
                                                ref={libraryUploadRef}
                                                disabled={libraryUploading}
                                                onClick={() => libraryUploadRef.current?.focus()}
                                                onFocus={() => setLibraryUploadFocused(true)}
                                                onBlur={() => setLibraryUploadFocused(false)}
                                                aria-label={libraryUploadFocused ? locale("ui_click_then_paste_focused") : locale("ui_click_then_paste")}
                                                className="pasteTarget"
                                                style={{
                                                    display: "block",
                                                    width: "100%",
                                                    border: `1px ${libraryUploadFocused && !libraryUploading ? "solid" : "dashed"} ${libraryUploadFocused && !libraryUploading ? "#4a9eff" : "#3a3a3a"}`,
                                                    background: libraryUploadFocused && !libraryUploading ? "rgba(74,158,255,0.10)" : "rgba(255,255,255,0.02)",
                                                    color: libraryUploadFocused && !libraryUploading ? "#cfe2ff" : "#aaa",
                                                    borderRadius: 6,
                                                    padding: 9,
                                                    textAlign: "center",
                                                    fontSize: 11,
                                                    fontWeight: libraryUploadFocused && !libraryUploading ? 600 : 400,
                                                    letterSpacing: libraryUploadFocused && !libraryUploading ? "0.06em" : "normal",
                                                    opacity: libraryUploading ? 0.5 : 1,
                                                    cursor: libraryUploading ? "default" : "pointer",
                                                    transition: "all 160ms ease",
                                                }}
                                            >
                                                {libraryUploading
                                                    ? locale("ui_uploading")
                                                    : (libraryUploadFocused
                                                        ? locale("ui_click_then_paste_focused")
                                                        : locale("ui_click_then_paste"))}
                                            </button>
                                        )}

                                        {libraryError && (
                                            <div style={{ color: "#f87171", fontSize: 12, padding: "4px 6px", background: "rgba(248,113,113,0.08)", border: "1px solid rgba(248,113,113,0.25)", borderRadius: 4 }}>{libraryError}</div>
                                        )}

                                        {/* Search + sort */}
                                        {libraryItems.length > 0 && (
                                            <div style={{ display: "flex", gap: 6, alignItems: "center" }}>
                                                <div style={{ position: "relative", flex: 1, minWidth: 0 }}>
                                                    <span aria-hidden="true" style={{ position: "absolute", left: 8, top: "50%", transform: "translateY(-50%)", color: "#666", fontSize: 12, pointerEvents: "none" }}>⌕</span>
                                                    <input
                                                        type="text"
                                                        value={librarySearch}
                                                        onChange={(e) => setLibrarySearch(e.target.value)}
                                                        placeholder={locale("ui_library_search_placeholder") || "Search library…"}
                                                        style={{
                                                            width: "100%",
                                                            background: "#0f0f0f",
                                                            border: "1px solid #2a2a2a",
                                                            borderRadius: 4,
                                                            padding: "6px 28px 6px 24px",
                                                            fontSize: 12,
                                                            color: "#eee",
                                                            outline: "none",
                                                            boxSizing: "border-box",
                                                        }}
                                                    />
                                                    {librarySearch && (
                                                        <button
                                                            type="button"
                                                            onClick={() => setLibrarySearch("")}
                                                            aria-label="Clear search"
                                                            style={{
                                                                position: "absolute",
                                                                right: 6,
                                                                top: "50%",
                                                                transform: "translateY(-50%)",
                                                                background: "transparent",
                                                                border: "none",
                                                                color: "#888",
                                                                cursor: "pointer",
                                                                fontSize: 12,
                                                                padding: 2,
                                                                lineHeight: 1,
                                                            }}
                                                        >
                                                            ✕
                                                        </button>
                                                    )}
                                                </div>
                                                <select
                                                    value={librarySort}
                                                    onChange={(e) => setLibrarySort(e.target.value as "newest" | "az" | "size")}
                                                    title={locale("ui_library_sort") || "Sort"}
                                                    style={{
                                                        background: "#0f0f0f",
                                                        border: "1px solid #2a2a2a",
                                                        borderRadius: 4,
                                                        padding: "6px 8px",
                                                        fontSize: 11,
                                                        color: "#ddd",
                                                        cursor: "pointer",
                                                        outline: "none",
                                                    }}
                                                >
                                                    <option value="newest">{locale("ui_library_sort_newest") || "Newest"}</option>
                                                    <option value="az">{locale("ui_library_sort_az") || "A → Z"}</option>
                                                    <option value="size">{locale("ui_library_sort_size") || "Size"}</option>
                                                </select>
                                            </div>
                                        )}

                                        {/* List */}
                                        <div
                                            className="libraryList"
                                            style={{
                                                flex: "1 1 0",
                                                minHeight: 120,
                                                maxHeight: 320,
                                                overflowY: "auto",
                                                overflowX: "hidden",
                                                overscrollBehavior: "contain",
                                                border: "1px solid #1f1f1f",
                                                borderRadius: 6,
                                                background: "rgba(0,0,0,0.2)",
                                            }}
                                        >
                                            {libraryLoading && libraryItems.length === 0 ? (
                                                <div style={{ padding: 24, textAlign: "center", color: "#666", fontSize: 12 }}>{locale("ui_loading") || "Loading…"}</div>
                                            ) : libraryItems.length === 0 ? (
                                                <div style={{ padding: 28, textAlign: "center", color: "#666" }}>
                                                    <div style={{ fontSize: 28, marginBottom: 6, opacity: 0.4 }}>♪</div>
                                                    <div style={{ fontSize: 12 }}>{locale("ui_library_empty")}</div>
                                                </div>
                                            ) : filtered.length === 0 ? (
                                                <div style={{ padding: 24, textAlign: "center", color: "#666", fontSize: 12 }}>
                                                    {locale("ui_library_no_results") || "No matches"}
                                                </div>
                                            ) : (
                                                filtered.map((item, idx) => {
                                                    const pendingDelete = libraryItemPendingDelete === item.id;
                                                    const meta = [formatBytes(item.file_size), formatDate(item.created_at)].filter(Boolean).join(" · ");
                                                    return (
                                                        <div
                                                            key={item.id}
                                                            className="libraryRow"
                                                            style={{
                                                                display: "flex",
                                                                alignItems: "center",
                                                                gap: 10,
                                                                padding: "8px 10px",
                                                                borderBottom: idx === filtered.length - 1 ? "none" : "1px solid #181818",
                                                                transition: "background 120ms ease",
                                                            }}
                                                        >
                                                            <span aria-hidden="true" style={{ color: "#4a9eff", fontSize: 14, opacity: 0.6, width: 14, textAlign: "center", flexShrink: 0 }}>♪</span>
                                                            <div style={{ flex: 1, minWidth: 0 }}>
                                                                <div title={item.title} style={{ overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap", fontSize: 13, color: "#e8e8e8" }}>
                                                                    {item.title}
                                                                </div>
                                                                {meta && (
                                                                    <div style={{ fontSize: 10, color: "#666", marginTop: 2 }}>{meta}</div>
                                                                )}
                                                            </div>
                                                            {pendingDelete ? (
                                                                <>
                                                                    <button
                                                                        type="button"
                                                                        onClick={() => { deleteLibraryItem(item.id); setLibraryItemPendingDelete(null); }}
                                                                        style={{ background: "#dc2626", color: "white", border: "none", borderRadius: 4, padding: "4px 8px", fontSize: 11, cursor: "pointer", fontWeight: 600 }}
                                                                    >
                                                                        {locale("ui_confirm") || "Confirm"}
                                                                    </button>
                                                                    <button
                                                                        type="button"
                                                                        onClick={() => setLibraryItemPendingDelete(null)}
                                                                        style={{ background: "transparent", color: "#aaa", border: "1px solid #333", borderRadius: 4, padding: "4px 8px", fontSize: 11, cursor: "pointer" }}
                                                                    >
                                                                        {locale("ui_cancel") || "Cancel"}
                                                                    </button>
                                                                </>
                                                            ) : (
                                                                <>
                                                                    <button
                                                                        type="button"
                                                                        onClick={() => addLibraryItemToPlaylist(addDialogDeck, item)}
                                                                        title={locale("ui_add_to_deck")}
                                                                        style={{ background: "#1d4ed8", color: "white", border: "none", borderRadius: 4, padding: "4px 10px", fontSize: 11, cursor: "pointer", fontWeight: 600, whiteSpace: "nowrap" }}
                                                                    >
                                                                        {locale("ui_add_to_deck")}
                                                                    </button>
                                                                    <button
                                                                        type="button"
                                                                        onClick={() => setLibraryItemPendingDelete(item.id)}
                                                                        aria-label={locale("ui_delete")}
                                                                        title={locale("ui_delete")}
                                                                        style={{ background: "transparent", color: "#888", border: "none", borderRadius: 4, padding: "4px 6px", fontSize: 13, cursor: "pointer", lineHeight: 1 }}
                                                                    >
                                                                        🗑
                                                                    </button>
                                                                </>
                                                            )}
                                                        </div>
                                                    );
                                                })
                                            )}
                                        </div>
                                    </div>
                                </>
                                );
                            })()}
                            {!libraryAvailable && (
                                <>
                                    <hr className="divider" />
                                    <div style={{ opacity: 0.6, fontSize: 12 }}>{locale("ui_library_unavailable")}</div>
                                </>
                            )}
                            </>
                            )}
                        </div>
                    </div>
                </div>
            )}
            {isStopBroadcastDialogOpen && (
                <div 
                    className="modalBackdrop" 
                    role="dialog" 
                    aria-modal="true" 
                    aria-labelledby="stop-broadcast-title"
                    onClick={(e) => {
                        if (e.target === e.currentTarget) {
                            setIsStopBroadcastDialogOpen(false);
                        }
                    }}
                >
                    <div className="modal" onClick={(e) => e.stopPropagation()}>
                        <div className="modalHeader">
                            <h3 id="stop-broadcast-title" style={{ margin: 0, fontSize: 16 }}>{locale("ui_stop_broadcasting_question")}</h3>
                            <button 
                                className="resetBtn" 
                                onClick={() => setIsStopBroadcastDialogOpen(false)} 
                                aria-label={locale("ui_close_confirmation_dialog")}
                            >
                                ✕
                            </button>
                        </div>
                        <div className="modalBody">
                            <div style={{ display: "flex", flexDirection: "column", gap: 12 }}>
                                <p style={{ margin: 0, fontSize: 14, color: "#ccc", lineHeight: 1.6 }}>
                                    {locale("ui_stop_broadcast_confirm")}
                                </p>
                                <p style={{ margin: 0, fontSize: 13, color: "#999", lineHeight: 1.5 }}>
                                    {locale("ui_this_will")}
                                </p>
                                <ul style={{ margin: 0, paddingLeft: 20, fontSize: 13, color: "#999", lineHeight: 1.8 }}>
                                    <li>{locale("ui_stop_the_broadcast")}</li>
                                    <li>{locale("ui_clear_all_playlists")}</li>
                                    <li>{locale("ui_reset_all_settings")}</li>
                                    <li>{locale("ui_close_the_controller")}</li>
                                </ul>
                                <p style={{ margin: 0, fontSize: 13, color: "#888", lineHeight: 1.5, fontStyle: "italic" }}>
                                    {locale("ui_tip_esc")}
                                </p>
                            </div>
                        </div>
                        <div className="modalActions">
                            <button
                                className="bg-secondary px-4 py-2 rounded-md text-secondary-foreground shadow-xs hover:bg-secondary/80"
                                onClick={() => setIsStopBroadcastDialogOpen(false)}
                                style={{ cursor: "pointer" }}
                            >
                                {locale("ui_cancel")}
                            </button>
                            <button
                                className="bg-red-600 px-4 py-2 rounded-md text-white shadow-xs hover:bg-red-700"
                                onClick={confirmStopBroadcast}
                                style={{ cursor: "pointer" }}
                            >
                                {locale("ui_stop_broadcasting")}
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    ) : null;
}