import { useEffect, useState } from "react";
import {
  Table,
  Text,
  ActionIcon,
  Stack,
  Group,
  TextInput,
  Tooltip,
  ScrollArea,
} from "@mantine/core";

import {
  Search as IconSearch,
  Copy as IconCopy,
  UsersRound as IconSteeringWheel,
  FileText as IconFileDescription,
} from "lucide-react";
import { Racers } from "../Live/Racers";
import { EventResult } from "../../../types/types";
import global from "../../../global.module.css";
import { Loading } from "../../Loading";
import { Details } from "../../MainApp/Details/Details";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { ApiResults } from "../../../Api/Results";
import { useRecoilState, useRecoilValue } from "recoil";
import { eventDetails, Lang } from "../../../reducers/atoms";

const Results = () => {
  const lang: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(false);
  const [event, setEvent] = useRecoilState(eventDetails);
  const [allResults, setAllResults] = useState<EventResult[]>([]);
  const [filtered, setFiltered] = useState<EventResult[]>([]);
  const [racers, setRacers] = useState<null | string>(null);
  const handleSearch = (input: string) => {
    const res = allResults.filter((event) =>
      event.eventName ? event.eventName.toLowerCase().includes(input) : false,
    );
    setFiltered(res);
  };
  const IconStyle = { height: 14, width: 14 };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getResults");
      if (resp) {
        setAllResults(resp);
        setFiltered(resp);
      } else {
        if (isEnvBrowser()) {
          setAllResults(ApiResults);
          setFiltered(ApiResults);
        }
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, []);

  if (!loaded) return <Loading />;
  return (
    <>
      {event && <Details isAdmin />}
      {racers && (
        <Racers
          event={racers}
          close={() => {
            setRacers(null);
          }}
          isResults
        />
      )}
      <Stack p="sm" mt={2}>
        <TextInput
          classNames={global}
          ml="auto"
          w={250}
          size="xs"
          placeholder={lang.search}
          leftSection={<IconSearch style={IconStyle} />}
          onChange={(e) => {
            handleSearch(e.currentTarget.value);
          }}
        />
        <ScrollArea h={`calc(var(--admin-content-h) - 70px)`} type="hover" scrollbars="y" scrollbarSize={6}>
          <Table>
            <Table.Thead>
              <Table.Tr>
                <Table.Th>{lang.title}</Table.Th>
                <Table.Th>{lang.track}</Table.Th>
                <Table.Th>{lang.class}</Table.Th>
                <Table.Th>{lang.host}</Table.Th>
                <Table.Th>{lang.racers}</Table.Th>
                <Table.Th>{lang.actions}</Table.Th>
              </Table.Tr>
            </Table.Thead>
            <Table.Tbody>
              {filtered.map((element) => (
                <Table.Tr key={element.identifier}>
                  <Table.Td maw={200}>{element.eventName}</Table.Td>
                  <Table.Td maw={150}>{element.track}</Table.Td>
                  <Table.Td w={70} tt="capitalize">
                    {element.class}
                  </Table.Td>
                  <Table.Td>
                    <Group gap={5}>
                      <Text fz={13}>{element.host}</Text>
                      <Tooltip label={lang.copy} color="var(--tooltip)" fz="xs">
                        <ActionIcon
                          size="xs"
                          variant="transparent"
                          ml="auto"
                          onClick={() => {
                            fetchNui("av_laptop", "copy", element.host);
                          }}
                        >
                          <IconCopy style={{ height: 14, width: 14 }} />
                        </ActionIcon>
                      </Tooltip>
                    </Group>
                  </Table.Td>
                  <Table.Td ta="center">{element.numRacers}</Table.Td>
                  <Table.Td>
                    <Group>
                      <Tooltip
                        label={lang.racers}
                        color="var(--tooltip)"
                        fz="xs"
                      >
                        <ActionIcon
                          size="xs"
                          variant="transparent"
                          color="orange.3"
                          onClick={() => {
                            setRacers(element.identifier);
                          }}
                        >
                          <IconSteeringWheel style={IconStyle} />
                        </ActionIcon>
                      </Tooltip>
                      <Tooltip
                        label={lang.details}
                        color="var(--tooltip)"
                        fz="xs"
                      >
                        <ActionIcon
                          size="xs"
                          variant="transparent"
                          color="var(--cyan)"
                          onClick={() => {
                            setEvent(element);
                          }}
                        >
                          <IconFileDescription style={IconStyle} />
                        </ActionIcon>
                      </Tooltip>
                    </Group>
                  </Table.Td>
                </Table.Tr>
              ))}
            </Table.Tbody>
          </Table>
        </ScrollArea>
      </Stack>
    </>
  );
};

export default Results;
