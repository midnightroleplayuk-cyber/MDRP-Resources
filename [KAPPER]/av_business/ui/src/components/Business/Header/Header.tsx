import { Text, ActionIcon, Group, Image } from "@mantine/core";
import { useAtomValue, useAtom } from "jotai";
import { BusinessInfo, Lang } from "../../../reducers/atoms";
import { IconPower } from "@tabler/icons-react";
import { fetchNui } from "../../../hooks/useNuiEvents";
import classes from "./style.module.css";

interface Properties {
  isOpen: boolean;
  setIsOpen: (state: boolean) => void;
}

export const Header = ({ isOpen, setIsOpen }: Properties) => {
  const lang: any = useAtomValue(Lang);
  const info = useAtomValue(BusinessInfo);
  const handleToggle = () => {
    setIsOpen(!isOpen);
    fetchNui("av_business", "handleBlip", !isOpen);
  };
  return (
    <Group className={classes.header} p="sm" h={46}>
      <Group gap="xs" align="center" justify="center">
        <Text fz="md" fw={600} c="white" ml={6}>
          {info.label}
        </Text>
        <Text fz="xs" c="var(--text-dim)">
          Business Panel
        </Text>
      </Group>
      {info.hasBlip && (
        <Group ml="auto" gap="xs">
          <Text fz="xs" c="white">
            {isOpen ? lang.open : lang.closed}
          </Text>
          <ActionIcon
            size="sm"
            variant="transparent"
            color={isOpen ? "teal.3" : "red.4"}
            onClick={() => {
              handleToggle();
            }}
          >
            <IconPower />
          </ActionIcon>
        </Group>
      )}
    </Group>
  );
};
