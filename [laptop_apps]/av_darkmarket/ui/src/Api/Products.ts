import { ProductType } from "../types/types";

export const ApiProducts: ProductType[] = [
  {
    name: "drug_package",
    label: "Drug Ingredients",
    metadata: { purity: "100%", strain: "AV Scripts" },
    stock: 5,
    price: 1500,
    account: "cosmo",
    accountLabel: "Cosmo",
    probability: 100,
    image: "drug_package.png",
    extension: "png",
    identifier: "abc123",
    category: "test",
    amount: 1,
  },
  {
    name: "hacking_device",
    label: "Cryptographic Decrypter Test Item",
    metadata: { level: "Advanced", OS: "Kali-Linux" },
    stock: 2,
    price: 5000,
    account: "cosmo",
    accountLabel: "Cosmo",
    probability: 40,
    image: "hacking_device.webp",
    extension: "webp",
    identifier: "hacking_device123",
    category: "test",
    amount: 1,
  },
];
