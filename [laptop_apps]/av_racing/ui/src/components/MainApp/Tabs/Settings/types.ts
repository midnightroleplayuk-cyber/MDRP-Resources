export interface SettingsData {
  name: string;
  nationality: string;
  photo: string;
  smoke: string;
  blip: string;
  animation: string;
  pathColor: string;
  pathEnabled: boolean;
  pathOpacity: number;
  ghostEnabled: boolean;
  ghostTarget: string;
}

export interface ColorOption {
  name: string;
  color: string;
}

export interface ColorsMapProps {
  type: keyof SettingsData;
  colors: ColorOption[];
  selected: string;
  onSelect: (field: keyof SettingsData, value: string) => void;
}
