import { CrewProperties, SettingsType } from "../../types/types";

export interface UndergroundType {
  name: string;
  crew: CrewProperties;
  title: string;
  time: string;
  bestTime: string;
  trackName: string;
  settings: SettingsType;
  vehicle: string;
  position: number;
  driftPoints: number;
}
