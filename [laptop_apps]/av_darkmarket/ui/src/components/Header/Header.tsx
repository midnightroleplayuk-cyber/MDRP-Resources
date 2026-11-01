import { Group, Text, Box, ActionIcon, Menu } from "@mantine/core";
import { AccountsType, SelectType } from "../../types/types";
import { ChevronDown, Skull } from "lucide-react";
import { AccountsMenu } from "./AccountsMenu";
import { CartButton } from "./CartButton";
import { isWide } from "../../hooks/wide";
import classes from "./style.module.css";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";

interface Properties {
  categories: SelectType[];
  tab: string;
  setTab: (option: string) => void;
  accounts: AccountsType[];
  showCart: () => void;
}

export const Header = ({
  categories,
  tab,
  setTab,
  accounts,
  showCart,
}: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const wide = isWide();
  const limit = wide ? 5 : 3;

  return (
    <Group className={classes.header} p="sm">
      <Group gap="xs">
        <Skull size={22} color="var(--primary-200)" />
        <Text fw="bold" fz="1.33rem" c="var(--primary-100)" tt="uppercase">
          {lang.header}
        </Text>
      </Group>
      <Group gap="xs" ml="auto" mr="auto">
        {categories.slice(0, limit).map((category) => (
          <Box
            key={category.value}
            p="xs"
            className={
              tab == category.value ? classes.selected : classes.category
            }
            onClick={() => setTab(category.value)}
          >
            <Text
              fz="xs"
              fw={600}
              lts={0.55}
              tt="uppercase"
              c={tab == category.value ? "white" : "gray.4"}
            >
              {category.label}
            </Text>
          </Box>
        ))}
        {categories.length > limit && (
          <Menu classNames={classes} shadow="md" width={200}>
            <Menu.Target>
              <ActionIcon
                variant="transparent"
                color="var(--primary-200)"
                style={{ cursor: "pointer" }}
              >
                <ChevronDown size={14} />
              </ActionIcon>
            </Menu.Target>
            <Menu.Dropdown
              bg="var(--dark-button-bg)"
              w={"fit-content"}
              style={{ maxHeight: 300, overflow: "auto" }}
              miw={180}
            >
              <Menu.Label>{lang.more}</Menu.Label>
              {categories.slice(limit).map((category) => (
                <Menu.Item
                  key={category.value}
                  onClick={() => setTab(category.value)}
                  closeMenuOnClick={true}
                  style={{ cursor: "pointer" }}
                >
                  <Text
                    fz="xs"
                    fw={500}
                    tt="uppercase"
                    c={tab == category.value ? "var(--primary-200)" : "gray.4"}
                  >
                    {category.label}
                  </Text>
                </Menu.Item>
              ))}
            </Menu.Dropdown>
          </Menu>
        )}
      </Group>
      <Group mr="xs" gap={wide ? 3 : 5}>
        <CartButton showCart={showCart} />
        <AccountsMenu accounts={accounts} />
      </Group>
    </Group>
  );
};
