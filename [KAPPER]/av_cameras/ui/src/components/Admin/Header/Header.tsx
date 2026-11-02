import { Button, Group, Text } from "@mantine/core";
import classes from "../style.module.css";

interface Properties {
  tab: string;
  setTab: (tab: string) => void;
}

export const Header = ({ tab, setTab }: Properties) => {
  const tabs = [
    { label: "Players Cameras", value: "players" },
    { label: "Server Cameras", value: "server" },
  ];
  return (
    <>
      <Group className={classes.header} p="sm">
        <Group gap="xs">
          <Text fw={500} lts={1.25} c="white">
            AV Cameras
          </Text>
          <Text fz="xs" c="dimmed">
            Admin Panel
          </Text>
        </Group>
        <Group ml="auto">
          {tabs.map((option) => (
            <Button
              className={
                option.value == tab ? classes.active : classes.disabled
              }
              fz="md"
              fw={400}
              ff="var(--font-display)"
              lts={1}
              key={option.value}
              variant="transparent"
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
    </>
  );
};
