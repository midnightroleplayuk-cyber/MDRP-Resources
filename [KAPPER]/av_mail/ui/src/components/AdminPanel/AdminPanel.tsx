import { useCallback, useEffect, useState } from "react";
import { useAtom } from "jotai";
import {
  Box,
  Text,
  UnstyledButton,
  TextInput,
  Textarea,
  NativeSelect,
  Tooltip,
} from "@mantine/core";
import {
  X,
  RefreshCw,
  Plus,
  Trash2,
  Pencil,
  KeyRound,
  Send,
  Users,
  Globe,
  ShieldCheck,
  Check,
  Search,
} from "lucide-react";
import { adminOpenAtom } from "../../reducers/atoms";
import { fetchNui, isEnvBrowser } from "../../hooks/useNuiEvents";
import { useT } from "../../hooks/useLang";
import { Loading } from "../Loading";
import classes from "./style.module.css";

type TabKey = "accounts" | "whitelist" | "domains" | "broadcast";

interface Account {
  id: number;
  address: string;
  displayName: string;
  domain: string;
  owner: string;
  createdAt: string;
}
interface DomainRow {
  id: number;
  domain: string;
  owner: string | null;
  price: number;
  isDefault: number;
}
interface WlEntry {
  identifier: string;
  label: string;
}

async function adminCall(event: string, data?: any, mock?: any): Promise<any> {
  if (isEnvBrowser()) return mock ?? { ok: true };
  return (await fetchNui("av_mail", event, data)) ?? { ok: false };
}

type TFn = ReturnType<typeof useT>;

const inputClasses = {
  root: classes.formField,
  label: classes.formLabel,
  input: classes.formInput,
};
const selectClasses = {
  root: classes.formField,
  label: classes.formLabel,
  input: classes.formSelect,
};
const textareaClasses = {
  root: classes.formField,
  label: classes.formLabel,
  input: classes.formTextarea,
};

export const AdminPanel = () => {
  const t = useT();
  const [open, setOpen] = useAtom(adminOpenAtom);
  const [tab, setTab] = useState<TabKey>("accounts");
  const [scale, setScale] = useState(1);

  const close = useCallback(() => {
    setOpen(false);
    if (!isEnvBrowser()) fetchNui("av_mail", "adminClose", {});
  }, [setOpen]);

  useEffect(() => {
    if (!open) return;
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape") close();
    };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [open, close]);

  useEffect(() => {
    const compute = () =>
      setScale(
        Math.max(
          1,
          Math.min(window.innerWidth / 1920, window.innerHeight / 1080),
        ),
      );
    compute();
    window.addEventListener("resize", compute);
    return () => window.removeEventListener("resize", compute);
  }, []);

  if (!open) return null;

  const tabs: { key: TabKey; label: string }[] = [
    { key: "accounts", label: t("admin.tab_accounts") },
    { key: "whitelist", label: t("admin.tab_whitelist") },
    { key: "domains", label: t("admin.tab_domains") },
    { key: "broadcast", label: t("admin.tab_broadcast") },
  ];

  return (
    <Box className={classes.wrapper}>
      <Box
        className={classes.panel}
        style={{ transform: scale !== 1 ? `scale(${scale})` : undefined }}
      >
        <Box className={classes.navbar}>
          <Text span className={classes.brand}>
            {t("app.name")}
          </Text>
          <Text span className={classes.brandSub}>
            {t("admin.title")}
          </Text>
          <Box className={classes.navSpacer} />
          <Box className={classes.navTabs}>
            {tabs.map((tb) => (
              <UnstyledButton
                key={tb.key}
                className={`${classes.navTab} ${tab === tb.key ? classes.navTabActive : ""}`}
                onClick={() => setTab(tb.key)}
              >
                {tb.label}
              </UnstyledButton>
            ))}
          </Box>
          <UnstyledButton className={classes.closeBtn} onClick={close}>
            <X size={16} />
          </UnstyledButton>
        </Box>

        {tab === "accounts" && <AccountsTab t={t} />}
        {tab === "whitelist" && <WhitelistTab t={t} />}
        {tab === "domains" && <DomainsTab t={t} />}
        {tab === "broadcast" && <BroadcastTab t={t} />}
      </Box>
    </Box>
  );
};

const Header = ({
  desc,
  onRefresh,
  action,
  search,
}: {
  desc: string;
  onRefresh: () => void;
  action?: React.ReactNode;
  search?: {
    value: string;
    onChange: (v: string) => void;
    placeholder: string;
  };
}) => {
  const t = useT();
  return (
    <Box className={classes.contentHeader}>
      <Text span className={classes.contentDesc}>
        {desc}
      </Text>
      <Box className={classes.contentActions}>
        {search && (
          <Box className={classes.searchBox}>
            <Search size={13} />
            <input
              className={classes.searchInput}
              placeholder={search.placeholder}
              value={search.value}
              onChange={(e) => search.onChange(e.currentTarget.value)}
            />
          </Box>
        )}
        <UnstyledButton className={classes.refreshBtn} onClick={onRefresh}>
          <RefreshCw size={11} /> {t("admin.refresh")}
        </UnstyledButton>
        {action}
      </Box>
    </Box>
  );
};

const Empty = ({ icon, text }: { icon: React.ReactNode; text: string }) => (
  <Box className={classes.centerBox}>
    {icon}
    <Text span className={classes.emptyText}>
      {text}
    </Text>
  </Box>
);

const AccountsTab = ({ t }: { t: TFn }) => {
  const [rows, setRows] = useState<Account[]>([]);
  const [loading, setLoading] = useState(false);
  const [banner, setBanner] = useState<{
    address: string;
    password: string;
  } | null>(null);
  const [query, setQuery] = useState("");

  const load = useCallback(async () => {
    setLoading(true);
    const res = await adminCall("adminListAccounts", undefined, {
      ok: true,
      accounts: [
        {
          id: 1,
          address: "john@avscripts.com",
          displayName: "John Doe",
          domain: "avscripts.com",
          owner: "char1:abc",
          createdAt: "",
        },
        {
          id: 2,
          address: "maria@taxi.com",
          displayName: "Maria",
          domain: "taxi.com",
          owner: "char2:def",
          createdAt: "",
        },
      ],
    });
    setLoading(false);
    if (res.ok) setRows(res.accounts || []);
  }, []);

  useEffect(() => {
    load();
  }, [load]);

  const reset = async (address: string) => {
    const res = await adminCall(
      "adminResetPassword",
      { address },
      { ok: true, password: "temp1234" },
    );
    if (res.ok) setBanner({ address, password: res.password });
  };

  const del = async (address: string) => {
    const res = await adminCall("adminDeleteAccount", { address });
    if (res.ok) load();
  };

  const q = query.trim().toLowerCase();
  const shown = q
    ? rows.filter((a) =>
        `${a.address} ${a.owner} ${a.displayName} ${a.domain}`
          .toLowerCase()
          .includes(q),
      )
    : rows;

  return (
    <>
      <Header
        desc={t("admin.accounts_desc")}
        onRefresh={load}
        search={{
          value: query,
          onChange: setQuery,
          placeholder: t("admin.search_accounts"),
        }}
      />
      {banner && (
        <Box className={classes.banner}>
          <KeyRound size={13} />
          <Text span>{t("admin.pw_reset_for", { addr: banner.address })}</Text>
          <Text span className={classes.pwText}>
            {banner.password}
          </Text>
        </Box>
      )}
      <Box className={`${classes.tableHead} ${classes.accountsGrid}`}>
        <Text span className={classes.thCell}>
          {t("admin.col_address")}
        </Text>
        <Text span className={classes.thCell}>
          {t("admin.col_identifier")}
        </Text>
        <Text span className={classes.thCell}>
          {t("admin.col_name")}
        </Text>
        <Text span className={classes.thCell}>
          {t("admin.col_domain")}
        </Text>
        <Text span className={classes.thCell}>
          {t("admin.col_actions")}
        </Text>
      </Box>
      <Box className={classes.tableWrap}>
        {loading ? (
          <Loading />
        ) : shown.length === 0 ? (
          <Empty icon={<Users size={26} />} text={t("admin.no_accounts")} />
        ) : (
          shown.map((a) => (
            <Box
              key={a.id}
              className={`${classes.tableRow} ${classes.accountsGrid}`}
            >
              <Text span className={classes.tdCell}>
                {a.address}
              </Text>
              <Text span className={`${classes.tdCell} ${classes.tdMono}`}>
                {a.owner}
              </Text>
              <Text span className={classes.tdCell}>
                {a.displayName}
              </Text>
              <Text span className={classes.tdCell}>
                @{a.domain}
              </Text>
              <Box className={`${classes.tdCell} ${classes.rowActions}`}>
                <Tooltip
                  label={t("admin.reset_pw_tip")}
                  withArrow
                  withinPortal={false}
                  color="dark"
                >
                  <UnstyledButton
                    className={classes.iconBtn}
                    onClick={() => reset(a.address)}
                  >
                    <KeyRound size={14} />
                  </UnstyledButton>
                </Tooltip>
                <Tooltip
                  label={t("admin.delete_tip")}
                  withArrow
                  withinPortal={false}
                  color="dark"
                >
                  <UnstyledButton
                    className={`${classes.iconBtn} ${classes.danger}`}
                    onClick={() => del(a.address)}
                  >
                    <Trash2 size={14} />
                  </UnstyledButton>
                </Tooltip>
              </Box>
            </Box>
          ))
        )}
      </Box>
    </>
  );
};

const WhitelistTab = ({ t }: { t: TFn }) => {
  const [rows, setRows] = useState<WlEntry[]>([]);
  const [loading, setLoading] = useState(false);
  const [showForm, setShowForm] = useState(false);
  const [identifier, setIdentifier] = useState("");
  const [label, setLabel] = useState("");
  const [query, setQuery] = useState("");

  const load = useCallback(async () => {
    setLoading(true);
    const res = await adminCall("adminGetDomainWhitelist", undefined, {
      ok: true,
      whitelist: [{ identifier: "char1:abc", label: "Police Chief" }],
    });
    setLoading(false);
    if (res.ok) setRows(res.whitelist || []);
  }, []);

  useEffect(() => {
    load();
  }, [load]);

  const add = async () => {
    if (!identifier.trim()) return;
    const res = await adminCall("adminAddDomainWhitelist", {
      identifier: identifier.trim(),
      label: label.trim(),
    });
    if (res.ok) {
      setIdentifier("");
      setLabel("");
      setShowForm(false);
      load();
    }
  };

  const remove = async (id: string) => {
    const res = await adminCall("adminRemoveDomainWhitelist", {
      identifier: id,
    });
    if (res.ok) load();
  };

  const q = query.trim().toLowerCase();
  const shown = q
    ? rows.filter((e) => `${e.label} ${e.identifier}`.toLowerCase().includes(q))
    : rows;

  return (
    <>
      <Header
        desc={t("admin.wl_desc")}
        onRefresh={load}
        search={{
          value: query,
          onChange: setQuery,
          placeholder: t("admin.search_whitelist"),
        }}
        action={
          <UnstyledButton
            className={classes.addBtn}
            onClick={() => setShowForm((s) => !s)}
          >
            <Plus size={13} />{" "}
            {showForm ? t("admin.cancel") : t("admin.wl_add")}
          </UnstyledButton>
        }
      />
      {showForm && (
        <Box className={classes.inlineForm}>
          <TextInput
            unstyled
            label={t("admin.wl_identifier")}
            placeholder={t("admin.wl_identifier_ph")}
            value={identifier}
            onChange={(e) => setIdentifier(e.currentTarget.value)}
            classNames={inputClasses}
          />
          <TextInput
            unstyled
            label={t("admin.wl_label")}
            placeholder={t("admin.wl_label_ph")}
            value={label}
            onChange={(e) => setLabel(e.currentTarget.value)}
            classNames={inputClasses}
          />
          <UnstyledButton
            className={classes.placeBtn}
            disabled={!identifier.trim()}
            onClick={add}
          >
            <Plus size={13} /> {t("admin.add")}
          </UnstyledButton>
        </Box>
      )}
      <Box className={classes.wlList}>
        {loading ? (
          <Loading />
        ) : shown.length === 0 ? (
          <Empty icon={<ShieldCheck size={26} />} text={t("admin.wl_none")} />
        ) : (
          shown.map((e) => (
            <Box key={e.identifier} className={classes.wlRow}>
              <Box className={classes.wlRowInfo}>
                <Text span className={classes.wlRowLabel}>
                  {e.label}
                </Text>
                <Text span className={classes.wlRowId}>
                  {e.identifier}
                </Text>
              </Box>
              <UnstyledButton
                className={`${classes.iconBtn} ${classes.danger}`}
                onClick={() => remove(e.identifier)}
              >
                <Trash2 size={14} />
              </UnstyledButton>
            </Box>
          ))
        )}
      </Box>
    </>
  );
};

const DomainsTab = ({ t }: { t: TFn }) => {
  const [rows, setRows] = useState<DomainRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [showForm, setShowForm] = useState(false);
  const [domain, setDomain] = useState("");
  const [identifier, setIdentifier] = useState("");
  const [editing, setEditing] = useState<string | null>(null);
  const [editId, setEditId] = useState("");
  const [query, setQuery] = useState("");

  const load = useCallback(async () => {
    setLoading(true);
    const res = await adminCall("adminListDomains", undefined, {
      ok: true,
      domains: [
        {
          id: 2,
          domain: "lspd.com",
          owner: "char1:abc",
          price: 0,
          isDefault: 0,
        },
        {
          id: 3,
          domain: "taxi.com",
          owner: "char2:def",
          price: 50000,
          isDefault: 0,
        },
      ],
    });
    setLoading(false);
    if (res.ok) setRows(res.domains || []);
  }, []);

  useEffect(() => {
    load();
  }, [load]);

  const assign = async (dom: string, id: string) => {
    const res = await adminCall("adminAssignDomain", {
      domain: dom.trim().toLowerCase(),
      identifier: id.trim(),
    });
    if (res.ok) load();
  };

  const create = async () => {
    if (!domain.trim()) return;
    await assign(domain, identifier);
    setDomain("");
    setIdentifier("");
    setShowForm(false);
  };

  const saveEdit = async (dom: string) => {
    await assign(dom, editId);
    setEditing(null);
    setEditId("");
  };

  const del = async (dom: string) => {
    const res = await adminCall("adminDeleteDomain", { domain: dom });
    if (res.ok) load();
  };

  const typeLabel = (d: DomainRow) =>
    d.isDefault
      ? t("admin.type_default")
      : d.owner
        ? t("admin.type_reserved")
        : t("admin.type_public");

  const q = query.trim().toLowerCase();
  const shown = q
    ? rows.filter((d) =>
        `${d.domain} ${d.owner || ""}`.toLowerCase().includes(q),
      )
    : rows;

  return (
    <>
      <Header
        desc={t("admin.domains_desc")}
        onRefresh={load}
        search={{
          value: query,
          onChange: setQuery,
          placeholder: t("admin.search_domains"),
        }}
        action={
          <UnstyledButton
            className={classes.addBtn}
            onClick={() => setShowForm((s) => !s)}
          >
            <Plus size={13} />{" "}
            {showForm ? t("admin.cancel") : t("admin.dm_add")}
          </UnstyledButton>
        }
      />
      {showForm && (
        <Box className={classes.inlineForm}>
          <TextInput
            unstyled
            label={t("admin.dm_domain")}
            placeholder={t("admin.dm_domain_ph")}
            value={domain}
            onChange={(e) => setDomain(e.currentTarget.value)}
            classNames={inputClasses}
          />
          <TextInput
            unstyled
            label={t("admin.dm_identifier")}
            placeholder={t("admin.dm_identifier_ph")}
            value={identifier}
            onChange={(e) => setIdentifier(e.currentTarget.value)}
            classNames={inputClasses}
          />
          <UnstyledButton
            className={classes.placeBtn}
            disabled={!domain.trim()}
            onClick={create}
          >
            <Plus size={13} /> {t("admin.save")}
          </UnstyledButton>
        </Box>
      )}
      <Box className={`${classes.tableHead} ${classes.domainsGrid}`}>
        <Text span className={classes.thCell}>
          {t("admin.col_domain")}
        </Text>
        <Text span className={classes.thCell}>
          {t("admin.col_owner")}
        </Text>
        <Text span className={classes.thCell}>
          {t("admin.col_type")}
        </Text>
        <Text span className={classes.thCell}>
          {t("admin.col_actions")}
        </Text>
      </Box>
      <Box className={classes.tableWrap}>
        {loading ? (
          <Loading />
        ) : shown.length === 0 ? (
          <Empty icon={<Globe size={26} />} text={t("admin.no_domains")} />
        ) : (
          shown.map((d) => (
            <Box
              key={d.id}
              className={`${classes.tableRow} ${classes.domainsGrid}`}
            >
              <Text span className={classes.tdCell}>
                @{d.domain}
              </Text>
              <Box className={classes.tdCell}>
                {editing === d.domain ? (
                  <TextInput
                    unstyled
                    placeholder={t("admin.dm_identifier_ph")}
                    value={editId}
                    onChange={(e) => setEditId(e.currentTarget.value)}
                    classNames={{ input: classes.formInput }}
                  />
                ) : d.owner ? (
                  <Text span className={classes.tdMono}>
                    {d.owner}
                  </Text>
                ) : (
                  <Text span className={classes.tdMuted}>
                    {t("admin.public")}
                  </Text>
                )}
              </Box>
              <Box className={classes.tdCell}>
                <Text
                  span
                  className={`${classes.pill} ${d.owner ? classes.pillAccent : ""}`}
                >
                  {typeLabel(d)}
                </Text>
              </Box>
              <Box className={`${classes.tdCell} ${classes.rowActions}`}>
                {editing === d.domain ? (
                  <UnstyledButton
                    className={classes.iconBtn}
                    title={t("admin.save")}
                    onClick={() => saveEdit(d.domain)}
                  >
                    <Check size={14} />
                  </UnstyledButton>
                ) : (
                  <UnstyledButton
                    className={classes.iconBtn}
                    title={t("admin.reassign")}
                    onClick={() => {
                      setEditing(d.domain);
                      setEditId(d.owner || "");
                    }}
                  >
                    <Pencil size={14} />
                  </UnstyledButton>
                )}
                <UnstyledButton
                  className={`${classes.iconBtn} ${classes.danger}`}
                  title={t("admin.delete")}
                  onClick={() => del(d.domain)}
                >
                  <Trash2 size={14} />
                </UnstyledButton>
              </Box>
            </Box>
          ))
        )}
      </Box>
    </>
  );
};

const BroadcastTab = ({ t }: { t: TFn }) => {
  const [audience, setAudience] = useState<"all" | "domain" | "account">("all");
  const [domain, setDomain] = useState("");
  const [address, setAddress] = useState("");
  const [from, setFrom] = useState("");
  const [subject, setSubject] = useState("");
  const [body, setBody] = useState("");
  const [sending, setSending] = useState(false);
  const [sent, setSent] = useState("");

  const send = async () => {
    setSent("");
    setSending(true);
    const res = await adminCall(
      "adminBroadcast",
      { audience, domain, address, from, subject, body },
      { ok: true, count: 12 },
    );
    setSending(false);
    if (res.ok) {
      setSent(t("admin.bc_sent", { count: res.count }));
      setSubject("");
      setBody("");
    }
  };

  return (
    <>
      <Header
        desc={t("admin.bc_desc")}
        onRefresh={() => {
          setSubject("");
          setBody("");
          setSent("");
        }}
      />
      <Box className={classes.broadcastForm}>
        <Box className={classes.broadcastRow}>
          <NativeSelect
            unstyled
            label={t("admin.bc_audience")}
            value={audience}
            onChange={(e) =>
              setAudience(e.currentTarget.value as "all" | "domain" | "account")
            }
            data={[
              { value: "all", label: t("admin.bc_all") },
              { value: "domain", label: t("admin.bc_domain") },
              { value: "account", label: t("admin.bc_account") },
            ]}
            rightSection={<span />}
            rightSectionWidth={0}
            classNames={selectClasses}
          />
          {audience === "domain" && (
            <TextInput
              unstyled
              label={t("admin.col_domain")}
              placeholder={t("admin.bc_domain_ph")}
              value={domain}
              onChange={(e) => setDomain(e.currentTarget.value)}
              classNames={inputClasses}
            />
          )}
          {audience === "account" && (
            <TextInput
              unstyled
              label={t("admin.bc_account")}
              placeholder={t("admin.bc_account_ph")}
              value={address}
              onChange={(e) => setAddress(e.currentTarget.value)}
              classNames={inputClasses}
            />
          )}
          <TextInput
            unstyled
            label={t("admin.bc_from")}
            placeholder={t("admin.bc_from_ph")}
            value={from}
            onChange={(e) => setFrom(e.currentTarget.value)}
            classNames={inputClasses}
          />
        </Box>
        <TextInput
          unstyled
          label={t("admin.bc_subject")}
          value={subject}
          onChange={(e) => setSubject(e.currentTarget.value)}
          classNames={inputClasses}
        />
        <Textarea
          unstyled
          autosize
          minRows={5}
          maxRows={12}
          label={t("admin.bc_body")}
          value={body}
          onChange={(e) => setBody(e.currentTarget.value)}
          classNames={textareaClasses}
        />
        {sent && (
          <Text span className={classes.sentNote}>
            {sent}
          </Text>
        )}
        <Box className={classes.broadcastActions}>
          <UnstyledButton
            className={classes.placeBtn}
            disabled={sending}
            onClick={send}
          >
            <Send size={13} /> {t("admin.bc_send")}
          </UnstyledButton>
        </Box>
      </Box>
    </>
  );
};
