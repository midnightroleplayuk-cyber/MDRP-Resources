import { useState, useEffect, useRef } from "react";
import { Transition, Box, Flex, Group, Text } from "@mantine/core";
import { UI_DIM_COLOR, DANGER_COLOR, formatRecTime } from "./utils";
import { CameraEffects } from "./Effects";
import { TopStatusArea } from "./TopStatus";
import { CameraSwitcherPanel } from "./Switcher";
import { BottomControls } from "./Controls";
import { CameraType } from "../../types/types";
import { fetchNui, isEnvBrowser, useNuiEvent } from "../../hooks/useNuiEvents";
import { ApiCameras } from "../../Api/Cameras";
import { TargetProfile } from "./Profile/Profile";
import { Sidebar } from "./Sidebar/Sidebar";
import { useGameViewWithRecording } from "../../hooks/gameView";
import { useAtomValue } from "jotai";
import { Lang } from "../../reducers/atoms";
import classes from "./style.module.css";

export const CamOverlay = () => {
  const lang: any = useAtomValue(Lang);
  const [loaded, setLoaded] = useState(false);
  const [allCameras, setAllCameras] = useState<CameraType[]>(
    isEnvBrowser() ? ApiCameras : [],
  );
  const [time, setTime] = useState(new Date());
  const [visionMode, setVisionMode] = useState<"normal" | "thermal" | "night">(
    "normal",
  );
  const [isRecording, setIsRecording] = useState(false);
  const [recSeconds, setRecSeconds] = useState(0);
  const [battery, setBattery] = useState(87);
  const [switcherOpen, setSwitcherOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const [activeCam, setActiveCam] = useState<CameraType | null>(
    isEnvBrowser() ? ApiCameras[0] : null,
  );
  const searchInputRef = useRef<HTMLInputElement>(null);
  const [zoom, setZoom] = useState(30);
  const [opacity, setOpacity] = useState(1.0);
  const canvasRef = useRef<any>(null);
  const { startRecording, stopRecording } = useGameViewWithRecording(
    canvasRef,
    setIsRecording,
  );

  const handleVisionModeChange = (mode: "normal" | "thermal" | "night") => {
    setVisionMode(mode);
    if (isEnvBrowser()) return;
    fetchNui("av_cameras", "setVisionMode", mode);
  };

  useNuiEvent(
    "setOverlay",
    (data: { cameras: CameraType[]; active: CameraType }) => {
      setAllCameras(data.cameras);
      setActiveCam(data.active);
      setLoaded(true);
    },
  );

  useNuiEvent("pause", (state: boolean) => {
    setOpacity(state ? 0.0 : 1.0);
  });

  useNuiEvent("closeOverlay", () => {
    setLoaded(false);
    setActiveCam(null);
    setIsRecording(false);
    setRecSeconds(0);
    setBattery(100);
    setZoom(30);
    setVisionMode("normal");
  });

  useNuiEvent("updateZoom", (percentage: number) => {
    setZoom(percentage);
  });

  useEffect(() => {
    const clockTimer = setInterval(() => setTime(new Date()), 1000);
    return () => clearInterval(clockTimer);
  }, []);

  useEffect(() => {
    let recTimer: ReturnType<typeof setInterval>;
    if (isRecording) {
      recTimer = setInterval(() => setRecSeconds((prev) => prev + 1), 1000);
    }
    return () => clearInterval(recTimer);
  }, [isRecording]);

  useEffect(() => {
    let batTimer: ReturnType<typeof setInterval>;
    if (isRecording) {
      batTimer = setInterval(
        () => setBattery((prev) => (prev > 1 ? prev - 1 : prev)),
        30000,
      );
    }
    return () => clearInterval(batTimer);
  }, [isRecording]);

  useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (
        switcherOpen &&
        !(e.target as Element).closest(`.${classes.camSwitcherWrap}`)
      ) {
        setSwitcherOpen(false);
      }
    };
    document.addEventListener("click", handleClickOutside);
    return () => document.removeEventListener("click", handleClickOutside);
  }, [switcherOpen]);

  const toggleRecord = () => {
    if (!isRecording) {
      setIsRecording(true);
      setRecSeconds(0);
      startRecording(activeCam?.identifier || "unknown");
    } else {
      setIsRecording(false);
      stopRecording();
    }
  };

  const toggleSwitcher = () => {
    setSwitcherOpen(!switcherOpen);
    if (!switcherOpen) {
      setTimeout(() => searchInputRef.current?.focus(), 100);
    }
  };

  const visibleCams = allCameras
    .filter((c) => {
      const q = searchQuery.toLowerCase();
      return (
        c.label.toLowerCase().includes(q) ||
        c.location.toLowerCase().includes(q)
      );
    })
    .sort((a, b) => a.label.localeCompare(b.label));

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (!loaded) return;
      switch (e.key) {
        case "Escape":
          fetchNui("av_cameras", "closeOverlay");
          setTimeout(() => {
            setLoaded(false);
            setActiveCam(null);
            setIsRecording(false);
            setRecSeconds(0);
            setBattery(100);
            setZoom(0);
            setVisionMode("normal");
          }, 100);
          break;
        case "Shift":
          fetchNui("av_cameras", "toggleFocus");
          break;
        default:
          break;
      }
    };
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [loaded]);

  const handleSelectCam = (cam: CameraType) => {
    if (cam.status === "offline") return;
    setActiveCam(cam);
    fetchNui("av_cameras", "viewCamera", cam);
  };

  const getBadgeStyle = () => {
    if (visionMode === "thermal")
      return {
        color: "#c8926a",
        borderColor: "rgba(200,146,106,0.4)",
        background: "rgba(180,100,60,0.12)",
        text: lang.thermalVision,
      };
    if (visionMode === "night")
      return {
        color: "#80b898",
        borderColor: "rgba(128,184,152,0.4)",
        background: "rgba(80,140,100,0.12)",
        text: lang.nightVision,
      };
    return null;
  };

  const badgeProps = getBadgeStyle();

  return (
    <>
      <canvas ref={canvasRef} style={{ display: "none" }}></canvas>
      <Transition mounted={loaded} transition="fade" duration={200}>
        {(styles) => (
          <Box
            className={classes.overlayWrapper}
            style={{ ...styles, pointerEvents: loaded ? "auto" : "none" }}
            opacity={opacity}
          >
            <CameraEffects visionMode={visionMode} />
            <TargetProfile />
            <Box className={classes.overlay}>
              <TopStatusArea
                activeCam={activeCam}
                isRecording={isRecording}
                time={time}
              />
              <Box
                className={`${classes.reticle} ${zoom > 0 ? classes.reticleActive : ""}`}
                style={{
                  transform: `translate(-50%, -50%) scale(${1 - (zoom / 100) * 0.5})`,
                }}
              >
                <svg width="60" height="60" viewBox="0 0 60 60" fill="none">
                  <circle
                    cx="30"
                    cy="30"
                    r="20"
                    stroke="rgba(220,230,240,0.8)"
                    strokeWidth="0.5"
                  />
                  <line
                    x1="30"
                    y1="4"
                    x2="30"
                    y2="14"
                    stroke="rgba(220,230,240,0.8)"
                    strokeWidth="0.5"
                  />
                  <line
                    x1="30"
                    y1="46"
                    x2="30"
                    y2="56"
                    stroke="rgba(220,230,240,0.8)"
                    strokeWidth="0.5"
                  />
                  <line
                    x1="4"
                    y1="30"
                    x2="14"
                    y2="30"
                    stroke="rgba(220,230,240,0.8)"
                    strokeWidth="0.5"
                  />
                  <line
                    x1="46"
                    y1="30"
                    x2="56"
                    y2="30"
                    stroke="rgba(220,230,240,0.8)"
                    strokeWidth="0.5"
                  />
                  <circle
                    cx="30"
                    cy="30"
                    r="1.5"
                    fill="rgba(220,230,240,0.6)"
                  />
                </svg>
              </Box>
              {isRecording && (
                <Group
                  gap={5}
                  style={{
                    position: "absolute",
                    top: 54,
                    right: 54,
                    pointerEvents: "none",
                  }}
                >
                  <Box
                    className={`${classes.liveDot} ${classes.liveDotPulsing}`}
                  />
                  <Text
                    ff="var(--font-mono)"
                    fz={10}
                    c={DANGER_COLOR}
                    lts="0.08em"
                  >
                    {formatRecTime(recSeconds)}
                  </Text>
                </Group>
              )}
              {badgeProps && (
                <Box
                  style={{
                    position: "absolute",
                    top: 54,
                    left: 54,
                    padding: "3px 9px",
                    border: `1px solid ${badgeProps.borderColor}`,
                    borderRadius: 3,
                    background: badgeProps.background,
                    pointerEvents: "none",
                  }}
                >
                  <Text
                    ff="var(--font-mono)"
                    fz={9}
                    c={badgeProps.color}
                    lts="0.12em"
                    tt="uppercase"
                  >
                    {badgeProps.text}
                  </Text>
                </Box>
              )}
              <Flex
                direction="column"
                align="center"
                gap={6}
                className={`${classes.zoomIndicator} ${zoom > 0 ? classes.zoomIndicatorVis : ""}`}
              >
                <Text
                  ff="var(--font-mono)"
                  fz={8}
                  c={UI_DIM_COLOR}
                  lts="0.08em"
                  className={classes.ziLabel}
                >
                  {lang.zoom}
                </Text>
                <Box className={classes.ziTrack}>
                  <Box
                    className={classes.ziFill}
                    style={{ height: `${15 + zoom * 0.85}%` }}
                  />
                </Box>
                <Text ff="var(--font-mono)" fz={8} c={UI_DIM_COLOR}>
                  {((zoom / 100) * 9 + 1).toFixed(1)}×
                </Text>
              </Flex>
              <CameraSwitcherPanel
                switcherProps={{
                  switcherOpen,
                  toggleSwitcher,
                  searchQuery,
                  setSearchQuery,
                  handleSelectCam,
                  searchInputRef,
                  visibleCams,
                }}
                activeCamProps={{ activeCam }}
              />
              <BottomControls
                actions={{
                  setVisionMode: (mode: "normal" | "thermal" | "night") => {
                    handleVisionModeChange(mode);
                  },
                  toggleRecord,
                }}
                stats={{ battery, settings: activeCam?.settings }}
                stateProps={{ visionMode, isRecording }}
              />
              <Sidebar />
            </Box>
          </Box>
        )}
      </Transition>
    </>
  );
};
