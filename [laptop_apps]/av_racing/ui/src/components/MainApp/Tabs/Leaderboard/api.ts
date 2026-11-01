export interface RaceRow {
  track: string;
  vehicle: string;
  position: number;
  total: number;
  time: string;
  date: number;
}

export interface ProfileData {
  name: string;
  elo: number;
  races: number;
  wins: number;
  losses: number;
  winrate: number;
  favTrack?: string;
  favTrackBest?: string;
  favVehicle?: string;
  last10: RaceRow[];
}

export const MOCK_PROFILE: ProfileData = {
  name: "NOS Runner",
  elo: 1840,
  races: 128,
  wins: 47,
  losses: 81,
  winrate: 37,
  favTrack: "Vinewood Sprint",
  favTrackBest: "1:42.318",
  favVehicle: "Elegy RH8",
  last10: [
    {
      track: "Vinewood Sprint",
      vehicle: "Elegy RH8",
      position: 1,
      total: 8,
      time: "1:42.318",
      date: 0,
    },
    {
      track: "Docks Circuit",
      vehicle: "Elegy RH8",
      position: 3,
      total: 8,
      time: "2:11.905",
      date: 0,
    },
    {
      track: "Airport Dash",
      vehicle: "Comet S2",
      position: 5,
      total: 10,
      time: "1:58.442",
      date: 0,
    },
    {
      track: "Vinewood Sprint",
      vehicle: "Elegy RH8",
      position: 2,
      total: 6,
      time: "1:43.771",
      date: 0,
    },
    {
      track: "Mountain Loop",
      vehicle: "Sultan RS",
      position: 4,
      total: 7,
      time: "3:05.220",
      date: 0,
    },
    {
      track: "Docks Circuit",
      vehicle: "Elegy RH8",
      position: 1,
      total: 5,
      time: "2:09.660",
      date: 0,
    },
    {
      track: "City Night Run",
      vehicle: "Comet S2",
      position: 6,
      total: 9,
      time: "2:24.019",
      date: 0,
    },
    {
      track: "Airport Dash",
      vehicle: "Elegy RH8",
      position: 2,
      total: 8,
      time: "1:57.113",
      date: 0,
    },
    {
      track: "Mountain Loop",
      vehicle: "Sultan RS",
      position: 7,
      total: 8,
      time: "3:12.884",
      date: 0,
    },
    {
      track: "Vinewood Sprint",
      vehicle: "Elegy RH8",
      position: 3,
      total: 10,
      time: "1:44.507",
      date: 0,
    },
  ],
};
