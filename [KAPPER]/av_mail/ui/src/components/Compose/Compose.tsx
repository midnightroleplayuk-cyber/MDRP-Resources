import { useEffect, useState } from "react";
import { useAtom, useAtomValue } from "jotai";
import {
  Modal,
  Box,
  Text,
  UnstyledButton,
  TextInput,
  Textarea,
  Button,
  TagsInput,
} from "@mantine/core";
import { Paperclip, X, FileText, Image as ImageIcon, Video } from "lucide-react";
import {
  composeAtom,
  composePrefillAtom,
  profileAtom,
} from "../../reducers/atoms";
import type { LaptopFile } from "../../types/types";
import { api } from "../../Api/api";
import { isAllowedHost, countBodyImages } from "../../Api/hosts";
import { useT } from "../../hooks/useLang";
import global from "../../global.module.css";
import classes from "./style.module.css";

const MAX_ATTACH = 5;
const accentBtn = { backgroundColor: "var(--accent)", color: "#07222a" };

const typeIcon = (type: string) =>
  type === "image" ? (
    <ImageIcon size={14} />
  ) : type === "video" ? (
    <Video size={14} />
  ) : (
    <FileText size={14} />
  );

export const Compose = ({ onSent }: { onSent: () => void }) => {
  const t = useT();
  const [, setOpen] = useAtom(composeAtom);
  const prefill = useAtomValue(composePrefillAtom);
  const profile = useAtomValue(profileAtom);

  const maxBody = profile?.maxBody ?? 2000;
  const maxSubject = profile?.maxSubject ?? 120;
  const maxImages = profile?.maxBodyImages ?? 5;
  const imageHosts = profile?.imageHosts ?? [];

  const [recipients, setRecipients] = useState<string[]>(
    (prefill.to || "")
      .split(",")
      .map((x) => x.trim())
      .filter(Boolean),
  );
  const [subject, setSubject] = useState(
    (prefill.subject || "").slice(0, maxSubject),
  );
  const [body, setBody] = useState((prefill.body || "").slice(0, maxBody));
  const [error, setError] = useState("");
  const [sending, setSending] = useState(false);

  const [pickerOpen, setPickerOpen] = useState(false);
  const [files, setFiles] = useState<LaptopFile[]>([]);
  const [selected, setSelected] = useState<LaptopFile[]>([]);
  const [contacts, setContacts] = useState<{ name: string; email: string }[]>(
    [],
  );
  const [imgOpen, setImgOpen] = useState(false);
  const [imgUrl, setImgUrl] = useState("");
  const [imgErr, setImgErr] = useState("");

  useEffect(() => {
    (async () => {
      const res = await api.getContacts();
      if (res.ok)
        setContacts(
          (res.contacts || []).map((c: any) => ({
            name: c.name,
            email: c.email,
          })),
        );
    })();
  }, []);

  const openPicker = async () => {
    setPickerOpen(true);
    if (files.length === 0) {
      const res = await api.getMyFiles();
      if (res.ok) setFiles(res.files || []);
    }
  };

  const toggleFile = (file: LaptopFile) => {
    setSelected((prev) => {
      const exists = prev.find((x) => x.id === file.id);
      if (exists) return prev.filter((x) => x.id !== file.id);
      if (prev.length >= MAX_ATTACH) return prev;
      return [...prev, file];
    });
  };

  const addImage = () => {
    setImgErr("");
    const url = imgUrl.trim();
    if (!url) return;
    if (!isAllowedHost(url, imageHosts))
      return setImgErr(t("compose.image_bad_host"));
    if (countBodyImages(body) >= maxImages)
      return setImgErr(t("compose.image_limit", { max: maxImages }));
    setBody(
      (b) => `${b}${b && !b.endsWith("\n") ? "\n" : ""}[img]${url}[/img]\n`,
    );
    setImgUrl("");
    setImgOpen(false);
  };

  const send = async () => {
    setError("");
    if (!recipients.length) return setError(t("compose.need_recipient"));
    setSending(true);
    const payload = {
      to: recipients.join(", "),
      subject,
      body,
      attachments: selected.map((f) => ({ file_id: f.id })),
    };
    const res = prefill.forwardOf
      ? await api.forwardMail({ id: prefill.forwardOf, ...payload })
      : await api.sendMail(payload);
    setSending(false);
    if (res.ok) {
      setOpen(false);
      onSent();
    } else {
      setError(t(res.error, res.errorParams));
    }
  };

  return (
    <Modal
      opened
      onClose={() => setOpen(false)}
      title={prefill.forwardOf ? t("compose.forward_title") : t("compose.title")}
      size="lg"
      centered
      classNames={{ content: global.content, header: global.header }}
      c="white"
      withinPortal
    >
      {error && <Box className={classes.error}>{error}</Box>}

      <TagsInput
        label={t("compose.to")}
        placeholder={recipients.length ? "" : t("compose.to_placeholder")}
        value={recipients}
        onChange={setRecipients}
        data={contacts.map((c) => c.email)}
        splitChars={[",", ";", " "]}
        limit={6}
        comboboxProps={{ withinPortal: false }}
        filter={({ options, search }: any) => {
          const q = search.trim().toLowerCase();
          if (!q) return options;
          return options.filter((o: any) => {
            const c = contacts.find((x) => x.email === o.value);
            return (
              o.value.toLowerCase().includes(q) ||
              (c ? c.name.toLowerCase().includes(q) : false)
            );
          });
        }}
        renderOption={({ option }: any) => {
          const c = contacts.find((x) => x.email === option.value);
          return (
            <Box>
              <Text span className={classes.optionName}>
                {c ? c.name : option.value}
              </Text>
              {c && (
                <Text span className={classes.optionEmail}>
                  {option.value}
                </Text>
              )}
            </Box>
          );
        }}
        classNames={{
          input: global.input,
          dropdown: global.dropdown,
          option: global.option,
        }}
        mb="sm"
      />
      <TextInput
        label={t("compose.subject")}
        value={subject}
        maxLength={maxSubject}
        onChange={(e) => setSubject(e.currentTarget.value)}
        classNames={{ input: global.input }}
        mb="sm"
      />
      <Textarea
        label={t("compose.message")}
        autosize
        minRows={6}
        maxRows={12}
        value={body}
        maxLength={maxBody}
        onChange={(e) => setBody(e.currentTarget.value.slice(0, maxBody))}
        classNames={{ input: global.input }}
      />
      <Text className={classes.charCount}>
        {t("compose.char_count", { count: body.length, max: maxBody })}
      </Text>

      {selected.length > 0 && (
        <Box className={classes.chips}>
          {selected.map((f) => (
            <Box key={f.id} className={classes.chip}>
              {typeIcon(f.type)} {f.name}
              <X
                size={12}
                style={{ cursor: "pointer" }}
                onClick={() => toggleFile(f)}
              />
            </Box>
          ))}
        </Box>
      )}

      {pickerOpen && (
        <Box className={classes.panel}>
          <Text className={classes.panelTitle}>
            {t("compose.files_title")} ({selected.length}/{MAX_ATTACH})
          </Text>
          {files.length === 0 && (
            <Text className={classes.pill}>{t("compose.no_files")}</Text>
          )}
          {files.map((f) => {
            const on = !!selected.find((x) => x.id === f.id);
            return (
              <Box
                key={f.id}
                className={classes.fileRow}
                style={{ opacity: on ? 1 : 0.85 }}
                onClick={() => toggleFile(f)}
              >
                <Box className={classes.fileName}>
                  {typeIcon(f.type)} {f.name}
                </Box>
                <Text span className={classes.pill}>
                  {on ? t("compose.selected") : f.type}
                </Text>
              </Box>
            );
          })}
        </Box>
      )}

      {imgOpen && (
        <Box className={classes.imageForm}>
          <TextInput
            placeholder={t("compose.image_url_ph")}
            value={imgUrl}
            onChange={(e) => setImgUrl(e.currentTarget.value)}
            onKeyDown={(e) => e.key === "Enter" && addImage()}
            classNames={{ input: global.input }}
            size="xs"
            style={{ flex: 1 }}
          />
          <Button size="xs" style={accentBtn} onClick={addImage}>
            {t("compose.image_add_confirm")}
          </Button>
        </Box>
      )}
      {imgErr && <Text className={classes.imageErr}>{imgErr}</Text>}

      <Box className={classes.footer}>
        <Button
          variant="default"
          leftSection={<Paperclip size={15} />}
          onClick={openPicker}
          classNames={{ root: global.button }}
        >
          {t("compose.attach")}
        </Button>
        <Button
          variant="default"
          leftSection={<ImageIcon size={15} />}
          onClick={() => {
            setImgOpen((v) => !v);
            setImgErr("");
          }}
          classNames={{ root: global.button }}
        >
          {t("compose.add_image")}
        </Button>
        <Button style={accentBtn} loading={sending} onClick={send} ml="auto">
          {t("compose.send")}
        </Button>
      </Box>
    </Modal>
  );
};
