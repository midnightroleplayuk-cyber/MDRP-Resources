import {
  Group,
  Grid,
  ScrollArea,
  Text,
  TextInput,
  Select,
  Card,
  Box,
  Image,
  Button,
} from "@mantine/core";
import { IconSearch, IconWallet } from "@tabler/icons-react";
import { useEffect, useState } from "react";
import {
  fetchNui,
  isEnvBrowser,
  useNuiEvent,
} from "../../../hooks/useNuiEvents";
import { Loading } from "../../Loading";
import { ApiCategories, ApiProducts } from "../../../api/Market";
import { ProductType, SelectType } from "../../../types/types";
import { useRecoilValue } from "recoil";
import { Gang, Lang } from "../../../reducers/atoms";
import { calculateLevel } from "../../../hooks/calculateLevel";
import { useMediaQuery } from "@mantine/hooks";
import global from "../../../global.module.css";
import classes from "./style.module.css";

const Market = () => {
  const lang: any = useRecoilValue(Lang);
  const { level, max } = useRecoilValue(Gang);
  const [loaded, setLoaded] = useState(false);
  const [money, setMoney] = useState(128938);
  const [category, setCategory] = useState("");
  const [categories, setCategories] = useState<SelectType[]>([]);
  const [allProducts, setAllProducts] = useState<ProductType[]>([]);
  const [filtered, setFiltered] = useState<ProductType[]>([]);
  const calculatedLevel = calculateLevel(level, max);
  const isWide = useMediaQuery("(min-width: 1400px)");

  useNuiEvent("updateMoney", (amount: number) => {
    setMoney(amount);
  });
  const handleBuy = (product: ProductType) => {
    fetchNui("av_gangs", "buyProduct", product.name);
  };
  const handleCategory = async (name: string) => {
    setCategory(name);
    const resp = await fetchNui("av_gangs", "getProducts", name);
    if (resp) {
      setAllProducts(resp);
      setFiltered(resp);
    }
  };
  const handleSearch = (input: string) => {
    if (input === "") {
      setFiltered(allProducts);
      return;
    }
    const lowercasedInput = input.toLowerCase();
    const res = allProducts.filter((product) => {
      const levelMatch = product.level <= calculatedLevel.level;
      const labelMatch = product.label
        ? product.label.toLowerCase().includes(lowercasedInput)
        : false;
      return levelMatch && labelMatch;
    });
    setFiltered(res);
  };
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_gangs", "getMarket");
      if (resp) {
        setMoney(resp.money);
        setCategories(resp.categories);
        if (resp.categories[0]) {
          handleCategory(resp.categories[0].value);
        }
      } else {
        if (isEnvBrowser()) {
          setCategories(ApiCategories);
          setAllProducts(ApiProducts);
          setFiltered(ApiProducts);
          setCategory(ApiCategories[0].value);
        }
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, []);

  if (!loaded) return <Loading />;
  return (
    <>
      <Group className={classes.card} p="md">
        <Text
          fz="1.35rem"
          c="white"
          ff="Bebas Neue"
          fw={500}
          lts={1.55}
        >{`${filtered.length} ${lang.products}`}</Text>
        <Group ml="auto">
          <Group gap="xs" mr="xs">
            <IconWallet
              style={{ height: "16px", width: "16px" }}
              color="#63e6be"
              stroke={1.5}
            />
            <Text fw={500} fz="sm" c="white">{`${
              lang.money_symbol
            }${money.toLocaleString("en-US")}`}</Text>
          </Group>
          <TextInput
            classNames={global}
            size="xs"
            placeholder={lang.search}
            leftSection={<IconSearch size={16} stroke={1.5} />}
            onChange={(e) => {
              handleSearch(e.currentTarget.value);
            }}
          />
          <Select
            classNames={global}
            size="xs"
            placeholder={lang.categories}
            data={categories}
            allowDeselect
            value={category}
            onChange={(e) => {
              if (!e) return;
              handleCategory(e);
            }}
          />
        </Group>
      </Group>
      <ScrollArea
        className={classes.scroll}
        offsetScrollbars
        type="hover"
        scrollbars="y"
        scrollbarSize={5}
        mt="sm"
      >
        <Grid>
          {filtered.map((product) => (
            <Grid.Col key={product.label} maw={isWide ? 295 : 255}>
              <Card withBorder radius="md" className={classes.card} h={315}>
                <Card.Section className={classes.image}>
                  {calculatedLevel.level < (product.level ?? 0) && (
                    <Box className={classes.blur} />
                  )}
                  <Image
                    src={product.photo}
                    h={120}
                    fallbackSrc="mission_default.webp"
                    fit="cover"
                  />
                </Card.Section>
                <Text
                  mt="xs"
                  fw={500}
                  truncate
                  ff="Bebas Neue"
                  fz="1.05rem"
                  lts={1.5}
                >
                  {calculatedLevel.level >= (product.level ?? 0)
                    ? product.label
                    : lang.classified}
                </Text>
                <Text
                  className={classes.description}
                  fz="xs"
                  c="dimmed"
                  lineClamp={4}
                  mt={2}
                >
                  {calculatedLevel.level >= (product.level ?? 0)
                    ? product.description
                    : `${lang.requiredLevel} ${product.level}`}
                </Text>
                <Group className={classes.buttonBox} mt="sm">
                  {calculatedLevel.level >= product.level ? (
                    <Text fw={500} c="gray.4" fz="sm">{`${
                      isWide ? `${lang.price}:` : ``
                    } ${lang.money_symbol}${product.price.toLocaleString(
                      "en-US"
                    )}`}</Text>
                  ) : (
                    <Text fw={500} c="gray.4" fz="sm">
                      {`${isWide ? `${lang.price}:` : ``} N/A`}
                    </Text>
                  )}
                  <Button
                    className={global.button}
                    color="var(--color-main)"
                    c="var(--color-text)"
                    size="xs"
                    variant="filled"
                    ml="auto"
                    fullWidth
                    disabled={calculatedLevel.level < (product.level ?? 0)}
                    onClick={() => {
                      handleBuy(product);
                    }}
                  >
                    {lang.buy}
                  </Button>
                </Group>
              </Card>
            </Grid.Col>
          ))}
        </Grid>
      </ScrollArea>
    </>
  );
};

export default Market;
