import { Box } from "@mantine/core";
import classes from "./style.module.css";

interface Props {
  visionMode: string;
}

export const CameraEffects = ({ visionMode }: Props) => {
  const getCamBgFilter = () => {
    if (visionMode === "thermal")
      return "sepia(0.3) hue-rotate(-10deg) saturate(1.2)";
    if (visionMode === "night")
      return "brightness(1.3) saturate(0.2) hue-rotate(90deg)";
    return "none";
  };

  return (
    <>
      <Box className={classes.camBg} style={{ filter: getCamBgFilter() }} />
      <Box className={classes.scanlines} />
      <Box
        className={`${classes.visionLayer} ${classes.visionThermal} ${visionMode === "thermal" ? classes.visionLayerActive : ""}`}
      />
      <Box
        className={`${classes.visionLayer} ${classes.visionNight} ${visionMode === "night" ? classes.visionLayerActive : ""}`}
      />
      <Box className={classes.vignette} />
      <Box className={classes.overlay}>
        <Box className={classes.gridLines} />
      </Box>
      <Box className={classes.overlay}>
        <Box className={`${classes.corner} ${classes.cornerTl}`} />
        <Box className={`${classes.corner} ${classes.cornerTr}`} />
        <Box className={`${classes.corner} ${classes.cornerBl}`} />
        <Box className={`${classes.corner} ${classes.cornerBr}`} />
      </Box>
    </>
  );
};
