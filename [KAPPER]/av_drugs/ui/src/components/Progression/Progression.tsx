import { useState, useEffect } from "react";
import { Grid, Box, Text } from "@mantine/core";
import { fetchNui, isEnvBrowser } from "../../hooks/useNuiEvents";
import { Loading } from "../Loading";
import { DrugStats } from "./DrugStats";
import { Territories } from "./Territories";
import classes from "./style.module.css";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";

export const Progression = () => {
  const { app: lang }: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(isEnvBrowser());
  const [allDrugs, setAllDrugs] = useState([]);
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_drugs", "getStats");
      if (resp) {
        setAllDrugs(resp);
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, []);
  if (!loaded) return <Loading />;
  return (
    <>
      {allDrugs[0] ? (
        <Grid className={classes.container}>
          <Grid.Col span={4}>
            <DrugStats allDrugs={allDrugs} />
          </Grid.Col>
          <Grid.Col span={"auto"}>
            <Territories />
          </Grid.Col>
        </Grid>
      ) : (
        <Box
          style={{
            position: "relative",
            display: "flex",
            width: "100%",
            height: "100vh",
            textAlign: "center",
            alignContent: "center",
            justifyContent: "center",
          }}
        >
          <Text fz="sm" c="dimmed" fw={500} mt="15%" lts={2}>
            {lang.empty}
          </Text>
        </Box>
      )}
    </>
  );
};
