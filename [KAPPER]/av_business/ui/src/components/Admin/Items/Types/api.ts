export interface TypesInterface {
  value: string;
  label: string;
  jobs: false | string[];
  weight: number;
  event?: string;
  remove?: boolean;
}

export const ApiTypes: TypesInterface[] = [
  {
    jobs: false,
    value: "drink",
    label: "Drink",
    weight: 1000,
    event: "av_business:consumable",
    remove: true,
  },
  {
    jobs: false,
    value: "food",
    label: "Food",
    weight: 1000,
    event: "av_business:consumable",
    remove: true,
  },
  {
    jobs: false,
    value: "joint",
    label: "Joint",
    weight: 1000,
    event: "av_business:consumable",
    remove: true,
  },
  {
    jobs: false,
    value: "others",
    label: "Others",
    weight: 1000,
    event: "av_business:consumable",
    remove: true,
  },
  {
    jobs: false,
    value: "box",
    label: "Boxes",
    weight: 1000,
    event: "av_business:consumable",
    remove: true,
  },
  {
    jobs: false,
    value: "alcohol",
    label: "Alcohol",
    weight: 1000,
    event: "av_business:consumable",
    remove: true,
  },
];
