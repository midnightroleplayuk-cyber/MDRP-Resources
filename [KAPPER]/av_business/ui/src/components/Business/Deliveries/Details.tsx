import { Modal, Text, Group, Stack } from "@mantine/core";
import { DeliveryType } from "../../../types/types";
import global from "../../../global.module.css";
import { formatTimestamp } from "../../../hooks/formatTime";

interface Properties {
  daLang: any;
  order: DeliveryType;
  setShow: (state: boolean) => void;
}

export const Details = ({ daLang, order, setShow }: Properties) => {
  const lang = daLang.deliveries;
  return (
    <Modal
      zIndex={99999}
      opened
      onClose={() => {
        setShow(false);
      }}
      centered
      classNames={global}
      title={<Text c="var(--text-main)">{lang.details}</Text>}
      lockScroll={false}
      size={300}
    >
      <Group>
        <Text fz="sm">{lang.order_id}</Text>
        <Text fz="sm" c="var(--text-dim)">
          {order.name}
        </Text>
      </Group>
      <Group>
        <Text fz="sm">{lang.created}</Text>
        <Text fz="sm" c="var(--text-dim)">
          {formatTimestamp(order.generated)}
        </Text>
      </Group>
      <Group>
        <Text fz="sm">{lang.claimed_by}</Text>
        <Text fz="sm" c="var(--text-dim)">
          {order.claimed ? order.claimed : `N/A`}
        </Text>
      </Group>
      <Text fz="sm">{lang.products}</Text>
      <Stack mt="xs" mah={200} style={{ overflow: "auto" }} gap="xs" pr="xs">
        {order.products.map((item, index) => (
          <Group
            key={index}
            style={{
              borderBottom:
                index == order.products.length
                  ? "unset"
                  : "solid 1px rgba(200,200,200,0.055)",
            }}
          >
            <Group>
              <Text fz="sm" c="var(--text-main)">
                {item}
              </Text>
            </Group>
          </Group>
        ))}
      </Stack>
    </Modal>
  );
};
