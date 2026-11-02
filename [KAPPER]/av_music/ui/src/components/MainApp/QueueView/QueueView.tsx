import { useState, useEffect, useCallback } from "react";
import {
  Box,
  Text,
  Group,
  ScrollArea,
  ActionIcon,
  Image,
  Loader,
  Divider,
} from "@mantine/core";
import { ListOrdered, X, Music, RefreshCw, Clock3 } from "lucide-react";
import { useAtomValue, useAtom } from "jotai";
import {
  activeDeviceAtom,
  deviceQueueAtom,
  queueIndexAtom,
  playerAtom,
  Lang,
  devicesAtom,
} from "../../../reducers/atoms";
import {
  getDeviceQueue,
  removeFromQueue,
  playerControl,
} from "../../../Api/Api";
import { Track } from "../../../types/types";
import classes from "../style.module.css";
import own from "./style.module.css";

const fmtDuration = (secs: number) => {
  if (!secs) return "0:00";
  return `${Math.floor(secs / 60)}:${(secs % 60).toString().padStart(2, "0")}`;
};

export const QueueView = () => {
  const activeDevice = useAtomValue(activeDeviceAtom);
  const devices = useAtomValue(devicesAtom);
  const lang: any = useAtomValue(Lang);
  const player = useAtomValue(playerAtom);
  const [tracks, setTracks] = useAtom(deviceQueueAtom);
  const [queueIndex, setQueueIdx] = useAtom(queueIndexAtom);
  const [loading, setLoading] = useState(false);

  const fetchQueue = useCallback(async () => {
    setLoading(true);
    try {
      const result = await getDeviceQueue(activeDevice);
      setTracks(result?.queue ?? []);
      setQueueIdx(result?.queueIndex ?? 0);
    } finally {
      setLoading(false);
    }
  }, [activeDevice]);

  useEffect(() => {
    fetchQueue();
  }, [player.track?.videoId]);

  useEffect(() => {
    fetchQueue();
  }, [activeDevice]);

  useEffect(() => {
    fetchQueue();
  }, []);

  useEffect(() => {
    const handler = (ev: MessageEvent) => {
      const { action, queue, queueIndex } = ev.data ?? {};
      if (action === "queueChanged") {
        fetchQueue();
      } else if (action === "queueData") {
        setTracks(queue ?? []);
        setQueueIdx(queueIndex ?? 0);
      }
    };
    window.addEventListener("message", handler);
    return () => window.removeEventListener("message", handler);
  }, [fetchQueue]);

  const handlePlay = async (idx: number) => {
    await playerControl("skipToIndex", idx + 1);
  };

  const handleRemove = async (idx: number) => {
    const result = await removeFromQueue(idx + 1);
    if (result?.ok) {
      setTracks((prev) => prev.filter((_, i) => i !== idx));
      if (queueIndex > idx + 1) setQueueIdx((q) => q - 1);
    }
  };

  const activeDeviceObj = devices.find((d) => d.id === activeDevice);
  const deviceLabel =
    activeDevice === "laptop"
      ? "Laptop"
      : activeDevice === "headphones"
        ? "Headphones"
        : (activeDeviceObj?.label ?? activeDevice.toUpperCase());

  return (
    <Box className={classes.mainView}>
      <Box className={own.queueHeader}>
        <Group justify="space-between" align="center">
          <Box>
            <Box className={classes.headerLeft}>
              <ListOrdered color="var(--accent)" size={18} />
              <Text className={own.queueTitle}>
                {lang.queue_title ?? "Device Queue"}
              </Text>
            </Box>
            <Text className={own.queueSubtitle}>
              {deviceLabel} · {tracks.length}{" "}
              {tracks.length === 1
                ? (lang.queue_track_singular ?? "track")
                : (lang.queue_track_plural ?? "tracks")}
            </Text>
          </Box>
          <ActionIcon
            variant="transparent"
            size="sm"
            onClick={fetchQueue}
            style={{ color: "var(--text-secondary)" }}
            title={lang.queue_refresh ?? "Refresh queue"}
          >
            <RefreshCw size={14} />
          </ActionIcon>
        </Group>
      </Box>

      {loading ? (
        <Box className={own.loadingBox}>
          <Loader size="sm" color="gray" />
        </Box>
      ) : tracks.length === 0 ? (
        <Box className={own.emptyBox}>
          <Music size={30} style={{ opacity: 0.25 }} />
          <Text className={own.emptyText}>
            {lang.queue_empty ?? "Queue is empty"}
          </Text>
          <Text className={own.emptyTextSub}>
            {lang.queue_empty_sub ?? "Search a song and press Add to Queue"}
          </Text>
        </Box>
      ) : (
        <ScrollArea style={{ flex: 1 }} scrollbarSize={4}>
          <Group
            className={classes.trackListHeader}
            px={16}
            mb={8}
            wrap="nowrap"
            gap="md"
          >
            <Text w={28} ta="center" fz="xs" fw={600} tt="uppercase" c="dimmed">
              #
            </Text>
            <Box style={{ flex: 1, minWidth: 0, paddingLeft: 46 }}>
              <Text fz="xs" fw={600} tt="uppercase" c="dimmed">
                Title
              </Text>
            </Box>
            <Box w={45} style={{ display: "flex", justifyContent: "flex-end" }}>
              <Clock3 size={14} color="gray" />
            </Box>
            <Box w={28} />
          </Group>
          <Divider className={classes.trackListDivider} mb={4} />

          {tracks.map((track: Track, i: number) => {
            const isCurrent = i + 1 === queueIndex;
            return (
              <Group
                key={track.videoId || i}
                className={`${classes.trackRow} ${isCurrent ? classes.trackRowActive : ""}`}
                px={16}
                wrap="nowrap"
                gap="md"
                style={{ cursor: "pointer" }}
                onClick={() => handlePlay(i)}
              >
                <Text
                  className={classes.trackIndex}
                  w={28}
                  ta="center"
                  style={{ color: isCurrent ? "var(--accent)" : undefined }}
                >
                  {isCurrent ? <span className={classes.playingDot} /> : i + 1}
                </Text>

                <Group gap={10} style={{ flex: 1, minWidth: 0 }} wrap="nowrap">
                  <Image
                    src={track.cover}
                    w={36}
                    h={36}
                    radius={4}
                    style={{ objectFit: "cover", flexShrink: 0 }}
                  />
                  <Box style={{ minWidth: 0, overflow: "hidden" }}>
                    <Text
                      className={`${classes.trackName} ${isCurrent ? classes.trackNameActive : ""}`}
                      fz="sm"
                      fw={500}
                      style={{
                        overflow: "hidden",
                        textOverflow: "ellipsis",
                        whiteSpace: "nowrap",
                      }}
                    >
                      {track.title}
                    </Text>
                    <Text
                      className={classes.trackArtistSmall}
                      fz="xs"
                      c="dimmed"
                      mt={2}
                    >
                      {track.artist}
                    </Text>
                  </Box>
                </Group>

                <Text
                  className={classes.trackDuration}
                  w={45}
                  fz="sm"
                  c="dimmed"
                  ta="right"
                >
                  {fmtDuration(track.durationSecs)}
                </Text>

                <Box
                  w={28}
                  style={{ display: "flex", justifyContent: "center" }}
                  onClick={(e) => e.stopPropagation()}
                >
                  <ActionIcon
                    variant="transparent"
                    size="sm"
                    onClick={() => handleRemove(i)}
                    className={classes.addToPlaylistBtn}
                    style={{ color: "var(--text-secondary)" }}
                    title={lang.btn_remove ?? "Remove"}
                  >
                    <X size={14} />
                  </ActionIcon>
                </Box>
              </Group>
            );
          })}
        </ScrollArea>
      )}
    </Box>
  );
};
