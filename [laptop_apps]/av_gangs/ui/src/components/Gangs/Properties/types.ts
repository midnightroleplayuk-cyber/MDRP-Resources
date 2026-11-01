export type UpgradeKeys = "stash" | "production" | "security";

interface Price {
  price: number;
  level: number;
}

export interface PropertyType {
  identifier: string;
  shell: string;
  type: string;
  upgrades: {
    [key in UpgradeKeys]: number;
  };
  isOpen: boolean;
  label: string;
  entry: {
    x: number;
    y: number;
    z: number;
  };
  raided: boolean;
  working: string;
  color: string;
  door: string;
  originalPrice: number;
  photo?: string;
  availableUpgrades: {
    [key in UpgradeKeys]: {
      label: string;
      prices: Price[];
      value: UpgradeKeys;
    };
  };
}
