import React from "react";
import { Table, UnstyledButton, Group, Text, Center, rem } from "@mantine/core";
import {
  ChevronsUpDown as IconSelector,
  ChevronDown as IconChevronDown,
  ChevronUp as IconChevronUp,
} from "lucide-react";
import global from "../global.module.css";

interface ThProps {
  children: React.ReactNode;
  reversed: boolean;
  sorted: boolean;
  onSort(): void;
}

const Th: React.FC<ThProps> = ({ children, reversed, sorted, onSort }) => {
  const Icon = sorted
    ? reversed
      ? IconChevronUp
      : IconChevronDown
    : IconSelector;
  return (
    <Table.Th className={global.th}>
      <UnstyledButton onClick={onSort} className={global.control}>
        <Group justify="space-between">
          <Text fw={600} fz="sm">
            {children}
          </Text>
          <Center className={global.icon}>
            <Icon style={{ width: rem(16), height: rem(16) }} />
          </Center>
        </Group>
      </UnstyledButton>
    </Table.Th>
  );
};

export default Th;
