import { useEffect, useState } from "react";
import {
  Box,
  Paper,
  Group,
  Text,
  ThemeIcon,
  ActionIcon,
  Tooltip,
  Transition,
} from "@mantine/core";
import {
  IconInbox,
  IconCoin,
  IconArrowDown,
  IconArrowUp,
  IconLock,
  IconLockOpen,
} from "@tabler/icons-react";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import {
  fetchNui,
  isEnvBrowser,
  useNuiEvent,
} from "../../../hooks/useNuiEvents";
import { BuyTab } from "./BuyTab";
import { SellTab } from "./SellTab";
import classes from "./style.module.css";

type TabType = "buy" | "sell";

export const PawnshopCashier = () => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.pawnshop_cashier;
  const [loaded, setLoaded] = useState(false);
  const [trayId, setTrayId] = useState("");
  const [cashierFunds, setCashierFunds] = useState(0);
  const [activeTab, setActiveTab] = useState<TabType>("buy");
  const [locked, setLocked] = useState(false);

  const handleLock = async () => {
    const state = await fetchNui("av_business", "togglePawnTrayLock", trayId);
    setLocked(state);
  };

  useNuiEvent(
    "openPawnCashier",
    (data: { id: string; funds: number; locked?: boolean }) => {
      setTrayId(data.id);
      setCashierFunds(data.funds);
      setLocked(data.locked || false);
      setLoaded(true);
    },
  );

  const onKeyDown = (e: KeyboardEvent) => {
    if (e.code === "Escape") {
      setLoaded(false);
      setTimeout(() => {
        fetchNui("av_business", "closePawnCashier");
      }, 250);
    }
  };

  useEffect(() => {
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, []);

  return (
    <Transition
      mounted={loaded}
      transition="fade-down"
      duration={500}
      exitDuration={500}
      timingFunction="ease"
    >
      {(styles) => (
        <Box className={classes.wrapper} style={styles}>
          <Paper className={classes.box}>
            <Group justify="space-between" className={classes.header}>
              <Group gap="sm">
                <ThemeIcon size="lg" variant="light" color="var(--accent)">
                  <IconInbox size={20} />
                </ThemeIcon>
                <Box>
                  <Text
                    ff="var(--font-display)"
                    tt="uppercase"
                    fz="xl"
                    fw={700}
                    c="var(--text-main)"
                  >
                    {lang.inspectionTrayTitle}
                  </Text>
                  <Text mt={-4} fz="xs" c="var(--text-dim)">
                    {lang.inspectionTrayDesc}
                  </Text>
                </Box>
              </Group>
              <Group gap="sm">
                <Box className={classes.tabGroup}>
                  <button
                    className={`${classes.tabBtn} ${activeTab === "buy" ? classes.tabBtnActive : ""}`}
                    onClick={() => setActiveTab("buy")}
                  >
                    <IconArrowDown size={13} />
                    {lang.tabBuy ?? "Buy"}
                  </button>
                  <button
                    className={`${classes.tabBtn} ${activeTab === "sell" ? classes.tabBtnActiveSell : ""}`}
                    onClick={() => setActiveTab("sell")}
                  >
                    <IconArrowUp size={13} />
                    {lang.tabSell ?? "Sell"}
                  </button>
                </Box>
                <Tooltip
                  label={locked ? lang.unlockStash : lang.lockStash}
                  withArrow
                  bg="var(--tooltip)"
                  c="var(--text-main)"
                >
                  <ActionIcon
                    color="var(--text-dim)"
                    variant="light"
                    onClick={handleLock}
                  >
                    {locked ? (
                      <IconLock size={18} />
                    ) : (
                      <IconLockOpen size={18} />
                    )}
                  </ActionIcon>
                </Tooltip>
                <Paper className={classes.fundsBox}>
                  <Group gap="sm">
                    <IconCoin size={18} color="var(--success)" />
                    <Box>
                      <Text
                        size="10px"
                        c="var(--text-dim)"
                        fw={700}
                        tt="uppercase"
                      >
                        {lang.cashierFunds}
                      </Text>
                      <Text
                        size="md"
                        fw={800}
                        c="var(--success)"
                        lh={1}
                        ff="var(--font-display)"
                      >
                        {`${daLang.money_symbol}${cashierFunds.toLocaleString()}`}
                      </Text>
                    </Box>
                  </Group>
                </Paper>
              </Group>
            </Group>

            {activeTab === "buy" ? (
              <BuyTab
                trayId={trayId}
                cashierFunds={cashierFunds}
                daLang={daLang}
                lang={lang}
                updateCashierFunds={setCashierFunds}
              />
            ) : (
              <SellTab trayId={trayId} daLang={daLang} lang={lang} />
            )}
          </Paper>
        </Box>
      )}
    </Transition>
  );
};
