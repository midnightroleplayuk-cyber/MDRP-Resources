import { DeliveriesType } from "../components/Admin/types";

export const ApiDeliveries: DeliveriesType = {
  enabled: true,
  maxDistance: 2000.0,
  minProducts: 5,
  maxProducts: 10,
  maxOrders: 20,
  maxPrice: 100,
  maxTip: 200,
  overprice: 50,
  toIgnore: ["box", "others"],
  deliveryWait: [1, 3],
  stash: {
    label: "Customer",
    weight: 100000,
    slots: 10,
  },
  models: ["a_f_m_beach_01", "a_m_m_bevhills_01"],
  coords: [
    [-790.32, 307.93, 85.7],
    [-812.2, 421.83, 91.55],
  ],
};

import { ActivitiesType, GeneralType } from "../components/Admin/types";

export const ApiGeneral: GeneralType = {
  bankLogs: 5,
  applications: 5,
  bossCanEditItself: false,
  maxQuestions: 3,
};

export const ApiActivities: ActivitiesType = {
  cashierAdds: 1,
  markAsDelivered: 1,
  buyingSupplies: 1,
  orderDelivery: 1,
  pawnshopSells: 1,
  pawnshopBuying: 1,
};

import { BlipsType } from "../components/Admin/types";

export const ApiBlips: BlipsType = {
  avscripts: {
    x: -1540.94,
    y: -417.42,
    z: 35.639,
    label: "AV Business",
    sprite: 59,
    color: 2,
    online: false,
  },
};

import { JobAccessType } from "../components/Admin/types";

export const ApiJobAccess: JobAccessType = {
  noCustomItems: { police: true, ambulance: true, taxi: true, mechanic: true },
  noSuppliesTab: { police: true, ambulance: true, taxi: true, mechanic: true },
  noDeliveriesTab: {
    police: true,
    ambulance: true,
    taxi: true,
    mechanic: true,
  },
  posterJobs: { uwucafe: true, avscripts: true },
  blacklistedDiscounts: {
    police: true,
    ambulance: true,
    taxi: true,
    mechanic: true,
  },
  blacklistedLoyalty: {
    police: true,
    ambulance: true,
    taxi: true,
    mechanic: true,
  },
  counterAccess: { avscripts: true, burgershot: true },
  billingBlocked: { job1: true, job2: true },
  laundryAccess: { avscripts: true, uwucafe: true },
  useBills: { avscripts: true },
  directBillJobs: { avscripts: true },
  blacklistedPlayers: { "char1:aosdhoashd": true, identifier123: true },
};
