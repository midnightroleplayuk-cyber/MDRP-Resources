import { Box, Stack, Group, ActionIcon, Text, ScrollArea } from "@mantine/core";
import { useAtom, useAtomValue } from "jotai";
import { BusinessInfo, Lang, MyPermissions } from "../../../reducers/atoms";
import {
  IconDeviceDesktopAnalytics,
  IconUsers,
  IconBurger,
  IconClipboardList,
  IconSettings,
  IconBuildingBank,
  IconShoppingBag,
  IconReceipt,
  IconPhoto,
  IconPackageExport,
  IconCashBanknote,
  IconRepeat,
  IconMoneybag,
  IconEPassport,
  IconDropletHalf2Filled,
  IconCreditCard,
} from "@tabler/icons-react";
import classes from "./style.module.css";
import { useNuiEvent } from "../../../hooks/useNuiEvents";

interface Properties {
  setTab: (option: string) => void;
  tab: string;
}

interface TabType {
  icon: any;
  tab: string;
  label: string;
  permission: string | boolean;
  extra?: string;
}

const iconStyle = {
  height: "16px",
  width: "16px",
};

export const Navbar = ({ tab, setTab }: Properties) => {
  const [myPermissions, setPermissions] = useAtom(MyPermissions);
  const { permissions } = useAtomValue(BusinessInfo);
  const lang: any = useAtomValue(Lang);

  useNuiEvent("permissions", (data: any) => {
    setPermissions(data);
    if (!data[tab]) setTab("overview");
  });

  const canViewTab = (option: TabType) => {
    if (option.extra && !permissions?.[option.extra]) return false;
    if (!option.permission) return true;
    if (myPermissions?.isBoss) return true;
    if (typeof option.permission === "string") {
      return myPermissions?.[option.permission] === true;
    }
    return false;
  };

  const tabs: TabType[] = [
    {
      icon: IconDeviceDesktopAnalytics,
      tab: "overview",
      label: lang.navbar.overview,
      permission: false,
    },
    {
      icon: IconUsers,
      tab: "employees",
      label: lang.navbar.employees,
      permission: "employees",
    },
    {
      icon: IconBuildingBank,
      tab: "bank",
      label: lang.navbar.bank,
      permission: "bank",
    },
    {
      icon: IconRepeat,
      tab: "laundry",
      label: lang.navbar.laundry,
      permission: "laundry",
      extra: "laundry",
    },
    {
      icon: IconPackageExport,
      tab: "deliveries",
      label: lang.navbar.deliveries,
      permission: "deliveries",
      extra: "useDeliveries",
    },
    {
      icon: IconReceipt,
      tab: "billing",
      label: lang.navbar.billing,
      permission: "billing",
      extra: "billing",
    },
    {
      icon: IconDropletHalf2Filled,
      tab: "bills",
      label: "Bills",
      permission: "bills",
      extra: "useBills",
    },
    {
      icon: IconBurger,
      tab: "products",
      label: lang.navbar.menu,
      permission: "products",
      extra: "isRestaurant",
    },
    {
      icon: IconShoppingBag,
      tab: "supplies",
      label: lang.navbar.supplies,
      permission: "supplies",
      extra: "buySupplies",
    },
    {
      icon: IconEPassport,
      tab: "counter",
      label: lang.navbar.counter,
      permission: "counter",
      extra: "useCounter",
    },
    {
      icon: IconCashBanknote,
      tab: "discounts",
      label: lang.navbar.discounts,
      permission: "discounts",
      extra: "useDiscounts",
    },
    {
      icon: IconCreditCard,
      tab: "loyalty",
      label: lang.navbar.loyalty,
      permission: "discounts",
      extra: "useDiscounts",
    },
    {
      icon: IconClipboardList,
      tab: "applications",
      label: lang.navbar.applications,
      permission: "applications",
    },
    {
      icon: IconMoneybag,
      tab: "pawnshop",
      label: lang.navbar.pawnshop,
      permission: false,
      extra: "usePawnshop",
    },
    {
      icon: IconPhoto,
      tab: "poster",
      label: lang.navbar.poster,
      permission: "poster",
      extra: "usePoster",
    },
    {
      icon: IconSettings,
      tab: "settings",
      label: lang.navbar.settings,
      permission: "settings",
    },
  ];

  return (
    <Box className={classes.navbar} p="sm" h="100%">
      <ScrollArea
        h="100%"
        style={{ flex: 1 }}
        type="hover"
        scrollbars="y"
        scrollbarSize={5}
      >
        <Stack gap="xs">
          {tabs.filter(canViewTab).map((option, index) => (
            <Group
              className={classes.option}
              gap="xs"
              c={tab === option.tab ? "#EDF5FF" : "#8c8c8c"}
              key={index}
              bg={tab === option.tab ? "var(--accent)" : "transparent"}
              onClick={() => {
                setTab(option.tab);
              }}
            >
              <ActionIcon
                ml="xs"
                size="sm"
                variant="transparent"
                c={tab === option.tab ? "#EDF5FF" : "#8c8c8c"}
              >
                <option.icon style={iconStyle} />
              </ActionIcon>
              <Text fz="sm" lts={0.25}>
                {option.label}
              </Text>
            </Group>
          ))}
        </Stack>
      </ScrollArea>
    </Box>
  );
};
