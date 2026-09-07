export interface ImageEditorConfig {
  imageUrl: string;
  initialCanvasJson?: string;
  width?: number;
  height?: number;
  maxHistorySize?: number;
  defaultColor?: string;
  defaultStrokeWidth?: number;
  blurIntensity?: number;
  historyThrottleMs?: number;
  blurThrottleMs?: number;
  canvasPadding?: number;
}

export interface CanvasSize {
  width: number;
  height: number;
}

export interface Bounds {
  left: number;
  top: number;
  width: number;
  height: number;
}
