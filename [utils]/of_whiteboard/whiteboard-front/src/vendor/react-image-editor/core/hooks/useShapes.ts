import { fabric } from "fabric";
import { useCallback } from "react";

import type { EditorFabricObject, ShapeType, UseShapesReturn } from "../types";
import { getViewportCenter, getImageBounds } from "../utils";

interface UseShapesOptions {
  defaultColor?: string;
  defaultStrokeWidth?: number;
  onShapeAdd?: (shape: fabric.Object, type: ShapeType) => void;
}

const DEFAULT_SHAPE_SIZE = 100;

export function useShapes(
  canvasRef: React.MutableRefObject<fabric.Canvas | null>,
  imageRef: React.MutableRefObject<fabric.Image | null>,
  options: UseShapesOptions = {}
): UseShapesReturn {
  const {
    defaultColor = "#ff7000",
    defaultStrokeWidth = 2,
    onShapeAdd,
  } = options;

  const calculateShapePosition = useCallback(
    (
      canvas: fabric.Canvas,
      shapeWidth: number,
      shapeHeight: number
    ): { x: number; y: number } => {
      const originalImage = imageRef.current;
      const imgBounds = getImageBounds(originalImage);

      const viewportCenter = getViewportCenter(canvas);
      let x = viewportCenter.x;
      let y = viewportCenter.y;

      if (imgBounds) {
        const halfWidth = shapeWidth / 2;
        const halfHeight = shapeHeight / 2;

        x = Math.max(
          imgBounds.left + halfWidth + 10,
          Math.min(x, imgBounds.left + imgBounds.width - halfWidth - 10)
        );
        y = Math.max(
          imgBounds.top + halfHeight + 10,
          Math.min(y, imgBounds.top + imgBounds.height - halfHeight - 10)
        );
      }

      return { x, y };
    },
    [imageRef]
  );

  const createBaseOptions = useCallback(
    (color: string, strokeWidth: number): fabric.IObjectOptions => ({
      fill: "transparent",
      stroke: color,
      strokeWidth,
      strokeUniform: true,
      originX: "center",
      originY: "center",
      cornerColor: color,
      cornerSize: 10,
      transparentCorners: false,
      hasControls: true,
      hasBorders: true,
      selectable: true,
      evented: true,
      objectCaching: false,
    }),
    []
  );

  const addRectangle = useCallback(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    const position = calculateShapePosition(
      canvas,
      DEFAULT_SHAPE_SIZE,
      DEFAULT_SHAPE_SIZE
    );

    const rect = new fabric.Rect({
      ...createBaseOptions(defaultColor, defaultStrokeWidth),
      left: position.x,
      top: position.y,
      width: DEFAULT_SHAPE_SIZE,
      height: DEFAULT_SHAPE_SIZE,
    });

    const customRect = rect as EditorFabricObject;
    customRect.isShape = true;
    customRect.shapeType = "rectangle";
    customRect.id = `rect-${Date.now()}`;

    canvas.add(rect);
    canvas.setActiveObject(rect);
    canvas.renderAll();

    onShapeAdd?.(rect, "rectangle");
  }, [
    canvasRef,
    calculateShapePosition,
    createBaseOptions,
    defaultColor,
    defaultStrokeWidth,
    onShapeAdd,
  ]);

  const addCircle = useCallback(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    const radius = DEFAULT_SHAPE_SIZE / 2;
    const position = calculateShapePosition(canvas, radius * 2, radius * 2);

    const circle = new fabric.Circle({
      ...createBaseOptions(defaultColor, defaultStrokeWidth),
      left: position.x,
      top: position.y,
      radius,
    });

    const customCircle = circle as EditorFabricObject;
    customCircle.isShape = true;
    customCircle.shapeType = "circle";
    customCircle.id = `circle-${Date.now()}`;

    canvas.add(circle);
    canvas.setActiveObject(circle);
    canvas.renderAll();

    onShapeAdd?.(circle, "circle");
  }, [
    canvasRef,
    calculateShapePosition,
    createBaseOptions,
    defaultColor,
    defaultStrokeWidth,
    onShapeAdd,
  ]);

  const addShape = useCallback(
    (type: ShapeType) => {
      if (type === "rectangle") {
        addRectangle();
      } else if (type === "circle") {
        addCircle();
      }
    },
    [addRectangle, addCircle]
  );

  return {
    addRectangle,
    addCircle,
    addShape,
  };
}

export default useShapes;
