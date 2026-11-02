import { useState, useRef, useCallback } from "react";
import {
  Box,
  Text,
  Image,
  Group,
  ScrollArea,
  TextInput,
  ActionIcon,
  Loader,
  Menu,
  Tooltip,
  Divider,
} from "@mantine/core";
import {
  Search,
  Clock3,
  X,
  Plus,
  Check,
  ListMusic,
  ListPlus,
} from "lucide-react";
import { useAtom, useAtomValue } from "jotai";
import { playerAtom, playlistsAtom, Lang } from "../../../reducers/atoms";
import {
  searchSongs,
  playSong,
  addToPlaylist,
  addToQueue,
} from "../../../Api/Api";
import { Track } from "../../../types/types";
import classes from "../style.module.css";

const fmtDuration = (secs: number) => {
  if (!secs) return "0:00";
  const m = Math.floor(secs / 60);
  const s = secs % 60;
  return `${m}:${s.toString().padStart(2, "0")}`;
};

export const MainView = () => {
  const [player, setPlayer] = useAtom(playerAtom);
  const lang: any = useAtomValue(Lang);
  const [playlists, setPlaylists] = useAtom(playlistsAtom);
  const [query, setQuery] = useState("");
  const [results, setResults] = useState<Track[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const [feedback, setFeedback] = useState<Record<string, string>>({});
  const [queueFeedback, setQueueFeedback] = useState<Record<string, boolean>>(
    {},
  );
  const inputRef = useRef<HTMLInputElement>(null);
  const clickTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  // Single-click plays; double-click cancels the action
  const handleRowClick = useCallback((track: Track) => {
    if (clickTimerRef.current) {
      clearTimeout(clickTimerRef.current);
      clickTimerRef.current = null;
      return;
    }
    clickTimerRef.current = setTimeout(() => {
      clickTimerRef.current = null;
      handlePlay(track);
    }, 250);
  }, []);

  const handleSearch = async () => {
    const q = query.trim();
    if (!q) return;
    setLoading(true);
    setSearched(true);
    try {
      setResults(await searchSongs(q));
    } finally {
      setLoading(false);
    }
  };

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === "Enter") handleSearch();
  };
  const handleClear = () => {
    setQuery("");
    setResults([]);
    setSearched(false);
    inputRef.current?.focus();
  };

  const handlePlay = async (track: Track) => {
    setPlayer((p) => ({
      ...p,
      track,
      playing: false,
      currentTime: 0,
      progress: 0,
    }));
    await playSong(track);
  };

  const handleAddToPlaylist = async (playlistId: string, track: Track) => {
    const key = `${playlistId}:${track.videoId}`;
    const result = await addToPlaylist(playlistId, track);
    if (result?.error) {
      setFeedback((f) => ({ ...f, [key]: "dup" }));
    } else {
      setFeedback((f) => ({ ...f, [key]: "ok" }));
      setPlaylists((pls) =>
        pls.map((pl) =>
          pl.id === playlistId ? { ...pl, songs: [...pl.songs, track] } : pl,
        ),
      );
    }
    setTimeout(
      () =>
        setFeedback((f) => {
          const c = { ...f };
          delete c[key];
          return c;
        }),
      2000,
    );
  };

  const handleAddToQueue = async (e: React.MouseEvent, track: Track) => {
    e.stopPropagation();
    const key = track.videoId;
    await addToQueue(track);
    setQueueFeedback((f) => ({ ...f, [key]: true }));
    setTimeout(
      () =>
        setQueueFeedback((f) => {
          const c = { ...f };
          delete c[key];
          return c;
        }),
      1500,
    );
  };

  return (
    <Box className={classes.mainView}>
      <Box className={classes.searchBar}>
        <TextInput
          ref={inputRef}
          value={query}
          onChange={(e) => setQuery(e.currentTarget.value)}
          onKeyDown={handleKeyDown}
          placeholder={
            lang.search_placeholder ?? "Search songs, artists...  (press Enter)"
          }
          classNames={{
            input: classes.searchInputField,
            wrapper: classes.searchInputWrapper,
          }}
          leftSection={
            loading ? (
              <Loader size={14} color="gray" />
            ) : (
              <Search size={15} color="var(--text-secondary)" />
            )
          }
          rightSection={
            query ? (
              <ActionIcon variant="transparent" size="sm" onClick={handleClear}>
                <X size={13} color="var(--text-secondary)" />
              </ActionIcon>
            ) : null
          }
          style={{ width: "100%" }}
        />
      </Box>
      {!searched ? (
        <Box className={classes.searchHero}>
          <Text
            style={{
              fontSize: 32,
              fontWeight: 800,
              color: "#fff",
              letterSpacing: -1,
            }}
          >
            {lang.app_title ?? "AV AUDIO"}
          </Text>
          <Text
            style={{
              color: "var(--text-secondary)",
              fontSize: 13,
              marginTop: 6,
            }}
          >
            {lang.search_hero_sub ?? "Search for a song to start listening"}
          </Text>
        </Box>
      ) : loading ? (
        <Box
          style={{ display: "flex", justifyContent: "center", paddingTop: 60 }}
        >
          <Loader size="sm" color="gray" />
        </Box>
      ) : results.length === 0 ? (
        <Box className={classes.searchEmpty}>
          <Text style={{ color: "var(--text-secondary)", fontSize: 13 }}>
            {lang.search_no_results ?? "No results found"}
          </Text>
        </Box>
      ) : (
        <ScrollArea style={{ flex: 1 }} scrollbarSize={4}>
          <Group
            className={classes.trackListHeader}
            px={16}
            mb={8}
            wrap="nowrap"
            gap="md"
          >
            <Text w={28} ta="center" fz="xs" fw={600} tt="uppercase" c="dimmed">
              #
            </Text>
            <Box style={{ flex: 1, minWidth: 0, paddingLeft: 46 }}>
              <Text fz="xs" fw={600} tt="uppercase" c="dimmed">
                Title
              </Text>
            </Box>
            <Text w={160} fz="xs" fw={600} tt="uppercase" c="dimmed">
              Album
            </Text>
            <Box w={45} style={{ display: "flex", justifyContent: "flex-end" }}>
              <Clock3 size={14} color="gray" />
            </Box>
            <Box w={60} />
          </Group>
          <Divider className={classes.trackListDivider} mb={4} />
          {results.map((track, i) => {
            const isActive = player.track?.videoId === track.videoId;
            const qDone = queueFeedback[track.videoId];
            return (
              <Group
                key={track.videoId || i}
                className={`${classes.trackRow} ${isActive ? classes.trackRowActive : ""}`}
                px={16}
                wrap="nowrap"
                gap="md"
                onClick={() => handleRowClick(track)}
              >
                <Text
                  className={classes.trackIndex}
                  w={28}
                  ta="center"
                  style={{ color: isActive ? "#c77dff" : undefined }}
                >
                  {isActive ? <span className={classes.playingDot} /> : i + 1}
                </Text>

                <Group gap={10} style={{ flex: 1, minWidth: 0 }} wrap="nowrap">
                  <Image
                    src={track.cover}
                    w={36}
                    h={36}
                    radius={4}
                    style={{ objectFit: "cover", flexShrink: 0 }}
                  />
                  <Box style={{ minWidth: 0 }}>
                    <Text
                      className={`${classes.trackName} ${isActive ? classes.trackNameActive : ""}`}
                      fz="sm"
                      fw={500}
                      style={{
                        overflow: "hidden",
                        textOverflow: "ellipsis",
                        whiteSpace: "nowrap",
                      }}
                    >
                      {track.title}
                    </Text>
                    <Text
                      className={classes.trackArtistSmall}
                      fz="xs"
                      c="dimmed"
                      mt={2}
                    >
                      {track.artist}
                    </Text>
                  </Box>
                </Group>

                <Text
                  className={classes.trackAlbum}
                  w={160}
                  fz="sm"
                  c="dimmed"
                  style={{
                    overflow: "hidden",
                    textOverflow: "ellipsis",
                    whiteSpace: "nowrap",
                  }}
                >
                  {track.album ?? ""}
                </Text>

                <Text
                  className={classes.trackDuration}
                  w={45}
                  fz="sm"
                  c="dimmed"
                  ta="right"
                >
                  {fmtDuration(track.durationSecs)}
                </Text>

                <Box
                  w={60}
                  style={{
                    display: "flex",
                    justifyContent: "flex-end",
                    gap: 6,
                  }}
                  onClick={(e) => e.stopPropagation()}
                >
                  <Tooltip
                    label={lang.add_to_queue ?? "Add to queue"}
                    position="left"
                    withArrow
                  >
                    <ActionIcon
                      className={classes.addToPlaylistBtn}
                      variant="transparent"
                      size="sm"
                      onClick={(e) => handleAddToQueue(e, track)}
                      style={{
                        color: qDone
                          ? "var(--success)"
                          : "var(--text-secondary)",
                      }}
                    >
                      {qDone ? (
                        <Check size={14} color="var(--success)" />
                      ) : (
                        <ListPlus size={14} />
                      )}
                    </ActionIcon>
                  </Tooltip>
                  <Menu
                    shadow="md"
                    width={180}
                    position="left-start"
                    withinPortal
                  >
                    <Menu.Target>
                      <Tooltip
                        label={lang.add_to_playlist ?? "Add to playlist"}
                        position="left"
                        withArrow
                      >
                        <ActionIcon
                          className={classes.addToPlaylistBtn}
                          variant="transparent"
                          size="sm"
                        >
                          <Plus size={14} color="var(--text-secondary)" />
                        </ActionIcon>
                      </Tooltip>
                    </Menu.Target>
                    <Menu.Dropdown>
                      <Menu.Label
                        style={{ fontSize: 10, color: "var(--text-secondary)" }}
                      >
                        {lang.add_to_playlist_menu ?? "ADD TO PLAYLIST"}
                      </Menu.Label>
                      {playlists.length === 0 ? (
                        <Menu.Item
                          disabled
                          leftSection={<ListMusic size={14} />}
                          style={{
                            color: "var(--text-secondary)",
                            fontSize: 12,
                          }}
                        >
                          {lang.no_playlists_in_menu ?? "No playlists yet"}
                        </Menu.Item>
                      ) : (
                        playlists.map((pl) => {
                          const key = `${pl.id}:${track.videoId}`;
                          const fb = feedback[key];
                          return (
                            <Menu.Item
                              key={pl.id}
                              onClick={() => handleAddToPlaylist(pl.id, track)}
                              leftSection={
                                fb === "ok" ? (
                                  <Check size={14} color="var(--success)" />
                                ) : fb === "dup" ? (
                                  <Check size={14} color="var(--warning)" />
                                ) : (
                                  <ListMusic size={14} />
                                )
                              }
                              style={{
                                fontSize: 12,
                                color: "var(--text-muted)",
                              }}
                            >
                              {pl.name}
                            </Menu.Item>
                          );
                        })
                      )}
                    </Menu.Dropdown>
                  </Menu>
                </Box>
              </Group>
            );
          })}
        </ScrollArea>
      )}
    </Box>
  );
};
