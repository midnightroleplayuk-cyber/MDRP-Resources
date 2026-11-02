interface Vector3 {
  x: number;
  y: number;
  z: number;
}

interface CraftingProp {
  flag: number;
  model: string;
  bone: number;
  pos: Vector3;
  rot: Vector3;
}

export interface CraftingAction {
  value: string;
  label: string;
  duration: number;
  anim: {
    dict: string;
    clip: string;
    flag?: number;
  };
  prop: CraftingProp[];
}

export const ApiCraftingItem: CraftingAction = {
  value: "",
  label: "",
  duration: 5000,
  anim: {
    dict: "anim@amb@business@coc@coc_unpack_cut@",
    clip: "fullcut_cycle_v6_cokecutter",
  },
  prop: [],
};

export const ApiCrafting: CraftingAction[] = [
  {
    value: "drink",
    label: "Crafting",
    duration: 5000,
    anim: {
      dict: "anim@amb@business@coc@coc_unpack_cut@",
      clip: "fullcut_cycle_v6_cokecutter",
    },
    prop: [],
  },
  {
    value: "food",
    label: "Crafting",
    duration: 5000,
    anim: {
      dict: "anim@amb@business@coc@coc_unpack_cut@",
      clip: "fullcut_cycle_v6_cokecutter",
    },
    prop: [
      {
        flag: 49,
        model: "prop_knife",
        bone: 57005,
        pos: { x: 0.13, y: 0.14, z: 0.09 },
        rot: { x: 40.0, y: 0.0, z: 0.0 },
      },
    ],
  },
  {
    value: "alcohol",
    label: "Crafting",
    duration: 5000,
    anim: {
      dict: "anim@amb@business@coc@coc_unpack_cut@",
      clip: "fullcut_cycle_v6_cokecutter",
    },
    prop: [],
  },
  {
    value: "joint",
    label: "Crafting",
    duration: 5000,
    anim: {
      dict: "anim@amb@business@coc@coc_unpack_cut@",
      clip: "fullcut_cycle_v6_cokecutter",
    },
    prop: [],
  },
];
