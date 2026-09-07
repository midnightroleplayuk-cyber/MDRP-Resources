import { fabric } from "fabric";
import { useCallback, useState } from "react";

import type { EditorFabricObject, UseSelectionReturn } from "../types";

interface UseSelectionOptions {
  onSelect?: (obj: fabric.Object) => void;
  onDeselect?: () => void;
  onDelete?: (obj: fabric.Object) => void;
}

export function useSelection(
  canvasRef: React.MutableRefObject<fabric.Canvas | null>,
  imageRef: React.MutableRefObject<fabric.Image | null>,
  options: UseSelectionOptions = {}
): UseSelectionReturn {
  const { onSelect, onDeselect, onDelete } = options;

  const [isSelectMode, setIsSelectMode] = useState(true);
  const [selectedObject, setSelectedObject] = useState<fabric.Object | null>(
    null
  );

  const updateObjectSelectability = useCallback(
    (canvas: fabric.Canvas, selectEnabled: boolean) => {
      const originalImage = imageRef.current;

      canvas.getObjects().forEach((obj) => {
        if (obj === originalImage) return;

        const customObj = obj as EditorFabricObject;
        if (!customObj.isBlurPatch) {
          obj.set({
            selectable: selectEnabled,
            evented: selectEnabled,
          });
        }
      });
    },
    [imageRef]
  );

  const enableSelectMode = useCallback(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    canvas.isDrawingMode = false;
    updateObjectSelectability(canvas, true);
    canvas.renderAll();

    setIsSelectMode(true);
  }, [canvasRef, updateObjectSelectability]);

  const disableSelectMode = useCallback(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    canvas.discardActiveObject();
    updateObjectSelectability(canvas, false);
    canvas.renderAll();

    setIsSelectMode(false);
    setSelectedObject(null);
    onDeselect?.();
  }, [canvasRef, updateObjectSelectability, onDeselect]);

  const toggleSelectMode = useCallback(() => {
    if (isSelectMode) {
      disableSelectMode();
    } else {
      enableSelectMode();
    }
  }, [isSelectMode, enableSelectMode, disableSelectMode]);

  const handleSelect = useCallback(
    (obj: fabric.Object) => {
      const originalImage = imageRef.current;

      if (obj === originalImage) return;

      const customObj = obj as EditorFabricObject;
      if (customObj.isBlurPatch) return;

      setSelectedObject(obj);
      onSelect?.(obj);
    },
    [imageRef, onSelect]
  );

  const clearSelection = useCallback(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    canvas.discardActiveObject();
    canvas.renderAll();

    setSelectedObject(null);
    onDeselect?.();
  }, [canvasRef, onDeselect]);

  const deleteSelected = useCallback(() => {
    const canvas = canvasRef.current;
    const originalImage = imageRef.current;

    if (!canvas || !selectedObject) return;

    if (selectedObject === originalImage) return;

    const customObj = selectedObject as EditorFabricObject;

    if (customObj.id?.startsWith("blur-")) {
      const blurRectId = customObj.id;
      const objects = canvas.getObjects();

      objects.forEach((obj) => {
        const o = obj as EditorFabricObject;
        if (o.blurRectId === blurRectId) {
          canvas.remove(obj);
        }
      });
    }

    canvas.remove(selectedObject);
    canvas.discardActiveObject();
    canvas.renderAll();

    onDelete?.(selectedObject);
    setSelectedObject(null);
  }, [canvasRef, imageRef, selectedObject, onDelete]);

  const setSelectedColor = useCallback(
    (color: string) => {
      const canvas = canvasRef.current;
      if (!canvas || !selectedObject) return;

      const customObj = selectedObject as EditorFabricObject;

      if (customObj.isText || selectedObject.type === "i-text") {
        selectedObject.set({
          fill: color,
          cornerColor: color,
          borderColor: color,
        });
      } else {
        selectedObject.set({
          stroke: color,
          cornerColor: color,
          borderColor: color,
        });
      }

      canvas.renderAll();
    },
    [canvasRef, selectedObject]
  );

  const setSelectedStrokeWidth = useCallback(
    (width: number) => {
      const canvas = canvasRef.current;
      if (!canvas || !selectedObject) return;

      selectedObject.set({ strokeWidth: width });
      canvas.renderAll();
    },
    [canvasRef, selectedObject]
  );

  return {
    isSelectMode,
    selectedObject,
    enableSelectMode,
    disableSelectMode,
    toggleSelectMode,
    deleteSelected,
    setSelectedColor,
    setSelectedStrokeWidth,
    clearSelection,
    _handleSelect: handleSelect,
  } as UseSelectionReturn & { _handleSelect: (obj: fabric.Object) => void };
}

export default useSelection;
