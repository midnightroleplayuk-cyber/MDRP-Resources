export interface Profile {
  username: string;
  photo: string;
  strain: string;
}

interface Inputs {
  key: string;
  label: string;
  description: string;
  min: number;
  max: number;
  color: string;
  value?: number;
  valueLabel?: number;
}

export interface InputInfo {
  title?: string;
  description?: string;
  inputs?: Inputs[];
}

export interface ZoneInfo {
  name: string;
  label: string;
  drug: string | boolean;
  strain: string | boolean;
  color: string;
  polygon: [number, number][];
}

export interface LabInfo {
  name: string;
  label: string;
  color: string;
  x: number;
  y: number;
}

export interface keyHolder {
  name: string;
  identifier: string;
}

export interface LabType {
  type: string;
  owner: string;
  isOwner: boolean;
  identifier: string;
  coords: {
    x: number;
    y: number;
    z: number;
  };
  keys: keyHolder[];
  drug: string;
  canCook: boolean;
  lastCook?: number;
  now?: number;
  highestPurity: number;
  xp: number;
  maintenance: boolean | number;
  isExpired: boolean;
  canTransfer: boolean;
  canDelete: boolean;
  isCop: boolean;
  created: number;
  upgrades: {
    security: number;
    stash: number;
  };
}
