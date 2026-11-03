import { useMediaQuery } from "@mantine/hooks";
import { isEnvBrowser } from "./useNuiEvents";

export const isWide = () => {
  return useMediaQuery(`(min-width: ${isEnvBrowser() ? 1750 : 1200}px)`);
};
