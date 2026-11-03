import { useEffect, useState } from "react";
import {
  Box,
  ScrollArea,
  TextInput,
  Stack,
  Group,
  Button,
  Flex,
  Text,
} from "@mantine/core";
import { fetchNui, isEnvBrowser } from "../../hooks/useNuiEvents";
import { DemoZones } from "../../API/labData";
import classes from "../style.module.css";
import { Loading } from "../../components/Loading";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";

interface ZoneTypes {
  drug: string;
  label: string;
  name: string;
  strain: string;
}

export const Zones = () => {
  const { admin: lang }: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(isEnvBrowser());
  const [allZones, setAllZones] = useState<ZoneTypes[]>(
    isEnvBrowser() ? DemoZones : []
  );
  const [currentZones, setCurrentZones] = useState<ZoneTypes[]>(
    isEnvBrowser() ? DemoZones : []
  );

  const handleSearch = (input: string) => {
    if (input == "") {
      setCurrentZones(allZones);
      return;
    }
    const res = allZones.filter((zone: ZoneTypes) =>
      zone.label.toLowerCase().includes(input.toLowerCase())
    );
    setCurrentZones(res);
  };
  const handleWipe = (name: string) => {
    fetchNui("av_drugs", "wipeZone", name);
    const res = allZones.map((zone) =>
      zone.name === name
        ? { ...zone, drug: "N/A", strain: "N/A" } // Update drug and strain fields
        : zone
    );
    setAllZones(res);
    setCurrentZones(res);
  };
  const wipeAll = () => {
    fetchNui("av_drugs", "wipeAll");
    const res = allZones.map((zone) => ({
      ...zone,
      drug: "N/A",
      strain: "N/A",
    }));
    setAllZones(res);
    setCurrentZones(res);
  };
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_drugs", "getAdminZones");
      if (resp) {
        setAllZones(resp);
        setCurrentZones(resp);
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, []);
  if (!loaded) return <Loading />;
  return (
    <Box p="sm">
      <Group>
        <TextInput
          classNames={classes}
          placeholder={lang.search_placeholder}
          onChange={(e) => {
            handleSearch(e.target.value);
          }}
          size="xs"
          w={255}
        />
        <Button
          ml="auto"
          size="xs"
          color="red"
          onDoubleClick={() => {
            wipeAll();
          }}
        >
          {lang.reset_all}
        </Button>
      </Group>
      <ScrollArea
        h={"45vh"}
        type="hover"
        scrollbars="y"
        offsetScrollbars
        scrollbarSize={7}
        mt="sm"
      >
        <Stack gap="xs">
          {currentZones.map((zone, index) => (
            <Group
              bg={index % 2 == 0 ? "rgba(80,80,80,0.25)" : "transparent"}
              key={zone.name}
              p="sm"
            >
              <Text w={150} truncate fz="sm" fw={500}>
                {zone.label}
              </Text>
              <Flex direction="column" ml={"auto"}>
                <Text fz="sm">{zone.drug}</Text>
                <Text c="dimmed" fz="xs">
                  {lang.popular_drug}
                </Text>
              </Flex>
              <Flex direction="column" ml={"auto"}>
                <Text fz="sm">{zone.strain}</Text>
                <Text c="dimmed" fz="xs">
                  {lang.popular_strain}
                </Text>
              </Flex>
              <Button
                ml="auto"
                variant="subtle"
                size="xs"
                color="red"
                onDoubleClick={() => {
                  handleWipe(zone.name);
                }}
              >
                {lang.reset_zone}
              </Button>
            </Group>
          ))}
        </Stack>
      </ScrollArea>
    </Box>
  );
};
