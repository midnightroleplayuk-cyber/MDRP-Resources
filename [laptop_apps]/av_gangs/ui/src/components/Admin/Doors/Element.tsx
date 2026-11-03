import { Group, Text, Tooltip, ActionIcon, Badge } from "@mantine/core";
import { IconCheck, IconX, IconMapPin, IconTrash } from "@tabler/icons-react";
import { DoorType } from "../../../types/types";
import { fetchNui } from "../../../hooks/useNuiEvents";
import { getDistance } from "../../../hooks/getDistance";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";

interface Properties {
  door: DoorType;
  bg: boolean;
  isNew: boolean;
  playerCoords: {
    x: number;
    y: number;
    z: number;
  };
  updateCoords: () => void;
  handleDelete: (door: DoorType) => void;
}
export const DoorComponent = ({
  door,
  bg,
  isNew,
  playerCoords,
  updateCoords,
  handleDelete,
}: Properties) => {
  const daLang: any = useRecoilValue(Lang);
  const lang = daLang.admin;
  const distance = getDistance(
    { x: door.x, y: door.y, z: door.z },
    playerCoords
  );
  const handleTeleport = async () => {
    await fetchNui("av_laptop", "teleport", {
      x: door.x,
      y: door.y,
      z: door.z,
    });
    updateCoords();
  };
  return (
    <Group
      key={door.identifier}
      bg={bg ? "rgba(30, 30, 36, 1)" : undefined}
      p="xs"
      gap="xs"
    >
      <Group gap="xs">
        {isNew && (
          <Badge color="yellow" size="xs">
            {daLang.new}
          </Badge>
        )}
        <Text fz="xs" truncate maw={170}>
          {door.street}
        </Text>
      </Group>
      <Group ml="auto" gap="xs">
        <Text fz="xs" c="dimmed">{`${lang.dist}: ${distance.toLocaleString(
          "en-US"
        )} mts.`}</Text>
        <Tooltip
          label={door.onUse ? lang.taken : lang.available}
          color="dark.5"
          position="top-start"
        >
          {door.onUse ? (
            <IconX style={{ height: "14px", width: "14px" }} color="#fa5252" />
          ) : (
            <IconCheck
              style={{ height: "14px", width: "14px" }}
              color="#63e6be"
            />
          )}
        </Tooltip>
        <Tooltip label={daLang.teleport} color="dark.5" position="top-start">
          <ActionIcon
            variant="transparent"
            color="violet.3"
            size="xs"
            onClick={handleTeleport}
          >
            <IconMapPin
              style={{ height: "14px", width: "14px" }}
              stroke={1.5}
            />
          </ActionIcon>
        </Tooltip>
        <Tooltip label={daLang.delete} color="dark.5" position="top-start">
          <ActionIcon
            variant="transparent"
            color="red.4"
            size="xs"
            onDoubleClick={() => {
              handleDelete(door);
            }}
          >
            <IconTrash style={{ height: "14px", width: "14px" }} stroke={1.5} />
          </ActionIcon>
        </Tooltip>
      </Group>
    </Group>
  );
};
