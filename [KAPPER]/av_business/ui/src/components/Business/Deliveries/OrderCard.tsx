import {
  Card,
  Group,
  Tooltip,
  Text,
  ActionIcon,
  Flex,
  Badge,
  Stack,
  Divider,
} from "@mantine/core";
import { DeliveryType } from "../../../types/types";
import {
  IconFileDescription,
  IconMapPinShare,
  IconCheck,
  IconUserExclamation,
  IconTrash,
} from "@tabler/icons-react";
import { fetchNui } from "../../../hooks/useNuiEvents";
import classes from "./style.module.css";

interface Properties {
  data: DeliveryType;
  symbol: string;
  handleDetails: (order: DeliveryType) => void;
  handleOrder: (type: string, order: DeliveryType) => void;
  selected: boolean;
  daLang: any;
}

const iconStyle = { width: 14, height: 14 };

export const OrderCard = ({
  data,
  symbol,
  handleDetails,
  selected,
  handleOrder,
  daLang,
}: Properties) => {
  const lang = daLang.deliveries;
  return (
    <Card
      className={classes.card}
      p="md"
      style={{ border: selected ? "solid 1px var(--accent)" : undefined }}
    >
      <Stack gap="xs">
        <Group>
          <Text
            ff="var(--font-display)"
            c="var(--cyan)"
            fw={700}
            fz="lg"
            lts={1.25}
          >
            #{data.name}
          </Text>
          <Badge
            size="sm"
            ml="auto"
            color={data.claimed ? "var(--yellow)" : "var(--text-dim)"}
            variant="light"
            radius={4}
          >
            {data.claimed ? lang.in_progress : lang.unassigned}
          </Badge>
        </Group>
        <Group justify="space-between" mr="xs">
          <Flex direction="column">
            <Text c="var(--text-dim)" fz="sm">
              {lang.items}
            </Text>
            <Text
              c="var(--text-main)"
              fz="sm"
            >{`${data.allProducts} ${lang.products}`}</Text>
          </Flex>
          <Flex direction="column">
            <Text c="var(--text-dim)" fz="sm">
              {lang.total}
            </Text>
            <Text
              c="var(--text-main)"
              fz="sm"
            >{`${symbol}${data.total.toLocaleString("en-US")}`}</Text>
          </Flex>
        </Group>
        <Flex direction="column">
          <Text c="var(--text-dim)" fz="sm">
            {lang.claimed_by}
          </Text>
          <Text
            ff="var(--font-display)"
            c={data.claimed ? "var(--cyan)" : "var(--text-main)"}
          >{`${data.claimed ? data.claimed : `N/A`}`}</Text>
        </Flex>
        <Divider color="var(--border)" />
        <Group grow>
          <Tooltip label={lang.details} color="var(--tooltip)">
            <ActionIcon
              variant="transparent"
              size="md"
              bg="var(--border)"
              color="violet"
              onClick={() => {
                handleDetails(data);
              }}
            >
              <IconFileDescription style={iconStyle} stroke={1.5} />
            </ActionIcon>
          </Tooltip>
          <Tooltip label={lang.waypoing} color="var(--tooltip)">
            <ActionIcon
              variant="transparent"
              size="md"
              color="cyan"
              bg="var(--border)"
              onClick={() => {
                fetchNui("av_laptop", "setGPS", data.coords);
              }}
            >
              <IconMapPinShare style={iconStyle} stroke={1.5} />
            </ActionIcon>
          </Tooltip>
          <Tooltip label={lang.claim_order} color="var(--tooltip)">
            <ActionIcon
              variant="transparent"
              size="md"
              color="orange"
              bg="var(--border)"
              onClick={() => {
                handleOrder("claimOrder", data);
              }}
            >
              <IconUserExclamation style={iconStyle} stroke={1.5} />
            </ActionIcon>
          </Tooltip>
          <Tooltip label={lang.mark_as} color="var(--tooltip)">
            <ActionIcon
              variant="transparent"
              size="md"
              color="teal"
              bg="var(--border)"
              onClick={() => {
                handleOrder("delivered", data);
              }}
            >
              <IconCheck style={iconStyle} stroke={1.5} />
            </ActionIcon>
          </Tooltip>
          <Tooltip label={lang.decline} color="var(--tooltip)">
            <ActionIcon
              variant="transparent"
              size="md"
              color="red"
              bg="var(--border)"
              onDoubleClick={() => {
                handleOrder("deleteOrder", data);
              }}
            >
              <IconTrash style={iconStyle} stroke={1.5} />
            </ActionIcon>
          </Tooltip>
        </Group>
      </Stack>
    </Card>
  );
};
