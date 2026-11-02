import { useEffect, useState } from "react";
import { useAtomValue, useSetAtom } from "jotai";
import {
  Box,
  Text,
  UnstyledButton,
  TextInput,
  PasswordInput,
  Select,
  Button,
  Checkbox,
} from "@mantine/core";
import { Mail } from "lucide-react";
import {
  authViewAtom,
  profileAtom,
  suggestedEmailAtom,
} from "../../reducers/atoms";
import { api } from "../../Api/api";
import { useT } from "../../hooks/useLang";
import global from "../../global.module.css";
import classes from "./style.module.css";

const accentBtn = { backgroundColor: "var(--accent)", color: "#07222a" };

export const Auth = () => {
  const t = useT();
  const [mode, setMode] = useState<"login" | "signup">("login");
  return (
    <Box className={classes.screen}>
      <Box className={classes.card}>
        <Box className={classes.brand}>
          <Box className={classes.logo}>
            <Mail size={22} />
          </Box>
          <Box>
            <Text span className={classes.brandName}>
              {t("app.name")}
            </Text>
            <Text span className={classes.brandTag}>
              {t("app.tagline")}
            </Text>
          </Box>
        </Box>
        {mode === "login" ? (
          <LoginForm onSwitch={() => setMode("signup")} />
        ) : (
          <SignupForm onSwitch={() => setMode("login")} />
        )}
      </Box>
    </Box>
  );
};

const LoginForm = ({ onSwitch }: { onSwitch: () => void }) => {
  const t = useT();
  const suggested = useAtomValue(suggestedEmailAtom);
  const setProfile = useSetAtom(profileAtom);
  const setView = useSetAtom(authViewAtom);
  const [address, setAddress] = useState(suggested);
  const [password, setPassword] = useState("");
  const [authorize, setAuthorize] = useState(false);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const submit = async () => {
    setError("");
    setLoading(true);
    const res = await api.login(address, password, authorize);
    setLoading(false);
    if (res.ok && res.profile) {
      setProfile(res.profile);
      setView("app");
    } else {
      setError(t(res.error, res.errorParams));
    }
  };

  return (
    <>
      {error && <Box className={classes.error}>{error}</Box>}
      <Box className={classes.field}>
        <TextInput
          label={t("auth.email")}
          placeholder={t("auth.email_placeholder")}
          value={address}
          onChange={(e) => setAddress(e.currentTarget.value)}
          classNames={{ input: global.input }}
        />
      </Box>
      <Box className={classes.field}>
        <PasswordInput
          label={t("auth.password")}
          placeholder="********"
          value={password}
          onChange={(e) => setPassword(e.currentTarget.value)}
          onKeyDown={(e) => e.key === "Enter" && submit()}
          classNames={{ input: global.input }}
        />
      </Box>
      <Checkbox
        label={t("auth.authorize")}
        description={t("auth.authorize_hint")}
        checked={authorize}
        onChange={(e) => setAuthorize(e.currentTarget.checked)}
        color="teal"
        mb="xs"
      />
      <Button
        fullWidth
        mt="sm"
        style={accentBtn}
        loading={loading}
        onClick={submit}
      >
        {t("auth.sign_in")}
      </Button>
      <Text className={classes.switch}>
        {t("auth.no_account")}{" "}
        <UnstyledButton className={classes.switchBtn} onClick={onSwitch}>
          {t("auth.create_one")}
        </UnstyledButton>
      </Text>
    </>
  );
};

const SignupForm = ({ onSwitch }: { onSwitch: () => void }) => {
  const t = useT();
  const setProfile = useSetAtom(profileAtom);
  const setView = useSetAtom(authViewAtom);
  const [domains, setDomains] = useState<string[]>([]);
  const [username, setUsername] = useState("");
  const [domain, setDomain] = useState<string | null>(null);
  const [displayName, setDisplayName] = useState("");
  const [password, setPassword] = useState("");
  const [confirm, setConfirm] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    (async () => {
      const list = await api.getSignupDomains();
      setDomains(list || []);
      if (list && list.length) setDomain(list[0]);
    })();
  }, []);

  const submit = async () => {
    setError("");
    if (!domain) return setError(t("auth.select_domain"));
    if (password !== confirm) return setError(t("auth.passwords_no_match"));
    setLoading(true);
    const res = await api.signup({ username, domain, password, displayName });
    setLoading(false);
    if (res.ok && res.profile) {
      setProfile(res.profile);
      setView("app");
    } else {
      setError(t(res.error, res.errorParams));
    }
  };

  return (
    <>
      {error && <Box className={classes.error}>{error}</Box>}
      <Box className={`${classes.field} ${classes.fieldRow}`}>
        <TextInput
          label={t("auth.username")}
          placeholder={t("auth.username_placeholder")}
          value={username}
          onChange={(e) => setUsername(e.currentTarget.value)}
          classNames={{ input: global.input }}
          style={{ flex: 1 }}
        />
        <Select
          label={t("auth.domain")}
          data={domains.map((d) => ({ value: d, label: "@" + d }))}
          value={domain}
          onChange={setDomain}
          classNames={{
            input: global.input,
            dropdown: global.dropdown,
            option: global.option,
          }}
          comboboxProps={{ withinPortal: false }}
          style={{ width: 150 }}
        />
      </Box>
      <Box className={classes.field}>
        <TextInput
          label={t("auth.display_name")}
          placeholder={t("auth.name_placeholder")}
          value={displayName}
          maxLength={24}
          onChange={(e) => setDisplayName(e.currentTarget.value)}
          classNames={{ input: global.input }}
        />
      </Box>
      <Box className={classes.field}>
        <PasswordInput
          label={t("auth.password")}
          value={password}
          onChange={(e) => setPassword(e.currentTarget.value)}
          classNames={{ input: global.input }}
        />
      </Box>
      <Box className={classes.field}>
        <PasswordInput
          label={t("auth.confirm_password")}
          value={confirm}
          onChange={(e) => setConfirm(e.currentTarget.value)}
          onKeyDown={(e) => e.key === "Enter" && submit()}
          classNames={{ input: global.input }}
        />
      </Box>
      <Button
        fullWidth
        mt="sm"
        style={accentBtn}
        loading={loading}
        onClick={submit}
      >
        {t("auth.create_account")}
      </Button>
      <Text className={classes.switch}>
        {t("auth.have_account")}{" "}
        <UnstyledButton className={classes.switchBtn} onClick={onSwitch}>
          {t("auth.sign_in_link")}
        </UnstyledButton>
      </Text>
    </>
  );
};
