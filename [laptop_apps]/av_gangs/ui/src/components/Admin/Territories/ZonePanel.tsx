import {
  Modal,
  Stack,
  Group,
  Button,
  ScrollArea,
  Text,
  NumberInput,
} from "@mantine/core";
import { ZoneDataType } from "./types";
import global from "../../../global.module.css";
import { useState } from "react";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";

interface Properties {
  zoneData: ZoneDataType;
  closeModal: () => void;
  handleSave: (zone: ZoneDataType) => void;
  handleWipe: (name: string) => void;
}

export const ZonePanel = ({
  zoneData,
  closeModal,
  handleSave,
  handleWipe,
}: Properties) => {
  const daLang: any = useRecoilValue(Lang);
  const lang = daLang.admin;
  const [data, setData] = useState<ZoneDataType>(zoneData);

  const handleUpdate = (gangName: string, points: number) => {
    setData((prevData) => {
      const updatedGangsData = prevData.gangsData.map((gang) => {
        if (gang.name === gangName) {
          return {
            ...gang,
            points: points,
          };
        }
        return gang;
      });
      return {
        ...prevData,
        gangsData: updatedGangsData,
      };
    });
  };
  return (
    <Modal
      classNames={global}
      opened
      onClose={closeModal}
      centered
      title={<Text c="white">{zoneData.zoneLabel}</Text>}
      size={320}
    >
      <Group>
        <Text c="dimmed" fz="xs">
          {lang.gang_name}
        </Text>
        <Text ml="auto" c="dimmed" fz="xs">
          {lang.zone_points}
        </Text>
      </Group>
      <ScrollArea
        mt="xs"
        h={250}
        offsetScrollbars
        type="hover"
        scrollbars="y"
        scrollbarSize={5}
      >
        <Stack gap="xs">
          {data.gangsData.map((gang) => (
            <Group>
              <Text fz="sm" c="gray.3" maw={200} truncate>
                {gang.label}
              </Text>
              <NumberInput
                classNames={global}
                min={0}
                ml="auto"
                size="xs"
                value={gang.points}
                allowDecimal={false}
                allowLeadingZeros={false}
                allowNegative={false}
                onChange={(e) => {
                  handleUpdate(gang.name, Number(e));
                }}
                w={100}
              />
            </Group>
          ))}
        </Stack>
      </ScrollArea>
      <Group mt="md">
        <Button
          ml="auto"
          size="xs"
          variant="subtle"
          color="red"
          onDoubleClick={() => {
            handleWipe(data.zoneName);
          }}
        >
          {lang.wipe_zone}
        </Button>
        <Button
          className={global.button}
          size="xs"
          onClick={() => {
            handleSave(data);
          }}
        >
          {daLang.save_changes}
        </Button>
      </Group>
    </Modal>
  );
};
