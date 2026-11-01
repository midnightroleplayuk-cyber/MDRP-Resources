export interface SelectType {
  value: string;
  label: string;
}

export interface GangType {
  name: string;
  label: string;
  logo: string;
  level: number;
  members: number;
  maxMembers: number;
  missions: number;
  phrase: string;
  graffitis: number;
  max: number;
  dailyMax: number;
  daily: number;
  strain: string;
  allPermissions: SelectType[];
  title: string;
  colors?: {
    buttons?: string;
    text?: string;
  };
}

export interface Member {
  identifier: string;
  alias: string;
  playerName: string;
  name: string;
  rank: string;
  photo: string;
  joined: string;
  permissions: string[];
  reputation: number;
}

type ModalOptions = {
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
};

export type ModalType = {
  state: boolean;
  info: {
    size?: string;
    title?: string;
    options: ModalOptions[];
    button?: string;
    extraData?: any;
  };
  callback?: (data: any) => void;
};

type UpgradeKeys = "stash" | "production" | "security";

interface Price {
  price: number;
  level: number;
}

export interface PropertyType {
  identifier: string;
  entry: Object;
  working: string;
  label: string;
  type: string;
  shell: string;
  photo: string;
  upgrades: {
    [key in UpgradeKeys]: number;
  };
  raided: boolean;
  isOpen: boolean;
  nextCook: number;
  availableUpgrades: {
    [key in UpgradeKeys]: {
      label: string;
      prices: Price[];
      value: UpgradeKeys;
    };
  };
}

interface CrewMember {
  name: string;
  identifier: string;
}

export interface GroupType {
  identifier: string;
  owner: string;
  label: string;
  password?: string;
  status: string;
  members: CrewMember[];
  maxMembers: number;
}

export interface MissionType {
  identifier: string;
  label: string;
  price: number | false;
  difficulty: number;
  level: number;
  image: string;
  description: string;
  started: boolean;
}

export interface ZoneType {
  name: string;
  gang: string;
  label: string;
  color: string;
  polygon: [number, number][];
}

export interface ColorsType {
  buttons: string;
  text: string;
}

export interface GangData {
  points: number;
  label: string;
}

export interface ZoneData {
  [key: string]: GangData;
}

export interface AllTerritoriesType {
  [key: string]: ZoneData;
}

export interface GangStats {
  name: string;
  gangLabel: string;
  controlledZones: number;
  totalPoints: number;
  logo: string;
}

export interface ProductType {
  name: string;
  label: string;
  description: string;
  price: number;
  level: number;
  photo: string;
}

export interface DoorType {
  identifier: string;
  street: string;
  x: number;
  y: number;
  z: number;

  onUse?: boolean;
}

export type PermissionsType = {
  [key: string]: boolean;
};
