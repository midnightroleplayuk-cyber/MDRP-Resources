export interface BillCfgEntry {
  enabled: boolean;
  label: string;
  perCraftCost: number;
  intervalDays: number;
}

export interface BillsConfig {
  dirtPerAction: number;
  cleanPerItem: number;
  cleaningItems: string[];
  gas: BillCfgEntry;
  electricity: BillCfgEntry;
  water: BillCfgEntry;
}

export interface RentState {
  enabled: boolean;
  amount: number;
  interval: number;
}

export const ApiCfg: BillsConfig = {
  dirtPerAction: 0.5,
  cleanPerItem: 20,
  cleaningItems: ["cleaning_kit"],
  gas: { enabled: true, label: "Gas", perCraftCost: 5, intervalDays: 7 },
  electricity: {
    enabled: true,
    label: "Electricity",
    perCraftCost: 8,
    intervalDays: 7,
  },
  water: { enabled: true, label: "Water", perCraftCost: 3, intervalDays: 7 },
};

export interface TaxState {
  rate: number;
  interval: number;
}
