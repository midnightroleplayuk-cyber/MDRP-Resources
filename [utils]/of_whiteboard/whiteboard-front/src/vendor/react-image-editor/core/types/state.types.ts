import type { fabric } from "fabric";

export interface EditorState {
  hasImage: boolean;
  isDrawing: boolean;
  isCropping: boolean;
  isSelectMode: boolean;
  selectedObject: fabric.Object | null;
  currentColor: string;
  currentStrokeWidth: number;
  canUndo: boolean;
  canRedo: boolean;
  zoom: number;
}

export interface HistoryState {
  json: string;
  timestamp: number;
}
