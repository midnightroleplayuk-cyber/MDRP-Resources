import { useState, useEffect, useRef, useCallback } from "react";
import { Box, Text, Image } from "@mantine/core";
import { useAtomValue, useAtom } from "jotai";
import {
  playerAtom,
  deviceQueueAtom,
  queueIndexAtom,
  activeDeviceAtom,
  Lang,
} from "../../reducers/atoms";
import { playerControl, getDeviceQueue, getMiniPlayerState } from "../../Api/Api";
import { fetchNui, isEnvBrowser } from "../../hooks/useNuiEvents";
import {
  SkipBack,
  SkipForward,
  Play,
  Pause,
  List,
  Music,
  MousePointer2Off,
} from "lucide-react";
import { Track } from "../../types/types";
import classes from "./style.module.css";

const MINI_W = 380;
const HEADER_H = 74;
const QUEUE_MAX_H = 220;
const QUEUE_ROW_H = 46;

const fmtTime = (s: number) => {
  const t = Math.max(0, Math.floor(s || 0));
  return `${Math.floor(t / 60)}:${(t % 60).toString().padStart(2, "0")}`;
};
const clamp = (v: number, lo: number, hi: number) =>
  Math.min(hi, Math.max(lo, v));

const CtrlBtn = ({
  onClick,
  children,
  primary,
  active,
}: {
  onClick: () => void;
  children: React.ReactNode;
  primary?: boolean;
  active?: boolean;
}) => (
  <Box
    onClick={(e: React.MouseEvent) => {
      e.stopPropagation();
      onClick();
    }}
    className={
      primary ? classes.ctrlPrimary : active ? classes.ctrlActive : classes.ctrl
    }
  >
    {children}
  </Box>
);

export const MiniPlayer = () => {
  const lang: any = useAtomValue(Lang);
  const [player, setPlayer] = useAtom(playerAtom);
  const [tracks, setTracks] = useAtom(deviceQueueAtom);
  const [queueIndex, setQueueIdx] = useAtom(queueIndexAtom);
  const activeDevice = useAtomValue(activeDeviceAtom);
  const [show, setShow] = useState(isEnvBrowser());
  const [cursorActive, setCursorActive] = useState(isEnvBrowser());
  const [queueOpen, setQueueOpen] = useState(false);
  const [pos, setPos] = useState({ x: -1, y: -1 });
  const posRef = useRef(pos);
  posRef.current = pos;
  const [liveTime, setLiveTime] = useState(0);
  const [liveDuration, setLiveDuration] = useState(0);
  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null);
  const dragging = useRef(false);
  const dragOffset = useRef({ x: 0, y: 0 });
  const positionSent = useRef(false);

  useEffect(() => {
    if (pos.x === -1) setPos({ x: window.innerWidth - MINI_W - 16, y: 16 });
  }, []);

  useEffect(() => {
    const handler = (ev: MessageEvent) => {
      const { action, data } = ev.data ?? {};

      if (action === "miniPlayerShow") {
        const shouldShow = !!data?.show;
        setShow(shouldShow);
        if (data?.pos) {
          setPos({
            x: clamp(
              (data.pos.x / 100) * window.innerWidth,
              0,
              window.innerWidth - MINI_W,
            ),
            y: clamp(
              (data.pos.y / 100) * window.innerHeight,
              0,
              window.innerHeight - HEADER_H,
            ),
          });
        }
        if (shouldShow) {
          getMiniPlayerState().then((state) => {
            if (!state) return;
            setPlayer((p) => ({
              ...p,
              track: state.track ?? p.track,
              playing: state.playing ?? false,
              currentTime: state.currentTime ?? 0,
              durationSecs: state.duration ?? state.track?.durationSecs ?? 0,
            }));
            setLiveTime(state.currentTime ?? 0);
            setLiveDuration(state.duration ?? state.track?.durationSecs ?? 0);
            setTracks(state.queue ?? []);
            setQueueIdx(state.queueIndex ?? 0);
          });
        }
      } else if (action === "miniPlayerCursor") {
        setCursorActive(!!data?.active);
      } else if (action === "trackChanged") {
        if (!data) {
          setPlayer((p) => ({
            ...p,
            track: null,
            playing: false,
            currentTime: 0,
            durationSecs: 0,
          }));
          setLiveTime(0);
          setLiveDuration(0);
        } else {
          setPlayer((p) => ({
            ...p,
            track: {
              id: data.videoId,
              videoId: data.videoId,
              url: data.url ?? "",
              title: data.title ?? "",
              artist: data.artist ?? "",
              album: data.album ?? "",
              durationSecs: data.durationSecs ?? 0,
              cover: data.cover ?? data.thumbnail ?? "",
            },
          }));
          setLiveDuration(data.durationSecs ?? 0);
        }
      } else if (action === "playState" && data) {
        setPlayer((p) => ({ ...p, playing: !!data.playing }));
      } else if (action === "timeUpdate" && data) {
        setLiveTime(data.currentTime ?? 0);
        setLiveDuration(data.duration ?? 0);
      }
    };
    window.addEventListener("message", handler);
    return () => window.removeEventListener("message", handler);
  }, []);

  useEffect(() => {
    if (timerRef.current) clearInterval(timerRef.current);
    if (player.playing && show) {
      timerRef.current = setInterval(() => {
        setLiveTime((t) => {
          const dur = liveDuration || player.durationSecs || 0;
          return dur > 0 ? Math.min(t + 0.25, dur) : t;
        });
      }, 250);
    }
    return () => {
      if (timerRef.current) clearInterval(timerRef.current);
    };
  }, [player.playing, show, liveDuration, player.durationSecs]);

  useEffect(() => {
    setLiveTime(player.currentTime ?? 0);
    setLiveDuration(player.durationSecs ?? 0);
  }, [player.track?.videoId]);

  useEffect(() => {
    if (!show) return;
    getDeviceQueue(activeDevice).then((r) => {
      setTracks(r?.queue ?? []);
      setQueueIdx(r?.queueIndex ?? 0);
    });
  }, [player.track?.videoId, activeDevice]);

  useEffect(() => {
    const handler = (ev: MessageEvent) => {
      if (ev.data?.action === "queueChanged" && show) {
        getDeviceQueue(activeDevice).then((r) => {
          setTracks(r?.queue ?? []);
          setQueueIdx(r?.queueIndex ?? 0);
        });
      }
    };
    window.addEventListener("message", handler);
    return () => window.removeEventListener("message", handler);
  }, [show]);

  const onHeaderMouseDown = useCallback(
    (e: React.MouseEvent) => {
      if (!cursorActive) return;
      dragging.current = true;
      positionSent.current = false;
      dragOffset.current = {
        x: e.clientX - posRef.current.x,
        y: e.clientY - posRef.current.y,
      };
      e.preventDefault();
    },
    [cursorActive],
  );

  useEffect(() => {
    const onMove = (e: MouseEvent) => {
      if (!dragging.current) return;
      const queueH = queueOpen
        ? Math.min(tracks.length * QUEUE_ROW_H + 12, QUEUE_MAX_H)
        : 0;
      setPos({
        x: clamp(
          e.clientX - dragOffset.current.x,
          0,
          window.innerWidth - MINI_W,
        ),
        y: clamp(
          e.clientY - dragOffset.current.y,
          0,
          window.innerHeight - (HEADER_H + queueH),
        ),
      });
    };
    const onUp = () => {
      if (!dragging.current) return;
      dragging.current = false;
      if (!positionSent.current) {
        positionSent.current = true;
        const p = posRef.current;
        fetchNui("av_music", "miniPlayerMoved", {
          x: (p.x / window.innerWidth) * 100,
          y: (p.y / window.innerHeight) * 100,
        });
      }
    };
    window.addEventListener("mousemove", onMove);
    window.addEventListener("mouseup", onUp);
    return () => {
      window.removeEventListener("mousemove", onMove);
      window.removeEventListener("mouseup", onUp);
    };
  }, [queueOpen, tracks.length]);

  if (!show || pos.x === -1) return null;

  const track = player.track;
  const dur = liveDuration || player.durationSecs || track?.durationSecs || 0;
  const progress = dur > 0 ? (liveTime / dur) * 100 : 0;

  return (
    <Box className={classes.overlay}>
      <Box
        className={`${classes.panel} ${cursorActive ? classes.panelActive : classes.panelInactive}`}
        style={{ left: pos.x, top: pos.y }}
      >
        <Box
          className={`${classes.header} ${cursorActive ? classes.headerGrab : classes.headerDefault}`}
          onMouseDown={onHeaderMouseDown}
        >
          {track?.cover ? (
            <Image
              src={track.cover}
              className={classes.cover}
              alt=""
              draggable={false}
            />
          ) : (
            <Box className={classes.coverPlaceholder}>
              <Music size={18} color="var(--text-secondary)" />
            </Box>
          )}
          <Box className={classes.trackInfo}>
            <Text className={classes.trackTitle}>{track?.title ?? "—"}</Text>
            <Text className={classes.trackArtist}>{track?.artist ?? "—"}</Text>
            <Box className={classes.progressRow}>
              <Text className={classes.timeLabel}>{fmtTime(liveTime)}</Text>
              <Box className={classes.progressTrack}>
                <Box
                  className={classes.progressBar}
                  style={{ width: `${clamp(progress, 0, 100)}%` }}
                />
              </Box>
              <Text className={classes.timeLabelRight}>{fmtTime(dur)}</Text>
            </Box>
          </Box>
          <Box
            className={classes.controls}
            onMouseDown={(e) => e.stopPropagation()}
          >
            <CtrlBtn onClick={() => playerControl("prev")}>
              <SkipBack size={13} />
            </CtrlBtn>
            <CtrlBtn onClick={() => playerControl("togglePlay")} primary>
              {player.playing ? (
                <Pause size={13} fill="white" />
              ) : (
                <Play size={13} fill="white" />
              )}
            </CtrlBtn>
            <CtrlBtn onClick={() => playerControl("next")}>
              <SkipForward size={13} />
            </CtrlBtn>
            <CtrlBtn onClick={() => setQueueOpen((o) => !o)} active={queueOpen}>
              <List size={13} />
            </CtrlBtn>
            {cursorActive && (
              <CtrlBtn
                onClick={() => fetchNui("av_music", "miniPlayerCursorOff", {})}
              >
                <MousePointer2Off size={13} />
              </CtrlBtn>
            )}
          </Box>
        </Box>
        <Box className={classes.divider} />
        <Box
          className={classes.queuePanel}
          style={{ maxHeight: queueOpen ? QUEUE_MAX_H : 0 }}
        >
          <Box
            className={classes.queueScroll}
            style={{ maxHeight: QUEUE_MAX_H }}
          >
            {tracks.length === 0 ? (
              <Text className={classes.queueEmpty}>
                {lang.mini_queue_empty ?? "Queue empty"}
              </Text>
            ) : (
              tracks.map((t: Track, i: number) => {
                const cur = i + 1 === queueIndex;
                return (
                  <Box
                    key={i}
                    className={`${classes.queueRow} ${cur ? classes.queueRowActive : classes.queueRowInactive}`}
                  >
                    <Box className={classes.queueIndex}>
                      {cur ? (
                        <Box className={classes.queueDot} />
                      ) : (
                        <Text className={classes.queueNum}>{i + 1}</Text>
                      )}
                    </Box>
                    {t.cover ? (
                      <Image
                        src={t.cover}
                        className={classes.queueCover}
                        alt=""
                        draggable={false}
                      />
                    ) : (
                      <Box className={classes.queueCoverPlaceholder}>
                        <Music size={12} color="var(--text-secondary)" />
                      </Box>
                    )}
                    <Box className={classes.queueTrackInfo}>
                      <Text
                        className={`${classes.queueTrackTitle} ${cur ? classes.queueTrackTitleActive : classes.queueTrackTitleInactive}`}
                      >
                        {t.title}
                      </Text>
                      <Text className={classes.queueTrackArtist}>
                        {t.artist}
                      </Text>
                    </Box>
                    <Text className={classes.queueTime}>
                      {fmtTime(t.durationSecs)}
                    </Text>
                  </Box>
                );
              })
            )}
          </Box>
        </Box>
      </Box>
    </Box>
  );
};
