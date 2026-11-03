import { Group, Table, Text, UnstyledButton, Center } from "@mantine/core";
import {
  IconChevronUp,
  IconChevronDown,
  IconSelector,
} from "@tabler/icons-react";
import classes from "./style.module.css";

interface ThProps {
  children: React.ReactNode;
  reversed: boolean;
  sorted: boolean;
  width?: number;
  onSort: () => void;
}

export const TableHeader = ({
  children,
  reversed,
  sorted,
  onSort,
  width,
}: ThProps) => {
  const Icon = sorted
    ? reversed
      ? IconChevronUp
      : IconChevronDown
    : IconSelector;

  return (
    <Table.Th className={classes.th} w={width ? width : undefined}>
      <UnstyledButton onClick={onSort} className={classes.control}>
        <Group justify="space-between">
          <Text fw={500} fz="sm" tt="uppercase" c="var(--text-dim)" lts={1}>
            {children}
          </Text>
          <Center className={classes.icon}>
            <Icon size={16} stroke={1.5} />
          </Center>
        </Group>
      </UnstyledButton>
    </Table.Th>
  );
};
