import { Group, Text, Button, Menu, ActionIcon } from "@mantine/core";
import { IconDotsVertical } from "@tabler/icons-react";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import classes from "../style.module.css";
import global from "../../../global.module.css";

interface Properties {
  tab: string;
  setTab: (option: string) => void;
}

export const Header = ({ tab, setTab }: Properties) => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.admin;
  const tabs = [
    { value: "home", label: lang.tab_home },
    { value: "access", label: lang.tab_access },
    { value: "animations", label: lang.tab_animations },
    { value: "adminbills", label: lang.tab_bills },
    { value: "blips", label: lang.tab_blips },
    { value: "crafting", label: lang.tab_crafting },
    { value: "deliveries", label: lang.tab_deliveries },
    { value: "ingredients", label: lang.tab_ingredients },
    { value: "items", label: lang.tab_items },
    { value: "logs", label: lang.tab_logs },
    { value: "misc", label: lang.tab_misc },
    { value: "pawnshops", label: lang.tab_pawnshops },
    { value: "permissions", label: lang.tab_permissions },
  ];
  return (
    <Group className={classes.header} p="sm">
      <Group gap="xs">
        <Text fw={500} lts={1.25} c="var(--text-main)">
          AV Business
        </Text>
        <Text fz="xs" c="var(--text-dim)">
          Admin Panel
        </Text>
      </Group>
      <Group ml="auto" gap={1}>
        {tabs.slice(0, 4).map((option) => (
          <Button
            className={option.value == tab ? classes.active : classes.disabled}
            fz="md"
            fw={400}
            ff="var(--font-display)"
            lts={1}
            key={option.value}
            variant="subtle"
            size="xs"
            onClick={() => {
              setTab(option.value);
            }}
          >
            {option.label}
          </Button>
        ))}
        <Menu
          shadow="md"
          width={145}
          classNames={global}
          zIndex={9999}
          withinPortal={false}
        >
          <Menu.Target>
            <ActionIcon className={classes.disabled}>
              <IconDotsVertical style={{ height: "14px", width: "14px" }} />
            </ActionIcon>
          </Menu.Target>
          <Menu.Dropdown>
            {tabs.slice(4).map((t) => (
              <Menu.Item
                ta="center"
                key={t.value}
                className={t.value == tab ? classes.active : classes.disabled}
                onClick={() => setTab(t.value)}
                fz="sm"
                fw={400}
              >
                {t.label}
              </Menu.Item>
            ))}
          </Menu.Dropdown>
        </Menu>
      </Group>
    </Group>
  );
};
