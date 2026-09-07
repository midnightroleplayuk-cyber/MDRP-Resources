import type { ImageEditorConfig } from "./config.types";
import type { UseImageEditorReturn } from "./hooks.types";

export interface ImageEditorProps {
  imageUrl: string;
  onSave: (blob: Blob) => void;
  onCancel: () => void;
  config?: Partial<ImageEditorConfig>;
  classNames?: ImageEditorClassNames;
  labels?: ImageEditorLabels;
  showCancelButton?: boolean;
}

export interface ImageEditorClassNames {
  container?: string;
  header?: string;
  toolbar?: string;
  canvas?: string;
  canvasWrapper?: string;
  button?: string;
  saveButton?: string;
  cancelButton?: string;
  zoomButton?: string;
}

export interface ImageEditorLabels {
  save?: string;
  cancel?: string;
  select?: string;
  draw?: string;
  crop?: string;
  blur?: string;
  rectangle?: string;
  circle?: string;
  undo?: string;
  redo?: string;
  delete?: string;
  applyCrop?: string;
  cancelCrop?: string;
  zoomIn?: string;
  zoomOut?: string;
  strokeWidth?: string;
}

export interface ToolbarRenderProps {
  editor: UseImageEditorReturn;
  tools: {
    select: { onClick: () => void; isActive: boolean; disabled: boolean };
    draw: { onClick: () => void; isActive: boolean; disabled: boolean };
    crop: { onClick: () => void; isActive: boolean; disabled: boolean };
    blur: { onClick: () => void; isActive: boolean; disabled: boolean };
    rectangle: { onClick: () => void; isActive: boolean; disabled: boolean };
    circle: { onClick: () => void; isActive: boolean; disabled: boolean };
    undo: { onClick: () => void; disabled: boolean };
    redo: { onClick: () => void; disabled: boolean };
    delete: { onClick: () => void; disabled: boolean };
  };
  style: {
    color: string;
    strokeWidth: number;
    onColorChange: (color: string) => void;
    onStrokeWidthChange: (width: number) => void;
  };
}

export interface CanvasRenderProps {
  canvasRef: React.RefObject<HTMLCanvasElement>;
  zoom: {
    level: number;
    zoomIn: () => void;
    zoomOut: () => void;
    reset: () => void;
  };
  isReady: boolean;
}
