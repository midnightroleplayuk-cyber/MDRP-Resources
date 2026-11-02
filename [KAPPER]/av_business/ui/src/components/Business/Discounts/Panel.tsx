import { DiscountType } from "./api";
import {
  Modal,
  Stack,
  Group,
  Text,
  ScrollAreaAutosize,
  ActionIcon,
  Divider,
  Button,
} from "@mantine/core";
import { IconCopy } from "@tabler/icons-react";
import { fetchNui } from "../../../hooks/useNuiEvents";
import useFormattedDateTime from "../../../hooks/formatDate";
import global from "../../../global.module.css";

interface Properties {
  coupon: DiscountType;
  handleDelete: (code: string) => void;
  toggleStatus: (code: string) => void;
  handleClose: () => void;
  lang: any;
}

const InfoRow = ({ label, value, color = "gray.5", children }: any) => (
  <Group justify="space-between" wrap="nowrap">
    <Text fz="xs" c="gray.1" fw={500}>
      {label}:
    </Text>
    {children || (
      <Text fz="xs" c={color} ta="right">
        {value}
      </Text>
    )}
  </Group>
);

export const Panel = ({
  coupon,
  handleClose,
  handleDelete,
  toggleStatus,
  lang,
}: Properties) => {
  const formattedDate = useFormattedDateTime(coupon.generated);
  const expiration = coupon.expires
    ? useFormattedDateTime(coupon.expires)
    : "N/A";
  const discountLabel =
    coupon.type === "amount" ? `$${coupon.discount}` : `${coupon.discount}%`;

  return (
    <Modal
      classNames={global}
      opened={true}
      onClose={handleClose}
      title={lang.details_header}
      centered
      size="325px"
      withinPortal
      lockScroll={false}
      trapFocus={false}
      styles={{
        title: { fontSize: "14px", fontWeight: 600 },
        content: { overflow: "hidden" },
      }}
    >
      <ScrollAreaAutosize mah={400} type="hover">
        <Stack gap="sm">
          <InfoRow label={lang.code}>
            <Group gap={4}>
              <Text fz="xs" c="gray.5">
                {coupon.code}
              </Text>
              <ActionIcon
                size="xs"
                variant="subtle"
                onClick={() => fetchNui("av_laptop", "copy", coupon.code)}
              >
                <IconCopy size={13} stroke={1.5} />
              </ActionIcon>
            </Group>
          </InfoRow>
          <Divider variant="dashed" opacity={0.2} />
          <Stack gap={2}>
            <Text fz="xs" c="gray.1" fw={500}>
              {lang.description}:
            </Text>
            <Text
              fz="xs"
              c="gray.5"
              style={{ lineHeight: 1.4, wordBreak: "break-word" }}
            >
              {coupon.description || "N/A"}
            </Text>
          </Stack>
          <Divider variant="dashed" opacity={0.2} />
          <InfoRow label={lang.created_by} value={coupon.employee} />
          <InfoRow label={lang.generated} value={formattedDate} />
          <InfoRow label={lang.expires} value={expiration} />
          <InfoRow label={lang.discount} value={discountLabel} color="blue.4" />
          <InfoRow label={lang.redeemed} value={`${coupon.redeemed}`} />
          <InfoRow label={lang.limit} value={coupon.limit ?? lang.unlimited} />
          <InfoRow
            label={lang.status}
            value={coupon.enabled ? lang.active : lang.inactive}
            color={coupon.enabled ? "teal.4" : "red.4"}
          />
          <Group>
            <Button
              variant="transparent"
              color="red"
              size="xs"
              ml="auto"
              onDoubleClick={() => {
                handleDelete(coupon.code);
              }}
            >
              {lang.delete_button}
            </Button>
            <Button
              size="xs"
              className={global.button}
              variant="filled"
              onClick={() => {
                toggleStatus(coupon.code);
              }}
            >
              {coupon.enabled ? lang.disable_button : lang.enable_button}
            </Button>
          </Group>
        </Stack>
      </ScrollAreaAutosize>
    </Modal>
  );
};
