import { Box } from "@mantine/core";
import { useEffect, useState, lazy, Suspense } from "react";
import { fetchNui, isEnvBrowser } from "../../hooks/useNuiEvents";
import { Loading } from "../Loading";
import { Header } from "./Header/Header";
import { useRecoilState, useSetRecoilState } from "recoil";
import { Gang, Identifier, Permissions } from "../../reducers/atoms";
import classes from "./style.module.css";

const Overview = lazy(() => import("./Overview/Overview"));
const Missions = lazy(() => import("./Missions/Missions"));
const Map = lazy(() => import("./Map/Map"));
const Settings = lazy(() => import("./Settings/Settings"));
const Market = lazy(() => import("./Market/Market"));
const Properties = lazy(() => import("./Properties/Properties"));

export const MainApp = () => {
  const [gang, setGang] = useRecoilState(Gang);
  const setPermissions = useSetRecoilState(Permissions);
  const setIdentifier = useSetRecoilState(Identifier);
  const [loaded, setLoaded] = useState(false);
  const [tab, setTab] = useState("overview");
  const fetchData = async () => {
    const resp = await fetchNui("av_gangs", "getData");
    if (resp) {
      setGang(resp.gang);
      setPermissions(resp.permissions);
      setIdentifier(resp.identifier);
    } else {
      if (!isEnvBrowser()) {
        fetchNui("av_laptop", "closeApp", "gang");
        return;
      }
    }
    setTimeout(() => {
      setLoaded(true);
    }, 100);
  };
  useEffect(() => {
    fetchData();
  }, []);
  useEffect(() => {
    document.documentElement.style.setProperty(
      "--color-main",
      gang.colors?.buttons ?? "#c0eb75"
    );
    document.documentElement.style.setProperty(
      "--color-text",
      gang.colors?.text ?? "#000000"
    );
  }, [gang.colors]);

  return (
    <Box className={classes.app}>
      {loaded ? (
        <Box className={classes.container}>
          <Header tab={tab} setTab={setTab} />
          <Box className={classes.main}>
            <Suspense fallback={<></>}>
              <Box className={classes.content} p="md">
                {tab == "overview" && <Overview />}
                {tab == "missions" && <Missions />}
                {tab == "territories" && <Map />}
                {tab == "settings" && <Settings />}
                {tab == "market" && <Market />}
                {tab == "properties" && <Properties />}
              </Box>
            </Suspense>
          </Box>
        </Box>
      ) : (
        <Loading />
      )}
    </Box>
  );
};
