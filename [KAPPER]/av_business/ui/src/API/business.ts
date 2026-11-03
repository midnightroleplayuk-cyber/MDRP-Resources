import { ApiGraph } from "./graph";

export const ApiBusiness = {
  monthlyGenerated: 0,
  stars: 0,
  inventory: "ox_inventory/web/images/",
  jobLabel: "UwU Cafe",
  todayOrders: 0,
  label: "UwU Cafe",
  funds: 0,
  blip: true,
  employees: 1,
  chart: ApiGraph,
  chartElements: [
    {
      name: "sells",
      color: "#4ade80",
      label: "Sells",
    },
    {
      name: "purchases",
      color: "#f87171",
      label: "Purchases",
    },
    {
      name: "supplies",
      color: "#22d3ee",
      label: "Supplies",
    },
    {
      name: "laundry",
      color: "#a855f7",
      label: "Laundry",
    },
  ],
  topEmployee: {
    image: undefined,
    activities: 0,
    name: "N/A",
  },
  todayDish: {
    image: undefined,
    label: "N/A",
    amount: 0,
    name: "N/A",
  },
  todayIncome: 0,
  allPermissions: [
    {
      value: "employees",
      label: "Employees",
    },
    {
      value: "menu",
      label: "Menu",
    },
    {
      value: "bank",
      label: "Bank",
    },
    {
      value: "applications",
      label: "Applications",
    },
    {
      value: "stashes",
      label: "Stashes",
    },
    {
      value: "cameras",
      label: "Cameras",
    },
  ],
  applications: false,
  name: "uwucafe",
  currentMonth: "06",
  webhooks: [],
  permissions: {
    isBoss: true,
    isRestaurant: true,
    useDeliveries: true,
    buySupplies: true,
    useCounter: true,
    useDiscounts: true,
    usePawnshop: true,
    usePoster: true,
    billing: true,
    laundry: true,
  },
};
