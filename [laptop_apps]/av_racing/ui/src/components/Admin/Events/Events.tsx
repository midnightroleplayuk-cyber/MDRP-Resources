import {
  Grid,
  Group,
  Text,
  Stack,
  ScrollArea,
  Card,
  NumberInput,
  Switch,
  Flex,
  RangeSlider,
  TextInput,
  ActionIcon,
  Checkbox,
  Tooltip,
  MultiSelect,
  Select,
  Button,
  Box,
} from "@mantine/core";
import { useEffect, useState } from "react";
import {
  Flag as IconFlag,
  MapPin as IconMapPin,
  Eye as IconEye,
} from "lucide-react";
import { Loading } from "../../Loading";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { RandomEventsType, RandomTracksType } from "./types";
import { ApiRandomEvents, ApiRandomTracks } from "../../../Api/RandomSettings";
import { ApiClasses } from "../../../Api/Classes";
import { SelectType, TrackType } from "../../../types/types";
import { ApiPhasing } from "../../../Api/Events";
import { ApiTrack } from "../../../Api/Track";
import { Details } from "../../MainApp/Tabs/Tracks/Details";
import global from "../../../global.module.css";
import classes from "./style.module.css";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";

const SettingCard = ({ title, tooltip, children, span = 6 }: any) => (
  <Grid.Col span={span}>
    <Card className={classes.card}>
      <Flex direction="column" gap="sm">
        <Group gap={6} align="center">
          <Text className={global.fieldLabel}>{title}</Text>
          <Tooltip
            label={tooltip}
            fz="xs"
            color="var(--tooltip)"
            lts={1}
            multiline
            maw={300}
          >
            <Text className={global.help}>?</Text>
          </Tooltip>
        </Group>
        {children}
      </Flex>
    </Card>
  </Grid.Col>
);

const Events = () => {
  const lang: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(false);
  const [allTracks, setAllTracks] = useState<RandomTracksType[]>([]);
  const [filtered, setFiltered] = useState<RandomTracksType[]>([]);
  const [search, setSearch] = useState("");
  const [settings, setSettings] = useState<RandomEventsType>(ApiRandomEvents);
  const [allClasses] = useState<SelectType[]>(ApiClasses);
  const [allAccounts, setAllAccounts] = useState<SelectType[]>([
    { value: "cosmo", label: "Cosmo" },
  ]);
  const [phasingOptions] = useState<SelectType[]>(ApiPhasing);
  const [circuit, setCircuit] = useState<TrackType | null>(null);

  const updateField = <K extends keyof RandomEventsType>(
    field: K,
    value: RandomEventsType[K],
  ) => {
    setSettings((prev) => ({
      ...prev,
      [field]: value,
    }));
  };

  const handleFilter = (type: string, state: boolean) => {
    if (!state) {
      setFiltered(allTracks);
      return;
    }
    if (type == "used") {
      const result = allTracks.filter((track) =>
        settings.tracks.includes(track.identifier),
      );
      setFiltered(result);
      return;
    }
    if (type == "isRanked") {
      const result = allTracks.filter((track) => track.isRanked);
      setFiltered(result);
    }
  };
  const handlePreview = async (identifier: string) => {
    const track = isEnvBrowser()
      ? ApiTrack
      : await fetchNui("av_racing", "getTrack", identifier);
    setCircuit(track);
  };

  const handleSearch = (input: string) => {
    setSearch(input);
    const filteredTracks = allTracks.filter((track) => {
      const query = input.toLowerCase();
      return (
        track.name.toLowerCase().includes(query) ||
        (track.type && track.type.toLowerCase().includes(query))
      );
    });
    setFiltered(filteredTracks);
  };

  const handleCheck = (state: boolean, identifier: string) => {
    setSettings((prev) => ({
      ...prev,
      tracks: state
        ? [...prev.tracks, identifier]
        : prev.tracks.filter((t) => t !== identifier),
    }));
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getEventsConfig");
      if (resp) {
        setSettings(resp.settings);
        setAllTracks(resp.allTracks || []);
        setFiltered(resp.allTracks || []);
        setAllAccounts(resp.allAccounts);
      } else if (isEnvBrowser()) {
        setAllTracks(ApiRandomTracks);
        setFiltered(ApiRandomTracks);
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, []);

  if (!loaded) return <Loading />;

  return (
    <>
      {circuit && (
        <Details
          track={circuit}
          handleClose={() => {
            setCircuit(null);
          }}
          isAdmin
        />
      )}
      <Stack p="md">
        <Group justify="space-between">
          <Text c="dimmed" fz="xs" maw={500}>
            {lang.random_events_description}
          </Text>
          <Group>
            <Switch
              classNames={global}
              label={settings.enabled ? lang.enabled : lang.disabled}
              size="xs"
              onChange={(e) => {
                updateField("enabled", e.currentTarget.checked);
              }}
              checked={settings.enabled}
            />
            <Button
              size="xs"
              color="var(--accent)"
              variant="outline"
              onClick={() => {
                fetchNui("av_racing", "updateServerSettings", settings);
              }}
            >
              {lang.save_changes}
            </Button>
          </Group>
        </Group>
        <Grid gutter="xs">
          <Grid.Col span={6}>
            <ScrollArea
              h={`calc(var(--admin-content-h) - 110px)`}
              type="hover"
              scrollbars="y"
              scrollbarSize={4}
              offsetScrollbars
              pr={7}
            >
              <Grid>
                <SettingCard
                  title={lang.event_interval}
                  tooltip={lang.event_interval_tooltip}
                >
                  <NumberInput
                    classNames={global}
                    size="xs"
                    min={1}
                    max={999}
                    value={settings.interval}
                    allowDecimal={false}
                    onChange={(e) => {
                      updateField("interval", Number(e));
                    }}
                  />
                </SettingCard>
                <SettingCard
                  title={lang.min_racers}
                  tooltip={lang.min_racers_tooltip}
                >
                  <NumberInput
                    classNames={global}
                    size="xs"
                    min={1}
                    max={100}
                    allowDecimal={false}
                    value={settings.minRacers}
                    onChange={(e) => {
                      updateField("minRacers", Number(e));
                    }}
                  />
                </SettingCard>
                <SettingCard
                  title={lang.time_2_start}
                  tooltip={lang.time_2_start_tooltip}
                >
                  <RangeSlider
                    mt="xs"
                    classNames={global}
                    value={[
                      settings.startTime[0] ?? 0,
                      settings.startTime[1] ?? 90,
                    ]}
                    min={10}
                    max={90}
                    step={5}
                    size="xs"
                    onChange={(e) => {
                      updateField("startTime", e);
                    }}
                  />
                </SettingCard>
                <SettingCard
                  title={lang.money_accounts}
                  tooltip={lang.money_accounts_tooltip}
                >
                  <MultiSelect
                    classNames={global}
                    size="xs"
                    data={allAccounts}
                    value={settings.moneyAccounts}
                    onChange={(e) => {
                      updateField("moneyAccounts", e);
                    }}
                  />
                </SettingCard>
                <SettingCard
                  title={lang.min_entry}
                  tooltip={lang.min_entry_tooltip}
                >
                  <NumberInput
                    classNames={global}
                    size="xs"
                    min={0}
                    max={1000000}
                    allowDecimal={false}
                    value={settings.minEntry}
                    onChange={(e) => {
                      updateField("minEntry", Number(e));
                    }}
                  />
                </SettingCard>
                <SettingCard
                  title={lang.max_entry}
                  tooltip={lang.max_entry_tooltip}
                >
                  <NumberInput
                    classNames={global}
                    size="xs"
                    min={0}
                    max={1000000}
                    allowDecimal={false}
                    value={settings.maxEntry}
                    onChange={(e) => {
                      updateField("maxEntry", Number(e));
                    }}
                  />
                </SettingCard>

                <SettingCard
                  title={lang.min_payout}
                  tooltip={lang.payout_tooltip}
                >
                  <NumberInput
                    classNames={global}
                    size="xs"
                    min={1}
                    max={1000000}
                    allowDecimal={false}
                    value={settings.minPayout}
                    onChange={(e) => {
                      updateField("minPayout", Number(e));
                    }}
                  />
                </SettingCard>
                <SettingCard
                  title={lang.max_payout}
                  tooltip={lang.payout_tooltip}
                >
                  <NumberInput
                    classNames={global}
                    size="xs"
                    min={2}
                    max={1000000}
                    allowDecimal={false}
                    value={settings.maxPayout}
                    onChange={(e) => {
                      updateField("maxPayout", Number(e));
                    }}
                  />
                </SettingCard>
                <SettingCard title={lang.laps} tooltip={lang.laps_tooltip}>
                  <RangeSlider
                    classNames={global}
                    size="xs"
                    mt="xs"
                    value={[settings.laps[0] ?? 0, settings.laps[1] ?? 3]}
                    min={0}
                    max={5}
                    minRange={0}
                    step={1}
                    onChange={(e) => {
                      updateField("laps", e);
                    }}
                  />
                </SettingCard>
                <SettingCard
                  title={lang.phasing}
                  tooltip={lang.phasing_tooltip}
                >
                  <MultiSelect
                    classNames={global}
                    size="xs"
                    data={phasingOptions}
                    value={settings.phasing}
                    onChange={(e) => {
                      updateField("phasing", e);
                    }}
                  />
                </SettingCard>
                <SettingCard
                  title={lang.reversed}
                  tooltip={lang.reversed_tooltip}
                >
                  <Select
                    classNames={global}
                    size="xs"
                    data={[
                      { value: "yes", label: lang.yes },
                      { value: "no", label: lang.no },
                    ]}
                    value={settings.reversed ? "yes" : "no"}
                    onChange={(e) => {
                      if (!e) {
                        updateField("reversed", false);
                      }
                      updateField("reversed", e === "yes" ? true : false);
                    }}
                  />
                </SettingCard>
                <SettingCard title={lang.ranked} tooltip={lang.ranked_tooltip}>
                  <Select
                    classNames={global}
                    size="xs"
                    data={[
                      { value: "yes", label: lang.yes },
                      { value: "no", label: lang.no },
                    ]}
                    value={settings.isRanked ? "yes" : "no"}
                    onChange={(e) => {
                      if (!e) {
                        updateField("isRanked", false);
                      }
                      updateField("isRanked", e === "yes" ? true : false);
                    }}
                  />
                </SettingCard>
                <SettingCard
                  title={lang.veh_classes}
                  tooltip={lang.veh_classes_tooltip}
                  span="auto"
                >
                  <MultiSelect
                    classNames={global}
                    size="xs"
                    data={allClasses}
                    value={settings.classes}
                    onChange={(e) => {
                      updateField("classes", e);
                    }}
                  />
                </SettingCard>
              </Grid>
            </ScrollArea>
          </Grid.Col>
          <Grid.Col span={6}>
            <Card
              className={classes.card}
              h={`calc(var(--admin-content-h) - 110px)`}
            >
              <Stack>
                <Group justify="space-between">
                  <Text c="gray.1">{`${filtered.length} ${lang.tracks}`}</Text>
                  <Group gap="xs">
                    <Checkbox
                      label={lang.selected}
                      size="xs"
                      onChange={(e) => {
                        handleFilter("used", e.currentTarget.checked);
                      }}
                    />
                    <Checkbox
                      label={lang.ranked}
                      size="xs"
                      onChange={(e) => {
                        handleFilter("isRanked", e.currentTarget.checked);
                      }}
                    />
                    <TextInput
                      classNames={global}
                      size="xs"
                      placeholder={lang.search}
                      value={search}
                      onChange={(e) => handleSearch(e.currentTarget.value)}
                      w={150}
                    />
                  </Group>
                </Group>
                <ScrollArea
                  h={`calc(var(--admin-content-h) - 188px)`}
                  type="hover"
                  scrollbars="y"
                  scrollbarSize={4}
                  offsetScrollbars
                  pr={7}
                >
                  <Stack gap="xs">
                    {filtered.map((track) => (
                      <Group
                        key={track.identifier}
                        className={classes.card}
                        p="xs"
                        mih={70}
                        bg="rgba(110, 113, 128, 0.09)"
                      >
                        <Flex direction="column">
                          <Text fz="sm" c="gray.3" maw={200} truncate>
                            {track.name}
                          </Text>
                          <Group gap="xs">
                            <Group gap={3}>
                              <IconFlag style={{ height: 13, width: 13 }} />
                              <Text c="dimmed" fz="xs">
                                {track.type}
                              </Text>
                            </Group>
                            <Group gap={3}>
                              <IconMapPin style={{ height: 13, width: 13 }} />
                              <Text c="dimmed" fz="xs">
                                {track.checkpoints}
                              </Text>
                            </Group>
                          </Group>
                        </Flex>
                        <Group ml="auto">
                          <Tooltip
                            label={lang.preview_circuit}
                            color="var(--tooltip)"
                            fz="xs"
                          >
                            <ActionIcon
                              variant="transparent"
                              size="sm"
                              color="cyan.2"
                              onClick={() => {
                                handlePreview(track.identifier);
                              }}
                            >
                              <IconEye />
                            </ActionIcon>
                          </Tooltip>
                          <Checkbox
                            size="xs"
                            color="var(--purple)"
                            checked={settings.tracks.includes(track.identifier)}
                            onChange={(e) => {
                              handleCheck(
                                e.currentTarget.checked,
                                track.identifier,
                              );
                            }}
                          />
                        </Group>
                      </Group>
                    ))}
                  </Stack>
                </ScrollArea>
              </Stack>
            </Card>
          </Grid.Col>
        </Grid>
      </Stack>
    </>
  );
};

export default Events;
