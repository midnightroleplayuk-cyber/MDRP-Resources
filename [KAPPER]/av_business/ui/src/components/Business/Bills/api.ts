export interface BillEntry {
  enabled: boolean;
  label: string;
  pending: number;
  lastPaid: number;
  interval: number;
  daysLeft: number | null;
  overdue: boolean;
}

export interface RentEntry {
  enabled: boolean;
  amount: number;
  interval: number;
  lastPaid: number;
  daysLeft: number | null;
  overdue: boolean;
}

export interface TaxEntry {
  enabled: boolean;
  rate: number;
  pending: number;
  interval: number;
  lastPaid: number;
  daysLeft: number | null;
  overdue: boolean;
}

export interface BillsState {
  dirt: number;
  dirtyThreshold: number;
  gas: BillEntry;
  electricity: BillEntry;
  water: BillEntry;
  rent: RentEntry;
  tax: TaxEntry;
}

const EMPTY_BILL: BillEntry = {
  enabled: false,
  label: "",
  pending: 0,
  lastPaid: 0,
  interval: 7,
  daysLeft: null,
  overdue: false,
};

const EMPTY_RENT: RentEntry = {
  enabled: false,
  amount: 0,
  interval: 7,
  lastPaid: 0,
  daysLeft: null,
  overdue: false,
};

const EMPTY_TAX: TaxEntry = {
  enabled: false,
  rate: 0,
  pending: 0,
  interval: 7,
  lastPaid: 0,
  daysLeft: null,
  overdue: false,
};

export const DEFAULT_BILLS: BillsState = {
  dirt: 0,
  dirtyThreshold: 100,
  gas: { ...EMPTY_BILL },
  electricity: { ...EMPTY_BILL },
  water: { ...EMPTY_BILL },
  rent: { ...EMPTY_RENT },
  tax: { ...EMPTY_TAX },
};

export const MockBills: BillsState = {
  dirt: 42,
  dirtyThreshold: 100,
  gas: {
    enabled: true,
    label: "Gas",
    pending: 125,
    lastPaid: 0,
    interval: 7,
    daysLeft: 3.5,
    overdue: false,
  },
  electricity: {
    enabled: true,
    label: "Electricity",
    pending: 200,
    lastPaid: 0,
    interval: 7,
    daysLeft: 0,
    overdue: true,
  },
  water: {
    enabled: true,
    label: "Water",
    pending: 48,
    lastPaid: 0,
    interval: 7,
    daysLeft: 5,
    overdue: false,
  },
  rent: {
    enabled: true,
    amount: 500,
    interval: 7,
    lastPaid: 0,
    daysLeft: 2.0,
    overdue: false,
  },
  tax: {
    enabled: true,
    rate: 10,
    pending: 350,
    interval: 7,
    lastPaid: 0,
    daysLeft: 0,
    overdue: true,
  },
};
