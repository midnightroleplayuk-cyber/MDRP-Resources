import { Box, ScrollArea } from "@mantine/core";
import { useEffect, useState, useCallback } from "react";
import { useRecoilState, useRecoilValue } from "recoil";
import { Lang, Profile } from "../../../../reducers/atoms";
import { fetchNui, isEnvBrowser } from "../../../../hooks/useNuiEvents";
import { Loading } from "../../../Loading";
import { SettingsData } from "./types";
import { RightSide } from "./RightSide";
import { SelectType } from "../../../../types/types";
import { LeftSide } from "./LeftSide";
import classes from "./style.module.css";

const Settings = () => {
  const lang: any = useRecoilValue(Lang);
  const [profile, setProfile] = useRecoilState(Profile);
  const [loaded, setLoaded] = useState(isEnvBrowser());
  const [animations, setAnimations] = useState<SelectType[]>([]);
  const [ghostAvailable, setGhostAvailable] = useState<boolean>(isEnvBrowser());
  const [pathAvailable, setPathAvailable] = useState<boolean>(isEnvBrowser());

  const handleEdit = useCallback(
    (
      field: keyof SettingsData | "name" | "photo",
      value: string | number | boolean | null,
      scope?: string,
    ) => {
      setProfile((prev) => {
        if (scope === "profile" && (field === "name" || field === "photo")) {
          return { ...prev, [field]: value };
        }
        return {
          ...prev,
          settings: {
            ...(prev.settings || {}),
            [field]: value,
          },
        };
      });
    },
    [setProfile],
  );

  const handleSave = useCallback(() => {
    fetchNui("av_racing", "saveProfile", profile);
  }, [profile]);

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getAnimations");
      setAnimations(resp);
      const ghost = await fetchNui<boolean>("av_racing", "getGhostEnabled");
      if (typeof ghost === "boolean") setGhostAvailable(ghost);
      const path = await fetchNui<boolean>("av_racing", "getRacePathEnabled");
      if (typeof path === "boolean") setPathAvailable(path);
      setLoaded(true);
    };
    fetchData();
  }, []);

  if (!loaded) return <Loading />;

  return (
    <Box className={classes.wrapper}>
      <ScrollArea h="100%" type="hover" offsetScrollbars scrollbarSize={6}>
        <Box className={classes.container}>
          <Box className={classes.card}>
            <LeftSide
              lang={lang}
              blip={profile.settings?.blip ?? ""}
              handleEdit={handleEdit}
              smoke={profile.settings?.smoke ?? "rgb(255, 255, 255)"}
              name={profile.name ?? ""}
              nationality={profile.settings?.nationality ?? ""}
              photo={profile.photo ?? ""}
            />
            <RightSide
              animation={profile.settings?.animation ?? ""}
              animations={animations}
              blip={profile.settings?.blip ?? ""}
              handleEdit={handleEdit}
              handleSave={handleSave}
              lang={lang}
              smoke={profile.settings?.smoke ?? "rgb(255, 255, 255)"}
              pathColor={profile.settings?.pathColor ?? "rgb(0, 200, 255)"}
              pathEnabled={profile.settings?.pathEnabled ?? false}
              pathOpacity={profile.settings?.pathOpacity ?? 100}
              pathAvailable={pathAvailable}
              ghostEnabled={profile.settings?.ghostEnabled ?? true}
              ghostTarget={profile.settings?.ghostTarget ?? "best"}
              ghostAvailable={ghostAvailable}
            />
          </Box>
        </Box>
      </ScrollArea>
    </Box>
  );
};

export default Settings;
