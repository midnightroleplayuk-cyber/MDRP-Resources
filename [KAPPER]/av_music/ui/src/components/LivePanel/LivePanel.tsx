import { useState, useEffect, useCallback } from "react";
import { Box, Text } from "@mantine/core";
import { fetchNui, isEnvBrowser, useNuiEvent } from "../../hooks/useNuiEvents";
import { Radio, X, Eye, EyeOff, Rss } from "lucide-react";
import { useAtomValue } from "jotai";
import { Lang } from "../../reducers/atoms";
import classes from "./style.module.css";

const Field = ({
  label,
  value,
  onChange,
  placeholder,
}: {
  label: string;
  value: string;
  onChange: (v: string) => void;
  placeholder?: string;
}) => (
  <Box className={classes.field}>
    <Text component="label" className={classes.fieldLabel}>
      {label}
    </Text>
    <input
      className={classes.fieldInput}
      value={value}
      onChange={(e) => onChange(e.target.value)}
      placeholder={placeholder}
      spellCheck={false}
    />
  </Box>
);

export const LivePanel = () => {
  const lang: any = useAtomValue(Lang);
  const [open, setOpen] = useState(isEnvBrowser());
  const [name, setName] = useState("");
  const [cover, setCover] = useState("");
  const [url, setUrl] = useState("");
  const [previewing, setPreviewing] = useState(false);
  const [publishing, setPublishing] = useState(false);
  const [published, setPublished] = useState(false);
  const [error, setError] = useState("");

  useNuiEvent("openLivePanel", () => {
    setOpen(true);
    setError("");
    setPublished(false);
  });

  const close = useCallback(() => {
    if (previewing) {
      fetchNui("av_music", "livePreview", { action: "stop" });
      setPreviewing(false);
    }
    setOpen(false);
    fetchNui("av_music", "closeLivePanel", {});
  }, [previewing]);

  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape" && open) close();
    };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [open, close]);

  const handlePreview = async () => {
    if (!url.trim()) {
      setError(lang.live_err_url ?? "Stream URL is required");
      return;
    }
    setError("");
    if (previewing) {
      await fetchNui("av_music", "livePreview", { action: "stop" });
      setPreviewing(false);
    } else {
      await fetchNui("av_music", "livePreview", {
        action: "start",
        url: url.trim(),
      });
      setPreviewing(true);
    }
  };

  const handlePublish = async () => {
    if (!name.trim()) {
      setError(lang.live_err_name ?? "Stream name is required");
      return;
    }
    if (!url.trim()) {
      setError(lang.live_err_stream ?? "Stream URL is required");
      return;
    }
    setError("");
    setPublishing(true);
    await fetchNui("av_music", "livePublish", {
      name: name.trim(),
      cover: cover.trim(),
      url: url.trim(),
    });
    setPublishing(false);
    setPublished(true);
  };

  if (!open) return null;

  return (
    <Box className={classes.backdrop}>
      <Box className={classes.panel}>
        <Box className={classes.panelHeader}>
          <Box className={classes.headerLeft}>
            <Box className={classes.iconBox}>
              <Radio size={16} color="var(--accent)" />
            </Box>
            <Text className={classes.panelTitle}>
              {lang.live_go_live ?? "Go Live"}
            </Text>
          </Box>
          <Box component="button" className={classes.closeBtn} onClick={close}>
            <X size={18} />
          </Box>
        </Box>
        <Box className={classes.panelBody}>
          <Box
            className={classes.coverPreview}
            style={cover ? { backgroundImage: `url('${cover}')` } : undefined}
          >
            {!cover && (
              <Box className={classes.noCover}>
                <Rss size={26} />
                <Text className={classes.noCoverLabel}>
                  {lang.live_no_cover ?? "No cover"}
                </Text>
              </Box>
            )}
          </Box>
          <Field
            label={lang.live_name_label ?? "STREAM NAME"}
            value={name}
            onChange={setName}
            placeholder={lang.live_name_placeholder ?? "My Live Radio"}
          />
          <Field
            label={lang.live_cover_label ?? "COVER IMAGE (URL)"}
            value={cover}
            onChange={setCover}
            placeholder={
              lang.live_cover_placeholder ?? "https://fivemanage.com/..."
            }
          />
          <Field
            label={lang.live_url_label ?? "STREAM URL"}
            value={url}
            onChange={setUrl}
            placeholder={
              lang.live_url_placeholder ?? "https://youtube.com/watch?v=..."
            }
          />
          {error && <Box className={classes.errorBox}>{error}</Box>}
          {published && (
            <Box className={classes.successBox}>
              {lang.live_success ??
                "Live published! Now visible in the Radio tab."}
            </Box>
          )}
        </Box>
        <Box className={classes.panelFooter}>
          <Box
            component="button"
            onClick={handlePreview}
            className={`${classes.previewBtn} ${previewing ? classes.previewBtnActive : ""}`}
          >
            {previewing ? <EyeOff size={14} /> : <Eye size={14} />}
            {previewing
              ? (lang.live_stop_preview ?? "Stop Preview")
              : (lang.live_preview ?? "Preview")}
          </Box>

          <Box
            component="button"
            onClick={handlePublish}
            disabled={publishing || published}
            className={`${classes.publishBtn} ${published ? classes.publishBtnDone : ""}`}
          >
            {publishing
              ? (lang.live_publishing ?? "Publishing…")
              : published
                ? (lang.live_published ?? "Published ✓")
                : (lang.live_publish ?? "Publish Live")}
          </Box>
        </Box>
      </Box>
    </Box>
  );
};
