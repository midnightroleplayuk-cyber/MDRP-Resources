import { useCallback, useState } from "react";
import type { fabric } from "fabric";

import { animateZoomTo, clampZoom } from "../utils";

export interface UseZoomOptions {
  initialZoom?: number;
}

export interface UseZoomReturn {
  zoom: number;
  zoomIn: (factor?: number) => void;
  zoomOut: (factor?: number) => void;
  setZoom: (level: number) => void;
  resetZoom: () => void;
}

export function useZoom(
  canvasRef: React.MutableRefObject<fabric.Canvas | null>,
  options: UseZoomOptions = {}
): UseZoomReturn {
  const { initialZoom = 1 } = options;

  const [zoom, setZoomLevel] = useState(initialZoom);

  const zoomIn = useCallback(
    (factor: number = 1.2) => {
      const canvas = canvasRef.current;
      if (!canvas) return;

      const newZoom = clampZoom(canvas.getZoom() * factor);
      animateZoomTo(canvas, newZoom);
      setZoomLevel(newZoom);
    },
    [canvasRef]
  );

  const zoomOut = useCallback(
    (factor: number = 1.2) => {
      const canvas = canvasRef.current;
      if (!canvas) return;

      const newZoom = clampZoom(canvas.getZoom() / factor);
      animateZoomTo(canvas, newZoom);
      setZoomLevel(newZoom);
    },
    [canvasRef]
  );

  const setZoom = useCallback(
    (level: number) => {
      const canvas = canvasRef.current;
      if (!canvas) return;

      const clampedZoom = clampZoom(level);
      animateZoomTo(canvas, clampedZoom);
      setZoomLevel(clampedZoom);
    },
    [canvasRef]
  );

  const resetZoom = useCallback(() => {
    setZoom(1);
  }, [setZoom]);

  return {
    zoom,
    zoomIn,
    zoomOut,
    setZoom,
    resetZoom,
  };
}

export default useZoom;
