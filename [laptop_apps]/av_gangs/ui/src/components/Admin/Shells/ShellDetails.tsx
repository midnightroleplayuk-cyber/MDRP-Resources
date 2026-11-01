import {
  Grid,
  TextInput,
  NumberInput,
  Tooltip,
  ActionIcon,
  Text,
  Flex,
  Group,
} from "@mantine/core";
import { IconCircleDashedCheck, IconMapPin } from "@tabler/icons-react";
import { fetchNui } from "../../../hooks/useNuiEvents";
import { ShellType } from "./types";
import global from "../../../global.module.css";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";

interface ShellDetailsProps {
  currentShell: ShellType | null;
  handleUpdate: (field: string, value: any) => void;
  handleUpdateDoor: (field: string, value: number) => void;
  handleDoor: () => void;
}

const ShellDetails = ({
  currentShell,
  handleUpdate,
  handleUpdateDoor,
  handleDoor,
}: ShellDetailsProps) => {
  const daLang: any = useRecoilValue(Lang);
  const lang = daLang.admin;
  return (
    <Grid>
      <Grid.Col span={3}>
        <TextInput
          classNames={global}
          label={daLang.label}
          size="xs"
          value={currentShell?.label ?? ""}
          onChange={(e) => {
            handleUpdate("label", e.currentTarget.value);
          }}
        />
      </Grid.Col>
      <Grid.Col span={3}>
        <TextInput
          classNames={global}
          label={daLang.shell_model}
          size="xs"
          value={currentShell?.shell ?? ""}
          rightSection={
            <Tooltip label={lang.verify} color="dark.6" fz="xs">
              <ActionIcon
                size="xs"
                variant="transparent"
                c="dimmed"
                onClick={() => {
                  fetchNui("av_gangs", "verifyAsset", currentShell?.shell);
                }}
              >
                <IconCircleDashedCheck />
              </ActionIcon>
            </Tooltip>
          }
          onChange={(e) => {
            handleUpdate("shell", e.currentTarget.value);
          }}
        />
      </Grid.Col>
      <Grid.Col span={1}>
        <NumberInput
          label={lang.zIndex}
          classNames={global}
          size="xs"
          value={currentShell?.zIndex}
          allowDecimal={false}
          allowLeadingZeros={false}
          allowNegative={false}
          min={25}
          max={200}
          prefix="-"
          rightSection={
            <Tooltip
              label={lang.zIndex_description}
              color="dark.5"
              fz="xs"
              w={170}
              multiline
            >
              <Text fw={600} mr="xs" fz="sm">
                ?
              </Text>
            </Tooltip>
          }
          onChange={(e) => {
            handleUpdate("zIndex", e);
          }}
        />
      </Grid.Col>
      <Grid.Col span="auto">
        <Flex direction="column" gap={0} mt={3}>
          <Group gap="0">
            <Text fz="xs" fw={500}>
              Door Offsets (x, y, z, heading)
            </Text>
            <Tooltip label={lang.player_coords} color="dark.6" fz="xs">
              <ActionIcon
                size="sm"
                variant="transparent"
                ml="auto"
                onClick={handleDoor}
              >
                <IconMapPin style={{ height: "14px", width: "14px" }} />
              </ActionIcon>
            </Tooltip>
          </Group>
          <Group grow>
            <NumberInput
              classNames={global}
              placeholder="x"
              value={currentShell?.door?.x}
              onChange={(e) => {
                handleUpdateDoor("x", Number(e));
              }}
              size="xs"
              step={0.01}
            />
            <NumberInput
              classNames={global}
              placeholder="y"
              value={currentShell?.door?.y}
              onChange={(e) => {
                handleUpdateDoor("y", Number(e));
              }}
              size="xs"
              step={0.01}
            />
            <NumberInput
              classNames={global}
              placeholder="z"
              value={currentShell?.door?.z}
              onChange={(e) => {
                handleUpdateDoor("z", Number(e));
              }}
              step={0.01}
              size="xs"
            />
            <NumberInput
              classNames={global}
              placeholder="heading"
              value={currentShell?.door?.heading}
              onChange={(e) => {
                handleUpdateDoor("heading", Number(e));
              }}
              step={0.01}
              size="xs"
            />
          </Group>
        </Flex>
      </Grid.Col>
    </Grid>
  );
};

export default ShellDetails;
