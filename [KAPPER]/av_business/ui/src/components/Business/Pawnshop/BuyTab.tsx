import { ItemImage } from "../../ItemImage/ItemImage";
import { useEffect, useState } from "react";
import {
  Box,
  Group,
  Text,
  Paper,
  Badge,
  Stack,
  Tooltip,
  Button,
  NumberInput,
  ScrollArea,
  ThemeIcon,
  ActionIcon,
} from "@mantine/core";
import {
  IconInbox,
  IconCheck,
  IconAlertTriangle,
  IconReceipt,
  IconUserFilled,
} from "@tabler/icons-react";
import { ApiPawnshopItems, PawnItem } from "../../../API/pawnshop";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import classes from "./style.module.css";
import { Loading } from "../../Loading";

interface Properties {
  trayId: string;
  updateCashierFunds: (funds: number) => void;
  cashierFunds: number;
  daLang: any;
  lang: any;
}

export const BuyTab = ({
  trayId,
  cashierFunds,
  updateCashierFunds,
  daLang,
  lang,
}: Properties) => {
  const [loaded, setLoaded] = useState(false);
  const [items, setItems] = useState<PawnItem[]>([]);
  const [offers, setOffers] = useState<Record<string, number | string>>({});
  const [targetId, setTargetId] = useState<string | number>("");
  const [inventory, setInventory] = useState("");

  const handleOfferChange = (itemName: string, value: number | string) => {
    setOffers((prev) => ({ ...prev, [itemName]: value }));
  };

  const handleClosest = async () => {
    const resp = await fetchNui("av_laptop", "closestPlayer");
    if (resp) {
      setTargetId(resp);
    }
  };

  const totalOffer = Object.values(offers).reduce(
    (acc: number, curr) => acc + (Number(curr) || 0),
    0,
  );

  const canAfford = totalOffer <= cashierFunds;
  const isOfferValid = totalOffer > 0 && canAfford && targetId !== "";

  const handleSubmitOffer = async () => {
    if (!isOfferValid) return;
    if (!loaded) return;
    setLoaded(false);
    const resp = await fetchNui("av_business", "submitPawnOffer", {
      offers,
      targetId,
      trayId,
    });
    setTimeout(() => {
      setLoaded(true);
    }, 250);
    if (!resp) return;
    setItems([]);
    setOffers({});
    updateCashierFunds(resp);
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getPawnTrayItems", trayId);
      if (resp) {
        setItems(resp.items);
        setInventory(resp.inventory);
      } else {
        if (isEnvBrowser()) {
          setItems(ApiPawnshopItems);
        }
      }
      setLoaded(true);
    };
    fetchData();
  }, [trayId]);

  return (
    <>
      <ScrollArea
        pl="md"
        pr="md"
        mt="md"
        h={400}
        scrollbarSize={6}
        offsetScrollbars
      >
        {!loaded ? (
          <Loading />
        ) : (
          <Stack gap="xs">
            {items.map((item) => {
              const currentOffer = Number(offers[item.name]) || 0;
              const isUnderMin =
                currentOffer > 0 && currentOffer < item.buyPrice * item.amount;
              const isOverMax = currentOffer > item.sellPrice * item.amount;

              let inputStateClass = classes.inputValid;
              if (isOverMax) inputStateClass = classes.inputOver;
              else if (isUnderMin) inputStateClass = classes.inputUnder;
              return (
                <Paper key={item.name} className={classes.itemCard}>
                  <Group wrap="nowrap" align="center" justify="space-between">
                    <Group wrap="nowrap" style={{ flex: 1 }}>
                      <Box className={classes.itemImage}>
                        <ItemImage
                          inventory={inventory}
                          name={item.name}
                          image={item.image}
                          w={40}
                          h={40}
                          fit="contain"
                        />
                      </Box>
                      <Box>
                        <Text
                          size="md"
                          fw={700}
                          c="var(--text-main)"
                          ff="var(--font-display)"
                          tt="uppercase"
                        >
                          {item.label}
                        </Text>
                        <Group gap={6} mt={4}>
                          <Badge size="sm" variant="light" color="gray">
                            {lang.qty} {item.amount}
                          </Badge>
                          <Text size="xs" c="var(--text-dim)" fw={500} mt={3}>
                            {`${daLang.money_symbol}${item.buyPrice.toLocaleString("en-US")} – ${daLang.money_symbol}${item.sellPrice.toLocaleString("en-US")} ${lang.ea}`}
                          </Text>
                        </Group>
                      </Box>
                    </Group>
                    <Box w={200}>
                      <NumberInput
                        label={lang.yourOffer}
                        placeholder={`${lang.max} $${item.sellPrice * item.amount}`}
                        prefix="$"
                        min={0}
                        max={99999999}
                        allowDecimal={false}
                        allowNegative={false}
                        value={offers[item.name] || ""}
                        onChange={(val) => handleOfferChange(item.name, val)}
                        classNames={{
                          input: inputStateClass,
                          label: classes.inputLabel,
                        }}
                        rightSection={
                          currentOffer > 0 && !isOverMax && !isUnderMin ? (
                            <IconCheck size={16} color="var(--success)" />
                          ) : isOverMax || isUnderMin ? (
                            <Tooltip
                              bg="var(--tooltip)"
                              c="var(--text-main)"
                              label={
                                isOverMax
                                  ? lang.offerOverMax
                                  : lang.offerUnderMin
                              }
                              withArrow
                            >
                              <IconAlertTriangle
                                size={16}
                                color={
                                  isOverMax ? "var(--danger)" : "var(--yellow)"
                                }
                              />
                            </Tooltip>
                          ) : null
                        }
                      />
                    </Box>
                  </Group>
                </Paper>
              );
            })}
          </Stack>
        )}
        {items.length === 0 && (
          <Stack align="center" justify="center" py="xl">
            <Text size="xs" c="var(--text-dim)" fw={500}>
              {lang.emptyTray}
            </Text>
          </Stack>
        )}
      </ScrollArea>

      <Group justify="space-between" align="center" className={classes.footer}>
        <Group gap="md">
          <ThemeIcon size="xl" variant="light" color="var(--accent)">
            <IconReceipt size={24} />
          </ThemeIcon>
          <Box>
            <Text size="xs" c="var(--text-dim)" fw={700} tt="uppercase">
              {lang.totalOffer}
            </Text>
            <Text
              size="xl"
              fw={800}
              c={canAfford ? "var(--accent)" : "var(--danger)"}
              lh={1}
              ff="var(--font-display)"
            >
              ${totalOffer.toLocaleString()}
            </Text>
            {!canAfford && (
              <Text size="10px" c="var(--danger)" fw={600} mt={4}>
                {lang.insufficientFunds}
              </Text>
            )}
          </Box>
        </Group>
        <Group gap="sm" align="flex-end">
          <NumberInput
            placeholder={lang.customerId}
            leftSection={
              <ActionIcon
                size="xs"
                variant="transparent"
                color="var(--text-dim)"
                opacity={0.9}
                onClick={handleClosest}
              >
                <IconUserFilled
                  style={{ height: "14px", width: "14px" }}
                  stroke={1.5}
                />
              </ActionIcon>
            }
            mb={3}
            min={1}
            max={999999}
            allowDecimal={false}
            allowNegative={false}
            value={targetId}
            w={140}
            onChange={setTargetId}
            classNames={{
              input: classes.inputValid,
              label: classes.inputLabel,
            }}
          />
          <Button
            size="md"
            disabled={!isOfferValid}
            onClick={handleSubmitOffer}
            className={`${classes.submitBtn} ${isOfferValid ? classes.submitBtnValid : classes.submitBtnInvalid}`}
          >
            {lang.submitOffer}
          </Button>
        </Group>
      </Group>
    </>
  );
};
