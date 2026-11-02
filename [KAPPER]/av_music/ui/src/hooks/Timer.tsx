import { useState, useEffect } from "react";
import { Text } from "@mantine/core";
import { Lang } from "../reducers/atoms";
import { useAtomValue } from "jotai";

interface TimerProps {
  deadline: number;
  hide?: boolean;
  text?: boolean;
}

const secondsToHMS = (sec: number): string => {
  if (sec <= 0) return "00:00:00";
  const hours = Math.floor(sec / 3600);
  const minutes = Math.floor((sec % 3600) / 60);
  const remainingSeconds = sec % 60;

  const formattedHours = hours < 10 ? `0${hours}` : `${hours}`;
  const formattedMinutes = minutes < 10 ? `0${minutes}` : `${minutes}`;
  const formattedSeconds =
    remainingSeconds < 10 ? `0${remainingSeconds}` : `${remainingSeconds}`;

  return `${formattedHours}:${formattedMinutes}:${formattedSeconds}`;
};

const getTimerColor = (sec: number) => {
  if (sec <= 180) return "red";
  if (sec <= 300) return "yellow";
  return "var(--accent)";
};

export const Timer = ({ deadline, hide, text = true }: TimerProps) => {
  const lang: any = useAtomValue(Lang);

  const [currentDeadline, setCurrentDeadline] = useState(Math.max(0, deadline));

  useEffect(() => {
    setCurrentDeadline(Math.max(0, deadline));
  }, [deadline]);

  useEffect(() => {
    if (currentDeadline <= 0) return;

    const interval = setInterval(() => {
      setCurrentDeadline((prev) => {
        if (prev <= 1) {
          clearInterval(interval);
          return 0;
        }
        return prev - 1;
      });
    }, 1000);

    return () => clearInterval(interval);
  }, []);

  if (hide && currentDeadline <= 0) return null;

  return (
    <Text
      display="flex"
      fz="sm"
      fw={600}
      lts={0.55}
      c={getTimerColor(currentDeadline)}
      tt="uppercase"
      ml="auto"
    >
      {currentDeadline > 0 ? secondsToHMS(currentDeadline) : lang.expired}
    </Text>
  );
};
