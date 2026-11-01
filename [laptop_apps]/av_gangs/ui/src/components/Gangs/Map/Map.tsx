import { useRecoilValue } from "recoil";
import { Territories } from "./Territories";
import { Gang } from "../../../reducers/atoms";
import { useEffect, useState } from "react";
import { Grid } from "@mantine/core";
import { useViewportSize } from "@mantine/hooks";
import { Loading } from "../../Loading";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { ApiTerritories } from "../../../api/Territories";
import { GangStats, ZoneType } from "../../../types/types";
import { Leaderboard } from "./Leaderboard";
import { getGangRankings } from "./getGangLeaderboard";
import { ApiLeaderboard } from "../../../api/Leaderboard";
import { ApiAllGangs } from "../../../api/Gang";
import { GraffitiType } from "../../Admin/Graffitis/types";
import { filterGraffitis } from "./helpers";
import { ApiGraffitis } from "../../../api/Graffitis";

const Map = () => {
  const { name } = useRecoilValue(Gang);
  const [loaded, setLoaded] = useState(false);
  const [zones, setZones] = useState<ZoneType[]>([]);
  const [filtered, setFiltered] = useState<ZoneType[]>([]);
  const [leaderboardData, setLeaderboardData] = useState<null | GangStats[]>(
    null,
  );
  const [myCoords, setMyCoords] = useState({ x: 0.0, y: 10.0, z: 20.0 });
  const { height } = useViewportSize();
  const [current, setCurrent] = useState<null | string>(null);
  const [allGraffitis, setAllGraffitis] = useState<GraffitiType[]>([]);

  const handleCurrent = (gang: string | null) => {
    setCurrent(gang);
    if (!gang) {
      setFiltered(zones);
    } else {
      const results = zones.filter((zone) => zone.name === gang);
      setFiltered(results);
    }
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_gangs", "getTerritories", name);
      if (resp) {
        setMyCoords(resp.myCoords);
        setZones(resp.territories);
        setFiltered(resp.territories);
        const graffitis = filterGraffitis(
          resp.graffitis,
          resp.discovered,
          name,
        );
        setAllGraffitis(resp.alwaysRender ? resp.graffitis : graffitis);
        if (resp.leaderboard) {
          const filtered = getGangRankings(resp.leaderboard, resp.allGangs, resp.minPoints);
          setLeaderboardData(filtered);
        }
      } else {
        if (isEnvBrowser()) {
          setZones(ApiTerritories);
          setFiltered(ApiTerritories);
          const filtered = getGangRankings(ApiLeaderboard, ApiAllGangs);
          setLeaderboardData(filtered);
          const graffitis = filterGraffitis(ApiGraffitis, ["TFLC9BKK5"], name);
          setAllGraffitis(graffitis);
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
    <Grid h={height / 1.25}>
      {leaderboardData && (
        <Grid.Col maw={350}>
          <Leaderboard
            gangs={leaderboardData}
            handleCurrent={handleCurrent}
            current={current}
          />
        </Grid.Col>
      )}
      <Grid.Col span="auto">
        <Territories
          myCoords={myCoords}
          zones={filtered}
          graffitis={allGraffitis}
        />
      </Grid.Col>
    </Grid>
  );
};

export default Map;
