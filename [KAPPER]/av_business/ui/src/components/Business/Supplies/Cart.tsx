import { ItemImage } from "../../ItemImage/ItemImage";
import {
  Dialog,
  Text,
  Stack,
  Flex,
  Box,
  ScrollAreaAutosize,
  Group,
  Indicator,
  ActionIcon,
  Button,
} from "@mantine/core";
import { IngredientsType } from "../../../types/types";
import { useClickOutside } from "@mantine/hooks";
import { IconX } from "@tabler/icons-react";
import classes from "./style.module.css";

interface Properties {
  daLang: any;
  opened: boolean;
  cart: any;
  close: () => void;
  inventory: string;
  handleCart: (item: IngredientsType, amount: number) => void;
  total: number;
  handleBuy: () => void;
}

export const Cart = ({
  daLang,
  opened,
  cart,
  close,
  inventory,
  handleCart,
  handleBuy,
  total,
}: Properties) => {
  const lang: any = daLang.supplies;
  const ref = useClickOutside(close);
  return (
    <>
      <Dialog
        bg="var(--bg-sidebar)"
        opened={opened}
        withCloseButton
        onClose={close}
        radius="md"
        position={{ right: 15, top: 120 }}
        withinPortal={false}
        miw={300}
        size="auto"
        ref={ref}
        shadow="md"
      >
        <Text size="md" mb="xs" fw={600}>
          {lang.cart_header}
        </Text>
        <Box>
          {cart.length > 0 ? (
            <>
              <ScrollAreaAutosize
                mt="lg"
                mah={300}
                type="hover"
                scrollbars="y"
                scrollbarSize={5}
                mx="auto"
              >
                <Stack gap="xs">
                  {cart.map((item: IngredientsType & { amount: number }) => (
                    <Indicator
                      offset={10}
                      color="transparent"
                      label={
                        <ActionIcon
                          size={10}
                          className={classes.delete}
                          variant="filled"
                          radius={50}
                          onClick={() => {
                            handleCart(item, 0);
                          }}
                        >
                          <IconX
                            style={{ height: 16, width: 16 }}
                            color="black"
                            stroke={3.5}
                          />
                        </ActionIcon>
                      }
                    >
                      <Group
                        bg="var(--bg-card)"
                        p="xs"
                        style={{
                          border: "solid 1px var(--border)",
                          borderRadius: "6px",
                        }}
                      >
                        <Group gap={4}>
                          <ItemImage
                            inventory={inventory}
                            name={item?.value}
                            w={30}
                            h={30}
                          />
                          <Flex direction="column" gap={0}>
                            <Text
                              fz="sm"
                              c="var(--text-main)"
                              maw={155}
                              truncate
                            >
                              {item.label}
                            </Text>
                            <Text
                              fz="xs"
                              c="var(--text-dim)"
                              mt={-3}
                            >{`x${item.amount}`}</Text>
                          </Flex>
                        </Group>
                        <Text
                          ml="auto"
                          mr="sm"
                          ff="var(--font-display)"
                          c="var(--success)"
                        >{`${daLang.money_symbol}${(item.price ? item.price : 1) * item.amount}`}</Text>
                      </Group>
                    </Indicator>
                  ))}
                </Stack>
              </ScrollAreaAutosize>
              <Button
                mt="sm"
                fullWidth
                size="xs"
                className={classes.button}
                onClick={handleBuy}
              >{`${lang.confirm} (${daLang.money_symbol}${total.toLocaleString(
                "en-US",
              )})`}</Button>
            </>
          ) : (
            <Text fz="xs" c="var(--text-dim)" ta="center">
              {lang.empty}
            </Text>
          )}
        </Box>
      </Dialog>
    </>
  );
};
