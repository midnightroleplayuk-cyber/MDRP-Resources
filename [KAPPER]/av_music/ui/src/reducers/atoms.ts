import { atom } from "jotai";
import { Device } from "../Api/Api";
import { PlayerState, Playlist, Track } from "../types/types";

export const Lang = atom<any>({});

export const playerAtom = atom<PlayerState>({
  track: null,
  playing: false,
  progress: 0,
  volume: 75,
  currentTime: 0,
  durationSecs: 0,
  sessionId: undefined,
});

export const viewAtom = atom<"browse" | "playlists" | "radio" | "queue">("browse");

export const playlistsAtom = atom<Playlist[]>([]);

export const activeDeviceAtom = atom<string>("laptop");

export const loopModeAtom  = atom<"none" | "track" | "queue">("none");
export const shuffleModeAtom = atom<boolean>(false);

export const deviceQueueAtom = atom<Track[]>([]);
export const queueIndexAtom  = atom<number>(0);

export const adminOpenAtom = atom<boolean>(false);

export const devicesAtom = atom<Device[]>([]);
