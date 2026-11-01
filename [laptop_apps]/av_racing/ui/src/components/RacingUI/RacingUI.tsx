import { useState } from "react";
import { Box, Text, Stack, Group } from "@mantine/core";
import { useNuiEvent, isEnvBrowser } from "../../hooks/useNuiEvents";
import { DEFAULT_INFO, MOCK_INFO, RaceInfo, RacePlayer } from "./api";
import classes from "./style.module.css";

function fmtTime(ms: number): { main: string; millis: string } {
  const totalSecs = ms / 1000;
  const m = Math.floor(totalSecs / 60);
  const sec = Math.floor(totalSecs % 60)
    .toString()
    .padStart(2, "0");
  const millis = "." + (ms % 1000).toString().padStart(3, "0");
  return { main: `${m}:${sec}`, millis };
}

function fmtDelta(ms: number): string {
  const sign = ms > 0 ? "+" : ms < 0 ? "-" : "";
  const secs = Math.abs(ms) / 1000;
  return `${sign}${secs.toFixed(2)}`;
}

function fmtDist(d: number): string {
  const a = Math.abs(d);
  return a < 1000
    ? `${Math.round(a * 10) / 10}m`
    : `${Math.round(a / 100) / 10}km`;
}

function InfoRow({
  label,
  children,
  amber,
}: {
  label: string;
  children: React.ReactNode;
  amber?: boolean;
}) {
  return (
    <Box className={classes.infoRow}>
      <Text className={amber ? classes.labelAmber : classes.label}>
        {label}
      </Text>
      {children}
    </Box>
  );
}

function StandingsBlock({
  players = [],
  myPos,
}: {
  players: RacePlayer[];
  myPos: number;
}) {
  if (!players || players.length === 0) return null;
  const top3 = players.filter((p) => p.pos <= 3).sort((a, b) => a.pos - b.pos);
  const me = players.find((p) => p.pos === myPos);
  const meIsTop3 = myPos <= 3;

  function Row({
    p,
    isMe,
    index,
  }: {
    p: RacePlayer;
    isMe: boolean;
    index: number;
  }) {
    const isAhead = p.pos < myPos;
    const deltaLabel = isMe
      ? "— YOU —"
      : isAhead
        ? `+${fmtDist(p.dist)}`
        : `-${fmtDist(Math.abs(p.dist))}`;
    const deltaClass = isMe
      ? classes.sDeltaMe
      : isAhead
        ? classes.sDeltaAhead
        : classes.sDeltaBehind;
    const zebraClass = isMe
      ? classes.sRowMe
      : index % 2 === 0
        ? classes.sRowEven
        : classes.sRowOdd;

    return (
      <Group className={`${classes.sRow} ${zebraClass}`} gap={0} wrap="nowrap">
        <Text className={`${classes.sNum} ${isMe ? classes.sNumMe : ""}`}>
          {p.pos}
        </Text>
        <Text className={`${classes.sName} ${isMe ? classes.sNameMe : ""}`}>
          {p.name}
        </Text>
        <Text className={`${classes.sDelta} ${deltaClass}`}>{deltaLabel}</Text>
      </Group>
    );
  }

  return (
    <Stack gap={0}>
      {top3.map((p, i) => (
        <Box key={p.pos}>
          <Row p={p} isMe={meIsTop3 && p.pos === myPos} index={i} />
          {i < top3.length - 1 && <Box className={classes.sSep} />}
        </Box>
      ))}
      {!meIsTop3 && me && (
        <>
          <Group gap={6} className={classes.sGap}>
            <Box className={classes.sGapLine} />
            <Text className={classes.sGapDots}>···</Text>
            <Box className={classes.sGapLine} />
          </Group>
          <Row p={me} isMe index={top3.length} />
        </>
      )}
    </Stack>
  );
}

export const RacingUI = ({ lang }: { lang: any }) => {
  const [info, setInfo] = useState<RaceInfo>(
    isEnvBrowser() ? MOCK_INFO : DEFAULT_INFO,
  );

  useNuiEvent("updateUI", (data: RaceInfo) => setInfo(data));
  useNuiEvent(
    "hudUpdate",
    (data: {
      myPos: number;
      lap: number;
      checkpoint: number;
      players: RacePlayer[];
    }) => {
      setInfo((prev) => ({
        ...prev,
        Position: data.myPos || 0,
        CurrentLap: data.lap || 0,
        CurrentCheckpoint: data.checkpoint || 0,
        Players: data.players || [],
      }));
    },
  );
  const lap = fmtTime(info.Time);
  const best = fmtTime(info.BestLap);
  const timeLeft = fmtTime(info.DriftTimeLeft || 0);
  const pct =
    info.TotalCheckpoints > 0
      ? (info.CurrentCheckpoint / info.TotalCheckpoints) * 100
      : 0;
  const isTimeRunningOut = info.isDrift && (info.DriftTimeLeft || 0) <= 10000;
  const showCombo = info.isDrift && (info.Combo || 1.0) > 1.0;
  const gd = info.GhostDelta;
  const showGhost = !info.isDrift && gd !== null && gd !== undefined;
  const ghostStr = showGhost ? fmtDelta(gd as number) : "";
  const ghostClass = !showGhost
    ? ""
    : (gd as number) < -50
      ? classes.deltaAhead
      : (gd as number) > 50
        ? classes.deltaBehind
        : classes.deltaNeutral;

  return (
    <Box className={classes.wrapper}>
      <Box className={classes.hudWrap}>
        <Box className={classes.infoBlock}>
          <Stack gap={20}>
            <InfoRow label={lang?.lap ?? "LAP"}>
              <Group gap={6} align="baseline" justify="flex-end">
                <Text className={classes.lapCurrent}>{info.CurrentLap}</Text>
                <Text className={classes.lapSep}>/</Text>
                <Text className={classes.lapTotal}>{info.TotalLaps}</Text>
              </Group>
            </InfoRow>
            <InfoRow label={lang?.checkpoint ?? "CHECKPOINT"}>
              <Group gap={4} align="baseline" justify="flex-end">
                <Text className={classes.cpCurrent}>
                  {info.CurrentCheckpoint}
                </Text>
                <Text className={classes.cpSep}>/</Text>
                <Text className={classes.cpTotal}>{info.TotalCheckpoints}</Text>
              </Group>
              <Box className={classes.cpBarWrap}>
                <Box
                  className={classes.cpBarFill}
                  style={{ width: `${pct}%` }}
                />
              </Box>
            </InfoRow>
            <InfoRow
              label={
                info.isDrift
                  ? (lang?.time_left ?? "TIME LEFT")
                  : (lang?.lap_time ?? "LAP TIME")
              }
            >
              {info.isDrift ? (
                <Group gap={2} align="baseline" justify="flex-end">
                  <Text
                    className={`${classes.timerBig} ${isTimeRunningOut ? classes.timeWarning : ""}`}
                  >
                    {timeLeft.main}
                  </Text>
                  <Text
                    className={`${classes.timerMs} ${isTimeRunningOut ? classes.timeWarning : ""}`}
                  >
                    {timeLeft.millis}
                  </Text>
                </Group>
              ) : (
                <Group gap={2} align="baseline" justify="flex-end">
                  <Text className={classes.timerBig}>{lap.main}</Text>
                  <Text className={classes.timerMs}>{lap.millis}</Text>
                </Group>
              )}
            </InfoRow>
            <InfoRow
              label={
                info.isDrift
                  ? (lang?.points ?? "POINTS")
                  : (lang?.best_lap ?? "BEST")
              }
              amber
            >
              {info.isDrift ? (
                <Group gap={2} align="baseline" justify="flex-end">
                  <Text className={classes.bestBig}>
                    {(info.DriftPoints || 0).toLocaleString()}
                  </Text>
                </Group>
              ) : (
                <Group gap={2} align="baseline" justify="flex-end">
                  <Text className={classes.bestBig}>{best.main}</Text>
                  <Text className={classes.bestMs}>{best.millis}</Text>
                </Group>
              )}
            </InfoRow>

            {showGhost && (
              <InfoRow label={lang?.ghost ?? "GHOST"}>
                <Group gap={2} align="baseline" justify="flex-end">
                  <Text className={`${classes.deltaBig} ${ghostClass}`}>
                    {ghostStr}
                  </Text>
                </Group>
              </InfoRow>
            )}

            {showCombo && (
              <InfoRow label={lang?.combo ?? "COMBO"} amber>
                <Group gap={2} align="baseline" justify="flex-end">
                  <Text className={classes.bestBig}>
                    x{(info.Combo || 1.0).toFixed(1)}
                  </Text>
                </Group>
              </InfoRow>
            )}
          </Stack>
        </Box>
        <Box className={classes.standingsBlock}>
          <StandingsBlock players={info.Players} myPos={info.Position} />
        </Box>
      </Box>
    </Box>
  );
};
