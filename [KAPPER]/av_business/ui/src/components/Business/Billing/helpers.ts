import { BillingType } from "../../../types/types";

export function filterData(data: BillingType[], search: string) {
  const query = search.toLowerCase().trim();

  return data.filter((item) =>
    Object.keys(item).some((key) => {
      const value = item[key as keyof BillingType];
      return String(value).toLowerCase().includes(query);
    })
  );
}

export function sortData(
  data: BillingType[],
  payload: {
    sortBy: keyof BillingType | null;
    reversed: boolean;
    search: string;
  }
) {
  const { sortBy, reversed, search } = payload;

  if (!sortBy) return filterData(data, search);

  return filterData(
    [...data].sort((a, b) => {
      const aValue = a[sortBy];
      const bValue = b[sortBy];

      if (typeof aValue === "number" && typeof bValue === "number") {
        return reversed ? bValue - aValue : aValue - bValue;
      }

      return reversed
        ? String(bValue).localeCompare(String(aValue))
        : String(aValue).localeCompare(String(bValue));
    }),
    search
  );
}
