export const formatString = (
  text: string,
  replacement: string | string[],
): string => {
  if (Array.isArray(replacement)) {
    let i = 0;
    return text.replace(/%s/g, () => replacement[i++] || "");
  } else {
    return text.replace(/%s/g, replacement);
  }
};

export const FormatDate = (timestamp: number) => {
  const date = new Date(timestamp * 1000);
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  const year = date.getFullYear();

  return `${month}-${day}-${year}`;
};
