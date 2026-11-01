import { atom, selector } from "recoil";
import { getLang } from "../hooks/getLang";
import {
  EventResult,
  EventType,
  ProfileProperties,
  SelectType,
  TrackType,
} from "../types/types";
import { ApiProfile } from "../Api/Profile";
import { ApiTrack } from "../Api/Track";

const langSelector = selector({
  key: "langSelector",
  get: async () => {
    const response = await getLang();
    return response;
  },
});

export const Lang = atom<Object>({
  key: "lang",
  default: langSelector,
});

export const Profile = atom<ProfileProperties>({
  key: "profile",
  default: ApiProfile,
});

export const Events = atom<any>({
  key: "events",
  default: [],
});

export const Categories = atom<SelectType[]>({
  key: "categories",
  default: [],
});

export const Classes = atom<SelectType[]>({
  key: "classes",
  default: [
    { value: "A", label: "A" },
    { value: "C", label: "C" },
  ],
});

export const showCountdownState = atom({
  key: "showCountdownState",
  default: false,
});

export const showRacingUIState = atom({
  key: "showRacingUIState",
  default: false,
});

export const eventDetails = atom<EventType | null | EventResult>({
  key: "eventDetails",
  default: null,
});

export const CreatorData = atom<TrackType>({
  key: "creator",
  default: ApiTrack,
});
