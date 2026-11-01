import { Group, Text } from "@mantine/core";
import classes from "./style.module.css";

export const Header = () => {
  return (
    <Group className={classes.header} p="sm">
      <Group gap="xs">
        <Text fw={500} lts={1.25} c="white">
          AV Marketplace
        </Text>
        <Text fz="xs" c="dimmed">
          Admin Panel
        </Text>
      </Group>
    </Group>
  );
};
