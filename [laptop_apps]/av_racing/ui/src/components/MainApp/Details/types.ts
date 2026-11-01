interface Coords {
  x: number;
  z: number;
  y: number;
}

interface Rotation {
  left: number;
  right: number;
}

interface Offset {
  left: Coords;
  right: Coords;
}

export interface CheckpointType {
  pileright?: number;
  coords: Coords;
  pileleft?: number;
  rotation?: Rotation;
  offset: Offset;
  blip?: number;
}
