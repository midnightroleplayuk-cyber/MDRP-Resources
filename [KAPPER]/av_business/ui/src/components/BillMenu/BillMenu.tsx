import {
  Box,
  Group,
  Text,
  TextInput,
  Accordion,
  Transition,
  ScrollArea,
  Flex,
  Button,
  Badge,
  ActionIcon,
} from "@mantine/core";
import classes from "./style.module.css";
import { useEffect, useState } from "react";
import { fetchNui, isEnvBrowser, useNuiEvent } from "../../hooks/useNuiEvents";
import { ApiBilling } from "../../API/billing";
import { BillingType } from "../../types/types";
import { Loading } from "../Loading";
import { IconSearch, IconCopy } from "@tabler/icons-react";
import { FlexColumn } from "./FlexColumn";
import { useAtomValue } from "jotai";
import { Lang } from "../../reducers/atoms";
import { Details } from "./Details";
import global from "../../global.module.css";

export const BillMenu = () => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.billing;
  const [loading, setLoading] = useState(true);
  const [loaded, setLoaded] = useState(false);
  const [bills, setBills] = useState<BillingType[]>([]);
  const [filtered, setFiltered] = useState<BillingType[]>([]);
  const [showDetails, setShowDetails] = useState<BillingType | null>(null);
  const [payments, setPayments] = useState([
    { value: "cash", label: "Cash" },
    { value: "bank", label: "Bank" },
    { value: "society", label: "Society" },
  ]);
  useNuiEvent("myBills", (data: BillingType[]) => {
    setBills(data);
    setFiltered(data);
  });
  const handleSearch = (input: string) => {
    const res = bills.filter(
      (item) =>
        (item.invoiceid
          ? item.invoiceid.toLowerCase().includes(input)
          : false) ||
        (item.title ? item.title.toLowerCase().includes(input) : false),
    );
    setFiltered(res);
  };
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getPlayerBills");
      if (resp) {
        setBills(resp.bills);
        setFiltered(resp.bills);
        setPayments(resp.payments);
      } else if (isEnvBrowser()) {
        setBills(ApiBilling);
        setFiltered(ApiBilling);
      }
      setLoaded(true);
      setTimeout(() => {
        setLoading(false);
      }, 200);
    };
    const onKeyDown = (e: KeyboardEvent) => {
      if (e.code === "Escape") {
        setLoaded(false);
        setTimeout(() => {
          fetchNui("av_business", "closeBill");
        }, 500);
      }
    };
    fetchData();
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, []);
  return (
    <Box className={classes.container}>
      <Transition
        mounted={loaded}
        transition="fade-down"
        duration={500}
        exitDuration={500}
        timingFunction="ease"
      >
        {(styles) => (
          <Box className={classes.box} p="md" style={styles}>
            {!loading ? (
              <>
                {showDetails && (
                  <Details
                    payOptions={payments}
                    close={setShowDetails}
                    data={showDetails}
                    daLang={daLang}
                  />
                )}
                <Group>
                  <Text c="var(--text-main)" fz="lg" fw={600}>
                    Player Invoices
                  </Text>
                  <TextInput
                    classNames={global}
                    ml="auto"
                    placeholder={daLang.search}
                    leftSection={<IconSearch size={16} stroke={1.5} />}
                    size="xs"
                    onChange={(e) => {
                      handleSearch(e.currentTarget.value);
                    }}
                  />
                </Group>
                {filtered.length > 0 ? (
                  <ScrollArea
                    offsetScrollbars
                    h={515}
                    type="hover"
                    scrollbars="y"
                    scrollbarSize={3}
                    mt="sm"
                  >
                    <Accordion classNames={classes} variant="contained">
                      {filtered.map((bill) => (
                        <Accordion.Item
                          value={bill.invoiceid}
                          key={bill.invoiceid}
                        >
                          <Accordion.Control>
                            <Group>
                              <Group gap="xs">
                                <Text c="var(--text-main)" fw={500}>
                                  {bill.title}
                                </Text>
                                <Badge
                                  size="sm"
                                  variant="transparent"
                                  c={
                                    bill.paid
                                      ? `var(--success)`
                                      : `var(--yellow)`
                                  }
                                >
                                  {bill.paid ? `Paid` : `Pending`}
                                </Badge>
                              </Group>
                              <Flex direction="column" ml="auto" mr="xs">
                                <Text fz="xs" c="var(--text-main)" fw={500}>
                                  {bill.issued}
                                </Text>
                                <Text fz="xs" c="var(--text-dim)">
                                  {lang.issued}
                                </Text>
                              </Flex>
                            </Group>
                          </Accordion.Control>
                          <Accordion.Panel>
                            <Group grow>
                              <Flex direction="column">
                                <Group>
                                  <Text fz="xs" c={"gray.1"} fw={500}>
                                    {bill.invoiceid}
                                  </Text>
                                  <ActionIcon
                                    size="xs"
                                    variant="transparent"
                                    onClick={() => {
                                      fetchNui(
                                        "av_laptop",
                                        "copy",
                                        bill.invoiceid,
                                      );
                                    }}
                                  >
                                    <IconCopy
                                      color="var(--cyan)"
                                      style={{ height: "14px", width: "14px" }}
                                      stroke={1.5}
                                    />
                                  </ActionIcon>
                                </Group>
                                <Text fz="xs" c="var(--text-dim)">
                                  {lang.invoiceid}
                                </Text>
                              </Flex>
                              <FlexColumn
                                value={`${bill.senderName}`}
                                label={lang.sender}
                              />
                              <FlexColumn
                                value={`${bill.description.length}`}
                                label={lang.contents}
                              />
                              <FlexColumn
                                value={`${daLang.money_symbol}${
                                  bill.amount
                                    ? bill.amount.toLocaleString("en-US")
                                    : 0
                                }`}
                                label={lang.total}
                                color="var(--success)"
                              />
                              <Button
                                className={global.button}
                                size="xs"
                                variant="filled"
                                onClick={() => {
                                  setShowDetails(bill);
                                }}
                              >
                                {lang.view_details}
                              </Button>
                            </Group>
                          </Accordion.Panel>
                        </Accordion.Item>
                      ))}
                    </Accordion>
                  </ScrollArea>
                ) : (
                  <Text c="var(--text-dim)" fz="sm" ta="center" mt="25%">
                    {lang.empty}
                  </Text>
                )}
              </>
            ) : (
              <Loading />
            )}
          </Box>
        )}
      </Transition>
    </Box>
  );
};
