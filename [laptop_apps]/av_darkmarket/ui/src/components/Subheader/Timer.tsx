import { useEffect } from "react";
import { Group, Box, Tooltip, Text } from "@mantine/core";
import { useRecoilState } from "recoil";
import { RefreshTime } from "../../reducers/atoms";
import classes from "./style.module.css";
import { useNuiEvent } from "../../hooks/useNuiEvents";
import { CircleQuestionMark } from "lucide-react";

export const Timer = () => {
  const [drop, setDrop] = useRecoilState(RefreshTime);

  const formatTime = (sec: number): string => {
    if (sec <= 0) return "00:00:00";
    const hours = Math.floor(sec / 3600);
    const minutes = Math.floor((sec % 3600) / 60);
    const remainingSeconds = sec % 60;

    return [hours, minutes, remainingSeconds]
      .map((v) => v.toString().padStart(2, "0"))
      .join(":");
  };

  useNuiEvent("refresh", (timer: number | undefined) => {
    setDrop(timer);
  });

  useEffect(() => {
    if (drop === undefined || drop <= 0) return;

    const interval = setInterval(() => {
      setDrop((prev) => {
        if (prev === undefined || prev <= 1) {
          clearInterval(interval);
          return 0;
        }
        return prev - 1;
      });
    }, 1000);

    return () => clearInterval(interval);
  }, [drop === undefined || drop === 0]);

  return (
    <Group gap="xs">
      <Text
        display="flex"
        fz="md"
        lts={0.55}
        c="var(--primary-300)"
        tt="uppercase"
        fw={500}
      >
        {/* Cambiamos la lógica: si drop existe y es mayor a 0, muestra el timer */}
        {drop !== undefined && drop > 0 ? (
          <>
            <Text mr={5} fz="md" c="gray" tt="uppercase" fw={450}>
              Restock In
            </Text>
            {formatTime(drop)}
          </>
        ) : (
          /* Si drop es 0, undefined o null, muestra esto */
          <Text c="var(--secondary-200)" fw={700} className={classes.pulse}>
            Updating Stock...
          </Text>
        )}
      </Text>

      <Tooltip
        label="When the timer reaches zero, the Dark Market will refresh with a new selection of items and a full restock."
        fz="xs"
        color="dark.5"
        lts={1}
        multiline
        maw={300}
      >
        <CircleQuestionMark
          size={14}
          strokeWidth={1.55}
          absoluteStrokeWidth
          color="var(--icon-subdued)"
        />
      </Tooltip>
    </Group>
  );
};
