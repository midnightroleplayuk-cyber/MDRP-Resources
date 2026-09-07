import type { fabric } from "fabric";

import type { Bounds } from "./config.types";
import type { EditorState } from "./state.types";
import type { ShapeType } from "./fabric.types";

export interface UseCanvasReturn {
  canvas: fabric.Canvas | null;
  originalImage: fabric.Image | null;
  hasImage: boolean;
  canvasRef: React.RefObject<HTMLCanvasElement | null>;
  onCanvasReady: (canvas: fabric.Canvas) => void;
  setOriginalImage: (img: fabric.Image | null) => void;
  getImageBounds: () => Bounds | null;
  exportToBlob: () => Promise<Blob | null>;
  dispose: () => void;
}

export interface UseHistoryReturn {
  saveState: () => void;
  undo: () => void;
  redo: () => void;
  initializeHistory: () => void;
  clearHistory: () => void;
  canUndo: boolean;
  canRedo: boolean;
  historyLength: number;
  currentIndex: number;
}

export interface UseBlurReturn {
  activeBlurRects: fabric.Rect[];
  addBlur: () => void;
  removeBlur: (id: string) => void;
  clearAllBlur: () => void;
  updateBlurEffect: (rect: fabric.Rect) => void;
}

export interface UseCropReturn {
  isCropping: boolean;
  startCrop: () => void;
  applyCrop: () => Promise<void>;
  cancelCrop: () => void;
  cropBounds: Bounds | null;
}

export interface UseDrawingReturn {
  isDrawing: boolean;
  enableDrawing: () => void;
  disableDrawing: () => void;
  toggleDrawing: () => void;
  setBrushColor: (color: string) => void;
  setBrushWidth: (width: number) => void;
}

export interface UseShapesReturn {
  addRectangle: () => void;
  addCircle: () => void;
  addShape: (type: ShapeType) => void;
}

export interface UseTextReturn {
  addText: (initialText?: string) => void;
  setFontSize: (size: number) => void;
  setFontFamily: (family: string) => void;
  setTextColor: (color: string) => void;
  setFontWeight: (weight: "normal" | "bold") => void;
  setFontStyle: (style: "normal" | "italic") => void;
  setUnderline: (underline: boolean) => void;
  setHighlightColor: (color: string | null) => void;
  setTextAlign: (align: "left" | "center" | "right" | "justify") => void;
  setLineHeight: (lineHeight: number) => void;
  applyStylePreset: (preset: "normal" | "heading1" | "heading2" | "heading3") => void;
  clearFormatting: () => void;
  fontFamilies: string[];
}

export interface UseEraserReturn {
  isErasing: boolean;
  enableEraser: () => void;
  disableEraser: () => void;
  toggleEraser: () => void;
  setEraserWidth: (width: number) => void;
}

export interface UseSelectionReturn {
  isSelectMode: boolean;
  selectedObject: fabric.Object | null;
  enableSelectMode: () => void;
  disableSelectMode: () => void;
  toggleSelectMode: () => void;
  deleteSelected: () => void;
  setSelectedColor: (color: string) => void;
  setSelectedStrokeWidth: (width: number) => void;
  clearSelection: () => void;
}

export interface UseZoomReturn {
  zoom: number;
  zoomIn: (factor?: number) => void;
  zoomOut: (factor?: number) => void;
  setZoom: (level: number) => void;
  resetZoom: () => void;
}

export interface UsePanReturn {
  isPanEnabled: boolean;
  enablePan: () => void;
  disablePan: () => void;
  resetPan: () => void;
}

export interface UseImageEditorReturn {
  canvas: fabric.Canvas | null;
  canvasRef: (node: HTMLCanvasElement | null) => void;
  originalImage: fabric.Image | null;
  hasImage: boolean;

  state: EditorState;

  history: {
    save: () => void;
    undo: () => void;
    redo: () => void;
    canUndo: boolean;
    canRedo: boolean;
    clear: () => void;
  };

  blur: {
    add: () => void;
    remove: (id: string) => void;
    clearAll: () => void;
    activeRects: fabric.Rect[];
  };

  crop: {
    start: () => void;
    apply: () => Promise<void>;
    cancel: () => void;
    isActive: boolean;
  };

  drawing: {
    enable: () => void;
    disable: () => void;
    toggle: () => void;
    isActive: boolean;
  };

  shapes: {
    addRectangle: () => void;
    addCircle: () => void;
    add: (type: ShapeType) => void;
  };

  text: {
    add: (initialText?: string) => void;
    setFontSize: (size: number) => void;
    setFontFamily: (family: string) => void;
    setColor: (color: string) => void;
    setFontWeight: (weight: "normal" | "bold") => void;
    setFontStyle: (style: "normal" | "italic") => void;
    setUnderline: (underline: boolean) => void;
    setHighlightColor: (color: string | null) => void;
    setTextAlign: (align: "left" | "center" | "right" | "justify") => void;
    setLineHeight: (lineHeight: number) => void;
    applyStylePreset: (preset: "normal" | "heading1" | "heading2" | "heading3") => void;
    clearFormatting: () => void;
    fontFamilies: string[];
  };

  eraser: {
    enable: () => void;
    disable: () => void;
    toggle: () => void;
    isActive: boolean;
    setWidth: (width: number) => void;
  };

  selection: {
    enable: () => void;
    disable: () => void;
    toggle: () => void;
    deleteSelected: () => void;
    selected: fabric.Object | null;
    clear: () => void;
    isActive: boolean;
  };

  style: {
    color: string;
    setColor: (color: string) => void;
    strokeWidth: number;
    setStrokeWidth: (width: number) => void;
  };

  zoom: {
    level: number;
    in: (factor?: number) => void;
    out: (factor?: number) => void;
    set: (level: number) => void;
    reset: () => void;
  };

  exportToBlob: () => Promise<Blob | null>;
  exportToDataURL: (format?: string, quality?: number) => string | null;
  exportCanvasJSON: () => string | null;

  dispose: () => void;
}
