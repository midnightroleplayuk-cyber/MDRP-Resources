import { memo, useEffect, useMemo, useState } from "react";
import {
  Group,
  Flex,
  Image,
  Text,
  Tooltip,
  MantineColor,
  Menu,
  ActionIcon,
  ScrollAreaAutosize,
  Stack,
  Box,
} from "@mantine/core";
import { useDisclosure } from "@mantine/hooks";
import {
  Star,
  Car,
  Trophy,
  MoreVertical,
  Bell,
  BellOff,
  Mail,
} from "lucide-react";
import { useRecoilState, useRecoilValue } from "recoil";
import { Lang, Profile } from "../../../reducers/atoms";
import { fetchNui } from "../../../hooks/useNuiEvents";
import { isWide } from "../../../hooks/isWide";
import classes from "./style.module.css";
import global from "../../../global.module.css";
import { FormatDate } from "../../../hooks/formatString";

interface HeaderProps {
  tab: string;
  setTab: (option: string) => void;
}

interface TabTypes {
  value: string;
  label: string;
  permission?: string;
}

interface ProfileStatProps {
  label: string;
  value?: string | number;
  icon: React.ElementType;
  color: MantineColor;
  onClick?: () => void;
}

const ProfileStat = memo(
  ({ label, value, icon: Icon, color, onClick }: ProfileStatProps) => {
    const iconStyle = { width: "14px", height: "14px" };
    if (value === null || value === undefined) return null;
    return (
      <Tooltip
        label={label}
        color="var(--tooltip)"
        fz="xs"
        position="top-start"
        offset={5}
      >
        <Group
          gap={4}
          c={color}
          onClick={onClick}
          style={{ cursor: onClick ? "pointer" : undefined }}
        >
          <Icon style={iconStyle} />
          <Text
            fz="11px"
            fw={600}
            c="var(--text-dim)"
            mt={1}
            ff="var(--font-main)"
          >
            {value}
          </Text>
        </Group>
      </Tooltip>
    );
  },
);

export const Header = ({ tab, setTab }: HeaderProps) => {
  const lang: any = useRecoilValue(Lang);
  const [vehClass, setVehClass] = useState<string | null>(null);
  const [mmEnabled, setMmEnabled] = useState(false);
  const [profile, setProfile] = useRecoilState(Profile);
  const { photo, name, crew, wins, alerts, isCop, elo, notifications } =
    profile;
  const [opened, handlers] = useDisclosure(false);

  const handleAlerts = () => {
    fetchNui("av_racing", "notifications", !alerts);
    setProfile({ ...profile, alerts: !alerts });
  };

  const stats = useMemo(() => {
    const baseStats: ProfileStatProps[] = [
      {
        label: lang.season_elo,
        value: elo,
        icon: Star,
        color: "var(--text-dim)",
      },
      {
        label: lang.season_victories,
        value: wins,
        icon: Trophy,
        color: "var(--text-dim)",
      },
      {
        label: lang.my_class,
        value: vehClass ?? undefined,
        icon: Car,
        color: "var(--accent)",
      },
      {
        label: lang.alerts,
        value: alerts ? lang.on : lang.off,
        icon: alerts ? Bell : BellOff,
        color: alerts ? "var(--success)" : "var(--danger)",
        onClick: handleAlerts,
      },
    ];
    return baseStats;
  }, [alerts, vehClass]);

  const tabs: TabTypes[] = [
    { value: "home", label: lang.home_tab },
    { value: "tracks", label: lang.tracks_tab },
  ];

  const extraTabs: TabTypes[] = [];
  if (!isCop) {
    extraTabs.push({
      value: "leaderboard",
      label: lang.leaderboard_tab,
    });
    extraTabs.push({
      value: "progression",
      label: lang.progression_tab,
    });
    if (mmEnabled) {
      extraTabs.push({
        value: "matchmaking",
        label: lang.matchmaking_tab ?? "MATCHMAKING",
      });
    }
  }
  if (crew) {
    extraTabs.push({
      value: "crew",
      label: lang.crew_tab,
    });
  }
  extraTabs.push({ value: "settings", label: lang.settings_tab });

  const getTabClass = (key: string) =>
    tab === key ? classes.active : classes.disabled;

  useEffect(() => {
    fetchNui<{ enabled: boolean }>("av_racing", "mmEnabled").then((r) =>
      setMmEnabled(r?.enabled === true),
    );
  }, []);

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getClass");
      setVehClass(resp || null);
    };
    fetchData();
  }, []);

  return (
    <Box className={classes.wrapper}>
      <Group className={classes.header}>
        <Group gap="md">
          <Box className={classes.avatar}>
            <Image
              src={photo}
              w="100%"
              h="100%"
              fit="cover"
              fallbackSrc="avatar_default.png"
            />
          </Box>
          <Flex direction="column" justify="center">
            <Text className={classes.userName}>{name}</Text>
            {!isCop && (
              <Group gap="sm" className={classes.statsGroup}>
                {stats.map((stat) => (
                  <ProfileStat key={stat.label} {...stat} />
                ))}
                <Menu
                  opened={opened}
                  onClose={() => {
                    handlers.close();
                  }}
                  shadow="md"
                  width={145}
                  classNames={global}
                  zIndex={9999}
                  withArrow
                >
                  <Menu.Target>
                    <Tooltip
                      label={lang.messages}
                      color="var(--tooltip)"
                      fz="xs"
                      position="top-start"
                      offset={5}
                    >
                      <ActionIcon
                        c={"var(--text-dim)"}
                        size="xs"
                        variant="transparent"
                        onClick={() => {
                          handlers.toggle();
                        }}
                        style={{ cursor: "pointer" }}
                      >
                        <Mail style={{ width: 14, height: 14 }} />
                      </ActionIcon>
                    </Tooltip>
                  </Menu.Target>
                  <Menu.Dropdown
                    w="auto"
                    maw={300}
                    p="xs"
                    className={classes.dropdown}
                  >
                    {notifications.length > 0 ? (
                      <ScrollAreaAutosize
                        mah={300}
                        type="hover"
                        scrollbars="y"
                        scrollbarSize={6}
                      >
                        <Stack gap="xs">
                          {notifications.map((notification, index) => (
                            <Menu.Item
                              key={notification.identifier}
                              style={{
                                backgroundColor: "var(--bg-main)",
                                color: "var(--text-main)",
                              }}
                            >
                              <Flex direction="column">
                                <Text fz="xs" c="var(--text-dim)">
                                  {FormatDate(notification.time)}
                                </Text>
                                <Text fz="xs">{notification.message}</Text>
                              </Flex>
                            </Menu.Item>
                          ))}
                        </Stack>
                      </ScrollAreaAutosize>
                    ) : (
                      <Text fz="xs" c="var(--text-dim)">
                        {lang.no_messages}
                      </Text>
                    )}
                  </Menu.Dropdown>
                </Menu>
              </Group>
            )}
          </Flex>
        </Group>

        <Group className={classes.tabGroup}>
          {tabs
            .filter((option) => {
              if (!option.permission) return true;
              return false;
            })
            .map((t) => (
              <button
                key={t.value}
                className={getTabClass(t.value)}
                onClick={() => setTab(t.value)}
              >
                {t.label}
              </button>
            ))}
          {isWide() ? (
            extraTabs
              .filter((option) => {
                if (!option.permission) return true;
                return false;
              })
              .map((t) => (
                <button
                  key={t.value}
                  className={getTabClass(t.value)}
                  onClick={() => setTab(t.value)}
                >
                  {t.label}
                </button>
              ))
          ) : (
            <Menu
              shadow="md"
              width={145}
              classNames={global}
              zIndex={9999}
              withinPortal={false}
            >
              <Menu.Target>
                <ActionIcon variant="transparent" c="var(--text-dim)" size="sm">
                  <MoreVertical size={16} />
                </ActionIcon>
              </Menu.Target>
              <Menu.Dropdown className={classes.dropdown}>
                {extraTabs.map((t) => (
                  <Menu.Item
                    ta="center"
                    key={t.value}
                    className={classes.disabled}
                    onClick={() => setTab(t.value)}
                    style={{
                      color: "var(--text-main)",
                      height: "auto",
                      padding: "10px",
                    }}
                  >
                    {t.label}
                  </Menu.Item>
                ))}
              </Menu.Dropdown>
            </Menu>
          )}
        </Group>
      </Group>
    </Box>
  );
};
