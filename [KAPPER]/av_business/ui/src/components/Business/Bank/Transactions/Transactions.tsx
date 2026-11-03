import { useState, useEffect } from "react";
import {
  Stack,
  Card,
  Text,
  Group,
  Flex,
  Select,
  ScrollArea,
} from "@mantine/core";
import { useAtomValue } from "jotai";
import { Lang } from "../../../../reducers/atoms";
import { formatTimestamp } from "../../../../hooks/formatTime";
import classes from "./style.module.css";
import global from "../../../../global.module.css";

export const Transactions = ({ myLogs }: any) => {
  const daLang: any = useAtomValue(Lang);
  const [loaded, setLoaded] = useState(false);
  const [currentLogs, setCurrentLogs] = useState(myLogs);
  const lang: any = daLang.bank;

  const filterLogs = (type: string | null) => {
    setLoaded(false);
    let filteredLogs = myLogs;

    if (type) {
      filteredLogs = myLogs.filter((log: any) => log.type === type);
    }
    const sortedLogs = [...filteredLogs].sort(
      (a, b) => Number(b.date) - Number(a.date),
    );
    setCurrentLogs(sortedLogs);
    setLoaded(true);
  };

  useEffect(() => {
    const sorted = [...myLogs].sort((a, b) => Number(b.date) - Number(a.date));
    setCurrentLogs(sorted);
    setLoaded(true);
  }, [myLogs]);

  return (
    <>
      <Group
        justify="space-between"
        mt="xs"
        align="center"
        display={"flex"}
        p={"xs"}
      >
        <Text fz="md" fw={500} c="var(--text-main)">
          {lang.latest}
        </Text>
        <Select
          classNames={global}
          placeholder={lang.filter}
          data={[
            { value: "deposit", label: lang.deposits },
            { value: "withdraw", label: lang.withdrawals },
          ]}
          size="xs"
          onChange={(value) => {
            filterLogs(value ?? null);
          }}
        />
      </Group>
      <ScrollArea
        h={`calc(100% - 160px)`}
        offsetScrollbars
        type="hover"
        scrollbars={"y"}
        scrollbarSize={6}
      >
        <Stack gap="xs">
          {loaded &&
            currentLogs.slice(0, 30).map((log: any, index: number) => (
              <Card
                className={classes.card}
                key={`${log.date}-${log.amount}-${index}`}
                p={"sm"}
                style={{
                  border: "solid 1px rgba(255,255,255,0.1)",
                  borderRadius: "6px",
                  overflow: "hidden",
                }}
              >
                <Group justify="space-between" w={"100%"} grow>
                  <Flex
                    justify="flex-start"
                    align="flex-start"
                    direction="column"
                    mah={100}
                  >
                    <Text fz="xs" c="var(--text-dim)">
                      {lang.description}
                    </Text>
                    <Text
                      fz="xs"
                      style={{
                        overflow: "auto",
                        wordWrap: "break-word",
                        overflowWrap: "break-word",
                      }}
                      maw={"100%"}
                    >
                      {log.description}
                    </Text>
                  </Flex>
                  <Flex
                    justify="flex-start"
                    align="flex-start"
                    direction="column"
                    wrap="wrap"
                  >
                    <Text fz="xs" c="var(--text-dim)">
                      {lang.employee}
                    </Text>
                    <Text fz="xs">{log.employee}</Text>
                  </Flex>
                  <Flex
                    justify="flex-start"
                    align="flex-start"
                    direction="column"
                    wrap="wrap"
                  >
                    <Text fz="xs" c="var(--text-dim)">
                      {lang.date}
                    </Text>
                    <Text fz="xs">{formatTimestamp(log.date)}</Text>
                  </Flex>
                  <Flex
                    justify="flex-start"
                    align="flex-start"
                    direction="column"
                    wrap="wrap"
                  >
                    <Text fz="xs" c="var(--text-dim)">
                      {lang.amount}
                    </Text>
                    <Text fz="xs">{`${
                      daLang.money_symbol
                    }${log.amount.toLocaleString("en-US")}`}</Text>
                  </Flex>
                  <Flex
                    justify="flex-start"
                    align="flex-start"
                    direction="column"
                    wrap="wrap"
                  >
                    <Text fz="xs" c="var(--text-dim)">
                      {lang.type}
                    </Text>
                    <Text
                      fz="xs"
                      c={
                        log.type === "deposit" ? "var(--cyan)" : "var(--danger)"
                      }
                      style={{ fontWeight: 600 }}
                    >
                      {log.type === "deposit" ? lang.deposit : lang.withdraw}
                    </Text>
                  </Flex>
                </Group>
              </Card>
            ))}
        </Stack>
      </ScrollArea>
    </>
  );
};
