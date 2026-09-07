export type {
  EditorFabricObject as CustomFabricObject,
  EditorFabricImage as CustomFabricImage,
  EditorFabricCanvas as CustomFabricCanvas,
  EditorFabricRect as CustomFabricRect,
  EditorFabricPath as CustomFabricPath,
  FabricSelectionEvent,
  FabricPathCreatedEvent,
  ShapeType,
  ImageEditorClassNames as ImageEditorCustomization,
} from "../../core/types";

import type { fabric } from "fabric";

export interface UseBlurHandlersReturn {
  activeBlurRects: fabric.Rect[];
  setActiveBlurRects: React.Dispatch<React.SetStateAction<fabric.Rect[]>>;
  handleAddBlur: () => void;
}

export interface UseCropHandlersReturn {
  isCropping: boolean;
  setIsCropping: React.Dispatch<React.SetStateAction<boolean>>;
  handleCropStart: () => void;
  handleCropApply: () => void;
  handleCropCancel: () => void;
}

export interface UseShapeHandlersReturn {
  handleAddShape: (shapeType: "rectangle" | "circle") => void;
}

export interface UseUndoRedoReturn {
  saveState: () => void;
  undo: () => void;
  redo: () => void;
  initializeHistory: () => void;
  canUndo: boolean;
  canRedo: boolean;
}
