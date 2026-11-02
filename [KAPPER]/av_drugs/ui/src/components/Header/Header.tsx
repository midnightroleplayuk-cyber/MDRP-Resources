import { Box, Text, Image, ActionIcon, Group, Flex, Tabs } from "@mantine/core";
import {
  IconFlaskFilled,
  IconBuildingStore,
  IconTrendingUp,
  IconEdit,
} from "@tabler/icons-react";
import { useHover } from "@mantine/hooks";
import { Profile } from "../../types/types";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";
import classes from "./style.module.css";

interface Properties {
  setTab: (option: string) => void;
  tab: string;
  openSettings: (state: boolean) => void;
  profile: Profile;
}

export const Header = ({ tab, setTab, openSettings, profile }: Properties) => {
  const { hovered, ref } = useHover();
  const { app: lang }: any = useRecoilValue(Lang);
  const iconStyle = { width: "14px", height: "14px" };
  return (
    <Box className={classes.container}>
      <Tabs
        classNames={classes}
        value={tab}
        variant="pills"
        color="#40424D"
        onChange={(e) => {
          if (!e || e == "settings") return;
          setTab(e);
        }}
      >
        <Group>
          <Group gap="sm" ref={ref}>
            <Image
              src={profile.photo}
              h={70}
              w={70}
              radius={6}
              fallbackSrc="./avatar_default.png"
            />
            <Flex direction="column" gap={-25}>
              <Text
                className={classes.text}
                fw={500}
                tt="uppercase"
                lts={1.5}
                fz={"2.15rem"}
                c="rgb(237,239,247)"
              >
                {profile.username}
              </Text>
              <Text
                className={classes.text}
                mt={-5}
                tt="uppercase"
                lts={1}
                fz="sm"
                c="dimmed"
              >
                {`${lang.strain}: ${profile.strain}`}
              </Text>
            </Flex>
            <ActionIcon
              size="sm"
              color={hovered ? "cyan" : "dark"}
              variant="transparent"
              onClick={() => {
                openSettings(true);
              }}
            >
              <IconEdit style={{ width: "16px", height: "16px" }} />
            </ActionIcon>
          </Group>
          <Tabs.List ml="auto">
            <Tabs.Tab
              value="home"
              leftSection={<IconFlaskFilled style={iconStyle} />}
              ml="auto"
              lts={0.55}
            >
              {lang.tables_tab}
            </Tabs.Tab>
            <Tabs.Tab
              value="market"
              leftSection={<IconBuildingStore style={iconStyle} />}
              lts={0.55}
            >
              {lang.market_tab}
            </Tabs.Tab>
            <Tabs.Tab
              value="progression"
              leftSection={<IconTrendingUp style={iconStyle} />}
              lts={0.55}
            >
              {lang.progress_tab}
            </Tabs.Tab>
          </Tabs.List>
        </Group>
      </Tabs>
      <Box className={classes.divider} />
    </Box>
  );
};
