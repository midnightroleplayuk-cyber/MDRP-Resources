import {
  Box,
  Text,
  Group,
  Button,
  Progress,
  Badge,
  Image,
  Stack,
  Tooltip,
  ActionIcon,
} from "@mantine/core";
import { useState, useEffect } from "react";
import { useAtomValue } from "jotai";
import { Lang } from "../../reducers/atoms";
import { Flip } from "@gfazioli/mantine-flip";
import {
  IconCreditCard,
  IconCopy,
  IconCheck,
  IconArrowLeft,
  IconInfoCircle,
} from "@tabler/icons-react";
import { fetchNui } from "../../hooks/useNuiEvents";
import global from "../../global.module.css";
import classes from "./style.module.css";

interface LoyaltyCardData {
  serial: string;
  promo_name: string;
  image: string | null;
  visits: number;
  required_visits: number;
  redeemed: number;
  discount: number;
  discount_type: "percentage" | "amount";
  job: string;
}

interface Props {
  data: LoyaltyCardData;
}

export const LoyaltyCardOverlay = ({ data }: Props) => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.loyalty_card ?? {};
  const [flipped, setFlipped] = useState(false);
  const [copied, setCopied] = useState(false);
  const progress = Math.min((data.visits / data.required_visits) * 100, 100);
  const isRedeemed = !!data.redeemed || data.visits >= data.required_visits;
  const remaining = Math.max(0, data.required_visits - data.visits);

  const discountLabel =
    data.discount_type === "percentage"
      ? `${data.discount}% off`
      : `$${data.discount} off`;

  const handleClose = () => fetchNui("av_business", "closeLoyaltyCard");

  const handleCopy = (e: React.MouseEvent) => {
    e.stopPropagation();
    fetchNui("av_laptop", "copy", data.serial);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  useEffect(() => {
    const onKeyDown = (e: KeyboardEvent) => {
      if (e.code === "Escape") {
        e.stopImmediatePropagation();
        if (flipped) setFlipped(false);
        else handleClose();
      }
    };
    window.addEventListener("keydown", onKeyDown, true);
    return () => window.removeEventListener("keydown", onKeyDown, true);
  }, [flipped]);

  return (
    <Box className={classes.overlay}>
      <Flip
        w="clamp(400px, 27vw, 560px)"
        h={300}
        flipped={flipped}
        easing="spring"
        duration={1}
      >
        <Flip.Front>
          <Box
            className={`${classes.card} ${classes.front}`}
            onClick={() => setFlipped(true)}
          >
            {data.image ? (
              <Image
                src={data.image}
                className={classes.frontImage}
                fit="cover"
              />
            ) : (
              <Box className={classes.frontFallback}>
                <IconCreditCard
                  size={72}
                  color="rgba(255,255,255,0.35)"
                  stroke={1}
                />
              </Box>
            )}
            <Box className={classes.frontGradient} />
            <Box className={classes.flipHint}>
              <Group gap={5} align="center">
                <IconInfoCircle size={11} color="rgba(255,255,255,0.65)" />
                <Text fz="10px" c="rgba(255,255,255,0.65)" lh={1}>
                  {lang.tap_for_info ?? "Tap for info"}
                </Text>
              </Group>
            </Box>
            <Box className={classes.frontMeta}>
              <Group justify="space-between" align="flex-end">
                <Box>
                  <Text
                    fz="xs"
                    c="rgba(255,255,255,0.5)"
                    tt="uppercase"
                    fw={500}
                    lts={0.8}
                    mb={2}
                  >
                    {data.job}
                  </Text>
                  <Text
                    fz="xl"
                    fw={700}
                    c="white"
                    ff="var(--font-display)"
                    tt="uppercase"
                    lts={0.5}
                    lh={1}
                  >
                    {data.promo_name}
                  </Text>
                </Box>
                <Badge
                  size="md"
                  variant="filled"
                  color={isRedeemed ? "green" : "indigo"}
                  radius="sm"
                  style={{ fontWeight: 400 }}
                >
                  {isRedeemed ? (lang.redeemed ?? "Redeemed") : discountLabel}
                </Badge>
              </Group>
            </Box>
          </Box>
        </Flip.Front>
        <Flip.Back>
          <Box className={`${classes.card} ${classes.back}`}>
            <Stack gap="md" p="lg" h="100%" justify="space-between">
              <Group justify="space-between" align="center">
                <ActionIcon
                  variant="subtle"
                  color="gray"
                  size="sm"
                  onClick={() => setFlipped(false)}
                >
                  <IconArrowLeft size={15} />
                </ActionIcon>
                <Text
                  fz="sm"
                  fw={600}
                  c="var(--text-main)"
                  ff="var(--font-display)"
                  tt="uppercase"
                  lts={0.5}
                >
                  {data.promo_name}
                </Text>
                <Badge
                  size="sm"
                  variant="light"
                  color={isRedeemed ? "green" : "indigo"}
                  style={{ fontWeight: 400 }}
                >
                  {isRedeemed ? (lang.redeemed ?? "Redeemed") : discountLabel}
                </Badge>
              </Group>
              <Box>
                <Group justify="space-between" mb={6}>
                  <Text
                    fz="sm"
                    c="var(--text-dim)"
                    tt="uppercase"
                    fw={600}
                    lts={0.5}
                  >
                    {lang.progress ?? "Progress"}
                  </Text>
                  <Text
                    fz="sm"
                    fw={700}
                    c={isRedeemed ? "var(--success)" : "var(--accent-hover)"}
                  >
                    {data.visits} / {data.required_visits}{" "}
                    {lang.visits ?? "visits"}
                  </Text>
                </Group>
                <Progress
                  value={progress}
                  color={isRedeemed ? "green" : "indigo"}
                  radius="xl"
                  size="md"
                  className={classes.progressTrack}
                />
                {!isRedeemed && (
                  <Text fz="xs" c="var(--text-dim)" mt={6}>
                    {remaining}{" "}
                    {remaining !== 1
                      ? (lang.visits ?? "visits")
                      : (lang.visit ?? "visit")}{" "}
                    {lang.to_unlock ?? "to unlock"} {discountLabel}
                  </Text>
                )}
              </Box>
              <Group
                p="xs"
                className={classes.serialRow}
                justify="space-between"
              >
                <Text
                  fz="sm"
                  c="var(--text-dim)"
                  tt="uppercase"
                  fw={600}
                  lts={0.5}
                >
                  {lang.serial ?? "Serial"}
                </Text>
                <Group gap={6}>
                  <Text
                    fz="sm"
                    ff="monospace"
                    c="var(--text-main)"
                    fw={500}
                    style={{ userSelect: "text", cursor: "text" }}
                  >
                    {data.serial}
                  </Text>
                  <Tooltip
                    label={
                      copied
                        ? (lang.copied ?? "Copied!")
                        : (lang.copy ?? "Copy")
                    }
                    fz="xs"
                    bg="var(--tooltip)"
                    c="var(--text-main)"
                    withArrow
                  >
                    <ActionIcon
                      size="xs"
                      variant="transparent"
                      color={copied ? "green" : "gray"}
                      onClick={handleCopy}
                      style={{ cursor: "pointer" }}
                    >
                      {copied ? (
                        <IconCheck
                          style={{ height: 12, width: 12 }}
                          stroke={2}
                        />
                      ) : (
                        <IconCopy
                          style={{ height: 12, width: 12 }}
                          stroke={1.5}
                        />
                      )}
                    </ActionIcon>
                  </Tooltip>
                </Group>
              </Group>
              <Button
                fullWidth
                size="sm"
                className={global.button}
                onClick={handleClose}
              >
                {lang.close ?? "Close"}
              </Button>
            </Stack>
          </Box>
        </Flip.Back>
      </Flip>
    </Box>
  );
};
