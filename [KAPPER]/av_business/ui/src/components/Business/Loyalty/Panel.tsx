import {
  Modal,
  Box,
  Group,
  Text,
  Badge,
  Button,
  Stack,
  Progress,
} from "@mantine/core";
import { IconTrash } from "@tabler/icons-react";
import { LoyaltyPromoType } from "./api";
import { fetchNui } from "../../../hooks/useNuiEvents";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import global from "../../../global.module.css";
import classes from "./style.module.css";

interface Props {
  promo: LoyaltyPromoType | null;
  opened: boolean;
  handleClose: () => void;
  handleDelete: (id: number) => void;
  toggleActive: (id: number, current: boolean) => void;
}

export const LoyaltyPanel = ({
  promo,
  opened,
  handleClose,
  handleDelete,
  toggleActive,
}: Props) => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.loyalty;

  if (!promo) return null;

  const isActive = Boolean(promo.active);
  const printed = promo.total_printed ?? 0;
  const redeemed = promo.total_redeemed ?? 0;
  const inCirculation = printed - redeemed;
  const printCap = promo.max_prints ?? null;
  const cooldownMin = Math.round(promo.visit_cooldown / 60);

  const previewStyle: React.CSSProperties = promo.image
    ? { backgroundImage: `url(${promo.image})` }
    : {};

  const onDelete = async () => {
    const resp = await fetchNui("av_business", "deleteLoyaltyPromo", promo.id);
    if (resp) handleDelete(promo.id);
  };

  const onToggle = () => {
    fetchNui("av_business", "toggleLoyaltyPromo", {
      id: promo.id,
      active: !isActive,
    });
    toggleActive(promo.id, isActive);
  };

  return (
    <Modal
      classNames={global}
      opened={opened}
      onClose={handleClose}
      title={promo.name}
      centered
      withinPortal
      lockScroll={false}
      trapFocus={false}
      styles={{
        title: { fontSize: "14px", fontWeight: 600 },
        content: { overflow: "hidden" },
      }}
    >
      <Stack gap="sm">
        <Box className={classes.cardPreview} style={previewStyle}>
          <Box className={classes.cardOverlay}>
            <Group justify="space-between" align="flex-end">
              <Text fz="sm" fw={700} c="white" lts={0.5}>
                {promo.name}
              </Text>
              <Badge
                color={promo.discount_type === "amount" ? "green" : "cyan"}
                size="sm"
                variant="filled"
              >
                {promo.discount_type === "amount"
                  ? `$${promo.discount} off`
                  : `${promo.discount}% off`}
              </Badge>
            </Group>
            <Text fz="xs" c="rgba(255,255,255,0.55)" mt={2}>
              {promo.required_visits} {lang.visits} required · {cooldownMin} min{" "}
              {lang.cooldown_unit}
            </Text>
          </Box>
        </Box>
        <Box
          bg="var(--bg-card)"
          p="sm"
          style={{ borderRadius: 6, border: "solid 1px var(--border)" }}
        >
          <Text fz="xs" c="var(--text-dim)" mb={6} tt="uppercase" lts={0.5}>
            {lang.card_stats}
          </Text>
          <Stack gap={4}>
            <Group justify="space-between">
              <Text fz="xs" c="var(--text-dim)">
                {lang.total_printed}
              </Text>
              <Text fz="xs" ff="var(--font-display)">
                {printed}
                {printCap ? ` / ${printCap}` : ""}
              </Text>
            </Group>
            {printCap && (
              <Progress
                value={(printed / printCap) * 100}
                size="xs"
                color="cyan"
                mb={2}
              />
            )}
            <Group justify="space-between">
              <Text fz="xs" c="var(--text-dim)">
                {lang.total_redeemed}
              </Text>
              <Text fz="xs" ff="var(--font-display)" c="var(--success)">
                {redeemed}
              </Text>
            </Group>
            <Group justify="space-between">
              <Text fz="xs" c="var(--text-dim)">
                {lang.in_circulation}
              </Text>
              <Text fz="xs" ff="var(--font-display)">
                {inCirculation}
              </Text>
            </Group>
          </Stack>
        </Box>
        <Group
          bg="var(--bg-card)"
          p="sm"
          style={{ borderRadius: 6, border: "solid 1px var(--border)" }}
          justify="space-between"
        >
          <Group gap="xs">
            <Text fz="xs" c="var(--text-dim)">
              {lang.status}
            </Text>
            <Badge
              color={isActive ? "green" : "gray"}
              size="xs"
              variant="light"
            >
              {isActive ? lang.active : lang.inactive}
            </Badge>
          </Group>
          <Button size="xs" className={global.button} onClick={onToggle}>
            {isActive ? lang.disable : lang.enable}
          </Button>
        </Group>
        <Button
          size="xs"
          className={global.redButton}
          fullWidth
          onDoubleClick={onDelete}
          leftSection={<IconTrash size={13} stroke={1.8} />}
        >
          {lang.delete}
        </Button>
      </Stack>
    </Modal>
  );
};
