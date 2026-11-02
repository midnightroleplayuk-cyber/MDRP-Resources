interface itemPawnType {
  name: string;
  label: string;
  min: number;
  max: number;
}

export interface PawnshopConfig {
  name: string;
  label: string;
  job: string;
  items: itemPawnType[];
  taxes: number;
  daily: number;
}
