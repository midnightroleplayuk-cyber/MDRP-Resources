import { useState, useEffect } from "react";
import { IconPlus, IconMinus } from "@tabler/icons-react";
import {
  Box,
  Group,
  Card,
  Grid,
  Image,
  Text,
  NumberInput,
  ActionIcon,
  Button,
} from "@mantine/core";
import { fetchNui, isEnvBrowser } from "../../hooks/useNuiEvents";
import classes from "./style.module.css";
import { Loading } from "../Loading";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";

interface Product {
  name: string;
  label: string;
  amount: number;
  price: number;
  account: string;
  accountLabel: string;
  image: string;
  max?: number;
}

export const Market = () => {
  const { app: lang }: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(isEnvBrowser());
  const [allProducts, setAllProducts] = useState<Product[]>([]);
  const [inventory, setInventory] = useState("");
  const handleAmount = (
    name: string,
    amount: number,
    max: number | undefined
  ) => {
    if (max && amount > max) return;
    if (amount < 0) return;
    const copy = allProducts.map((item) =>
      item.name === name ? { ...item, amount } : item
    );
    setAllProducts(copy);
  };
  const handleBuy = (name: string, amount: number) => {
    const copy = allProducts.map((item) =>
      item.name === name ? { ...item, amount: 0 } : item
    );
    setAllProducts(copy);
    fetchNui("av_drugs", "buyProduct", { name, amount });
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_drugs", "getMarket");
      if (resp) {
        setAllProducts(resp.items);
        setInventory(resp.path);
        setTimeout(() => {
          setLoaded(true);
        }, 100);
      }
    };
    fetchData();
  }, []);
  if (!loaded) return <Loading />;
  return (
    <>
      {allProducts[0] ? (
        <Grid className={classes.container} gutter="sm">
          {allProducts.map((product) => (
            <Grid.Col span={3} key={product.name} maw={220}>
              <Card p="md" className={classes.card} withBorder radius="md">
                <Card.Section className={classes.imageSection}>
                  <Image
                    src={
                      product.image
                        ? `https://cfx-nui-${inventory}${product.image}.png`
                        : `https://cfx-nui-${inventory}${product.name}.png`
                    }
                    h={100}
                    w={100}
                    mr="auto"
                    ml="auto"
                    fallbackSrc={
                      product.image ? product.image : "./noimage.png"
                    }
                  />
                  <Text
                    ta="center"
                    fw={500}
                    tt="capitalize"
                    mt="xs"
                    c="white"
                    truncate
                  >
                    {product.label}
                  </Text>
                  <Text
                    ta="center"
                    fw={500}
                    tt="capitalize"
                    mt="xs"
                    fz="xs"
                    c="dimmed"
                  >
                    <a style={{ fontWeight: 700 }}>{`${lang.price}:`}</a>{" "}
                    {product.price.toLocaleString("en-US")}{" "}
                    {product.accountLabel}
                  </Text>
                </Card.Section>
                <Group justify="center" w="100%">
                  <ActionIcon
                    size="xs"
                    color="gray"
                    variant="light"
                    onClick={() => {
                      handleAmount(
                        product.name,
                        product.amount - 1,
                        product.max
                      );
                    }}
                  >
                    <IconMinus style={{ width: "12px", height: "12px" }} />
                  </ActionIcon>
                  <NumberInput
                    maw={55}
                    max={product.max ? product.max : 100}
                    min={0}
                    allowDecimal={false}
                    allowLeadingZeros={false}
                    allowNegative={false}
                    value={product.amount}
                    fw={500}
                    size="xs"
                    variant="transparent"
                    ta="center"
                    styles={{
                      input: {
                        textAlign: "center",
                      },
                    }}
                    hideControls
                    onChange={(e) => {
                      handleAmount(product.name, Number(e), product.max);
                    }}
                  />
                  <ActionIcon
                    size="xs"
                    color="gray"
                    variant="light"
                    onClick={() => {
                      handleAmount(
                        product.name,
                        product.amount + 1,
                        product.max
                      );
                    }}
                  >
                    <IconPlus style={{ width: "12px", height: "12px" }} />
                  </ActionIcon>
                </Group>
                <Button
                  size="xs"
                  color="teal.9"
                  mt="xs"
                  disabled={product.amount == 0}
                  onClick={() => {
                    handleBuy(product.name, product.amount);
                  }}
                >
                  {lang.buy}
                </Button>
              </Card>
            </Grid.Col>
          ))}
        </Grid>
      ) : (
        <Box
          style={{
            position: "relative",
            display: "flex",
            width: "100%",
            height: "100vh",
            textAlign: "center",
            alignContent: "center",
            justifyContent: "center",
          }}
        >
          <Text fz="sm" c="dimmed" fw={500} mt="15%" lts={2}>
            {lang.empty_market}
          </Text>
        </Box>
      )}
    </>
  );
};
