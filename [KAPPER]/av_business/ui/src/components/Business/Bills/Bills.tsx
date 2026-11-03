import { useEffect, useState } from "react";
import {
  Stack,
  Text,
  Group,
  Button,
  Divider,
  Box,
  ScrollAreaAutosize,
  Flex,
} from "@mantine/core";
import {
  IconFlame,
  IconBolt,
  IconDroplet,
  IconHome,
  IconReceipt,
} from "@tabler/icons-react";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import { Loading } from "../../Loading";
import { BillsState, DEFAULT_BILLS, MockBills } from "./api";
import classes from "./style.module.css";
import global from "../../../global.module.css";

const dirtColor = (pct: number) => {
  if (pct < 40) return "#22c55e";
  if (pct < 70) return "#eab308";
  return "#ef4444";
};

const BILL_ICONS: Record<string, any> = {
  gas: IconFlame,
  electricity: IconBolt,
  water: IconDroplet,
  rent: IconHome,
  tax: IconReceipt,
};

const mergeBills = (base: BillsState, incoming: any): BillsState => ({
  ...base,
  ...incoming,
  gas: { ...base.gas, ...(incoming?.gas ?? {}) },
  electricity: { ...base.electricity, ...(incoming?.electricity ?? {}) },
  water: { ...base.water, ...(incoming?.water ?? {}) },
  rent: { ...base.rent, ...(incoming?.rent ?? {}) },
  tax: { ...base.tax, ...(incoming?.tax ?? {}) },
});

const BillCard = ({
  type,
  label,
  pending,
  daysLeft,
  overdue,
  onPay,
  paying,
  funds,
  daLang,
  lang,
  color,
}: {
  type: string;
  label: string;
  pending: number;
  daysLeft: number | null;
  overdue: boolean;
  onPay: (type: string) => void;
  paying: string | null;
  funds: number;
  daLang: any;
  lang: any;
  color?: string;
}) => {
  const Icon = BILL_ICONS[type] || IconFlame;
  const canPay =
    type === "rent"
      ? overdue && funds >= pending
      : pending > 0 && funds >= pending;
  const dueLabel =
    daysLeft !== null
      ? overdue
        ? lang.due_now
        : lang.due_in.replace("%s", daysLeft.toFixed(1))
      : lang.no_period;

  return (
    <Box
      className={`${classes.billCard} ${overdue ? classes.billCardOverdue : ""}`}
    >
      <Group justify="space-between" mb={10}>
        <Group gap="xs">
          <Icon size={15} color={color ?? "var(--text-dim)"} />
          <Text fz="sm" c="var(--text-main)" fw={500}>
            {label}
          </Text>
        </Group>
        <span className={overdue ? classes.overdueTag : classes.okTag}>
          {overdue ? lang.overdue : lang.on_time}
        </span>
      </Group>
      <Group justify="space-between" align="flex-end">
        <Stack gap={2}>
          <Text fz="xl" fw={700} c={overdue ? "#ef4444" : "var(--text-main)"}>
            {`${daLang.money_symbol}${Number(pending).toLocaleString("en-US")}`}
          </Text>
          <Text fz="xs" c="var(--text-dim)">
            {dueLabel}
          </Text>
        </Stack>
        <Button
          className={global.button}
          size="xs"
          disabled={!canPay || paying !== null}
          loading={paying === type}
          onClick={() => onPay(type)}
        >
          {lang.pay}{" "}
          {`${daLang.money_symbol}${Number(pending).toLocaleString("en-US")}`}
        </Button>
      </Group>
    </Box>
  );
};

const Bills = () => {
  const daLang: any = useAtomValue(Lang);
  const lang: any = daLang.bills;
  const [bills, setBills] = useState<BillsState | null>(null);
  const [funds, setFunds] = useState(0);
  const [paying, setPaying] = useState<string | null>(null);

  const fetchData = async () => {
    const [billsResp, bankResp] = await Promise.all([
      fetchNui("av_business", "getBills"),
      fetchNui("av_business", "getBank"),
    ]);
    if (isEnvBrowser()) setBills(MockBills);
    else if (billsResp) setBills(mergeBills(DEFAULT_BILLS, billsResp));
    if (bankResp) setFunds(bankResp.funds ?? 0);
  };

  useEffect(() => {
    fetchData();
  }, []);

  const handlePay = async (type: string) => {
    setPaying(type);
    const resp = await fetchNui("av_business", "payMaintenanceBill", type);
    if (resp?.success) {
      if (resp.funds !== undefined) setFunds(resp.funds);
      if (resp.bills)
        setBills((prev) => mergeBills(prev ?? DEFAULT_BILLS, resp.bills));
    }
    setPaying(null);
  };

  if (!bills) return <Loading />;

  const dirtPct = Math.min((bills.dirt / bills.dirtyThreshold) * 100, 100);
  const utilityBills = [
    { type: "gas", color: "#ffc078", ...bills.gas },
    { type: "electricity", color: "#ffd43b", ...bills.electricity },
    { type: "water", color: "#4dabf7", ...bills.water },
  ];

  const overdueCount = [
    ...utilityBills.filter((b) => b.overdue),
    ...(bills.rent?.enabled && bills.rent.overdue ? [bills.rent] : []),
    ...((bills.tax?.rate ?? 0) > 0 && bills.tax.overdue ? [bills.tax] : []),
  ].length;

  return (
    <Stack gap="sm" h="100%">
      <Group
        bg="var(--bg-card)"
        p="sm"
        justify="space-between"
        style={{
          borderRadius: "6px",
          border: "solid 1px var(--border)",
          flexShrink: 0,
        }}
      >
        <Flex gap="xs" direction="column">
          <Text ff="var(--font-display)" tt="uppercase" fz="xl" fw={700}>
            {lang.header}
          </Text>
          <Text mt={-15} fz="xs" c="var(--text-dim)">
            {overdueCount > 0 ? `${overdueCount} overdue` : lang.subtitle}
          </Text>
        </Flex>
        <Flex gap={2} direction="column" align="flex-end">
          <Text fz="xs" c="var(--text-dim)">
            {lang.business_funds}
          </Text>
          <Text fz="sm" fw={600} c="var(--text-main)">
            {`${daLang.money_symbol}${Number(funds).toLocaleString("en-US")}`}
          </Text>
        </Flex>
      </Group>
      <ScrollAreaAutosize
        h="100%"
        type="hover"
        scrollbars="y"
        scrollbarSize={5}
      >
        <Stack gap="md" p="xs">
          <Stack gap="xs">
            <Group justify="space-between">
              <Text fz="xs" c="var(--text-dim)" tt="uppercase" lts={0.8}>
                {lang.dirtiness}
              </Text>
              <Text fz="xs" c={dirtColor(dirtPct)} fw={600}>
                {dirtPct.toFixed(1)}%
              </Text>
            </Group>
            <Box className={classes.dirtBar}>
              <Box
                className={classes.dirtFill}
                style={{
                  width: `${dirtPct}%`,
                  backgroundColor: dirtColor(dirtPct),
                }}
              />
            </Box>
            {dirtPct >= 100 && (
              <Text fz="xs" c="#ef4444">
                {lang.dirty_blocked}
              </Text>
            )}
            <Text fz="xs" c="var(--text-dim)" opacity={0.6}>
              {lang.clean_hint.replace("%s", "20")}
            </Text>
          </Stack>
          <Divider opacity={0.1} />
          {utilityBills.length > 0 && (
            <Stack gap="sm">
              <Text fz="xs" c="var(--text-dim)" tt="uppercase" lts={0.8}>
                {lang.utility_bills}
              </Text>
              {utilityBills.map((b) => (
                <BillCard
                  key={b.type}
                  type={b.type}
                  label={b.label}
                  pending={b.pending}
                  daysLeft={b.daysLeft}
                  overdue={b.overdue}
                  onPay={handlePay}
                  paying={paying}
                  funds={funds}
                  lang={lang}
                  daLang={daLang}
                  color={b.color}
                />
              ))}
            </Stack>
          )}
          {bills.rent?.enabled && (
            <>
              <Divider opacity={0.1} />
              <Stack gap="sm">
                <Text fz="xs" c="var(--text-dim)" tt="uppercase" lts={0.8}>
                  {lang.rent}
                </Text>
                <BillCard
                  type="rent"
                  label={lang.rent}
                  pending={bills.rent.amount}
                  daysLeft={bills.rent.daysLeft}
                  overdue={bills.rent.overdue}
                  onPay={handlePay}
                  paying={paying}
                  funds={funds}
                  lang={lang}
                  daLang={daLang}
                />
              </Stack>
            </>
          )}
          {(bills.tax?.rate ?? 0) > 0 && (
            <>
              <Divider opacity={0.1} />
              <Stack gap="sm">
                <Text fz="xs" c="var(--text-dim)" tt="uppercase" lts={0.8}>
                  {lang.tax}
                </Text>
                <BillCard
                  type="tax"
                  label={`${lang.tax} (${bills.tax.rate}%)`}
                  pending={bills.tax.pending}
                  daysLeft={bills.tax.daysLeft}
                  overdue={bills.tax.overdue}
                  onPay={handlePay}
                  paying={paying}
                  funds={funds}
                  lang={lang}
                  daLang={daLang}
                />
              </Stack>
            </>
          )}
        </Stack>
      </ScrollAreaAutosize>
    </Stack>
  );
};

export default Bills;
