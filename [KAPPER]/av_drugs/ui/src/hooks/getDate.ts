export const getDate = (
  timestamp: number | undefined,
  currentTime: number | undefined
) => {
  if (!timestamp || !currentTime) return "N/A";
  const secondsDifference = currentTime - timestamp;
  const minutes = Math.floor(secondsDifference / 60);
  const hours = Math.floor(minutes / 60);
  const days = Math.floor(hours / 24);

  if (secondsDifference < 60) {
    return `Just now`;
  } else if (minutes < 60) {
    return `${minutes} min${minutes !== 1 ? "s" : ""} ago`;
  } else if (hours < 24) {
    return `${hours} hr${hours !== 1 ? "s" : ""} ago`;
  } else {
    return `${days} Day${days !== 1 ? "s" : ""} ago`;
  }
};
