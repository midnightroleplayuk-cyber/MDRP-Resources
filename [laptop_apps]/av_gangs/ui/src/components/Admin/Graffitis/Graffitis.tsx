import { useEffect, useState } from "react";
import {
  Box,
  Stack,
  Text,
  Group,
  ActionIcon,
  Tooltip,
  Select,
} from "@mantine/core";
import { Map } from "./Map";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";
import { GraffitiType } from "./types";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { ApiGraffitis } from "../../../api/Graffitis";
import { IconMapPinShare, IconTrash } from "@tabler/icons-react";
import classes from "./style.module.css";
import global from "../../../global.module.css";
import { Loading } from "../../Loading";
import { SelectType } from "../../../types/types";

const Graffitis = () => {
  const daLang: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(false);
  const [allGraffitis, setAllGraffitis] = useState<GraffitiType[]>([]);
  const [filtered, setFiltered] = useState<GraffitiType[]>([]);
  const [current, setCurrent] = useState<GraffitiType | null>(null);
  const [gangOptions, setGangOptions] = useState<SelectType[]>([]);
  const [option, setOption] = useState<string | null>(null);

  const handleFilter = (option: string | null) => {
    setOption(option);
    if (!option) {
      setFiltered(allGraffitis);
      return;
    }
    const results = allGraffitis.filter((graffiti) => graffiti.gang === option);
    setFiltered(results);
  };
  const handleDelete = () => {
    if (!current) return;
    const result = allGraffitis.filter(
      (graffiti) => graffiti.identifier !== current.identifier
    );
    setAllGraffitis(result);
    setFiltered(result);
    fetchNui("av_gangs", "deleteGraffiti", current);
    setCurrent(null);
  };

  const fetchData = async () => {
    setLoaded(false);
    const resp = await fetchNui("av_gangs", "admin:graffitis");
    if (resp) {
      setAllGraffitis(resp.graffitis);
      setFiltered(resp.graffitis);
      setGangOptions(resp.gangs);
    } else {
      if (isEnvBrowser()) {
        setAllGraffitis(ApiGraffitis);
        setFiltered(ApiGraffitis);
        setGangOptions([
          { value: "lossantosvagos", label: "Los Santos Vagos" },
          { value: "ballas", label: "Ballas" },
        ]);
      }
    }
    setTimeout(() => {
      setLoaded(true);
    }, 100);
  };
  useEffect(() => {
    fetchData();
  }, []);
  if (!loaded) return <Loading />;
  return (
    <Box mt={2}>
      <Stack className={classes.component}>
        <Select
          classNames={global}
          styles={{
            input: {
              backgroundColor: "rgba(10,10,10,0.9)",
              color: "white",
            },
          }}
          value={option}
          data={gangOptions}
          placeholder="Filter by gang"
          size="xs"
          w={200}
          onChange={(e) => {
            handleFilter(e);
          }}
          onDropdownOpen={() => {
            setCurrent(null);
          }}
        />
        {current && (
          <Stack className={classes.box} hidden={!current} p="sm" gap={3}>
            <Group gap="xs">
              <Text c="gray.2" fz="sm">
                {`${daLang.identifier}:`}
              </Text>
              <Text c="gray.4" fz="sm">
                {current?.identifier}
              </Text>
            </Group>
            <Group gap="xs">
              <Text c="gray.2" fz="sm">
                {`${daLang.gang}:`}
              </Text>
              <Text c="gray.4" fz="sm">
                {current?.gang}
              </Text>
            </Group>
            <Group gap="xs">
              <Text c="gray.2" fz="sm">
                {daLang.actions}
              </Text>
              <Group gap="xs">
                <Tooltip label={daLang.teleport} color="dark" fz="xs">
                  <ActionIcon
                    size="xs"
                    variant="transparent"
                    onClick={() => {
                      fetchNui("av_laptop", "teleport", {
                        x: current.coords.x,
                        y: current.coords.y,
                        z: current.coords.z,
                      });
                    }}
                  >
                    <IconMapPinShare
                      style={{ height: "14px", width: "14px" }}
                    />
                  </ActionIcon>
                </Tooltip>
                <Tooltip label={daLang.delete} color="dark" fz="xs">
                  <ActionIcon
                    size="xs"
                    variant="transparent"
                    color="red"
                    onDoubleClick={handleDelete}
                  >
                    <IconTrash style={{ height: "14px", width: "14px" }} />
                  </ActionIcon>
                </Tooltip>
              </Group>
            </Group>
          </Stack>
        )}
      </Stack>
      <Map
        graffitis={filtered}
        handleCurrent={setCurrent}
        current={current?.identifier ?? null}
      />
    </Box>
  );
};

export default Graffitis;
