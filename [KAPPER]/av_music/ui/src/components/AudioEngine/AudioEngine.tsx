import { useRef, useEffect, useCallback } from "react";
import { useNuiEvent, fetchNui } from "../../hooks/useNuiEvents";

function getYouTubeId(url: string): string | null {
  const m = url.match(/(?:v=|youtu\.be\/|embed\/|shorts\/)([A-Za-z0-9_-]{11})/);
  return m ? m[1] : null;
}

type SoundInstance = {
  audio?: HTMLAudioElement;
  sourceNode?: MediaElementAudioSourceNode;
  gainNode?: GainNode;
  panner?: PannerNode;
  filterNode?: BiquadFilterNode;
  timer?: ReturnType<typeof setInterval>;
  spatial?: boolean;
};

export const AudioEngine: React.FC = () => {
  const instances = useRef<Map<string, SoundInstance>>(new Map());
  const audioCtxRef = useRef<AudioContext | null>(null);

  const getCtx = useCallback((): AudioContext => {
    if (!audioCtxRef.current) {
      audioCtxRef.current = new (
        window.AudioContext || (window as any).webkitAudioContext
      )();
    }
    if (audioCtxRef.current.state === "suspended") {
      audioCtxRef.current.resume();
    }
    return audioCtxRef.current;
  }, []);

  const dispatchEvt = useCallback(
    (name: string, event: string, extra?: Record<string, unknown>) => {
      fetchNui("av_music", "avs_event", { event, name, ...(extra ?? {}) });
    },
    [],
  );

  const stopTimer = useCallback((name: string) => {
    const inst = instances.current.get(name);
    if (inst?.timer !== undefined) {
      clearInterval(inst.timer);
      inst.timer = undefined;
    }
  }, []);

  const startHtml5Timer = useCallback(
    (name: string, el: HTMLAudioElement) => {
      stopTimer(name);
      const inst = instances.current.get(name);
      if (!inst) return;
      inst.timer = setInterval(() => {
        if (!instances.current.has(name)) return;
        if (!el.paused && !el.ended)
          dispatchEvt(name, "timeSync", {
            currentTime: Math.floor(el.currentTime),
            duration: Math.floor(el.duration) || 0,
          });
      }, 500);
    },
    [dispatchEvt, stopTimer],
  );

  const destroyInstance = useCallback((name: string) => {
    const inst = instances.current.get(name);
    if (!inst) return;
    if (inst.timer !== undefined) clearInterval(inst.timer);
    try {
      inst.sourceNode?.disconnect();
    } catch {}
    try {
      inst.filterNode?.disconnect();
    } catch {}
    try {
      inst.gainNode?.disconnect();
    } catch {}
    try {
      inst.panner?.disconnect();
    } catch {}
    if (inst.audio) {
      inst.audio.pause();
      inst.audio.src = "";
    }
    instances.current.delete(name);
    console.log("[AudioEngine] destroyed:", name);
  }, []);

  const makeSpatialChain = useCallback(
    (
      vol: number,
      radius: number,
    ): { gain: GainNode; pan: PannerNode; ctx: AudioContext } | null => {
      try {
        const ctx = getCtx();
        const gain = ctx.createGain();
        const pan = ctx.createPanner();
        pan.panningModel = "HRTF";
        pan.distanceModel = "linear";
        pan.refDistance = 1;
        pan.maxDistance = radius;
        pan.rolloffFactor = 1;
        pan.coneInnerAngle = 360;
        pan.coneOuterAngle = 0;
        pan.coneOuterGain = 0;
        gain.gain.value = vol;
        gain.connect(pan);
        pan.connect(ctx.destination);
        return { gain, pan, ctx };
      } catch (e) {
        console.warn("[AudioEngine] makeSpatialChain failed:", e);
        return null;
      }
    },
    [getCtx],
  );

  useNuiEvent(
    "avCmd",
    useCallback(
      (data: any) => {
        const {
          cmd,
          name,
          url,
          volume,
          loop,
          time,
          initialTime,
          spatial,
          radius,
        } = data;
        if (!name) return;

        if (cmd === "play") {
          if (getYouTubeId(url ?? "")) {
            console.log("[AudioEngine] YT sound routed to DUI — skip:", name);
            return;
          }

          destroyInstance(name);
          instances.current.set(name, {});

          const vol = volume ?? 0.75;
          const rad = radius ?? 20;
          const el = new Audio(url);
          el.loop = !!loop;
          const inst = instances.current.get(name)!;
          inst.audio = el;

          let usedSpatial = false;
          if (spatial) {
            const chain = makeSpatialChain(vol, rad);
            if (chain) {
              try {
                const source = chain.ctx.createMediaElementSource(el);
                source.connect(chain.gain);
                inst.sourceNode = source;
                inst.gainNode = chain.gain;
                inst.panner = chain.pan;
                inst.spatial = true;
                usedSpatial = true;
                console.log("[AudioEngine] HTML5 HRTF ready:", name);
              } catch (e) {
                console.warn("[AudioEngine] HTML5 spatial failed:", e);
                chain.gain.disconnect();
                chain.pan.disconnect();
              }
            }
          }
          if (!usedSpatial) el.volume = Math.max(0, Math.min(1, vol));

          if ((initialTime ?? 0) > 0)
            el.addEventListener(
              "canplay",
              () => {
                if (el.currentTime < initialTime) el.currentTime = initialTime;
              },
              { once: true },
            );

          el.addEventListener("loadedmetadata", () =>
            dispatchEvt(name, "ready", {
              duration: Math.floor(el.duration) || 0,
            }),
          );
          let started = false;
          el.addEventListener("play", () => {
            if (!started) {
              started = true;
              dispatchEvt(name, "playing", {});
            } else dispatchEvt(name, "resumed", {});
          });
          el.addEventListener("pause", () => {
            if (!el.ended) dispatchEvt(name, "paused", {});
          });
          el.addEventListener("ended", () => {
            stopTimer(name);
            dispatchEvt(name, "ended", {});
          });
          el.addEventListener("error", () =>
            dispatchEvt(name, "error", { code: el.error?.code ?? -1 }),
          );
          el.play().catch(() => dispatchEvt(name, "error", { code: -99 }));
          startHtml5Timer(name, el);
        } else if (cmd === "updateSpatial") {
          const inst = instances.current.get(name);
          const ctx = audioCtxRef.current;
          if (!inst?.panner || !ctx) return;

          const t = ctx.currentTime + 0.05;
          const sp = data.speaker;
          const ls = data.listener;
          inst.panner.positionX.setValueAtTime(sp.x, t);
          inst.panner.positionY.setValueAtTime(sp.z, t);
          inst.panner.positionZ.setValueAtTime(-sp.y, t);
          ctx.listener.positionX.setValueAtTime(ls.position.x, t);
          ctx.listener.positionY.setValueAtTime(ls.position.z, t);
          ctx.listener.positionZ.setValueAtTime(-ls.position.y, t);
          ctx.listener.forwardX.setValueAtTime(ls.forward.x, t);
          ctx.listener.forwardY.setValueAtTime(ls.forward.z, t);
          ctx.listener.forwardZ.setValueAtTime(-ls.forward.y, t);
          ctx.listener.upX.setValueAtTime(0, t);
          ctx.listener.upY.setValueAtTime(1, t);
          ctx.listener.upZ.setValueAtTime(0, t);
        } else if (cmd === "pause") {
          const inst = instances.current.get(name);
          inst?.audio?.pause();
          stopTimer(name);
        } else if (cmd === "resume") {
          const inst = instances.current.get(name);
          inst?.audio?.play().catch(() => {});
        } else if (cmd === "stop") {
          destroyInstance(name);
        } else if (cmd === "seek") {
          const inst = instances.current.get(name);
          if (inst?.audio) inst.audio.currentTime = time;
        } else if (cmd === "volume") {
          const inst = instances.current.get(name);
          const v = Math.max(0, Math.min(1, volume));
          if (inst?.gainNode) inst.gainNode.gain.value = v;
          else if (inst?.audio) inst.audio.volume = v;
        } else if (cmd === "updateFilter" || cmd === "addFilter") {
          const inst = instances.current.get(name);
          const ctx = audioCtxRef.current;
          if (!inst || !ctx) return;
          const freq = data.frequency ?? 800;
          const quality = data.quality ?? 0.8;
          const fadeSec = 0.25;
          if (!inst.filterNode) {
            if (!inst.sourceNode) return;
            const f = ctx.createBiquadFilter();
            f.type = "lowpass";
            f.frequency.value = freq;
            f.Q.value = quality;
            try {
              inst.sourceNode.disconnect();
            } catch {}
            inst.sourceNode.connect(f);
            f.connect(inst.gainNode ?? ctx.destination);
            inst.filterNode = f;
            console.log("[AudioEngine] filter added:", name, freq + "Hz");
          } else {
            const t = ctx.currentTime;
            inst.filterNode.frequency.cancelAndHoldAtTime(t);
            inst.filterNode.frequency.setValueAtTime(
              inst.filterNode.frequency.value,
              t,
            );
            inst.filterNode.frequency.linearRampToValueAtTime(
              freq,
              t + fadeSec,
            );
            inst.filterNode.Q.setValueAtTime(quality, t);
          }
        } else if (cmd === "removeFilter") {
          const inst = instances.current.get(name);
          const ctx = audioCtxRef.current;
          if (!inst?.filterNode || !inst.sourceNode || !ctx) return;
          try {
            inst.sourceNode.disconnect();
          } catch {}
          try {
            inst.filterNode.disconnect();
          } catch {}
          inst.sourceNode.connect(inst.gainNode ?? ctx.destination);
          inst.filterNode = undefined;
          console.log("[AudioEngine] filter removed:", name);
        }
      },
      [
        dispatchEvt,
        stopTimer,
        destroyInstance,
        makeSpatialChain,
        startHtml5Timer,
      ],
    ),
  );

  useEffect(
    () => () => {
      instances.current.forEach((_, n) => destroyInstance(n));
    },
    [destroyInstance],
  );

  return null;
};
