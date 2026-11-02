import { PromoType } from "./api";
import {
  Modal,
  Stack,
  Group,
  Text,
  ActionIcon,
  Divider,
  Button,
  Badge,
} from "@mantine/core";
import { IconTrash } from "@tabler/icons-react";
import global from "../../../global.module.css";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";

const fmtDate = (ts?: number | null) => {
  if (!ts) return "—";
  return new Date(ts * 1000).toLocaleString("en-US", {
    day: "2-digit",
    month: "short",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
};

const promoStatus = (promo: PromoType) => {
  const now = Math.floor(Date.now() / 1000);
  if (!promo.enabled) return "disabled";
  if (promo.starts_at > now) return "scheduled";
  if (promo.ends_at && promo.ends_at < now) return "expired";
  return "active";
};

const STATUS_COLOR: Record<string, string> = {
  active: "green",
  scheduled: "cyan",
  expired: "red",
  disabled: "gray",
};

interface Properties {
  promo: PromoType;
  handleDelete: (id: number) => void;
  toggleStatus: (id: number, current: boolean) => void;
  handleClose: () => void;
}

export const PromoPanel = ({
  promo,
  handleDelete,
  toggleStatus,
  handleClose,
}: Properties) => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.discounts;
  const status = promoStatus(promo);

  return (
    <Modal
      classNames={global}
      opened={true}
      onClose={handleClose}
      title={promo.label}
      centered
      withinPortal
      lockScroll={false}
      trapFocus={false}
      styles={{ title: { fontSize: "14px", fontWeight: 600 } }}
    >
      <Stack gap="xs">
        <Group justify="space-between">
          <Text fz="xs" c="var(--text-dim)">
            {lang.type}
          </Text>
          <Text fz="xs" fw={500}>
            {promo.type === "percentage"
              ? `${promo.discount}%`
              : `$${promo.discount}`}
          </Text>
        </Group>
        <Divider opacity={0.1} />
        <Group justify="space-between">
          <Text fz="xs" c="var(--text-dim)">
            {lang.starts_at ?? "Starts at"}
          </Text>
          <Text fz="xs" fw={500}>
            {fmtDate(promo.starts_at)}
          </Text>
        </Group>
        <Group justify="space-between">
          <Text fz="xs" c="var(--text-dim)">
            {lang.ends_at ?? "Ends at"}
          </Text>
          <Text fz="xs" fw={500}>
            {fmtDate(promo.ends_at)}
          </Text>
        </Group>
        <Divider opacity={0.1} />
        <Group justify="space-between">
          <Text fz="xs" c="var(--text-dim)">
            {lang.description}
          </Text>
          <Text fz="xs" fw={500}>
            {promo.description || "—"}
          </Text>
        </Group>
        <Group justify="space-between">
          <Text fz="xs" c="var(--text-dim)">
            Status
          </Text>
          <Badge size="xs" color={STATUS_COLOR[status]} variant="light">
            {status}
          </Badge>
        </Group>
        <Divider opacity={0.1} />
        <Group justify="space-between">
          <ActionIcon
            size="sm"
            variant="subtle"
            color="red"
            onClick={() => promo.id !== undefined && handleDelete(promo.id)}
          >
            <IconTrash style={{ height: 14, width: 14 }} stroke={1.5} />
          </ActionIcon>
          <Button
            size="xs"
            className={global.button}
            onClick={() =>
              promo.id !== undefined &&
              toggleStatus(promo.id, promo.enabled as boolean)
            }
          >
            {promo.enabled ? lang.disable_button : lang.enable_button}
          </Button>
        </Group>
      </Stack>
    </Modal>
  );
};
