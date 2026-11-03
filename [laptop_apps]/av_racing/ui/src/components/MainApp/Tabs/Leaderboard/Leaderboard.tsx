import { useEffect, useState } from "react";
import {
  Stack,
  Group,
  Text,
  Box,
  TextInput,
  ActionIcon,
  Select,
  Flex,
  Pagination,
  Tooltip,
} from "@mantine/core";
import { Search, X, Trophy } from "lucide-react";
import { Loading } from "../../../Loading";
import { useViewportSize } from "@mantine/hooks";
import { Racers } from "./Racers";
import { Crews } from "./Crews";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../../reducers/atoms";
import { fetchNui } from "../../../../hooks/useNuiEvents";
import { SelectType } from "../../../../types/types";
import classes from "./style.module.css";
import global from "../../../../global.module.css";

const Leaderboard = () => {
  const lang: any = useRecoilValue(Lang);
  const [tab, setTab] = useState("racers");
  const [search, setSearch] = useState("");
  const [season, setSeason] = useState<string | null>(null);
  const [sortBy, setSortBy] = useState<string>("elo");
  const [endsIn, setEndsIn] = useState<string | null>(null);
  const [currentSeason, setCurrentSeason] = useState<number>(1);
  const [seasonList, setSeasonList] = useState<SelectType[]>([]);
  const [activePage, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(0);
  const [count, setCount] = useState(0);
  const { height } = useViewportSize();
  const [loaded, setLoaded] = useState(false);

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getSeasonData");
      if (resp) {
        setEndsIn(resp.days);
        setCurrentSeason(resp.season || 1);
        if (resp.seasonList) setSeasonList(resp.seasonList);
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, []);

  const handleTabChange = (newTab: string) => {
    setTab(newTab);
    setPage(1);
    setSearch("");
  };

  if (!loaded) return <Loading />;

  return (
    <Stack style={{ flex: 1, overflow: "hidden" }}>
      <Group
        justify="space-between"
        pb="sm"
        style={{ borderBottom: "1px solid var(--border-color)" }}
      >
        <Group gap="md">
          <Box className={classes.iconBox}>
            <Trophy size={20} />
          </Box>
          <Group gap="sm" align="center">
            <Text
              component="span"
              onClick={() => handleTabChange("racers")}
              style={{
                cursor: "pointer",
                color:
                  tab === "racers" ? "var(--text-main)" : "var(--text-dim)",
                fontWeight: 800,
                fontSize: "20px",
                fontFamily: "var(--font-main)",
                textTransform: "uppercase",
                letterSpacing: "1px",
                transition: "color 0.2s ease",
              }}
            >
              {lang?.racers ?? "Racers"}
            </Text>
            <Text component="span" c="var(--text-dim)" fw={800} fz="20px">
              /
            </Text>
            <Text
              component="span"
              onClick={() => handleTabChange("crews")}
              style={{
                cursor: "pointer",
                color: tab === "crews" ? "var(--text-main)" : "var(--text-dim)",
                fontWeight: 800,
                fontSize: "20px",
                fontFamily: "var(--font-main)",
                textTransform: "uppercase",
                letterSpacing: "1px",
                transition: "color 0.2s ease",
              }}
            >
              {lang?.crews ?? "Crews"}
            </Text>
            {season === null && (
              <Group gap="xs" ml="md">
                <Box
                  style={{
                    width: "2px",
                    height: "30px",
                    backgroundColor: "var(--border-color)",
                    marginRight: "8px",
                  }}
                />
                <Flex direction="column" gap={0}>
                  <Text
                    fw={900}
                    fz="14px"
                    ff="var(--font-main)"
                    c="var(--accent)"
                    tt="uppercase"
                    lts={1}
                  >
                    {`${lang?.season_tab ?? "Season"} ${currentSeason}`}
                  </Text>
                  <Text
                    fz="11px"
                    c="var(--text-dim)"
                    fw={600}
                    tt="uppercase"
                    mt={-2}
                  >
                    {`${lang?.ends_in ?? "Ends in"} ${endsIn} ${lang?.days ?? "days"}`}
                  </Text>
                </Flex>
                <Tooltip
                  label={lang?.season_info ?? "Season Information"}
                  fz="xs"
                  color="var(--tooltip)"
                  multiline
                  maw={300}
                  withArrow
                >
                  <Box className={classes.tooltip}>
                    <Text fz="12px" c="var(--text-main)" fw={700}>
                      ?
                    </Text>
                  </Box>
                </Tooltip>
              </Group>
            )}
          </Group>
        </Group>
        <Group ml="auto" gap="sm">
          <TextInput
            placeholder={lang?.search ?? "Search..."}
            leftSection={<Search size={14} />}
            classNames={global}
            size="xs"
            onChange={(e) => {
              setSearch(e.target.value);
              setPage(1);
            }}
            value={search}
            styles={{
              input: {
                backgroundColor: "var(--bg-main)",
                border: "1px solid var(--border-color)",
                color: "var(--text-main)",
              },
            }}
            rightSection={
              search.length > 0 && (
                <ActionIcon
                  size="xs"
                  radius={50}
                  color="var(--text-dim)"
                  variant="transparent"
                  onClick={() => {
                    setSearch("");
                    setPage(1);
                  }}
                >
                  <X size={14} />
                </ActionIcon>
              )
            }
          />
          <Select
            classNames={global}
            size="xs"
            value={sortBy}
            onChange={(val) => setSortBy(val || "elo")}
            data={[
              { value: "elo", label: lang?.season_elo ?? "Sort by Elo" },
              {
                value: "wins",
                label: lang?.season_victories ?? "Sort by Wins",
              },
              { value: "races", label: lang?.season_races ?? "Sort by Races" },
              { value: "name", label: "Sort by Name" },
            ]}
            styles={{
              input: {
                backgroundColor: "var(--bg-main)",
                border: "1px solid var(--border-color)",
                color: "var(--text-dim)",
              },
              dropdown: {
                backgroundColor: "var(--bg-panel)",
                border: "1px solid var(--border-color)",
              },
              option: {
                color: "var(--text-main)",
              },
            }}
          />
          {currentSeason > 1 && (
            <Select
              classNames={global}
              size="xs"
              placeholder={lang?.current_season ?? "Current Season"}
              data={seasonList}
              onChange={(e) => setSeason(e)}
              styles={{
                input: {
                  backgroundColor: "var(--bg-main)",
                  border: "1px solid var(--border-color)",
                  color: "var(--text-dim)",
                },
                dropdown: {
                  backgroundColor: "var(--bg-panel)",
                  border: "1px solid var(--border-color)",
                },
                option: {
                  color: "var(--text-main)",
                },
              }}
            />
          )}
        </Group>
      </Group>
      <Box className={classes.container}>
        {tab === "racers" ? (
          <Racers
            height={height}
            setCount={setCount}
            setTotalPages={setTotalPages}
            activePage={activePage}
            setPage={setPage}
            search={search}
            season={season}
            sortBy={sortBy as any}
          />
        ) : (
          <Crews
            height={height}
            setCount={setCount}
            setTotalPages={setTotalPages}
            activePage={activePage}
            setPage={setPage}
            search={search}
            season={season}
            sortBy={sortBy as any}
          />
        )}
      </Box>
      {totalPages > 1 && (
        <Pagination
          classNames={{
            root: classes.paginationRoot,
            control: classes.paginationControl,
          }}
          total={totalPages}
          value={activePage}
          onChange={setPage}
        />
      )}
    </Stack>
  );
};

export default Leaderboard;
