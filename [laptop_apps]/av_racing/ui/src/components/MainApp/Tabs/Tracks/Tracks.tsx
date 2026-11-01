import {
  Flex,
  Group,
  Box,
  Text,
  TextInput,
  ActionIcon,
  Select,
  Checkbox,
  ScrollArea,
  Grid,
  Tooltip,
  Button,
} from "@mantine/core";
import { Map, X, CirclePlus, Search } from "lucide-react";
import { useEffect, useMemo, useState } from "react";
import { useRecoilState, useRecoilValue } from "recoil";
import { Categories, Lang, Profile } from "../../../../reducers/atoms";
import { Loading } from "../../../Loading";
import { fetchNui, isEnvBrowser } from "../../../../hooks/useNuiEvents";
import { TrackType } from "../../../../types/types";
import { ApiTracks } from "../../../../Api/Tracks";
import { Element } from "./Element";
import { ApiTrack } from "../../../../Api/Track";
import { Details } from "./Details";
import { CreateEvent } from "./CreateEvent";
import { isWide } from "../../../../hooks/isWide";
import { GetTrackType } from "../../../../hooks/getTrackType";
import { formatString } from "../../../../hooks/formatString";
import classes from "./style.module.css";
import global from "../../../../global.module.css";

const Tracks = () => {
  const lang: any = useRecoilValue(Lang);
  const categories = useRecoilValue(Categories);
  const [profile, setProfile] = useRecoilState(Profile);
  const [loaded, setLoaded] = useState(false);
  const [search, setSearch] = useState("");
  const [category, setCategory] = useState("");
  const [tracks, setTracks] = useState<TrackType[]>([]);
  const [byRanked, setByRanked] = useState(false);
  const [visibleItems, setVisibleItems] = useState(20);
  const [updated, setUpdated] = useState(false);
  const [minCheckpoints, setMinCheckpoints] = useState(50);
  const [details, setDetails] = useState<any>({
    show: false,
  });
  const [track, setTrack] = useState<null | string>(null);
  const [permissions, setPermissions] = useState({
    createTracks: isEnvBrowser(),
    createEvents: isEnvBrowser(),
  });
  const wide = isWide();

  const filterByFavorite = (tracks: TrackType[]) => {
    const favoritesList = profile?.favorites ?? [];
    const favoriteTracks = tracks.filter(
      (track) => track?.identifier && favoritesList.includes(track.identifier),
    );
    const otherTracks = tracks.filter(
      (track) =>
        !track?.identifier || !favoritesList.includes(track.identifier),
    );
    favoriteTracks.sort((a, b) => a.name.localeCompare(b.name));
    otherTracks.sort((a, b) => a.name.localeCompare(b.name));
    return [...favoriteTracks, ...otherTracks];
  };

  const filtered = useMemo(() => {
    return tracks.filter((track) => {
      const matchesSearch =
        !search || track.name.toLowerCase().includes(search.toLowerCase());
      const matchesCategory = !category || track.type === category;
      const isRanked = !byRanked || track.isRanked === byRanked;
      return matchesSearch && matchesCategory && isRanked;
    });
  }, [tracks, search, category, byRanked]);

  const handleFavorite = (identifier: string) => {
    if (!identifier) return;
    const favoritesList = profile?.favorites ?? [];
    const newFavorites = favoritesList.includes(identifier)
      ? favoritesList.filter((id) => id !== identifier)
      : [...favoritesList, identifier];
    setUpdated(true);
    setProfile({ ...profile, favorites: newFavorites });
  };

  const handleClose = () => {
    setDetails({ ...details, state: false, track: null });
  };

  const handleDetails = async (identifier: string, edit?: boolean) => {
    const resp = await fetchNui("av_racing", "getTrack", identifier);
    if (resp) {
      setDetails({ ...details, state: true, track: resp, edit });
    } else {
      if (isEnvBrowser()) {
        setDetails({ ...details, state: true, track: ApiTrack, edit });
      }
    }
  };

  const isFavorite = (identifier: string): boolean => {
    if (!identifier || !profile?.favorites) return false;
    return profile.favorites.includes(identifier);
  };

  const fetchData = async () => {
    const resp = await fetchNui("av_racing", "getTracks");
    if (resp) {
      const rawTracks = resp.tracks ?? [];
      const tracksToRender = rawTracks.filter(
        (track: any) => track && GetTrackType(track.type, categories),
      );
      const sorted = filterByFavorite(tracksToRender);
      setTracks(sorted ?? []);
      setMinCheckpoints(resp.minRanked ?? 50);
      setPermissions({
        createEvents: !!resp.createEvents,
        createTracks: !!resp.createTracks,
      });
    } else {
      if (isEnvBrowser()) {
        setTracks(ApiTracks);
      }
    }
    setTimeout(() => {
      setLoaded(true);
    }, 100);
  };

  useEffect(() => {
    if (!loaded) fetchData();
    return () => {
      if (updated && profile?.favorites) {
        fetchNui("av_racing", "updateFavorites", profile.favorites);
      }
    };
  }, [updated]);

  useEffect(() => {
    setVisibleItems(20);
  }, [search, category, byRanked]);

  if (!loaded) return <Loading />;

  return (
    <>
      {details.state && (
        <Details handleClose={handleClose} track={details.track} />
      )}
      {track && <CreateEvent track={track} setTrack={setTrack} lang={lang} />}
      <Flex
        direction="column"
        gap="sm"
        style={{ flex: 1, width: "100%", overflow: "hidden" }}
      >
        <Box className={classes.header}>
          <Group className={classes.titleBlock}>
            <Box className={classes.iconBox}>
              <Map size={20} />
            </Box>
            <Text className={classes.title}>
              {`${filtered.length} ${lang.tracks_header}`}
            </Text>
          </Group>
          <Group gap="sm">
            <Tooltip
              label={`${formatString(lang.ranked_requeriment, String(minCheckpoints))}`}
              multiline
              w={200}
              fz="xs"
              color="var(--tooltip)"
              withArrow
            >
              <Checkbox
                label={lang.ranked_check}
                color="var(--accent)"
                size="xs"
                styles={{
                  label: {
                    color: "var(--text-dim)",
                    fontWeight: 500,
                    fontFamily: "var(--font-main)",
                  },
                  input: {
                    backgroundColor: "var(--bg-main)",
                    borderColor: "var(--border-color)",
                    cursor: "pointer",
                  },
                }}
                onChange={(e) => {
                  setByRanked(e.currentTarget.checked);
                }}
              />
            </Tooltip>
            <TextInput
              classNames={global}
              size="xs"
              placeholder={lang.search ?? "Search tracks..."}
              leftSection={<Search size={14} />}
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              rightSection={
                search.length > 0 && (
                  <ActionIcon
                    size="xs"
                    radius={50}
                    color="var(--text-dim)"
                    variant="transparent"
                    onClick={() => setSearch("")}
                  >
                    <X size={14} />
                  </ActionIcon>
                )
              }
              styles={{
                input: {
                  backgroundColor: "var(--bg-main)",
                  border: "1px solid var(--border-color)",
                  color: "var(--text-main)",
                },
              }}
            />
            <Select
              classNames={global}
              size="xs"
              placeholder={lang.filter_category ?? "Filter by category"}
              data={categories}
              value={category}
              onChange={(val) => setCategory(val || "")}
              styles={{
                input: {
                  backgroundColor: "var(--bg-main)",
                  border: "1px solid var(--border-color)",
                  color: "var(--text-dim)",
                },
                dropdown: {
                  backgroundColor: "var(--bg-panel)",
                  border: "1px solid var(--border-color)",
                },
                option: {
                  color: "var(--text-main)",
                },
              }}
            />
            {permissions.createTracks && (
              <>
                {wide ? (
                  <Button
                    className={classes.primaryButton}
                    variant="unestyled"
                    size="xs"
                    onClick={() => fetchNui("av_racing", "newCircuit")}
                  >
                    {lang.create_track ?? "CREATE TRACK"}
                  </Button>
                ) : (
                  <Tooltip
                    label={lang.create_track}
                    color="var(--tooltip)"
                    fz="xs"
                    withArrow
                  >
                    <button
                      className={classes.actionBtn}
                      style={{ color: "var(--accent)" }}
                      onClick={() => fetchNui("av_racing", "newCircuit")}
                    >
                      <CirclePlus size={20} />
                    </button>
                  </Tooltip>
                )}
              </>
            )}
          </Group>
        </Box>

        <Box style={{ flex: 1, overflow: "hidden" }}>
          <ScrollArea
            h="100%"
            type="hover"
            scrollbars="y"
            scrollbarSize={4}
            offsetScrollbars
            onTopReached={() => setVisibleItems(20)}
            onBottomReached={() => setVisibleItems((prev) => prev + 20)}
          >
            <Box pb="xl">
              <Grid key={`${search}-${category}-${byRanked}`} gutter="sm">
                {filtered.slice(0, visibleItems).map((track) => (
                  <Grid.Col span={4} key={track.identifier} miw={310}>
                    <Element
                      lang={lang}
                      track={track}
                      handleFavorite={handleFavorite}
                      isFav={isFavorite(track.identifier)}
                      createEvents={permissions.createEvents}
                      editTracks={permissions.createTracks}
                      handleDetails={handleDetails}
                      handleEvent={setTrack}
                    />
                  </Grid.Col>
                ))}
              </Grid>
            </Box>
          </ScrollArea>
        </Box>
      </Flex>
    </>
  );
};

export default Tracks;
