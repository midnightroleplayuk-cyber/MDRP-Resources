import {
  RandomEventsType,
  RandomTracksType,
} from "../components/Admin/Events/types";

export const ApiRandomEvents: RandomEventsType = {
  interval: 30,
  enabled: false,
  startTime: [0, 30],
  minRacers: 5,
  tracks: ["abc123", "track1", "abc1231"],
  classes: [],
  laps: [1, 3],
  maxEntry: 100,
  minEntry: 0,
  maxPayout: 1000,
  minPayout: 50,
  moneyAccounts: ["cosmo"],
  phasing: [],
  reversed: true,
  isRanked: true,
};

export const ApiRandomTracks: RandomTracksType[] = [
  {
    identifier: "abc1231",
    name: "Lorem ipsum dolor sit amet consectetur adipiscing elit lacinia",
    type: "circuit",
    checkpoints: 50,
  },
  {
    identifier: "abc1232",
    name: "Test Track 2",
    type: "circuit",
    checkpoints: 50,
    isRanked: true,
  },
  {
    identifier: "abc1233",
    name: "Test Track 3",
    type: "circuit",
    checkpoints: 50,
  },
  {
    identifier: "abc1234",
    name: "Test Track 4",
    type: "circuit",
    checkpoints: 50,
  },
  {
    identifier: "abc12351",
    name: "Test Track 5",
    type: "circuit",
    checkpoints: 50,
  },
  {
    identifier: "abc123522",
    name: "Test Track 6",
    type: "circuit",
    checkpoints: 50,
  },
  {
    identifier: "abc12351111",
    name: "Test Track 7",
    type: "circuit",
    checkpoints: 50,
  },
  {
    identifier: "abc123514",
    name: "Test Track 8",
    type: "circuit",
    checkpoints: 50,
  },
  {
    identifier: "abc12352",
    name: "Test Track 9",
    type: "circuit",
    checkpoints: 50,
  },
  {
    identifier: "abc123513",
    name: "Test Track 10",
    type: "circuit",
    checkpoints: 50,
  },
];
