import {
  Group,
  Text,
  Flex,
  Image,
  Progress,
  Button,
  Tooltip,
  Menu,
  ActionIcon,
} from "@mantine/core";
import { useRecoilValue } from "recoil";
import { Gang, Lang, Permissions } from "../../../reducers/atoms";
import { calculateLevel } from "../../../hooks/calculateLevel";
import { IconDotsVertical } from "@tabler/icons-react";
import { useMediaQuery } from "@mantine/hooks";
import classes from "./style.module.css";
import global from "../../../global.module.css";

interface Properties {
  tab: string;
  setTab: (option: string) => void;
}

interface TabTypes {
  value: string;
  label: string;
  permission?: string;
}

export const Header = ({ tab, setTab }: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const permissions = useRecoilValue(Permissions);
  const { label, daily, dailyMax, level, logo, max } = useRecoilValue(Gang);
  const result = calculateLevel(level, max);
  const isWide = useMediaQuery("(min-width: 1400px)");
  const tabs: TabTypes[] = [
    { value: "overview", label: lang.overview_tab },
    { value: "missions", label: lang.missions_tab, permission: "missions" },
    { value: "territories", label: lang.territories_tab },
  ];

  const extraTabs: TabTypes[] = [
    {
      value: "properties",
      label: lang.properties_tab,
      permission: "properties",
    },
    { value: "market", label: lang.market_tab, permission: "market" },
    { value: "settings", label: lang.settings_tab, permission: "isBoss" },
  ];
  const getTabClass = (key: string) =>
    tab === key ? classes.active : classes.disabled;

  return (
    <Group className={classes.header} p="sm">
      <Group gap="xs">
        <Image
          src={logo}
          w={60}
          h={60}
          fit="contain"
          ml="md"
          fallbackSrc="gang_default.png"
        />
        <Flex direction="column" maw={isWide ? 290 : 165}>
          <Text ff="Bebas Neue" fz="1.25rem" lts={2} truncate>
            {label}
          </Text>
          <Flex direction="column" miw={165}>
            <Progress
              value={result.percentage}
              size="xs"
              color="var(--color-main)"
            />
            <Group>
              <Tooltip
                multiline
                label={
                  <Text fz="xs" c="gray.4">
                    {lang.xp_limit}
                  </Text>
                }
                position="bottom-start"
                maw={300}
                color="dark.5"
              >
                <Text fz="10px" c="dimmed">{`${daily.toLocaleString(
                  "en-US",
                )} / ${dailyMax.toLocaleString("en-US")} ${
                  lang.daily_xp
                }`}</Text>
              </Tooltip>
              <Group ml="auto">
                <Text
                  fz="xs"
                  fw={500}
                  c="gray.3"
                >{`${lang.lvl} ${result.level}`}</Text>
              </Group>
            </Group>
          </Flex>
        </Flex>
      </Group>
      <Group ml="auto" mr="sm" gap="xs">
        {tabs
          .filter((option) => {
            if (!option.permission) return true;
            if (permissions.isBoss) return true;
            if (typeof option.permission === "string") {
              return permissions[option.permission] === true;
            }
            return false;
          })
          .map((t) => (
            <Button
              key={t.value}
              className={getTabClass(t.value)}
              onClick={() => setTab(t.value)}
              ff="Bebas Neue"
              fz="lg"
              lts={1.55}
              fw={550}
            >
              {t.label}
            </Button>
          ))}
        {isWide ? (
          extraTabs
            .filter((option) => {
              if (!option.permission) return true;
              if (permissions.isBoss) return true;
              if (typeof option.permission === "string") {
                return permissions[option.permission] === true;
              }
              return false;
            })
            .map((t) => (
              <Button
                key={t.value}
                className={getTabClass(t.value)}
                onClick={() => setTab(t.value)}
                ff="Bebas Neue"
                fz="lg"
                lts={1.55}
                fw={550}
              >
                {t.label}
              </Button>
            ))
        ) : (
          <Menu shadow="md" width={155} classNames={global} zIndex={9999}>
            <Menu.Target>
              <ActionIcon className={classes.disabled}>
                <IconDotsVertical style={{ height: "14px", width: "14px" }} />
              </ActionIcon>
            </Menu.Target>
            <Menu.Dropdown>
              {extraTabs.map((t) => (
                <Menu.Item
                  key={t.value}
                  className={getTabClass(t.value)}
                  onClick={() => setTab(t.value)}
                  ff="Bebas Neue"
                  fz="md"
                  lts={1.55}
                  fw={550}
                >
                  {t.label}
                </Menu.Item>
              ))}
            </Menu.Dropdown>
          </Menu>
        )}
      </Group>
    </Group>
  );
};
