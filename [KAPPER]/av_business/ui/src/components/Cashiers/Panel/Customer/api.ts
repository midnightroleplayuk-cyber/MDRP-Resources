import { DiscountType } from "../../../Business/Discounts/api";

export interface CartItem {
  name: string;
  amount: number;
  price: number;
  label: string;
  ingredients: string[];
  type: string;
  toUse: string[];
}

export interface ApiCustomerInterface {
  discount?: DiscountType;
  order: number;
  serial: string;
  cart: CartItem[];
  employee: number | string;
  total: number;
  job: string;
}

export const ApiCustomer: ApiCustomerInterface = {
  discount: {
    generated: 1770076311,
    code: "TACOTUESDAY",
    employee: "AV Scripts",
    enabled: true,
    redeemed: 0,
    description: "Enjoy a 20% discount on Taco Tuesday",
    job: "avscripts",
    expires: 1770278400,
    limit: 10,
    type: "percentage",
    discount: 20,
  },
  order: 1,
  serial: "avscripts6663",
  cart: [
    {
      name: "icecream",
      amount: 15,
      price: 15,
      label: "Ice Cream",
      ingredients: [
        "chocolate",
        "milk",
        "ice",
        "item2",
        "item3",
        "item4",
        "item5",
      ],
      type: "drink",
      toUse: ["chocolate", "milk"],
    },
    {
      name: "icecream",
      amount: 1,
      price: 15,
      label: "Ice Cream",
      ingredients: ["chocolate", "milk", "ice"],
      type: "drink",
      toUse: ["chocolate"],
    },
    {
      name: "icecream",
      amount: 33,
      price: 15,
      label: "Ice Cream",
      ingredients: ["chocolate", "milk", "ice"],
      type: "drink",
      toUse: [],
    },
    {
      name: "icecream",
      amount: 15,
      price: 15,
      label: "Ice Cream",
      ingredients: ["chocolate", "milk", "ice"],
      type: "drink",
      toUse: ["chocolate", "milk"],
    },
    {
      name: "icecream",
      amount: 1,
      price: 15,
      label: "Ice Cream",
      ingredients: ["chocolate", "milk", "ice"],
      type: "drink",
      toUse: ["chocolate"],
    },
    {
      name: "icecream",
      amount: 33,
      price: 15,
      label: "Ice Cream",
      ingredients: ["chocolate", "milk", "ice"],
      type: "drink",
      toUse: [],
    },
    {
      name: "icecream",
      amount: 15,
      price: 15,
      label: "Ice Cream",
      ingredients: ["chocolate", "milk", "ice"],
      type: "drink",
      toUse: ["chocolate", "milk"],
    },
    {
      name: "icecream",
      amount: 1,
      price: 15,
      label: "Ice Cream",
      ingredients: ["chocolate", "milk", "ice"],
      type: "drink",
      toUse: ["chocolate"],
    },
    {
      name: "icecream",
      amount: 33,
      price: 15,
      label: "Ice Cream",
      ingredients: ["chocolate", "milk", "ice"],
      type: "drink",
      toUse: [],
    },
    {
      name: "icecream",
      amount: 15,
      price: 15,
      label: "Ice Cream",
      ingredients: ["chocolate", "milk", "ice"],
      type: "drink",
      toUse: ["chocolate", "milk"],
    },
    {
      name: "icecream",
      amount: 1,
      price: 15,
      label: "Ice Cream",
      ingredients: ["chocolate", "milk", "ice"],
      type: "drink",
      toUse: ["chocolate"],
    },
    {
      name: "icecream",
      amount: 33,
      price: 15,
      label: "Ice Cream",
      ingredients: ["chocolate", "milk", "ice"],
      type: "drink",
      toUse: [],
    },
    {
      name: "icecream",
      amount: 15,
      price: 15,
      label: "Ice Cream",
      ingredients: ["chocolate", "milk", "ice"],
      type: "drink",
      toUse: ["chocolate", "milk"],
    },
    {
      name: "icecream",
      amount: 1,
      price: 15,
      label: "Ice Cream",
      ingredients: ["chocolate", "milk", "ice"],
      type: "drink",
      toUse: ["chocolate"],
    },
    {
      name: "icecream",
      amount: 33,
      price: 15,
      label: "Ice Cream",
      ingredients: ["chocolate", "milk", "ice"],
      type: "drink",
      toUse: [],
    },
  ],
  employee: 1,
  total: 735,
  job: "avscripts",
};
