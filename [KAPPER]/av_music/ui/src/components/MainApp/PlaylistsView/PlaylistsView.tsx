import { useState, useRef, useCallback } from "react";
import {
  Box,
  Text,
  Group,
  Image,
  ScrollArea,
  ActionIcon,
  Modal,
  TextInput,
  Button,
  Stack,
  UnstyledButton,
  Tooltip,
} from "@mantine/core";
import {
  ListMusic,
  Plus,
  Trash2,
  Play,
  ArrowLeft,
  Clock3,
  Music2,
} from "lucide-react";
import { useAtom, useAtomValue } from "jotai";
import { playlistsAtom, playerAtom, Lang } from "../../../reducers/atoms";
import {
  createPlaylist,
  deletePlaylist,
  removeFromPlaylist,
  playSong,
  playPlaylist,
} from "../../../Api/Api";
import { Playlist, Track } from "../../../types/types";
import classes from "../style.module.css";

const fmtDuration = (secs: number) => {
  if (!secs) return "0:00";
  return `${Math.floor(secs / 60)}:${(secs % 60).toString().padStart(2, "0")}`;
};

const CoverPlaceholder = ({
  name,
  size = 56,
}: {
  name: string;
  size?: number;
}) => (
  <Box
    className={classes.playlistCoverPlaceholder}
    style={{ width: size, height: size, fontSize: size * 0.4 }}
  >
    {name?.[0]?.toUpperCase() ?? "P"}
  </Box>
);

interface CreateModalProps {
  opened: boolean;
  onClose: () => void;
  onCreate: (name: string, cover: string) => Promise<void>;
}

const CreateModal = ({ opened, onClose, onCreate }: CreateModalProps) => {
  const lang: any = useAtomValue(Lang);
  const [name, setName] = useState("");
  const [cover, setCover] = useState("");
  const [busy, setBusy] = useState(false);

  const handleCreate = async () => {
    if (!name.trim()) return;
    setBusy(true);
    await onCreate(name.trim(), cover.trim());
    setName("");
    setCover("");
    setBusy(false);
    onClose();
  };

  return (
    <Modal
      opened={opened}
      onClose={onClose}
      title={lang.playlist_modal_title ?? "New Playlist"}
      centered
      size={320}
      styles={{
        content: {
          background: "var(--bg-card)",
          border: "1px solid rgba(255,255,255,0.07)",
        },
        header: { background: "var(--bg-card)", color: "#fff" },
        title: { color: "#fff", fontWeight: 600, fontSize: 14 },
        close: { color: "var(--text-secondary)" },
      }}
    >
      <Stack gap="sm">
        <Box
          style={{
            display: "flex",
            justifyContent: "center",
            paddingBottom: 4,
          }}
        >
          {cover ? (
            <Image
              src={cover}
              w={80}
              h={80}
              radius={10}
              style={{ objectFit: "cover" }}
              onError={() => {}}
            />
          ) : (
            <CoverPlaceholder name={name || "P"} size={80} />
          )}
        </Box>

        <TextInput
          label={lang.playlist_name_label ?? "Name"}
          placeholder={lang.playlist_name_placeholder ?? "My Playlist"}
          value={name}
          onChange={(e) => setName(e.currentTarget.value)}
          onKeyDown={(e) => e.key === "Enter" && handleCreate()}
          size="xs"
          styles={{
            label: {
              color: "var(--text-secondary)",
              fontSize: 11,
              marginBottom: 4,
            },
            input: {
              background: "var(--bg-hover)",
              border: "1px solid rgba(255,255,255,0.08)",
              color: "#fff",
            },
          }}
          withAsterisk
        />

        <TextInput
          label={lang.playlist_cover_label ?? "Cover Image URL"}
          placeholder="https://…"
          value={cover}
          onChange={(e) => setCover(e.currentTarget.value)}
          size="xs"
          styles={{
            label: {
              color: "var(--text-secondary)",
              fontSize: 11,
              marginBottom: 4,
            },
            input: {
              background: "var(--bg-hover)",
              border: "1px solid rgba(255,255,255,0.08)",
              color: "#fff",
            },
          }}
        />

        <Button
          fullWidth
          size="xs"
          mt={4}
          disabled={!name.trim() || busy}
          loading={busy}
          onClick={handleCreate}
          styles={{
            root: { background: "var(--accent)", border: "none" },
          }}
        >
          {lang.playlist_create_btn ?? "Create Playlist"}
        </Button>
      </Stack>
    </Modal>
  );
};

export const PlaylistsView = () => {
  const lang: any = useAtomValue(Lang);
  const [playlists, setPlaylists] = useAtom(playlistsAtom);
  const [player, setPlayer] = useAtom(playerAtom);
  const [selected, setSelected] = useState<Playlist | null>(null);
  const [modalOpen, setModalOpen] = useState(false);
  const clickTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  const syncSelected = (updated: Playlist[]) => {
    if (selected) {
      const found = updated.find((p) => p.id === selected.id);
      setSelected(found ?? null);
    }
    setPlaylists(updated);
  };

  const handleCreate = async (name: string, cover: string) => {
    const result = await createPlaylist(name, cover);
    if (Array.isArray(result)) setPlaylists(result);
  };

  const handleDelete = async (id: string) => {
    if (selected?.id === id) setSelected(null);
    const updated = await deletePlaylist(id);
    setPlaylists(updated);
  };

  const handleRemoveSong = async (videoId: string) => {
    if (!selected) return;
    const updated = await removeFromPlaylist(selected.id, videoId);
    syncSelected(updated);
  };

  const handleRowClick = useCallback((track: Track, idx?: number) => {
    if (clickTimerRef.current) {
      clearTimeout(clickTimerRef.current);
      clickTimerRef.current = null;
      return;
    }
    clickTimerRef.current = setTimeout(() => {
      clickTimerRef.current = null;
      handlePlayTrack(track, idx);
    }, 250);
  }, []);

  const handlePlayTrack = async (track: Track, idx?: number) => {
    setPlayer((p) => ({
      ...p,
      track,
      playing: false,
      progress: 0,
      currentTime: 0,
      durationSecs: 0,
    }));
    if (selected && idx !== undefined) {
      await playPlaylist(selected.songs, idx + 1);
    } else {
      await playSong(track);
    }
  };

  const handlePlayAll = async (startIndex = 1) => {
    if (!selected || selected.songs.length === 0) return;

    const first = selected.songs[startIndex - 1];
    setPlayer((p) => ({
      ...p,
      track: first,
      playing: false,
      progress: 0,
      currentTime: 0,
      durationSecs: 0,
    }));
    await playPlaylist(selected.songs, startIndex);
  };

  if (selected) {
    return (
      <ScrollArea className={classes.mainView} scrollbarSize={4}>
        <Box px={32} pt={24} pb={40}>
          <Group mb={24} gap={12}>
            <ActionIcon
              variant="transparent"
              onClick={() => setSelected(null)}
              style={{ color: "var(--text-secondary)" }}
            >
              <ArrowLeft size={18} />
            </ActionIcon>
            {selected.cover ? (
              <Image
                src={selected.cover}
                w={64}
                h={64}
                radius={10}
                style={{ objectFit: "cover", flexShrink: 0 }}
              />
            ) : (
              <CoverPlaceholder name={selected.name} size={64} />
            )}
            <Box style={{ minWidth: 0, overflow: "hidden" }}>
              <Text
                style={{
                  fontSize: 20,
                  fontWeight: 700,
                  color: "#fff",
                  lineHeight: 1.2,
                }}
              >
                {selected.name}
              </Text>
              <Text
                style={{
                  fontSize: 12,
                  color: "var(--text-secondary)",
                  marginTop: 2,
                }}
              >
                {selected.songs.length} song
                {selected.songs.length !== 1
                  ? (lang.playlist_song_plural_suffix ?? "s")
                  : ""}
              </Text>
            </Box>
            {selected.songs.length > 0 && (
              <ActionIcon
                size={44}
                radius="xl"
                onClick={() => handlePlayAll(1)}
                style={{
                  background: "var(--accent)",
                  color: "#fff",
                  marginLeft: "auto",
                }}
              >
                <Play size={18} fill="currentColor" />
              </ActionIcon>
            )}
          </Group>

          {selected.songs.length === 0 ? (
            <Box
              className={classes.searchEmpty}
              style={{ flexDirection: "column", gap: 8 }}
            >
              <Music2 size={32} color="var(--text-secondary)" />
              <Text style={{ color: "var(--text-secondary)", fontSize: 13 }}>
                No songs yet — add some from Browse
              </Text>
            </Box>
          ) : (
            <Box className={classes.trackList}>
              <Group
                className={classes.trackListHeader}
                px={16}
                mb={8}
                wrap="nowrap"
                gap="md"
              >
                <Text
                  w={28}
                  ta="center"
                  fz="xs"
                  fw={600}
                  tt="uppercase"
                  c="dimmed"
                >
                  #
                </Text>
                <Text
                  style={{ flex: 1 }}
                  fz="xs"
                  fw={600}
                  tt="uppercase"
                  c="dimmed"
                >
                  Title
                </Text>
                <Text w={120} fz="xs" fw={600} tt="uppercase" c="dimmed">
                  Album
                </Text>
                <Box
                  w={45}
                  style={{ display: "flex", justifyContent: "flex-end" }}
                >
                  <Clock3 size={14} color="gray" />
                </Box>

                <Box w={28} />
              </Group>
              <Box className={classes.trackListDivider} />
              {selected.songs.map((track, idx) => {
                const isActive = player.track?.id === track.id;
                const isPlaying = isActive && player.playing;
                return (
                  <Group
                    key={track.videoId}
                    className={`${classes.trackRow} ${isActive ? classes.trackRowActive : ""}`}
                    px={16}
                    wrap="nowrap"
                    onClick={() => handleRowClick(track, idx)}
                  >
                    <Text className={classes.trackIndex} w={28}>
                      {isPlaying ? (
                        <span className={classes.playingDot} />
                      ) : (
                        idx + 1
                      )}
                    </Text>
                    <Group gap={12} style={{ flex: 1, minWidth: 0 }}>
                      <Image
                        src={track.cover}
                        w={36}
                        h={36}
                        radius={4}
                        style={{ objectFit: "cover", flexShrink: 0 }}
                      />
                      <Box style={{ minWidth: 0, overflow: "hidden" }}>
                        <Text
                          className={`${classes.trackName} ${isActive ? classes.trackNameActive : ""}`}
                          style={{
                            overflow: "hidden",
                            textOverflow: "ellipsis",
                            whiteSpace: "nowrap",
                          }}
                        >
                          {track.title}
                        </Text>
                        <Text className={classes.trackArtistSmall}>
                          {track.artist}
                        </Text>
                      </Box>
                    </Group>
                    <Text
                      className={classes.trackAlbum}
                      w={120}
                      style={{
                        overflow: "hidden",
                        textOverflow: "ellipsis",
                        whiteSpace: "nowrap",
                      }}
                    >
                      {track.album}
                    </Text>
                    <Text className={classes.trackDuration}>
                      {fmtDuration(track.durationSecs)}
                    </Text>
                    <Box
                      w={28}
                      style={{ display: "flex", justifyContent: "center" }}
                      onClick={(e) => e.stopPropagation()}
                    >
                      <Tooltip label="Remove" withArrow>
                        <ActionIcon
                          size="sm"
                          variant="transparent"
                          className={classes.addToPlaylistBtn}
                          onClick={() => handleRemoveSong(track.videoId)}
                          style={{ color: "var(--accent)" }}
                        >
                          <Trash2 size={13} />
                        </ActionIcon>
                      </Tooltip>
                    </Box>
                  </Group>
                );
              })}
            </Box>
          )}
        </Box>
      </ScrollArea>
    );
  }

  return (
    <>
      <CreateModal
        opened={modalOpen}
        onClose={() => setModalOpen(false)}
        onCreate={handleCreate}
      />

      <ScrollArea className={classes.mainView} scrollbarSize={4}>
        <Box px={32} pt={24} pb={40}>
          <Group justify="space-between" align="center" mb={20}>
            <Box className={classes.headerLeft}>
              <ListMusic size={18} color="var(--accent)" />
              <Text className={classes.pageTitle}>
                {lang.sidebar_playlists ?? "Playlists"}
              </Text>
            </Box>
            <ActionIcon
              size="md"
              className={classes.searchBtn}
              onClick={() => setModalOpen(true)}
            >
              <Plus size={16} />
            </ActionIcon>
          </Group>

          {playlists.length === 0 ? (
            <Box
              className={classes.searchEmpty}
              style={{ flexDirection: "column", gap: 12, minHeight: 220 }}
            >
              <Music2 size={36} color="var(--text-secondary)" />
              <Text style={{ color: "var(--text-secondary)", fontSize: 13 }}>
                No playlists yet
              </Text>
              <Button
                size="xs"
                onClick={() => setModalOpen(true)}
                styles={{
                  root: { background: "var(--accent)", border: "none" },
                }}
                leftSection={<Plus size={13} />}
              >
                Create your first playlist
              </Button>
            </Box>
          ) : (
            <Box className={classes.playlistGrid}>
              {playlists.map((pl) => (
                <UnstyledButton
                  key={pl.id}
                  className={classes.playlistCard}
                  onClick={() => setSelected(pl)}
                >
                  <Box className={classes.playlistCardCover}>
                    {pl.cover ? (
                      <Image
                        src={pl.cover}
                        w="100%"
                        h="100%"
                        style={{ objectFit: "cover" }}
                      />
                    ) : (
                      <CoverPlaceholder name={pl.name} size={56} />
                    )}
                    <Box className={classes.playlistCardHover}>
                      <Play size={22} fill="#fff" color="#fff" />
                    </Box>
                  </Box>
                  <Box className={classes.playlistCardInfo}>
                    <Text className={classes.playlistCardName}>{pl.name}</Text>
                    <Text className={classes.playlistCardCount}>
                      {pl.songs.length} song
                      {pl.songs.length !== 1
                        ? (lang.playlist_song_plural_suffix ?? "s")
                        : ""}
                    </Text>
                  </Box>
                  <ActionIcon
                    size="xs"
                    variant="transparent"
                    className={classes.playlistDeleteBtn}
                    onClick={(e) => {
                      e.stopPropagation();
                      handleDelete(pl.id);
                    }}
                    style={{ color: "var(--accent)" }}
                  >
                    <Trash2 size={12} />
                  </ActionIcon>
                </UnstyledButton>
              ))}
            </Box>
          )}
        </Box>
      </ScrollArea>
    </>
  );
};
