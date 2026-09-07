import { fabric } from "fabric";
import { useCallback, useRef, useState } from "react";

import type { EditorFabricObject, UseEraserReturn } from "../types";

interface EraserBrush {
  canvas: fabric.Canvas & { contextTop: CanvasRenderingContext2D };
  _points: fabric.Point[];
  decimatePoints(points: fabric.Point[], distance: number): fabric.Point[];
  _resetShadow(): void;
}

class EraserBrush extends fabric.PencilBrush {
  _finalizeAndAddPath() {
    const ctx = this.canvas.contextTop;
    ctx.closePath();
    if (this.decimate) {
      this._points = this.decimatePoints(this._points, this.decimate);
    }
    const pathData = this.convertPointsToSVGPath(this._points).join("");
    if (pathData === "M 0 0 Q 0 0 0 0 L 0 0") {
      this.canvas.requestRenderAll();
      return;
    }

    const path = this.createPath(pathData);
    path.set({
      globalCompositeOperation: "destination-out",
      selectable: false,
      evented: false,
      hasControls: false,
      hasBorders: false,
    });
    (path as EditorFabricObject).isEraserPath = true;

    this.canvas.clearContext(this.canvas.contextTop);
    this.canvas.fire("before:path:created", { path });
    this.canvas.add(path);
    this.canvas.requestRenderAll();
    path.setCoords();
    this._resetShadow();
    this.canvas.fire("path:created", { path });
  }
}

interface UseEraserOptions {
  initialWidth?: number;
  onEnable?: () => void;
  onDisable?: () => void;
}

export function useEraser(
  canvasRef: React.MutableRefObject<fabric.Canvas | null>,
  imageRef: React.MutableRefObject<fabric.Image | null>,
  options: UseEraserOptions = {}
): UseEraserReturn {
  const { initialWidth = 20, onEnable, onDisable } = options;

  const [isErasing, setIsErasing] = useState(false);
  const widthRef = useRef(initialWidth);
  const previousBrushRef = useRef<fabric.BaseBrush | null>(null);

  const updateObjectSelectability = useCallback(
    (canvas: fabric.Canvas, eraserEnabled: boolean) => {
      const originalImage = imageRef.current;

      canvas.getObjects().forEach((obj) => {
        if (obj === originalImage) return;

        const customObj = obj as EditorFabricObject;
        if (!customObj.isBlurPatch) {
          obj.set({
            selectable: !eraserEnabled,
            evented: !eraserEnabled,
          });
        }
      });
    },
    [imageRef]
  );

  const enableEraser = useCallback(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    previousBrushRef.current = canvas.freeDrawingBrush;

    const brush = new EraserBrush(canvas);
    brush.width = widthRef.current;
    canvas.freeDrawingBrush = brush;
    canvas.isDrawingMode = true;

    updateObjectSelectability(canvas, true);
    canvas.discardActiveObject();
    canvas.renderAll();

    setIsErasing(true);
    onEnable?.();
  }, [canvasRef, updateObjectSelectability, onEnable]);

  const disableEraser = useCallback(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    canvas.isDrawingMode = false;
    if (previousBrushRef.current) {
      canvas.freeDrawingBrush = previousBrushRef.current;
    }

    updateObjectSelectability(canvas, false);
    canvas.renderAll();

    setIsErasing(false);
    onDisable?.();
  }, [canvasRef, updateObjectSelectability, onDisable]);

  const toggleEraser = useCallback(() => {
    if (isErasing) {
      disableEraser();
    } else {
      enableEraser();
    }
  }, [isErasing, enableEraser, disableEraser]);

  const setEraserWidth = useCallback(
    (width: number) => {
      widthRef.current = width;

      const canvas = canvasRef.current;
      if (canvas?.freeDrawingBrush && isErasing) {
        canvas.freeDrawingBrush.width = width;
      }
    },
    [canvasRef, isErasing]
  );

  return {
    isErasing,
    enableEraser,
    disableEraser,
    toggleEraser,
    setEraserWidth,
  };
}

export default useEraser;
