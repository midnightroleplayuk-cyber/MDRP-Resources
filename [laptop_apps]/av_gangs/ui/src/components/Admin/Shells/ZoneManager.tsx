import {
  Grid,
  Text,
  Tooltip,
  ActionIcon,
  Stack,
  ScrollArea,
  Group,
  Flex,
} from "@mantine/core";
import {
  IconLibraryPlus,
  IconEdit,
  IconMapPin,
  IconTrash,
} from "@tabler/icons-react";
import { fetchNui } from "../../../hooks/useNuiEvents";
import { ShellType } from "./types";
import { ModalType } from "../../../types/types";
import { useRecoilValue } from "recoil";
import { CursorState, Lang } from "../../../reducers/atoms";

interface ZoneManagerProps {
  currentShell: ShellType | null;
  handleNew: (type: string, data?: any) => void;
  handleDelete: (type: string, index: number) => void;
  setModal: React.Dispatch<React.SetStateAction<ModalType>>;
  handleCallback: (data: any) => void;
}

const ZoneManager = ({
  currentShell,
  handleNew,
  handleDelete,
  setModal,
  handleCallback,
}: ZoneManagerProps) => {
  const cursor = useRecoilValue(CursorState);
  const daLang: any = useRecoilValue(Lang);
  const lang = daLang.admin;
  const newZone = async () => {
    const events = await fetchNui("av_gangs", "getEvents");
    setModal({
      state: true,
      info: {
        title: lang.new_zone,
        options: [
          {
            type: "text",
            name: "name",
            title: lang.zone_name,
            size: "xs",
          },
          {
            type: "text",
            name: "label",
            title: lang.interaction,
            size: "xs",
          },
          {
            type: "select",
            name: "event",
            title: lang.zone_event,
            options: events,
            searchable: true,
            size: "xs",
          },
          {
            type: "number",
            name: "dist",
            title: lang.interaction_distance,
            default: 1,
            min: 1,
            size: "xs",
          },
        ],
        button: daLang.confirm,
      },
      callback: handleRegister,
    });
  };

  const handleRegister = (data: any) => {
    setModal({ state: false, info: { options: [] } });
    if (!data) return;
    handleNew("newinteraction", data);
  };
  const editZone = (zone: any, index: number) => {
    setModal({
      state: true,
      info: {
        title: lang.edit_zone,
        options: [
          {
            type: "text",
            name: "name",
            title: lang.zone_name,
            default: zone.name ?? "",
            size: "xs",
          },
          {
            type: "text",
            name: "label",
            title: lang.interaction,
            default: zone.label ?? "Interact",
            size: "xs",
          },
          {
            type: "text",
            name: "event",
            title: lang.zone_event,
            default: zone.event ?? "",
            size: "xs",
          },
          {
            type: "number",
            name: "dist",
            title: lang.interaction_distance,
            default: zone.dist ?? 1,
            min: 1,
            size: "xs",
          },
        ],
        button: daLang.confirm,
        extraData: { type: "interactions", index },
      },
      callback: handleCallback,
    });
  };

  return (
    <Grid.Col span={6}>
      <Flex direction="column">
        <Group>
          <Text fz="sm" c="gray.3">{`${
            currentShell?.interactions?.length ?? 0
          } Zone(s)`}</Text>
          <Tooltip
            label={lang.new_zone}
            color="dark.6"
            fz="xs"
            disabled={!cursor}
          >
            <ActionIcon
              size="xs"
              variant="transparent"
              onClick={() => {
                newZone();
              }}
            >
              <IconLibraryPlus
                style={{ height: "15px", width: "15px" }}
                stroke={1.5}
              />
            </ActionIcon>
          </Tooltip>
        </Group>
        <ScrollArea
          h={355}
          mt="xs"
          offsetScrollbars
          type="hover"
          scrollbars="y"
          scrollbarSize={5}
        >
          <Stack gap="xs">
            {currentShell?.interactions?.map((zone, index) => (
              <Group key={index} bg="rgba(30, 30, 36, 1)" p="sm">
                <Text fz="sm">{`${zone.name ?? zone.event}`}</Text>
                <Group ml="auto" gap="sm">
                  <Tooltip
                    label={lang.edit_zone}
                    color="dark.6"
                    fz="xs"
                    disabled={!cursor}
                  >
                    <ActionIcon
                      size="xs"
                      variant="transparent"
                      onClick={() => {
                        editZone(zone, index);
                      }}
                    >
                      <IconEdit style={{ height: "14px", width: "14px" }} />
                    </ActionIcon>
                  </Tooltip>
                  <Tooltip
                    label={daLang.teleport}
                    color="dark.6"
                    fz="xs"
                    disabled={!cursor}
                  >
                    <ActionIcon
                      size="xs"
                      variant="transparent"
                      color="violet"
                      onClick={() => {
                        fetchNui("av_gangs", "teleportTo", {
                          x: zone.x,
                          y: zone.y,
                          z: zone.z,
                        });
                      }}
                    >
                      <IconMapPin style={{ height: "14px", width: "14px" }} />
                    </ActionIcon>
                  </Tooltip>
                  <Tooltip
                    label={daLang.delete}
                    color="dark.6"
                    fz="xs"
                    disabled={!cursor}
                  >
                    <ActionIcon
                      size="xs"
                      variant="transparent"
                      color="red"
                      onDoubleClick={() => {
                        handleDelete("interactions", index);
                      }}
                    >
                      <IconTrash style={{ height: "14px", width: "14px" }} />
                    </ActionIcon>
                  </Tooltip>
                </Group>
              </Group>
            ))}
          </Stack>
        </ScrollArea>
      </Flex>
    </Grid.Col>
  );
};

export default ZoneManager;
