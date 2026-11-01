import { useEffect, useState } from "react";
import { Box, Text, Flex, Stack, Group } from "@mantine/core";
import { useNuiEvent, fetchNui, isEnvBrowser } from "../../hooks/useNuiEvents";
import { UndergroundType } from "./types";
import { ApiUnderground } from "../../Api/Underground";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";
import classes from "./style.module.css";

interface StatProps {
  value: string | undefined;
  label: string;
}

function Stat({ value, label }: StatProps) {
  return (
    <Box className={classes.stat}>
      <Text className={classes.statVal}>{value ?? "—"}</Text>
      <Text className={classes.statLbl}>{label}</Text>
    </Box>
  );
}

export const Underground = () => {
  const lang: any = useRecoilValue(Lang);
  const [playerInfo, setPlayerInfo] = useState<UndergroundType | null>(
    isEnvBrowser() ? ApiUnderground : null,
  );
  const CONTROLS = [
    { label: lang.previous ?? "Previous", key: "←" },
    { label: lang.next ?? "Next", key: "→" },
    { label: lang.exit ?? "Exit", key: "ESC" },
  ];
  useNuiEvent("slotInfo", (data: UndergroundType) => {
    setPlayerInfo(data);
  });

  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      switch (e.code) {
        case "Escape":
        case "Backspace":
          fetchNui("av_racing", "exitUnderground");
          break;
        case "ArrowLeft":
          fetchNui("av_racing", "leftCam");
          break;
        case "ArrowRight":
          fetchNui("av_racing", "rightCam");
          break;
      }
    };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, []);

  if (!playerInfo) return null;

  const driftPts = (playerInfo as any)?.driftPoints;
  const isDrift = typeof driftPts === "number" && driftPts > 0;

  const stats = [
    { value: playerInfo?.settings?.nationality, label: lang?.nationality },
    ...(playerInfo?.crew
      ? [{ value: playerInfo?.crew?.label, label: lang?.crew }]
      : []),
    { value: playerInfo?.vehicle, label: lang?.vehicle },
    {
      value: isDrift ? driftPts.toLocaleString() : playerInfo?.bestTime,
      label: isDrift ? (lang?.points ?? "POINTS") : lang?.best_lap,
    },
    { value: playerInfo?.time, label: lang?.total_time },
  ];

  return (
    <Box className={classes.container}>
      <Box className={classes.accentLine} />
      <Flex className={classes.top} justify="space-between" align="flex-start">
        <Stack className={classes.eventBlock} gap={2}>
          <Text className={classes.eventName}>{playerInfo?.title}</Text>
          <Text className={classes.eventTrack}>{playerInfo?.trackName}</Text>
        </Stack>
        <Stack className={classes.nameBlock} align="flex-end" gap={6}>
          <Text className={classes.driverPosition}>
            # {playerInfo?.position}
          </Text>
          <Text className={classes.driverName}>{playerInfo?.name}</Text>
        </Stack>
      </Flex>
      <Box className={classes.center} />
      <Box className={classes.bottom}>
        <Flex className={classes.card}>
          {stats.map((s, idx) => (
            <Stat key={idx} value={s.value} label={s.label} />
          ))}
        </Flex>
        <Group className={classes.controls} justify="flex-end" gap={8}>
          {CONTROLS.map((c) => (
            <Flex key={c.key} className={classes.ctrl} align="center">
              <Text className={classes.ctrlLbl}>{c.label}</Text>
              <Text className={classes.ctrlKey}>{c.key}</Text>
            </Flex>
          ))}
        </Group>
      </Box>
    </Box>
  );
};
