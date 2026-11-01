type UpgradeKeys = "stash" | "production" | "security";

export interface PropertyType {
  identifier: string;
  shell: string;
  type: string;
  upgrades: {
    [key in UpgradeKeys]?: number;
  };
  isOpen: boolean;
  label: string;
  entry: {
    x: number;
    y: number;
    z: number;
    h: number;
  };
  raided: boolean;
  photo?: string;
  working: string;
}

export interface ShellType {
  value: string;
  label: string;
  preview: string;
}
