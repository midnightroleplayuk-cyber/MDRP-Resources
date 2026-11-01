interface Coords3D {
  x: number;
  y: number;
  z: number;
}

export const getDistance = (coord1: Coords3D, coord2: Coords3D): number => {
  if (!coord1 || !coord2) {
    return 0;
  }
  const dx = coord1.x - coord2.x;
  const dy = coord1.y - coord2.y;
  const dz = coord1.z - coord2.z;
  const calculatedDistance = Math.sqrt(dx * dx + dy * dy + dz * dz);
  return Math.round(calculatedDistance);
};
