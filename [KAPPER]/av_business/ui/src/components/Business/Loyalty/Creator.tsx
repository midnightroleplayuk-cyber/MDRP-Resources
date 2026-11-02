import {
  Modal,
  Grid,
  Stack,
  TextInput,
  Text,
  Button,
  Select,
  NumberInput,
  Box,
  Group,
  Badge,
} from "@mantine/core";
import { useState } from "react";
import { ApiLoyaltyPromo, LoyaltyPromoType } from "./api";
import { fetchNui } from "../../../hooks/useNuiEvents";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import global from "../../../global.module.css";
import classes from "./style.module.css";

type FormType = Omit<LoyaltyPromoType, "id" | "created_at">;

const FieldHint = ({ text }: { text: string }) => (
  <Text fz="10px" c="var(--text-dim)" mt={2} lh={1.3}>
    {text}
  </Text>
);

export const LoyaltyCreator = ({
  handleClose,
}: {
  handleClose: (refresh: boolean) => void;
}) => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.loyalty;

  const [form, setForm] = useState<FormType>({ ...ApiLoyaltyPromo });
  const [cooldownMin, setCooldownMin] = useState(60);
  const [saving, setSaving] = useState(false);

  const update = (field: keyof FormType, value: any) =>
    setForm((prev) => ({ ...prev, [field]: value }));

  const handleSave = async () => {
    if (!form.name || !form.discount || !form.required_visits) return;
    setSaving(true);
    const payload = { ...form, visit_cooldown: cooldownMin * 60 };
    const resp = await fetchNui("av_business", "saveLoyaltyPromo", payload);
    setSaving(false);
    if (!resp) return;
    handleClose(true);
  };

  const discountLabel =
    form.discount_type === "amount" ? lang.amount : lang.percentage;

  const previewStyle: React.CSSProperties = form.image
    ? { backgroundImage: `url(${form.image})` }
    : {};

  return (
    <Modal
      classNames={global}
      opened={true}
      onClose={() => handleClose(false)}
      title={lang.new_card}
      centered
      withinPortal
      lockScroll={false}
      trapFocus={false}
      size="lg"
      styles={{
        title: { fontSize: "14px", fontWeight: 600 },
        content: { overflow: "hidden" },
      }}
    >
      <Stack gap="sm">
        <TextInput
          withAsterisk
          classNames={global}
          size="xs"
          label={lang.card_name}
          placeholder="VIP Coffee Card"
          value={form.name}
          onChange={(e) => update("name", e.currentTarget.value)}
        />
        <Grid gap="sm">
          <Grid.Col span={6}>
            <Select
              classNames={global}
              withAsterisk
              size="xs"
              label={lang.type}
              data={[
                { value: "percentage", label: lang.percentage },
                { value: "amount", label: lang.amount },
              ]}
              value={form.discount_type}
              allowDeselect={false}
              onChange={(v) => {
                update("discount_type", v);
                update("discount", 1);
              }}
            />
          </Grid.Col>
          <Grid.Col span={6}>
            <NumberInput
              classNames={global}
              withAsterisk
              size="xs"
              label={discountLabel}
              min={1}
              max={form.discount_type === "percentage" ? 100 : 1_000_000}
              clampBehavior="blur"
              allowDecimal={false}
              allowNegative={false}
              value={form.discount}
              leftSection={
                <Text c="dimmed" fz="xs">
                  {form.discount_type === "percentage" ? "%" : "$"}
                </Text>
              }
              onChange={(v) => update("discount", Number(v) || 1)}
            />
          </Grid.Col>
        </Grid>
        <Grid gap="sm">
          <Grid.Col span={6}>
            <NumberInput
              classNames={global}
              withAsterisk
              size="xs"
              label={lang.required_visits}
              min={1}
              max={999}
              allowDecimal={false}
              allowNegative={false}
              value={form.required_visits}
              onChange={(v) => update("required_visits", Number(v) || 1)}
            />
          </Grid.Col>
          <Grid.Col span={6}>
            <NumberInput
              classNames={global}
              size="xs"
              label={lang.cooldown_label}
              min={1}
              max={10080}
              allowDecimal={false}
              allowNegative={false}
              allowLeadingZeros={false}
              value={cooldownMin}
              onChange={(v) => setCooldownMin(Number(v) || 60)}
            />
            <FieldHint text={lang.cooldown_desc} />
          </Grid.Col>
        </Grid>
        <Box>
          <NumberInput
            classNames={global}
            size="xs"
            label={lang.max_prints}
            min={0}
            max={999999}
            allowDecimal={false}
            allowNegative={false}
            value={form.max_prints ?? 0}
            placeholder={lang.unlimited}
            onChange={(v) =>
              update("max_prints", Number(v) === 0 ? null : Number(v))
            }
          />
          <FieldHint text={lang.max_prints_desc} />
        </Box>
        <TextInput
          classNames={global}
          size="xs"
          label={lang.image_url}
          placeholder={lang.image_placeholder}
          value={form.image ?? ""}
          onChange={(e) =>
            update("image", e.currentTarget.value.trim() || null)
          }
        />
        <Box>
          <Text fz="xs" c="var(--text-dim)" mb={4}>
            {lang.preview}
          </Text>
          <Box className={classes.cardPreview} style={previewStyle}>
            <Box className={classes.cardOverlay}>
              <Group justify="space-between" align="flex-end">
                <Text fz="sm" fw={700} c="white" lts={0.5}>
                  {form.name || lang.card_name}
                </Text>
                <Badge
                  color={form.discount_type === "amount" ? "green" : "cyan"}
                  size="sm"
                  variant="filled"
                >
                  {form.discount_type === "amount"
                    ? `$${form.discount} off`
                    : `${form.discount}% off`}
                </Badge>
              </Group>
              <Text fz="xs" c="rgba(255,255,255,0.6)" mt={2}>
                {form.required_visits} {lang.visits} required
              </Text>
            </Box>
          </Box>
        </Box>
      </Stack>
      <Button
        mt="sm"
        fullWidth
        className={global.button}
        size="xs"
        loading={saving}
        disabled={!form.name || !form.discount || !form.required_visits}
        onClick={handleSave}
      >
        {lang.save}
      </Button>
    </Modal>
  );
};
