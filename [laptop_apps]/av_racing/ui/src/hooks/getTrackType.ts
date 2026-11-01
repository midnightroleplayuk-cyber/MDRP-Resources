import { EventType, SelectType } from "../types/types";

export const GetTrackType = (type: string, filterCategories: SelectType[]) => {
  return filterCategories.find((x) => x.value === type);
};

export const GetListByCategories = (
  categories: SelectType[],
  resp: EventType[]
) => {
  const validTypes = new Set(categories.map((category) => category.value));
  return resp.filter((race) => validTypes.has(race.type));
};
