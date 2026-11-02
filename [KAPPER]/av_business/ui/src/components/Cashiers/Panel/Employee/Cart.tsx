import { useEffect, useState } from "react";
import {
  Group,
  Stack,
  Text,
  Select,
  TextInput,
  Flex,
  ScrollArea,
  ActionIcon,
  Divider,
  Button,
  Badge,
  Box,
} from "@mantine/core";
import { ItemImage } from "../../../ItemImage/ItemImage";
import { JobItem, SelectType } from "../../../../types/types";
import { useAtomValue } from "jotai";
import { Lang } from "../../../../reducers/atoms";
import { IconX } from "@tabler/icons-react";
import global from "../../../../global.module.css";
import classes from "./style.module.css";
import { DiscountType, PromoType } from "../../../Business/Discounts/api";

interface ItemType extends JobItem {
  toUse: string[];
  isCustom?: boolean;
}

interface Properties {
  cart: ItemType[];
  inventory: string;
  total: number;
  itemsTotal: number;
  allTypes: SelectType[];
  coupon?: DiscountType | null;
  code?: string | null;
  activePromo?: PromoType | null;
  handleCode: (input: string) => void;
  setCode: () => void;
  handleRemove: (name: string, index: number) => void;
  getIngredientLabel: (ingredient: string) => string;
  handleOrder: () => void;
}

export const Cart = ({
  cart,
  inventory,
  total,
  coupon,
  code,
  itemsTotal,
  allTypes,
  handleCode,
  setCode,
  handleRemove,
  getIngredientLabel,
  handleOrder,
  activePromo,
}: Properties) => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.cashier;
  const [filtered, setFiltered] = useState(cart);
  const [tempCode, setTempCode] = useState("");

  const handleSearch = (input: string) => {
    const res = cart.filter(
      (item) =>
        (item.name ? item.name.toLowerCase().includes(input) : false) ||
        (item.label ? item.label.toLowerCase().includes(input) : false),
    );
    setFiltered(res);
  };

  const handleFilter = (type: string | null) => {
    if (!type) {
      setFiltered(cart);
    } else {
      const res = cart.filter((item) =>
        item.type ? item.type.toLowerCase().includes(type) : false,
      );
      setFiltered(res);
    }
  };

  useEffect(() => {
    setFiltered(cart);
  }, [cart]);

  const applyDisc = (d: DiscountType | PromoType | null | undefined) =>
    !d
      ? total
      : d.type === "amount"
        ? total - d.discount
        : total * (1 - d.discount / 100);

  const finalTotal = `${daLang.money_symbol}${Math.max(0, Math.round(Math.min(applyDisc(coupon), applyDisc(activePromo ?? undefined)))).toLocaleString("en-US")}`;

  return (
    <Flex h="100%" gap="xs">
      <Flex
        direction="column"
        style={{ width: "52%", flexShrink: 0, height: "100%" }}
      >
        <Group style={{ flexShrink: 0, padding: "8px" }} grow>
          <Select
            classNames={global}
            size="xs"
            placeholder={lang.filter_type}
            data={allTypes}
            searchable
            onChange={(e) => handleFilter(e)}
          />
          <TextInput
            classNames={global}
            size="xs"
            placeholder={daLang.search}
            onChange={(e) => handleSearch(e.currentTarget.value)}
          />
        </Group>
        <ScrollArea
          style={{ flex: 1 }}
          type="hover"
          scrollbars="y"
          scrollbarSize={5}
          pl="xs"
          pr="xs"
          pb="sm"
        >
          <Stack gap="xs">
            {filtered.map((item, index) => (
              <Flex
                key={`${item.name}-${index}`}
                direction="column"
                className={classes.card}
                p="xs"
                gap={5}
              >
                <Group>
                  <ItemImage
                    inventory={inventory}
                    name={item?.name}
                    image={item.image}
                    useDefault={!item.image && item.isCustom}
                    h={32}
                    w={32}
                    fit="contain"
                  />
                  <Flex direction="column">
                    <Text fz="sm" c="gray.1">
                      {item.label}
                    </Text>
                    <Group gap="xs">
                      <Text
                        fz="sm"
                        c="var(--success)"
                        ff="var(--font-display)"
                        fw={450}
                      >{`${daLang.money_symbol}${item.price.toLocaleString("en-US")}`}</Text>
                      <Group gap={2}>
                        <Text fz="xs" c="var(--text-dim)" fw={450}>
                          {lang.amount}:
                        </Text>
                        <Text fz="xs" c="var(--text-normal)" fw={450}>
                          {item.amount}
                        </Text>
                      </Group>
                    </Group>
                  </Flex>
                  <ActionIcon
                    ml="auto"
                    variant="transparent"
                    color="var(--danger)"
                    size="xs"
                    onClick={() => handleRemove(item.name, index)}
                  >
                    <IconX style={{ height: 14, width: 14 }} stroke={1.5} />
                  </ActionIcon>
                </Group>
                {item.toUse?.length && item.toUse.length > 0 && (
                  <Text
                    fz="xs"
                    c="var(--text-dim)"
                    fw={450}
                    style={{ wordBreak: "break-word", whiteSpace: "normal" }}
                  >
                    {item.toUse
                      .map((name) => getIngredientLabel(name))
                      .join(", ")}
                  </Text>
                )}
              </Flex>
            ))}
          </Stack>
        </ScrollArea>
      </Flex>
      <Flex
        direction="column"
        style={{ flex: 1, height: "100%", gap: "8px" }}
      >
        <Box style={{ flexShrink: 0 }}>
          <Divider label={lang.total} labelPosition="center" mb="xs" />
          <Stack gap={6}>
            <Group justify="space-between">
              <Text fz="xs" c="var(--text-dim)" tt="uppercase" fw={600}>
                {lang.products_subheader}:
              </Text>
              <Text fz="sm" fw={600} c="var(--primary-200)">
                {itemsTotal}
              </Text>
            </Group>
            <Group justify="space-between">
              <Text fz="xs" c="var(--text-dim)" tt="uppercase" fw={600}>
                {lang.subtotal}:
              </Text>
              <Text fz="md" fw={600} c="var(--cyan)" ff="var(--font-display)">
                {`${daLang.money_symbol}${total.toLocaleString("en-US")}`}
              </Text>
            </Group>
            <Group justify="space-between">
              <Text fz="xs" c="var(--text-dim)" tt="uppercase" fw={600}>
                {lang.discounts}:
              </Text>
              <Text fz="sm" fw={600} c="var(--primary-200)">
                {coupon
                  ? coupon.type === "percentage"
                    ? `${coupon.discount}%`
                    : `${daLang.money_symbol}${coupon.discount}`
                  : "N/A"}
              </Text>
            </Group>
            {activePromo && (
              <Group
                justify="space-between"
                p={6}
                style={{
                  background: "rgba(124,96,200,0.12)",
                  borderRadius: 4,
                  border: "1px solid rgba(124,96,200,0.3)",
                }}
              >
                <Text fz="xs" c="var(--text-dim)" tt="uppercase" fw={600}>
                  Promo:
                </Text>
                <Group gap={4}>
                  <Badge size="xs" color="violet" variant="light">
                    {activePromo.label}
                  </Badge>
                  <Text fz="xs" fw={600} c="var(--accent)">
                    {activePromo.type === "percentage"
                      ? `-${activePromo.discount}%`
                      : `-${daLang.money_symbol}${activePromo.discount}`}
                  </Text>
                </Group>
              </Group>
            )}
          </Stack>
        </Box>
        <Box style={{ flexShrink: 0 }}>
          {code ? (
            <Group>
              <Text fz="xs" c="var(--text-dim)">
                {lang.code}:
              </Text>
              <Group ml="auto" gap={2}>
                <Text fz="xs" c="var(--text-dim)">
                  {code}
                </Text>
                <ActionIcon
                  size="xs"
                  variant="transparent"
                  color="red"
                  onClick={() => setCode()}
                >
                  <IconX style={{ height: 12, width: 12 }} stroke={1.5} />
                </ActionIcon>
              </Group>
            </Group>
          ) : (
            <Group>
              <TextInput
                classNames={global}
                size="xs"
                placeholder={lang.discounts}
                maxLength={50}
                flex={1}
                value={tempCode}
                onChange={(e) => setTempCode(e.currentTarget.value)}
              />
              <Button
                size="xs"
                className={classes.button}
                onClick={() => handleCode(tempCode)}
              >
                {lang.apply}
              </Button>
            </Group>
          )}
        </Box>
        <Box style={{ flex: 1 }} />
        <Box style={{ flexShrink: 0 }}>
          <Group justify="space-between" mb="xs">
            <Text fz="xs" c="var(--text-dim)" tt="uppercase" fw={600}>
              {lang.total}:
            </Text>
            <Text fz="lg" fw={600} c="var(--success)" ff="var(--font-display)">
              {finalTotal}
            </Text>
          </Group>
          <Button
            className={classes.button}
            size="xs"
            disabled={cart.length === 0}
            fullWidth
            onClick={handleOrder}
          >
            {lang.send_order}
          </Button>
        </Box>
      </Flex>
    </Flex>
  );
};
