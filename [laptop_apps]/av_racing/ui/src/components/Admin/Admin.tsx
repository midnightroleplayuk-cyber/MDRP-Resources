import { lazy, Suspense, useEffect, useMemo, useState } from "react";
import { Box, Transition, Group, Stack, Text, ActionIcon } from "@mantine/core";
import { X } from "lucide-react";
import { fetchNui, isEnvBrowser } from "../../hooks/useNuiEvents";
import { Sidebar } from "./Sidebar/Sidebar";
import { getTabs } from "./Sidebar/tabs";
import { Loading } from "../Loading";
import { ModalType, SelectType } from "../../types/types";
import { ModalMenu } from "../ModalMenu/ModalMenu";
import { CreateEvent } from "./Live/CreateEvent";
import { useRecoilValue, useSetRecoilState } from "recoil";
import { Classes, Lang } from "../../reducers/atoms";
import classes from "./style.module.css";

const Crews = lazy(() => import("./Crews/Crews"));
const Live = lazy(() => import("./Live/Live"));
const Results = lazy(() => import("./Results/Results"));
const Tracks = lazy(() => import("./Tracks/Tracks"));
const Season = lazy(() => import("./Season/Season"));
const Events = lazy(() => import("./Events/Events"));
const Matchmaking = lazy(() => import("./Matchmaking/Matchmaking"));

interface AdminType {
  state: boolean;
  classes?: SelectType[];
}

export const Admin = () => {
  const lang: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(isEnvBrowser());
  const [tab, setTab] = useState("crews");
  const activeTab = useMemo(
    () => getTabs(lang).find((t) => t.value === tab),
    [lang, tab],
  );
  const [showCreator, setShowCreator] = useState(false);
  const setClasses = useSetRecoilState(Classes);
  const [modalOptions, setModalOptions] = useState<ModalType>({
    state: false,
    info: {
      title: lang.create_crew_title,
      options: [
        { type: "text", name: "label", title: lang.crew_name, asterisk: true },
        {
          type: "number",
          name: "boss",
          title: lang.crew_boss,
          description: lang.player_serverid,
        },
      ],
      button: lang.create_button,
    },
  });

  const handleNew = () => {
    setModalOptions({ ...modalOptions, state: true });
  };
  const callback = (data: any) => {
    setModalOptions({ ...modalOptions, state: false });
    if (!data) return;
    fetchNui("av_racing", "registerCrew", data);
  };
  const closeAdmin = () => {
    setLoaded(false);
    setTimeout(() => {
      fetchNui("av_racing", "closeAdmin");
    }, 250);
  };

  const onKeyDown = (e: KeyboardEvent) => {
    if (e.code === "Escape") {
      closeAdmin();
    }
  };

  useEffect(() => {
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, []);

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getAdminClasses");
      if (resp) {
        setClasses(resp);
      }
      setTimeout(() => {
        setLoaded(true);
      }, 200);
    };
    fetchData();
  }, []);

  return (
    <>
      <Box className={classes.container}>
        <Transition
          mounted={loaded}
          transition="fade-down"
          duration={500}
          exitDuration={500}
          timingFunction="ease"
        >
          {(styles) => (
            <Box className={classes.box} style={styles}>
              {showCreator && (
                <CreateEvent setState={setShowCreator} lang={lang} />
              )}
              {modalOptions.state && (
                <ModalMenu data={modalOptions} callback={callback} />
              )}
              <Sidebar tab={tab} setTab={setTab} />

              <Box className={classes.main}>
                <Group
                  className={classes.topbar}
                  justify="space-between"
                  wrap="nowrap"
                >
                  <Stack gap={2}>
                    <Text className={classes.pageTitle}>
                      {activeTab?.label}
                    </Text>
                    {activeTab?.desc && (
                      <Text className={classes.pageDesc}>{activeTab.desc}</Text>
                    )}
                  </Stack>
                  <ActionIcon
                    className={classes.closeBtn}
                    variant="subtle"
                    size="md"
                    onClick={closeAdmin}
                  >
                    <X size={18} />
                  </ActionIcon>
                </Group>

                <Box className={classes.content}>
                  <Suspense fallback={<Loading />}>
                    {tab == "crews" && <Crews handleNew={handleNew} />}
                    {tab == "live" && <Live showCreator={setShowCreator} />}
                    {tab == "results" && <Results />}
                    {tab == "tracks" && <Tracks />}
                    {tab == "season" && <Season />}
                    {tab == "events" && <Events />}
                    {tab == "matchmaking" && <Matchmaking />}
                  </Suspense>
                </Box>
              </Box>
            </Box>
          )}
        </Transition>
      </Box>
    </>
  );
};
