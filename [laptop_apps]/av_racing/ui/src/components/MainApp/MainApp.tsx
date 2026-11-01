import { Box } from "@mantine/core";
import { useState, Suspense, useEffect, lazy } from "react";
import { Header } from "./Header/Header";
import { Loading } from "../Loading";
import { fetchNui, isEnvBrowser } from "../../hooks/useNuiEvents";
import { useSetRecoilState } from "recoil";
import { Categories, Classes, Profile } from "../../reducers/atoms";
import { ApiProfile } from "../../Api/Profile";
import { ApiCategories } from "../../Api/Categories";
import { Details } from "./Details/Details";
import { ApiClasses } from "../../Api/Classes";
import classes from "./style.module.css";

const Home = lazy(() => import("./Tabs/Home/Home"));
const Tracks = lazy(() => import("./Tabs/Tracks/Tracks"));
const Settings = lazy(() => import("./Tabs/Settings/Settings"));
const Crew = lazy(() => import("./Tabs/Crew/Crew"));
const Leaderboard = lazy(() => import("./Tabs/Leaderboard/Leaderboard"));
const Progression = lazy(() => import("./Tabs/Progression/Progression"));
const Matchmaking = lazy(() => import("./Tabs/Matchmaking/Matchmaking"));

const MainApp = () => {
  const [loaded, setLoaded] = useState(false);
  const [tab, setTab] = useState("home");
  const setProfile = useSetRecoilState(Profile);
  const setCategories = useSetRecoilState(Categories);
  const setClasses = useSetRecoilState(Classes);

  const fetchData = async () => {
    const resp = await fetchNui("av_racing", "getData");
    if (resp) {
      setCategories(resp.categories);
      setProfile(resp.profile);
      setClasses(resp.classes);
    } else {
      if (isEnvBrowser()) {
        setProfile(ApiProfile);
        setCategories(ApiCategories);
        setClasses(ApiClasses);
      }
    }
    setLoaded(true);
  };

  useEffect(() => {
    fetchData();
  }, []);

  return (
    <Box className={classes.app}>
      {loaded ? (
        <Box className={classes.container}>
          <Header tab={tab} setTab={setTab} />
          <Box className={classes.main}>
            <Box className={classes.content} p="md">
              <Details />
              <Suspense fallback={<Loading />}>
                {tab == "home" && <Home />}
                {tab == "tracks" && <Tracks />}
                {tab == "settings" && <Settings />}
                {tab == "crew" && <Crew />}
                {tab == "leaderboard" && <Leaderboard />}
                {tab == "progression" && <Progression />}
                {tab == "matchmaking" && <Matchmaking />}
              </Suspense>
            </Box>
          </Box>
        </Box>
      ) : (
        <Loading />
      )}
    </Box>
  );
};

export default MainApp;
