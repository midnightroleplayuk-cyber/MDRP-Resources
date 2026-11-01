import { ReactNode } from "react";
import {
  Modal,
  Grid,
  Stack,
  Group,
  Text,
  Box,
  Button,
  Select,
  TextInput,
  PasswordInput,
  NumberInput,
  Switch,
  Tooltip,
  ScrollArea,
} from "@mantine/core";
import { MapZone } from "../MainApp/Map/Map";
import { Loading } from "../Loading";
import { EventType, SelectType } from "../../types/types";
import { CheckpointType } from "../MainApp/Details/types";
import global from "../../global.module.css";
import classes from "./style.module.css";

export interface EventFormProps {
  lang: any;
  loaded: boolean;
  event: EventType;
  errorType: string;
  checkpoints: CheckpointType[];
  trackData: any;
  accounts: SelectType[];
  phasing: SelectType[];
  categories: SelectType[];
  vehClasses: SelectType[];
  onUpdate: (field: string, value: any) => void;
  onReversed: (state: boolean) => void;
  onCancel: () => void;
  onCreate: () => void;
  tracks?: SelectType[];
  track?: string | null;
  onTrackChange?: (value: string | null) => void;
  canCreate?: boolean;
  canCrew?: boolean;
  rankedDisabled?: boolean;
  rankedHint?: string;
  rewindAvailable?: boolean;
}

export const EventForm = ({
  lang,
  loaded,
  event,
  errorType,
  checkpoints,
  trackData,
  accounts,
  phasing,
  categories,
  vehClasses,
  onUpdate,
  onReversed,
  onCancel,
  onCreate,
  tracks,
  track,
  onTrackChange,
  canCreate = true,
  canCrew = false,
  rankedDisabled = false,
  rankedHint,
  rewindAvailable = false,
}: EventFormProps) => {
  const isDrift = event.type?.toLowerCase() === "drift";

  const label = (text: string, tip: ReactNode) => (
    <Group gap={6} align="center" mb={2}>
      <Text className={global.fieldLabel}>{text}</Text>
      <Tooltip label={tip} color="var(--tooltip)" withArrow w={250} multiline>
        <Text className={global.help}>?</Text>
      </Tooltip>
    </Group>
  );

  const toggle = (
    text: string,
    tip: string,
    checked: boolean,
    onChange: (state: boolean) => void,
    disabled?: boolean,
  ) => (
    <Group gap={6} align="center" wrap="nowrap">
      <Switch
        size="xs"
        color="var(--accent)"
        checked={checked}
        disabled={disabled}
        onChange={(e) => onChange(e.currentTarget.checked)}
      />
      <Text className={global.fieldLabel}>{text}</Text>
      <Tooltip label={tip} color="var(--tooltip)" withArrow w={250} multiline>
        <Text className={global.help}>?</Text>
      </Tooltip>
    </Group>
  );

  const phasingTip = (
    <Stack gap={4}>
      <Group gap={4}>
        <Text fz="xs" c="white">
          {lang.phasing_types?.a?.title ?? "Standard"}
        </Text>
        <Text fz="xs" c="gray.4">
          {lang.phasing_types?.a?.description ?? "Normal phasing"}
        </Text>
      </Group>
      <Group gap={4}>
        <Text fz="xs" c="white">
          {lang.phasing_types?.b?.title ?? "Ghosted"}
        </Text>
        <Text fz="xs" c="gray.4">
          {lang.phasing_types?.b?.description ?? "Always ghosted"}
        </Text>
      </Group>
      <Group gap={4}>
        <Text fz="xs" c="white">
          {lang.phasing_types?.c?.title ?? "None"}
        </Text>
        <Text fz="xs" c="gray.4">
          {lang.phasing_types?.c?.description ?? "No phasing"}
        </Text>
      </Group>
    </Stack>
  );

  const summaryRow = (key: string, value: ReactNode, accent?: boolean) => (
    <Box className={classes.summaryRow}>
      <Text className={classes.summaryKey}>{key}</Text>
      <Text
        className={`${classes.summaryValue} ${accent ? classes.summaryAccent : ""}`}
      >
        {value}
      </Text>
    </Box>
  );

  const distance = trackData?.distance
    ? `${(Number(trackData.distance) / 1000).toFixed(2)} km`
    : "—";

  return (
    <Modal
      classNames={global}
      opened
      size="100%"
      centered
      lockScroll={false}
      c="white"
      trapFocus={false}
      withCloseButton={false}
      onClose={onCancel}
      title={
        <Group justify="space-between" wrap="nowrap" w="100%">
          <Text c="white" lts={0.5}>
            {lang.create_event ?? "CREATE EVENT"}
          </Text>
          <Group gap="xs">
            <Button
              size="xs"
              variant="transparent"
              color="red"
              onClick={onCancel}
            >
              {lang.cancel_button ?? "CANCEL"}
            </Button>
            {canCreate && (
              <Button className={global.button} size="xs" onClick={onCreate}>
                {lang.create_event_button ?? "CREATE"}
              </Button>
            )}
          </Group>
        </Group>
      }
      styles={{
        content: { maxWidth: "1240px", backdropFilter: "unset" },
        title: { width: "100%" },
      }}
    >
      {!loaded ? (
        <Loading />
      ) : (
        <Box className={classes.body}>
          <ScrollArea
            className={classes.formCol}
            h="100%"
            type="hover"
            scrollbars="y"
            scrollbarSize={4}
            offsetScrollbars
            pr={8}
          >
            <Stack gap={12} pb={10}>
              <Box className={classes.section}>
                <Text className={classes.sectionTitle}>
                  {lang.section_basics ?? "BASICS"}
                </Text>
                <Box className={classes.fieldGrid}>
                  {tracks && (
                    <Box>
                      {label(
                        lang.track ?? "TRACK",
                        lang.tooltip_track ?? "Track selected for the event.",
                      )}
                      <Select
                        classNames={global}
                        value={track}
                        data={tracks}
                        searchable
                        size="sm"
                        allowDeselect={false}
                        onChange={(e) => onTrackChange && onTrackChange(e)}
                      />
                    </Box>
                  )}
                  <Box>
                    {label(
                      lang.event_title ?? "EVENT TITLE",
                      lang.tooltip_title ?? "Public name for this event.",
                    )}
                    <TextInput
                      classNames={global}
                      value={event.title}
                      size="sm"
                      maxLength={30}
                      required
                      error={errorType == "title"}
                      onChange={(e) => onUpdate("title", e.currentTarget.value)}
                    />
                  </Box>
                  <Box>
                    {label(
                      lang.event_type ?? "EVENT TYPE",
                      lang.tooltip_type ?? "Game mode for the race.",
                    )}
                    <Select
                      classNames={global}
                      data={categories}
                      size="sm"
                      allowDeselect={false}
                      required
                      error={errorType == "type"}
                      value={event.type}
                      onChange={(e) => e && onUpdate("type", e)}
                    />
                  </Box>
                  <Box className={classes.wide}>
                    {label(
                      lang.description ?? "DESCRIPTION",
                      lang.tooltip_desc ??
                        "Short description or specific rules.",
                    )}
                    <TextInput
                      classNames={global}
                      value={event.description}
                      size="sm"
                      maxLength={50}
                      onChange={(e) =>
                        onUpdate("description", e.currentTarget.value)
                      }
                    />
                  </Box>
                </Box>
              </Box>

              <Box className={classes.section}>
                <Text className={classes.sectionTitle}>
                  {lang.section_entry ?? "ENTRY"}
                </Text>
                <Box className={classes.fieldGrid}>
                  <Box>
                    {label(
                      lang.buyin ?? "BUY IN",
                      lang.tooltip_buyin ?? "Amount required to join the race.",
                    )}
                    <NumberInput
                      classNames={global}
                      size="sm"
                      min={0}
                      max={10000000}
                      value={event.buyin}
                      thousandSeparator
                      allowDecimal={false}
                      allowLeadingZeros={false}
                      allowNegative={false}
                      required
                      error={errorType == "buyin"}
                      onChange={(e) => onUpdate("buyin", e)}
                    />
                  </Box>
                  <Box>
                    {label(
                      lang.money_account ?? "MONEY ACCOUNT",
                      lang.tooltip_account ??
                        "Currency used for entry and prizes.",
                    )}
                    <Select
                      classNames={global}
                      size="sm"
                      value={event.moneyAccount}
                      data={accounts}
                      allowDeselect={false}
                      required
                      error={errorType == "moneyAccount"}
                      onChange={(e) => e && onUpdate("moneyAccount", e)}
                    />
                  </Box>
                  <Box>
                    {label(
                      lang.vehicle_class ?? "VEHICLE CLASS",
                      lang.tooltip_class ?? "Allowed vehicle classes.",
                    )}
                    <Select
                      classNames={global}
                      size="sm"
                      value={event.class}
                      data={vehClasses}
                      onChange={(e) => onUpdate("class", e ?? "all")}
                    />
                  </Box>
                  <Box>
                    {label(
                      lang.starts_in ?? "STARTS IN",
                      lang.tooltip_starts ?? "Minutes until the race begins.",
                    )}
                    <NumberInput
                      classNames={global}
                      size="sm"
                      min={1}
                      max={600}
                      thousandSeparator
                      allowDecimal={false}
                      allowLeadingZeros={false}
                      allowNegative={false}
                      required
                      hideControls
                      value={event.startsin}
                      error={errorType == "startsin"}
                      onChange={(e) => onUpdate("startsin", e)}
                    />
                  </Box>
                  <Box>
                    {label(
                      lang.password ?? "PASSWORD",
                      lang.tooltip_password ?? "Leave empty for public events.",
                    )}
                    <PasswordInput
                      classNames={global}
                      size="sm"
                      maxLength={15}
                      value={event.password ? event.password : undefined}
                      onChange={(e) =>
                        onUpdate(
                          "password",
                          e.currentTarget.value === ""
                            ? false
                            : e.currentTarget.value,
                        )
                      }
                    />
                  </Box>
                </Box>
              </Box>

              <Box className={classes.section}>
                <Text className={classes.sectionTitle}>
                  {lang.section_setup ?? "RACE SETUP"}
                </Text>
                <Box className={classes.fieldGrid}>
                  <Box>
                    {label(
                      lang.laps ?? "LAPS",
                      lang.tooltip_laps ??
                        "Number of laps. Set to 0 for drag mode.",
                    )}
                    <NumberInput
                      classNames={global}
                      size="sm"
                      min={0}
                      max={99}
                      allowDecimal={false}
                      allowLeadingZeros={false}
                      allowNegative={false}
                      required
                      error={errorType == "laps"}
                      value={event.laps}
                      onChange={(e) => onUpdate("laps", e)}
                    />
                  </Box>
                  <Box>
                    {label(lang.phasing ?? "PHASING", phasingTip)}
                    <Select
                      classNames={global}
                      size="sm"
                      data={phasing}
                      value={
                        typeof event.phasing === "string"
                          ? event.phasing
                          : undefined
                      }
                      onChange={(e) => onUpdate("phasing", e ?? false)}
                    />
                  </Box>
                  {isDrift && (
                    <>
                      <Box>
                        {label(
                          lang.starting_time ?? "START TIME",
                          lang.tooltip_drift_start ??
                            "Initial time in seconds.",
                        )}
                        <NumberInput
                          classNames={global}
                          size="sm"
                          min={5}
                          max={999}
                          allowDecimal={false}
                          allowLeadingZeros={false}
                          allowNegative={false}
                          value={event.driftStartTime ?? 60}
                          error={errorType == "driftStartTime"}
                          onChange={(e) => onUpdate("driftStartTime", e)}
                        />
                      </Box>
                      <Box>
                        {label(
                          lang.checkpoint_time ?? "CP TIME",
                          lang.tooltip_drift_cp ??
                            "Seconds added per checkpoint.",
                        )}
                        <NumberInput
                          classNames={global}
                          size="sm"
                          min={5}
                          max={999}
                          allowDecimal={false}
                          allowLeadingZeros={false}
                          allowNegative={false}
                          value={event.driftCheckpointTime ?? 15}
                          error={errorType == "driftCheckpointTime"}
                          onChange={(e) => onUpdate("driftCheckpointTime", e)}
                        />
                      </Box>
                    </>
                  )}
                </Box>

                <Box className={classes.toggleRow}>
                  {toggle(
                    lang.reversed ?? "REVERSED",
                    lang.tooltip_reversed ??
                      "Drive the track in the opposite direction.",
                    event.reversed === true,
                    onReversed,
                  )}
                  {toggle(
                    lang.ranked ?? "RANKED",
                    rankedDisabled && rankedHint
                      ? rankedHint
                      : (lang.tooltip_ranked ??
                        "Event results will affect player ELO and rankings."),
                    event.isRanked === true,
                    (state) => onUpdate("isRanked", state),
                    rankedDisabled,
                  )}
                  {canCrew &&
                    toggle(
                      lang.crew_only ?? "CREW ONLY",
                      lang.tooltip_crew ?? "Restrict to crew members.",
                      event.isCrew === true,
                      (state) => onUpdate("isCrew", state),
                    )}
                  {rewindAvailable &&
                    toggle(
                      lang.rewind ?? "REWIND",
                      lang.tooltip_rewind ??
                        "Lets racers press a key to place their car back at an earlier point on the track. The clock keeps running, so the lost time is the cost.",
                      event.rewind === true,
                      (state) => onUpdate("rewind", state),
                    )}
                  {toggle(
                    lang.first_person ?? "FIRST PERSON",
                    lang.tooltip_first_person ??
                      "Locks every racer to the in-car first person view for the whole race. Their normal camera comes back when it ends.",
                    event.forceFirstPerson === true,
                    (state) => onUpdate("forceFirstPerson", state),
                  )}
                </Box>
              </Box>
            </Stack>
          </ScrollArea>

          <Box className={classes.rail}>
            <Box className={classes.mapBox}>
              {checkpoints && checkpoints.length > 0 ? (
                <MapZone checkpoints={checkpoints} />
              ) : (
                <Text className={classes.empty}>
                  {lang.select_track ?? "Select a track"}
                </Text>
              )}
            </Box>
            <Box className={classes.summary}>
              <Text className={classes.sectionTitle}>
                {lang.section_summary ?? "SUMMARY"}
              </Text>
              {summaryRow(lang.track ?? "TRACK", trackData?.name ?? "—")}
              {summaryRow(lang.distance ?? "DISTANCE", distance)}
              {summaryRow(
                lang.checkpoints ?? "CHECKPOINTS",
                checkpoints?.length ?? 0,
              )}
              {summaryRow(lang.laps ?? "LAPS", event.laps ?? 0)}
              {summaryRow(
                lang.buyin ?? "BUY IN",
                `${Number(event.buyin ?? 0).toLocaleString("en-US")}`,
                true,
              )}
            </Box>
          </Box>
        </Box>
      )}
    </Modal>
  );
};
