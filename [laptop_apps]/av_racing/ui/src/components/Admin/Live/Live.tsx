import { useEffect, useState } from "react";
import {
  Stack,
  Group,
  Text,
  TextInput,
  Table,
  ScrollArea,
  ActionIcon,
  Button,
  Tooltip,
} from "@mantine/core";
import { EventType } from "../../../types/types";
import {
  UsersRound,
  Search as IconSearch,
  Copy as IconCopy,
  FileText as IconFileDescription,
  Trash as IconTrash,
  Play as IconPlayerPlay,
  Mail as IconMessage,
} from "lucide-react";
import {
  fetchNui,
  isEnvBrowser,
  useNuiEvent,
} from "../../../hooks/useNuiEvents";
import { ApiEvents } from "../../../Api/Events";
import { Loading } from "../../Loading";
import { Timer } from "../../../hooks/Timer";
import { Chat } from "../../MainApp/Chat/Chat";
import { useRecoilState, useRecoilValue } from "recoil";
import { eventDetails, Lang } from "../../../reducers/atoms";
import { Details } from "../../MainApp/Details/Details";
import global from "../../../global.module.css";
import { Racers } from "./Racers";

interface Properties {
  showCreator: (state: boolean) => void;
}

const Live = ({ showCreator }: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(false);
  const [allEvents, setAllEvents] = useState<EventType[]>([]);
  const [filtered, setFiltered] = useState<EventType[]>([]);
  const [event, setEvent] = useRecoilState(eventDetails);
  const [racers, setRacers] = useState<null | string>(null);
  const [chat, setChat] = useState<string | null>(null);
  const IconStyle = { height: 14, width: 14 };

  const handleSearch = (input: string) => {
    const res = allEvents.filter((event) =>
      event.title ? event.title.toLowerCase().includes(input) : false,
    );
    setFiltered(res);
  };

  useNuiEvent("updateEvents", (events: EventType[]) => {
    setAllEvents(events);
    setFiltered(events);
  });
  useNuiEvent("newEvent", (event: EventType) => {
    const updated = [...allEvents, event];
    setAllEvents(updated);
    setFiltered(updated);
  });

  useNuiEvent("removeEvent", (identifier: string) => {
    const updated = allEvents.filter(
      (event) => event.identifier !== identifier,
    );
    setAllEvents(updated);
    setFiltered(updated);
  });

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getEvents");
      if (resp) {
        setAllEvents(resp);
        setFiltered(resp);
      } else {
        if (isEnvBrowser()) {
          setAllEvents(ApiEvents);
          setFiltered(ApiEvents);
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
      {racers && (
        <Racers
          event={racers}
          close={() => {
            setRacers(null);
          }}
        />
      )}
      {chat && (
        <Chat
          id={chat}
          setId={() => {
            setChat(null);
          }}
          isAdmin
        />
      )}
      {event && <Details isAdmin />}
      <Stack p="sm" mt={2}>
        <Group ml="auto">
          <TextInput
            classNames={global}
            size="xs"
            placeholder={lang.search}
            leftSection={<IconSearch style={IconStyle} />}
            onChange={(e) => {
              handleSearch(e.currentTarget.value);
            }}
          />
          <Button
            size="xs"
            color="var(--accent)"
            variant="outline"
            onClick={() => {
              showCreator(true);
            }}
          >
            {lang.create_event_button}
          </Button>
        </Group>
        <ScrollArea h={`calc(var(--admin-content-h) - 70px)`} type="hover" scrollbars="y" scrollbarSize={6}>
          <Table>
            <Table.Thead>
              <Table.Tr>
                <Table.Th>{lang.title}</Table.Th>
                <Table.Th>{lang.track}</Table.Th>
                <Table.Th>{lang.class}</Table.Th>
                <Table.Th>{lang.host}</Table.Th>
                <Table.Th>{lang.racers}</Table.Th>
                <Table.Th>{lang.starts_in}</Table.Th>
                <Table.Th>{lang.actions}</Table.Th>
              </Table.Tr>
            </Table.Thead>
            <Table.Tbody>
              {filtered.map((element) => (
                <Table.Tr key={element.identifier}>
                  <Table.Td maw={200}>{element.title}</Table.Td>
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
                    {element.started ? (
                      <Text>{lang.started}</Text>
                    ) : (
                      <Timer deadline={element.seconds} hide />
                    )}
                  </Table.Td>
                  <Table.Td>
                    <Group>
                      {!element.started && (
                        <Tooltip
                          label={lang.start_race}
                          color="var(--tooltip)"
                          fz="xs"
                        >
                          <ActionIcon
                            size="xs"
                            variant="transparent"
                            color="var(--light-green)"
                            onClick={() => {
                              fetchNui("av_racing", "startRace", element);
                            }}
                          >
                            <IconPlayerPlay style={IconStyle} />
                          </ActionIcon>
                        </Tooltip>
                      )}
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
                          <UsersRound style={IconStyle} />
                        </ActionIcon>
                      </Tooltip>
                      <Tooltip
                        label={lang.open_chat}
                        color="var(--tooltip)"
                        fz="xs"
                      >
                        <ActionIcon
                          size="xs"
                          variant="transparent"
                          color="indigo.3"
                          onClick={() => {
                            setChat(element.identifier);
                          }}
                        >
                          <IconMessage />
                        </ActionIcon>
                      </Tooltip>
                      <Tooltip
                        label={lang.delete_event}
                        color="var(--tooltip)"
                        fz="xs"
                      >
                        <ActionIcon
                          size="xs"
                          variant="transparent"
                          color="red.4"
                          onDoubleClick={() => {
                            fetchNui(
                              "av_racing",
                              "deleteEvent",
                              element.identifier,
                            );
                          }}
                        >
                          <IconTrash style={IconStyle} />
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
export default Live;
