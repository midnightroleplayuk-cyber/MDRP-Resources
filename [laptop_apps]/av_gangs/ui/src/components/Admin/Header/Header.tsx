import { Group, Text, Button } from "@mantine/core";
import classes from "../style.module.css";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";

interface Properties {
  tab: string;
  setTab: (option: string) => void;
}

export const Header = ({ tab, setTab }: Properties) => {
  const daLang: any = useRecoilValue(Lang);
  const lang = daLang.admin;
  const tabs = [
    { value: "gangs", label: lang.gangs_tab },
    { value: "graffitis", label: lang.graffitis_tab },
    { value: "doors", label: lang.doors_tab },
    { value: "market", label: lang.market_tab },
    { value: "shells", label: lang.shells_tab },
    { value: "territories", label: lang.territories_tab },
    { value: "logs", label: lang.logs_tab || "Logs" },
  ];
  return (
    <Group className={classes.header} p="sm">
      <Group gap="xs">
        <Text fw={500} lts={1.25} c="white">
          AV Gangs
        </Text>
        <Text fz="xs" c="dimmed">
          Admin Panel
        </Text>
      </Group>
      <Group ml="auto" gap="xs">
        {tabs.map((option) => (
          <Button
            className={option.value == tab ? classes.active : classes.disabled}
            key={option.value}
            size="xs"
            onClick={() => {
              setTab(option.value);
            }}
          >
            {option.label}
          </Button>
        ))}
      </Group>
    </Group>
  );
};
