export const JoinedRace = (racers: any, identifier: string) => {
  if (racers[identifier]) return true;
  return false;
};
