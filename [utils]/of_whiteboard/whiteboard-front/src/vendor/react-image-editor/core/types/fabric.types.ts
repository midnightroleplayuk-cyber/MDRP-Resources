import type { fabric } from "fabric";

export type ShapeType = "rectangle" | "circle" | "text";

export type EditorMode = "select" | "draw" | "crop" | "blur";

export type EditorTool =
  | "select"
  | "draw"
  | "crop"
  | "blur"
  | "rectangle"
  | "circle"
  | "text";

export interface EditorFabricObject extends fabric.Object {
  id?: string;
  isDrawing?: boolean;
  isBlurPatch?: boolean;
  blurRectId?: string;
  isShape?: boolean;
  shapeType?: ShapeType;
  isText?: boolean;
  isEraserPath?: boolean;
}

export interface EditorFabricIText extends fabric.IText {
  id?: string;
  isText?: boolean;
  isShape?: boolean;
  shapeType?: ShapeType;
}

export interface EditorFabricImage extends fabric.Image {
  id?: string;
  originalWidth?: number;
  originalHeight?: number;
}

export interface EditorFabricCanvas extends fabric.Canvas {
  isUpdatingBlur?: boolean;
}

export interface EditorFabricRect extends fabric.Rect {
  id?: string;
  isBlurPatch?: boolean;
  blurRectId?: string;
}

export interface EditorFabricPath extends fabric.Path {
  isDrawing?: boolean;
}

export interface FabricSelectionEvent {
  selected?: fabric.Object[];
  deselected?: fabric.Object[];
}

export interface FabricPathCreatedEvent {
  path?: fabric.Path;
}
