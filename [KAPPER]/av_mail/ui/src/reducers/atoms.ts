import { atom } from "jotai";
import type {
  Profile,
  FolderKey,
  ScreenKey,
  FullMessage,
} from "../types/types";

export const Lang = atom<any>({});

export const authViewAtom = atom<"login" | "signup" | "app">("login");

export const profileAtom = atom<Profile | null>(null);

export const screenAtom = atom<ScreenKey>("mail");

export const folderAtom = atom<FolderKey>("inbox");
export const selectedAtom = atom<FullMessage | null>(null);

export const composeAtom = atom<boolean>(false);
export const composePrefillAtom = atom<{
  to?: string;
  subject?: string;
  body?: string;
  forwardOf?: number;
}>({});

export const suggestedEmailAtom = atom<string>("");
export const initDoneAtom = atom<boolean>(false);

export const adminOpenAtom = atom<boolean>(false);
