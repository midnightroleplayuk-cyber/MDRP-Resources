import {
  Group,
  Text,
  Select,
  Button,
  ActionIcon,
  Tooltip,
} from "@mantine/core";
import {
  IconTrash,
  IconHome,
  IconDoor,
  IconMapPinShare,
  IconMouse,
  IconSun,
} from "@tabler/icons-react";
import { fetchNui } from "../../../hooks/useNuiEvents";
import { ShellType } from "./types";
import { SelectType } from "../../../types/types";
import { useRecoilState, useRecoilValue } from "recoil";
import { CursorState, Lang } from "../../../reducers/atoms";
import global from "../../../global.module.css";
import classes from "./style.module.css";

interface ShellManagerProps {
  shellOptions: SelectType[];
  currentShell: ShellType | null;
  handleSelect: (input: string | null) => void;
  handleSave: () => void;
  handleDelete: () => void;
}

const ShellManager = ({
  shellOptions,
  currentShell,
  handleSelect,
  handleSave,
  handleDelete,
}: ShellManagerProps) => {
  const daLang: any = useRecoilValue(Lang);
  const lang = daLang.admin;
  const [cursor, setCursor] = useRecoilState(CursorState);
  const handleCursor = () => {
    setCursor(!cursor);
    fetchNui("av_gangs", "toggleCursor");
  };
  return (
    <Group className={classes.card}>
      <Group>
        <Text fz="1.55rem" c="white" ff="Bebas Neue" fw={500} lts={1.55}>
          {lang.shells_manager}
        </Text>
        <Group gap="xs">
          <Tooltip label={lang.toggle_shell} color="dark.5" fz="xs">
            <ActionIcon
              size="xs"
              variant="transparent"
              color="dimmed"
              onClick={() => {
                fetchNui("av_gangs", "toggleShell", currentShell);
              }}
            >
              <IconHome />
            </ActionIcon>
          </Tooltip>
          <Tooltip
            label={lang.tp_shell}
            color="dark.5"
            fz="xs"
            onClick={() => {
              fetchNui("av_gangs", "teleportShell", currentShell);
            }}
          >
            <ActionIcon size="xs" variant="transparent" color="dimmed">
              <IconDoor />
            </ActionIcon>
          </Tooltip>
          <Tooltip label={lang.tp_outside} color="dark.5" fz="xs">
            <ActionIcon
              size="xs"
              variant="transparent"
              color="dimmed"
              onClick={() => {
                fetchNui("av_gangs", "teleportOutside");
              }}
            >
              <IconMapPinShare />
            </ActionIcon>
          </Tooltip>
          <Tooltip
            label={lang.toggle_weather}
            color="dark.5"
            fz="xs"
            hidden={!cursor}
          >
            <ActionIcon
              size="xs"
              variant="transparent"
              color="dimmed"
              onClick={() => {
                fetchNui("av_gangs", "toggleWeather");
              }}
            >
              <IconSun />
            </ActionIcon>
          </Tooltip>
          <Tooltip
            label={lang.toggle_menu}
            color="dark.5"
            fz="xs"
            hidden={!cursor}
          >
            <ActionIcon
              size="xs"
              variant="transparent"
              color="dimmed"
              onClick={handleCursor}
            >
              <IconMouse />
            </ActionIcon>
          </Tooltip>
        </Group>
      </Group>
      <Group ml="auto">
        <Select
          classNames={global}
          size="xs"
          placeholder={daLang.shell_model}
          data={shellOptions}
          searchable
          onChange={(e) => {
            handleSelect(e);
          }}
        />
        <Button
          className={global.button}
          size="xs"
          disabled={currentShell ? (currentShell.shell ? false : true) : true}
          miw={120}
          onDoubleClick={handleSave}
        >
          {daLang.save_changes}
        </Button>
        <Tooltip label={lang.delete_shell} color="dark.6" fz="xs">
          <ActionIcon
            color="red"
            variant="subtle"
            onDoubleClick={handleDelete}
            disabled={!currentShell?.shell}
          >
            <IconTrash style={{ height: "14px", width: "14px" }} />
          </ActionIcon>
        </Tooltip>
      </Group>
    </Group>
  );
};

export default ShellManager;
