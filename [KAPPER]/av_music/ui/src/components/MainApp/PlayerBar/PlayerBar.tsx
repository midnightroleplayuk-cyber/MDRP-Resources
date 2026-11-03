import { useRef, useState, useEffect, useCallback } from "react";
import {
  Box,
  Group,
  Text,
  Image,
  Slider,
  ActionIcon,
  Popover,
  Tooltip,
  UnstyledButton,
} from "@mantine/core";
import {
  SkipBack,
  Play,
  Pause,
  SkipForward,
  Volume2,
  Shuffle,
  Repeat,
  Headphones,
  Car,
  Check,
  X,
  Laptop,
  RadioTower,
  PictureInPicture2,
} from "lucide-react";
import { useAtom, useAtomValue } from "jotai";
import {
  playerAtom,
  activeDeviceAtom,
  loopModeAtom,
  shuffleModeAtom,
  Lang,
  devicesAtom,
} from "../../../reducers/atoms";
import {
  playerControl,
  requestDevices,
  setDevice,
  Device,
  toggleMiniPlayer,
} from "../../../Api/Api";
import { useNuiEvent } from "../../../hooks/useNuiEvents";
import classes from "./style.module.css";

const fmtTime = (secs: number) => {
  const s = Math.max(0, Math.floor(secs));
  return `${Math.floor(s / 60)}:${(s % 60).toString().padStart(2, "0")}`;
};

const PINK = "var(--accent)";

export const PlayerBar = () => {
  const lang: any = useAtomValue(Lang);
  const [player, setPlayer] = useAtom(playerAtom);
  const [activeDevice, setActiveDevice] = useAtom(activeDeviceAtom);
  const [loopMode, setLoopMode] = useAtom(loopModeAtom);
  const [shuffleMode, setShuffleMode] = useAtom(shuffleModeAtom);
  const [miniPlayerActive, setMiniPlayerActive] = useState(false);
  const sessionIdRef = useRef<string | undefined>(undefined);
  const [localPlaying, setLocalPlaying] = useState(false);
  const [localDuration, setLocalDuration] = useState(0);
  const serverTimeRef = useRef({ time: 0, ts: Date.now() });
  const [liveTime, setLiveTime] = useState(0);
  const [liveProgress, setLiveProgress] = useState(0);
  const isDragging = useRef(false);
  const isLiveRef = useRef(false);
  const [isLive, setIsLive] = useState(false);

  const [devicesOpen, setDevicesOpen] = useState(false);
  const [devices, setDevices] = useAtom(devicesAtom);

  useNuiEvent<{ devices: Device[]; activeDevice: string }>(
    "devicesUpdate",
    useCallback((data) => {
      setDevices(data.devices ?? []);
      setActiveDevice(data.activeDevice ?? "laptop");
    }, []),
  );

  // On mount: fetch current device state from Lua so the UI reflects the
  // preserved device (vehicle/zone/headphones) even if the devicesUpdate
  // NUI message was sent before this component had registered its listener.
  useEffect(() => {
    requestDevices().then((data) => {
      if (data?.devices) {
        setDevices(data.devices);
        setActiveDevice(data.activeDevice ?? "laptop");
      }
    });
  }, []);

  const handleDevicesClick = async () => {
    if (!devicesOpen) {
      const data = await requestDevices();
      if (data?.devices) {
        setDevices(data.devices);
        setActiveDevice(data.activeDevice ?? "laptop");
      }
    }
    setDevicesOpen((o) => !o);
  };

  const handleSelectDevice = async (deviceId: string) => {
    if (deviceId === activeDevice) {
      setDevicesOpen(false);
      return;
    }
    await setDevice(deviceId);
    setActiveDevice(deviceId);
    setDevicesOpen(false);
  };

  useEffect(() => {
    if (!localPlaying || !localDuration) return;
    const id = setInterval(() => {
      if (isDragging.current) return;
      const elapsed = (Date.now() - serverTimeRef.current.ts) / 1000;
      const estimated = Math.min(
        serverTimeRef.current.time + elapsed,
        localDuration,
      );
      setLiveTime(Math.floor(estimated));
      setLiveProgress((estimated / localDuration) * 100);
    }, 250);
    return () => clearInterval(id);
  }, [localPlaying, localDuration]);

  useEffect(() => {
    const handler = (ev: MessageEvent) => {
      if (!ev.data || typeof ev.data !== "object") return;
      const { action, data } = ev.data;
      if (!action) return;
      if (!data && action !== "trackChanged") return;
      if (action === "trackChanged") {
        if (!data) {
          sessionIdRef.current = undefined;
          serverTimeRef.current = { time: 0, ts: Date.now() };
          isLiveRef.current = false;
          setIsLive(false);
          setLocalPlaying(false);
          setLocalDuration(0);
          setLiveTime(0);
          setLiveProgress(0);
          setPlayer((p) => ({
            ...p,
            track: null,
            playing: false,
            progress: 0,
            currentTime: 0,
            durationSecs: 0,
            sessionId: undefined,
          }));
          return;
        }
        sessionIdRef.current = data.sessionId;
        serverTimeRef.current = { time: 0, ts: Date.now() };
        const live =
          data.trackType === "live" || (data.durationSecs ?? 0) === 0;
        isLiveRef.current = live;
        setIsLive(live);
        setLocalPlaying(false);
        setLocalDuration(data.durationSecs ?? 0);
        setLiveTime(0);
        setLiveProgress(0);
        setPlayer((p) => ({
          ...p,
          track: data,
          playing: false,
          progress: 0,
          currentTime: 0,
          durationSecs: data.durationSecs ?? 0,
          sessionId: data.sessionId,
        }));
      } else if (action === "playState") {
        if (data.sessionId && sessionIdRef.current !== data.sessionId) return;
        setLocalPlaying(data.playing);
        if (data.currentTime !== undefined) {
          serverTimeRef.current = { time: data.currentTime, ts: Date.now() };
          setLiveTime(data.currentTime);
        }
      } else if (action === "timeUpdate") {
        if (data.sessionId && sessionIdRef.current !== data.sessionId) return;
        if (data.duration > 0 && !isLiveRef.current)
          setLocalDuration(data.duration);
        if (!isDragging.current) {
          serverTimeRef.current = { time: data.currentTime, ts: Date.now() };
          if (!isLiveRef.current) setLiveTime(data.currentTime);
          if (data.duration > 0 && !isLiveRef.current)
            setLiveProgress((data.currentTime / data.duration) * 100);
        }
      } else if (action === "volumeUpdate") {
        if (data.volume !== undefined && data.volume !== null) {
          setPlayer((p) => ({ ...p, volume: Math.round(data.volume) }));
        }
      } else if (action === "loopState") {
        setLoopMode(data.mode ?? "none");
      } else if (action === "shuffleState") {
        setShuffleMode(data.enabled ?? false);
      } else if (action === "miniPlayerShow") {
        setMiniPlayerActive(!!data?.show);
      }
    };
    window.addEventListener("message", handler);
    return () => window.removeEventListener("message", handler);
  }, []);

  useEffect(() => {
    setLocalPlaying(player.playing);
  }, [player.playing]);
  useEffect(() => {
    if (!isLiveRef.current) setLocalDuration(player.durationSecs);
  }, [player.durationSecs]);

  const togglePlay = async () => {
    setLocalPlaying((p) => !p);
    await playerControl("togglePlay");
  };
  const handleVolumeChange = async (v: number) => {
    setPlayer((p) => ({ ...p, volume: v }));
    await playerControl("setVolume", v);
  };
  const handleProgressChange = (v: number) => {
    isDragging.current = true;
    setLiveTime(Math.floor((v / 100) * localDuration));
    setLiveProgress(v);
  };
  const handleProgressChangeEnd = async (v: number) => {
    isDragging.current = false;
    const t = Math.floor((v / 100) * localDuration);
    setLiveTime(t);
    setLiveProgress(v);
    serverTimeRef.current = { time: t, ts: Date.now() };
    await playerControl("seek", v);
  };

  const loopLabel =
    loopMode === "track"
      ? (lang.loop_track ?? "Loop: 1 track")
      : loopMode === "queue"
        ? (lang.loop_queue ?? "Loop: queue")
        : (lang.loop_off ?? "Loop: off");

  const activeDeviceObj = devices.find((d) => d.id === activeDevice);

  const sliderStyles = {
    track: { backgroundColor: "rgba(255,255,255,0.1)" },
    bar: { backgroundColor: "#fff" },
    thumb: {
      backgroundColor: "#fff",
      borderColor: "#fff",
      width: 10,
      height: 10,
    },
  };

  const dotStyle: React.CSSProperties = {
    position: "absolute",
    bottom: -3,
    left: "50%",
    transform: "translateX(-50%)",
    width: 3,
    height: 3,
    borderRadius: "50%",
    background: PINK,
  };

  return (
    <Box className={classes.playerBar}>
      <Group
        gap={12}
        className={classes.playerTrack}
        wrap="nowrap"
        style={{ overflow: "hidden", minWidth: 0 }}
      >
        {player.track ? (
          <>
            <Image
              src={player.track.cover}
              w={42}
              h={42}
              radius={6}
              style={{ objectFit: "cover", flexShrink: 0 }}
            />
            <Box style={{ minWidth: 0 }}>
              <Text
                className={classes.trackTitle}
                style={{
                  overflow: "hidden",
                  textOverflow: "ellipsis",
                  whiteSpace: "nowrap",
                }}
              >
                {player.track.title}
              </Text>
              <Text className={classes.trackArtist}>{player.track.artist}</Text>
            </Box>
          </>
        ) : (
          <Text className={classes.trackArtist}>
            {lang.player_no_track ?? "No track selected"}
          </Text>
        )}
      </Group>
      <Box className={classes.playerCenter}>
        <Group gap={24} justify="center" mb={8}>
          <ActionIcon
            variant="transparent"
            size="sm"
            className={classes.controlBtn}
            onClick={() => playerControl("toggleShuffle")}
            style={{ position: "relative" }}
            title={
              shuffleMode
                ? (lang.shuffle_on ?? "Shuffle: ON")
                : (lang.shuffle_off ?? "Shuffle: OFF")
            }
          >
            <Shuffle size={15} color={shuffleMode ? PINK : undefined} />
            {shuffleMode && <span style={dotStyle} />}
          </ActionIcon>
          <ActionIcon
            variant="transparent"
            className={classes.controlBtn}
            size="md"
            onClick={() => playerControl("prev")}
            disabled={!player.track}
          >
            <SkipBack size={18} />
          </ActionIcon>
          <ActionIcon
            variant="filled"
            radius="xl"
            size="lg"
            className={classes.playBtn}
            onClick={togglePlay}
            disabled={!player.track}
          >
            {localPlaying ? <Pause size={16} /> : <Play size={16} />}
          </ActionIcon>
          <ActionIcon
            variant="transparent"
            className={classes.controlBtn}
            size="md"
            onClick={() => playerControl("next")}
            disabled={!player.track}
          >
            <SkipForward size={18} />
          </ActionIcon>
          <ActionIcon
            variant="transparent"
            size="sm"
            className={classes.controlBtn}
            onClick={() => playerControl("toggleLoop")}
            style={{
              position: "relative",
            }}
            title={loopLabel}
          >
            <Repeat size={15} color={loopMode !== "none" ? PINK : undefined} />
            {loopMode !== "none" && <span style={dotStyle} />}
            {loopMode === "track" && (
              <span
                style={{
                  position: "absolute",
                  top: -5,
                  right: -5,
                  fontSize: 8,
                  fontWeight: 800,
                  color: PINK,
                  lineHeight: 1,
                }}
              >
                1
              </span>
            )}
          </ActionIcon>
        </Group>
        {isLive && player.track ? (
          <Group gap={10} align="center" style={{ width: "100%" }}>
            <span
              style={{
                fontSize: 9,
                fontWeight: 700,
                letterSpacing: 1,
                color: "var(--text-white)",
                background: "var(--accent)",
                borderRadius: 4,
                padding: "2px 7px",
                display: "flex",
                alignItems: "center",
                gap: 4,
              }}
            >
              <span
                style={{
                  width: 5,
                  height: 5,
                  borderRadius: "50%",
                  background: "#fff",
                  animation: "liveDot 1.2s ease-in-out infinite",
                  display: "inline-block",
                  flexShrink: 0,
                }}
              />
              LIVE
            </span>
            <Slider
              value={100}
              size={3}
              style={{ flex: 1, minWidth: 0 }}
              disabled
              styles={{
                ...sliderStyles,
                thumb: { display: "none" },
                bar: { background: "var(--accent)" },
              }}
            />
          </Group>
        ) : (
          <Group gap={10} align="center" style={{ width: "100%" }}>
            <Text className={classes.timeLabel}>{fmtTime(liveTime)}</Text>
            <Slider
              value={liveProgress}
              onChange={handleProgressChange}
              onChangeEnd={handleProgressChangeEnd}
              label={(v) => fmtTime(Math.floor((v / 100) * localDuration))}
              size={3}
              style={{ flex: 1, minWidth: 0 }}
              disabled={!player.track}
              styles={sliderStyles}
            />
            <Text className={classes.timeLabel}>{fmtTime(localDuration)}</Text>
          </Group>
        )}
      </Box>
      <style>{`@keyframes liveDot { 0%,100%{opacity:1} 50%{opacity:.25} }`}</style>
      {devicesOpen && (
        <Box
          onClick={() => setDevicesOpen(false)}
          style={{
            position: "fixed",
            inset: 0,
            zIndex: 99,
          }}
        />
      )}
      <Group
        gap={0}
        justify="flex-end"
        className={classes.playerVolume}
        align="center"
      >
        <Popover
          opened={devicesOpen}
          onClose={() => setDevicesOpen(false)}
          position="top-end"
          withinPortal={false}
          closeOnClickOutside
          withArrow
          arrowSize={8}
          styles={{
            dropdown: {
              background: "rgba(14,17,28,0.97)",
              backdropFilter: "blur(16px)",
              border: "1px solid rgba(255,255,255,0.09)",
              borderRadius: 12,
              padding: "6px 0",
              minWidth: 200,
              zIndex: 100,
            },
            arrow: {
              background: "rgba(14,17,28,0.97)",
              border: "1px solid rgba(255,255,255,0.09)",
            },
          }}
        >
          <Popover.Target>
            <Tooltip
              label={lang.devices_label ?? "Devices"}
              position="top"
              withArrow
              styles={{
                tooltip: { fontSize: 11, padding: "3px 8px", background: "rgba(14,17,28,0.97)", border: "1px solid rgba(255,255,255,0.09)", color: "#fff" },
                arrow: { background: "rgba(14,17,28,0.97)", border: "1px solid rgba(255,255,255,0.09)" },
              }}
            >
            <ActionIcon
              variant="transparent"
              size="sm"
              onClick={handleDevicesClick}
              className={classes.controlBtn}
              style={{
                position: "relative",
                zIndex: 100,
              }}
            >
              {(() => {
                const Icon =
                  activeDevice === "laptop"
                    ? Laptop
                    : activeDevice === "headphones"
                      ? Headphones
                      : activeDevice?.startsWith("zone_")
                        ? RadioTower
                        : Car;
                return <Icon size={15} color="var(--accent)" />;
              })()}
            </ActionIcon>
            </Tooltip>
          </Popover.Target>
          <Popover.Dropdown>
            <Text
              style={{
                fontSize: 10,
                fontWeight: 600,
                letterSpacing: "0.08em",
                color: "rgba(255,255,255,0.35)",
                padding: "4px 16px 8px",
                textTransform: "uppercase",
              }}
            >
              {lang.devices_title ?? "DEVICES"}
            </Text>
            {devices.length === 0 ? (
              <Text
                style={{
                  padding: "6px 16px 10px",
                  fontSize: 12,
                  color: "rgba(255,255,255,0.3)",
                }}
              >
                {lang.devices_empty ?? "No devices available"}
              </Text>
            ) : (
              devices.map((dev) => {
                const isActive = activeDevice === dev.id;
                const DevIcon =
                  dev.type === "vehicle"
                    ? Car
                    : dev.type === "laptop"
                      ? Laptop
                      : dev.type === "zone"
                        ? RadioTower
                        : Headphones;
                return (
                  <UnstyledButton
                    key={dev.id}
                    onClick={() => handleSelectDevice(dev.id)}
                    style={{
                      display: "flex",
                      alignItems: "center",
                      gap: 10,
                      padding: "8px 14px 8px 12px",
                      width: "100%",
                      color: isActive ? PINK : "rgba(255,255,255,0.5)",
                      background: isActive
                        ? "var(--accent-soft)"
                        : "transparent",
                      borderLeft: isActive
                        ? `2px solid ${PINK}`
                        : "2px solid transparent",
                      transition: "background 0.15s, color 0.15s",
                    }}
                  >
                    <DevIcon size={14} style={{ flexShrink: 0 }} />
                    <Text
                      style={{
                        fontSize: 13,
                        flex: 1,
                        fontWeight: isActive ? 600 : 400,
                        color: isActive ? PINK : undefined,
                        fontFamily:
                          dev.type === "vehicle" ? "monospace" : "inherit",
                        letterSpacing:
                          dev.type === "vehicle" ? "0.05em" : undefined,
                      }}
                    >
                      {dev.label}
                    </Text>
                    {isActive && dev.type !== "headphones" && (
                      <Check size={13} style={{ flexShrink: 0, color: PINK }} />
                    )}
                    {isActive && dev.type === "headphones" && (
                      <Box
                        component="span"
                        title={
                          lang.devices_disconnect_headphones ??
                          "Disconnect headphones"
                        }
                        onClick={(e: React.MouseEvent) => {
                          e.stopPropagation();
                          handleSelectDevice("laptop");
                        }}
                        style={{
                          display: "flex",
                          alignItems: "center",
                          justifyContent: "center",
                          width: 18,
                          height: 18,
                          borderRadius: 4,
                          flexShrink: 0,
                          color: PINK,
                          cursor: "pointer",
                          transition: "background 0.12s",
                        }}
                        onMouseEnter={(e: React.MouseEvent) =>
                          ((e.currentTarget as HTMLElement).style.background =
                            "rgba(255,62,108,0.18)")
                        }
                        onMouseLeave={(e: React.MouseEvent) =>
                          ((e.currentTarget as HTMLElement).style.background =
                            "transparent")
                        }
                      >
                        <X size={12} />
                      </Box>
                    )}
                  </UnstyledButton>
                );
              })
            )}

            {activeDeviceObj && (
              <Text
                style={{
                  fontSize: 10,
                  color: "rgba(255,255,255,0.22)",
                  padding: "6px 16px 4px",
                  borderTop: "1px solid rgba(255,255,255,0.06)",
                  marginTop: 4,
                }}
              >
                {lang.devices_playing_in ?? "Playing on"}{" "}
                <span style={{ color: PINK }}>{activeDeviceObj.label}</span>
              </Text>
            )}
          </Popover.Dropdown>
        </Popover>

        <Box style={{ width: 8 }} />
        <Tooltip
          label={lang.mini_player_toggle ?? "Mini Player"}
          position="top"
          withArrow
          styles={{
            tooltip: { fontSize: 11, padding: "3px 8px", background: "rgba(14,17,28,0.97)", border: "1px solid rgba(255,255,255,0.09)", color: "#fff" },
            arrow: { background: "rgba(14,17,28,0.97)", border: "1px solid rgba(255,255,255,0.09)" },
          }}
        >
          <ActionIcon
            variant="transparent"
            size="sm"
            onClick={() => toggleMiniPlayer().then((r) => r && setMiniPlayerActive(r.visible))}
            className={classes.controlBtn}
            style={{ position: "relative" }}
          >
            <PictureInPicture2
              size={15}
              style={{ color: miniPlayerActive ? "var(--accent)" : "var(--text-secondary)" }}
            />
            {miniPlayerActive && (
              <span
                style={{
                  position: "absolute",
                  bottom: -3,
                  left: "50%",
                  transform: "translateX(-50%)",
                  width: 3,
                  height: 3,
                  borderRadius: "50%",
                  background: "var(--accent)",
                }}
              />
            )}
          </ActionIcon>
        </Tooltip>

        <Box
          style={{
            width: 1,
            height: 16,
            background: "rgba(255,255,255,0.1)",
            margin: "0 10px",
          }}
        />

        <Volume2 size={15} color="var(--text-secondary, #8b9bb4)" />
        <Box style={{ width: 6 }} />
        <Slider
          value={player.volume}
          onChange={handleVolumeChange}
          label={(v) => `${Math.round(v)}%`}
          size={3}
          w={90}
          styles={{
            track: { backgroundColor: "rgba(255,255,255,0.1)" },
            bar: { backgroundColor: "rgba(255,255,255,0.5)" },
            thumb: {
              backgroundColor: "#fff",
              borderColor: "#fff",
              width: 10,
              height: 10,
            },
          }}
        />
      </Group>
    </Box>
  );
};
