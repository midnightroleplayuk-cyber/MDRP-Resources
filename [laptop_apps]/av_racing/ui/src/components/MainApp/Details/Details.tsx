import {
  useEffect,
  useMemo,
  useState,
  useCallback,
  lazy,
  Suspense,
} from "react";
import {
  Modal,
  Grid,
  Stack,
  Text,
  Group,
  ScrollArea,
  ActionIcon,
  PasswordInput,
  Tooltip,
  Box,
} from "@mantine/core";
import { useRecoilState, useRecoilValue } from "recoil";
import { Copy as IconCopy } from "lucide-react";
import { eventDetails, Lang } from "../../../reducers/atoms";
import { Loading } from "../../Loading";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { ApiCheckpoints } from "../../../Api/Checkpoints";
import { CheckpointType } from "./types";

const MapZone = lazy(() =>
  import("../Map/Map").then((m) => ({ default: m.MapZone })),
);
import { useViewportHeight } from "../../../hooks/windowResize";
import { calculateDistance } from "../../../hooks/calculateDistance";
import global from "../../../global.module.css";
import classes from "./style.module.css";

interface Properties {
  isAdmin?: boolean;
}

export const Details = ({ isAdmin }: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const [details, setDetails] = useRecoilState<any>(eventDetails);
  const [checkpoints, setCheckpoints] = useState<CheckpointType[]>([]);
  const [loaded, setLoaded] = useState(false);
  const height = useViewportHeight();

  useEffect(() => {
    const fetchData = async () => {
      setLoaded(false);
      const resp = await fetchNui("av_racing", "getCheckpoints", {
        identifier: details?.identifier,
        trackIdentifier: details.trackIdentifier,
      });
      if (resp) {
        let checkpoints = resp.checkpoints;
        if (resp.isOld && details.reversed) {
          checkpoints = checkpoints.reverse();
        }
        setCheckpoints(checkpoints);
      } else {
        if (isEnvBrowser()) setCheckpoints(ApiCheckpoints);
      }
      setLoaded(true);
    };

    if (details) {
      fetchData();
    }
  }, [details]);

  const filteredCheckpoints = useMemo(() => {
    if (!checkpoints || checkpoints.length === 0) {
      return [];
    }
    const newCheckpoints = [checkpoints[0]];
    for (let i = 1; i < checkpoints.length; i++) {
      const prevCheckpoint = newCheckpoints[newCheckpoints.length - 1];
      const currentCheckpoint = checkpoints[i];
      const distance = calculateDistance(prevCheckpoint, currentCheckpoint);
      if (distance > 50) {
        newCheckpoints.push(currentCheckpoint);
      }
    }
    return newCheckpoints;
  }, [checkpoints]);

  const panelHeight = isAdmin
    ? 460
    : Math.min(520, Math.max(360, height * 0.85 - 130));

  const renderRow = useCallback(
    (label: string, value: string | number, tooltip?: string) => (
      <Box className={classes.row} key={label}>
        <Text className={classes.rowKey}>{label}</Text>
        <Group gap={4} wrap="nowrap">
          <Text className={classes.rowValue} tt="capitalize">
            {value}
          </Text>
          {tooltip && (
            <Tooltip
              label={tooltip}
              fz="xs"
              color="var(--tooltip)"
              withArrow
              multiline
              maw={300}
            >
              <Box className={classes.tooltip}>
                <Text className={classes.tooltipText}>?</Text>
              </Box>
            </Tooltip>
          )}
        </Group>
      </Box>
    ),
    [],
  );

  const renderChip = useCallback(
    (label: string, on: boolean) => (
      <Text
        key={label}
        className={`${classes.chip} ${on ? classes.chipOn : ""}`}
      >
        {label}
      </Text>
    ),
    [],
  );

  return (
    <Modal
      opened={!!details}
      size="1050px"
      centered
      lockScroll={false}
      trapFocus={false}
      title={details?.title}
      onClose={() => setDetails(null)}
      classNames={{
        header: classes.modalHeader,
        title: classes.modalTitle,
      }}
      styles={{
        content: {
          minHeight: !loaded ? height / 2 : undefined,
          backdropFilter: isAdmin ? "unset" : undefined,
          backgroundColor: "var(--bg-main)",
          border: "1px solid var(--border-color)",
        },
        header: {
          backgroundColor: "transparent",
        },
        body: {
          padding: "20px",
          backgroundColor: "var(--bg-main)",
        },
      }}
    >
      {!loaded ? (
        <Loading />
      ) : (
        <Grid gutter="lg">
          <Grid.Col span={5}>
            <ScrollArea
              h={panelHeight}
              type="hover"
              scrollbars="y"
              scrollbarSize={4}
              offsetScrollbars
            >
              <Stack gap="md" pr="xs">
                <Box className={classes.metrics}>
                  <Box className={classes.metric}>
                    <Text className={classes.metricLabel}>
                      {lang.buyin ?? "Buy In"}
                    </Text>
                    <Text className={classes.metricValue}>
                      {`${details?.buyin ? details?.buyin.toLocaleString("en-US") : 0}`}
                    </Text>
                  </Box>
                  <Box className={classes.metric}>
                    <Text className={classes.metricLabel}>
                      {lang.total_pot ?? "Total Pot"}
                    </Text>
                    <Text
                      className={`${classes.metricValue} ${classes.metricAccent}`}
                    >
                      {`${details?.moneypot ? details?.moneypot.toLocaleString("en-US") : 0}`}
                    </Text>
                  </Box>
                  <Box className={classes.metric}>
                    <Text className={classes.metricLabel}>
                      {lang.participants ?? "Racers"}
                    </Text>
                    <Text className={classes.metricValue}>
                      {details?.minRacers
                        ? `${details?.numRacers ?? 0} / ${details.minRacers}`
                        : (details?.numRacers ?? 0)}
                    </Text>
                  </Box>
                </Box>

                <Stack gap={8}>
                  <Text className={classes.sectionLabel}>
                    {lang.rules ?? "RULES"}
                  </Text>
                  <Box className={classes.chips}>
                    {renderChip(lang.ranked ?? "Ranked", !!details?.isRanked)}
                    {renderChip(lang.phasing ?? "Phasing", !!details?.phasing)}
                    {renderChip(lang.reversed ?? "Reversed", !!details?.reversed)}
                    {renderChip(lang.rewind ?? "Rewind", !!details?.rewind)}
                    {renderChip(
                      lang.first_person ?? "First Person",
                      !!details?.forceFirstPerson,
                    )}
                  </Box>
                </Stack>

                <Box className={classes.rows}>
                  {renderRow(lang.track ?? "Track", details?.track ?? "N/A")}
                  {renderRow(
                    lang.vehicle_class ?? "Class",
                    details?.class ?? "All",
                  )}
                  {renderRow(
                    lang.checkpoints ?? "Checkpoints",
                    filteredCheckpoints.length,
                  )}
                  {renderRow(lang.laps ?? "Laps", details?.laps ?? 0)}
                  {details?.accountLabel &&
                    renderRow(
                      lang.money_account ?? "Account",
                      details.accountLabel,
                    )}
                </Box>

                {isAdmin && (
                  <Stack gap={8} className={classes.adminBlock}>
                    <Text className={classes.sectionLabel}>
                      {lang.admin ?? "ADMIN"}
                    </Text>
                    <Box className={classes.row}>
                      <Text className={classes.rowKey}>
                        {lang.host ?? "Host"}
                      </Text>
                      <Group gap={4} wrap="nowrap">
                        <Text className={classes.rowValue} maw={130}>
                          {details?.host ?? "SYSTEM"}
                        </Text>
                        <ActionIcon
                          variant="transparent"
                          size="xs"
                          className={classes.copyIcon}
                          onClick={() => {
                            fetchNui("av_laptop", "copy", details?.host);
                          }}
                        >
                          <IconCopy style={{ height: 14, width: 14 }} />
                        </ActionIcon>
                      </Group>
                    </Box>
                    {details?.password && (
                      <Box className={classes.row}>
                        <Text className={classes.rowKey}>
                          {lang.password ?? "Password"}
                        </Text>
                        <PasswordInput
                          size="xs"
                          w={130}
                          value={details.password}
                          readOnly
                          styles={{
                            input: {
                              backgroundColor: "var(--bg-main)",
                              border: "1px solid var(--border-color)",
                              color: "var(--text-main)",
                              fontFamily: "var(--font-main)",
                            },
                          }}
                        />
                      </Box>
                    )}
                  </Stack>
                )}
              </Stack>
            </ScrollArea>
          </Grid.Col>
          <Grid.Col span="auto" h={panelHeight}>
            <Box className={classes.mapContainer}>
              <Suspense fallback={null}>
                <MapZone checkpoints={filteredCheckpoints} />
              </Suspense>
            </Box>
          </Grid.Col>
        </Grid>
      )}
    </Modal>
  );
};
