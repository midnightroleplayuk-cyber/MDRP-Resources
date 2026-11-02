export const UI_COLOR = "rgba(220, 230, 240, 0.88)";
export const UI_DIM_COLOR = "rgba(180, 195, 210, 0.45)";
export const DANGER_COLOR = "#d97a7a";
export const ACCENT_COLOR = "#a8c4d8";

export const pad = (num: number) => String(num).padStart(2, "0");

export const formatTime = (date: Date) =>
  `${pad(date.getHours())}:${pad(date.getMinutes())}:${pad(date.getSeconds())}`;

export const formatDate = (date: Date) => {
  const days = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
  const months = [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AUG",
    "SEP",
    "OCT",
    "NOV",
    "DEC",
  ];
  return `${days[date.getDay()]} ${pad(date.getDate())} ${months[date.getMonth()]} ${date.getFullYear()}`;
};

export const formatRecTime = (totalSeconds: number) => {
  const h = Math.floor(totalSeconds / 3600);
  const m = Math.floor((totalSeconds % 3600) / 60);
  const s = totalSeconds % 60;
  return `REC ${pad(h)}:${pad(m)}:${pad(s)}`;
};
