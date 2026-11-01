import { Box, Group, Text, Stack, ScrollArea, NavLink } from "@mantine/core";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";
import { getTabs } from "./tabs";
import classes from "../style.module.css";

interface Properties {
  tab: string;
  setTab: (option: string) => void;
}

export const Sidebar = ({ tab, setTab }: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const tabs = getTabs(lang);

  return (
    <Box className={classes.sidebar}>
      <Group className={classes.brand} gap={12} wrap="nowrap">
        <Box className={classes.logo}>AV</Box>
        <Stack gap={2}>
          <Text className={classes.brandName}>AV Racing</Text>
          <Text className={classes.brandSub}>Admin Panel</Text>
        </Stack>
      </Group>

      <ScrollArea className={classes.navScroll} type="scroll" scrollbarSize={5}>
        <Text className={classes.navLabel}>{lang.nav_sections ?? "Sections"}</Text>
        <Stack gap={2} px={10} pb={12}>
          {tabs.map((option) => (
            <NavLink
              key={option.value}
              className={classes.navItem}
              active={tab === option.value}
              label={option.label}
              leftSection={option.icon}
              onClick={() => setTab(option.value)}
            />
          ))}
        </Stack>
      </ScrollArea>
    </Box>
  );
};
