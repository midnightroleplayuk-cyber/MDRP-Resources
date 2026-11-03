import {
  Grid,
  Box,
  Stack,
  Text,
  Group,
  ScrollArea,
  Tooltip,
  ActionIcon,
} from "@mantine/core";
import { useEffect, useState } from "react";
import { IconMapPinPlus, IconSearch, IconList } from "@tabler/icons-react";
import { Loading } from "../../Loading";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { ApiDoors } from "../../../api/Doors";
import { DoorType } from "../../../types/types";
import { DoorComponent } from "./Element";
import { MapZone } from "./MapZone";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";

const Doors = () => {
  const daLang: any = useRecoilValue(Lang);
  const lang = daLang.admin;
  const [loaded, setLoaded] = useState(false);
  const [allDoors, setAllDoors] = useState<DoorType[]>([]);
  const [added, setAdded] = useState<string[]>([]);
  const [closest, setClosest] = useState<DoorType | null>(null);
  const [playerCoords, setPlayerCoords] = useState({ x: 0.0, y: 0.0, z: 0.0 });

  const updateCoords = async () => {
    const resp = await fetchNui("av_gangs", "getPlayerCoords");
    setPlayerCoords(resp);
  };

  const handleAdd = async () => {
    const resp = await fetchNui("av_gangs", "getCoords", allDoors);
    updateCoords();
    if (resp) {
      const updated = [...allDoors, resp];
      setAllDoors(updated);
      setAdded((prev) => [...prev, resp.identifier]);
      fetchNui("av_gangs", "saveCoords", updated);
    }
  };
  const handleClosest = async () => {
    updateCoords();
    if (closest) {
      setClosest(null);
    } else {
      const resp = await fetchNui("av_gangs", "closestDoor", allDoors);
      if (resp) {
        setClosest(resp);
      }
    }
  };
  const handleDelete = async (door: DoorType) => {
    const resp = await fetchNui("av_gangs", "deleteDoorZone", door.identifier);
    if (resp) {
      setAllDoors(resp);
    }
    if (closest) {
      setClosest(null);
    }
  };
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_gangs", "getDoors");
      if (resp) {
        updateCoords();
        setAllDoors(resp);
      } else {
        if (isEnvBrowser()) {
          setAllDoors(ApiDoors);
        }
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    if (!loaded) {
      fetchData();
    }
  }, [playerCoords]);

  if (!loaded) return <Loading />;
  return (
    <Box p="sm" ta="center">
      <Text fz="xl" c="white" fw={500}>
        {lang.doors_title}
      </Text>
      <Text fz="xs" c="dimmed">
        {lang.doors_subtitle1}
      </Text>
      <Text fz="xs" c="dimmed">
        {lang.doors_subtitle2}
      </Text>
      <Grid mt="sm">
        <Grid.Col maw={400}>
          <Stack gap="xs">
            <Group>
              <Text c="white" fz="sm">
                {closest
                  ? lang.closest_location
                  : `${allDoors.length} ${lang.locations}`}
              </Text>
              <Group ml="auto" gap="xs">
                <Tooltip
                  label={closest ? lang.all_doors : lang.get_closest}
                  color="dark.5"
                  position="top-start"
                >
                  <ActionIcon
                    size="sm"
                    variant="transparent"
                    color="yellow"
                    onClick={handleClosest}
                  >
                    {closest ? (
                      <IconList style={{ height: "16px", width: "16px" }} />
                    ) : (
                      <IconSearch style={{ height: "16px", width: "16px" }} />
                    )}
                  </ActionIcon>
                </Tooltip>
                <Tooltip
                  label={lang.add_coords}
                  color="dark.5"
                  position="top-start"
                >
                  <ActionIcon
                    size="sm"
                    variant="transparent"
                    color="indigo.4"
                    onDoubleClick={handleAdd}
                  >
                    <IconMapPinPlus style={{ height: "16px", width: "16px" }} />
                  </ActionIcon>
                </Tooltip>
              </Group>
            </Group>
            <ScrollArea
              h={400}
              offsetScrollbars
              type="hover"
              scrollbars="y"
              scrollbarSize={5}
            >
              <Stack gap={3}>
                {closest ? (
                  <DoorComponent
                    door={closest}
                    bg={true}
                    isNew={false}
                    playerCoords={playerCoords}
                    updateCoords={updateCoords}
                    handleDelete={handleDelete}
                  />
                ) : (
                  allDoors.map((door, index) => (
                    <DoorComponent
                      door={door}
                      bg={index % 2 == 0}
                      isNew={added.includes(door.identifier)}
                      playerCoords={playerCoords}
                      updateCoords={updateCoords}
                      handleDelete={handleDelete}
                    />
                  ))
                )}
              </Stack>
            </ScrollArea>
          </Stack>
        </Grid.Col>
        <Grid.Col span={"auto"}>
          <div
            style={{ height: "430px", width: "100%", backgroundColor: "red" }}
          >
            <MapZone
              myCoords={playerCoords}
              zones={allDoors}
              setSelected={setClosest}
            />
          </div>
        </Grid.Col>
      </Grid>
    </Box>
  );
};

export default Doors;
