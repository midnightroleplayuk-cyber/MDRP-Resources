import { fetchNui } from "../../../hooks/useNuiEvents";
import { CameraType } from "../../../types/types";

export const STATUS_CONFIG = {
  live: { color: "green", label: "Live" },
  offline: { color: "var(--danger)", label: "Offline" },
  unassigned: { color: "yellow", label: "Unassigned" },
  "support-needed": { color: "var(--yellow)", label: "Support needed" },
} as const;

export const batteryColor = (b: number) => {
  if (b >= 60) return "var(--success)";
  if (b >= 25) return "var(--yellow)";
  return "var(--danger)";
};

export interface Properties {
  onView: (cam: CameraType) => void;
  onDelete: (cam: CameraType) => void;
}

export const handleView = (cam: CameraType) => {
  fetchNui("av_cameras", "connectCamera", cam);
};

export const DUMMY_CAMERA: CameraType = {
  identifier: "",
  owner: "",
  label: "",
  location: "",
  type: "server",
  thumbnail: "",
  battery: 100,
  coords: {
    coords: { x: 0, y: 0, z: 0 },
    rotation: { x: 0, y: 0, z: 0 },
  },
  settings: {
    rotationAngle: 90,
    allowHacking: true,
    allowZoom: true,
    isBreakable: true,
    model: "prop_cctv_cam_01a",
    damageChance: 5,
    replay: false,
    thermalVision: false,
    nightVision: false,
    motionDetection: false,
    recording: false,
    plugged: false,
  },
  status: "live",
};
