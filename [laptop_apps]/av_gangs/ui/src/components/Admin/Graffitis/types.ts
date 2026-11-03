interface Coords {
  y: number;
  x: number;
  z: number;
}

interface Rotation {
  y: number;
  x: number;
  z: number;
}

export interface GraffitiType {
  gang: string;
  label?: string;
  coords: Coords;
  identifier: string;
  rotation: Rotation;
  color?: string;
}
