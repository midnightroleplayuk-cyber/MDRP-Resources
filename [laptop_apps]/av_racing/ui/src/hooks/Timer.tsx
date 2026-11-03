import { useState, useEffect } from "react";
import { useRecoilValue } from "recoil";
import { Lang } from "../reducers/atoms";

interface TimerProps {
  deadline: number;
  hide?: boolean;
}

export const Timer = ({ deadline, hide }: TimerProps) => {
  const lang: any = useRecoilValue(Lang);
  const [timeLeft, setTimeLeft] = useState(deadline);

  useEffect(() => {
    setTimeLeft(deadline);
  }, [deadline]);

  useEffect(() => {
    if (timeLeft <= 0) return;

    const interval = setInterval(() => {
      setTimeLeft((prev) => (prev > 0 ? prev - 1 : 0));
    }, 1000);

    return () => clearInterval(interval);
  }, [timeLeft]);

  const secondsToHMS = (sec: number): string => {
    const hours = Math.floor(sec / 3600);
    const minutes = Math.floor((sec % 3600) / 60);
    const remainingSeconds = sec % 60;

    const formattedHours = hours < 10 ? `0${hours}` : `${hours}`;
    const formattedMinutes = minutes < 10 ? `0${minutes}` : `${minutes}`;
    const formattedSeconds =
      remainingSeconds < 10 ? `0${remainingSeconds}` : `${remainingSeconds}`;

    if (hours > 0) {
      return `${formattedHours}:${formattedMinutes}:${formattedSeconds}`;
    }
    return `${formattedMinutes}:${formattedSeconds}`;
  };

  const getTimeColor = () => {
    if (timeLeft <= 180) return "var(--danger)";
    if (timeLeft <= 300) return "var(--warning)";
    return "var(--success)";
  };

  if (timeLeft <= 0) {
    return (
      <span style={{ color: "var(--danger)" }}>
        {lang?.waiting ?? "WAITING"}
      </span>
    );
  }

  return (
    <span style={{ color: getTimeColor(), transition: "color 0.3s ease" }}>
      {!hide && lang?.startsin && (
        <span style={{ marginRight: "6px", color: "var(--text-dim)" }}>
          {lang.startsin}
        </span>
      )}
      {secondsToHMS(timeLeft)}
    </span>
  );
};
