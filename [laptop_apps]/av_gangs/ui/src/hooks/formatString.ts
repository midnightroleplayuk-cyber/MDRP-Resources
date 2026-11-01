export const formatString = (text: string, replacement: string | string[]): string => {
  if (Array.isArray(replacement)) {
    let i = 0;
    return text.replace(/%s/g, () => replacement[i++] || '');
  } else {
    return text.replace(/%s/g, replacement);
  }
};