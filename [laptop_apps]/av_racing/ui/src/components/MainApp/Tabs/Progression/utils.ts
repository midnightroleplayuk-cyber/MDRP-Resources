import { useMemo } from "react";

export const useSortedRewards = (items: any[], redeemed: string[]) => {
  return useMemo(() => {
    return items
      .map((item) => ({
        ...item,
        redeemed: redeemed.includes(item.value),
      }))
      .sort((a, b) => a.level - b.level);
  }, [items, redeemed]);
};
