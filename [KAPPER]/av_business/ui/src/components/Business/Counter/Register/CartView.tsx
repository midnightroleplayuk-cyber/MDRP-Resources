import { useMemo } from "react";
import {
  Grid,
  Card,
  Text,
  Group,
  Button,
  Stack,
  TextInput,
  ScrollArea,
  ActionIcon,
  Divider,
} from "@mantine/core";
import { ItemImage } from "../../../ItemImage/ItemImage";
import { IconX } from "@tabler/icons-react";
import { CartItem } from "./CounterRegister";
import { DiscountType } from "../../Discounts/api";
import classes from "./style.module.css";
import global from "../../../../global.module.css";

interface Properties {
  lang: any;
  daLang: any;
  inventory: string;
  cart: CartItem[];
  code: string | null;
  coupon: DiscountType | null;
  tempCode: string;
  cartTotal: number;
  cartItemsCount: number;
  onTempCodeChange: (val: string) => void;
  onRemoveFromCart: (name: string) => void;
  onApplyCode: (code: string) => void;
  onClearCode: () => void;
  onCheckout: () => void;
}

export const CartView = ({
  lang,
  daLang,
  cart,
  inventory,
  code,
  coupon,
  tempCode,
  onTempCodeChange,
  onRemoveFromCart,
  onApplyCode,
  onClearCode,
  onCheckout,
}: Properties) => {
  const cartTotal = useMemo(() => {
    return cart.reduce((total, item) => total + item.price * item.amount, 0);
  }, [cart]);

  const cartItemsCount = useMemo(() => {
    return cart.reduce((count, item) => count + item.amount, 0);
  }, [cart]);

  return (
    <Grid h="calc(100% - 60px)" gap="xl">
      <Grid.Col span={7} h="100%">
        <ScrollArea h="100%" type="auto" offsetScrollbars>
          <Stack gap="sm">
            {cart.map((item) => (
              <Card key={item.name} className={classes.cartItemCard}>
                <Group justify="space-between" wrap="nowrap">
                  <Group wrap="nowrap">
                    <ItemImage
                      inventory={inventory}
                      name={item.name}
                      w={40}
                      h={40}
                      fit="contain"
                    />
                    <Stack gap={0}>
                      <Text fz="sm" fw={600} c="var(--text-main)" truncate>
                        {item.label}
                      </Text>
                      <Group gap="xs">
                        <Text fz="sm" fw={700} c="var(--success)">
                          ${item.price}
                        </Text>
                        <Text fz="xs" c="var(--text-dim)">
                          {lang.amount || "Amount"}: {item.amount}
                        </Text>
                      </Group>
                    </Stack>
                  </Group>
                  <ActionIcon
                    variant="subtle"
                    color="red"
                    onClick={() => onRemoveFromCart(item.name)}
                  >
                    <IconX size={16} />
                  </ActionIcon>
                </Group>
              </Card>
            ))}
          </Stack>
        </ScrollArea>
      </Grid.Col>
      <Grid.Col span={5}>
        <Stack gap="sm" w="100%">
          <Group justify="center" align="center">
            <Divider flex={1} color="var(--border)" />
            <Text fz="sm" c="var(--text-dim)" mx="sm">
              {lang.total_header || "Total"}
            </Text>
            <Divider flex={1} color="var(--border)" />
          </Group>
          <Group justify="space-between">
            <Text fz="xs" c="var(--text-dim)" tt="uppercase" fw={600}>
              {lang.products_subheader || "PRODUCTS"}:
            </Text>
            <Text fz="sm" fw={600} c="var(--primary-200)">
              {cartItemsCount}
            </Text>
          </Group>
          <Group justify="space-between">
            <Text fz="xs" c="var(--text-dim)" tt="uppercase" fw={600}>
              {lang.subtotal || "SUBTOTAL"}:
            </Text>
            <Text fz="md" fw={600} c="var(--cyan)" ff="var(--font-display)">
              {`${daLang.money_symbol}${cartTotal.toLocaleString("en-US")}`}
            </Text>
          </Group>
          {code ? (
            <Group>
              <Text fz="xs" c="var(--text-dim)" tt="uppercase" fw={600}>
                {lang.code || "Code"}:
              </Text>
              <Group ml="auto" gap={2}>
                <Text fz="xs" c="var(--text-dim)" tt="uppercase" fw={600}>
                  {code}
                </Text>
                <ActionIcon
                  size="xs"
                  variant="transparent"
                  color="red"
                  onClick={onClearCode}
                >
                  <IconX style={{ height: 12, width: 12 }} stroke={1.5} />
                </ActionIcon>
              </Group>
            </Group>
          ) : (
            <Group mt="xs">
              <TextInput
                classNames={global}
                size="xs"
                placeholder={lang.discounts || "Discounts"}
                maxLength={50}
                flex={1}
                value={tempCode}
                onChange={(e) => onTempCodeChange(e.currentTarget.value)}
              />
              <Button
                size="xs"
                className={global.button}
                onClick={() => onApplyCode(tempCode)}
              >
                {lang.apply || "Apply"}
              </Button>
            </Group>
          )}
          <Group justify="space-between">
            <Text fz="xs" c="var(--text-dim)" tt="uppercase" fw={600}>
              {lang.total || "TOTAL"}:
            </Text>
            <Text
              fz="lg"
              fw={600}
              c="var(--success)"
              ff="var(--font-display)"
              tt="uppercase"
            >
              {`${daLang.money_symbol}${Math.max(
                0,
                Math.round(
                  coupon?.type === "amount"
                    ? cartTotal - (coupon?.discount ?? 0)
                    : cartTotal * (1 - (coupon?.discount ?? 0) / 100),
                ),
              ).toLocaleString("en-US")}`}
            </Text>
          </Group>
          <Button
            className={global.button}
            fullWidth
            size="xs"
            color="var(--accent)"
            onClick={onCheckout}
            disabled={cart.length === 0}
          >
            {lang.pay_order || "Pay Order"}
          </Button>
        </Stack>
      </Grid.Col>
    </Grid>
  );
};
