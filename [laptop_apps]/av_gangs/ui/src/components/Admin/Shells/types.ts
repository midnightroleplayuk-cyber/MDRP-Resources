export interface Door {
  x: number;
  y: number;
  z: number;
  heading: number;
  dist: number;
  label: string;
  event: string;
}

export interface Interaction {
  x: number;
  y: number;
  z: number;
  dist: number;
  name?: string;
  label: string;
  event: string;
  type: string;
}

export interface Ped {
  x: number;
  y: number;
  z: number;
  heading: number;
  model: string;
  dict: string;
  animation: string;
  entity?: number;
}

export interface ShellType {
  label?: string;
  shell?: string;
  zIndex: number;
  door: Door;
  interactions: Interaction[];
  peds: Ped[];
}

export interface AnimationsType {
  dict: string;
  animation: string;
  label: string;
}

export interface PedsType {
  model: string;
  label: string;
}

export interface ExtraDataType {
  type: "peds" | "interactions" | "newped" | "newinteraction";
  index: number;
}
