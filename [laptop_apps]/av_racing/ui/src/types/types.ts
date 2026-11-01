export interface Member {
  identifier: string;
  name: string;
  photo: string;
  crew: string;
  crewLabel: string;
  isBoss: boolean;
  joined: string;
  races: number;
  wins: number;
  settings: SettingsType;
  elo: number;
}

export interface SettingsType {
  smoke: string;
  blip: string;
  story?: string;
  animation?: string;
  nationality?: string;
  age?: string;
  pathColor?: string;
  pathEnabled?: boolean;
  pathOpacity?: number;
  ghostEnabled?: boolean;
  ghostTarget?: string;
}

export interface CrewProperties {
  name: string;
  label: string;
  isBoss?: boolean | undefined;
  photo?: string;
  wins: number;
  members?: number;
  ranking?: number;
}

interface NotificationsType {
  time: number;
  identifier: string;
  message: string;
}

export interface ProfileProperties {
  isAdmin: boolean;
  identifier: string;
  name: string;
  photo: string;
  crew?: CrewProperties;
  isBoss: boolean;
  joined?: string;
  races: number;
  wins: number;
  settings: SettingsType;
  underground: boolean;
  isCop?: boolean;
  alerts: boolean;
  favorites: string[];
  elo: number;
  notifications: NotificationsType[];
}

export interface EventType {
  buyin: number;
  class: string;
  description?: string;
  host: string;
  hostName: string;
  identifier: string;
  laps: number;
  isRanked?: boolean;
  rewind?: boolean;
  forceFirstPerson?: boolean;
  moneyAccount: string;
  accountLabel: string;
  moneypot: number;
  numRacers: number;
  password: string | false;
  phasing: boolean | string;
  racers: any[];
  seconds: number;
  isCrew?: boolean;
  reversed?: boolean;
  started: boolean;
  startsin: number;
  title: string;
  totalFinished: number;
  track: string;
  trackIdentifier: string;
  type: string;
  driftStartTime?: number;
  driftCheckpointTime?: number;
  elo?: {
    rewards: number[];
    third: number;
    average: number;
  };
}

export interface SelectType {
  value: string;
  label: string;
}

export interface RacerResult {
  name: string;
  crew?: {
    joined: string;
    name: string;
    label: string;
    photo: string;
    isBoss: number;
  };
  settings: {
    age?: string;
    story: string;
    smoke: string;
    nationality: string;
    blip: string;
    animation: string;
  };
  time: string;
  type: string;
  position: number;
  trackName: string;
  vehicle: string;
  bestTime: string;
  driftPoints?: number;
}

export interface EventResult {
  identifier: string;
  class: string;
  numRacers: number;
  host: string;
  type: string;
  results: RacerResult[];
  laps: number;
  track: string;
  eventName: string;
  hostName: string;
  moneypot: number;
  buyin: number;
  accountLabel: string;
  phasing: boolean;
  reversed: boolean;
  isRanked: boolean;
  isCrew: boolean;
}

interface Coords {
  x: number;
  y: number;
  z: number;
}

interface Offset {
  left: Coords;
  right: Coords;
}

interface CheckpointType {
  coords: Coords;
  blip: number;
  offset: Offset;
  model?: string;
}

export interface TrackType {
  name: string;
  identifier: string;
  createdby: string;
  distance: number;
  description: string;
  type: string;
  isRanked?: boolean;
  checkpoints?: CheckpointType[];
  checkpointTotal: number;
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
  info?: {
    size?: string;
    title?: string;
    options: ModalOptions[];
    button?: string;
    extraData?: any;
  };
  callback?: (data: any) => void;
};

export interface ChatType {
  identifier: string;
  name: string;
  message: string;
  date: number;
}

export interface RacerType {
  isDriver: boolean;
  position: number;
  lap: number;
  checkpoint: number;
  finished: boolean;
  vehicle: string;
  identifier: string;
  time: number;
  buyin: number;
  class: string;
  netId: number;
  name: string;
}

export interface RecordEntry {
  photo?: string;
  identifier: string;
  vehicle: string;
  name: string;
  miliseconds: number;
  class: string;
  bestTime: string;
  crew?: string;
}

export interface RecordsType {
  [key: string]: RecordEntry[];
}

export interface RacerLeaderboardType {
  identifier: string;
  name: string;
  photo: string;
  crewLabel?: string;
  ranking?: number;
  races: number;
  wins: number;
  elo: number;
}

export interface SeasonDataType {
  season: number;
  days: number;
}
