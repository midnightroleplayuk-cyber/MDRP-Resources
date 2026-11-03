import { GraffitiType } from "../../Admin/Graffitis/types";

export const filterGraffitis = (
  allGraffitis: GraffitiType[],
  saved: string[],
  gangName: string
): GraffitiType[] => {
  const savedSet = new Set(saved);
  return allGraffitis.filter(
    (graffiti) =>
      savedSet.has(graffiti.identifier) || graffiti.gang === gangName
  );
};
