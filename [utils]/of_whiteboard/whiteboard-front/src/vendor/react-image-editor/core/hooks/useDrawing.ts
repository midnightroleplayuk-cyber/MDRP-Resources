import { fabric } from "fabric";
import { useCallback, useState } from "react";

import type { EditorFabricObject, UseDrawingReturn } from "../types";

interface UseDrawingOptions {
  initialColor?: string;
  initialWidth?: number;
  onEnable?: () => void;
  onDisable?: () => void;
}

export function useDrawing(
  canvasRef: React.MutableRefObject<fabric.Canvas | null>,
  imageRef: React.MutableRefObject<fabric.Image | null>,
  options: UseDrawingOptions = {}
): UseDrawingReturn {
  const {
    initialColor = "#ff7000",
    initialWidth = 2,
    onEnable,
    onDisable,
  } = options;

  const [isDrawing, setIsDrawing] = useState(false);

  const updateObjectSelectability = useCallback(
    (canvas: fabric.Canvas, drawingEnabled: boolean) => {
      const originalImage = imageRef.current;

      canvas.getObjects().forEach((obj) => {
        if (obj === originalImage) return;

        const customObj = obj as EditorFabricObject;
        if (!customObj.isBlurPatch) {
          obj.set({
            selectable: !drawingEnabled,
            evented: !drawingEnabled,
          });
        }
      });
    },
    [imageRef]
  );

  const enableDrawing = useCallback(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    canvas.isDrawingMode = true;
    canvas.freeDrawingBrush.color = initialColor;
    canvas.freeDrawingBrush.width = initialWidth;

    updateObjectSelectability(canvas, true);
    canvas.discardActiveObject();
    canvas.renderAll();

    setIsDrawing(true);
    onEnable?.();
  }, [canvasRef, initialColor, initialWidth, updateObjectSelectability, onEnable]);

  const disableDrawing = useCallback(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    canvas.isDrawingMode = false;
    updateObjectSelectability(canvas, false);
    canvas.renderAll();

    setIsDrawing(false);
    onDisable?.();
  }, [canvasRef, updateObjectSelectability, onDisable]);

  const toggleDrawing = useCallback(() => {
    if (isDrawing) {
      disableDrawing();
    } else {
      enableDrawing();
    }
  }, [isDrawing, enableDrawing, disableDrawing]);

  const setBrushColor = useCallback(
    (color: string) => {
      const canvas = canvasRef.current;
      if (!canvas) return;

      canvas.freeDrawingBrush.color = color;
    },
    [canvasRef]
  );

  const setBrushWidth = useCallback(
    (width: number) => {
      const canvas = canvasRef.current;
      if (!canvas) return;

      canvas.freeDrawingBrush.width = width;
    },
    [canvasRef]
  );

  return {
    isDrawing,
    enableDrawing,
    disableDrawing,
    toggleDrawing,
    setBrushColor,
    setBrushWidth,
  };
}

export default useDrawing;
