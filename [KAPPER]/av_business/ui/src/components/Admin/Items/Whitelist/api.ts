export interface WhitelistItems {
  value: string;
  label: string;
  jobs: string[];
  type: string[];
  override: boolean;
}

export const ApiItemWhitelist: WhitelistItems = {
  value: "water",
  label: "Water",
  jobs: ["burgershot", "harbourcafe", "upnatom"],
  type: ["drink"],
  override: true,
};

export const ApiWhitelist: WhitelistItems[] = [
  {
    value: "water",
    label: "Water",
    jobs: ["burgershot", "harbourcafe", "upnatom"],
    type: ["drink"],
    override: true,
  },
  {
    value: "burgershotcola",
    label: "Burgershot eCola",
    jobs: ["burgershot"],
    type: ["drink"],
    override: true,
  },
  {
    value: "WEAPON_ASSAULTRIFLE_MK2",
    label: "Assault Rifle MK2",
    jobs: ["burgershot"],
    type: ["drink"],
    override: true,
  },
];
