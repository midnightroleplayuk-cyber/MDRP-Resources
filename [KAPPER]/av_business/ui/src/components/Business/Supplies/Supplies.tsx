import {
  Grid,
  Text,
  Group,
  TextInput,
  ActionIcon,
  NumberInput,
  Card,
  ScrollArea,
  Indicator,
  Flex,
  Box,
} from "@mantine/core";
import { ItemImage } from "../../ItemImage/ItemImage";
import { useState, useEffect } from "react";
import { ApiIngredients } from "../../../API/products";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import { IconSearch, IconShoppingCart } from "@tabler/icons-react";
import { useDisclosure } from "@mantine/hooks";
import { IngredientsType } from "../../../types/types";
import { Loading } from "../../Loading";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { Cart } from "./Cart";
import classes from "./style.module.css";
import global from "../../../global.module.css";

const Supplies = () => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.supplies;
  const [loaded, setLoaded] = useState(false);
  const [opened, { toggle, close }] = useDisclosure(false);
  const [maxAmount, setMaxAmount] = useState(100);

  const [total, setTotal] = useState(0);
  const [cart, setCart] = useState<(IngredientsType & { amount: number })[]>(
    [],
  );
  const [search, setSearch] = useState("");
  const [allItems, setAllItems] = useState<
    (IngredientsType & { amount?: number })[]
  >([]);
  const [filtered, setFiltered] = useState<
    (IngredientsType & { amount?: number })[]
  >([]);
  const [inventory, setInventory] = useState("");
  const [modified, setModified] = useState<{ [key: string]: boolean }>({});

  const handleCart = (item: IngredientsType, amount: number) => {
    setModified((prev) => ({ ...prev, [item.value]: true }));
    setCart((prevCart) => {
      const exists = prevCart.find((i) => i.value === item.value);
      if (amount === 0) {
        return prevCart.filter((i) => i.value !== item.value);
      }
      if (exists) {
        return prevCart.map((i) =>
          i.value === item.value ? { ...i, amount } : i,
        );
      }
      return [...prevCart, { ...item, amount }];
    });
  };
  const handleSearchChange = (value: string) => {
    setSearch(value);
    const search = value.toLowerCase();
    const res = allItems.filter(
      (item) =>
        (item.label ? item.label.toLowerCase().includes(search) : false) ||
        (item.value ? item.value.toLowerCase().includes(search) : false),
    );
    setFiltered(res);
  };
  const handleBuy = async () => {
    setLoaded(false);
    const resp = await fetchNui("av_business", "buySupplies", cart);
    if (resp) {
      setCart([]);
      setModified({});
    }
    setTimeout(() => {
      setLoaded(true);
    }, 200);
  };
  useEffect(() => {
    const newTotal = cart.reduce((acc, item) => {
      const price = item.price ?? 1;
      return acc + price * item.amount;
    }, 0);
    setTotal(newTotal);
  }, [cart]);

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getSupplies");
      if (resp) {
        setAllItems(resp.supplies);
        setFiltered(resp.supplies);
        setInventory(resp.inventory);
        setMaxAmount(resp.maxAmount);
      } else {
        if (isEnvBrowser()) {
          setAllItems(ApiIngredients);
          setFiltered(ApiIngredients);
        }
      }
      setTimeout(() => {
        setLoaded(true);
      }, 200);
    };
    fetchData();
  }, []);
  if (!loaded) return <Loading />;
  return (
    <>
      <Cart
        daLang={daLang}
        opened={opened}
        close={close}
        cart={cart}
        inventory={inventory}
        handleCart={handleCart}
        handleBuy={handleBuy}
        total={total}
      />
      <Group
        bg="var(--bg-card)"
        p="sm"
        style={{
          borderRadius: "6px",
          border: "solid 1px var(--border)",
        }}
      >
        <Flex gap="xs" direction="column">
          <Text ff="var(--font-display)" tt="uppercase" fz="xl" fw={700}>
            {lang.header}
          </Text>
          <Text mt={-15} fz="xs" c="var(--text-dim)">
            {`${filtered.length} ${lang.items}`}
          </Text>
        </Flex>

        <TextInput
          classNames={global}
          placeholder={lang.search}
          leftSection={<IconSearch size={16} stroke={1.5} />}
          value={search}
          onChange={(e) => {
            handleSearchChange(e.currentTarget.value);
          }}
          size="xs"
          ml="auto"
          w={200}
        />
        <Indicator
          color="var(--cyan)"
          inline
          processing
          disabled={cart.length === 0}
        >
          <ActionIcon
            className={classes.button}
            variant="filled"
            w={40}
            onClick={() => {
              toggle();
            }}
          >
            <IconShoppingCart style={{ height: "14px" }} />
          </ActionIcon>
        </Indicator>
      </Group>
      <ScrollArea
        type="hover"
        scrollbars={"y"}
        scrollbarSize={6}
        h={"calc(100% - 75px)"}
        mt="md"
      >
        <Grid gap="sm">
          {filtered.map((item) => {
            const cartItem = cart.find((i) => i.value === item.value);
            const inputValue = cartItem
              ? cartItem.amount
              : modified[item.value]
                ? 0
                : undefined;
            return (
              <Grid.Col miw={155} maw={155} key={item.value}>
                <Card
                  className={`${classes.card} ${cartItem ? classes.cardActive : ""}`}
                >
                  <Box className={classes.imageWrap}>
                    <ItemImage
                      inventory={inventory}
                      name={item?.value}
                      w={44}
                      h={44}
                      style={{ objectFit: "contain" }}
                    />
                  </Box>
                  <Text className={classes.itemLabel} truncate mt={8}>
                    {item.label}
                  </Text>
                  <Text className={classes.itemPrice}>
                    {`${daLang.money_symbol} ${item.price}`}
                  </Text>
                  <NumberInput
                    classNames={global}
                    hideControls
                    size="xs"
                    mt={8}
                    value={inputValue}
                    allowDecimal={false}
                    allowLeadingZeros={false}
                    allowNegative={false}
                    max={maxAmount}
                    onChange={(e) => {
                      handleCart(item, Number(e));
                    }}
                    rightSection={
                      <Text mr="xl" fz="xs" c="var(--text-dim)">
                        {lang.quantity}
                      </Text>
                    }
                    styles={{
                      input: {
                        textAlign: "center",
                        backgroundColor: "var(--bg-input)",
                        borderColor: cartItem
                          ? "var(--accent)"
                          : "rgba(255,255,255,0.06)",
                        color: "var(--text-main)",
                        fontFamily: "var(--font-display)",
                        fontSize: "13px",
                        transition: "border-color 0.2s",
                      },
                    }}
                  />
                </Card>
              </Grid.Col>
            );
          })}
        </Grid>
      </ScrollArea>
    </>
  );
};

export default Supplies;
