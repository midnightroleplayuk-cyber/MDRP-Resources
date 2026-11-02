import { useEffect, useState } from "react";
import {
  Tooltip,
  Stack,
  Group,
  Text,
  Flex,
  Grid,
  ActionIcon,
  ScrollArea,
} from "@mantine/core";
import { useAtomValue } from "jotai";
import { Lang } from "../../../../reducers/atoms";
import {
  IconMapPinShare,
  IconEdit,
  IconTrash,
  IconBug,
} from "@tabler/icons-react";
import { fetchNui, isEnvBrowser } from "../../../../hooks/useNuiEvents";
import { Loading } from "../../../Loading";
import { ApiZones } from "../../../../API/admin";
import { ZoneType } from "../../../../types/types";
import classes from "./style.module.css";

export const Zones = ({ job }: { job: string | null }) => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.admin;
  const [loaded, setLoaded] = useState(false);
  const [allZones, setAllZones] = useState<ZoneType[]>([]);

  const teleport = (coords: { x: number; y: number; z: number }) => {
    fetchNui("av_laptop", "teleport", coords);
  };

  const deleteZone = (name: string) => {
    const updated = allZones.filter((zone) => zone.name !== name);
    setAllZones(updated);
    fetchNui("av_business", "deleteZone", { name, job });
  };

  const editZone = (zone: ZoneType) => {
    fetchNui("av_business", "editZone", zone);
  };
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getAdminZone", job);
      if (resp) {
        setAllZones(resp);
      } else {
        if (isEnvBrowser()) {
          setAllZones(ApiZones);
        }
      }
    };
    setTimeout(() => {
      setLoaded(true);
    }, 100);
    fetchData();
  }, [job]);

  if (!loaded) return <Loading />;
  return (
    <ScrollArea h={530} type="hover" scrollbars="y" scrollbarSize={5}>
      <Grid gap="xs">
        {allZones.map((zone) => (
          <Grid.Col span={2}>
            <Stack className={classes.card} p="md">
              <Flex direction="column" flex={1}>
                <Text c="var(--text-dim)" fz="xs">
                  {lang.zones_zone_id}
                </Text>
                <Text fz="xs" c="var(--text-main)">
                  {zone.name}
                </Text>
              </Flex>
              <Flex direction="column" flex={1}>
                <Text c="var(--text-dim)" fz="xs">
                  {lang.type}
                </Text>
                <Text fz="xs" tt="capitalize" c="var(--text-main)">
                  {zone.type}
                </Text>
              </Flex>
              <Group justify="center">
                <Tooltip
                  label={lang.zones_teleport}
                  color="var(--tooltip)"
                  fz="xs"
                >
                  <ActionIcon
                    size="xs"
                    variant="transparent"
                    onClick={() => {
                      teleport(zone.data.coords);
                    }}
                  >
                    <IconMapPinShare
                      style={{ height: 14, width: 14 }}
                      stroke={1.5}
                    />
                  </ActionIcon>
                </Tooltip>
                <Tooltip label={lang.zones_edit} color="var(--tooltip)" fz="xs">
                  <ActionIcon
                    size="xs"
                    variant="transparent"
                    color="orange"
                    onClick={() => {
                      editZone(zone);
                    }}
                  >
                    <IconEdit style={{ height: 14, width: 14 }} stroke={1.5} />
                  </ActionIcon>
                </Tooltip>
                <Tooltip
                  label={lang.zones_debug}
                  color="var(--tooltip)"
                  fz="xs"
                >
                  <ActionIcon
                    size="xs"
                    variant="transparent"
                    color="teal"
                    onClick={() => {
                      fetchNui("av_business", "toggleDebug", {
                        name: zone.name,
                        type: zone.type,
                      });
                    }}
                  >
                    <IconBug style={{ height: 14, width: 14 }} stroke={1.5} />
                  </ActionIcon>
                </Tooltip>
                <Tooltip
                  label={lang.zones_delete}
                  color="var(--tooltip)"
                  fz="xs"
                >
                  <ActionIcon
                    size="xs"
                    variant="transparent"
                    color="red"
                    onDoubleClick={() => {
                      deleteZone(zone.name);
                    }}
                  >
                    <IconTrash style={{ height: 14, width: 14 }} stroke={1.5} />
                  </ActionIcon>
                </Tooltip>
              </Group>
            </Stack>
          </Grid.Col>
        ))}
      </Grid>
    </ScrollArea>
  );
};
