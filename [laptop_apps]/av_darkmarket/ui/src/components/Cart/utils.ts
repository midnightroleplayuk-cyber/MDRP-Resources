import { CartAccounts, CartType } from "../../types/types";

export const getCartAccountTotals = (cart: CartType[]): CartAccounts[] => {
  const totals = cart.reduce(
    (acc, item) => {
      const { account, accountLabel, price, amount } = item;
      const totalCost = price * amount;

      if (!acc[account]) {
        acc[account] = {
          name: account,
          label: accountLabel,
          amount: 0,
        };
      }

      acc[account].amount += totalCost;
      return acc;
    },
    {} as Record<string, CartAccounts>,
  );

  return Object.values(totals);
};
