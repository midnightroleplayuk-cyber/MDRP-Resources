import {
  Modal,
  Box,
  Image,
  Group,
  Badge,
  Text,
  ScrollArea,
} from "@mantine/core";
import { Calendar } from "lucide-react";
import { MarketItem } from "../../../../../types/types";
import { useTimestamp } from "../../../../../hooks/formatTime";
import { useAtomValue } from "jotai";
import { Lang } from "../../../../../reducers/atoms";
import classes from "./style.module.css";

interface Properties {
  item: MarketItem;
  close: () => void;
}

export const Details = ({ item, close }: Properties) => {
  const lang: any = useAtomValue(Lang);

  return (
    <>
      <Modal
        opened
        onClose={close}
        title={item.title}
        centered
        radius="lg"
        size={500}
      >
        <Box
          mt="md"
          mb="md"
          style={{ borderRadius: "8px", overflow: "hidden", height: "240px" }}
        >
          <Image
            src={item.image}
            alt={item.title}
            style={{ width: "100%", height: "100%" }}
            fit="contain"
            fallbackSrc="/noimage.png"
          />
        </Box>
        <Group justify="space-between" align="center" mb="xs">
          <Badge
            variant="unstyled"
            radius="sm"
            className={classes.tagBadge}
            style={{
              color: `var(--green-light)`,
              border: `1px solid var(--border-light)`,
            }}
          >
            {item.category}
          </Badge>
          <Text
            fw={700}
            size="xl"
            style={{
              color: "var(--green)",
              fontFamily: "var(--font-display)",
              fontSize: "24px",
              textShadow: "0 0 12px rgba(66, 168, 70, 0.25)",
            }}
          >
            {`$${item.price.toLocaleString("en-US")}`}
          </Text>
        </Group>
        <Text size="sm" fw={500} style={{ color: "var(--text-hint)" }} mb={4}>
          {lang.detailsDescription}
        </Text>
        <ScrollArea.Autosize mah={180} mx="auto" mb="xl">
          <Text
            size="sm"
            style={{
              color: "var(--text-muted)",
              lineHeight: 1.6,
              whiteSpace: "pre-line",
            }}
          >
            {item.description}
          </Text>
        </ScrollArea.Autosize>

        <Group
          justify="space-between"
          pt="md"
          style={{ borderTop: "1px solid var(--border-light)" }}
        >
          <Group gap={4}>
            <Text size="xs" style={{ color: "var(--text-hint)" }}>
              {lang.detailsSeller}
            </Text>
            <Text size="xs" fw={600} style={{ color: "var(--text-main)" }}>
              {item.seller}
            </Text>
          </Group>
          <Group gap={4} align="center">
            <Calendar size={13} color="var(--text-hint)" />
            <Text size="xs" className={classes.ratingNumber}>
              {useTimestamp(item.created_at, "date")}
            </Text>
          </Group>
        </Group>
      </Modal>
    </>
  );
};
