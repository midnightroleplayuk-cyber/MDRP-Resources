interface LevelInfo {
  level: number;
  percentage: number;
  remaining: number;
}

export const calculateLevel = (exp: number, maxPerLevel: number): LevelInfo => {
  const level = Math.floor(exp / maxPerLevel);
  const remainingExp = exp % maxPerLevel;
  const percentage = (remainingExp / maxPerLevel) * 100;

  return {
    level: level,
    percentage: percentage,
    remaining: remainingExp,
  };
};
