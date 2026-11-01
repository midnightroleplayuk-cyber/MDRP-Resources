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
import { ModalType, SelectType } from "../../../types/types";
import { useRecoilValue } from "recoil";
import { CursorState, Lang } from "../../../reducers/atoms";

interface PedManagerProps {
  currentShell: ShellType | null;
  pedOptions: SelectType[];
  animOptions: SelectType[];
  handleNew: (type: string) => void;
  handleDelete: (type: string, index: number) => void;
  setModal: React.Dispatch<React.SetStateAction<ModalType>>;
  handleCallback: (data: any) => void;
}

const PedManager = ({
  currentShell,
  pedOptions,
  animOptions,
  handleNew,
  handleDelete,
  setModal,
  handleCallback,
}: PedManagerProps) => {
  const daLang: any = useRecoilValue(Lang);
  const lang = daLang.admin;
  const cursor = useRecoilValue(CursorState);
  const editPed = (ped: any, index: number) => {
    setModal({
      state: true,
      info: {
        title: lang.edit_ped,
        options: [
          {
            name: "model",
            title: lang.ped_model,
            type: "select",
            options: pedOptions,
            default: ped.model,
          },
          {
            type: "select",
            name: "animData",
            title: lang.animation,
            options: animOptions,
            default: `${ped.dict}:${ped.animation}`,
          },
        ],
        button: daLang.confirm,
        extraData: { type: "peds", index },
      },
      callback: handleCallback,
    });
  };

  return (
    <Grid.Col span={6}>
      <Flex direction="column">
        <Group>
          <Text fz="sm" c="gray.3">{`${currentShell?.peds?.length ?? 0} ${
            daLang.peds
          }`}</Text>
          <Tooltip
            label={lang.new_ped}
            color="dark.6"
            fz="xs"
            disabled={!cursor}
          >
            <ActionIcon
              size="xs"
              variant="transparent"
              onClick={() => {
                handleNew("newped");
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
            {currentShell?.peds?.map((ped, index) => (
              <Group key={index} bg="rgba(30, 30, 36, 1)" p="sm">
                <Text fz="sm">{ped.model}</Text>
                <Group ml="auto" gap="sm">
                  <Tooltip
                    label={lang.edit_ped}
                    color="dark.6"
                    fz="xs"
                    disabled={!cursor}
                  >
                    <ActionIcon
                      size="xs"
                      variant="transparent"
                      onClick={() => {
                        editPed(ped, index);
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
                          x: ped.x,
                          y: ped.y,
                          z: ped.z,
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
                        handleDelete("peds", index);
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

export default PedManager;
