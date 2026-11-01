import { useEffect, useState, useMemo } from "react";
import { Box, Avatar, ScrollArea } from "@mantine/core";
import { RacerLeaderboardType } from "../../../../types/types";
import { fetchNui, isEnvBrowser } from "../../../../hooks/useNuiEvents";
import { ApiLeaderboard } from "../../../../Api/Leaderboard";
import { getItemsPerPage, paginate, sortData } from "./utils";
import { Loading } from "../../../Loading";
import { getRankedLeaderboard } from "../../../../hooks/sortbyElo";
import classes from "./style.module.css";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../../reducers/atoms";
import { Crown } from "lucide-react";
import { RacerProfile } from "./RacerProfile";

interface Properties {
  height: number;
  setCount: (amount: number) => void;
  setTotalPages: (amount: number) => void;
  activePage: number;
  setPage: (page: number) => void;
  search: string;
  season: string | null;
  sortBy: keyof RacerLeaderboardType;
}

export const Racers = ({
  height,
  setCount,
  setTotalPages,
  activePage,
  search,
  season,
  sortBy,
}: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(false);
  const [allRacers, setAllRacers] = useState<RacerLeaderboardType[]>([]);
  const [selected, setSelected] = useState<{ id: string; name: string } | null>(
    null,
  );
  const itemsPerPage = getItemsPerPage(height);

  const paginatedRacers = useMemo(() => {
    let processedRacers = allRacers.filter((racer) =>
      racer.name?.toLowerCase().includes(search.toLowerCase()),
    );
    processedRacers = sortData(processedRacers, {
      sortBy,
      reversed: sortBy !== "name",
      search,
    });
    setCount(processedRacers.length);
    setTotalPages(Math.ceil(processedRacers.length / itemsPerPage));
    return paginate(processedRacers, activePage, itemsPerPage);
  }, [
    allRacers,
    search,
    activePage,
    itemsPerPage,
    setCount,
    setTotalPages,
    sortBy,
  ]);

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getSeason", season);
      let dataToProcess: RacerLeaderboardType[] = [];
      if (resp) {
        dataToProcess = getRankedLeaderboard(resp);
      } else if (isEnvBrowser()) {
        dataToProcess = getRankedLeaderboard(ApiLeaderboard);
      }
      setAllRacers(dataToProcess);
      setLoaded(true);
    };
    fetchData();
  }, [season]);

  if (!loaded) return <Loading />;

  return (
    <>
    <ScrollArea
      h="100%"
      type="hover"
      scrollbars="y"
      offsetScrollbars
      scrollbarSize={6}
    >
      <Box className={classes.listContainer}>
        {paginatedRacers.map((racer) => {
          const rank = racer.ranking || 0;
          const isTop1 = rank === 1;
          const isTop2 = rank === 2;
          const isTop3 = rank === 3;

          let rowClass = classes.racerRow;
          let rankClass = classes.rankTextOther;

          if (isTop1) {
            rowClass += ` ${classes.rank1}`;
            rankClass = classes.rankText1;
          } else if (isTop2) {
            rowClass += ` ${classes.rank2}`;
            rankClass = classes.rankText2;
          } else if (isTop3) {
            rowClass += ` ${classes.rank3}`;
            rankClass = classes.rankText3;
          }

          return (
            <Box
              className={`${rowClass} ${classes.clickable}`}
              key={racer.identifier}
              onClick={() =>
                setSelected({ id: racer.identifier, name: racer.name })
              }
            >
              <Box className={classes.racerInfo}>
                <Box className={`${classes.rankBox} ${rankClass}`}>#{rank}</Box>
                <Avatar src={racer.photo} size="md" radius="sm" />
                <Box className={classes.nameBlock}>
                  <div className={classes.racerName}>
                    <span className={classes.nameText}>{racer.name}</span>
                    {isTop1 && (
                      <Crown size={14} color="#ffd700" fill="#ffd700" />
                    )}
                  </div>
                  <span className={classes.racerCrew}>
                    {racer.crewLabel || "N/A"}
                  </span>
                </Box>
              </Box>

              <Box className={classes.statsContainer}>
                <Box className={classes.statBlock}>
                  <span className={classes.statLabel}>
                    {lang.season_races ?? "RACES"}
                  </span>
                  <span className={classes.statValue}>{racer.races}</span>
                </Box>
                <Box className={classes.statBlock}>
                  <span className={classes.statLabel}>
                    {lang.season_victories ?? "WINS"}
                  </span>
                  <span className={classes.statValue}>{racer.wins}</span>
                </Box>
                <Box className={classes.statBlock}>
                  <span className={classes.statLabel}>
                    {lang.season_elo ?? "TOTAL ELO"}
                  </span>
                  <span className={classes.statValueAccent}>{racer.elo}</span>
                </Box>
              </Box>
            </Box>
          );
        })}
      </Box>
    </ScrollArea>
    {selected && (
      <RacerProfile
        identifier={selected.id}
        fallbackName={selected.name}
        onClose={() => setSelected(null)}
      />
    )}
    </>
  );
};
