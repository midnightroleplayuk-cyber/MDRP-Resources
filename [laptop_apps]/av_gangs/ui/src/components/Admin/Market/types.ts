import { SelectType } from "../../../types/types";

interface UpgradePrice {
  level: number;
  price: number;
}

interface Upgrade {
  label: string;
  prices: UpgradePrice[];
  value: string;
}

interface UpgradesType {
  production?: Upgrade;
  security?: Upgrade;
  stash?: Upgrade;
}

export interface ItemType {
  name?: string;
  enabled: boolean;
  category: string;
  description: string;
  output?: string;
  ingredients?: string[];
  label: string;
  level: number;
  photo: string;
  price: number;
  product?: string;
  shell: string;
  type?: string;
  upgrades: UpgradesType;
  allowedGangs?: string[];
}
