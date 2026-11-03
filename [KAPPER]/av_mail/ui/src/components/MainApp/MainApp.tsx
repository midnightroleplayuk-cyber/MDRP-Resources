import { useEffect } from "react";
import { useAtom, useAtomValue, useSetAtom } from "jotai";
import { Box } from "@mantine/core";
import {
  authViewAtom,
  initDoneAtom,
  profileAtom,
  suggestedEmailAtom,
} from "../../reducers/atoms";
import { api } from "../../Api/api";
import { Auth } from "../Auth/Auth";
import { MailApp } from "../MailApp/MailApp";
import classes from "./style.module.css";

export const MainApp = () => {
  const view = useAtomValue(authViewAtom);
  const setView = useSetAtom(authViewAtom);
  const setProfile = useSetAtom(profileAtom);
  const setSuggested = useSetAtom(suggestedEmailAtom);
  const [initDone, setInitDone] = useAtom(initDoneAtom);

  useEffect(() => {
    let active = true;

    const runInit = async () => {
      const res = await api.init();
      if (!active) return;
      if (res.ok && res.autoLogin && res.profile) {
        setProfile(res.profile);
        setView("app");
      } else if (res.ok && res.suggestedEmail) {
        setSuggested(res.suggestedEmail);
      }
      setInitDone(true);
    };

    runInit();

    const handler = (e: MessageEvent) => {
      if (e.data?.message === "loadApp") runInit();
    };
    window.addEventListener("message", handler);
    return () => {
      active = false;
      window.removeEventListener("message", handler);
    };
  }, [setInitDone, setProfile, setSuggested, setView]);

  if (!initDone) return null;

  return (
    <Box className={classes.root}>
      {view === "app" ? <MailApp /> : <Auth />}
    </Box>
  );
};
