import { ItemImage } from "../ItemImage/ItemImage";
import { useEffect, useState } from "react";
import {
  Box,
  Transition,
  Group,
  Text,
  ScrollArea,
  Stack,
  Flex,
  Badge,
  Button,
} from "@mantine/core";
import { fetchNui, isEnvBrowser, useNuiEvent } from "../../hooks/useNuiEvents";
import { IngredientsType, OrderType } from "../../types/types";
import { ApiIngredients } from "../../API/products";
import { Loading } from "../Loading";
import classes from "./style.module.css";
import { Lang } from "../../reducers/atoms";
import { useAtomValue } from "jotai";

interface Properties {
  order: OrderType;
}

export const ActiveOrder = ({ order }: Properties) => {
  const lang: any = useAtomValue(Lang);
  const [focus, setFocus] = useState(isEnvBrowser());
  const [loading, setLoading] = useState(true);
  const [loaded, setLoaded] = useState(false);
  const [ingredients, setIngredients] =
    useState<IngredientsType[]>(ApiIngredients);
  const [inventory, setInventory] = useState("");

  useNuiEvent("setFocus", () => {
    setFocus(true);
  });
  const getIngredientLabel = (ingredient: string) => {
    const match = ingredients.find((item) => item.value === ingredient);
    return match ? match.label : ingredient;
  };
  const usingIngredient = (name: string, ingredients: string[] | undefined) => {
    if (!ingredients) return false;
    return ingredients.find((item) => item === name);
  };
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getIngredients");
      if (resp) {
        setIngredients(resp.ingredients);
        setInventory(resp.inventory);
      }
      setLoaded(true);
      setTimeout(() => {
        setLoading(false);
      }, 100);
    };
    const onKeyDown = (e: KeyboardEvent) => {
      switch (e.code) {
        case "KeyK":
          setFocus(false);
          fetchNui("av_business", "disableCursor");
          break;
        case "Escape":
          setLoaded(false);
          setTimeout(() => {
            fetchNui("av_business", "closeActive");
          }, 200);
          break;
        default:
          break;
      }
    };
    fetchData();
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, []);

  return (
    <>
      <Box className={classes.container}>
        <Transition
          mounted={loaded}
          transition="fade-left"
          duration={800}
          exitDuration={800}
          timingFunction="ease"
        >
          {(styles) => (
            <Stack
              className={classes.box}
              style={styles}
              w={320}
              mah={650}
              opacity={focus ? 1.0 : 0.8}
              p="xs"
            >
              {loading ? (
                <Loading />
              ) : (
                <>
                  <Text
                    fz="xl"
                    c="var(--text-main)"
                    fw={600}
                    ff="var(--font-display)"
                    tt="uppercase"
                    ta="center"
                    lts={1}
                  >
                    Active Order
                  </Text>
                  <ScrollArea
                    type="hover"
                    scrollbars="y"
                    scrollbarSize={5}
                    h={"calc(45vh - 110px)"}
                    bg="var(--dark-800)"
                    mah={450}
                    pr="xs"
                  >
                    <Stack>
                      {order.cart.map((product) => (
                        <Group className={classes.order} p="sm">
                          <Group>
                            <ItemImage
                              inventory={inventory}
                              name={product?.name}
                              image={product.image}
                              w={40}
                            />
                            <Flex direction="column" w={150}>
                              <Text fz="sm" c="var(--text-main)" truncate>
                                {product.label}
                              </Text>
                              <Text fz="xs" c="var(--text-dim)">
                                {`${lang.orders.quantity}: ${product.amount}`}
                              </Text>
                            </Flex>
                          </Group>
                          {product.ingredients.length > 0 && (
                            <Group gap={7}>
                              {product.ingredients.map((ingredient) => (
                                <Badge
                                  size="xs"
                                  fw={300}
                                  color={
                                    usingIngredient(ingredient, product.toUse)
                                      ? `var(--accent)`
                                      : `dark.4`
                                  }
                                >
                                  {getIngredientLabel(ingredient)}
                                </Badge>
                              ))}
                            </Group>
                          )}
                        </Group>
                      ))}
                    </Stack>
                  </ScrollArea>
                  <Group grow>
                    <Button
                      size="xs"
                      fullWidth
                      color="var(--accent)"
                      fw={400}
                      onClick={() => {
                        fetchNui(
                          "av_business",
                          "markAsCompleted",
                          order.identifier,
                        );
                      }}
                    >
                      {lang.orders.mark_complete}
                    </Button>
                    <Button
                      size="xs"
                      color="var(--accent)"
                      fw={400}
                      onClick={() => {
                        fetchNui(
                          "av_business",
                          "deleteOrderInProgress",
                          order.identifier,
                        );
                      }}
                    >
                      {lang.orders.mark_delivered}
                    </Button>
                  </Group>
                  <Group>
                    <Group gap={4} ml="auto">
                      <Text fz="xs" fw={500} c="var(--text-dim)">
                        [ESC]
                      </Text>
                      <Text fz="xs" fw={500} c="var(--text-main)">
                        Close
                      </Text>
                    </Group>
                    <Group gap={4}>
                      <Text fz="xs" fw={500} c="var(--text-dim)">
                        [K]
                      </Text>
                      <Text fz="xs" fw={500} c="var(--text-main)">
                        Toggle cursor
                      </Text>
                    </Group>
                  </Group>
                </>
              )}
            </Stack>
          )}
        </Transition>
      </Box>
    </>
  );
};
