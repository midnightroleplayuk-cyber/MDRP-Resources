import { Menu, Button, Text, Group } from "@mantine/core";
import { AccountsType } from "../../types/types";
import { Wallet, ChevronDown } from "lucide-react";
import { isWide } from "../../hooks/wide";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";
import classes from "./style.module.css";

interface Properties {
  accounts: AccountsType[];
}

export const AccountsMenu = ({ accounts }: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const wide = isWide();
  return (
    <Menu classNames={classes} shadow="md" width={200} withinPortal={false}>
      <Menu.Target>
        <Button className={classes.button} variant="transparent">
          <Wallet size={13} color="var(--primary-200)" />
          {wide && (
            <>
              <Text fz="xs" c="gray.3" ml="xs">
                {`${accounts.length} ${lang.accounts}`}
              </Text>
              <ChevronDown
                size={12}
                style={{ marginLeft: 8 }}
                color="var(--primary-100)"
              />
            </>
          )}
        </Button>
      </Menu.Target>
      <Menu.Dropdown bg="var(--dark-button-bg)" w="fit-content" miw={190}>
        <Menu.Label>{lang.my_accounts}</Menu.Label>
        {accounts.map((account) => (
          <Menu.Item>
            <Group>
              <Text fz="xs" c="gray.3" fw={500}>
                {account.label}
              </Text>
              <Text fz="xs" ml="auto" c="gray.5">
                {account.amount.toLocaleString("en-US")}
              </Text>
            </Group>
          </Menu.Item>
        ))}
      </Menu.Dropdown>
    </Menu>
  );
};
