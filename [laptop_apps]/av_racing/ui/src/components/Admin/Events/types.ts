export interface RandomEventsType {
  enabled: boolean;
  interval: number;
  tracks: string[];
  minRacers: number;
  startTime: [number, number];
  moneyAccounts: string[];
  minEntry: number;
  maxEntry: number;
  minPayout: number;
  maxPayout: number;
  phasing: string[];
  laps: [number, number];
  classes: string[];
  reversed: boolean;
  isRanked: boolean;
}

export interface RandomTracksType {
  identifier: string;
  name: string;
  type: string;
  checkpoints: number;
  isRanked?: boolean;
}
