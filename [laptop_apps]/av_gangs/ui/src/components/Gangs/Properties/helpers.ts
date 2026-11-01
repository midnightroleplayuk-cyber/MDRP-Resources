import { SelectType } from "../../../types/types";
import { PropertyType } from "./types";

export const getImages = (
  properties: PropertyType[],
  shells: (SelectType & { preview: string })[]
) => {
  const shellsMap = new Map(
    shells.map((shell) => [shell.value, shell.preview])
  );

  const updatedProperties = properties.map((property) => {
    const photo = shellsMap.get(property.shell);
    return {
      ...property,
      photo,
    };
  });

  return updatedProperties;
};
