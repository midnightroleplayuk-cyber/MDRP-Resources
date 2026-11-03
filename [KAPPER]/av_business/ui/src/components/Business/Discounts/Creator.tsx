import {
  Modal,
  Grid,
  Stack,
  TextInput,
  Text,
  ActionIcon,
  Button,
  Select,
  NumberInput,
} from "@mantine/core";
import { DatePickerInput, DateTimePicker } from "@mantine/dates";
import { useState } from "react";
import { ApiCoupon, ApiPromo, DiscountType, PromoType } from "./api";
import { IconWand } from "@tabler/icons-react";
import { generateCode, toTimestamp, useToday } from "./utils";
import global from "../../../global.module.css";
import { fetchNui } from "../../../hooks/useNuiEvents";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";

export const Creator = ({
  handleCreator,
  mode = "coupon",
}: {
  handleCreator: (added: boolean) => void;
  mode?: "coupon" | "promo";
}) => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.discounts;
  const [coupon, setCoupon] = useState<DiscountType>(ApiCoupon);
  const [promo, setPromo] = useState<PromoType>({
    ...ApiPromo,
    starts_at: Math.floor(Date.now() / 1000),
  });

  const updateCoupon = (field: keyof DiscountType, value: any) =>
    setCoupon((prev) => ({ ...prev, [field]: value }));

  const updatePromo = (field: keyof PromoType, value: any) =>
    setPromo((prev) => ({ ...prev, [field]: value }));

  const handleSave = async () => {
    if (mode === "promo") {
      if (!promo.label || !promo.starts_at) return;
      const resp = await fetchNui("av_business", "savePromo", promo);
      if (!resp) return;
    } else {
      const resp = await fetchNui("av_business", "saveCoupon", coupon);
      if (!resp) return;
    }
    handleCreator(true);
  };

  const isPromo = mode === "promo";
  const title = isPromo ? (lang.new_promo ?? "New Promo") : lang.modal_title;

  return (
    <Modal
      classNames={global}
      opened={true}
      onClose={() => handleCreator(false)}
      title={title}
      centered
      withinPortal
      lockScroll={false}
      trapFocus={false}
      styles={{
        title: { fontSize: "14px", fontWeight: 600 },
        content: { overflow: "hidden" },
      }}
    >
      {isPromo ? (
        <Grid>
          <Grid.Col span={6}>
            <Stack gap="xs">
              <TextInput
                withAsterisk
                classNames={global}
                size="xs"
                label={lang.label ?? "Label"}
                placeholder="Happy Hour"
                value={promo.label}
                onChange={(e) => updatePromo("label", e.currentTarget.value)}
              />
              <Select
                classNames={global}
                withAsterisk
                size="xs"
                label={lang.type}
                data={[
                  { value: "percentage", label: lang.percentage },
                  { value: "amount", label: lang.amount },
                ]}
                value={promo.type}
                allowDeselect={false}
                onChange={(e) => {
                  updatePromo("type", e);
                  updatePromo("discount", 1);
                }}
              />
              <NumberInput
                classNames={global}
                withAsterisk
                size="xs"
                label={promo.type === "amount" ? lang.amount : lang.percentage}
                min={1}
                max={promo.type === "percentage" ? 100 : 1000000}
                clampBehavior="blur"
                value={promo.discount}
                allowDecimal={false}
                allowNegative={false}
                leftSection={
                  <Text c="dimmed" fz="xs">
                    {promo.type === "percentage" ? "%" : "$"}
                  </Text>
                }
                onChange={(val) => updatePromo("discount", Number(val) || 1)}
              />
            </Stack>
          </Grid.Col>
          <Grid.Col span={6}>
            <Stack gap="xs">
              <TextInput
                classNames={global}
                size="xs"
                label={lang.description}
                placeholder="Summer sale..."
                value={promo.description}
                maxLength={100}
                onChange={(e) =>
                  updatePromo("description", e.currentTarget.value)
                }
              />
              <DateTimePicker
                classNames={global}
                size="xs"
                withAsterisk
                label={lang.starts_at ?? "Starts at"}
                placeholder="Now"
                valueFormat="DD MMM YYYY HH:mm"
                onChange={(d) =>
                  updatePromo(
                    "starts_at",
                    d ? Math.floor(new Date(d as any).getTime() / 1000) : 0,
                  )
                }
              />
              <DateTimePicker
                classNames={global}
                size="xs"
                label={lang.ends_at ?? "Ends at"}
                placeholder="Never"
                valueFormat="DD MMM YYYY HH:mm"
                clearable
                onChange={(d) =>
                  updatePromo(
                    "ends_at",
                    d ? Math.floor(new Date(d as any).getTime() / 1000) : null,
                  )
                }
              />
            </Stack>
          </Grid.Col>
        </Grid>
      ) : (
        <Grid>
          <Grid.Col span={6}>
            <Stack gap="xs">
              <TextInput
                withAsterisk
                classNames={global}
                size="xs"
                label={lang.code}
                placeholder={lang.code}
                value={coupon.code}
                onChange={(e) =>
                  updateCoupon("code", e.currentTarget.value.toUpperCase())
                }
                rightSection={
                  <ActionIcon
                    size="xs"
                    variant="transparent"
                    color="dimmed"
                    onClick={() => updateCoupon("code", generateCode())}
                  >
                    <IconWand style={{ height: 14, width: 14 }} stroke={1.5} />
                  </ActionIcon>
                }
              />
              <NumberInput
                classNames={global}
                size="xs"
                label={lang.limit}
                min={0}
                max={100000}
                allowDecimal={false}
                allowLeadingZeros={false}
                allowNegative={false}
                w={200}
                onChange={(e) =>
                  updateCoupon("limit", e === 0 ? false : Number(e))
                }
              />
              <Select
                classNames={global}
                withAsterisk
                size="xs"
                label={lang.type}
                data={[
                  { value: "percentage", label: lang.percentage },
                  { value: "amount", label: lang.amount },
                ]}
                value={coupon.type}
                allowDeselect={false}
                onChange={(e) => {
                  updateCoupon("type", e);
                  updateCoupon("discount", 1);
                }}
              />
            </Stack>
          </Grid.Col>
          <Grid.Col span={6}>
            <Stack gap="xs">
              <TextInput
                classNames={global}
                size="xs"
                label={lang.description}
                placeholder="My awesome discount"
                value={coupon.description}
                maxLength={50}
                onChange={(e) =>
                  updateCoupon("description", e.currentTarget.value)
                }
              />
              <DatePickerInput
                classNames={global}
                size="xs"
                label={lang.expires}
                placeholder="Never"
                minDate={useToday()}
                clearable
                w={200}
                onChange={(e) => {
                  if (!e) {
                    updateCoupon("expires", false);
                    return;
                  }
                  updateCoupon("expires", toTimestamp(e));
                }}
              />
              <NumberInput
                classNames={global}
                withAsterisk
                size="xs"
                label={coupon.type === "amount" ? lang.amount : lang.percentage}
                min={1}
                max={coupon.type === "percentage" ? 100 : 1000000}
                clampBehavior="blur"
                value={coupon.discount}
                allowDecimal={false}
                allowNegative={false}
                leftSection={
                  <Text c="dimmed" fz="xs">
                    {coupon.type === "percentage" ? "%" : "$"}
                  </Text>
                }
                onChange={(val) => {
                  const n = Number(val);
                  updateCoupon("discount", isNaN(n) || n < 1 ? 1 : n);
                }}
              />
            </Stack>
          </Grid.Col>
        </Grid>
      )}
      <Button
        mt="sm"
        fullWidth
        className={global.button}
        size="xs"
        disabled={
          isPromo
            ? promo.label.length === 0 || promo.starts_at === 0
            : coupon.code.length === 0
        }
        onClick={handleSave}
      >
        {lang.generate_button}
      </Button>
    </Modal>
  );
};
