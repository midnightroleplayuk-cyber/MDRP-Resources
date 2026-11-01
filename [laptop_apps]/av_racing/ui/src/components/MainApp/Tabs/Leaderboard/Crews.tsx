import { useEffect, useState, useMemo } from "react";
import { Box, Avatar } from "@mantine/core";
import { fetchNui, isEnvBrowser } from "../../../../hooks/useNuiEvents";
import { getItemsPerPage, getRankedCrews, paginate, sortData } from "./utils";
import { Loading } from "../../../Loading";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../../reducers/atoms";
import { Crown } from "lucide-react";
import classes from "./style.module.css";
import { CrewProperties } from "../../../../types/types";

interface Properties {
  height: number;
  setCount: (amount: number) => void;
  setTotalPages: (amount: number) => void;
  activePage: number;
  setPage: (page: number) => void;
  search: string;
  season: string | null;
  sortBy: keyof CrewProperties;
}

export const Crews = ({
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
  const [allCrews, setAllCrews] = useState<CrewProperties[]>([]);
  const itemsPerPage = getItemsPerPage(height);

  const paginatedCrews = useMemo(() => {
    let processedCrews = allCrews.filter((crew) =>
      crew.name?.toLowerCase().includes(search.toLowerCase()),
    );
    processedCrews = sortData(processedCrews, {
      sortBy,
      reversed: sortBy !== "name",
      search,
    }) as unknown as CrewProperties[];

    setCount(processedCrews.length);
    setTotalPages(Math.ceil(processedCrews.length / itemsPerPage));
    return paginate(processedCrews, activePage, itemsPerPage);
  }, [
    allCrews,
    search,
    activePage,
    itemsPerPage,
    setCount,
    setTotalPages,
    sortBy,
  ]);

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getCrewsLeaderboard", season);
      let dataToProcess: CrewProperties[] = [];
      if (resp) {
        dataToProcess = getRankedCrews(resp);
      } else if (isEnvBrowser()) {
        dataToProcess = [
          {
            name: "apex_racing",
            label: "Apex Coalition",
            members: 12,
            wins: 45,
            ranking: 1,
          },
          {
            label: "Iron Torque",
            name: "2",
            members: 8,
            wins: 30,
            ranking: 2,
          },
          {
            label: "Phoenix Drift",
            name: "3",
            members: 15,
            wins: 50,
            ranking: 3,
          },
          {
            label: "Burnout Kings",
            name: "4",
            members: 5,
            wins: 15,
            ranking: 4,
          },
        ];
      }
      setAllCrews(dataToProcess);
      setLoaded(true);
    };
    fetchData();
  }, [season]);

  if (!loaded) return <Loading />;

  return (
    <Box className={classes.listContainer}>
      {paginatedCrews.map((crew) => {
        const rank = crew.ranking || 0;
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
          <Box className={rowClass} key={crew.name}>
            <Box className={classes.racerInfo}>
              <Box className={`${classes.rankBox} ${rankClass}`}>#{rank}</Box>
              <Avatar src={crew.photo} size="md" radius="sm" />
              <Box className={classes.nameBlock}>
                <div className={classes.racerName}>
                  {crew.label}
                  {isTop1 && <Crown size={14} color="#ffd700" fill="#ffd700" />}
                </div>
                <span className={classes.racerCrew}>
                  {crew.members} {lang.members ?? "MEMBERS"}
                </span>
              </Box>
            </Box>
            <Box className={classes.statsContainer}>
              <Box className={classes.statBlock}>
                <span className={classes.statLabel}>
                  {lang.season_victories ?? "WINS"}
                </span>
                <span className={classes.statValueAccent}>{crew.wins}</span>
              </Box>
            </Box>
          </Box>
        );
      })}
    </Box>
  );
};
