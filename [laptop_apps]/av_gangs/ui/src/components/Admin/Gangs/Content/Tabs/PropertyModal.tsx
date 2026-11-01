import {
  Modal,
  Stack,
  Group,
  Text,
  Flex,
  Button,
  Select,
  Image,
} from "@mantine/core";
import { PropertyType, ShellType } from "./types";
import global from "../../../../../global.module.css";
import { useEffect, useState } from "react";
import { Loading } from "../../../../Loading";
import { fetchNui } from "../../../../../hooks/useNuiEvents";
import { useRecoilValue } from "recoil";
import { CursorState, Lang } from "../../../../../reducers/atoms";

interface Properties {
  property: PropertyType;
  handleClose: () => void;
  handleAction: (type: string, property: PropertyType, data?: any) => void;
}

export const PropertyModal = ({
  property,
  handleClose,
  handleAction,
}: Properties) => {
  const daLang: any = useRecoilValue(Lang);
  const lang = daLang.admin;
  const cursor = useRecoilValue(CursorState);
  const [loaded, setLoaded] = useState(false);
  const [selected, setSelected] = useState(property.shell);
  const [shells, setShells] = useState<ShellType[]>([
    {
      value: "shell1",
      label: "Shell 1",
      preview: "https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/acid.jpg",
    },
  ]);
  const getPreviewByValue = (searchValue: string) => {
    const foundShell = shells.find((shell) => shell.value === searchValue);
    return foundShell ? foundShell.preview : null;
  };
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_gangs", "getShells", property.type);
      if (resp) {
        setShells(resp);
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, [property]);
  return (
    <Modal
      classNames={global}
      opened
      size={340}
      onClose={handleClose}
      lockScroll={false}
      c="white"
      centered
      trapFocus={false}
      opacity={cursor ? 1.0 : 0.1}
      title={
        <Text fz="sm" c="gray.3">
          {lang.property_details}
        </Text>
      }
    >
      {!loaded ? (
        <div style={{ padding: 100 }}>
          <Loading />
        </div>
      ) : (
        <Stack>
          <Image
            src={getPreviewByValue(selected)}
            fallbackSrc="mission_default.webp"
            h={100}
            fit="cover"
          />
          <Select
            classNames={global}
            label={
              <Text fz="sm" c="white" fw={500}>
                {daLang.shell_model}
              </Text>
            }
            size="xs"
            data={shells}
            defaultValue={property.shell}
            allowDeselect={false}
            onChange={(e) => {
              if (!e) return;
              setSelected(e);
              handleAction("changeShell", property, e);
            }}
          />
          <Flex direction="column">
            <Text fz="sm" c="white" fw={500}>
              {daLang.upgrades}
            </Text>
            <Group>
              <Text fz="xs" c="gray.4">{`Security: ${
                property.upgrades.security ?? `N/A`
              }`}</Text>
              <Text fz="xs" c="gray.4">{`Production: ${
                property.upgrades.production ?? `N/A`
              }`}</Text>
              <Text fz="xs" c="gray.4">{`Stash: ${
                property.upgrades.stash ?? `N/A`
              }`}</Text>
            </Group>
          </Flex>
          <Flex direction="column">
            <Text fz="sm" c="white">
              {daLang.actions}
            </Text>
            <Group grow mt="xs">
              <Button
                size="xs"
                variant="light"
                onClick={() => {
                  handleAction("processStash", property);
                }}
                disabled={property.type !== "labs"}
              >
                {daLang.process_lab}
              </Button>
              <Button
                size="xs"
                variant="light"
                color="cyan"
                onClick={() => {
                  handleAction("changeEntry", property);
                }}
              >
                {lang.change_entry}
              </Button>
            </Group>
            <Group grow mt="xs">
              <Button
                size="xs"
                variant="light"
                color="orange"
                onClick={() => {
                  handleAction("toggleDoor", property);
                }}
              >
                {lang.toggle_door}
              </Button>
              <Button
                size="xs"
                variant="light"
                color="violet"
                onClick={() => {
                  fetchNui("av_laptop", "setGPS", {
                    x: property.entry.x,
                    y: property.entry.y,
                    z: property.entry.z,
                  });
                }}
              >
                {daLang.set_waypoint}
              </Button>
            </Group>
            <Button
              mt="xs"
              size="xs"
              variant="light"
              color="red"
              onDoubleClick={() => {
                handleAction("deleteProperty", property);
              }}
              fullWidth
            >
              {daLang.delete}
            </Button>
          </Flex>
        </Stack>
      )}
    </Modal>
  );
};
