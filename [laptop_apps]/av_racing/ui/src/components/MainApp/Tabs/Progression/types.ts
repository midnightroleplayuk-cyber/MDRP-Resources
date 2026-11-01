export interface LevelsType {
  description?: string;
  label?: string;
  value: string;
  level: number;
  image?: string;
  redeemed?: boolean;
}

export interface ProgressionType {
  levels: LevelsType[];
  xp: number;
  redeemed: string[];
}
