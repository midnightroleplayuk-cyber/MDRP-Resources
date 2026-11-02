import { useEffect, useState } from "react";
import {
  Box,
  Text,
  Group,
  Stack,
  SimpleGrid,
  Card,
  Button,
  Table,
  Grid,
  ScrollAreaAutosize,
  List,
  Alert,
  ScrollArea,
} from "@mantine/core";
import {
  IconAlertTriangle,
  IconCircleCheck,
  IconScissors,
  IconLock,
  IconReceipt,
  IconPackage,
  IconShieldCheck,
  IconAlertOctagon,
  IconRotateClockwise,
} from "@tabler/icons-react";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { ApiLaundry, TransactionType } from "./api";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import { isWide } from "../../../hooks/wide";
import classes from "./style.module.css";

const Laundry = () => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang?.laundry;
  const [logs, setLogs] = useState<TransactionType[]>([]);
  const [cleaned, setCleaned] = useState(0);
  const [stash, setStash] = useState(0);
  const [fee, setFee] = useState(0);
  const [max, setMax] = useState(0);
  const wide = isWide();

  const instructionSteps = lang?.instructions || [
    "Locate the physical vault in your business zone and insert your dirty cash.",
    "Once the stash is ready, press the button below to link it with your business.",
    "Your legitimate sales will now act as a cover, 'mixing' the stashed funds into clean profit automatically with every purchase.",
  ];

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getLaundry");
      if (resp) {
        setCleaned(resp.cleaned);
        setStash(resp.stash);
        setFee(resp.fee);
        setMax(resp.max);
        setLogs(resp.logs);
      } else {
        if (isEnvBrowser()) {
          setCleaned(5000);
          setStash(100000);
          setFee(10);
          setMax(100000);
          setLogs(ApiLaundry);
        }
      }
    };
    fetchData();
  }, []);

  return (
    <ScrollAreaAutosize
      h={`calc(100% - 15px)`}
      type="hover"
      scrollbars="y"
      scrollbarSize={5}
    >
      <Stack gap="md" className={classes.container}>
        <Box>
          <Text fz="xl" fw={700} c="var(--text-main)" className={classes.title}>
            {lang?.title || "Financial Mixing Operations"}
          </Text>
          <Text fz="xs" fw={500} c="var(--text-dim)">
            {lang?.subtitle ||
              "Deposit dirty cash into the stash. Your legitimate sales will automatically wash it over time."}
          </Text>
        </Box>
        <SimpleGrid cols={3} spacing="md">
          <Card radius="md" p="lg" className={classes.kpiCard}>
            <IconPackage className={classes.kpiIconBg} />
            <Group gap={6} mb="xs">
              <IconAlertTriangle size={14} color="var(--yellow)" />
              <Text fz="sm" fw={600} c="var(--text-dim)">
                {lang?.dirty_stash || "Dirty Stash (Waiting)"}
              </Text>
            </Group>
            <Text fz="xl" fw={700} c="var(--yellow)">
              {`${daLang?.money_symbol || "$"}${stash.toLocaleString("en-US")}`}
            </Text>
          </Card>
          <Card radius="md" p="lg" className={classes.kpiCard}>
            <IconShieldCheck className={classes.kpiIconBg} />
            <Group gap={6} mb="xs">
              <IconCircleCheck size={14} color="var(--cyan)" />
              <Text fz="sm" fw={600} c="var(--text-dim)">
                {lang?.cleaned_shift || "Cleaned This Shift"}
              </Text>
            </Group>
            <Text fz="xl" fw={700} c="var(--text-main)">
              {`${daLang?.money_symbol || "$"}${cleaned.toLocaleString("en-US")} / `}
              <a style={{ color: "var(--cyan)" }}>
                {`${daLang.money_symbol}${max.toLocaleString("en-US")}`}
              </a>
            </Text>
          </Card>

          <Card radius="md" p="lg" className={classes.kpiCard}>
            <IconScissors className={classes.kpiIconBg} />
            <Group gap={6} mb="xs">
              <IconScissors size={14} color="var(--danger)" />
              <Text fz="sm" fw={600} c="var(--text-dim)">
                {lang?.system_fee || "System Fee Cut"}
              </Text>
            </Group>
            <Text fz="xl" fw={700} c="var(--danger)">
              {`${fee}%`}
            </Text>
          </Card>
        </SimpleGrid>
        <Grid gap="md">
          <Grid.Col span={4}>
            <Card radius="md" p="xl" className={classes.panelCardFull}>
              <Group mb="md" align="center" gap={8}>
                <IconLock size={18} color="var(--text-dim)" />
                <Text fz="md" fw={600} c="var(--text-main)">
                  {lang?.safe_control || "The Safe Control"}
                </Text>
              </Group>
              <Stack gap="md">
                <List
                  type="unordered"
                  size="xs"
                  spacing="xs"
                  styles={{
                    item: {
                      "&::marker": {
                        color: "#9f7aea",
                        fontWeight: 700,
                      },
                    },
                  }}
                >
                  {instructionSteps.map((step: string, index: number) => (
                    <List.Item key={index} fz="xs" c="var(--text-dim)" fw={500}>
                      {step}
                    </List.Item>
                  ))}
                </List>
                {wide && (
                  <Alert
                    variant="light"
                    radius="md"
                    color="red.4"
                    title={
                      <Group gap="xs">
                        <IconAlertOctagon size={14} color="#e03131" />{" "}
                        <Text fw={600} fz="sm" lts={0.5}>
                          {lang?.attention || "ATTENTION"}
                        </Text>
                      </Group>
                    }
                  >
                    <Text fz="xs" c="var(--text-dim)">
                      {lang?.attention_msg ||
                        "Mixing is a one-way street. Your stashed cash is now tied to your sales and cannot be recovered until it's fully processed."}
                    </Text>
                  </Alert>
                )}
                <Box
                  style={{
                    display: "flex",
                    justifyContent: "center",
                    width: "100%",
                  }}
                >
                  <Button
                    variant="outline"
                    radius="md"
                    size="sm"
                    fullWidth
                    style={{
                      borderColor: "#e2951e",
                      color: "#e2951e",
                      backgroundColor: "rgba(226, 149, 30, 0.025)",
                      fontWeight: 700,
                      fontSize: "sm",
                    }}
                    leftSection={
                      <IconRotateClockwise size={16} color="#e2951e" />
                    }
                    onClick={() => {
                      fetchNui("av_business", "processDirty");
                    }}
                  >
                    {lang?.mix_funds || "Mix Funds"}
                  </Button>
                </Box>
              </Stack>
            </Card>
          </Grid.Col>
          <Grid.Col span="auto">
            <Card
              radius="md"
              p="xl"
              className={classes.panelCardFull}
              style={{ flex: 1 }}
            >
              <Group justify="space-between" mb="lg">
                <Group gap={8}>
                  <IconReceipt size={18} color="var(--text-dim)" />
                  <Text fz="md" fw={600} c="var(--text-main)">
                    {lang?.logs_title || "Today's Transactions"}
                  </Text>
                </Group>
              </Group>
              <Box className={classes.tableContainer} p={10}>
                <ScrollArea h={300} scrollbarSize={4}>
                  <Table
                    verticalSpacing="sm"
                    horizontalSpacing="md"
                    style={{ color: "var(--text-main)" }}
                    layout="fixed"
                  >
                    <Table.Thead>
                      <Table.Tr className={classes.tableHeader}>
                        <Table.Th className={classes.tableHeader}>
                          {lang?.table_time || "TIME"}
                        </Table.Th>
                        <Table.Th className={classes.tableHeader}>
                          {lang?.table_receipt || "RECEIPT ITEM"}
                        </Table.Th>
                        <Table.Th className={classes.tableHeader}>
                          {lang?.table_legit || "LEGIT SALE"}
                        </Table.Th>
                        <Table.Th className={classes.tableHeader}>
                          {lang?.table_dirty || "DIRTY WASHED"}
                        </Table.Th>
                        <Table.Th className={classes.tableHeader}>
                          {lang?.table_total || "TOTAL CLEANED (SAFE)"}
                        </Table.Th>
                      </Table.Tr>
                    </Table.Thead>

                    <Table.Tbody>
                      {logs.map((log) => (
                        <Table.Tr key={log.date} className={classes.tableRow}>
                          <Table.Td c="var(--text-dim)">{log.date}</Table.Td>
                          <Table.Td tt="capitalize">{log.method}</Table.Td>
                          <Table.Td>
                            {daLang?.money_symbol || "$"}
                            {log.sale.toFixed(2)}
                          </Table.Td>
                          <Table.Td c="var(--yellow)" fw={600}>
                            +{daLang?.money_symbol || "$"}
                            {log.washed.toFixed(2)}
                          </Table.Td>
                          <Table.Td c="var(--cyan)" fw={600} mr={6}>
                            {daLang?.money_symbol || "$"}
                            {log.cleaned.toFixed(2)}
                          </Table.Td>
                        </Table.Tr>
                      ))}
                    </Table.Tbody>
                  </Table>
                </ScrollArea>
              </Box>
            </Card>
          </Grid.Col>
        </Grid>
      </Stack>
    </ScrollAreaAutosize>
  );
};

export default Laundry;
