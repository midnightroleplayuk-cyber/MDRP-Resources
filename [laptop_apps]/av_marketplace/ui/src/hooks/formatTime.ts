type TimestampFormat = "date" | "datetime" | "time";

export const useTimestamp = (
  timestamp: number | string,
  format: TimestampFormat = "datetime",
): string => {
  if (!timestamp) return "";

  const ms =
    typeof timestamp === "number" && timestamp < 9_999_999_999
      ? timestamp * 1000
      : Number(timestamp);

  const date = new Date(ms);
  if (isNaN(date.getTime())) return "";

  const MM = String(date.getMonth() + 1).padStart(2, "0");
  const DD = String(date.getDate()).padStart(2, "0");
  const HH = String(date.getHours()).padStart(2, "0");
  const min = String(date.getMinutes()).padStart(2, "0");

  if (format === "date") return `${MM}/${DD}`;
  if (format === "time") return `${HH}:${min}`;
  return `${MM}/${DD} ${HH}:${min}`;
};
