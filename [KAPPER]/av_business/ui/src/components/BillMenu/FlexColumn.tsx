import { Flex, Text } from "@mantine/core";
import React from "react";

interface Properties {
  label: string;
  value: React.ReactNode;
  color?: string;
}

export const FlexColumn = ({
  label,
  value,
  color = "var(--text-main)",
}: Properties) => (
  <Flex direction="column">
    <Text fz="xs" c={color} fw={500}>
      {value}
    </Text>
    <Text fz="xs" c="var(--text-dim)">
      {label}
    </Text>
  </Flex>
);
