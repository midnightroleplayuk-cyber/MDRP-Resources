import { fabric } from "fabric";
import { useCallback, useEffect, useRef, useState } from "react";

import type { Bounds, EditorFabricImage, UseCanvasReturn } from "../types";
import {
  loadImageToCanvas,
  getImageBounds,
  dataURLToBlob,
  CleanupManager,
} from "../utils";

interface UseCanvasOptions {
  imageUrl?: string;
  backgroundColor?: string;
  padding?: number;
  onImageLoad?: (image: fabric.Image) => void;
  onReady?: (canvas: fabric.Canvas) => void;
}

export function useCanvas(options: UseCanvasOptions = {}): UseCanvasReturn {
  const {
    imageUrl,
    backgroundColor = "transparent",
    padding = 24,
    onImageLoad,
    onReady,
  } = options;

  const canvasRef = useRef<HTMLCanvasElement>(null);
  const canvasInstanceRef = useRef<fabric.Canvas | null>(null);
  const cleanupRef = useRef(new CleanupManager());

  const [canvas, setCanvas] = useState<fabric.Canvas | null>(null);
  const [originalImage, setOriginalImage] = useState<fabric.Image | null>(null);
  const [hasImage, setHasImage] = useState(false);

  const onCanvasReady = useCallback(
    (fabricCanvas: fabric.Canvas) => {
      canvasInstanceRef.current = fabricCanvas;
      setCanvas(fabricCanvas);
      onReady?.(fabricCanvas);
    },
    [onReady]
  );

  const loadImage = useCallback(
    async (url: string) => {
      const currentCanvas = canvasInstanceRef.current;
      if (!currentCanvas || !url) return;

      try {
        const img = await loadImageToCanvas(currentCanvas, url, padding);
        setOriginalImage(img);
        setHasImage(true);
        onImageLoad?.(img);
      } catch {
        setHasImage(false);
      }
    },
    [padding, onImageLoad]
  );

  const getImageBoundsCallback = useCallback((): Bounds | null => {
    return getImageBounds(originalImage);
  }, [originalImage]);

  const exportToBlob = useCallback(async (): Promise<Blob | null> => {
    const currentCanvas = canvasInstanceRef.current;
    if (!currentCanvas || !originalImage) return null;

    const currentViewportTransform =
      currentCanvas.viewportTransform || [1, 0, 0, 1, 0, 0];
    const currentZoom = currentCanvas.getZoom();

    try {
      currentCanvas.setZoom(1);
      currentCanvas.setViewportTransform([1, 0, 0, 1, 0, 0]);

      const imgBounds = getImageBounds(originalImage);
      if (!imgBounds) {
        throw new Error("Could not get image bounds");
      }

      let minX = imgBounds.left;
      let minY = imgBounds.top;
      let maxX = imgBounds.left + imgBounds.width;
      let maxY = imgBounds.top + imgBounds.height;

      const objects = currentCanvas.getObjects();
      objects.forEach((obj) => {
        if (obj !== originalImage) {
          const objBounds = obj.getBoundingRect();
          minX = Math.min(minX, objBounds.left);
          minY = Math.min(minY, objBounds.top);
          maxX = Math.max(maxX, objBounds.left + objBounds.width);
          maxY = Math.max(maxY, objBounds.top + objBounds.height);
        }
      });

      const canvasWidth = currentCanvas.getWidth();
      const canvasHeight = currentCanvas.getHeight();
      minX = Math.max(0, minX);
      minY = Math.max(0, minY);
      maxX = Math.min(canvasWidth, maxX);
      maxY = Math.min(canvasHeight, maxY);

      const dataURL = currentCanvas.toDataURL({
        format: "png",
        quality: 1,
        left: Math.round(minX),
        top: Math.round(minY),
        width: Math.round(maxX - minX),
        height: Math.round(maxY - minY),
        multiplier: 1,
      });

      currentCanvas.setZoom(currentZoom);
      currentCanvas.setViewportTransform(currentViewportTransform);
      currentCanvas.renderAll();

      return await dataURLToBlob(dataURL);
    } catch {
      currentCanvas.setZoom(currentZoom);
      currentCanvas.setViewportTransform(currentViewportTransform);
      currentCanvas.renderAll();

      try {
        const fallbackDataURL = currentCanvas.toDataURL({
          format: "png",
          quality: 1,
        });
        return await dataURLToBlob(fallbackDataURL);
      } catch {
        return null;
      }
    }
  }, [originalImage]);

  const dispose = useCallback(() => {
    cleanupRef.current.cleanup();

    if (canvasInstanceRef.current) {
      try {
        canvasInstanceRef.current.dispose();
      } catch {
      }
      canvasInstanceRef.current = null;
    }

    setCanvas(null);
    setOriginalImage(null);
    setHasImage(false);
  }, []);

  useEffect(() => {
    if (!canvasRef.current || canvasInstanceRef.current) return;

    const fabricCanvas = new fabric.Canvas(canvasRef.current);
    fabricCanvas.setBackgroundColor(backgroundColor, () => {
      fabricCanvas.renderAll();
    });

    onCanvasReady(fabricCanvas);

    return () => {
      dispose();
    };
  }, [backgroundColor, onCanvasReady, dispose]);

  useEffect(() => {
    if (imageUrl && canvas) {
      loadImage(imageUrl);
    }
  }, [imageUrl, canvas, loadImage]);

  const setOriginalImageCallback = useCallback(
    (img: fabric.Image | null) => {
      if (img) {
        (img as EditorFabricImage).id = "originalImage";
      }
      setOriginalImage(img);
      setHasImage(img !== null);
    },
    []
  );

  return {
    canvas,
    originalImage,
    hasImage,
    canvasRef,
    onCanvasReady,
    setOriginalImage: setOriginalImageCallback,
    getImageBounds: getImageBoundsCallback,
    exportToBlob,
    dispose,
  };
}

export default useCanvas;
