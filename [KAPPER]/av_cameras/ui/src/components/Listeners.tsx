import { useRef } from "react";
import { useNuiEvent } from "../hooks/useNuiEvents";
import { useGameViewWithRecording } from "../hooks/gameView";

export const Listeners = () => {
  const canvasRef = useRef<any>(null);
  const { takePhoto } = useGameViewWithRecording(canvasRef);
  useNuiEvent("takePhoto", () => {
    takePhoto("");
  });
  return <canvas ref={canvasRef} style={{ display: "none" }}></canvas>;
};
