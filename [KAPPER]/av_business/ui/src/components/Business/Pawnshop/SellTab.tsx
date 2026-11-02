import { ItemImage } from "../../ItemImage/ItemImage";
import { useEffect, useState } from "react";
import {
  Box,
  Group,
  Text,
  Paper,
  Stack,
  Button,
  NumberInput,
  ScrollArea,
  ThemeIcon,
  Badge,
  ActionIcon,
} from "@mantine/core";
import { IconInbox, IconReceipt2, IconUserFilled } from "@tabler/icons-react";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import classes from "./style.module.css";
import { Loading } from "../../Loading";

interface SellItem {
  name: string;
  label: string;
  image?: string;
  price: number;
  amount: number;
}

interface Properties {
  trayId: string;
  daLang: any;
  lang: any;
}

const ApiSellItems: SellItem[] = [
  { name: "gold_bar", label: "Gold Bar", price: 4500, amount: 3 },
  { name: "diamond", label: "Diamond", price: 12000, amount: 1 },
  { name: "watch_luxury", label: "Luxury Watch", price: 8200, amount: 2 },
];

export const SellTab = ({ trayId, daLang, lang }: Properties) => {
  const [loaded, setLoaded] = useState(false);
  const [sellItems, setSellItems] = useState<SellItem[]>([]);
  const [quantities, setQuantities] = useState<Record<string, number | string>>(
    {},
  );
  const [targetId, setTargetId] = useState<string | number>("");
  const [inventory, setInventory] = useState("");

  const handleClosest = async () => {
    const resp = await fetchNui("av_laptop", "closestPlayer");
    if (resp) {
      setTargetId(resp);
    }
  };
  const fetchSellData = async () => {
    const resp = await fetchNui("av_business", "getPawnshopSellItems");
    if (resp) {
      setSellItems(resp.items);
      setInventory(resp.inventory ?? "");
    } else {
      if (isEnvBrowser()) {
        setSellItems(ApiSellItems);
      }
    }
    setLoaded(true);
  };
  useEffect(() => {
    fetchSellData();
  }, []);

  const handleQtyChange = (name: string, val: number | string) => {
    setQuantities((prev) => ({ ...prev, [name]: val }));
  };

  const cart = sellItems
    .map((item) => {
      const qty = Number(quantities[item.name]) || 0;
      return { ...item, qty, subtotal: qty * item.price };
    })
    .filter((i) => i.qty > 0);

  const totalRevenue = cart.reduce((acc, i) => acc + i.subtotal, 0);
  const isValid = totalRevenue > 0 && targetId !== "";

  const handleSubmitSale = async () => {
    if (!isValid) return;
    if (!loaded) return;
    setLoaded(false);
    const resp = await fetchNui("av_business", "submitPawnSale", {
      items: cart.map((i) => ({ name: i.name, amount: i.qty })),
      targetId,
      trayId,
    });
    setTimeout(() => {
      setLoaded(true);
    }, 250);
    if (!resp) return;
    setQuantities({});
    setTargetId("");
    fetchSellData();
  };

  return (
    <>
      <ScrollArea
        pl="md"
        pr="md"
        mt="md"
        h={400}
        scrollbarSize={6}
        offsetScrollbars
      >
        {!loaded ? (
          <Loading />
        ) : (
          <>
            {sellItems.length === 0 ? (
              <Stack align="center" justify="center" py="xl">
                <Text size="xs" c="var(--text-dim)" fw={500}>
                  {lang.emptyTray ?? "No items available"}
                </Text>
              </Stack>
            ) : (
              <Stack gap="xs">
                {sellItems.map((item) => {
                  const qty = Number(quantities[item.name]) || 0;
                  const subtotal = qty * item.price;

                  return (
                    <Paper key={item.name} className={classes.itemCard}>
                      <Group
                        wrap="nowrap"
                        align="center"
                        justify="space-between"
                      >
                        <Group wrap="nowrap" gap={12} style={{ flex: 1 }}>
                          <Box className={classes.itemImage}>
                            <ItemImage
                              inventory={inventory}
                              name={item.name}
                              image={item.image}
                              w={40}
                              h={40}
                              fit="contain"
                            />
                          </Box>
                          <Box style={{ flex: 1 }}>
                            <Text
                              ff="var(--font-display)"
                              size="md"
                              fw={700}
                              c="var(--text-main)"
                              tt="uppercase"
                            >
                              {item.label}
                            </Text>
                            <Group gap={8} mt={4}>
                              <Badge size="sm" variant="light" color="gray">
                                {lang.qty ?? "Qty"}: {item.amount}
                              </Badge>
                              <Text size="xs" fw={700} c="var(--success)">
                                {daLang.money_symbol}
                                {item.price.toLocaleString("en-US")}{" "}
                                {lang.ea ?? "ea"}
                              </Text>
                            </Group>
                          </Box>
                        </Group>

                        <Group gap={12} align="center" wrap="nowrap">
                          {subtotal > 0 && (
                            <Box style={{ textAlign: "right" }}>
                              <Text
                                size="9px"
                                c="var(--text-dim)"
                                tt="uppercase"
                                fw={700}
                                lh={1}
                              >
                                Subtotal
                              </Text>
                              <Text
                                size="sm"
                                fw={800}
                                c="var(--cyan)"
                                ff="var(--font-display)"
                                lh={1.2}
                              >
                                {daLang.money_symbol}
                                {subtotal.toLocaleString()}
                              </Text>
                            </Box>
                          )}
                          <NumberInput
                            w={110}
                            placeholder="0"
                            min={0}
                            max={item.amount}
                            allowDecimal={false}
                            allowNegative={false}
                            value={quantities[item.name] || ""}
                            onChange={(val) => handleQtyChange(item.name, val)}
                            classNames={{
                              input: classes.inputValid,
                              label: classes.inputLabel,
                            }}
                            label={lang.quantity ?? "Qty"}
                          />
                        </Group>
                      </Group>
                    </Paper>
                  );
                })}
              </Stack>
            )}
          </>
        )}
      </ScrollArea>
      <Group justify="space-between" align="center" className={classes.footer}>
        <Group gap="md">
          <ThemeIcon size="xl" variant="light" color="var(--cyan)">
            <IconReceipt2 size={24} />
          </ThemeIcon>
          <Box>
            <Text size="xs" c="var(--text-dim)" fw={700} tt="uppercase">
              {lang.totalOffer ?? "Total Revenue"}
            </Text>
            <Text
              size="xl"
              fw={800}
              c="var(--cyan)"
              lh={1}
              ff="var(--font-display)"
            >
              {daLang.money_symbol}
              {totalRevenue.toLocaleString()}
            </Text>
            {cart.length > 0 && (
              <Text size="10px" c="var(--text-dim)" mt={2}>
                {cart.length} item{cart.length !== 1 ? "s" : ""}
              </Text>
            )}
          </Box>
        </Group>
        <Group gap="sm" align="flex-end">
          <NumberInput
            placeholder={lang.customerId ?? "Player ID"}
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
            mb={3}
            min={1}
            max={999999}
            allowDecimal={false}
            allowNegative={false}
            value={targetId}
            w={140}
            onChange={setTargetId}
            classNames={{
              input: classes.inputValid,
              label: classes.inputLabel,
            }}
          />
          <Button
            size="md"
            disabled={!isValid}
            onClick={handleSubmitSale}
            className={`${classes.submitBtn} ${isValid ? classes.submitBtnSell : classes.submitBtnInvalid}`}
          >
            {lang.sell ?? "Sell"}
          </Button>
        </Group>
      </Group>
    </>
  );
};
