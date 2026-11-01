import { useEffect, useState } from "react";
import {
  Card,
  Image,
  Text,
  Stack,
  Group,
  ActionIcon,
  Tooltip,
} from "@mantine/core";
import { fetchNui, isEnvBrowser } from "../../../../../hooks/useNuiEvents";
import { Loading } from "../../../../Loading";
import { ApiGang } from "../../../../../api/Gang";
import { GangType } from "../../../../../types/types";
import { calculateLevel } from "../../../../../hooks/calculateLevel";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../../../reducers/atoms";
import { IconCopy } from "@tabler/icons-react";
import classes from "./style.module.css";

interface Properties {
  gang: string;
}

export const Overview = ({ gang }: Properties) => {
  const daLang: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(false);
  const [gangData, setGangData] = useState<GangType | null>(null);
  const [calculated, setCalculated] = useState({
    level: 5,
    percentage: 50,
    remaining: 20,
  });
  const fetchData = async () => {
    if (!gang) return;
    setLoaded(false);
    const resp = await fetchNui("av_gangs", "fetchGang", gang);
    if (resp) {
      setGangData(resp);
      const calc = calculateLevel(resp.level, resp.max);
      setCalculated(calc);
    } else {
      if (isEnvBrowser()) {
        setGangData(ApiGang);
      }
    }
    setTimeout(() => {
      setLoaded(true);
    }, 100);
  };
  useEffect(() => {
    fetchData();
  }, [gang]);
  if (!loaded) return <Loading />;
  return (
    <>
      {!gangData ? null : (
        <Card
          className={classes.card}
          ml="auto"
          mr="auto"
          mt="sm"
          w={350}
          p="md"
        >
          <Text
            ff="Bebas Neue"
            ta="center"
            fz="1.65rem"
            c="white"
            fw={500}
            lts={2}
          >
            {gangData.label}
          </Text>
          <Stack mt="xs" ta="center" gap="xs">
            <Image
              src={gangData.logo}
              h={155}
              w={155}
              fit="contain"
              ml="auto"
              mr="auto"
              fallbackSrc="gang_default.png"
            />
            <Group justify="center" gap="xs">
              <Text fz="sm" c="dimmed">
                {gangData.name}
              </Text>
              <Tooltip label="Copy gang name" color="dark.6" fz="xs">
                <ActionIcon
                  size="xs"
                  variant="transparent"
                  onClick={() => {
                    fetchNui("av_laptop", "copy", gangData.name);
                  }}
                >
                  <IconCopy
                    style={{ height: "14px", width: "14px" }}
                    stroke={1.5}
                  />
                </ActionIcon>
              </Tooltip>
            </Group>
            <Stack ml="auto" mr="auto" gap="xs" w={200}>
              <Group gap="xs" ff="Bebas Neue" lts={2}>
                <Text c="var(--color-main)" fz="1.05rem">
                  {`${daLang.level}:`}
                </Text>
                <Text c="gray" fz="1.05rem" ml="auto">
                  {calculated.level}
                </Text>
              </Group>
              <Group gap="xs" ff="Bebas Neue" lts={2}>
                <Text c="var(--color-main)" fz="1.05rem">
                  {`${daLang.members}:`}
                </Text>
                <Text c="gray" fz="1.05rem" ml="auto">
                  {gangData.members}
                </Text>
              </Group>
              <Group gap="xs" ff="Bebas Neue" lts={2}>
                <Text c="var(--color-main)" fz="1.05rem">
                  {`${daLang.graffitis}`}
                </Text>
                <Text c="gray" fz="1.05rem" ml="auto">
                  {gangData.graffitis}
                </Text>
              </Group>
              <Group gap="xs" ff="Bebas Neue" lts={2}>
                <Text c="var(--color-main)" fz="1.05rem">
                  {`${daLang.strain}:`}
                </Text>
                <Text c="gray" fz="1.05rem" ml="auto">
                  {gangData.strain}
                </Text>
              </Group>
            </Stack>
          </Stack>
        </Card>
      )}
    </>
  );
};
