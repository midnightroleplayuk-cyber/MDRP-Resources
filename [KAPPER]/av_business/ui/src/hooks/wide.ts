import { useMediaQuery } from "@mantine/hooks";

export const isWide = () => {
  return useMediaQuery("(min-width: 1300px)");
};
