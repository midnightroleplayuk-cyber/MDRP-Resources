import { Box, Text, Group, Grid } from "@mantine/core";
import { Trophy, TrendingUp, Coins } from "lucide-react";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../../../reducers/atoms";
import { useEffect, useState } from "react";
import { fetchNui } from "../../../../../hooks/useNuiEvents";
import classes from "./style.module.css";

export const TodayStats = () => {
  const lang: any = useRecoilValue(Lang);
  const [racesWon, setRacesWon] = useState<number | undefined>();
  const [eloGained, setEloGained] = useState<number | undefined>();
  const [cosmoEarned, setCosmoEarned] = useState<number | undefined>();

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getTodayStats");
      if (!resp) return;
      setRacesWon(resp.wins);
      setEloGained(resp.elo);
      setCosmoEarned(resp.earnings);
    };
    fetchData();
  }, []);

  return (
    <Grid gutter="md">
      <Grid.Col span={{ base: 12, sm: 4 }}>
        <Box className={classes.statCard}>
          <Group justify="space-between" align="flex-start">
            <Group className={classes.statHeader}>
              <Trophy size={16} color="var(--success)" />
              <Text className={classes.statTitle}>
                {lang?.races_won ?? "Races Won"}
              </Text>
            </Group>
            <Text fz="9px" fw={800} tt="uppercase" c="var(--text-dim)" lts={1}>
              {lang?.today ?? "Today"}
            </Text>
          </Group>
          <Text className={classes.statValue} c="var(--success)">
            {racesWon !== undefined
              ? racesWon.toString().padStart(2, "0")
              : "--"}
          </Text>
        </Box>
      </Grid.Col>
      <Grid.Col span={{ base: 12, sm: 4 }}>
        <Box className={classes.statCard}>
          <Group justify="space-between" align="flex-start">
            <Group className={classes.statHeader}>
              <TrendingUp
                size={16}
                color={
                  eloGained !== undefined && eloGained >= 0
                    ? "var(--accent)"
                    : "var(--danger)"
                }
              />
              <Text className={classes.statTitle}>
                {lang?.elo_gained ?? "Elo Gained"}
              </Text>
            </Group>
            <Text fz="9px" fw={800} tt="uppercase" c="var(--text-dim)" lts={1}>
              {lang?.today ?? "Today"}
            </Text>
          </Group>
          <Text
            className={classes.statValue}
            c={
              eloGained !== undefined && eloGained >= 0
                ? "var(--accent)"
                : "var(--danger)"
            }
          >
            {eloGained !== undefined
              ? eloGained > 0
                ? `+${eloGained}`
                : eloGained
              : "--"}
          </Text>
        </Box>
      </Grid.Col>
      <Grid.Col span={{ base: 12, sm: 4 }}>
        <Box className={classes.statCard}>
          <Group justify="space-between" align="flex-start">
            <Group className={classes.statHeader}>
              <Coins
                size={16}
                color={
                  cosmoEarned !== undefined && cosmoEarned >= 0
                    ? "var(--accent)"
                    : "var(--danger)"
                }
              />
              <Text className={classes.statTitle}>
                {lang?.cosmo_earned ?? "Cosmo Earned"}
              </Text>
            </Group>
            <Text fz="9px" fw={800} tt="uppercase" c="var(--text-dim)" lts={1}>
              {lang?.today ?? "Today"}
            </Text>
          </Group>
          <Text
            className={classes.statValue}
            c={
              cosmoEarned !== undefined && cosmoEarned >= 0
                ? "var(--accent)"
                : "var(--danger)"
            }
          >
            {cosmoEarned !== undefined ? cosmoEarned.toLocaleString() : "--"}
          </Text>
        </Box>
      </Grid.Col>
    </Grid>
  );
};
