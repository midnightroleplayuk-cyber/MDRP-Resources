export const sortAlphabetically = <T extends { label?: string }>(
  data: T[] | undefined | null,
): T[] => {
  if (!data || !Array.isArray(data)) return [];

  return [...data].sort((a, b) => {
    const labelA = a?.label ?? "";
    const labelB = b?.label ?? "";
    return labelA.localeCompare(labelB, undefined, {
      sensitivity: "base",
      numeric: true,
    });
  });
};
