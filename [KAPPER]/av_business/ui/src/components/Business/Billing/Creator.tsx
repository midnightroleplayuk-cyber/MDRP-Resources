import { useEffect, useState } from "react";
import {
  Modal,
  NumberInput,
  Stack,
  Button,
  Grid,
  Text,
  Group,
  Divider,
  ActionIcon,
  TextInput,
} from "@mantine/core";
import { BillingItem, SelectType } from "../../../types/types";
import { ComboInput } from "./Combobox";
import { IconTrash, IconUserFilled } from "@tabler/icons-react";
import { fetchNui } from "../../../hooks/useNuiEvents";
import global from "../../../global.module.css";

interface Properties {
  show: (state: boolean) => void;
  items: BillingItem[];
  daLang: any;
  isLaptop?: boolean;
}

interface CustomerType {
  name: string;
  phone: string;
  title: string;
}

const transformToSelectOptions = (items: BillingItem[]): SelectType[] => {
  return items.map((i) => ({
    value: i.item,
    label: i.item,
  }));
};

export const Creator = ({ show, items, daLang, isLaptop }: Properties) => {
  const lang = daLang.billing;
  const options = transformToSelectOptions(items);
  const [playerId, setPlayerId] = useState(0);
  const [bill, setBill] = useState<BillingItem[]>([]);
  const [customer, setCustomer] = useState<CustomerType>({
    name: "",
    phone: "",
    title: "",
  });
  const [total, setTotal] = useState(0);
  const [clearInput, setClearInput] = useState(0);
  const [product, setProduct] = useState({
    item: "",
    price: 0,
    amount: 0,
  });
  const handleCustomer = (field: string, value: any) => {
    setCustomer({ ...customer, [field]: value });
  };
  const handleItem = (type: string, value: string | number) => {
    switch (type) {
      case "name":
        const item = items.find((i) => i.item === value);
        if (item) {
          setProduct({
            item: item.item,
            price: item.price,
            amount: 1,
          });
        } else {
          setProduct({ ...product, item: String(value) });
        }
        break;
      default:
        setProduct({ ...product, [type]: value });
        break;
    }
  };
  const handleAdd = () => {
    if (!product.item || product.amount <= 0) return;
    setBill((prev) => [...prev, product]);
    setProduct({
      item: "",
      price: 0,
      amount: 0,
    });
    setClearInput((prev) => prev + 1);
  };
  const handleDelete = (product: BillingItem) => {
    setBill((prev) =>
      prev.filter(
        (i) => !(i.item === product.item && i.amount === product.amount),
      ),
    );
  };
  const handleClosest = async () => {
    const resp = await fetchNui("av_laptop", "closestPlayer");
    if (resp) {
      setPlayerId(resp);
    }
  };
  const handleSend = () => {
    fetchNui("av_business", "sendBill", {
      playerId,
      bill,
      customer,
    });
    show(false);
  };
  useEffect(() => {
    const sum = bill.reduce((acc, item) => {
      const amount = item.amount ?? 0;
      return acc + amount * item.price;
    }, 0);
    setTotal(sum);
  }, [bill]);

  return (
    <Modal
      opened
      onClose={() => {
        show(false);
      }}
      classNames={global}
      title={lang.creator_heading}
      lockScroll={false}
      c="var(--text-main)"
      withinPortal={isLaptop ? false : true}
      size="calc(45vw)"
      centered
      styles={{
        root: {
          position: "relative",
          right: isLaptop ? "10%" : "unset",
        },
        content: {
          maxWidth: "750px",
          maxHeight: "700px",
        },
      }}
    >
      <Group grow>
        <TextInput
          classNames={global}
          label={lang.customer_name}
          placeholder="John Smith"
          size="xs"
          min={1}
          maxLength={100}
          value={customer.name}
          onChange={(e) => {
            handleCustomer("name", e.currentTarget.value);
          }}
        />
        <TextInput
          classNames={global}
          label={lang.customer_phone}
          placeholder="619-577-2209"
          size="xs"
          min={1}
          maxLength={20}
          value={customer.phone}
          onChange={(e) => {
            handleCustomer("phone", e.currentTarget.value);
          }}
        />
        <TextInput
          classNames={global}
          label={lang.title}
          placeholder={lang.title_placeholder}
          size="xs"
          min={1}
          maxLength={50}
          value={customer.title}
          onChange={(e) => {
            handleCustomer("title", e.currentTarget.value);
          }}
        />
      </Group>
      <Divider mt="sm" size="xs" color="rgba(255,255,255,0.095)" />
      <Grid mt="sm">
        <Grid.Col span={5}>
          <Group>
            <Stack gap="sm" w="92%">
              <ComboInput
                items={options}
                handleItem={handleItem}
                daLang={daLang}
                clear={clearInput}
              />
              <NumberInput
                classNames={global}
                label="Amount"
                size="xs"
                min={1}
                max={100}
                allowDecimal={false}
                allowLeadingZeros={false}
                allowNegative={false}
                value={product.amount}
                onChange={(e) => {
                  handleItem("amount", e);
                }}
              />
              <NumberInput
                classNames={global}
                label={lang.unit_price}
                size="xs"
                value={product.price}
                allowDecimal={false}
                allowLeadingZeros={false}
                allowNegative={false}
                min={1}
                max={1000000}
                prefix={daLang.money_symbol}
                thousandSeparator
                onChange={(e) => {
                  handleItem("price", e);
                }}
              />
              <Button
                size="xs"
                onClick={handleAdd}
                className={global.button}
                variant="filled"
                disabled={!product.item || product.amount <= 0}
              >
                {lang.add_item}
              </Button>
            </Stack>
            <Divider
              size="xs"
              orientation="vertical"
              ml="auto"
              color="rgba(255,255,255,0.095)"
            />
          </Group>
        </Grid.Col>
        <Grid.Col span={7}>
          <Stack ml="xs">
            <Stack mt={4} h={200} style={{ overflow: "auto" }} gap="xs" pr="xs">
              {bill.length > 0 ? (
                <>
                  {bill.map((item, index) => (
                    <Group
                      key={index}
                      style={{
                        borderBottom:
                          index == bill.length
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
                      <Group ml="auto">
                        <Text
                          fz="md"
                          c="var(--cyan)"
                          ff="var(--font-display)"
                        >{`${
                          daLang.money_symbol
                        }${item.price.toLocaleString("en-US")}`}</Text>
                        <ActionIcon
                          size="xs"
                          variant="transparent"
                          color="red"
                          onClick={() => {
                            handleDelete(item);
                          }}
                        >
                          <IconTrash
                            style={{ height: 13, width: 13 }}
                            stroke={1.5}
                          />
                        </ActionIcon>
                      </Group>
                    </Group>
                  ))}
                </>
              ) : (
                <Text
                  fz="xs"
                  c="var(--text-dim)"
                  ta="center"
                  mt="20%"
                  opacity="0.9"
                >
                  {lang.no_items}
                </Text>
              )}
            </Stack>
            <Group gap="xs" mt="sm" ml="auto">
              <Text fz="xs" c="var(--text-dim)">
                {`${daLang.total}:`}
              </Text>
              <Text fz="lg" c="var(--success)" ff="var(--font-display)" lh={0}>
                {`${daLang.money_symbol}${total.toLocaleString("en-US")}`}
              </Text>
            </Group>
            <Group justify="space-between" grow>
              <NumberInput
                classNames={global}
                placeholder={lang.player_id}
                value={playerId}
                size="xs"
                allowDecimal={false}
                allowLeadingZeros={false}
                allowNegative={false}
                min={1}
                max={10000}
                leftSection={
                  <ActionIcon
                    size="xs"
                    variant="transparent"
                    color="var(--text-dim)"
                    opacity={0.9}
                    onClick={handleClosest}
                  >
                    <IconUserFilled
                      style={{ height: "14px", width: "14px" }}
                      stroke={1.5}
                    />
                  </ActionIcon>
                }
                onChange={(e) => {
                  if (!e) return;
                  setPlayerId(Number(e));
                }}
              />
              <Button
                className={global.button}
                disabled={bill.length === 0 || playerId == 0}
                size="xs"
                onClick={handleSend}
              >
                {daLang.billing.send}
              </Button>
            </Group>
          </Stack>
        </Grid.Col>
      </Grid>
    </Modal>
  );
};
