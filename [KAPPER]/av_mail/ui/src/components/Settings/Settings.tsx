import { useState } from "react";
import { useAtom } from "jotai";
import {
  Box,
  Text,
  Image,
  TextInput,
  PasswordInput,
  Button,
} from "@mantine/core";
import { profileAtom } from "../../reducers/atoms";
import { api } from "../../Api/api";
import { useT } from "../../hooks/useLang";
import global from "../../global.module.css";
import classes from "./style.module.css";

const accentBtn = { backgroundColor: "var(--accent)", color: "#07222a" };

export const Settings = () => {
  const t = useT();
  const [profile, setProfile] = useAtom(profileAtom);

  const [displayName, setDisplayName] = useState(profile?.displayName || "");
  const [avatar, setAvatar] = useState(profile?.avatar || "");
  const [profileMsg, setProfileMsg] = useState("");
  const [savingProfile, setSavingProfile] = useState(false);

  const [current, setCurrent] = useState("");
  const [next, setNext] = useState("");
  const [confirm, setConfirm] = useState("");
  const [passMsg, setPassMsg] = useState("");
  const [savingPass, setSavingPass] = useState(false);

  const saveProfile = async () => {
    setProfileMsg("");
    setSavingProfile(true);
    const res = await api.updateProfile(displayName.trim(), avatar.trim());
    setSavingProfile(false);
    if (res.ok) {
      if (res.profile) setProfile(res.profile);
      setProfileMsg(t("settings.saved"));
    } else {
      setProfileMsg(t(res.error, res.errorParams));
    }
  };

  const changePassword = async () => {
    setPassMsg("");
    if (next !== confirm) return setPassMsg(t("auth.passwords_no_match"));
    setSavingPass(true);
    const res = await api.changePassword(current, next);
    setSavingPass(false);
    if (res.ok) {
      setCurrent("");
      setNext("");
      setConfirm("");
      setPassMsg(t("settings.changed"));
    } else {
      setPassMsg(t(res.error, res.errorParams));
    }
  };

  return (
    <Box className={classes.screen}>
      <Text className={classes.title}>{t("settings.title")}</Text>
      <Text className={classes.sub}>{t("settings.subtitle")}</Text>

      <Box className={classes.panel}>
        <Text className={classes.panelTitle}>{t("settings.profile")}</Text>
        <Box className={classes.avatarRow}>
          <Box className={classes.avatar}>
            {avatar ? (
              <Image src={avatar} alt="" w="100%" h="100%" fit="cover" />
            ) : (
              (displayName || "?").slice(0, 1).toUpperCase()
            )}
          </Box>
          <Box className={classes.grow}>
            <TextInput
              label={t("settings.avatar")}
              placeholder={t("settings.avatar_placeholder")}
              value={avatar}
              onChange={(e) => setAvatar(e.currentTarget.value)}
              classNames={{ input: global.input }}
            />
          </Box>
        </Box>
        <Box className={classes.field}>
          <TextInput
            label={t("settings.display_name")}
            value={displayName}
            maxLength={24}
            onChange={(e) => setDisplayName(e.currentTarget.value)}
            classNames={{ input: global.input }}
          />
        </Box>
        {profileMsg && <Text className={classes.emptyHint}>{profileMsg}</Text>}
        <Button style={accentBtn} loading={savingProfile} onClick={saveProfile}>
          {t("settings.save")}
        </Button>
      </Box>

      <Box className={classes.panel}>
        <Text className={classes.panelTitle}>{t("settings.password")}</Text>
        <Box className={classes.field}>
          <PasswordInput
            label={t("settings.current")}
            value={current}
            onChange={(e) => setCurrent(e.currentTarget.value)}
            classNames={{ input: global.input }}
          />
        </Box>
        <Box className={classes.field}>
          <PasswordInput
            label={t("settings.new")}
            value={next}
            onChange={(e) => setNext(e.currentTarget.value)}
            classNames={{ input: global.input }}
          />
        </Box>
        <Box className={classes.field}>
          <PasswordInput
            label={t("settings.confirm")}
            value={confirm}
            onChange={(e) => setConfirm(e.currentTarget.value)}
            classNames={{ input: global.input }}
          />
        </Box>
        {passMsg && <Text className={classes.emptyHint}>{passMsg}</Text>}
        <Button style={accentBtn} loading={savingPass} onClick={changePassword}>
          {t("settings.change")}
        </Button>
      </Box>
    </Box>
  );
};
