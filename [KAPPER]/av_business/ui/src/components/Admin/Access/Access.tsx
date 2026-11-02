import { useEffect, useState } from "react";
import {
  Stack,
  Button,
  Group,
  Text,
  Grid,
  Flex,
  Tooltip,
  Box,
  ScrollAreaAutosize,
  TextInput,
  ActionIcon,
  Divider,
  Card,
  Table,
  Badge,
} from "@mantine/core";
import { IconTrash } from "@tabler/icons-react";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { ApiJobAccess } from "../../../API/admin_settings";
import { JobAccessType } from "../types";
import { SelectType } from "../../../types/types";
import { MultiSelector } from "../MultiSelector";
import global from "../../../global.module.css";
import classes from "./style.module.css";
import { Loading } from "../../Loading";

const toArray = (obj: Record<string, boolean>): string[] =>
  Object.keys(obj).filter((k) => obj[k]);

const toRecord = (arr: string[]): Record<string, boolean> =>
  arr.reduce((acc, k) => ({ ...acc, [k]: true }), {});

type AccessKey = keyof Omit<JobAccessType, "blacklistedPlayers">;

const AccessCard = ({
  label,
  tooltip,
  value,
  allJobs,
  onChange,
}: {
  label: string;
  tooltip: string;
  value: string[];
  allJobs: SelectType[];
  onChange: (v: string[]) => void;
}) => (
  <Grid.Col span={6}>
    <Card className={classes.card}>
      <Flex direction="column" gap="sm">
        <Group>
          <Text fz="sm" c="var(--text-dim)">
            {label}
          </Text>
          <Tooltip
            label={tooltip}
            fz="xs"
            color="var(--tooltip)"
            lts={1}
            multiline
            maw={230}
            withArrow
            position="top-start"
          >
            <Box className={classes.tooltip} bg="var(--tooltip)">
              <Text fz={10} c="var(--text-dim)">
                ?
              </Text>
            </Box>
          </Tooltip>
        </Group>
        <MultiSelector data={allJobs} values={value} updateData={onChange} />
      </Flex>
    </Card>
  </Grid.Col>
);

const Access = ({ allJobs }: { allJobs: SelectType[] }) => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.admin;
  const ACCESS_CARDS: { key: AccessKey; label: string; tooltip: string }[] = [
    {
      key: "noCustomItems",
      label: lang.access_no_products,
      tooltip: lang.access_no_products_tip,
    },
    {
      key: "noSuppliesTab",
      label: lang.access_no_supplies,
      tooltip: lang.access_no_supplies_tip,
    },
    {
      key: "noDeliveriesTab",
      label: lang.access_no_deliveries,
      tooltip: lang.access_no_deliveries_tip,
    },
    {
      key: "posterJobs",
      label: lang.access_poster,
      tooltip: lang.access_poster_tip,
    },
    {
      key: "blacklistedDiscounts",
      label: lang.access_no_discounts,
      tooltip: lang.access_no_discounts_tip,
    },
    {
      key: "blacklistedLoyalty",
      label: lang.access_no_loyalty,
      tooltip: lang.access_no_loyalty_tip,
    },
    {
      key: "counterAccess",
      label: lang.access_counter,
      tooltip: lang.access_counter_tip,
    },
    {
      key: "billingBlocked",
      label: lang.access_billing_blocked,
      tooltip: lang.access_billing_blocked_tip,
    },
    {
      key: "laundryAccess",
      label: lang.access_laundry,
      tooltip: lang.access_laundry_tip,
    },
    {
      key: "useBills",
      label: lang.access_bills,
      tooltip: lang.access_bills_tip,
    },
    {
      key: "directBillJobs",
      label: lang.access_direct_billing,
      tooltip: lang.access_direct_billing_tip,
    },
  ];
  const [loaded, setLoaded] = useState(false);
  const [access, setAccess] = useState<JobAccessType>(ApiJobAccess);
  const [playerInput, setPlayerInput] = useState("");

  const updateKey = (key: AccessKey, arr: string[]) =>
    setAccess((prev) => ({ ...prev, [key]: toRecord(arr) }));

  const addPlayer = () => {
    const trimmed = playerInput.trim();
    if (!trimmed || access.blacklistedPlayers[trimmed]) return;
    setAccess((prev) => ({
      ...prev,
      blacklistedPlayers: { ...prev.blacklistedPlayers, [trimmed]: true },
    }));
    setPlayerInput("");
  };

  const removePlayer = (id: string) => {
    setAccess((prev) => {
      const updated = { ...prev.blacklistedPlayers };
      delete updated[id];
      return { ...prev, blacklistedPlayers: updated };
    });
  };

  const handleSave = () => {
    fetchNui("av_business", "updateSettings", {
      settings: access,
      type: "job_access",
    });
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getSettings", "job_access");
      if (resp && Object.keys(resp).length > 0) {
        setAccess(resp);
      } else if (isEnvBrowser()) {
        setAccess(ApiJobAccess);
      }
      setTimeout(() => setLoaded(true), 100);
    };
    fetchData();
  }, []);

  if (!loaded) return <Loading />;

  const players = Object.keys(access.blacklistedPlayers ?? {});

  return (
    <Stack gap="xs">
      <Group>
        <Text fz="xs" maw={420} c="var(--text-dim)" lts={0.55}>
          {lang.access_desc}
        </Text>
        <Button
          className={global.button}
          size="xs"
          ml="auto"
          onClick={handleSave}
        >
          {lang.save_changes}
        </Button>
      </Group>
      <ScrollAreaAutosize h={590} type="hover" scrollbars="y" scrollbarSize={5}>
        <Stack gap="sm">
          <Grid gap="xs">
            {ACCESS_CARDS.map(({ key, label, tooltip }) => (
              <AccessCard
                key={key}
                label={label}
                tooltip={tooltip}
                value={toArray(access[key] ?? {})}
                allJobs={allJobs}
                onChange={(arr) => updateKey(key, arr)}
              />
            ))}
          </Grid>
          <Divider opacity={0.12} />
          <Stack gap="xs">
            <Group>
              <Text fz="xs" c="var(--text-dim)">
                {lang.access_blacklisted_players}
              </Text>
              <Tooltip
                label={lang.access_blacklist_tooltip}
                fz="xs"
                color="var(--tooltip)"
                multiline
                maw={260}
                withArrow
                position="top-start"
              >
                <Box className={classes.tooltip} bg="var(--tooltip)">
                  <Text fz={10} c="var(--text-dim)">
                    ?
                  </Text>
                </Box>
              </Tooltip>
              <Badge size="xs" variant="light" color="gray" ml="auto">
                {players.length} {lang.access_blocked}
              </Badge>
            </Group>
            <Group gap="xs">
              <TextInput
                classNames={global}
                size="xs"
                placeholder={lang.access_placeholder}
                value={playerInput}
                style={{ flex: 1 }}
                onChange={(e) => setPlayerInput(e.currentTarget.value)}
                onKeyDown={(e) => {
                  if (e.key === "Enter") addPlayer();
                }}
              />
              <Button
                className={global.button}
                size="xs"
                disabled={!playerInput.trim()}
                onClick={addPlayer}
              >
                {lang.access_add}
              </Button>
            </Group>
            {players.length > 0 ? (
              <Table layout="fixed" fz="xs">
                <Table.Thead>
                  <Table.Tr>
                    <Table.Th>{lang.access_identifier}</Table.Th>
                    <Table.Th w={70}>{lang.access_remove}</Table.Th>
                  </Table.Tr>
                </Table.Thead>
                <Table.Tbody>
                  {players.map((id) => (
                    <Table.Tr key={id}>
                      <Table.Td>
                        <Text fz="xs" ff="monospace" truncate>
                          {id}
                        </Text>
                      </Table.Td>
                      <Table.Td>
                        <Tooltip
                          label={lang.access_remove_tooltip}
                          fz="xs"
                          color="var(--tooltip)"
                        >
                          <ActionIcon
                            size="xs"
                            variant="transparent"
                            color="red"
                            onDoubleClick={() => removePlayer(id)}
                          >
                            <IconTrash
                              style={{ height: 13, width: 13 }}
                              stroke={1.5}
                            />
                          </ActionIcon>
                        </Tooltip>
                      </Table.Td>
                    </Table.Tr>
                  ))}
                </Table.Tbody>
              </Table>
            ) : (
              <Text fz="xs" c="var(--text-dim)" ta="center" py="xs">
                {lang.no_players ?? "No restricted players"}
              </Text>
            )}
          </Stack>
        </Stack>
      </ScrollAreaAutosize>
    </Stack>
  );
};

export default Access;
