const YTMusicModule = require("ytmusic-api");
const YTMusic = YTMusicModule.default ?? YTMusicModule;

const client = new YTMusic();
let initialized = false;

const _ID_PATTERN = /^[a-zA-Z0-9-_]{11}$/;
const _HTTP_PATTERN = /^https?:\/\//;
const _PATH_PATTERN =
  /^https?:\/\/(youtu\.be\/|(www\.)?youtube\.com\/(embed|v|shorts|live)\/)/;

async function ensureReady() {
  if (initialized) return;
  await client.initialize({ GL: "US", HL: "en" });
  initialized = true;
}

ensureReady().catch((err) => {
  console.log("[av_music] Init error:", err.message);
});

function extractVideoId(input) {
  if (input === null || input === undefined) return null;
  if (typeof input !== "string") input = String(input);

  const trimmed = input.trim();
  if (_ID_PATTERN.test(trimmed)) return trimmed;
  if (!_HTTP_PATTERN.test(trimmed)) return null;

  let parsed;
  try {
    parsed = new URL(trimmed);
  } catch {
    return null;
  }

  let id = parsed.searchParams.get("v");

  if (!id && _PATH_PATTERN.test(trimmed)) {
    const segments = parsed.pathname.split("/");
    id = parsed.host === "youtu.be" ? segments[1] : segments[2];
  }

  if (!id || !_ID_PATTERN.test(id.substring(0, 11))) return null;
  return id.substring(0, 11);
}

function bestThumbnail(thumbnails, videoId) {
  if (!thumbnails || thumbnails.length === 0) {
    return `https://i.ytimg.com/vi/${videoId}/maxresdefault.jpg`;
  }
  const sorted = [...thumbnails].sort(
    (a, b) => (b.width ?? 0) - (a.width ?? 0),
  );
  return sorted[0].url;
}

function normalizeSong(item) {
  const videoId = item.videoId ?? null;
  return {
    videoId,
    url: videoId ? `https://www.youtube.com/watch?v=${videoId}` : null,
    title: item.name ?? "Unknown",
    artist: item.artist?.name ?? item.artists?.[0]?.name ?? "Unknown",
    album: item.album?.name ?? "Unknown",
    duration: item.duration ?? 0,
    thumbnail: bestThumbnail(item.thumbnails, videoId),
  };
}

exports("fetchVideoInfo", async (url) => {
  try {
    await ensureReady();
    const id = extractVideoId(url);
    if (!id) return { error: "Invalid YouTube URL", code: 400 };
    let item = await client.getSong(id).catch(() => null);
    if (!item) {
      item = await client.getVideo(id).catch(() => null);
    }
    if (!item) return { error: "Video not found", code: 404 };
    const result = normalizeSong({ ...item, videoId: id });
    return result;
  } catch (err) {
    console.log("[av_music] fetchVideoInfo ERROR:", err.message);
    return { error: err.message, code: 500 };
  }
});

exports("searchVideos", async (query) => {
  try {
    await ensureReady();
    if (!query || typeof query !== "string") {
      return { error: "Invalid query", code: 400 };
    }
    const [songs, videos] = await Promise.allSettled([
      client.searchSongs(query),
      client.searchVideos(query),
    ]);
    const songList = songs.status === "fulfilled" ? songs.value : [];
    const videoList = videos.status === "fulfilled" ? videos.value : [];
    const seen = new Set();
    const merged = [];

    const maxLen = Math.max(songList.length, videoList.length);
    for (let i = 0; i < maxLen && merged.length < 20; i++) {
      if (i < songList.length) {
        const s = songList[i];
        if (s.videoId && !seen.has(s.videoId)) {
          seen.add(s.videoId);
          merged.push(normalizeSong(s));
        }
      }
      if (i < videoList.length && merged.length < 20) {
        const v = videoList[i];
        if (v.videoId && !seen.has(v.videoId)) {
          seen.add(v.videoId);
          merged.push(normalizeSong(v));
        }
      }
    }
    return { results: merged };
  } catch (err) {
    console.log("[av_music] searchVideos ERROR:", err.message);
    return { error: err.message, code: 500 };
  }
});

exports("extractVideoId", (_, input) => {
  return extractVideoId(input);
});
