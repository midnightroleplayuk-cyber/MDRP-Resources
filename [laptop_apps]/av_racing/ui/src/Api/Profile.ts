import { ProfileProperties } from "../types/types";
import { ApiFavorites } from "./Tracks";

export const ApiProfile: ProfileProperties = {
  name: "User-3930",
  isCop: false,
  identifier: "F197ZVW4",
  photo: "",
  favorites: ApiFavorites,
  alerts: false,
  underground: true,
  settings: {
    story: "",
    blip: "red",
    smoke: "violet",
    nationality: "Unknown",
    animation: "smoke",
  },
  isAdmin: false,
  isBoss: false,
  races: 0,
  wins: 0,
  elo: 100,
  notifications: [
    {
      identifier: "abc123",
      time: 123123,
      message:
        "You received a Invertero Coquette D10, you can claim it at Pillbox Garage.",
    },
  ],
  crew: {
    name: "yokai",
    isBoss: true,
    label: "Yokai Racing Club",
    wins: 5,
    photo:
      "https://files.fivemerr.com/images/4bfa576e-7a9d-4cc6-a9f6-a6c0c551d279.png",
  },
};
