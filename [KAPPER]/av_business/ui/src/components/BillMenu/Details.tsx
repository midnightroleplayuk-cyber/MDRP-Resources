import {
  Modal,
  Stack,
  Text,
  Group,
  ActionIcon,
  Select,
  Button,
  ScrollArea,
} from "@mantine/core";
import global from "../../global.module.css";
import { BillingType, SelectType } from "../../types/types";
import { fetchNui } from "../../hooks/useNuiEvents";
import { IconCopy } from "@tabler/icons-react";
import { useState } from "react";

interface Properties {
  payOptions: SelectType[];
  data: BillingType;
  close: (data: null) => void;
  daLang: any;
}

export const Details = ({ payOptions, data, close, daLang }: Properties) => {
  const lang = daLang.billing;
  const [account, setAccount] = useState<string | null>(null);
  const handlePayment = () => {
    fetchNui("av_business", "payBill", {
      account,
      invoiceid: data.invoiceid,
    });
    close(null);
  };
  return (
    <Modal
      opened
      onClose={() => {
        close(null);
      }}
      classNames={global}
      lockScroll={false}
      c="white"
      withinPortal={false}
      size="325"
      title={lang.details_header}
      centered
    >
      <Stack gap={4}>
        <Group gap="xs">
          <Text fz="sm" c="var(--text-dim)">
            {`${lang.invoiceid}:`}
          </Text>
          <Group gap="xs">
            <Text fz="sm" c="gray.3">
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
            {`${lang.sender}:`}
          </Text>
          <Group gap="xs">
            <Text fz="sm" c="gray.3">
              {data.senderName}
            </Text>
            <ActionIcon
              size="xs"
              variant="transparent"
              onClick={() => {
                fetchNui("av_laptop", "copy", data.senderIdentifier);
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
            {`${lang.issued}:`}
          </Text>
          <Text fz="sm" c="gray.3">
            {data.issued}
          </Text>
        </Group>
        <Group gap="xs">
          <Text fz="sm" c="var(--text-dim)">
            {`${lang.status}:`}
          </Text>
          <Text fz="sm" c={data.paid ? `var(--success)` : `var(--yellow)`}>
            {`${data.paid ? lang.paid : lang.pending}`}
          </Text>
        </Group>
        <Text fz="sm" c="var(--text-dim)">
          {`${lang.details}:`}
        </Text>
        <ScrollArea
          h={data.description.length > 3 ? 200 : 100}
          offsetScrollbars
          type="hover"
          scrollbars={"y"}
          scrollbarSize={6}
        >
          <Stack mt={4} style={{ overflow: "auto" }} gap="xs">
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
                <Text fz="sm" c="gray.2" ml="auto">{`${daLang.money_symbol}${
                  item.price ? item.price.toLocaleString("en-US") : 0
                }`}</Text>
              </Group>
            ))}
          </Stack>
        </ScrollArea>
        <Group gap="xs" mt="sm" ml="auto">
          <Text fz="sm" c="var(--text-dim)">
            {`${lang.total}:`}
          </Text>
          <Text fz="sm" c="gray.3">
            {`${daLang.money_symbol}${data.amount.toLocaleString("en-US")}`}
          </Text>
        </Group>
        {!data.paid && (
          <Group mt="sm" grow>
            <Select
              classNames={global}
              data={payOptions}
              placeholder={lang.payment_method}
              onChange={(e) => {
                setAccount(e);
              }}
              size="xs"
            />
            <Button
              className={global.button}
              size="xs"
              onClick={handlePayment}
              disabled={!account}
            >
              {lang.paybutton}
            </Button>
          </Group>
        )}
      </Stack>
    </Modal>
  );
};
