interface GangPoints {
  label: string;
  name: string;
  points: number;
}

export interface ZoneDataType {
  gangsData: GangPoints[];
  zoneName: string;
  zoneLabel: string;
}
