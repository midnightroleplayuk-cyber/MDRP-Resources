import {
  AllTerritoriesType,
  GangData,
  GangStats,
  GangType,
} from "../../../types/types";

export function getGangRankings(
  territories: AllTerritoriesType,
  allGangs: GangType[],
  minPoints: number = 10
): GangStats[] {
  const logoMap = new Map<string, GangType>();
  for (const gang of allGangs) {
    logoMap.set(gang.name, gang);
  }

  const summary: {
    [key: string]: {
      name: string;
      label: string;
      logo: string;
      totalPoints: number;
      controlledZones: number;
    };
  } = {};
  for (const [name, gang] of logoMap.entries()) {
    summary[name] = {
      name: gang.name,
      label: gang.label,
      logo: gang.logo,
      totalPoints: 0,
      controlledZones: 0,
    };
  }

  for (const zoneName in territories) {
    const zoneData = territories[zoneName];
    for (const gangName in zoneData) {
      if (logoMap.has(gangName)) {
        summary[gangName].totalPoints += zoneData[gangName].points;
      }
    }
  }

  for (const zoneName in territories) {
    const zoneData = territories[zoneName];
    const entries = Object.entries(zoneData) as [string, GangData][];

    if (entries.length === 0) {
      continue;
    }

    const trueWinner = entries.reduce((prev, curr) => {
      const prevPoints = prev[1].points;
      const currPoints = curr[1].points;

      if (currPoints > prevPoints) {
        return curr;
      } else if (currPoints === prevPoints) {
        return curr[0].localeCompare(prev[0]) < 0 ? curr : prev;
      } else {
        return prev;
      }
    });

    const [winnerName, winnerData] = trueWinner;
    const isWinnerValid = logoMap.has(winnerName);

    if (winnerData.points >= minPoints && isWinnerValid) {
      if (summary[winnerName]) {
        summary[winnerName].controlledZones++;
      }
    }
  }

  const finalArray = Object.values(summary).map((data) => ({
    gangLabel: data.label,
    logo: data.logo,
    controlledZones: data.controlledZones,
    totalPoints: data.totalPoints,
    name: data.name,
  }));
  finalArray.sort((a, b) => b.totalPoints - a.totalPoints);
  return finalArray as GangStats[];
}
