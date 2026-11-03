export const cleanString = (input: string): string => {
  let cleaned = input.toLowerCase();
  cleaned = cleaned.replace(/[^a-z0-9\s]/g, "");
  cleaned = cleaned.replace(/\s/g, "");
  return cleaned;
};
