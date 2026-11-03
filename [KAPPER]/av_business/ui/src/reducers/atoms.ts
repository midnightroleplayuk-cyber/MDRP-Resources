import { atom } from "jotai";
import { ApiBusiness } from "../API/business";
import { BusinessType, Permissions } from "../types/types";

export const Lang = atom<Object>({});

export const BusinessInfo = atom<BusinessType>(ApiBusiness);

export const MyPermissions = atom<Permissions>({});
