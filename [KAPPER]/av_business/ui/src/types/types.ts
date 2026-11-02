export type Permissions = {
  [key: string]: boolean;
};

export type ChartsType = {
  date: string;
  sells: number;
  rentals: number;
  imports: number;
  buys: number;
};

export type BusinessType = {
  monthlyGenerated: number;
  stars: number;
  inventory: string;
  jobLabel: string;
  todayOrders: number;
  label: string;
  funds: number;
  employees: number;
  blip: boolean;
  chart: any[];
  topEmployee: {
    image: string | undefined;
    activities: number;
    name: string;
  };
  todayDish: {
    image: string | undefined;
    label: string;
    amount: number;
    name: string;
  };
  todayIncome: number;
  allPermissions: {
    value: string;
    label: string;
  }[];
  permissions: { [key: string]: boolean };
  applications: boolean;
  name: string;
  currentMonth: string;
  webhooks: any[];
  poster?: string;
  chartElements: any[];
  hasBlip?: boolean;
};

export type SelectType = {
  value: string;
  label: string;
  type?: string;
};

type ModalOptions = {
  name?: string;
  type: string;
  image?: string;
  height?: number;
  title?: string;
  default?: string | number | boolean | string[];
  icon?: string;
  style?: React.CSSProperties;
  searchable?: boolean;
  description?: string;
  options?: SelectType[];
  size?: string;
  color?: string;
  disabled?: boolean;
  asterisk?: boolean;
  min?: number;
  decimal?: boolean;
  negative?: boolean;
  zero?: boolean;
  isMoney?: boolean;
  max?: number;
};

export type ModalType = {
  state: boolean;
  portal?: boolean;
  info: {
    title?: string;
    options: ModalOptions[];
    button?: string;
    extraData?: any;
  };
};

type GradeType = {
  payment: number;
  name: string;
  isboss: boolean;
  level: number;
};

export type Employee = {
  permissions: string[];
  phone: string;
  hours: number;
  activities: number;
  generated: number;
  grade: GradeType;
  identifier: string;
  lastSeen: string;
  name: string;
  image: string;
};

export type IngredientsType = {
  value: string;
  label: string;
  type: string[];
  jobs: string[];
  price?: number;
  effects?: string[];
};

export type JobItem = {
  ingredients: string[];
  image: string;
  type: string;
  description: string;
  weight: string;
  price: number;
  label: string;
  name: string;
  job: string;
  prop: string;
  toUse?: string[];
  amount?: number;
  cashier?: boolean;
};

export interface ItemProperties {
  name: string;
  description: string;
  image: string;
  type: string | null;
  ingredients: string[];
  price: number;
  isNew: boolean;
  prop: string;
  cashier: boolean;
}

export interface BillingItem {
  item: string;
  price: number;
  amount?: number;
}

export interface BillingType {
  invoiceid: string;
  customerIdentifier: string;
  customerName: string;
  customerPhone?: string;
  senderName: string;
  senderIdentifier: string;
  amount: number;
  title: string;
  description: BillingItem[];
  issued: string;
  paid: boolean;
}

export interface OrderItem {
  price: number;
  label: string;
  type: string;
  ingredients: string[];
  toUse: string[];
  amount: number;
  name: string;
  image?: string;
}

export interface OrderType {
  identifier: string;
  cart: OrderItem[];
  order: number;
  generated: number;
  inProgress?: boolean;
  customerName: string;
  amount?: number;
  image?: string;
}

export type DeliveryCoords = {
  x: number;
  y: number;
  z: number;
};

export type DeliveryType = {
  products: string[];
  model: string;
  generated: number;
  total: number;
  identifier: string;
  name: string;
  coords: DeliveryCoords;
  job: string;
  claimed?: string | false;
  claimedIdentifier?: string;
  allProducts: number;
};

interface Vector3 {
  x: number;
  y: number;
  z: number;
}

interface ZoneData {
  coords: Vector3;
  distance: number;
  heading: number;
  height: number;
  job: string;
  maxZ: number;
  minZ: number;
  name: string;
  type: string;
  width: number;
}

export interface ZoneType {
  data: ZoneData;
  job: string;
  name: string;
  type: string;
}
