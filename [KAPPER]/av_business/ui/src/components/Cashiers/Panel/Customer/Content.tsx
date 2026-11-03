import {
  Group,
  Text,
  Stack,
  Flex,
  Divider,
  ActionIcon,
  TextInput,
  Button,
  Select,
  Badge,
  Box,
  ScrollArea,
} from "@mantine/core";
import { ItemImage } from "../../../ItemImage/ItemImage";
import { CartItem } from "./api";
import { DiscountType, PromoType } from "../../../Business/Discounts/api";
import { IconX, IconCheck } from "@tabler/icons-react";
import { useState } from "react";
import { SelectType } from "../../../../types/types";
import { LoyaltyVerifyResult } from "./Customer";
import global from "../../../../global.module.css";
import classes from "./style.module.css";

interface Properties {
  items: CartItem[];
  inventory: string;
  daLang: any;
  getIngredientLabel: (ingredient: string) => string;
  itemsTotal: number;
  total: number;
  coupon: DiscountType | undefined;
  code: string | null;
  setCode: () => void;
  handleCode: (code: string) => void;
  handlePay: () => void;
  accounts: SelectType[];
  setAccount: (option: string) => void;
  customerName: string;
  setCustomerName: (name: string) => void;
  account: string;
  activePromo?: PromoType | null;
  loyaltySerial: string | null;
  loyaltyInfo: LoyaltyVerifyResult | null;
  verifyLoyalty: (serial: string) => Promise<boolean>;
  clearLoyalty: () => void;
}

export const Content = ({
  items,
  inventory,
  daLang,
  getIngredientLabel,
  itemsTotal,
  total,
  coupon,
  code,
  setCode,
  handleCode,
  handlePay,
  accounts,
  setAccount,
  customerName,
  account,
  setCustomerName,
  activePromo,
  loyaltySerial,
  loyaltyInfo,
  verifyLoyalty,
  clearLoyalty,
}: Properties) => {
  const lang: any = daLang.cashier;
  const [tempCode, setTempCode] = useState("");
  const [tempLoyalty, setTempLoyalty] = useState("");

  const applyDisc = (d: DiscountType | PromoType | null | undefined) =>
    !d
      ? total
      : d.type === "amount"
        ? total - d.discount
        : total * (1 - d.discount / 100);

  const finalTotal = Math.max(
    0,
    Math.round(
      Math.min(applyDisc(coupon), applyDisc(activePromo ?? undefined)),
    ),
  );

  const isRedeemable = loyaltyInfo
    ? !loyaltyInfo.redeemed &&
      loyaltyInfo.visits + 1 >= loyaltyInfo.required_visits
    : false;

  const loyaltyDiscount =
    isRedeemable && loyaltyInfo
      ? loyaltyInfo.discount_type === "percentage"
        ? finalTotal * (loyaltyInfo.discount / 100)
        : loyaltyInfo.discount
      : 0;

  const displayTotal = isRedeemable
    ? Math.max(0, Math.round(finalTotal - loyaltyDiscount))
    : finalTotal;

  const [loyaltyLoading, setLoyaltyLoading] = useState(false);

  const handleLoyaltyApply = async () => {
    const serial = tempLoyalty.trim();
    if (!serial) return;
    setLoyaltyLoading(true);
    const ok = await verifyLoyalty(serial);
    setLoyaltyLoading(false);
    if (ok) setTempLoyalty("");
  };

  const discountLabel = loyaltyInfo
    ? loyaltyInfo.discount_type === "percentage"
      ? `${loyaltyInfo.discount}% off`
      : `$${loyaltyInfo.discount} off`
    : "";

  return (
    <Flex h="100%" gap="xs">
      <ScrollArea
        style={{ flex: "0 0 52%" }}
        h="100%"
        type="hover"
        scrollbars="y"
        scrollbarSize={5}
        pr="xs"
      >
        <Stack gap="xs" pb="xs">
          {items.map((item, i) => (
            <Group key={i} className={classes.card} p="xs">
              <ItemImage
                inventory={inventory}
                name={item?.name}
                h={32}
                w={32}
                fit="contain"
              />
              <Flex direction="column" gap={2}>
                <Text fz="sm" c="var(--text-main)">
                  {item.label}
                </Text>
                <Group gap="xs">
                  <Text
                    fz="sm"
                    ff="var(--font-display)"
                    c="var(--success)"
                    lh={1}
                    fw={450}
                  >
                    {`${daLang.money_symbol}${item.price.toLocaleString("en-US")}`}
                  </Text>
                  <Group gap={2}>
                    <Text fz="xs" c="var(--text-dim)" fw={450}>
                      {lang.amount}:
                    </Text>
                    <Text fz="xs" fw={450}>
                      {item.amount}
                    </Text>
                  </Group>
                </Group>
                <Group gap={2} maw={220}>
                  <Text fz="xs" fw={450}>{`${lang.ingredients}:`}</Text>
                  <Text
                    fz="xs"
                    c="var(--text-dim)"
                    fw={450}
                    style={{ wordBreak: "break-word", whiteSpace: "normal" }}
                  >
                    {item.toUse?.length && item.toUse.length > 0
                      ? item.toUse.map((n) => getIngredientLabel(n)).join(", ")
                      : "No"}
                  </Text>
                </Group>
              </Flex>
            </Group>
          ))}
        </Stack>
      </ScrollArea>
      <Flex
        direction="column"
        style={{
          flex: 1,
          borderLeft: "1px solid var(--border)",
          paddingLeft: 10,
          minWidth: 0,
        }}
        gap="xs"
      >
        <Stack gap={4} style={{ flexShrink: 0 }}>
          <Divider label={lang.total} labelPosition="center" />
          <Group justify="space-between">
            <Text fz="xs" c="var(--text-dim)" tt="uppercase" fw={600}>
              {lang.products_subheader}:
            </Text>
            <Text fz="xs" fw={600}>
              {itemsTotal}
            </Text>
          </Group>
          <Group justify="space-between">
            <Text fz="xs" c="var(--text-dim)" tt="uppercase" fw={600}>
              {lang.subtotal}:
            </Text>
            <Text fz="sm" fw={600} c="var(--cyan)" ff="var(--font-display)">
              {`${daLang.money_symbol}${total.toLocaleString("en-US")}`}
            </Text>
          </Group>
          <Group justify="space-between">
            <Text fz="xs" c="var(--text-dim)" tt="uppercase" fw={600}>
              {lang.discounts}:
            </Text>
            <Text fz="xs" fw={600}>
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
              p={4}
              style={{
                background: "rgba(88,88,184,0.1)",
                borderRadius: 4,
                border: "1px solid rgba(88,88,184,0.25)",
              }}
            >
              <Badge size="xs" color="violet" variant="light">
                {activePromo.label}
              </Badge>
              <Text fz="xs" fw={600} c="var(--accent)">
                {activePromo.type === "percentage"
                  ? `-${activePromo.discount}%`
                  : `-${daLang.money_symbol}${activePromo.discount}`}
              </Text>
            </Group>
          )}
          {isRedeemable && loyaltyInfo && (
            <Group
              justify="space-between"
              p={4}
              style={{
                background: "rgba(34,197,94,0.1)",
                borderRadius: 4,
                border: "1px solid rgba(34,197,94,0.25)",
              }}
            >
              <Badge size="xs" color="green" variant="light">
                {loyaltyInfo.promo_name}
              </Badge>
              <Text fz="xs" fw={600} c="var(--success)">
                {loyaltyInfo.discount_type === "percentage"
                  ? `-${loyaltyInfo.discount}%`
                  : `-${daLang.money_symbol}${loyaltyInfo.discount}`}
              </Text>
            </Group>
          )}
          <Divider />
          <Group justify="space-between">
            <Text fz="xs" c="var(--text-dim)" tt="uppercase" fw={700}>
              {lang.total}:
            </Text>
            <Text fz="md" fw={700} c="var(--success)" ff="var(--font-display)">
              {`${daLang.money_symbol}${displayTotal.toLocaleString("en-US")}`}
            </Text>
          </Group>
        </Stack>
        <ScrollArea
          style={{ flex: 1 }}
          type="hover"
          scrollbars="y"
          scrollbarSize={5}
        >
          <Stack gap="xs" pb="xs">
            <Divider label={lang.discounts} labelPosition="center" />
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
                    onClick={setCode}
                  >
                    <IconX style={{ height: 12, width: 12 }} stroke={1.5} />
                  </ActionIcon>
                </Group>
              </Group>
            ) : (
              <Group gap="xs">
                <TextInput
                  classNames={global}
                  size="xs"
                  placeholder={lang.discount_code}
                  maxLength={50}
                  style={{ flex: 1 }}
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
            <Divider label="Loyalty Card" labelPosition="center" />
            {loyaltySerial && loyaltyInfo ? (
              <Stack gap={4}>
                <Group justify="space-between">
                  <Group gap={4}>
                    <IconCheck size={12} color="var(--success)" />
                    <Text fz="xs" c="var(--success)" fw={600}>
                      {loyaltyInfo.promo_name}
                    </Text>
                  </Group>
                  <ActionIcon
                    size="xs"
                    variant="transparent"
                    color="red"
                    onClick={clearLoyalty}
                  >
                    <IconX style={{ height: 12, width: 12 }} stroke={1.5} />
                  </ActionIcon>
                </Group>
                <Group justify="space-between">
                  <Text fz="xs" c="var(--text-dim)" ff="monospace">
                    {loyaltySerial}
                  </Text>
                  <Badge
                    size="xs"
                    variant="light"
                    color={isRedeemable ? "green" : "gray"}
                  >
                    {isRedeemable
                      ? discountLabel
                      : `${loyaltyInfo.visits}/${loyaltyInfo.required_visits} visits`}
                  </Badge>
                </Group>
              </Stack>
            ) : (
              <Stack gap={4}>
                <Group gap="xs">
                  <TextInput
                    classNames={global}
                    size="xs"
                    placeholder="XXXX-XXXXXX"
                    maxLength={11}
                    style={{ flex: 1 }}
                    value={tempLoyalty}
                    onChange={(e) =>
                      setTempLoyalty(e.currentTarget.value.toUpperCase())
                    }
                    onKeyDown={(e) => {
                      if (e.key === "Enter") handleLoyaltyApply();
                    }}
                  />
                  <Button
                    size="xs"
                    className={classes.button}
                    loading={loyaltyLoading}
                    disabled={tempLoyalty.trim().length === 0}
                    onClick={handleLoyaltyApply}
                  >
                    {lang.apply}
                  </Button>
                </Group>
              </Stack>
            )}
            <Divider label={lang.customer_subheader} labelPosition="center" />
            <TextInput
              classNames={global}
              size="xs"
              label={lang.customer_name}
              value={customerName}
              maxLength={30}
              onChange={(e) => setCustomerName(e.currentTarget.value)}
            />
            <Select
              classNames={global}
              size="xs"
              label={lang.payment_method}
              data={accounts}
              value={account}
              onChange={(e) => {
                if (!e) return;
                setAccount(e);
              }}
              allowDeselect={false}
            />
          </Stack>
        </ScrollArea>
        <Box style={{ flexShrink: 0 }}>
          <Button
            className={classes.button}
            size="xs"
            disabled={items.length === 0}
            fullWidth
            onClick={handlePay}
          >
            {lang.complete_button}
          </Button>
        </Box>
      </Flex>
    </Flex>
  );
};
