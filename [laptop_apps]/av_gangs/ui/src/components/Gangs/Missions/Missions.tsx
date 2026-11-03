import { Grid, ScrollArea, Group, Text, TextInput } from "@mantine/core";
import { Crew } from "./Crew";
import { useEffect, useState } from "react";
import { MissionCard } from "./MissionCard";
import { GroupType, MissionType } from "../../../types/types";
import { IconWallet, IconSearch } from "@tabler/icons-react";
import {
  fetchNui,
  isEnvBrowser,
  useNuiEvent,
} from "../../../hooks/useNuiEvents";
import { ApiMissions } from "../../../api/Missions";
import { calculateLevel } from "../../../hooks/calculateLevel";
import { useRecoilValue } from "recoil";
import { Gang, Lang } from "../../../reducers/atoms";
import { useMediaQuery } from "@mantine/hooks";
import { Loading } from "../../Loading";
import { ApiCrew } from "../../../api/Crew";
import classes from "./style.module.css";
import global from "../../../global.module.css";

const Heists = () => {
  const daLang: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(false);
  const [filteredMissions, setFilteredMissions] = useState<MissionType[]>([]);
  const [missions, setMissions] = useState<MissionType[]>([]);
  const [myCrew, setMyCrew] = useState<GroupType | null>(null);
  const [showCrew, setShowCrew] = useState(true);
  const [money, setMoney] = useState(0);
  const { level, max } = useRecoilValue(Gang);
  const calculatedLevel = calculateLevel(level, max);
  const isWide = useMediaQuery("(min-width: 1400px)");

  const handleSearch = (input: string) => {
    const res = missions.filter((mission) =>
      mission.label ? mission.label.toLowerCase().includes(input) : false,
    );
    setFilteredMissions(res);
  };
  useNuiEvent("updateMission", (data: any) => {
    const updated = missions.map((mission) => {
      if (mission.identifier === data.name) {
        return {
          ...mission,
          started: data.status,
        };
      }
      return mission;
    });
    setMissions(updated);
    setFilteredMissions(updated);
  });

  useNuiEvent("updateMoney", (amount: number) => {
    setMoney(amount);
  });

  const handleStart = async (mission: MissionType) => {
    fetchNui("av_gangs", "startMission", mission);
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_gangs", "getMissions");
      if (resp) {
        if (resp.missions) {
          const filtered: MissionType[] = resp.missions.sort(
            (a: MissionType, b: MissionType) => a.difficulty - b.difficulty,
          );
          setMissions(filtered);
          setFilteredMissions(filtered);
        }
        setShowCrew(resp.crew);
        setMoney(resp.money);
      } else {
        if (isEnvBrowser()) {
          const filtered: MissionType[] = ApiMissions.sort(
            (a: MissionType, b: MissionType) => a.difficulty - b.difficulty,
          );
          setMissions(filtered);
          setFilteredMissions(filtered);
        }
      }
      const crew = await fetchNui("av_gangs", "getCrew");
      if (crew) {
        setMyCrew(crew);
      } else {
        if (isEnvBrowser()) {
          setMyCrew(ApiCrew);
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
    <Grid>
      {showCrew && (
        <Grid.Col maw={270}>
          <Crew myCrew={myCrew} setMyCrew={setMyCrew} />
        </Grid.Col>
      )}
      <Grid.Col span="auto">
        <Group className={classes.card} p="md">
          <Text
            fz="1.35rem"
            c="white"
            ff="Bebas Neue"
            fw={500}
            lts={1.55}
          >{`${missions.length} ${daLang.missions_header}`}</Text>
          <Group ml="auto">
            <Group gap="xs" mr="xs">
              <IconWallet
                style={{ height: "16px", width: "16px" }}
                color="#63e6be"
                stroke={1.5}
              />
              <Text fw={500} fz="sm" c="white">{`${daLang.money_symbol}${
                money ? money.toLocaleString("en-US") : 0
              }`}</Text>
            </Group>
            <TextInput
              classNames={global}
              size="xs"
              placeholder={daLang.search}
              leftSection={<IconSearch size={16} stroke={1.5} />}
              onChange={(e) => {
                handleSearch(e.currentTarget.value);
              }}
            />
          </Group>
        </Group>
        <ScrollArea
          mt="xs"
          className={classes.scroll}
          offsetScrollbars
          type="hover"
          scrollbars="y"
          scrollbarSize={5}
        >
          <Grid>
            {filteredMissions.map((mission) => (
              <Grid.Col maw={isWide ? 295 : 255}>
                <MissionCard
                  key={mission.identifier}
                  res={calculatedLevel}
                  mission={mission}
                  lang={daLang}
                  handleStart={handleStart}
                  isWide={isWide}
                />
              </Grid.Col>
            ))}
          </Grid>
        </ScrollArea>
      </Grid.Col>
    </Grid>
  );
};

export default Heists;
