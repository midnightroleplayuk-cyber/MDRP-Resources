export interface PermissionsType {
  value: string;
  label: string;
  jobs: false | string[];
  default: boolean;
}

export const ApiPermissions: PermissionsType[] = [
  {
    value: "employees",
    label: "Employees",
    jobs: false,
    default: false,
  },
  {
    value: "products",
    label: "Products",
    jobs: false,
    default: false,
  },
  {
    value: "bank",
    label: "Bank",
    jobs: false,
    default: false,
  },
  {
    value: "applications",
    label: "Applications",
    jobs: false,
    default: false,
  },
  {
    value: "stashes",
    label: "Stashes",
    jobs: false,
    default: true,
  },
  {
    value: "cameras",
    label: "Cameras",
    jobs: false,
    default: false,
  },
  {
    value: "supplies",
    label: "Supplies",
    jobs: false,
    default: false,
  },
  {
    value: "billing",
    label: "Billing",
    jobs: false,
    default: true,
  },
  {
    value: "poster",
    label: "Poster",
    jobs: false,
    default: false,
  },
  {
    value: "deliveries",
    label: "Deliveries",
    jobs: false,
    default: true,
  },
];
