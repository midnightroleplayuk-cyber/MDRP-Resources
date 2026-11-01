import { useEffect, useMemo, useState } from "react";
import {
  ActionIcon,
  Badge,
  Box,
  Group,
  ScrollArea,
  Text,
  TextInput,
  Tooltip,
} from "@mantine/core";
import {
  IconActivity,
  IconCar,
  IconCash,
  IconCheck,
  IconClock,
  IconCopy,
  IconSearch,
  IconSpray,
  IconSwords,
  IconTarget,
  IconUsers,
} from "@tabler/icons-react";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { ApiLogs } from "../../../api/Logs";
import { GangLogType } from "./types";
import classes from "./style.module.css";
import global from "../../../global.module.css";

const MAX_RENDER = 100;

const getActivityIcon = (activity: string) => {
  const text = activity.toLowerCase();
  if (text.includes("graffiti")) return IconSpray;
  if (text.includes("money") || text.includes("sold")) return IconCash;
  if (text.includes("vehicle") || text.includes("export")) return IconCar;
  if (text.includes("war") || text.includes("attack")) return IconSwords;
  if (text.includes("mission") || text.includes("contract")) return IconTarget;
  if (text.includes("member")) return IconUsers;
  return IconActivity;
};

const LogsTab = () => {
  const daLang: any = useRecoilValue(Lang);
  const lang = daLang.admin;
  const [logs, setLogs] = useState<GangLogType[]>([]);
  const [search, setSearch] = useState("");
  const [copiedId, setCopiedId] = useState<string | null>(null);

  const copyIdentifier = (log: GangLogType) => {
    if (!log.identifier) return;
    if (isEnvBrowser()) {
      navigator.clipboard?.writeText(log.identifier);
    } else {
      fetchNui("av_laptop", "copy", log.identifier);
    }
    setCopiedId(log.id);
    setTimeout(() => {
      setCopiedId((current) => (current === log.id ? null : current));
    }, 1500);
  };

  const fetchLogs = async () => {
    const resp = await fetchNui("av_gangs", "admin:getLogs");
    if (resp) {
      setLogs(resp);
    } else if (isEnvBrowser()) {
      setLogs(ApiLogs);
    }
  };

  useEffect(() => {
    fetchLogs();
  }, []);

  const filtered = useMemo(() => {
    const query = search.trim().toLowerCase();
    if (!query) return logs;
    return logs.filter((log) =>
      [
        log.activity,
        log.member,
        log.gang,
        log.target ?? "",
        log.identifier ?? "",
        log.date,
      ].some((field) => field.toLowerCase().includes(query)),
    );
  }, [logs, search]);

  const visible = useMemo(() => filtered.slice(0, MAX_RENDER), [filtered]);

  return (
    <Box className={classes.wrapper} p="md">
      <Group justify="space-between" mb="sm">
        <Group gap="xs">
          <Text className={classes.title}>{lang.logs_tab}</Text>
          <Badge className={classes.countBadge}>{filtered.length}</Badge>
        </Group>
        <TextInput
          value={search}
          onChange={(event) => setSearch(event.currentTarget.value)}
          placeholder={daLang.search}
          leftSection={<IconSearch size={14} />}
          classNames={{ input: global.input }}
          w={260}
          size="xs"
        />
      </Group>
      <ScrollArea className={classes.scroll} type="scroll">
        {filtered.length === 0 ? (
          <Box className={classes.empty}>
            <IconActivity size={26} className={classes.emptyIcon} />
            <Text className={classes.emptyText}>
              {lang.logs_empty || "No logs found"}
            </Text>
          </Box>
        ) : (
          visible.map((log) => {
            const ActivityIcon = getActivityIcon(log.activity);
            return (
              <Group key={log.id} className={classes.card} gap="sm">
                <Box className={classes.iconBox}>
                  <ActivityIcon size={17} />
                </Box>
                <Box className={classes.info}>
                  <Text className={classes.activity}>{log.activity}</Text>
                  <Group gap={6}>
                    <Text className={classes.member}>{log.member}</Text>
                    <Text className={classes.separator}>•</Text>
                    <Text className={classes.gang}>{log.gang}</Text>
                    {log.target && (
                      <>
                        <Text className={classes.vs}>
                          {lang.logs_vs || "vs"}
                        </Text>
                        <Text className={classes.target}>{log.target}</Text>
                      </>
                    )}
                  </Group>
                </Box>
                <Group gap={5} className={classes.dateBox}>
                  <IconClock size={13} />
                  <Text className={classes.date}>{log.date}</Text>
                </Group>
                {log.identifier && (
                  <Tooltip
                    label={
                      copiedId === log.id
                        ? lang.logs_copied || "Copied!"
                        : lang.logs_copy || "Copy identifier"
                    }
                  >
                    <ActionIcon
                      className={
                        copiedId === log.id
                          ? `${classes.copyBtn} ${classes.copyBtnDone}`
                          : classes.copyBtn
                      }
                      variant="subtle"
                      onClick={() => copyIdentifier(log)}
                    >
                      {copiedId === log.id ? (
                        <IconCheck size={14} />
                      ) : (
                        <IconCopy size={14} />
                      )}
                    </ActionIcon>
                  </Tooltip>
                )}
              </Group>
            );
          })
        )}
        {filtered.length > MAX_RENDER && (
          <Text className={classes.limitNote}>
            {(lang.logs_limit || "Showing the first {count} results, refine your search").replace(
              "{count}",
              String(MAX_RENDER),
            )}
          </Text>
        )}
      </ScrollArea>
    </Box>
  );
};

export default LogsTab;
