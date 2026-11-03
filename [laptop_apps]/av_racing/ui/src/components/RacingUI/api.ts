export interface RacePlayer {
  pos: number;
  name: string;
  dist: number;
}

export interface RaceInfo {
  CurrentCheckpoint: number;
  TotalCheckpoints: number;
  TotalLaps: number;
  CurrentLap: number;
  RaceName: string;
  Time: number;
  TotalTime: number;
  BestLap: number;
  Position: number;
  TotalRacers: number;
  Players: RacePlayer[];
  isDrift?: boolean;
  DriftTimeLeft?: number;
  DriftPoints?: number;
  Combo?: number;
  GhostDelta?: number;
}

export const MOCK_INFO: RaceInfo = {
  CurrentCheckpoint: 43,
  TotalCheckpoints: 137,
  TotalLaps: 3,
  CurrentLap: 2,
  RaceName: "AV Scripts",
  Time: 72381,
  TotalTime: 215000,
  BestLap: 68204,
  Position: 5,
  TotalRacers: 8,
  Players: [
    { pos: 1, name: "NOS Runner", dist: 21.5 },
    { pos: 2, name: "Anon-716069", dist: 13.7 },
    { pos: 3, name: "NOS Enzo", dist: 8.2 },
    { pos: 4, name: "Ghost Rider", dist: 3.1 },
    { pos: 5, name: "Tú", dist: 0 },
    { pos: 6, name: "MW MonkeyMan", dist: -4.2 },
    { pos: 7, name: "SpeedFreak", dist: -9.8 },
    { pos: 8, name: "Turbo Mike", dist: -18.3 },
  ],
  isDrift: false,
  DriftTimeLeft: 45600,
  DriftPoints: 12450,
  Combo: 2.5,
  GhostDelta: -1234,
};

export const DEFAULT_INFO: RaceInfo = {
  CurrentCheckpoint: 1,
  TotalCheckpoints: 1,
  TotalLaps: 1,
  CurrentLap: 1,
  RaceName: "AV Scripts",
  Time: 0,
  TotalTime: 0,
  BestLap: 0,
  Position: 0,
  TotalRacers: 0,
  Players: [],
};
