import { useEffect, useState } from "react";
import {
  Stack,
  Group,
  TextInput,
  Button,
  ScrollArea,
  Table,
  Text,
  Tooltip,
  ActionIcon,
} from "@mantine/core";

import {
  Search as IconSearch,
  Copy as IconCopy,
  Trash as IconTrash,
  Eye as IconEye,
  Edit as IconEdit,
  List as IconList,
} from "lucide-react";
import { TrackType } from "../../../types/types";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { ApiTracks } from "../../../Api/Tracks";
import { Loading } from "../../Loading";
import { sortData } from "./utils";
import { Details } from "../../MainApp/Tabs/Tracks/Details";
import { Records } from "../../Records/Records";
import { ApiTrack } from "../../../Api/Track";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";
import Th from "./Th";
import global from "../../../global.module.css";

const Tracks = () => {
  const lang: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(false);
  const [search, setSearch] = useState("");
  const [circuit, setCircuit] = useState<TrackType | null>(null);
  const [allTracks, setAllTracks] = useState<TrackType[]>([]);
  const [filtered, setFiltered] = useState<TrackType[]>([]);
  const [reversed, setReversed] = useState(false);
  const [sortBy, setSortBy] = useState<keyof TrackType | null>(null);
  const [recordsTrack, setRecordsTrack] = useState<TrackType | null>(null);

  const IconStyle = { height: 14, width: 14 };

  const setSorting = (field: keyof TrackType) => {
    const res: boolean = field === sortBy ? !reversed : false;
    setReversed(res);
    setSortBy(field);
    setFiltered(sortData(allTracks, { sortBy: field, reversed: res, search }));
  };

  const handleSearch = (input: string) => {
    setSearch(input);
    const res = allTracks.filter((track) =>
      track.name ? track.name.toLowerCase().includes(input) : false,
    );
    setFiltered(res);
  };

  const handlePreview = async (identifier: string) => {
    const track = isEnvBrowser()
      ? ApiTrack
      : await fetchNui("av_racing", "getTrack", identifier);
    setCircuit(track);
  };
  const handleDelete = (identifier: string) => {
    const result = allTracks.filter((track) => track.identifier !== identifier);
    setAllTracks(result);
    setFiltered(result);
    fetchNui("av_racing", "deleteTrack", identifier);
  };

  const handleRecords = (track: TrackType) => {
    setRecordsTrack(track);
  };
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getAllTracks");
      if (resp) {
        setAllTracks(resp);
        setFiltered(resp);
      } else {
        if (isEnvBrowser()) {
          setAllTracks(ApiTracks);
          setFiltered(ApiTracks);
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
      {circuit && (
        <Details
          track={circuit}
          handleClose={() => {
            setCircuit(null);
          }}
          isAdmin
        />
      )}
      {recordsTrack && (
        <Records
          track={recordsTrack}
          closeTrack={setRecordsTrack}
          isAdmin={true}
        />
      )}
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
              fetchNui("av_racing", "newCircuit");
            }}
          >
            {lang.create_track}
          </Button>
        </Group>
        <ScrollArea h={`calc(var(--admin-content-h) - 70px)`} type="hover" scrollbars="y" scrollbarSize={6}>
          <Table>
            <Table.Thead>
              <Table.Tr>
                <Th
                  type="name"
                  sorted={sortBy === "name"}
                  reversed={reversed}
                  onSort={() => setSorting("name")}
                >
                  {lang.name}
                </Th>
                <Th
                  type="checkpointTotal"
                  sorted={sortBy === "checkpointTotal"}
                  reversed={reversed}
                  onSort={() => setSorting("checkpointTotal")}
                >
                  {lang.checkpoints}
                </Th>
                <Table.Th>{lang.created_by}</Table.Th>
                <Th
                  type="distance"
                  sorted={sortBy === "distance"}
                  reversed={reversed}
                  onSort={() => setSorting("distance")}
                >
                  {lang.distance}
                </Th>
                <Th
                  type="type"
                  sorted={sortBy === "type"}
                  reversed={reversed}
                  onSort={() => setSorting("type")}
                >
                  {lang.type}
                </Th>
                <Table.Th fw={500} fz="sm">
                  {lang.actions}
                </Table.Th>
              </Table.Tr>
            </Table.Thead>
            <Table.Tbody>
              {filtered.map((element) => (
                <Table.Tr key={element.identifier}>
                  <Table.Td maw={200}>{element.name}</Table.Td>
                  <Table.Td maw={200} ta="center">
                    {element.checkpointTotal}
                  </Table.Td>
                  <Table.Td>
                    <Group gap={5}>
                      <Text fz={13}>{element.createdby}</Text>
                      <Tooltip label={lang.copy} color="var(--tooltip)" fz="xs">
                        <ActionIcon
                          size="xs"
                          variant="transparent"
                          ml="auto"
                          onClick={() => {
                            fetchNui("av_laptop", "copy", element.createdby);
                          }}
                        >
                          <IconCopy style={{ height: 14, width: 14 }} />
                        </ActionIcon>
                      </Tooltip>
                    </Group>
                  </Table.Td>
                  <Table.Td maw={200}>{element.distance}</Table.Td>
                  <Table.Td maw={200}>{element.type}</Table.Td>
                  <Table.Td>
                    <Group>
                      <Tooltip
                        label={lang.edit_circuit}
                        color="var(--tooltip)"
                        fz="xs"
                      >
                        <ActionIcon
                          size="xs"
                          variant="transparent"
                          color="cyan.3"
                          onClick={() => {
                            fetchNui(
                              "av_racing",
                              "editCircuit",
                              element.identifier,
                            );
                          }}
                        >
                          <IconEdit style={IconStyle} />
                        </ActionIcon>
                      </Tooltip>
                      <Tooltip
                        label={lang.preview_circuit}
                        color="var(--tooltip)"
                        fz="xs"
                      >
                        <ActionIcon
                          size="xs"
                          variant="transparent"
                          color="indigo.3"
                          onClick={() => {
                            handlePreview(element.identifier);
                          }}
                        >
                          <IconEye style={IconStyle} />
                        </ActionIcon>
                      </Tooltip>
                      <Tooltip
                        label={lang.records}
                        color="var(--tooltip)"
                        fz="xs"
                      >
                        <ActionIcon
                          size="xs"
                          variant="transparent"
                          color="yellow.3"
                          onClick={() => {
                            handleRecords(element);
                          }}
                        >
                          <IconList style={IconStyle} />
                        </ActionIcon>
                      </Tooltip>
                      <Tooltip
                        label={lang.delete_track}
                        color="var(--tooltip)"
                        fz="xs"
                      >
                        <ActionIcon
                          size="xs"
                          variant="transparent"
                          color="red.4"
                          onDoubleClick={() => {
                            handleDelete(element.identifier);
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
export default Tracks;
