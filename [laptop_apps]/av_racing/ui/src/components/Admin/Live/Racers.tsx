import { useEffect, useState } from "react";
import {
  Modal,
  Stack,
  ScrollArea,
  Table,
  TextInput,
  ActionIcon,
  Group,
  Text,
  Tooltip,
} from "@mantine/core";
import { Trash as IconTrash, Copy as IconCopy } from "lucide-react";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { ApiRacers } from "../../../Api/Racers";
import { RacerType } from "../../../types/types";
import global from "../../../global.module.css";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";

interface Properties {
  event: string;
  close: () => void;
  isResults?: boolean;
}

export const Racers = ({ event, close, isResults }: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const [allRacers, setAllRacers] = useState<RacerType[]>([]);
  const [filtered, setFiltered] = useState<RacerType[]>([]);
  const [search, setSearch] = useState("");

  const handleSearch = (input: string) => {
    setSearch(input);
    const res = allRacers.filter((racer) =>
      racer.name
        ? racer.name.toLowerCase().includes(input.toLocaleLowerCase()) ||
          racer.vehicle.toLowerCase().includes(input.toLocaleLowerCase())
        : false,
    );
    setFiltered(res);
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getRacers", event);
      if (resp) {
        setAllRacers(resp);
        setFiltered(resp);
      } else {
        if (isEnvBrowser()) {
          setAllRacers(ApiRacers);
          setFiltered(ApiRacers);
        }
      }
    };
    fetchData();
  }, [event]);

  return (
    <Modal
      classNames={global}
      opened
      centered
      title={`${filtered.length} ${lang.racers}`}
      lockScroll={false}
      c="white"
      size="auto"
      trapFocus={false}
      onClose={close}
      styles={{
        content: {
          width: 950,
          backdropFilter: "unset",
        },
      }}
    >
      <Stack>
        <TextInput
          classNames={global}
          placeholder={lang.search}
          size="xs"
          value={search}
          onChange={(e) => {
            handleSearch(e.currentTarget.value);
          }}
        />
        <ScrollArea h={`calc(var(--admin-content-h) - 140px)`} type="hover" scrollbars="y" scrollbarSize={6}>
          <Table>
            <Table.Thead>
              <Table.Tr>
                <Table.Th>{lang.nickname}</Table.Th>
                <Table.Th>{lang.identifier}</Table.Th>
                <Table.Th>{lang.vehicle}</Table.Th>
                <Table.Th>{lang.position}</Table.Th>
                <Table.Th>{lang.is_driver}</Table.Th>
                <Table.Th>{lang.finished}</Table.Th>
                {!isResults && <Table.Th>{lang.actions}</Table.Th>}
              </Table.Tr>
            </Table.Thead>
            <Table.Tbody>
              {filtered.map((racer) => (
                <Table.Tr key={racer.name}>
                  <Table.Td>{racer.name}</Table.Td>
                  <Table.Td>
                    <Group gap={5}>
                      <Text fz={13} truncate maw={155}>
                        {racer.identifier}
                      </Text>
                      <ActionIcon
                        size="xs"
                        variant="transparent"
                        onClick={() => {
                          fetchNui("av_laptop", "copy", racer.identifier);
                        }}
                      >
                        <IconCopy style={{ height: 14, width: 14 }} />
                      </ActionIcon>
                    </Group>
                  </Table.Td>
                  <Table.Td>{racer.vehicle}</Table.Td>
                  <Table.Td>{racer.position}</Table.Td>
                  <Table.Td>{racer.isDriver ? lang.yes : lang.no}</Table.Td>
                  <Table.Td>{racer.finished ? lang.yes : lang.no}</Table.Td>
                  {!isResults && (
                    <Table.Td>
                      <Tooltip
                        label={lang.remove_from_event}
                        color="var(--tooltip)"
                        fz="xs"
                      >
                        <ActionIcon
                          size="xs"
                          color="red.4"
                          variant="transparent"
                        >
                          <IconTrash style={{ height: 14, width: 14 }} />
                        </ActionIcon>
                      </Tooltip>
                    </Table.Td>
                  )}
                </Table.Tr>
              ))}
            </Table.Tbody>
          </Table>
        </ScrollArea>
      </Stack>
    </Modal>
  );
};
