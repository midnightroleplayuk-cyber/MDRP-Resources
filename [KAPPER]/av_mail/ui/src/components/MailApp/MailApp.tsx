import { useCallback, useEffect, useRef, useState } from "react";
import { useAtom, useAtomValue, useSetAtom } from "jotai";
import { Box, Text, UnstyledButton, Image, TextInput } from "@mantine/core";
import {
  Inbox,
  Send,
  Star,
  Trash2,
  Plus,
  Globe,
  LogOut,
  Settings as SettingsIcon,
  Reply,
  Forward,
  Paperclip,
  Download,
  FileText,
  Image as ImageIcon,
  Video,
  Search,
  Users,
} from "lucide-react";
import {
  authViewAtom,
  composeAtom,
  composePrefillAtom,
  folderAtom,
  profileAtom,
  screenAtom,
  selectedAtom,
  suggestedEmailAtom,
} from "../../reducers/atoms";
import type { FolderKey, MailItem } from "../../types/types";
import { api } from "../../Api/api";
import { fetchNui } from "../../hooks/useNuiEvents";
import { useT } from "../../hooks/useLang";
import { Compose } from "../Compose/Compose";
import { Domains } from "../Domains/Domains";
import { Settings } from "../Settings/Settings";
import { Contacts } from "../Contacts/Contacts";
import {
  Avatar,
  ComposePrefill,
  fmtFull,
  fmtTime,
  fwdSubject,
  replySubject,
} from "./utils";
import { MailBody } from "./MailBody";
import classes from "./style.module.css";
import { Loading } from "../Loading";

export const MailApp = () => {
  const t = useT();
  const profile = useAtomValue(profileAtom);
  const [screen, setScreen] = useAtom(screenAtom);
  const [folder, setFolder] = useAtom(folderAtom);
  const [selected, setSelected] = useAtom(selectedAtom);
  const [compose, setCompose] = useAtom(composeAtom);
  const setPrefill = useSetAtom(composePrefillAtom);
  const setProfile = useSetAtom(profileAtom);
  const setView = useSetAtom(authViewAtom);
  const setSuggested = useSetAtom(suggestedEmailAtom);
  const [items, setItems] = useState<MailItem[]>([]);
  const [loading, setLoading] = useState(false);
  const [search, setSearch] = useState("");
  const [showSearch, setShowSearch] = useState(false);
  const openingRef = useRef<number | null>(null);

  const folderMeta: { key: FolderKey; icon: any }[] = [
    { key: "inbox", icon: Inbox },
    { key: "sent", icon: Send },
    { key: "starred", icon: Star },
    { key: "trash", icon: Trash2 },
  ];

  const loadFolder = useCallback(
    async (f: FolderKey) => {
      setLoading(true);
      setSelected(null);
      const res = await api.getFolder(f);
      setLoading(false);
      setItems(res.ok ? res.items || [] : []);
    },
    [setSelected],
  );

  useEffect(() => {
    if (screen === "mail") loadFolder(folder);
  }, [folder, screen, loadFolder]);

  const openMessage = async (item: MailItem) => {
    if (selected?.itemId === item.itemId) return;
    if (openingRef.current === item.itemId) return;
    openingRef.current = item.itemId;
    const res = await api.openMessage(item.itemId);
    openingRef.current = null;
    if (res.ok) {
      setSelected(res.message);
      setItems((prev) =>
        prev.map((i) =>
          i.itemId === item.itemId ? { ...i, isRead: true } : i,
        ),
      );
    }
  };

  const copyEmail = () => {
    if (profile?.address) fetchNui("av_laptop", "copy", profile.address);
  };

  const logout = async () => {
    const lastUsed = profile?.address;
    await api.logout();
    if (lastUsed) setSuggested(lastUsed);
    setProfile(null);
    setSelected(null);
    setView("login");
  };

  const startCompose = (p: ComposePrefill = {}) => {
    setPrefill(p);
    setCompose(true);
  };

  const shownItems = search
    ? items.filter((i) =>
        `${i.fromAddress} ${i.subject} ${i.preview}`
          .toLowerCase()
          .includes(search.toLowerCase()),
      )
    : items;

  const secondary: { key: typeof screen; icon: any; label: string }[] = [
    { key: "domains", icon: Globe, label: t("nav.domains") },
    { key: "contacts", icon: Users, label: t("nav.contacts") },
    { key: "settings", icon: SettingsIcon, label: t("nav.settings") },
  ];

  return (
    <Box className={classes.app}>
      <Box className={classes.sidebar}>
        <Box className={classes.account}>
          <Avatar profile={profile} size={34} />
          <Box className={classes.accountText}>
            <Text className={classes.accountName}>{profile?.displayName}</Text>
            <Text
              className={classes.accountAddr}
              onClick={copyEmail}
              title={t("nav.copy_email")}
            >
              {profile?.address}
            </Text>
          </Box>
        </Box>

        <UnstyledButton
          className={classes.composeBtn}
          onClick={() => startCompose()}
        >
          <Plus size={16} /> {t("nav.compose")}
        </UnstyledButton>

        <Box className={classes.nav}>
          {folderMeta.map((f) => (
            <UnstyledButton
              key={f.key}
              className={`${classes.navItem} ${screen === "mail" && folder === f.key ? classes.navItemActive : ""}`}
              onClick={() => {
                setScreen("mail");
                setFolder(f.key);
              }}
            >
              <f.icon size={16} /> {t("folders." + f.key)}
              {f.key === "inbox" && profile?.unread ? (
                <Text span className={classes.badge}>
                  {profile.unread}
                </Text>
              ) : null}
            </UnstyledButton>
          ))}
        </Box>

        <Box className={`${classes.nav} ${classes.navSpacer}`}>
          {secondary.map((s) => (
            <UnstyledButton
              key={s.key}
              className={`${classes.navItem} ${screen === s.key ? classes.navItemActive : ""}`}
              onClick={() => setScreen(s.key)}
            >
              <s.icon size={16} /> {s.label}
            </UnstyledButton>
          ))}
          <UnstyledButton className={classes.navItem} onClick={logout}>
            <LogOut size={16} /> {t("nav.logout")}
          </UnstyledButton>
        </Box>
      </Box>
      {screen === "mail" && (
        <>
          <Box className={classes.inbox}>
            <Box className={classes.inboxHeader}>
              {showSearch ? (
                <TextInput
                  unstyled
                  autoFocus
                  placeholder={t("list.search_ph")}
                  value={search}
                  onChange={(e) => setSearch(e.currentTarget.value)}
                  classNames={{ input: classes.search }}
                  style={{ flex: 1 }}
                />
              ) : (
                <Text span>{t("folders." + folder)}</Text>
              )}
              <Search
                size={16}
                style={{
                  color: showSearch ? "var(--accent)" : "var(--text-dim)",
                  cursor: "pointer",
                }}
                onClick={() => {
                  setShowSearch((sv) => !sv);
                  setSearch("");
                }}
              />
            </Box>
            <Box className={classes.list}>
              {loading && <Loading />}
              {!loading && shownItems.length === 0 && (
                <Text className={classes.emptyHint}>{t("list.empty")}</Text>
              )}
              {shownItems.map((item) => (
                <MailCard
                  key={item.itemId}
                  item={item}
                  folder={folder}
                  active={selected?.itemId === item.itemId}
                  onClick={() => openMessage(item)}
                />
              ))}
            </Box>
          </Box>
          <Box className={classes.viewer}>
            {selected ? (
              <Viewer
                onReply={startCompose}
                onChanged={() => loadFolder(folder)}
              />
            ) : (
              <Box className={classes.viewerEmpty}>
                <Inbox size={40} />
                <Text span>{t("viewer.empty")}</Text>
              </Box>
            )}
          </Box>
        </>
      )}
      {screen === "domains" && <Domains />}
      {screen === "contacts" && <Contacts />}
      {screen === "settings" && <Settings />}
      {compose && <Compose onSent={() => loadFolder(folder)} />}
    </Box>
  );
};

const MailCard = ({
  item,
  folder,
  active,
  onClick,
}: {
  item: MailItem;
  folder: FolderKey;
  active: boolean;
  onClick: () => void;
}) => {
  const t = useT();
  const unread = folder === "inbox" && !item.isRead;
  return (
    <Box
      className={`${classes.card} ${unread ? classes.cardUnread : ""} ${active ? classes.cardActive : ""}`}
      onClick={onClick}
    >
      <Box className={classes.row}>
        <Text span className={classes.sender}>
          {item.fromAddress}
        </Text>
        <Text span className={classes.time}>
          {item.attachments > 0 && (
            <Paperclip size={11} className={classes.previewClip} />
          )}
          {fmtTime(item.createdAt, t("list.yesterday"))}
        </Text>
      </Box>
      <Text className={classes.subject}>
        {item.subject || t("list.no_subject")}
      </Text>
      <Text className={classes.preview}>{item.preview}</Text>
    </Box>
  );
};

const Viewer = ({
  onReply,
  onChanged,
}: {
  onReply: (p?: ComposePrefill) => void;
  onChanged: () => void;
}) => {
  const t = useT();
  const [selected, setSelected] = useAtom(selectedAtom);
  const [dlState, setDlState] = useState<Record<number, "loading" | "done">>(
    {},
  );
  if (!selected) return null;

  const toggleStar = async () => {
    const res = await api.toggleStar(selected.itemId);
    if (res.ok) setSelected({ ...selected, isStarred: res.starred });
    onChanged();
  };

  const del = async () => {
    await api.deleteMail(selected.itemId);
    setSelected(null);
    onChanged();
  };

  const download = async (id: number) => {
    if (dlState[id]) return;
    setDlState((s) => ({ ...s, [id]: "loading" }));
    const res = await api.downloadAttachment(id);
    setDlState((s) => {
      const n = { ...s };
      if (res.ok) n[id] = "done";
      else delete n[id];
      return n;
    });
  };

  const initials = (selected.from || "?").slice(0, 1).toUpperCase();

  return (
    <>
      <Box className={classes.toolbar}>
        <UnstyledButton
          className={`${classes.iconBtn} ${selected.isStarred ? classes.iconBtnOn : ""}`}
          onClick={toggleStar}
        >
          <Star
            size={14}
            color={selected.isStarred ? "var(--yellow)" : "currentColor"}
            fill={selected.isStarred ? "var(--yellow)" : "none"}
          />{" "}
          {t("viewer.star")}
        </UnstyledButton>
        <UnstyledButton
          className={classes.iconBtn}
          onClick={() =>
            onReply({
              to: selected.from,
              subject: replySubject(selected.subject),
            })
          }
        >
          <Reply size={14} /> {t("viewer.reply")}
        </UnstyledButton>
        <UnstyledButton
          className={classes.iconBtn}
          onClick={() =>
            onReply({
              subject: fwdSubject(selected.subject),
              body:
                t("viewer.fwd_header", {
                  from: selected.from,
                  date: fmtFull(selected.createdAt),
                  subject: selected.subject || t("list.no_subject"),
                }) + (selected.body || ""),
              forwardOf: selected.itemId,
            })
          }
        >
          <Forward size={14} /> {t("viewer.forward")}
        </UnstyledButton>
        <UnstyledButton className={classes.iconBtn} onClick={del}>
          <Trash2 size={14} /> {t("viewer.delete")}
        </UnstyledButton>
      </Box>
      <Box>
        <Text className={classes.headTitle}>
          {selected.subject || t("list.no_subject")}
        </Text>
        <Box className={classes.senderInfo}>
          <Box className={classes.avatar}>
            {selected.fromAvatar ? (
              <Image
                src={selected.fromAvatar}
                alt={initials}
                w="100%"
                h="100%"
                fit="cover"
              />
            ) : (
              initials
            )}
          </Box>
          <Box>
            <Text className={classes.from}>
              {selected.fromName
                ? `${selected.fromName} <${selected.from}>`
                : selected.from}
            </Text>
            <Text className={classes.to}>
              {t("viewer.to")}: {selected.to.join(", ")}
            </Text>
          </Box>
        </Box>
      </Box>
      <MailBody body={selected.body} />
      {selected.attachments.length > 0 && (
        <Box className={classes.attachments}>
          {selected.attachments.map((a) => (
            <Box className={classes.attachCard} key={a.id}>
              <Box className={classes.thumb}>
                {a.type === "image" && a.url !== "#" ? (
                  <Image
                    src={a.url}
                    alt={a.name}
                    w="100%"
                    h="100%"
                    fit="cover"
                  />
                ) : a.type === "video" ? (
                  <Video size={28} />
                ) : a.type === "image" ? (
                  <ImageIcon size={28} />
                ) : (
                  <FileText size={28} />
                )}
              </Box>
              <Box className={classes.meta}>
                <Text className={classes.fname}>{a.name}</Text>
                <UnstyledButton
                  className={classes.dl}
                  disabled={!!dlState[a.id]}
                  onClick={() => download(a.id)}
                >
                  <Download size={11} />{" "}
                  {dlState[a.id] === "done"
                    ? t("viewer.downloaded")
                    : dlState[a.id] === "loading"
                      ? t("viewer.downloading")
                      : t("viewer.download")}
                </UnstyledButton>
              </Box>
            </Box>
          ))}
        </Box>
      )}
    </>
  );
};
