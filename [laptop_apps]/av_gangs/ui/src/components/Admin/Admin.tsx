import { useEffect, useState, lazy, Suspense } from "react";
import { Box, Transition } from "@mantine/core";
import { Header } from "./Header/Header";
import { fetchNui, useNuiEvent } from "../../hooks/useNuiEvents";
import { ModalType } from "../../types/types";
import { ModalMenu } from "../ModalMenu/ModalMenu";
import { useRecoilState, useRecoilValue } from "recoil";
import { CursorState, Lang } from "../../reducers/atoms";
import classes from "./style.module.css";

const Doors = lazy(() => import("./Doors/Doors"));
const Gangs = lazy(() => import("./Gangs/Gangs"));
const Market = lazy(() => import("./Market/Market"));
const Shells = lazy(() => import("./Shells/Shells"));
const Territories = lazy(() => import("./Territories/Territories"));
const Graffitis = lazy(() => import("./Graffitis/Graffitis"));
const LogsTab = lazy(() => import("./LogsTab/LogsTab"));

export const Admin = () => {
  const daLang: any = useRecoilValue(Lang);
  const lang = daLang.admin;
  const [cursor, setCursor] = useRecoilState(CursorState);
  const [tab, setTab] = useState("gangs");
  const [loaded, setLoaded] = useState(false);
  const [modal, setModal] = useState<ModalType>({
    state: false,
    info: {
      title: lang.close_panel,
      options: [
        {
          type: "info",
          description: lang.close_description,
          size: "xs",
        },
      ],
      button: daLang.confirm,
    },
  });
  useNuiEvent("toggleCursor", (state: boolean) => {
    setCursor(state);
  });

  const callback = (data: any) => {
    setModal({ ...modal, state: false });
    if (!data) return;
    setLoaded(false);
    setTimeout(() => {
      fetchNui("av_gangs", "closeAdmin");
    }, 250);
  };

  const onKeyDown = (e: KeyboardEvent) => {
    if (e.code === "Escape") {
      if (tab == "shells") {
        setModal({ ...modal, state: true });
      } else {
        setLoaded(false);
        setTimeout(() => {
          fetchNui("av_gangs", "closeAdmin");
        }, 250);
      }
    }
  };
  useEffect(() => {
    if (!loaded) {
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    }
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, [tab]);

  return (
    <Box className={classes.container} opacity={!cursor ? 0.1 : 1.0}>
      <Transition
        mounted={loaded}
        transition="fade-down"
        duration={500}
        exitDuration={500}
        timingFunction="ease"
      >
        {(styles) => (
          <Box className={classes.box} style={styles}>
            {modal.state && <ModalMenu data={modal} callback={callback} />}
            <Header tab={tab} setTab={setTab} />
            <Suspense fallback={<></>}>
              <Box className={classes.content}>
                {tab == "doors" && <Doors />}
                {tab == "gangs" && <Gangs />}
                {tab == "market" && <Market />}
                {tab == "shells" && <Shells />}
                {tab == "territories" && <Territories />}
                {tab == "graffitis" && <Graffitis />}
                {tab == "logs" && <LogsTab />}
              </Box>
            </Suspense>
          </Box>
        )}
      </Transition>
    </Box>
  );
};
