import { CheckpointType } from "../components/MainApp/Details/types";

export const calculateDistance = (
  p1: CheckpointType,
  p2: CheckpointType
): number => {
  const dx = p2.coords.x - p1.coords.x;
  const dy = p2.coords.y - p1.coords.y;
  return Math.sqrt(dx * dx + dy * dy);
};
