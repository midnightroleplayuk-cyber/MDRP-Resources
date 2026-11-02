export interface SelectType {
  value: string;
  label: string;
  server?: boolean;
  owned?: boolean;
  type?: string;
}

interface ModalOptions {
  name?: string;
  type: string;
  image?: string;
  width?: number;
  height?: number;
  title?: string;
  default?: string | number | boolean | string[];
  icon?: string;
  style?: React.CSSProperties;
  searchable?: boolean;
  description?: string;
  options?: SelectType[];
  size?: string;
  color?: string;
  disabled?: boolean;
  asterisk?: boolean;
  min?: number;
  decimal?: boolean;
  negative?: boolean;
  zero?: boolean;
  isMoney?: boolean;
  max?: number;
}

export interface ModalType {
  state: boolean;
  info?: {
    size?: string;
    title?: string;
    options: ModalOptions[];
    button?: string;
    extraData?: any;
  };
  callback?: (data: any) => void;
}

export type ViewMode = "grid" | "map";

interface CamSettings {
  allowZoom?: boolean;
  nightVision?: boolean;
  thermalVision?: boolean;
  motionDetection?: boolean;
  recording?: boolean;
  isBreakable?: boolean;
  damageChance?: number;
  rotationAngle: number;
  allowHacking?: boolean;
  model?: string;
  replay?: boolean;
  plugged?: boolean;
}

export interface CameraType {
  identifier: string;
  owner: string;
  group_id?: string | null;
  label: string;
  location: string;
  type: string;
  thumbnail: string;
  coords: {
    coords: { x: number; y: number; z: number };
    rotation: { x: number; y: number; z: number };
  };
  battery: number;
  settings: CamSettings;
  status?: "live" | "offline" | "unassigned" | "support-needed";
  favorite?: boolean;
  distance?: number;
  owned?: boolean;
}
