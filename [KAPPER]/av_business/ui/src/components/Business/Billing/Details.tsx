import { Modal, Stack, Text, Group, ActionIcon, Button } from "@mantine/core";
import { BillingType } from "../../../types/types";
import { fetchNui } from "../../../hooks/useNuiEvents";
import { IconCopy } from "@tabler/icons-react";
import global from "../../../global.module.css";

interface Properties {
  data: BillingType;
  close: (data: null) => void;
  daLang: any;
  isLaptop?: boolean;
  isBoss: boolean;
  identifier: string;
  handleDelete: (identifier: string) => void;
}

export const Details = ({
  data,
  close,
  daLang,
  isLaptop,
  isBoss,
  identifier,
  handleDelete,
}: Properties) => {
  const lang = daLang.billing;
  return (
    <Modal
      opened
      onClose={() => {
        close(null);
      }}
      classNames={global}
      lockScroll={false}
      c="white"
      withinPortal={isLaptop ? false : true}
      size="325"
      title={lang.details_header}
      centered
      styles={{
        root: {
          position: "relative",
          right: isLaptop ? "10%" : "unset",
        },
      }}
    >
      <Stack gap={4}>
        <Group gap="xs">
          <Text fz="sm" c="var(--text-dim)">
            {`${lang.invoiceid}:`}
          </Text>
          <Group gap="xs">
            <Text fz="sm" c="var(--text-main)">
              {data.invoiceid}
            </Text>
            <ActionIcon
              size="xs"
              variant="transparent"
              onClick={() => {
                fetchNui("av_laptop", "copy", data.invoiceid);
              }}
            >
              <IconCopy
                color="var(--cyan)"
                style={{ height: "14px", width: "14px" }}
                stroke={1.5}
              />
            </ActionIcon>
          </Group>
        </Group>
        <Group gap="xs">
          <Text fz="sm" c="var(--text-dim)">
            {`${lang.customer}:`}
          </Text>
          <Text fz="sm" c="var(--text-main)">
            {data.customerName}
          </Text>
        </Group>
        <Group gap="xs">
          <Text fz="sm" c="var(--text-dim)">
            {`${lang.phone}:`}
          </Text>
          <Group gap="xs">
            <Text fz="sm" c="var(--text-main)">
              {data.customerPhone}
            </Text>
            <ActionIcon
              size="xs"
              variant="transparent"
              onClick={() => {
                fetchNui("av_laptop", "copy", data.customerPhone);
              }}
            >
              <IconCopy
                color="var(--cyan)"
                style={{ height: "14px", width: "14px" }}
                stroke={1.5}
              />
            </ActionIcon>
          </Group>
        </Group>
        <Group gap="xs">
          <Text fz="sm" c="var(--text-dim)">
            {`${lang.employee}:`}
          </Text>
          <Text fz="sm" c="var(--text-main)">
            {data.senderName}
          </Text>
        </Group>
        <Group gap="xs">
          <Text fz="sm" c="var(--text-dim)">
            {`${lang.issued}:`}
          </Text>
          <Text fz="sm" c="var(--text-main)">
            {data.issued}
          </Text>
        </Group>
        <Group gap="xs">
          <Text fz="sm" c="var(--text-dim)">
            {`${lang.status}:`}
          </Text>
          <Text fz="sm" c={data.paid ? `teal` : `orange`}>
            {`${data.paid ? lang.paid : lang.pending}`}
          </Text>
        </Group>
        <Text fz="sm" c="var(--text-dim)">
          {`${lang.details}:`}
        </Text>
        <Stack mt={4} mah={200} style={{ overflow: "auto" }} gap="xs" pr="xs">
          {data.description.map((item, index) => (
            <Group
              key={index}
              style={{
                borderBottom:
                  index == data.description.length
                    ? "unset"
                    : "solid 1px rgba(200,200,200,0.055)",
              }}
            >
              <Group>
                {item.amount && (
                  <Text fz="sm" c="var(--white-600)">
                    {`${item.amount}x`}
                  </Text>
                )}
                <Text fz="sm" c="white">
                  {item.item}
                </Text>
              </Group>
              <Text fz="sm" c="gray.2" ml="auto">{`${
                daLang.money_symbol
              }${item.price.toLocaleString("en-US")}`}</Text>
            </Group>
          ))}
        </Stack>
        <Group gap="xs" mt="sm" ml="auto">
          <Text fz="sm" c="var(--text-dim)">
            {`${lang.total}:`}
          </Text>
          <Text fz="sm" c="var(--text-main)">
            {`${daLang.money_symbol}${data.amount.toLocaleString("en-US")}`}
          </Text>
        </Group>
        {(isBoss || data.senderIdentifier === identifier) && (
          <Button
            color="red"
            variant="light"
            size="xs"
            fullWidth
            onDoubleClick={() => {
              handleDelete(data.invoiceid);
            }}
          >
            {lang.delete_button}
          </Button>
        )}
      </Stack>
    </Modal>
  );
};
