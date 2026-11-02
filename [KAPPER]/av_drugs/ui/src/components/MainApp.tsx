import { useState, useEffect } from "react";
import { Box } from "@mantine/core";
import { fetchNui, isEnvBrowser } from "../hooks/useNuiEvents";
import { Loading } from "./Loading";
import { Products } from "./Products/Products";
import { Header } from "./Header/Header";
import { Market } from "./Market/Market";
import { Settings } from "./Settings/Settings";
import { Profile } from "../types/types";
import classes from "./appStyle.module.css";
import { Progression } from "./Progression/Progression";

export const MainApp = () => {
  const [loaded, setLoaded] = useState(isEnvBrowser());
  const [profile, setProfile] = useState<Profile>({
    username: "AV Scripts",
    strain: "avilchiis",
    photo: "./avatar_default.png",
  });
  const [showSettings, setShowSettings] = useState(false);
  const [tab, setTab] = useState("home");

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_drugs", "getProfile");
      if (resp) {
        setProfile(resp);
        setTimeout(() => {
          setLoaded(true);
        }, 200);
      }
    };
    fetchData();
  }, []);

  return (
    <Box className={classes.app} p={"sm"}>
      <Box className={classes.container}>
        {loaded ? (
          <>
            {showSettings && (
              <Settings
                profile={profile}
                setProfile={setProfile}
                show={setShowSettings}
              />
            )}
            <Header
              tab={tab}
              setTab={setTab}
              openSettings={setShowSettings}
              profile={profile}
            />
            {tab == "home" && <Products />}
            {tab == "market" && <Market />}
            {tab == "progression" && <Progression />}
          </>
        ) : (
          <Loading />
        )}
      </Box>
    </Box>
  );
};
