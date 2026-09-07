import { fabric } from "fabric";
import { useCallback, useRef, useState } from "react";

import type {
  EditorFabricCanvas,
  EditorFabricObject,
  EditorFabricRect,
  UseBlurReturn,
} from "../types";
import {
  getViewportCenter,
  getImageBounds,
  calculateIntersection,
  createTempCanvas,
  CleanupManager,
  createThrottledFunction,
} from "../utils";

interface UseBlurOptions {
  blurIntensity?: number;
  throttleMs?: number;
  onBlurAdd?: (rect: fabric.Rect) => void;
  onBlurRemove?: (id: string) => void;
}

const DEFAULT_BLUR_INTENSITY = 20;
const DEFAULT_THROTTLE_MS = 50;
const BLUR_RECT_WIDTH = 150;
const BLUR_RECT_HEIGHT = 100;

export function useBlur(
  canvasRef: React.MutableRefObject<fabric.Canvas | null>,
  imageRef: React.MutableRefObject<fabric.Image | null>,
  options: UseBlurOptions = {}
): UseBlurReturn {
  const {
    blurIntensity = DEFAULT_BLUR_INTENSITY,
    throttleMs = DEFAULT_THROTTLE_MS,
    onBlurAdd,
    onBlurRemove,
  } = options;

  const [activeBlurRects, setActiveBlurRects] = useState<fabric.Rect[]>([]);

  const cleanupRef = useRef(new CleanupManager());
  const throttledUpdatesRef = useRef<
    Map<string, { fn: () => void; cancel: () => void }>
  >(new Map());

  const updateBlurEffect = useCallback(
    (blurRect: fabric.Rect) => {
      const canvas = canvasRef.current;
      const originalImage = imageRef.current;

      if (!canvas || !originalImage) return;

      const customCanvas = canvas as EditorFabricCanvas;
      if (customCanvas.isUpdatingBlur) return;
      customCanvas.isUpdatingBlur = true;

      const cleanup = cleanupRef.current;
      const customBlurRect = blurRect as EditorFabricRect;
      const blurRectId = customBlurRect.id;

      const objects = canvas.getObjects();
      objects.forEach((obj) => {
        const customObj = obj as EditorFabricObject;
        if (customObj.isBlurPatch && customObj.blurRectId === blurRectId) {
          canvas.remove(obj);
        }
      });

      const rectLeft = blurRect.left || 0;
      const rectTop = blurRect.top || 0;
      const rectWidth = blurRect.getScaledWidth();
      const rectHeight = blurRect.getScaledHeight();

      const imgBounds = getImageBounds(originalImage);
      if (!imgBounds) {
        customCanvas.isUpdatingBlur = false;
        return;
      }

      const intersection = calculateIntersection(
        { left: rectLeft, top: rectTop, width: rectWidth, height: rectHeight },
        imgBounds
      );

      if (!intersection) {
        blurRect.set({ visible: true });
        canvas.requestRenderAll();
        customCanvas.isUpdatingBlur = false;
        return;
      }

      const imgScaleX = originalImage.scaleX || 1;
      const imgScaleY = originalImage.scaleY || 1;
      const pxX = Math.round((intersection.left - imgBounds.left) / imgScaleX);
      const pxY = Math.round((intersection.top - imgBounds.top) / imgScaleY);
      const pxW = Math.round(intersection.width / imgScaleX);
      const pxH = Math.round(intersection.height / imgScaleY);

      const imgEl = originalImage.getElement() as HTMLImageElement;

      requestAnimationFrame(() => {
        const { canvas: tempCanvas, ctx: tempCtx } = createTempCanvas(
          pxW,
          pxH,
          cleanup
        );
        if (!tempCtx) {
          customCanvas.isUpdatingBlur = false;
          return;
        }

        tempCtx.drawImage(imgEl, pxX, pxY, pxW, pxH, 0, 0, pxW, pxH);

        const { canvas: blurCanvas, ctx: blurCtx } = createTempCanvas(
          pxW,
          pxH,
          cleanup
        );
        if (!blurCtx) {
          cleanup.disposeCanvas(tempCanvas);
          customCanvas.isUpdatingBlur = false;
          return;
        }

        blurCtx.filter = `blur(${blurIntensity}px)`;
        blurCtx.drawImage(tempCanvas, 0, 0);

        fabric.Image.fromURL(blurCanvas.toDataURL(), (blurImg) => {
          const customBlurImg = blurImg as EditorFabricObject;
          customBlurImg.set({
            left: intersection.left,
            top: intersection.top,
            originX: "left",
            originY: "top",
            scaleX: imgScaleX,
            scaleY: imgScaleY,
            selectable: false,
            evented: false,
            isBlurPatch: true,
            blurRectId: blurRectId,
            opacity: 1,
          });

          canvas.add(blurImg);
          blurRect.set({ visible: true });
          canvas.bringToFront(blurRect);
          canvas.requestRenderAll();

          cleanup.disposeCanvas(tempCanvas);
          cleanup.disposeCanvas(blurCanvas);

          customCanvas.isUpdatingBlur = false;
        });
      });
    },
    [canvasRef, imageRef, blurIntensity]
  );

  const addBlur = useCallback(() => {
    const canvas = canvasRef.current;
    const originalImage = imageRef.current;

    if (!canvas || !originalImage) return;

    const cleanup = cleanupRef.current;

    const imgBounds = getImageBounds(originalImage);
    if (!imgBounds) return;

    const viewportCenter = getViewportCenter(canvas);
    let blurX = viewportCenter.x - BLUR_RECT_WIDTH / 2;
    let blurY = viewportCenter.y - BLUR_RECT_HEIGHT / 2;

    const margin = 20;
    blurX = Math.max(
      imgBounds.left + margin,
      Math.min(blurX, imgBounds.left + imgBounds.width - BLUR_RECT_WIDTH - margin)
    );
    blurY = Math.max(
      imgBounds.top + margin,
      Math.min(blurY, imgBounds.top + imgBounds.height - BLUR_RECT_HEIGHT - margin)
    );

    const blurId = `blur-${Date.now()}`;

    const blurRect = new fabric.Rect({
      left: blurX,
      top: blurY,
      width: BLUR_RECT_WIDTH,
      height: BLUR_RECT_HEIGHT,
      originX: "left",
      originY: "top",
      fill: "transparent",
      stroke: "#8b5cf6",
      strokeWidth: 2,
      strokeUniform: true,
      strokeDashArray: [5, 5],
      opacity: 0.9,
      cornerColor: "#8b5cf6",
      cornerSize: 10,
      transparentCorners: false,
      hasControls: true,
      hasBorders: true,
      lockRotation: true,
      selectable: true,
      evented: true,
      borderColor: "#8b5cf6",
      objectCaching: false,
    } as fabric.IRectOptions);

    (blurRect as EditorFabricRect).id = blurId;

    const { fn: throttledUpdate, cancel } = createThrottledFunction(
      () => updateBlurEffect(blurRect),
      throttleMs,
      cleanup
    );

    throttledUpdatesRef.current.set(blurId, { fn: throttledUpdate, cancel });

    blurRect.on("modified", throttledUpdate);
    blurRect.on("moving", throttledUpdate);
    blurRect.on("scaling", throttledUpdate);

    canvas.add(blurRect);
    canvas.setActiveObject(blurRect);
    updateBlurEffect(blurRect);

    setActiveBlurRects((prev) => [...prev, blurRect]);

    canvas.renderAll();
    onBlurAdd?.(blurRect);
  }, [canvasRef, imageRef, throttleMs, updateBlurEffect, onBlurAdd]);

  const removeBlur = useCallback(
    (id: string) => {
      const canvas = canvasRef.current;
      if (!canvas) return;

      const throttledUpdate = throttledUpdatesRef.current.get(id);
      if (throttledUpdate) {
        throttledUpdate.cancel();
        throttledUpdatesRef.current.delete(id);
      }

      const objects = canvas.getObjects();
      objects.forEach((obj) => {
        const customObj = obj as EditorFabricObject;
        const customRect = obj as EditorFabricRect;

        if (customRect.id === id || customObj.blurRectId === id) {
          canvas.remove(obj);
        }
      });

      setActiveBlurRects((prev) =>
        prev.filter((rect) => (rect as EditorFabricRect).id !== id)
      );

      canvas.renderAll();
      onBlurRemove?.(id);
    },
    [canvasRef, onBlurRemove]
  );

  const clearAllBlur = useCallback(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    throttledUpdatesRef.current.forEach(({ cancel }) => cancel());
    throttledUpdatesRef.current.clear();

    try {
      const objects = canvas.getObjects();
      objects.forEach((obj) => {
        const customObj = obj as EditorFabricObject;
        const customRect = obj as EditorFabricRect;

        if (customRect.id?.startsWith("blur-") || customObj.isBlurPatch) {
          canvas.remove(obj);
        }
      });

      canvas.renderAll();
    } catch {
    }

    setActiveBlurRects([]);
  }, [canvasRef]);

  return {
    activeBlurRects,
    addBlur,
    removeBlur,
    clearAllBlur,
    updateBlurEffect,
  };
}

export default useBlur;
