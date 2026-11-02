export const formatTimestamp = (timestamp: number, format?: string): string => {
  const date = new Date(timestamp * 1000);

  const month = ("0" + (date.getMonth() + 1)).slice(-2);
  const day = ("0" + date.getDate()).slice(-2);
  const year = date.getFullYear();
  const hours = ("0" + date.getHours()).slice(-2);
  const minutes = ("0" + date.getMinutes()).slice(-2);

  const defaultFormat = `${month}/${day} ${hours}:${minutes}`;

  if (!format) return defaultFormat;

  return format
    .replace(/MM/g, month)
    .replace(/DD/g, day)
    .replace(/YYYY/g, year.toString())
    .replace(/HH/g, hours)
    .replace(/mm/g, minutes);
};
