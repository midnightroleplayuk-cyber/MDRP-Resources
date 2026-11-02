export interface SelectType {
  value: string;
  label: string;
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

export interface Track {
  id: string;
  videoId: string;
  url: string;
  title: string;
  artist: string;
  album: string;
  durationSecs: number;
  cover: string;
  volume?: number;
}

export interface Playlist {
  id: string;
  name: string;
  cover: string;
  songs: Track[];
  createdAt?: number;
}

export interface PlayerState {
  track: Track | null;
  playing: boolean;
  progress: number;
  volume: number;
  currentTime: number;
  durationSecs: number;
  sessionId?: string;
}
