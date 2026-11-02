export interface DeliveryStash {
  label: string;
  weight: number;
  slots: number;
}

export interface DeliveriesType {
  enabled: boolean;
  maxDistance: number;
  minProducts: number;
  maxProducts: number;
  maxOrders: number;
  maxPrice: number;
  maxTip: number;
  overprice: number;
  toIgnore: string[];
  deliveryWait: [number, number];
  stash: DeliveryStash;
  models: string[];
  coords: number[][];
}

export interface GeneralType {
  bankLogs: number;
  applications: number;
  bossCanEditItself: boolean;
  maxQuestions: number;
}

export interface ActivitiesType {
  cashierAdds: number;
  markAsDelivered: number;
  buyingSupplies: number;
  orderDelivery: number;
  pawnshopSells: number;
  pawnshopBuying: number;
}

export interface BlipEntry {
  x: number;
  y: number;
  z: number;
  label: string;
  sprite: number;
  color: number;
  online: boolean;
}

export type BlipsType = Record<string, BlipEntry>;

export interface JobAccessType {
  noCustomItems: Record<string, boolean>;
  noSuppliesTab: Record<string, boolean>;
  noDeliveriesTab: Record<string, boolean>;
  posterJobs: Record<string, boolean>;
  blacklistedDiscounts: Record<string, boolean>;
  blacklistedLoyalty: Record<string, boolean>;
  counterAccess: Record<string, boolean>;
  billingBlocked: Record<string, boolean>;
  laundryAccess: Record<string, boolean>;
  directBillJobs: Record<string, boolean>;
  blacklistedPlayers: Record<string, boolean>;
  useBills: Record<string, boolean>;
}
