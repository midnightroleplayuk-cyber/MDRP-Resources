import { CrewProperties } from "../../../../types/types";

export const getItemsPerPage = (height: number) => {
  if (height >= 954) {
    return 12;
  }
  if (height >= 771) {
    return 8;
  }
  return 4;
};

export const paginate = <T>(
  array: T[],
  page: number,
  itemsPerPage: number,
): T[] => {
  const startIndex = (page - 1) * itemsPerPage;
  const endIndex = startIndex + itemsPerPage;
  return array.slice(startIndex, endIndex);
};

export function filterData<T>(data: T[], search: string): T[] {
  const query = search.toLowerCase().trim();
  return data.filter((item) =>
    Object.values(item as any).some(
      (value) =>
        typeof value === "string" && value.toLowerCase().includes(query),
    ),
  );
}

export function sortData<T>(
  data: T[],
  payload: {
    sortBy: keyof T | null;
    reversed: boolean;
    search: string;
  },
): T[] {
  const { sortBy, reversed, search } = payload;
  const filteredData = filterData(data, search);

  if (!sortBy) {
    return filteredData;
  }

  const sortedData = [...filteredData].sort((a, b) => {
    const valA = a[sortBy];
    const valB = b[sortBy];

    const aIsNull = valA === null || valA === undefined;
    const bIsNull = valB === null || valB === undefined;

    if (aIsNull && bIsNull) return 0;
    if (aIsNull) return 1;
    if (bIsNull) return -1;

    if (typeof valA === "string" && typeof valB === "string") {
      return reversed
        ? (valB as string).localeCompare(valA as string)
        : (valA as string).localeCompare(valB as string);
    } else if (typeof valA === "number" && typeof valB === "number") {
      return reversed
        ? (valB as number) - (valA as number)
        : (valA as number) - (valB as number);
    }

    return 0;
  });

  return sortedData;
}

export const getRankedCrews = (crews: CrewProperties[]) => {
  return [...crews]
    .sort((a, b) => b.wins - a.wins)
    .map((crew, index) => ({
      ...crew,
      ranking: crew.wins === 0 ? 0 : index + 1,
    }));
};
