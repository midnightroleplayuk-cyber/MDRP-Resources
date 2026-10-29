import { useEffect, useRef, useState } from "react";
import { useNuiEvent } from "../../providers/nui/useNui";

type TurnConfig = {
	iceServers?: Array<{ urls: string[] | string; username?: string; credential?: string; }>;
};

export default function MusicPlayer() {
	const audioRef = useRef<HTMLAudioElement | null>(null);
	const pcRef = useRef<RTCPeerConnection | null>(null);
	const audioCtxRef = useRef<AudioContext | null>(null);
	const streamSourceRef = useRef<MediaStreamAudioSourceNode | null>(null);
	const gainRef = useRef<GainNode | null>(null);
	const pannerRef = useRef<StereoPannerNode | PannerNode | null>(null);
	const biquadFilterRef = useRef<BiquadFilterNode | null>(null);
	const broadcasterRef = useRef<number | null>(null);
	const [isPlaying, setIsPlaying] = useState(false);

	useEffect(() => {
		console.log("MusicPlayer: mounted");
		return () => console.log("MusicPlayer: unmounted");
	}, []);

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
			console.error("MusicPlayer: NUI POST failed", name, e);
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
			console.error("MusicPlayer: NUI POST JSON failed", name, e);
			return null;
		}
	};

	const sleep = (ms: number) => new Promise<void>(r => setTimeout(r, ms));

	const ensureTurnConfig = async (): Promise<TurnConfig | null> => {
		let requested = false;
		for (let i = 0; i < 15; i++) {
			const cfgResp = await nuiPostJson<{ ok: boolean; config?: TurnConfig }>("music_rtc_get_turn_config", {});
			const cfg = (cfgResp && cfgResp.config) ? cfgResp.config : null;
			const valid = !!(cfg && Array.isArray(cfg.iceServers) && cfg.iceServers.length > 0);
			if (valid) {
				return cfg;
			}
			if (!requested) {
				requested = true;
				await nuiPost("music_rtc_request_turn_config", {});
			}
			await sleep(200);
		}
		return null;
	};

	const closePc = () => {
		try {
			const pc = pcRef.current;
			if (pc) {
				try { pc.onicecandidate = null; } catch {}
				try { pc.ontrack = null; } catch {}
				try { pc.getSenders().forEach(s => { try { pc.removeTrack(s); } catch {} }); } catch {}
				try { pc.close(); } catch {}
			}
		} catch {}
		pcRef.current = null;
	};

	useNuiEvent("music:rtc:broadcastStarted", async (msg: any) => {
		try {
			const payload = (msg && (msg.payload || msg.data)) || {};
			const { broadcaster } = payload || {};
			broadcasterRef.current = typeof broadcaster === "number" ? broadcaster : null;
			console.log("MusicPlayer: broadcastStarted received", payload);

			const existing = pcRef.current;
			if (existing) {
				closePc();
			}

			const cfg = await ensureTurnConfig();
			const turnConfig: RTCConfiguration = cfg ? { iceServers: cfg.iceServers as any } : {};
			console.log("MusicPlayer: using RTCConfiguration", turnConfig ?? {});

			const pc = new RTCPeerConnection(turnConfig);
			pcRef.current = pc;
			try {
				pc.onconnectionstatechange = () => console.log("MusicPlayer RTC connectionState:", pc.connectionState);
				pc.oniceconnectionstatechange = () => console.log("MusicPlayer RTC iceConnectionState:", pc.iceConnectionState);
				pc.onicegatheringstatechange = () => console.log("MusicPlayer RTC gatheringState:", pc.iceGatheringState);
			} catch {}
			pc.onicecandidate = (ev) => {
				if (ev.candidate) {
					nuiPost("music_rtc_ice_to_broadcaster", { candidate: ev.candidate });
				}
			};
			pc.ontrack = (ev) => {
				const [stream] = ev.streams;
				const audio = audioRef.current;
				if (!audio) return;
				try {
					const track = ev.track;
					console.log("MusicPlayer: ontrack", { kind: track?.kind, enabled: track?.enabled, muted: (track as any)?.muted });
					try {
						(track as any).onmute = () => console.warn("MusicPlayer: inbound track muted");
						(track as any).onunmute = () => console.warn("MusicPlayer: inbound track unmuted");
						(track as any).onended = () => console.warn("MusicPlayer: inbound track ended");
					} catch {}
					(audio as any).srcObject = stream;
					audio.autoplay = true;
					(audio as any).playsInline = true;
					audio.muted = false;
					audio.volume = 1.0;
					audio.play().then(async () => {
						// Build WebAudio graph from MediaStream directly; then mute element output
						try {
							// @ts-ignore
							const Ctx = (window.AudioContext || (window as any).webkitAudioContext);
							if (Ctx && !audioCtxRef.current) {
								audioCtxRef.current = new Ctx();
							}
							const ctx = audioCtxRef.current;
							if (ctx) {
								if (ctx.state === 'suspended') { try { await ctx.resume(); } catch {} }
								// (Re)create nodes
								try { (streamSourceRef.current as any)?.disconnect?.(); } catch {}
								try { (gainRef.current as any)?.disconnect?.(); } catch {}
								try { (pannerRef.current as any)?.disconnect?.(); } catch {}
								streamSourceRef.current = ctx.createMediaStreamSource(stream);
								if (!gainRef.current) { gainRef.current = ctx.createGain(); }
								gainRef.current.gain.value = 1.0;
								if (!pannerRef.current) {
									if (typeof (ctx as any).createStereoPanner === 'function') {
										pannerRef.current = (ctx as any).createStereoPanner();
										(pannerRef.current as StereoPannerNode).pan.value = 0.0;
									} else {
										const pn = ctx.createPanner();
										pn.panningModel = 'equalpower';
										pn.distanceModel = 'inverse';
										try { pn.setPosition(0, 0, 1); } catch {}
										pannerRef.current = pn;
									}
								}
								// Connect: stream -> gain -> panner -> destination
								streamSourceRef.current.connect(gainRef.current);
								(gainRef.current as any).connect(pannerRef.current as any);
								(pannerRef.current as any).connect(ctx.destination);
								// mute element output to avoid double playback
								audio.muted = true;
							}
						} catch {}
						setIsPlaying(true)
					}).catch((e) => {
						console.error("MusicPlayer: audio.play() failed", e);
					});
					console.log("MusicPlayer: remote track attached");
				} catch {}
			};
			try { pc.addTransceiver("audio", { direction: "recvonly" }); } catch {}

			const offer = await pc.createOffer({ offerToReceiveAudio: true });
			await pc.setLocalDescription(offer);
			console.log("MusicPlayer: created and set local offer");
			await nuiPost("music_rtc_offer", { sdp: offer.sdp });
			console.log("MusicPlayer: sent offer to broadcaster");
		} catch {}
	});

	useNuiEvent("music:rtc:answer", async (msg: any) => {
		const payload = (msg && (msg.payload || msg.data)) || {};
		const { sdp } = payload || {};
		const pc = pcRef.current;
		if (!pc || !sdp) return;
		try {
			await pc.setRemoteDescription({ type: "answer", sdp });
			console.log("MusicPlayer: applied remote answer");
		} catch {}
	});

	useNuiEvent("music:rtc:iceFromBroadcaster", async (msg: any) => {
		const payload = (msg && (msg.payload || msg.data)) || {};
		let { candidate } = payload || {};
		const pc = pcRef.current;
		if (!pc || !candidate) return;
		try {
			// Some bridges send candidate as a JSON string; normalize to object
			if (typeof candidate === "string") {
				try { candidate = JSON.parse(candidate); } catch {}
			}
			await pc.addIceCandidate(candidate as RTCIceCandidateInit);
			console.log("MusicPlayer: added ICE candidate from broadcaster");
		} catch {}
	});

	useNuiEvent("music:rtc:broadcastStopped", () => {
		try {
			const audio = audioRef.current;
			if (audio) {
				try { audio.pause(); } catch {}
				try { audio.removeAttribute("src"); audio.load(); } catch {}
				try { audio.volume = 0.0; } catch {}
			}
			try { (streamSourceRef.current as any)?.disconnect?.(); } catch {}
			try { (biquadFilterRef.current as any)?.disconnect?.(); } catch {}
			try { (gainRef.current as any)?.disconnect?.(); } catch {}
			try { (pannerRef.current as any)?.disconnect?.(); } catch {}
			biquadFilterRef.current = null;
		} catch {}
		setIsPlaying(false);
		closePc();
	});

	// Distance-based attenuation (volume control from client proximity loop)


	useNuiEvent("music:setAudioValues", (msg: any) => {
		const data = (msg && (msg.payload || msg.data)) || {};
		const volRaw = typeof data.volume === "number" ? data.volume : null;
		const panRaw = typeof data.pan === "number" ? data.pan : null;
		const muffled = typeof data.muffled === "boolean" ? data.muffled : null;
		if (volRaw != null) {
			const vol = Math.max(0, Math.min(1, volRaw));
			const audio = audioRef.current;
			if (!audio) return;
			try { audio.volume = vol; } catch {}
			try { if (gainRef.current) gainRef.current.gain.value = vol; } catch {}
		}
		if (panRaw != null) {
			const pan = Math.max(-1, Math.min(1, panRaw));
			try {
				const p = pannerRef.current as any;
				if (!p) return;
				if (typeof p.pan?.setValueAtTime === "function" && audioCtxRef.current) {
					p.pan.setValueAtTime(pan, audioCtxRef.current.currentTime);
				} else if (typeof p.setPosition === "function") {
					// map pan to x-axis [-1,1] at z=1
					p.setPosition(pan, 0, 1);
				}
			} catch {}
		}
		if (muffled != null) {
		try {
				const ctx = audioCtxRef.current;
			if (!ctx) return;
				const source = streamSourceRef.current;
				if (!source) return;
				const gain = gainRef.current;
				if (!gain) return;
				const panner = pannerRef.current;
				if (!panner) return;

			// If muffled, insert a lowpass filter node between source and gain
			if (muffled) {
					if (!biquadFilterRef.current) {
					const filter = ctx.createBiquadFilter();
					filter.type = "lowpass";
					// Typical muffling: cutoff between 400hz and 1000hz for "in next room"
					filter.frequency.setValueAtTime(700, ctx.currentTime);
					filter.Q.setValueAtTime(1, ctx.currentTime);

						// Disconnect existing chain: source -> gain
						try { source.disconnect(); } catch {}
						// Note: gain -> panner -> destination should remain connected

						// Reconnect through filter: source -> filter -> gain
						source.connect(filter);
						filter.connect(gain);
						// gain is already connected to panner -> destination from initial setup
						biquadFilterRef.current = filter;
				} else {
						// Filter already exists, ensure cutoff is set
						biquadFilterRef.current.frequency.setValueAtTime(700, ctx.currentTime);
				}
			} else {
				// Remove filter if present
					if (biquadFilterRef.current) {
						const filter = biquadFilterRef.current;
						
						// Disconnect filter from chain
						try { source.disconnect(); } catch {}
						try { filter.disconnect(); } catch {}
						// Note: gain -> panner -> destination should remain connected

						// Reconnect without filter: source -> gain
						source.connect(gain);
						// gain is already connected to panner -> destination from initial setup
						biquadFilterRef.current = null;
				}
			}
		} catch (e) {
			console.error("[MusicPlayer] error applying muffled effect:", e);
		}
		}
	});

	useEffect(() => {
		// Optional: log connection and ICE state for debugging
		const pc = pcRef.current;
		if (pc) {
			try {
				pc.onconnectionstatechange = () => console.log("MusicPlayer RTC connectionState:", pc.connectionState);
				pc.oniceconnectionstatechange = () => console.log("MusicPlayer RTC iceConnectionState:", pc.iceConnectionState);
				pc.onicegatheringstatechange = () => console.log("MusicPlayer RTC gatheringState:", pc.iceGatheringState);
			} catch {}
		}
		return () => {
			closePc();
		};
	}, []);

	return (
		<div style={{ position: "fixed", left: -9999, top: -9999, width: 1, height: 1, opacity: 0, pointerEvents: "none" }}>
			<audio ref={audioRef} playsInline autoPlay />
			<div aria-hidden style={{ width: 1, height: 1 }}>{isPlaying ? "on" : "off"}</div>
		</div>
	);
}

