export const calculateProgress = (
  started: number | undefined,
  currentTime: number | undefined,
  endsIn: number | undefined
) => {
  if (!started) return 0;
  if (!currentTime) return 0;
  if (!endsIn) return 0;
  const totalTime = endsIn - started;
  const timeElapsed = currentTime - started;
  if (currentTime >= endsIn) {
    return 100;
  }
  if (currentTime <= started) {
    return 0;
  }
  const percentageElapsed = Math.floor((timeElapsed / totalTime) * 100);
  return Math.min(percentageElapsed, 100);
};
