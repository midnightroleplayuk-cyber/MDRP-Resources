import { fetchNui } from "./useNuiEvents";

export const getLang = async () => {
  let lang = "en";

  try {
    const locale = await fetchNui("av_laptop", "getLang");
    if (locale) {
      lang = locale;
    }
    const response = await fetch(`locales/${lang}.json`);
    if (response.ok) {
      return await response.json();
    } else {
      throw new Error(
        `Locale '${lang}' not found in ui/dist/locales folder, using default 'en'`
      );
    }
  } catch (error) {
    console.log("^3[Warning]^7", error);
    try {
      const fallbackResponse = await fetch("locales/en.json");
      if (fallbackResponse.ok) {
        return await fallbackResponse.json();
      } else {
        throw new Error("Default locale file not found.");
      }
    } catch (fallbackError) {
      console.error("Failed to load default locale:", fallbackError);
      return {};
    }
  }
};
