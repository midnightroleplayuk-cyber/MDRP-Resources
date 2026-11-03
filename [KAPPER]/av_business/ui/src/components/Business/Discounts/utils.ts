import { DiscountType } from "./api";

export function filterData(data: DiscountType[], search: string) {
  const query = search.toLowerCase().trim();

  return data.filter((item) =>
    Object.keys(item).some((key) => {
      const value = item[key as keyof DiscountType];
      return String(value).toLowerCase().includes(query);
    }),
  );
}

export function sortData(
  data: DiscountType[],
  payload: {
    sortBy: keyof DiscountType | null;
    reversed: boolean;
    search: string;
  },
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
    search,
  );
}

export const generateCode = () => {
  const characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  let result = "";
  for (let i = 0; i < 10; i++) {
    result += characters.charAt(Math.floor(Math.random() * characters.length));
  }
  return result;
};

export const useToday = () => {
  const date = new Date();
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  return `${year} ${month} ${day}`;
};

export const toTimestamp = (dateStr: string): number => {
  const date = new Date(`${dateStr}T00:00:00`);
  return Math.floor(date.getTime() / 1000);
};

export const sortAlphabetically = <T extends { code?: string }>(
  data: T[] | undefined | null,
): T[] => {
  if (!data || !Array.isArray(data)) return [];

  return [...data].sort((a, b) => {
    const codeA = a?.code ?? "";
    const codeB = b?.code ?? "";
    return codeA.localeCompare(codeB, undefined, {
      numeric: true,
      sensitivity: "base",
    });
  });
};
