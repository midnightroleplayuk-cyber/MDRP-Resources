import { Group, Text, Box, Button } from "@mantine/core";
import { Eye, Flame, Moon } from "lucide-react";
import { UI_COLOR, UI_DIM_COLOR, ACCENT_COLOR, DANGER_COLOR } from "./utils";
import { useAtomValue } from "jotai";
import { Lang } from "../../reducers/atoms";
import classes from "./style.module.css";

export const BottomControls = ({ actions, stats, stateProps }: any) => {
  const lang: any = useAtomValue(Lang);
  const { setVisionMode, toggleRecord } = actions;
  const { settings } = stats;
  const { visionMode, isRecording } = stateProps;

  const getBtnStyles = (condition: boolean, activeProps: any) => ({
    root: {
      height: 34,
      padding: "0 14px",
      background: "rgba(0,0,0,0.45)",
      border: "1px solid rgba(220,230,240,0.12)",
      color: UI_DIM_COLOR,
      fontFamily: "var(--font-family)",
      fontWeight: 600,
      letterSpacing: "0.06em",
      textTransform: "uppercase" as const,
      transition: "all 0.18s",
      "&:hover": {
        borderColor: "rgba(220,230,240,0.3)",
        color: UI_COLOR,
        background: "rgba(0,0,0,0.6)",
      },
      ...(condition ? activeProps : {}),
    },
  });

  return (
    <Group justify="center" align="center" className={classes.bottomBar}>
      <Group gap={8} justify="center">
        {(settings?.hasNightVision || settings?.hasThermalVision) && (
          <Button
            leftSection={<Eye size={13} />}
            variant="unstyled"
            onClick={() => setVisionMode("normal")}
            styles={getBtnStyles(visionMode === "normal", {
              background: "rgba(168,196,216,0.14)",
              borderColor: "rgba(168,196,216,0.4)",
              color: ACCENT_COLOR,
            })}
          >
            {lang.visionNormal}
          </Button>
        )}
        {settings?.hasThermalVision && (
          <Button
            leftSection={<Flame size={13} />}
            variant="unstyled"
            onClick={() => setVisionMode("thermal")}
            styles={getBtnStyles(visionMode === "thermal", {
              background: "rgba(180,100,60,0.14)",
              borderColor: "rgba(200,130,80,0.35)",
              color: "#c8926a",
            })}
          >
            {lang.visionThermal}
          </Button>
        )}
        {settings?.hasNightVision && (
          <Button
            leftSection={<Moon size={13} />}
            variant="unstyled"
            onClick={() => setVisionMode("night")}
            styles={getBtnStyles(visionMode === "night", {
              background: "rgba(80,140,100,0.12)",
              borderColor: "rgba(100,170,120,0.3)",
              color: "#80b898",
            })}
          >
            {lang.visionNight}
          </Button>
        )}
        <Box className={classes.btnSep} />
        <Button
          variant="unstyled"
          onClick={toggleRecord}
          styles={getBtnStyles(isRecording, {
            background: "rgba(217,122,122,0.12)",
            borderColor: "rgba(217,122,122,0.35)",
            color: DANGER_COLOR,
          })}
        >
          <Group gap={7}>
            <Box
              className={classes.liveDot}
              style={{
                backgroundColor: isRecording ? "currentColor" : UI_DIM_COLOR,
                animation: isRecording
                  ? "livepulse 1s ease-in-out infinite"
                  : "none",
              }}
            />
            <Text inherit>
              {isRecording ? lang.recordStop : lang.recordStart}
            </Text>
          </Group>
        </Button>
      </Group>
    </Group>
  );
};
