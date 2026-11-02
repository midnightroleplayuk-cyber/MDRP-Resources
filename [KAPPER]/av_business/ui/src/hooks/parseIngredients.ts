export const parseIngredients = (
  ingredients: string[],
  replacements: { value: string; label: string }[]
): string => {
  try {
    if (Array.isArray(ingredients) && ingredients.length > 0) {
      const replaced = ingredients.map((ingredient) => {
        const replacement = replacements.find((r) => r.value === ingredient);
        return replacement ? replacement.label : ingredient;
      });
      return replaced.join(", ");
    } else {
      return "N/A";
    }
  } catch (error) {
    console.error(`Failed to parse ingredients: ${ingredients}`, error);
    return "N/A";
  }
};
