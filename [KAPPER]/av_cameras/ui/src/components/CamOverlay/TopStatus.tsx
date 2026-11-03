import { Group, Stack, Text, Flex, Box } from "@mantine/core";
import { useAtomValue } from "jotai";
import { Lang } from "../../reducers/atoms";
import {
  UI_COLOR,
  UI_DIM_COLOR,
  DANGER_COLOR,
  formatTime,
  formatDate,
} from "./utils";
import classes from "./style.module.css";

export const TopStatusArea = ({
  activeCam,
  isPaused,
  isRecording,
  time,
}: any) => {
  const lang: any = useAtomValue(Lang);

  if (!activeCam) {
    return (
      <Group justify="space-between" className={classes.topBar}>
        <Text ff="var(--font-mono)" fz={11} c={UI_COLOR} lts="0.08em">
          {lang.no_active_camera}
        </Text>
      </Group>
    );
  }
  return (
    <Group justify="space-between" className={classes.topBar}>
      <Stack gap={1}>
        <Text ff="var(--font-mono)" fz={11} c={UI_COLOR} lts="0.08em">
          {lang.cam} {activeCam.label}
        </Text>
        <Text
          ff="var(--font-mono)"
          fz={9}
          c={UI_DIM_COLOR}
          lts="0.06em"
          tt="uppercase"
        >
          {activeCam.location}
        </Text>
      </Stack>
      <Flex
        align="center"
        gap={5}
        style={{
          background: "rgba(0,0,0,0.35)",
          border: "1px solid rgba(220,230,240,0.12)",
          borderRadius: 4,
          padding: "3px 9px",
        }}
      >
        <Box
          className={`${classes.liveDot} ${isPaused ? "" : classes.liveDotPulsing}`}
          style={{ backgroundColor: isPaused ? UI_DIM_COLOR : DANGER_COLOR }}
        />
        <Text ff="var(--font-mono)" fz={10} c={UI_COLOR} lts="0.1em">
          {isPaused ? lang.pause : isRecording ? lang.rec : lang.live}
        </Text>
      </Flex>
      <Stack align="flex-end" gap={1}>
        <Text ff="var(--font-mono)" fz={14} c={UI_COLOR} lts="0.04em">
          {formatTime(time)}
        </Text>
        <Text ff="var(--font-mono)" fz={9} c={UI_DIM_COLOR} lts="0.06em">
          {formatDate(time)}
        </Text>
      </Stack>
    </Group>
  );
};
