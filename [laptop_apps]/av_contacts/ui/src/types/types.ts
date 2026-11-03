export type ContactsType = {
  identifier: string;
  name: string;
  xp: number;
  description: string;
  coords?: { x: number; y: number; z: number };
  avatar?: string;
  max?: number;
};
