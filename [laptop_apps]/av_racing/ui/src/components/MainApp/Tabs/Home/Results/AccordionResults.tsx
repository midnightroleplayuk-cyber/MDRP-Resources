import { Accordion, Group, Text, Flex } from "@mantine/core";
import { PositionTable } from "./PositionTable";
import { fetchNui } from "../../../../../hooks/useNuiEvents";
import { useCallback } from "react";
import { EventResult } from "../../../../../types/types";
import classes from "./style.module.css";

interface AccordionResultsProps {
  event: EventResult;
  lang: any;
}

const InfoItem = ({
  label,
  value,
}: {
  label: string;
  value: string | number;
}) => (
  <Flex direction="column" gap={4}>
    <Text className={classes.label}>{label}</Text>
    <Text truncate className={classes.text}>
      {value}
    </Text>
  </Flex>
);

export const AccordionResults = ({ event, lang }: AccordionResultsProps) => {
  const openUnderground = useCallback(() => {
    fetchNui("av_racing", "underground", event.identifier);
  }, [event]);
  const eventType = event.type?.toLowerCase();
  const isDrift = eventType === "drift";
  return (
    <Accordion.Item value={event.identifier} id={event.identifier}>
      <Accordion.Control>
        <Group grow style={{ flex: 1 }}>
          <InfoItem
            label={lang.event_name ?? "EVENT"}
            value={event.eventName}
          />
          <InfoItem label={lang.track_name ?? "TRACK"} value={event.track} />
          <InfoItem label={lang.racers ?? "RACERS"} value={event.numRacers} />
          <InfoItem label={lang.class ?? "CLASS"} value={event.class} />
          <InfoItem label={lang.laps ?? "LAPS"} value={event.laps} />
        </Group>
      </Accordion.Control>
      <Accordion.Panel>
        <PositionTable data={event.results} isDrift={isDrift} />
        <Group justify="center" mt="md">
          <button className={classes.underBtn} onClick={openUnderground}>
            {lang.underground_btn ?? "UNDERGROUND"}
          </button>
        </Group>
      </Accordion.Panel>
    </Accordion.Item>
  );
};
