import { ProgressionType } from "./types";

export const ApiProgression: ProgressionType = {
  xp: 1140,
  redeemed: ["Level1"],
  levels: [
    {
      label: "S+",
      level: 3,
      value: "Level3",
      description: "Unlock access to join S+ races",
    },
    { image: "tokens.png", label: "50 Cosmo", level: 15, value: "Level15" },
    { label: "50 Cosmo", level: 25, value: "Level25" },
    {
      description: "The vehicle will be sent to your Pillbox Garage",
      image: "vehicle.png",
      label: "Invertero Coquette D10",
      level: 50,
      value: "Level50",
    },
    { label: "10 Cosmo", level: 5, value: "Level5" },
    { image: "tokens.png", label: "50 Cosmo", level: 20, value: "Level20" },
    { image: "tokens.png", label: "25 Cosmo", level: 10, value: "Level10" },
    { image: "tokens.png", label: "10 Cosmo", level: 1, value: "Level1" },
    { image: "tokens.png", label: "100 Cosmo", level: 30, value: "Level30" },
    { image: "tokens.png", label: "250 Cosmo", level: 40, value: "Level40" },
  ],
};
