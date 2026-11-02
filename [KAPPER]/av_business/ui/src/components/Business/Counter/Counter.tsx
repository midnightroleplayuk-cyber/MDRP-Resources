import { useEffect, useState } from "react";
import {
  Grid,
  Card,
  Text,
  Group,
  NumberInput,
  Button,
  Stack,
  Box,
  Flex,
  TextInput,
  Select,
  ScrollArea,
  Tooltip,
  ActionIcon,
  Modal,
} from "@mantine/core";
import { ItemImage } from "../../ItemImage/ItemImage";
import {
  IconBox,
  IconPackage,
  IconSearch,
  IconInfoCircle,
  IconToggleLeft,
  IconToggleRight,
  IconEdit,
} from "@tabler/icons-react";
import { Loading } from "../../Loading";
import {
  fetchNui,
  isEnvBrowser,
  useNuiEvent,
} from "../../../hooks/useNuiEvents";
import { CounterItems } from "./api";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import { SelectType } from "../../../types/types";
import { ApiTypes } from "../../../API/products";
import global from "../../../global.module.css";
import classes from "./style.module.css";

interface ShopItem {
  name: string;
  label: string;
  stock: number;
  price: number;
  type: string;
}

interface UpdatedData {
  item: string;
  stock: number;
  job: string;
}

interface ItemUpdated {
  item: string;
  stock: number;
}

const Counter = () => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.counter_app;
  const [job, setJob] = useState("");
  const [loaded, setLoaded] = useState(false);
  const [items, setItems] = useState<ShopItem[]>([]);
  const [currentItems, setCurrentItems] = useState<ShopItem[]>([]);
  const [quantities, setQuantities] = useState<Record<string, number>>({});
  const [inventory, setInventory] = useState("");
  const [search, setSearch] = useState("");
  const [itemTypes, setItemTypes] = useState<SelectType[]>([]);
  const [counterActive, setCounterActive] = useState(false);

  const [priceModalOpened, setPriceModalOpened] = useState(false);
  const [selectedItem, setSelectedItem] = useState<ShopItem | null>(null);
  const [newPrice, setNewPrice] = useState<number | string>(0);

  useNuiEvent(
    "refreshCounter",
    (data: { job: string; items: ItemUpdated[] }) => {
      if (data.job !== job) return;
      const updateFn = (prev: ShopItem[]) =>
        prev.map((item) => {
          const updated = data.items.find((i) => i.item === item.name);
          return updated ? { ...item, stock: updated.stock } : item;
        });
      setItems(updateFn);
      setCurrentItems(updateFn);
    },
  );

  useNuiEvent("updateStock", (data: UpdatedData) => {
    if (data.job !== job) return;
    setItems((prev) =>
      prev.map((item) =>
        item.name === data.item ? { ...item, stock: data.stock } : item,
      ),
    );
    setCurrentItems((prev) =>
      prev.map((item) =>
        item.name === data.item ? { ...item, stock: data.stock } : item,
      ),
    );
  });

  const handleSearchChange = (input: string) => {
    setSearch(input);
    const search = input.toLowerCase();
    const filtered = items.filter((item) =>
      item.label.toLowerCase().includes(search),
    );
    setCurrentItems(filtered);
  };

  const handleFilter = (type: string | null) => {
    if (!type) {
      setCurrentItems(items);
    } else {
      const res = items.filter((item) =>
        item.type ? item.type.toLowerCase().includes(type) : false,
      );
      setCurrentItems(res);
    }
  };

  const handleQuantityChange = (item: string, value: number | string) => {
    const numValue =
      typeof value === "number" ? value : parseInt(value, 10) || 1;
    setQuantities((prev) => ({ ...prev, [item]: numValue }));
  };

  const processStash = () => {
    fetchNui("av_business", "processCounterStash");
  };

  const onWithdraw = (item: string, amount: number) => {
    fetchNui("av_business", "withdrawCounterItem", { item, amount });
  };

  const getQuantity = (item: string) => quantities[item] || 1;

  const handleAction = (item: string, type: "deposit" | "withdraw") => {
    const amount = getQuantity(item);
    if (amount <= 0) return;
    if (type === "deposit") processStash();
    else onWithdraw(item, amount);
    setQuantities((prev) => ({ ...prev, [item]: 1 }));
  };

  const handleToggleCounter = () => {
    const next = !counterActive;
    setCounterActive(next);
    fetchNui("av_business", "toggleCounter", next);
  };

  const handleOpenPriceModal = (item: ShopItem) => {
    setSelectedItem(item);
    setNewPrice(item.price);
    setPriceModalOpened(true);
  };

  const handleUpdatePrice = () => {
    if (!selectedItem) return;
    const finalPrice =
      typeof newPrice === "number" ? newPrice : parseInt(newPrice, 10) || 0;
    fetchNui("av_business", "updateItemPrice", {
      item: selectedItem.name,
      price: finalPrice,
    });
    setItems((prev) =>
      prev.map((i) =>
        i.name === selectedItem.name ? { ...i, price: finalPrice } : i,
      ),
    );
    setCurrentItems((prev) =>
      prev.map((i) =>
        i.name === selectedItem.name ? { ...i, price: finalPrice } : i,
      ),
    );
    setPriceModalOpened(false);
    setSelectedItem(null);
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getCounterItems");
      if (resp) {
        setItems(resp.items);
        setCurrentItems(resp.items);
        setInventory(resp.inventory);
        setItemTypes(resp.types);
        setCounterActive(resp.counterActive ?? false);
        setJob(resp.job ?? "");
      } else {
        if (isEnvBrowser()) {
          setItems(CounterItems);
          setCurrentItems(CounterItems);
          setItemTypes(ApiTypes);
        }
      }
      setLoaded(true);
    };
    fetchData();
  }, []);

  if (!loaded) return <Loading />;

  return (
    <>
      <Group
        bg="var(--bg-card)"
        p="sm"
        style={{ borderRadius: "6px", border: "solid 1px var(--border)" }}
      >
        <Flex gap="xs" direction="column">
          <Text ff="var(--font-display)" tt="uppercase" fz="xl" fw={700}>
            {lang.header}
          </Text>
          <Text mt={-15} fz="xs" c="var(--text-dim)">
            {`${currentItems.length} ${lang.products}`}
          </Text>
        </Flex>
        <Group ml="auto" gap={6}>
          <Tooltip
            label={
              <Flex direction="column" gap={4}>
                <Text c="var(--text-main)" fz="sm" fw={500}>
                  {lang.info_header}
                </Text>
                <Text c="var(--text-dim)" fz="xs">
                  {lang.info_description}
                </Text>
              </Flex>
            }
            color="var(--tooltip)"
            fz="xs"
            withArrow
            multiline
            w={280}
            position="bottom-end"
          >
            <ActionIcon
              variant="transparent"
              c="cyan"
              size="sm"
              style={{ color: "var(--text-dim)" }}
            >
              <IconInfoCircle size={16} />
            </ActionIcon>
          </Tooltip>
          <Tooltip
            label={
              <Flex direction="column" gap={4}>
                <Text c="var(--text-main)" fz="sm" fw={500}>
                  {lang.stash_header}
                </Text>
                <Text c="var(--text-dim)" fz="xs">
                  {lang.stash_description}
                </Text>
              </Flex>
            }
            color="var(--tooltip)"
            fz="xs"
            withArrow
            multiline
            w={280}
            position="bottom-end"
          >
            <ActionIcon
              variant="transparent"
              c="var(--accent)"
              size="sm"
              style={{ color: "var(--text-dim)" }}
              onClick={processStash}
            >
              <IconPackage size={16} />
            </ActionIcon>
          </Tooltip>
          <Tooltip
            label={counterActive ? "Counter: Active" : "Counter: Inactive"}
            color="var(--tooltip)"
            fz="xs"
            withArrow
            position="bottom"
          >
            <ActionIcon
              size="md"
              variant="subtle"
              onClick={handleToggleCounter}
              style={{
                color: counterActive ? "var(--success)" : "var(--text-dim)",
                background: counterActive
                  ? "rgba(74,222,128,0.1)"
                  : "transparent",
                border: `1px solid ${counterActive ? "rgba(74,222,128,0.25)" : "var(--border)"}`,
                transition: "all 0.2s",
              }}
            >
              {counterActive ? (
                <IconToggleRight size={18} />
              ) : (
                <IconToggleLeft size={18} />
              )}
            </ActionIcon>
          </Tooltip>
          <TextInput
            classNames={global}
            placeholder={lang.search}
            leftSection={<IconSearch size={16} stroke={1.5} />}
            value={search}
            onChange={(event) => handleSearchChange(event.currentTarget.value)}
            size="xs"
            maw={200}
          />
          <Select
            classNames={global}
            data={itemTypes}
            placeholder={lang.filter}
            size="xs"
            w={150}
            onChange={handleFilter}
          />
        </Group>
      </Group>
      <ScrollArea
        h={"calc(100% - 75px)"}
        type="hover"
        scrollbars={"y"}
        scrollbarSize={6}
        mt="sm"
      >
        <Grid>
          {currentItems.map((item) => {
            const currentQuantity = getQuantity(item.name);
            const outOfStock = item.stock === 0;
            return (
              <Grid.Col span={2} key={item.name} miw={190}>
                <Card className={classes.card}>
                  <Box className={classes.imageWrap}>
                    <ItemImage
                      inventory={inventory}
                      name={item.name}
                      w={52}
                      h={52}
                      fit="contain"
                      alt={item.label}
                    />
                  </Box>
                  <Text className={classes.itemLabel} truncate mt={10}>
                    {item.label}
                  </Text>
                  <Group justify="space-between" mt={4} mb={10}>
                    <Group gap={5} lh={0}>
                      <IconBox size={13} color="var(--text-dim)" />
                      <Text
                        mt={2}
                        className={classes.stockValue}
                        style={{
                          color: outOfStock
                            ? "var(--danger)"
                            : "var(--text-dim)",
                        }}
                      >
                        {item.stock}
                      </Text>
                    </Group>
                    <Group gap={4}>
                      <Text className={classes.price}>
                        {`${daLang.money_symbol}${item.price.toLocaleString("en-US")}`}
                      </Text>
                      <ActionIcon
                        size="xs"
                        variant="transparent"
                        c="var(--text-dim)"
                        onClick={() => handleOpenPriceModal(item)}
                        opacity={0.5}
                      >
                        <IconEdit size={14} />
                      </ActionIcon>
                    </Group>
                  </Group>
                  <Stack gap={6}>
                    <NumberInput
                      value={currentQuantity}
                      onChange={(val) => handleQuantityChange(item.name, val)}
                      min={1}
                      allowDecimal={false}
                      allowLeadingZeros={false}
                      max={1000}
                      allowNegative={false}
                      size="xs"
                      styles={{
                        input: {
                          backgroundColor: "var(--bg-input)",
                          borderColor: "rgba(255,255,255,0.06)",
                          color: "var(--text-main)",
                          fontFamily: "var(--font-display)",
                          fontSize: "13px",
                          textAlign: "center",
                        },
                      }}
                    />
                    <Button
                      size="xs"
                      onClick={() => handleAction(item.name, "withdraw")}
                      disabled={outOfStock}
                      fullWidth
                      className={classes.btnWithdraw}
                    >
                      {lang.withdraw ?? "Withdraw"}
                    </Button>
                  </Stack>
                </Card>
              </Grid.Col>
            );
          })}
        </Grid>
      </ScrollArea>
      <Modal
        lockScroll={false}
        classNames={global}
        opened={priceModalOpened}
        onClose={() => setPriceModalOpened(false)}
        title={lang.update_price || "Update Price"}
        centered
        size={300}
      >
        <NumberInput
          classNames={global}
          value={newPrice}
          onChange={setNewPrice}
          min={0}
          allowNegative={false}
          allowDecimal={false}
          allowLeadingZeros={false}
          label="Price"
          mb="md"
          thousandSeparator=","
          prefix={daLang.money_symbol}
          max={100000000}
        />
        <Button className={global.button} fullWidth onClick={handleUpdatePrice}>
          {lang.submit || "Submit"}
        </Button>
      </Modal>
    </>
  );
};

export default Counter;
