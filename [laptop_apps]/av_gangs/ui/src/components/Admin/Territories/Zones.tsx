import {
  Group,
  Text,
  TextInput,
  Stack,
  ScrollAreaAutosize,
} from "@mantine/core";
import { ZoneDataType } from "./types";
import { useState } from "react";
import classes from "./style.module.css";
import global from "../../../global.module.css";

interface Properties {
  zoneData: ZoneDataType[];
  handleCurrent: (name: string) => void;
}

function sortZonesAlphabetically(zones: ZoneDataType[]): ZoneDataType[] {
  return zones.sort((a, b) => a.zoneLabel.localeCompare(b.zoneLabel));
}

export const Zones = ({ zoneData, handleCurrent }: Properties) => {
  const allZones = sortZonesAlphabetically(zoneData);
  const [filtered, setFiltered] = useState(sortZonesAlphabetically(zoneData));

  const handleSearch = (input: string) => {
    const res = allZones.filter((zone) =>
      zone.zoneName ? zone.zoneName.toLowerCase().includes(input) : false,
    );
    setFiltered(res);
  };
  return (
    <Stack>
      <ScrollAreaAutosize
        h={525}
        offsetScrollbars
        type="hover"
        scrollbars="y"
        scrollbarSize={5}
      >
        <Stack gap="xs">
          <TextInput
            classNames={global}
            size="xs"
            placeholder="Search..."
            mr="xs"
            onChange={(e) => {
              handleSearch(e.currentTarget.value);
            }}
          />
          {filtered.map((zone) => (
            <Group
              key={zone.zoneName}
              className={classes.group}
              onClick={() => {
                handleCurrent(zone.zoneName);
              }}
            >
              <Text fz="sm" truncate maw={200}>
                {zone.zoneLabel}
              </Text>
            </Group>
          ))}
        </Stack>
      </ScrollAreaAutosize>
    </Stack>
  );
};
