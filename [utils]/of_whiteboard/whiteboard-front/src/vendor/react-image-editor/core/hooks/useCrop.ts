import { fabric } from "fabric";
import { useCallback, useRef, useState } from "react";

import type { Bounds, EditorFabricImage, UseCropReturn } from "../types";
import {
  getImageBounds,
  lockImage,
  calculateFitScale,
  calculateCenterPosition,
  createTempCanvas,
  CleanupManager,
  createCropOverlays,
  createCropRect,
  createCropLabel,
  updateCropLabel,
  constrainCropRectInside,
  limitCropRectScale,
  calculateCropCoordinates,
} from "../utils";

interface UseCropOptions {
  onCropApply?: (newImage: fabric.Image) => void;
  onCropCancel?: () => void;
  onCropStart?: () => void;
}

interface CropState {
  cropRect: fabric.Rect | null;
  overlays: fabric.Rect[];
  label: fabric.Textbox | null;
}

export function useCrop(
  canvasRef: React.MutableRefObject<fabric.Canvas | null>,
  imageRef: React.MutableRefObject<fabric.Image | null>,
  setImage: (img: fabric.Image | null) => void,
  options: UseCropOptions = {}
): UseCropReturn {
  const { onCropApply, onCropCancel, onCropStart } = options;

  const [isCropping, setIsCropping] = useState(false);
  const [cropBounds, setCropBounds] = useState<Bounds | null>(null);

  const cropStateRef = useRef<CropState>({
    cropRect: null,
    overlays: [],
    label: null,
  });
  const cleanupRef = useRef(new CleanupManager());

  const startCrop = useCallback(() => {
    const canvas = canvasRef.current;
    const originalImage = imageRef.current;

    if (!canvas || !originalImage) return;

    const imgBounds = getImageBounds(originalImage);
    if (!imgBounds) return;

    setIsCropping(true);
    onCropStart?.();

    const overlays = createCropOverlays(
      canvas.getWidth(),
      canvas.getHeight(),
      imgBounds
    );
    overlays.forEach((overlay) => canvas.add(overlay));

    const cropRect = createCropRect(imgBounds);
    canvas.add(cropRect);

    const label = createCropLabel(cropRect);
    canvas.add(label);

    canvas.setActiveObject(cropRect);

    cropStateRef.current = { cropRect, overlays, label };

    setCropBounds({
      left: cropRect.left || 0,
      top: cropRect.top || 0,
      width: cropRect.getScaledWidth(),
      height: cropRect.getScaledHeight(),
    });

    const onMoving = (): void => {
      constrainCropRectInside(cropRect, imgBounds);
      const { width, height } = updateCropLabel(label, cropRect);
      setCropBounds({
        left: cropRect.left || 0,
        top: cropRect.top || 0,
        width,
        height,
      });
      canvas.requestRenderAll();
    };

    const onScaling = (): void => {
      constrainCropRectInside(cropRect, imgBounds);
      const { width, height } = updateCropLabel(label, cropRect);
      setCropBounds({
        left: cropRect.left || 0,
        top: cropRect.top || 0,
        width,
        height,
      });
      limitCropRectScale(cropRect, imgBounds);
      constrainCropRectInside(cropRect, imgBounds);
      canvas.requestRenderAll();
    };

    cropRect.on("moving", onMoving);
    cropRect.on("scaling", onScaling);

    canvas.renderAll();
  }, [canvasRef, imageRef, onCropStart]);

  const applyCrop = useCallback(async (): Promise<void> => {
    const canvas = canvasRef.current;
    const originalImage = imageRef.current;
    const { cropRect } = cropStateRef.current;

    if (!canvas || !originalImage || !cropRect) return;

    const cleanup = cleanupRef.current;
    const vpt = canvas.viewportTransform || [1, 0, 0, 1, 0, 0];

    const coords = calculateCropCoordinates(
      cropRect,
      originalImage,
      vpt as number[]
    );

    const imgElement = originalImage.getElement() as HTMLImageElement;
    const { canvas: croppedCanvas, ctx } = createTempCanvas(
      coords.width,
      coords.height,
      cleanup
    );

    if (!ctx) {
      cleanup.cleanup();
      return;
    }

    ctx.drawImage(
      imgElement,
      coords.x,
      coords.y,
      coords.width,
      coords.height,
      0,
      0,
      coords.width,
      coords.height
    );

    const croppedDataUrl = croppedCanvas.toDataURL();

    return new Promise<void>((resolve) => {
      fabric.Image.fromURL(croppedDataUrl, (img) => {
        canvas.clear();

        const canvasWidth = canvas.getWidth();
        const canvasHeight = canvas.getHeight();
        const scale = calculateFitScale(
          croppedCanvas.width,
          croppedCanvas.height,
          canvasWidth,
          canvasHeight,
          24
        );

        img.scale(scale);

        const scaledWidth = img.getScaledWidth();
        const scaledHeight = img.getScaledHeight();
        const position = calculateCenterPosition(
          scaledWidth,
          scaledHeight,
          canvasWidth,
          canvasHeight
        );

        img.set({
          left: position.x,
          top: position.y,
          originX: "left",
          originY: "top",
        });

        (img as EditorFabricImage).id = "originalImage";
        (img as EditorFabricImage).originalWidth = coords.width;
        (img as EditorFabricImage).originalHeight = coords.height;
        lockImage(img);

        canvas.add(img);
        img.setCoords();

        setImage(img);
        setIsCropping(false);
        setCropBounds(null);

        cropStateRef.current = { cropRect: null, overlays: [], label: null };

        cleanup.disposeCanvas(croppedCanvas);

        canvas.renderAll();
        onCropApply?.(img);
        resolve();
      });
    });
  }, [canvasRef, imageRef, setImage, onCropApply]);

  const cancelCrop = useCallback(() => {
    const canvas = canvasRef.current;
    const { cropRect, overlays, label } = cropStateRef.current;

    if (!canvas) return;

    const toRemove = [cropRect, ...overlays, label].filter(
      Boolean
    ) as fabric.Object[];
    toRemove.forEach((obj) => canvas.remove(obj));

    cropStateRef.current = { cropRect: null, overlays: [], label: null };
    setIsCropping(false);
    setCropBounds(null);

    canvas.discardActiveObject();
    canvas.renderAll();

    onCropCancel?.();
  }, [canvasRef, onCropCancel]);

  return {
    isCropping,
    startCrop,
    applyCrop,
    cancelCrop,
    cropBounds,
  };
}

export default useCrop;
