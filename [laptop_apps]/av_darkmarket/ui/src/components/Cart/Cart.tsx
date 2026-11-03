import {
  Grid,
  Stack,
  ScrollAreaAutosize,
  Image,
  Group,
  Flex,
  Text,
  Modal,
  ActionIcon,
} from "@mantine/core";
import { useRecoilState, useRecoilValue } from "recoil";
import { X } from "lucide-react";
import { CartItems, Inventory, Lang } from "../../reducers/atoms";
import { CartType } from "../../types/types";
import { Modifier } from "../Modifier/Modifier";
import { CartSummary } from "./CartSummary";
import { useState } from "react";
import { fetchNui } from "../../hooks/useNuiEvents";
import { Loading } from "../Loading";
import global from "../../global.module.css";
import classes from "./styles.module.css";

interface Properties {
  close: () => void;
}

export const Cart = ({ close }: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const [loading, setLoading] = useState(false);
  const inventory = useRecoilValue(Inventory);
  const [cart, setCart] = useRecoilState(CartItems);

  const handlePayment = async () => {
    setLoading(true);
    const resp = await fetchNui("av_darkmarket", "pay", cart);
    if (resp) {
      setCart([]);
      close();
    }
    setTimeout(() => {
      setLoading(false);
    }, 100);
  };

  const handleControl = (item: CartType, type: string, amount: number) => {
    if (isNaN(amount)) return;
    setCart((prevCart) => {
      const cleanAmount = Number(amount);
      const existingItem = prevCart.find(
        (i) => i.identifier === item.identifier,
      );
      if (!existingItem) return prevCart;
      if (type === "set" && cleanAmount <= 0) {
        return prevCart.filter((i) => i.identifier !== item.identifier);
      }
      if (type === "remove" && existingItem.amount - cleanAmount <= 0) {
        return prevCart.filter((i) => i.identifier !== item.identifier);
      }
      return prevCart.map((cartItem) => {
        if (cartItem.identifier !== item.identifier) return cartItem;
        let newAmount = cartItem.amount;
        if (type === "add") {
          newAmount = Math.min(cartItem.stock, cartItem.amount + cleanAmount);
        } else if (type === "remove") {
          newAmount = Math.max(0, cartItem.amount - cleanAmount);
        } else if (type === "set") {
          newAmount = Math.min(cartItem.stock, cleanAmount);
        }
        return {
          ...cartItem,
          amount: isNaN(newAmount) ? cartItem.amount : newAmount,
        };
      });
    });
  };

  const handleDelete = (identifier: string) => {
    setCart((prevCart) =>
      prevCart.filter((item) => item.identifier !== identifier),
    );
  };

  return (
    <Modal
      classNames={global}
      opened
      onClose={close}
      centered
      lockScroll={false}
      c="white"
      size={800}
      mih={300}
      title={
        <Text fz="sm" truncate>
          {lang.cart_header}
        </Text>
      }
      trapFocus={false}
    >
      {loading ? (
        <div style={{ height: 300 }}>
          <Loading />
        </div>
      ) : (
        <Grid>
          <Grid.Col span={7}>
            <ScrollAreaAutosize
              mih={300}
              mah={500}
              type="hover"
              scrollbars="y"
              scrollbarSize={5}
              offsetScrollbars
            >
              {cart.length > 0 ? (
                <>
                  <Stack gap="sm">
                    {cart.map((product) => (
                      <Group className={classes.card} p="xs">
                        <Image
                          src={
                            product.image
                              ? product.image
                              : `https://cfx-nui-${inventory}${product.name}.${
                                  product.extension ? product.extension : "png"
                                }`
                          }
                          fallbackSrc="./no_image.png"
                          h={25}
                          w={25}
                          fit="contain"
                        />
                        <Flex direction="column">
                          <Text fz="sm">{product.label}</Text>
                          <Text fz="xs" c="var(--text-normal)" fw={450}>
                            {`${product.price.toLocaleString("en-US")} ${product.accountLabel} | ${lang.stock}: ${product.stock}`}
                          </Text>
                        </Flex>
                        <Group ml="auto" gap="xs">
                          <Modifier
                            product={product}
                            handleControl={handleControl}
                          />
                          <ActionIcon
                            size="xs"
                            variant="transparent"
                            color="red"
                            onDoubleClick={() => {
                              handleDelete(product.identifier);
                            }}
                          >
                            <X size={12} strokeWidth={1.5} />
                          </ActionIcon>
                        </Group>
                      </Group>
                    ))}
                  </Stack>
                </>
              ) : (
                <Text fz="xs" c="dimmed" ta="center">
                  {lang.empty_cart}
                </Text>
              )}
            </ScrollAreaAutosize>
          </Grid.Col>
          <Grid.Col span="auto">
            <CartSummary handlePayment={handlePayment} />
          </Grid.Col>
        </Grid>
      )}
    </Modal>
  );
};
