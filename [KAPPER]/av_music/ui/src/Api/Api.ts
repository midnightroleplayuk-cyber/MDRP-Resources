import { fetchNui, isEnvBrowser } from "../hooks/useNuiEvents";
import { Track, Playlist } from "../types/types";

const MOCK_TRACKS: Track[] = [
  {
    id: "dQw4w9WgXcQ",
    videoId: "dQw4w9WgXcQ",
    url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
    title: "Never Gonna Give You Up",
    artist: "Rick Astley",
    album: "Whenever You Need Somebody",
    durationSecs: 213,
    cover: "https://i.ytimg.com/vi/dQw4w9WgXcQ/maxresdefault.jpg",
  },
  {
    id: "9bZkp7q19f0",
    videoId: "9bZkp7q19f0",
    url: "https://www.youtube.com/watch?v=9bZkp7q19f0",
    title: "GANGNAM STYLE",
    artist: "PSY",
    album: "PSY 6甲",
    durationSecs: 252,
    cover: "https://i.ytimg.com/vi/9bZkp7q19f0/maxresdefault.jpg",
  },
  {
    id: "kJQP7kiw5Fk",
    videoId: "kJQP7kiw5Fk",
    url: "https://www.youtube.com/watch?v=kJQP7kiw5Fk",
    title: "Despacito",
    artist: "Luis Fonsi ft. Daddy Yankee",
    album: "Vida",
    durationSecs: 282,
    cover: "https://i.ytimg.com/vi/kJQP7kiw5Fk/maxresdefault.jpg",
  },
];

const MOCK_PLAYLISTS: Playlist[] = [
  {
    id: "mock-1",
    name: "Chill Vibes",
    cover: "",
    songs: [MOCK_TRACKS[0], MOCK_TRACKS[2]],
    createdAt: Date.now(),
  },
];

export async function searchSongs(query: string): Promise<Track[]> {
  if (isEnvBrowser()) {
    await new Promise((r) => setTimeout(r, 600));
    const q = query.toLowerCase();
    const filtered = MOCK_TRACKS.filter(
      (t) =>
        t.title.toLowerCase().includes(q) || t.artist.toLowerCase().includes(q),
    );
    return filtered.length > 0 ? filtered : MOCK_TRACKS;
  }
  const data = await fetchNui<{ results: any[]; error?: string }>(
    "av_music",
    "searchSongs",
    { query },
  );
  if (!data?.results) return [];
  return data.results.map(
    (r: any): Track => ({
      id: r.videoId,
      videoId: r.videoId,
      url: r.url,
      title: r.title,
      artist: r.artist,
      album: r.album || "Unknown",
      durationSecs: r.durationSecs ?? r.duration ?? 0,
      cover: r.thumbnail,
    }),
  );
}

export async function playSong(track: Track): Promise<void> {
  if (isEnvBrowser()) return;
  await fetchNui("av_music", "playSong", track);
}

export async function playPlaylist(
  tracks: Track[],
  startIndex = 1,
): Promise<void> {
  if (isEnvBrowser()) return;
  await fetchNui("av_music", "playPlaylist", { tracks, startIndex });
}

export async function playerControl(
  action: string,
  value?: number,
): Promise<void> {
  if (isEnvBrowser()) return;
  await fetchNui("av_music", "playerControl", { action, value });
}

export async function addToQueue(track: Track): Promise<void> {
  if (isEnvBrowser()) return;
  await fetchNui("av_music", "addToQueue", track);
}

export async function getDeviceQueue(
  device: string,
): Promise<{
  queue: Track[];
  queueIndex: number;
  loopMode?: string;
  shuffleMode?: boolean;
} | null> {
  if (isEnvBrowser()) return { queue: MOCK_TRACKS, queueIndex: 1 };
  const result = await fetchNui<{
    queue: Track[];
    queueIndex: number;
    loopMode?: string;
    shuffleMode?: boolean;
  }>("av_music", "getDeviceQueue", { device });
  return result ?? null;
}

export async function removeFromQueue(
  index: number,
): Promise<{ ok: boolean; queueLength?: number } | null> {
  if (isEnvBrowser()) return { ok: true };
  const result = await fetchNui<{ ok: boolean; queueLength?: number }>(
    "av_music",
    "removeFromQueue",
    { index },
  );
  return result ?? null;
}

export async function getPlaylists(): Promise<Playlist[]> {
  if (isEnvBrowser()) {
    await new Promise((r) => setTimeout(r, 200));
    return MOCK_PLAYLISTS;
  }
  const result = await fetchNui<Playlist[]>("av_music", "getPlaylists", {});
  return Array.isArray(result) ? result : [];
}

export async function createPlaylist(
  name: string,
  cover: string,
): Promise<Playlist[] | { error: string }> {
  if (isEnvBrowser()) {
    const newPl: Playlist = {
      id: "mock-" + Date.now(),
      name,
      cover,
      songs: [],
      createdAt: Date.now(),
    };
    MOCK_PLAYLISTS.push(newPl);
    return [...MOCK_PLAYLISTS];
  }
  const result = await fetchNui<Playlist[] | { error: string }>(
    "av_music",
    "createPlaylist",
    { name, cover },
  );
  return result ?? [];
}

export async function deletePlaylist(id: string): Promise<Playlist[]> {
  if (isEnvBrowser()) {
    const idx = MOCK_PLAYLISTS.findIndex((p) => p.id === id);
    if (idx !== -1) MOCK_PLAYLISTS.splice(idx, 1);
    return [...MOCK_PLAYLISTS];
  }
  const result = await fetchNui<Playlist[]>("av_music", "deletePlaylist", {
    id,
  });
  return Array.isArray(result) ? result : [];
}

export async function addToPlaylist(
  playlistId: string,
  track: Track,
): Promise<{ playlists?: Playlist[]; error?: string }> {
  if (isEnvBrowser()) {
    const pl = MOCK_PLAYLISTS.find((p) => p.id === playlistId);
    if (pl) {
      if (pl.songs.find((s) => s.videoId === track.videoId))
        return { error: "already_added" };
      pl.songs.push(track);
    }
    return { playlists: [...MOCK_PLAYLISTS] };
  }
  const result = await fetchNui<{ playlists?: Playlist[]; error?: string }>(
    "av_music",
    "addToPlaylist",
    { playlistId, track },
  );
  return result ?? {};
}

export async function removeFromPlaylist(
  playlistId: string,
  videoId: string,
): Promise<Playlist[]> {
  if (isEnvBrowser()) {
    const pl = MOCK_PLAYLISTS.find((p) => p.id === playlistId);
    if (pl) pl.songs = pl.songs.filter((s) => s.videoId !== videoId);
    return [...MOCK_PLAYLISTS];
  }
  const result = await fetchNui<Playlist[]>("av_music", "removeFromPlaylist", {
    playlistId,
    videoId,
  });
  return Array.isArray(result) ? result : [];
}

export interface RestoredPlayerState {
  track: Track;
  playing: boolean;
  currentTime: number;
  duration: number;
  progress: number;
}

export async function getPlayerState(): Promise<RestoredPlayerState | null> {
  if (isEnvBrowser()) return null;
  const result = await fetchNui<RestoredPlayerState | null>(
    "av_music",
    "getPlayerState",
    {},
  );
  if (!result || !result.track) return null;
  return result;
}

export type Device = {
  id: string;
  type: "laptop" | "headphones" | "vehicle" | "zone";
  label: string;
};
export type DevicesResponse = { devices: Device[]; activeDevice: string };

export async function requestDevices(): Promise<DevicesResponse> {
  if (isEnvBrowser()) return { devices: [], activeDevice: "laptop" };
  const res = await fetchNui<DevicesResponse>("av_music", "requestDevices", {});
  return res ?? { devices: [], activeDevice: "laptop" };
}

export async function setDevice(deviceId: string): Promise<void> {
  if (isEnvBrowser()) return;
  await fetchNui("av_music", "setDevice", { deviceId });
}

export interface LiveStation {
  owner: number;
  name: string;
  cover: string;
  url: string;
}

export async function getLives(): Promise<LiveStation[]> {
  if (isEnvBrowser())
    return [
      {
        owner: 1,
        name: "Lo-Fi Beats",
        cover: "https://i.ytimg.com/vi/jfKfPfyJRdk/maxresdefault.jpg",
        url: "https://www.youtube.com/watch?v=jfKfPfyJRdk",
      },
      {
        owner: 2,
        name: "Night Drive Radio",
        cover: "",
        url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
      },
    ];
  const result = await fetchNui<LiveStation[]>("av_music", "getLives", {});
  return result ?? [];
}

export async function playLive(station: LiveStation): Promise<void> {
  if (isEnvBrowser()) return;

  await fetchNui("av_music", "playSong", {
    id: `live_${station.owner}`,
    videoId: null,
    url: station.url,
    title: station.name,
    artist: "Live Radio",
    album: "",
    durationSecs: 0,
    trackType: "live",
    cover: station.cover,
  });
}

export async function toggleMiniPlayer(): Promise<{ visible: boolean } | null> {
  if (isEnvBrowser()) return { visible: true };
  const result = await fetchNui<{ visible: boolean }>(
    "av_music",
    "toggleMiniPlayer",
    {},
  );
  return result ?? null;
}

export interface MiniPlayerState {
  track: Track | null;
  playing: boolean;
  currentTime: number;
  duration: number;
  queue: Track[];
  queueIndex: number;
  loopMode?: string;
  shuffleMode?: boolean;
  device: string;
}

export async function getMiniPlayerState(): Promise<MiniPlayerState | null> {
  if (isEnvBrowser())
    return {
      track: MOCK_TRACKS[0],
      playing: false,
      currentTime: 30,
      duration: MOCK_TRACKS[0].durationSecs,
      queue: MOCK_TRACKS,
      queueIndex: 1,
      loopMode: "none",
      shuffleMode: false,
      device: "headphones",
    };
  const result = await fetchNui<MiniPlayerState>(
    "av_music",
    "getMiniPlayerState",
    {},
  );
  return result ?? null;
}
