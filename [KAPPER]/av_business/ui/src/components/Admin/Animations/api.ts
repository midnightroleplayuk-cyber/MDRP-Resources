export interface PropData {
  model: string;
  bone: number;
  pos: { x: number; y: number; z: number };
  rot: { x: number; y: number; z: number };
}

export interface AnimType {
  value: string;
  label: string;
  progressLabel: string;
  time: number;
  type: string[];
  jobs: string[] | false;
  canWalk: boolean;
  canDrive: boolean;
  anim: {
    dict: string;
    clip: string;
    flag?: number;
  };
  prop?: PropData | PropData[];
}

export const ApiAnimation: AnimType = {
  canWalk: true,
  type: ["food", "fryer"],
  label: "Burger",
  jobs: false,
  time: 5000,
  prop: {
    rot: {
      x: -50.0,
      y: 16.0,
      z: 60.0,
    },
    bone: 18905,
    pos: {
      x: 0.12999999523162,
      y: 0.05000000074505,
      z: 0.01999999955296,
    },
    model: "prop_cs_burger_01",
  },
  progressLabel: "Eating",
  anim: {
    clip: "mp_player_int_eat_burger",
    dict: "mp_player_inteat@burger",
  },
  value: "burger",
  canDrive: true,
};

export const ApiAnimations: AnimType[] = [
  {
    type: ["food"],
    anim: {
      clip: "mp_player_int_eat_burger",
      dict: "mp_player_inteat@burger",
    },
    time: 5000,
    prop: {
      model: "prop_cs_burger_01",
      pos: { x: -50, y: 16, z: 60 },
      bone: 18905,
      rot: { x: 0.13, y: 0.05, z: 0.02 },
    },
    label: "Burger",
    canWalk: true,
    jobs: false,
    canDrive: true,
    value: "burger",
    progressLabel: "Eating",
  },
  {
    type: ["food"],
    anim: {
      clip: "mp_player_int_eat_burger",
      dict: "mp_player_inteat@burger",
    },
    time: 5000,
    prop: {
      model: "prop_sandwich_01",
      pos: { x: -50, y: 16, z: 60 },
      bone: 18905,
      rot: { x: 0.13, y: 0.05, z: 0.02 },
    },
    label: "Sandwich",
    canWalk: true,
    jobs: false,
    canDrive: true,
    value: "sandwich",
    progressLabel: "Eating",
  },
  {
    type: ["drink"],
    anim: { clip: "loop_bottle", dict: "mp_player_intdrink" },
    time: 5000,
    prop: {
      model: "prop_ecola_can",
      pos: { x: 240, y: -30, z: -2 },
      bone: 18905,
      rot: { x: 0.11, y: -0.01, z: 0.03 },
    },
    label: "Soda",
    canWalk: true,
    jobs: false,
    canDrive: true,
    value: "soda",
    progressLabel: "Drinking",
  },
];
