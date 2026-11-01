import { atom, selector } from "recoil";
import { getLang } from "../hooks/getLang";
import { CartType, AccountsType } from "../types/types";
import { ApiAccounts } from "../Api/Accounts";
import { isEnvBrowser } from "../hooks/useNuiEvents";
import { ApiCart } from "../Api/Cart";

const langSelector = selector({
  key: "langSelector",
  get: async () => {
    const response = await getLang();
    return response;
  },
});

export const Lang = atom<Object>({
  key: "lang",
  default: langSelector,
});

export const CartItems = atom<CartType[]>({
  key: "cart",
  default: isEnvBrowser() ? ApiCart : [],
});

export const MoneyAccounts = atom<AccountsType[]>({
  key: "accounts",
  default: ApiAccounts,
});

export const Inventory = atom<string>({
  key: "inventory",
  default: "",
});

export const RefreshTime = atom<number | undefined>({
  key: "refresh",
  default: 30,
});

export const SubheaderAtom = atom<{ search: string; account: null | string }>({
  key: "subheader",
  default: {
    search: "",
    account: null,
  },
});
