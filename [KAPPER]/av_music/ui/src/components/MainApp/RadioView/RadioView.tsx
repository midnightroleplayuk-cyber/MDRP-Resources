import { useState, useEffect, useCallback } from "react";
import {
  Box,
  Text,
  ScrollArea,
  ActionIcon,
  Tooltip,
  Modal,
} from "@mantine/core";
import { Radio, RefreshCw, Wifi, Eye, EyeOff, Rss, Plus } from "lucide-react";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import { getLives, playLive, LiveStation } from "../../../Api/Api";
import { fetchNui } from "../../../hooks/useNuiEvents";
import { useNuiEvent } from "../../../hooks/useNuiEvents";
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

const GoLiveModal = ({
  opened,
  onClose,
  lang,
  onPublished,
}: {
  opened: boolean;
  onClose: () => void;
  lang: any;
  onPublished: () => void;
}) => {
  const [name, setName] = useState("");
  const [cover, setCover] = useState("");
  const [url, setUrl] = useState("");
  const [previewing, setPreviewing] = useState(false);
  const [publishing, setPublishing] = useState(false);
  const [published, setPublished] = useState(false);
  const [error, setError] = useState("");

  const reset = () => {
    setName("");
    setCover("");
    setUrl("");
    setPreviewing(false);
    setPublishing(false);
    setPublished(false);
    setError("");
  };

  const handleClose = useCallback(async () => {
    if (previewing) {
      await fetchNui("av_music", "livePreview", { action: "stop" });
      setPreviewing(false);
    }
    reset();
    onClose();
  }, [previewing, onClose]);

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
    onPublished();
  };

  return (
    <Modal
      opened={opened}
      onClose={handleClose}
      withCloseButton={false}
      centered
      padding={0}
      radius={16}
      size={420}
      styles={{
        content: {
          background: "var(--bg-card)",
          border: "1px solid var(--border-input)",
          boxShadow: "0 24px 64px rgba(0,0,0,0.7)",
          overflow: "hidden",
        },
        overlay: { background: "rgba(0,0,0,0.55)" },
      }}
    >
      <Box className={classes.modalHeader}>
        <Box className={classes.modalHeaderLeft}>
          <Box className={classes.iconBox}>
            <Radio size={16} color="var(--accent)" />
          </Box>
          <Text className={classes.modalTitle}>
            {lang.live_go_live ?? "Go Live"}
          </Text>
        </Box>
        <Box
          component="button"
          className={classes.closeBtn}
          onClick={handleClose}
        >
          ✕
        </Box>
      </Box>
      <Box className={classes.modalBody}>
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
          placeholder={lang.live_cover_placeholder ?? "https://i.imgur.com/..."}
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
      <Box className={classes.modalFooter}>
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
    </Modal>
  );
};

interface CardProps {
  station: LiveStation;
  onPlay: (s: LiveStation) => void;
  tunedIn: boolean;
  lang: any;
}

const LiveCard = ({ station, onPlay, tunedIn, lang }: CardProps) => {
  const [hover, setHover] = useState(false);

  return (
    <Box
      onClick={() => onPlay(station)}
      onMouseEnter={() => setHover(true)}
      onMouseLeave={() => setHover(false)}
      className={`${classes.card} ${tunedIn ? classes.cardTunedIn : hover ? classes.cardHovered : ""}`}
    >
      <Box className={classes.thumb}>
        {station.cover ? (
          <img
            src={station.cover}
            alt={station.name}
            className={`${classes.thumbImg} ${hover && !tunedIn ? classes.thumbImgDim : ""}`}
            onError={(e) => {
              (e.target as HTMLImageElement).style.display = "none";
            }}
          />
        ) : (
          <Box className={classes.thumbPlaceholder}>
            <Text className={classes.thumbPlaceholderLetter}>
              {station.name?.[0]?.toUpperCase() ?? "R"}
            </Text>
          </Box>
        )}
        <Box className={classes.liveBadge}>
          <Box className={classes.liveDot} />
          <Text className={classes.liveBadgeText}>
            {lang.radio_live_badge ?? "LIVE"}
          </Text>
        </Box>
        {hover && !tunedIn && (
          <Box className={classes.hoverOverlay}>
            <Box className={classes.tuneInPill}>
              <Wifi size={13} color="var(--text-white)" />
              <Text className={classes.tuneInText}>
                {lang.radio_tune_in ?? "Tune in"}
              </Text>
            </Box>
          </Box>
        )}
      </Box>
      <Box className={classes.cardInfo}>
        <Text
          className={`${classes.cardName} ${tunedIn ? classes.cardNameTunedIn : classes.cardNameDefault}`}
        >
          {station.name}
        </Text>
      </Box>
    </Box>
  );
};

export const RadioView = () => {
  const lang: any = useAtomValue(Lang);
  const [lives, setLives] = useState<LiveStation[]>([]);
  const [loading, setLoading] = useState(true);
  const [tunedIn, setTunedIn] = useState<number | null>(null);
  const [liveOpen, setLiveOpen] = useState(false);
  const [canGoLive, setCanGoLive] = useState(false);

  const fetchLives = useCallback(async () => {
    setLoading(true);
    const result = await getLives();
    setLives(result);
    setLoading(false);
  }, []);

  useEffect(() => {
    fetchLives();
    fetchNui<{ whitelisted: boolean }>(
      "av_music",
      "isLiveWhitelisted",
      {},
    ).then((r) => {
      setCanGoLive(r?.whitelisted ?? false);
    });
  }, [fetchLives]);

  useNuiEvent("livesChanged", () => {
    fetchLives();
  });

  const handlePlay = async (station: LiveStation) => {
    setTunedIn(station.owner);
    await playLive(station);
  };

  return (
    <>
      <GoLiveModal
        opened={liveOpen}
        onClose={() => setLiveOpen(false)}
        lang={lang}
        onPublished={fetchLives}
      />

      <ScrollArea className={classes.mainView} scrollbarSize={4}>
        <Box px={32} pt={24} pb={40}>
          <Box className={classes.headerRow}>
            <Box className={classes.headerLeft}>
              <Radio size={18} color="var(--accent)" />
              <Text className={classes.pageTitle}>
                {lang.radio_title ?? "Radio"}
              </Text>
              {lives.length > 0 && (
                <Box className={classes.countBadge}>
                  <Text className={classes.countText}>{lives.length}</Text>
                </Box>
              )}
            </Box>
            <Box className={classes.headerActions}>
              {canGoLive && (
                <Box
                  component="button"
                  onClick={() => setLiveOpen(true)}
                  className={classes.goLiveBtn}
                >
                  <Plus size={13} />
                  {lang.live_go_live ?? "Go Live"}
                </Box>
              )}
              <Tooltip label={lang.radio_refresh ?? "Refresh"} position="left">
                <ActionIcon
                  variant="subtle"
                  color="gray"
                  size="sm"
                  onClick={fetchLives}
                  style={{ color: "var(--text-secondary)" }}
                >
                  <RefreshCw
                    size={14}
                    style={{
                      animation: loading ? "spin 0.8s linear infinite" : "none",
                    }}
                  />
                </ActionIcon>
              </Tooltip>
            </Box>
          </Box>

          {lives.length === 0 ? (
            <Box className={classes.emptyState}>
              <Radio size={36} color="var(--text-secondary)" />
              <Text className={classes.emptyText}>
                {lang.radio_no_lives ?? "No live stations right now."}
              </Text>
            </Box>
          ) : (
            <Box className={classes.stationGrid}>
              {lives.map((station) => (
                <LiveCard
                  key={station.owner}
                  station={station}
                  onPlay={handlePlay}
                  tunedIn={tunedIn === station.owner}
                  lang={lang}
                />
              ))}
            </Box>
          )}
        </Box>
      </ScrollArea>
    </>
  );
};
