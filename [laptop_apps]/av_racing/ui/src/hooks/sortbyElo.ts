import { RacerLeaderboardType, Member } from "../types/types";

type RankedItem = (RacerLeaderboardType | Member) & { ranking?: number };

export const getRankedLeaderboard = (
  arr: RacerLeaderboardType[] | Member[],
): RankedItem[] => {
  const rankedData: RankedItem[] = arr.map((item) => ({ ...item }));

  rankedData.sort((a, b) => {
    const ea = Number(a.elo);
    const eb = Number(b.elo);
    return (isNaN(eb) ? 0 : eb) - (isNaN(ea) ? 0 : ea);
  });

  for (let i = 0; i < rankedData.length; i++) {
    rankedData[i].ranking = i + 1;
  }

  return rankedData;
};
