import { RandomTracksType } from "./types";

export const getUsedTracks = (
  fullList: RandomTracksType[],
  usedIds: string[]
): RandomTracksType[] => {
  return fullList.map((track) => {
    if (usedIds.includes(track.identifier)) {
      return { ...track, used: true };
    }
    return track;
  });
};
