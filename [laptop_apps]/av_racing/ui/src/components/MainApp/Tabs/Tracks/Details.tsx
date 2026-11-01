import {
  Modal,
  Text,
  Stack,
  Grid,
  Switch,
  Group,
  Box,
  Select,
  Tooltip,
} from "@mantine/core";
import { RecordsType, TrackType } from "../../../../types/types";
import { useMemo, useState, useEffect, lazy, Suspense } from "react";

const MapZone = lazy(() =>
  import("../../Map/Map").then((m) => ({ default: m.MapZone })),
);
import { Flag } from "lucide-react";
import { calculateDistance } from "../../../../hooks/calculateDistance";
import { Loading } from "../../../Loading";
import { RecordComponent } from "../../../Records/RecordComponent";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../../reducers/atoms";
import global from "../../../../global.module.css";
import { fetchNui, isEnvBrowser } from "../../../../hooks/useNuiEvents";
import classes from "./style.module.css";

interface Properties {
  track: TrackType;
  handleClose: () => void;
  isAdmin?: boolean;
}

const fmt = (ms: number) => {
  const m = Math.floor((ms / (60 * 1000)) % 60);
  const s = Math.floor((ms / 1000) % 60);
  const cs = String(ms % 1000).slice(0, 2);
  return `${m}:${s < 10 ? "0" + s : s}.${cs}`;
};

type Split = number | { t: number; lap?: number };
interface RunPoint {
  x: number;
  y: number;
  s: number;
  z?: number;
  l?: number;
}
interface Run {
  time: number;
  splits: Split[];
  path: RunPoint[];
  crashes: { x: number; y: number; l?: number }[];
  laps?: number;
}
interface Telemetry {
  last?: Run | null;
  best?: Run | null;
}

const splitT = (s: Split) => (typeof s === "number" ? s : s.t);
const splitLap = (s: Split) => (typeof s === "number" ? 1 : (s.lap ?? 1));

const MOCK_TELE: Telemetry = {
  last: {
    time: 128450,
    splits: [21200, 45900, 72300, 101800, 128450],
    path: [
      { x: 0, y: 0, s: 40 },
      { x: 40, y: 20, s: 120 },
      { x: 90, y: 10, s: 60 },
      { x: 140, y: -30, s: 150 },
      { x: 180, y: -80, s: 90 },
    ],
    crashes: [{ x: 90, y: 10 }],
  },
  best: {
    time: 121000,
    splits: [20800, 44100, 69900, 97600, 121000],
    path: [],
    crashes: [],
  },
};

export const Details = ({ track, handleClose, isAdmin }: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const mappedCheckpoints = useMemo(() => {
    if (!track.checkpoints || track.checkpoints.length === 0) {
      return [];
    }
    const filteredPoints: any[] = [];
    filteredPoints.push({
      originalIndex: 0,
      checkpointData: track.checkpoints[0],
    });

    for (let i = 1; i < track.checkpoints.length; i++) {
      const prevCheckpoint =
        filteredPoints[filteredPoints.length - 1].checkpointData;
      const currentCheckpoint = track.checkpoints[i];
      const distance = calculateDistance(prevCheckpoint, currentCheckpoint);
      if (distance > 50) {
        filteredPoints.push({
          originalIndex: i,
          checkpointData: currentCheckpoint,
        });
      }
    }
    return filteredPoints;
  }, [track.checkpoints]);

  const loading =
    !mappedCheckpoints.length && (track?.checkpoints?.length ?? 0) > 0;

  const [telem, setTelem] = useState<Telemetry | null>(
    isEnvBrowser() ? MOCK_TELE : null,
  );
  const [showRun, setShowRun] = useState(true);
  const [leftTab, setLeftTab] = useState<"leaderboard" | "runs">("leaderboard");
  const [lap, setLap] = useState<number>(1);

  useEffect(() => {
    if (isEnvBrowser() || isAdmin) return;
    fetchNui<Telemetry>("av_racing", "getTelemetry", {
      track: track.identifier,
    }).then((resp) => setTelem(resp && resp.last ? resp : null));
  }, [track.identifier, isAdmin]);

  const lapsAvailable = useMemo(() => {
    const last = telem?.last;
    const set = new Set<number>();
    last?.splits?.forEach((sp) => set.add(splitLap(sp)));
    last?.path?.forEach((pt) => set.add(pt.l ?? 1));
    const arr = Array.from(set).sort((a, b) => a - b);
    return arr.length ? arr : [1];
  }, [telem]);

  useEffect(() => {
    setLap(lapsAvailable[0] ?? 1);
  }, [lapsAvailable]);

  const panelHeight = 540;
  const [records, setRecords] = useState<RecordsType | undefined>();

  useEffect(() => {
    if (isAdmin) return;
    fetchNui<RecordsType>("av_racing", "getRecords", track.identifier).then(
      (resp) => resp && setRecords(resp),
    );
  }, [track.identifier, isAdmin]);

  const trackRecord = useMemo(() => {
    if (!records) return null;
    let best: { time: string; ms: number; cls: string } | null = null;
    Object.entries(records).forEach(([cls, list]) => {
      (list ?? []).forEach((entry: any) => {
        const ms = Number(entry?.miliseconds);
        if (!ms) return;
        if (!best || ms < best.ms) {
          best = { time: entry.bestTime, ms, cls };
        }
      });
    });
    return best as { time: string; ms: number; cls: string } | null;
  }, [records]);

  const sectors = useMemo(() => {
    const last = telem?.last;
    if (!last?.splits?.length) return [];
    const build = (splits: Split[]) => {
      let prev = 0;
      const perLap: Record<number, number> = {};
      return splits.map((sp) => {
        const t = splitT(sp);
        const lp = splitLap(sp);
        const seg = t - prev;
        prev = t;
        perLap[lp] = (perLap[lp] ?? 0) + 1;
        return { lap: lp, idx: perLap[lp], seg };
      });
    };

    const lastSegs = build(last.splits);
    const bestSegs = telem?.best?.splits ? build(telem.best.splits) : [];
    const bestMap = new Map(bestSegs.map((b) => [b.idx, b.seg]));

    return lastSegs
      .filter((sg) => sg.lap === lap)
      .map((sg) => {
        const segBest = bestMap.get(sg.idx);
        const delta = segBest !== undefined ? sg.seg - segBest : null;
        return { index: sg.idx, seg: sg.seg, delta };
      });
  }, [telem, lap]);

  const lapPath = useMemo(() => {
    const p = telem?.last?.path;
    if (!p) return undefined;
    const tagged = p.some((pt) => pt.l !== undefined);
    return tagged ? p.filter((pt) => (pt.l ?? 1) === lap) : p;
  }, [telem, lap]);

  const lapCrashes = useMemo(() => {
    const c = telem?.last?.crashes;
    if (!c) return undefined;
    const tagged = c.some((ct) => ct.l !== undefined);
    return tagged ? c.filter((ct) => (ct.l ?? 1) === lap) : c;
  }, [telem, lap]);

  const hasRun = !!telem?.last?.path?.length;

  return (
    <Modal
      classNames={global}
      opened
      size="100%"
      centered
      lockScroll={false}
      c="white"
      trapFocus={false}
      title={
        <Box className={classes.dHeader}>
          <Text fw={600}>{track?.name}</Text>
          {track?.type && (
            <Text className={classes.dChip}>{track.type}</Text>
          )}
          {track?.isRanked && (
            <Text className={`${classes.dChip} ${classes.dChipOn}`}>
              {lang.ranked ?? "Ranked"}
            </Text>
          )}
        </Box>
      }
      onClose={handleClose}
      styles={{
        content: {
          maxWidth: "1200px",
          backdropFilter: isAdmin ? "none" : "blur(10px)",
        },
      }}
    >
      {loading ? (
        <Loading />
      ) : (
        <Grid>
          {!isAdmin && (
            <Grid.Col span={6}>
              <Stack>
                <Box className={classes.dStats}>
                  <Box className={classes.dStat}>
                    <Text className={classes.dStatLabel}>
                      {lang.distance ?? "Distance"}
                    </Text>
                    <Text className={classes.dStatValue}>
                      {track?.distance
                        ? `${(Number(track.distance) / 1000).toFixed(2)} km`
                        : "—"}
                    </Text>
                  </Box>
                  <Box className={classes.dStat}>
                    <Text className={classes.dStatLabel}>
                      {lang.checkpoints ?? "Checkpoints"}
                    </Text>
                    <Text className={classes.dStatValue}>
                      {track?.checkpointTotal ?? mappedCheckpoints.length}
                    </Text>
                  </Box>
                  <Box className={classes.dStat}>
                    <Text className={classes.dStatLabel}>
                      {lang.record ?? "Record"}
                    </Text>
                    <Text
                      className={`${classes.dStatValue} ${trackRecord ? classes.dStatAccent : ""}`}
                    >
                      {trackRecord ? trackRecord.time : "—"}
                      {trackRecord && (
                        <Text component="span" className={classes.dStatBadge}>
                          {trackRecord.cls}
                        </Text>
                      )}
                    </Text>
                  </Box>
                </Box>

                <Box className={classes.segmented}>
                  {(
                    [
                      ["leaderboard", lang.leaderboard_tab ?? "Leaderboard"],
                      ["runs", lang.my_runs ?? "My Runs"],
                    ] as const
                  ).map(([key, label]) => (
                    <Text
                      key={key}
                      className={`${classes.segment} ${leftTab === key ? classes.segmentOn : ""}`}
                      onClick={() => setLeftTab(key)}
                    >
                      {label}
                    </Text>
                  ))}
                </Box>

                {leftTab === "leaderboard" ? (
                  <Box
                    mah={panelHeight - 150}
                    style={{ overflowY: "auto", paddingRight: 4 }}
                  >
                  <RecordComponent
                    records={records}
                    identifier={track.identifier}
                    isAdmin={false}
                  />
                  </Box>
                ) : telem?.last ? (
                  <Stack gap={6}>
                    <Group justify="space-between" align="center">
                      {lapsAvailable.length > 1 ? (
                        <Select
                          size="xs"
                          w={110}
                          value={String(lap)}
                          onChange={(v) => v && setLap(Number(v))}
                          allowDeselect={false}
                          data={lapsAvailable.map((l) => ({
                            value: String(l),
                            label: `${lang.lap ?? "Lap"} ${l}`,
                          }))}
                          styles={{
                            input: {
                              backgroundColor: "var(--bg-panel)",
                              border: "1px solid var(--border-color)",
                              color: "var(--text-main)",
                            },
                            dropdown: {
                              backgroundColor: "var(--bg-panel)",
                              border: "1px solid var(--border-color)",
                            },
                            option: { color: "var(--text-main)" },
                          }}
                        />
                      ) : (
                        <span />
                      )}
                      <Switch
                        size="xs"
                        checked={showRun}
                        onChange={(e) => setShowRun(e.currentTarget.checked)}
                        label={lang.show_on_map ?? "Show on map"}
                      />
                    </Group>
                    <Group
                      justify="space-between"
                      style={{ padding: "2px 8px", paddingRight: 12 }}
                    >
                      <Text
                        fz="10px"
                        fw={700}
                        c="var(--text-dim)"
                        tt="uppercase"
                        style={{ letterSpacing: "0.5px" }}
                      >
                        {lang.checkpoint ?? "Checkpoint"}
                      </Text>
                      <Group gap={10}>
                        <Tooltip
                          label={
                            lang.hdr_time_help ??
                            "Time to complete this checkpoint"
                          }
                          bg="var(--tooltip)"
                          c="var(--text-main)"
                          withArrow
                          multiline
                          w={190}
                        >
                          <Text
                            fz="10px"
                            fw={700}
                            c="var(--text-dim)"
                            tt="uppercase"
                            style={{
                              letterSpacing: "0.5px",
                              minWidth: 56,
                              textAlign: "right",
                              cursor: "help",
                            }}
                          >
                            {lang.hdr_time ?? "Time"}
                          </Text>
                        </Tooltip>
                        <Tooltip
                          bg="var(--tooltip)"
                          c="var(--text-main)"
                          label={
                            lang.hdr_delta_help ??
                            "Difference vs your best run — green is faster, red is slower"
                          }
                          withArrow
                          multiline
                          w={190}
                        >
                          <Text
                            fz="10px"
                            fw={700}
                            c="var(--text-dim)"
                            tt="uppercase"
                            style={{
                              letterSpacing: "0.5px",
                              minWidth: 56,
                              textAlign: "right",
                              cursor: "help",
                              borderBottom: "1px dotted var(--text-dim)",
                            }}
                          >
                            {lang.hdr_delta ?? "vs Best"}
                          </Text>
                        </Tooltip>
                      </Group>
                    </Group>
                    <Box
                      mah={panelHeight - 210}
                      style={{ overflowY: "auto", paddingRight: 4 }}
                    >
                      {sectors.map((sec) => (
                        <Group
                          key={sec.index}
                          justify="space-between"
                          style={{
                            padding: "4px 8px",
                            borderBottom: "1px solid var(--border-color)",
                          }}
                        >
                          <Text fz="xs" c="gray.3">
                            {(lang.checkpoint ?? "Checkpoint") +
                              " " +
                              sec.index}
                          </Text>
                          <Group gap={10}>
                            <Text
                              fz="xs"
                              c="gray.1"
                              fw={600}
                              style={{ minWidth: 56, textAlign: "right" }}
                            >
                              {fmt(sec.seg)}
                            </Text>
                            <Text
                              fz="xs"
                              fw={700}
                              c={
                                sec.delta === null
                                  ? "gray.6"
                                  : sec.delta <= 0
                                    ? "teal.4"
                                    : "red.4"
                              }
                              style={{ minWidth: 56, textAlign: "right" }}
                            >
                              {sec.delta === null
                                ? "—"
                                : (sec.delta <= 0 ? "-" : "+") +
                                  fmt(Math.abs(sec.delta))}
                            </Text>
                          </Group>
                        </Group>
                      ))}
                    </Box>
                  </Stack>
                ) : (
                  <Box className={classes.emptyState}>
                    <Flag size={26} color="var(--text-dim)" />
                    <Text className={classes.emptyText}>
                      {lang.no_runs_track ??
                        "You haven't completed a race on this track yet."}
                    </Text>
                  </Box>
                )}
              </Stack>
            </Grid.Col>
          )}
          <Grid.Col span="auto" h={panelHeight}>
            <Box className={classes.mapFrame}>
            <Suspense fallback={null}>
              <MapZone
                checkpoints={mappedCheckpoints.map((mc) => mc.checkpointData)}
                runLine={showRun && hasRun ? lapPath : undefined}
                crashes={showRun && hasRun ? lapCrashes : undefined}
              />
            </Suspense>
            </Box>
          </Grid.Col>
        </Grid>
      )}
    </Modal>
  );
};
