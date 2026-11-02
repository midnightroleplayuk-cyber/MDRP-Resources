import { useCallback, useEffect, useState } from "react";
import { Box, Text, TextInput, PasswordInput, Button } from "@mantine/core";
import { Globe, Plus, Mail, Trash2 } from "lucide-react";
import type { DomainsData } from "../../types/types";
import { api } from "../../Api/api";
import { useT } from "../../hooks/useLang";
import global from "../../global.module.css";
import classes from "./style.module.css";

const accentBtn = { backgroundColor: "var(--accent)", color: "#07222a" };
const money = (n: number) => "$" + n.toLocaleString("en-US");

export const Domains = () => {
  const t = useT();
  const [data, setData] = useState<DomainsData | null>(null);
  const [newDomain, setNewDomain] = useState("");
  const [error, setError] = useState("");
  const [busy, setBusy] = useState(false);
  const [openFor, setOpenFor] = useState<string | null>(null);
  const [mbUser, setMbUser] = useState("");
  const [mbPass, setMbPass] = useState("");

  const load = useCallback(async () => {
    const res = await api.getDomains();
    if (res.ok) setData(res);
  }, []);

  useEffect(() => {
    load();
  }, [load]);

  const buy = async () => {
    setError("");
    if (!newDomain.trim()) return;
    setBusy(true);
    const res = await api.buyDomain(newDomain.trim().toLowerCase());
    setBusy(false);
    if (res.ok) {
      setNewDomain("");
      load();
    } else setError(t(res.error, res.errorParams));
  };

  const createMailbox = async (domain: string) => {
    setError("");
    if (!mbUser.trim() || !mbPass.trim()) return;
    const res = await api.createMailbox(
      domain,
      mbUser.trim().toLowerCase(),
      mbPass.trim(),
    );
    if (res.ok) {
      setMbUser("");
      setMbPass("");
      setOpenFor(null);
      load();
    } else setError(t(res.error, res.errorParams));
  };

  const removeMailbox = async (address: string) => {
    const res = await api.deleteMailbox(address);
    if (res.ok) load();
  };

  return (
    <Box className={classes.screen}>
      <Text className={classes.title}>{t("domains.title")}</Text>
      <Text className={classes.sub}>{t("domains.subtitle")}</Text>

      {error && <Box className={classes.error}>{error}</Box>}

      {data?.allowBuy && (
        <Box className={classes.panel}>
          <Text className={classes.panelTitle}>{t("domains.buy_title")}</Text>
          <Box className={classes.buyRow}>
            <TextInput
              placeholder={t("domains.domain_placeholder")}
              value={newDomain}
              onChange={(e) => setNewDomain(e.currentTarget.value)}
              classNames={{ input: global.input }}
              style={{ flex: 1 }}
            />
            <Button
              style={accentBtn}
              loading={busy}
              leftSection={<Plus size={15} />}
              onClick={buy}
            >
              {t("domains.buy")}
            </Button>
          </Box>
          <Text className={classes.emptyHint}>
            {t("domains.price")}: {money(data.price)}
          </Text>
        </Box>
      )}

      <Box className={classes.panel}>
        <Text className={classes.panelTitle}>{t("domains.mine")}</Text>
        {(!data || data.owned.length === 0) && (
          <Text className={classes.emptyHint}>{t("domains.none_owned")}</Text>
        )}
        {data?.owned.map((d) => (
          <Box key={d.id} className={classes.domainBlock}>
            <Box className={classes.domainRow}>
              <Text span className={classes.domainLabel}>
                <Globe size={15} /> @{d.domain}
              </Text>
              <Button
                size="xs"
                variant="default"
                classNames={{ root: global.button }}
                leftSection={<Mail size={13} />}
                onClick={() => setOpenFor(openFor === d.domain ? null : d.domain)}
              >
                {t("domains.create_mailbox")}
              </Button>
            </Box>

            <Box className={classes.mailboxes}>
              {d.mailboxes.length === 0 && (
                <Text className={classes.emptyHint}>
                  {t("domains.no_mailboxes")}
                </Text>
              )}
              {d.mailboxes.map((m) => (
                <Box className={classes.mailboxRow} key={m.address}>
                  <Text span>
                    {m.address}{" "}
                    <Text span className={classes.pill}>
                      {m.displayName}
                    </Text>
                  </Text>
                  <Trash2
                    size={14}
                    style={{ cursor: "pointer", color: "var(--danger)" }}
                    onClick={() => removeMailbox(m.address)}
                  />
                </Box>
              ))}
            </Box>

            {openFor === d.domain && (
              <Box className={classes.mailboxForm}>
                <TextInput
                  placeholder={t("domains.mailbox_user_placeholder")}
                  value={mbUser}
                  onChange={(e) => setMbUser(e.currentTarget.value)}
                  classNames={{ input: global.input }}
                  size="xs"
                  rightSectionWidth={Math.min(180, d.domain.length * 7 + 28)}
                  rightSection={
                    <Text span className={classes.rightHint}>
                      @{d.domain}
                    </Text>
                  }
                />
                <Box className={classes.passRow}>
                  <PasswordInput
                    placeholder={t("domains.mailbox_pass_placeholder")}
                    value={mbPass}
                    onChange={(e) => setMbPass(e.currentTarget.value)}
                    classNames={{ input: global.input }}
                    size="xs"
                    style={{ flex: 1 }}
                  />
                  <Button
                    size="xs"
                    style={accentBtn}
                    onClick={() => createMailbox(d.domain)}
                  >
                    {t("domains.create")}
                  </Button>
                </Box>
                <Text className={classes.emptyHint}>
                  {t("domains.mailbox_hint")}
                </Text>
              </Box>
            )}
          </Box>
        ))}
      </Box>
    </Box>
  );
};
