import { useCallback } from "react";
import type { fabric } from "fabric";

import { dataURLToBlob } from "../utils";
import type { EditorFabricImage } from "../types";
import { DEFAULT_CUSTOM_PROPERTIES } from "./useHistory";

export interface UseExportReturn {
  exportToBlob: () => Promise<Blob | null>;
  exportToDataURL: (format?: string, quality?: number) => string | null;
  exportCanvasJSON: () => string | null;
}

export function useExport(
  canvasRef: React.MutableRefObject<fabric.Canvas | null>,
  originalImageRef: React.MutableRefObject<fabric.Image | null>
): UseExportReturn {
  const exportToBlob = useCallback(async (): Promise<Blob | null> => {
    const canvas = canvasRef.current;
    const image = originalImageRef.current as EditorFabricImage | null;
    if (!canvas || !image) return null;

    const currentVPT = canvas.viewportTransform || [1, 0, 0, 1, 0, 0];
    const currentZoom = canvas.getZoom();

    try {
      canvas.setZoom(1);
      canvas.setViewportTransform([1, 0, 0, 1, 0, 0]);

      const imgLeft = image.left || 0;
      const imgTop = image.top || 0;
      const scaledWidth = image.getScaledWidth();
      const scaledHeight = image.getScaledHeight();

      const originalWidth = image.originalWidth || image.width || scaledWidth;
      const multiplier = originalWidth / scaledWidth;

      const dataURL = canvas.toDataURL({
        format: "png",
        quality: 1,
        left: Math.round(imgLeft),
        top: Math.round(imgTop),
        width: Math.round(scaledWidth),
        height: Math.round(scaledHeight),
        multiplier: multiplier,
      });

      canvas.setZoom(currentZoom);
      canvas.setViewportTransform(currentVPT);
      canvas.renderAll();

      return await dataURLToBlob(dataURL);
    } catch {
      canvas.setZoom(currentZoom);
      canvas.setViewportTransform(currentVPT);
      canvas.renderAll();
      return null;
    }
  }, [canvasRef, originalImageRef]);

  const exportToDataURL = useCallback(
    (format: string = "png", quality: number = 1): string | null => {
      const canvas = canvasRef.current;
      if (!canvas) return null;

      return canvas.toDataURL({ format, quality });
    },
    [canvasRef]
  );

  const exportCanvasJSON = useCallback((): string | null => {
    const canvas = canvasRef.current;
    if (!canvas) return null;

    try {
      return JSON.stringify(canvas.toJSON(DEFAULT_CUSTOM_PROPERTIES));
    } catch {
      return null;
    }
  }, [canvasRef]);

  return {
    exportToBlob,
    exportToDataURL,
    exportCanvasJSON,
  };
}

export default useExport;
