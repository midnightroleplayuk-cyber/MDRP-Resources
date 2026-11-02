import { useState, useCallback, useEffect } from "react";
import {
  Box,
  Group,
  Text,
  ActionIcon,
  Slider,
  Transition,
} from "@mantine/core";
import { Play, Pause } from "lucide-react";
import { fetchNui, useNuiEvent } from "../../hooks/useNuiEvents";
import classes from "./style.module.css";

const formatTime = (seconds: number) => {
  const m = Math.floor(seconds / 60);
  const s = Math.floor(seconds % 60);
  return `${String(m).padStart(2, "0")}:${String(s).padStart(2, "0")}`;
};

export const Replay = () => {
  const [loaded, setLoaded] = useState(false);
  const [duration, setDuration] = useState(10);
  const [playing, setPlaying] = useState(false);
  const [progress, setProgress] = useState(0);
  const [frameCount, setFrameCount] = useState(0);
  const [title, setTitle] = useState("");
  const frameToSeconds = (frame: number) =>
    frameCount > 0 ? (frame / frameCount) * duration : 0;

  useNuiEvent(
    "replayData",
    (data: { duration: number; frameCount: number; title: string }) => {
      setDuration(data.duration);
      setFrameCount(data.frameCount);
      setProgress(0);
      setPlaying(false);
      setTitle(data.title);
      setLoaded(true);
    },
  );

  useNuiEvent("playbackEnded", () => {
    setPlaying(false);
    setProgress(0);
  });

  useNuiEvent(
    "frameUpdate",
    (data: {
      frameIdx: number;
      frameCount: number;
      timeSec: number;
      duration: number;
    }) => {
      setProgress(data.frameIdx);
    },
  );

  const handlePlayPause = useCallback(() => {
    const next = !playing;
    setPlaying(next);
    if (next) {
      fetchNui("av_cameras", "play");
    } else {
      fetchNui("av_cameras", "pause");
    }
  }, [playing, progress]);

  const handleScrubEnd = useCallback(
    (value: number) => {
      setProgress(value);
      fetchNui("av_cameras", "seek", value);
    },
    [playing],
  );

  const handleScrubChange = useCallback((value: number) => {
    setProgress(value);
  }, []);

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (!loaded) return;
      switch (e.key) {
        case "Escape":
          fetchNui("av_cameras", "closeReplay");
          setTimeout(() => {
            setLoaded(false);
          }, 100);
          break;
        default:
          break;
      }
    };
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [loaded]);

  return (
    <Transition
      mounted={loaded}
      transition="fade"
      duration={500}
      exitDuration={500}
      timingFunction="ease"
    >
      {(styles) => (
        <Box className={classes.box} style={styles}>
          <Group justify="space-between" mb={10} gap={0}>
            <Text c="var(--text-main)" fz="xs" ta="center">
              {title}
            </Text>
            <Text className={classes.timer}>
              {formatTime(frameToSeconds(progress))} / {formatTime(duration)}
            </Text>
          </Group>
          <Slider
            value={progress}
            min={0}
            max={frameCount}
            step={1.0}
            onChange={handleScrubChange}
            onChangeEnd={handleScrubEnd}
            size={3}
            thumbSize={13}
            classNames={{
              root: classes.sliderRoot,
              track: classes.sliderTrack,
              bar: classes.sliderBar,
              thumb: classes.sliderThumb,
            }}
          />
          <Group justify="center" gap={6}>
            <ActionIcon
              size={44}
              radius="xl"
              onClick={handlePlayPause}
              color="var(--accent)"
              variant="light"
              title={playing ? "Pause" : "Play"}
            >
              {playing ? (
                <Pause size={18} fill="#0a0a0c" />
              ) : (
                <Play size={18} fill="#0a0a0c" />
              )}
            </ActionIcon>
          </Group>
        </Box>
      )}
    </Transition>
  );
};
