import { atom } from "recoil";
import { GangType, ColorsType, PermissionsType } from "../types/types";
import { ApiGang } from "../api/Gang";

export const Lang = atom<Object>({
  key: "lang",
  default: {},
});

export const Gang = atom<GangType>({
  key: "gang",
  default: ApiGang,
});

export const Permissions = atom<PermissionsType>({
  key: "permissions",
  default: {},
});

export const Identifier = atom<string>({
  key: "identifier",
  default: "abc123",
});

export const Colors = atom<ColorsType>({
  key: "colors",
  default: {
    buttons: "#c0eb75",
    text: "black",
  },
});

export const CursorState = atom<boolean>({
  key: "cursor",
  default: true,
});
