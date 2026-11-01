import { GangType } from "../types/types";
import { ApiMembers } from "./Members";

export const ApiGang: GangType = {
  name: "lossantosvagos",
  title: "Respected",
  label: "Los Santos Vagos",
  logo: "https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/VagosSpray.png",
  level: 4505,
  members: ApiMembers.length,
  maxMembers: 10,
  missions: 2,
  graffitis: 11,
  max: 1000,
  daily: 2400,
  dailyMax: 2500,
  strain: "La Virgen",
  phrase: "Vatos Locos",
  allPermissions: [
    { value: "members", label: "Members" },
    { value: "missions", label: "Missions" },
    { value: "labs", label: "Labs" },
    { value: "stashes", label: "Stashes" },
    { value: "blackmarket", label: "Black Market" },
  ],
};

export const ApiAllGangs: GangType[] = [
  {
    name: "lossantosvagos",
    title: "Respected",
    label: "Los Santos Vagos",
    logo: "https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/VagosSpray.png",
    level: 4505,
    members: ApiMembers.length,
    maxMembers: 10,
    missions: 2,
    graffitis: 11,
    max: 1000,
    daily: 2400,
    dailyMax: 2500,
    strain: "La Virgen",
    phrase: "Vatos Locos",
    allPermissions: [
      { value: "members", label: "Members" },
      { value: "missions", label: "Missions" },
      { value: "labs", label: "Labs" },
      { value: "stashes", label: "Stashes" },
      { value: "blackmarket", label: "Black Market" },
    ],
  },
];
