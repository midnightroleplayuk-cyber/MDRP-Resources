import { useCallback, useEffect, useState } from "react";
import { Box, Text, TextInput, Button } from "@mantine/core";
import { UserPlus, Trash2, Pencil, Check, X } from "lucide-react";
import type { Contact } from "../../types/types";
import { api } from "../../Api/api";
import { useT } from "../../hooks/useLang";
import global from "../../global.module.css";
import classes from "./style.module.css";

const accentBtn = { backgroundColor: "var(--accent)", color: "#07222a" };

export const Contacts = () => {
  const t = useT();
  const [rows, setRows] = useState<Contact[]>([]);
  const [error, setError] = useState("");
  const [showForm, setShowForm] = useState(false);
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [editing, setEditing] = useState<number | null>(null);
  const [editName, setEditName] = useState("");
  const [editEmail, setEditEmail] = useState("");

  const load = useCallback(async () => {
    const res = await api.getContacts();
    if (res.ok) setRows(res.contacts || []);
  }, []);

  useEffect(() => {
    load();
  }, [load]);

  const add = async () => {
    setError("");
    if (!name.trim() || !email.trim()) return;
    const res = await api.addContact(name.trim(), email.trim().toLowerCase());
    if (res.ok) {
      setName("");
      setEmail("");
      setShowForm(false);
      load();
    } else setError(t(res.error, res.errorParams));
  };

  const startEdit = (c: Contact) => {
    setEditing(c.id);
    setEditName(c.name);
    setEditEmail(c.email);
  };

  const saveEdit = async () => {
    if (editing == null) return;
    const res = await api.updateContact(
      editing,
      editName.trim(),
      editEmail.trim().toLowerCase(),
    );
    if (res.ok) {
      setEditing(null);
      load();
    } else setError(t(res.error, res.errorParams));
  };

  const del = async (id: number) => {
    const res = await api.deleteContact(id);
    if (res.ok) load();
  };

  return (
    <Box className={classes.screen}>
      <Text className={classes.title}>{t("contacts.title")}</Text>
      <Text className={classes.sub}>{t("contacts.subtitle")}</Text>

      {error && <Box className={classes.error}>{error}</Box>}

      <Box className={classes.panel}>
        <Box className={classes.panelHead}>
          <Text className={classes.panelTitle}>{t("contacts.list_title")}</Text>
          <Button
            size="xs"
            style={accentBtn}
            leftSection={<UserPlus size={14} />}
            onClick={() => {
              setShowForm((s) => !s);
              setName("");
              setEmail("");
            }}
          >
            {showForm ? t("contacts.cancel") : t("contacts.add")}
          </Button>
        </Box>

        {showForm && (
          <Box className={classes.form}>
            <TextInput
              placeholder={t("contacts.name_ph")}
              value={name}
              onChange={(e) => setName(e.currentTarget.value)}
              classNames={{ input: global.input }}
              size="xs"
              style={{ flex: 1 }}
            />
            <TextInput
              placeholder={t("contacts.email_ph")}
              value={email}
              onChange={(e) => setEmail(e.currentTarget.value)}
              classNames={{ input: global.input }}
              size="xs"
              style={{ flex: 1 }}
            />
            <Button size="xs" style={accentBtn} onClick={add}>
              {t("contacts.save")}
            </Button>
          </Box>
        )}

        {rows.length === 0 && (
          <Text className={classes.emptyHint}>{t("contacts.none")}</Text>
        )}
        {rows.map((c) => (
          <Box className={classes.row} key={c.id}>
            {editing === c.id ? (
              <Box className={classes.rowEdit}>
                <TextInput
                  value={editName}
                  onChange={(e) => setEditName(e.currentTarget.value)}
                  classNames={{ input: global.input }}
                  size="xs"
                  style={{ flex: 1 }}
                />
                <TextInput
                  value={editEmail}
                  onChange={(e) => setEditEmail(e.currentTarget.value)}
                  classNames={{ input: global.input }}
                  size="xs"
                  style={{ flex: 1 }}
                />
              </Box>
            ) : (
              <Text span>
                {c.name}{" "}
                <Text span className={classes.pill}>
                  {c.email}
                </Text>
              </Text>
            )}
            <Box className={classes.actions}>
              {editing === c.id ? (
                <>
                  <Check
                    size={15}
                    style={{ cursor: "pointer", color: "var(--accent)" }}
                    onClick={saveEdit}
                  />
                  <X
                    size={15}
                    style={{ cursor: "pointer", color: "var(--text-dim)" }}
                    onClick={() => setEditing(null)}
                  />
                </>
              ) : (
                <>
                  <Pencil
                    size={14}
                    style={{ cursor: "pointer", color: "var(--text-dim)" }}
                    onClick={() => startEdit(c)}
                  />
                  <Trash2
                    size={14}
                    style={{ cursor: "pointer", color: "var(--danger)" }}
                    onClick={() => del(c.id)}
                  />
                </>
              )}
            </Box>
          </Box>
        ))}
      </Box>
    </Box>
  );
};
