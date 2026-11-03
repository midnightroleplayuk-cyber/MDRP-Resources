export interface CartType {
  name: string;
  label: string;
  price: number;
  amount: number;
  account: string;
  accountLabel: string;
  category: string;
  identifier: string;
  stock: number;
  image?: string | boolean;
  extension?: string | boolean;
}

export interface ProductType {
  name: string;
  label: string;
  metadata?: Record<string, string | number>;
  stock: number;
  price: number;
  account: string;
  accountLabel: string;
  probability?: number;
  image?: string | boolean;
  extension?: string | boolean;
  identifier: string;
  category: string;
  amount: number;
}

export interface AccountsType {
  value: string;
  label: string;
  amount: number;
}

export interface SelectType {
  value: string;
  label: string;
}

export interface CartAccounts {
  name: string;
  label: string;
  amount: number;
}
