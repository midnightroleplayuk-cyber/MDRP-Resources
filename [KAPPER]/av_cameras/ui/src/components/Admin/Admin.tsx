import { Box, Transition } from "@mantine/core";
import { useEffect, useState } from "react";
import { Header } from "./Header/Header";
import { fetchNui, useNuiEvent } from "../../hooks/useNuiEvents";
import { CameraList } from "./Content/CameraList";
import { ServerList } from "./Content/ServerList";
import classes from "./style.module.css";

export const Admin = () => {
  const [loaded, setLoaded] = useState(false);
  const [opacity, setOpacity] = useState(1.0);
  const [tab, setTab] = useState<string>("classes");

  useNuiEvent("setOpacity", (value: number) => {
    setOpacity(value);
  });

  const onKeyDown = (e: KeyboardEvent) => {
    if (e.code === "Escape") {
      setOpacity(1.0);
      setLoaded(false);
      setTimeout(() => {
        fetchNui("av_cameras", "closeAdmin");
      }, 250);
    }
  };

  useEffect(() => {
    if (!loaded) {
      setTimeout(() => {
        setLoaded(true);
      }, 200);
    }
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, []);

  return (
    <Box className={classes.container} opacity={opacity}>
      <Transition
        mounted={loaded}
        transition="fade-down"
        duration={500}
        exitDuration={500}
        timingFunction="ease"
      >
        {(styles) => (
          <Box className={classes.box} style={styles}>
            <Header tab={tab} setTab={setTab} />
            {tab == "players" && <CameraList />}
            {tab == "server" && <ServerList />}
          </Box>
        )}
      </Transition>
    </Box>
  );
};
