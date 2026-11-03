import "./App.css";
import { useEffect, useState } from "react";
import { MantineProvider, Box, createTheme } from "@mantine/core";
import { fetchNui, isEnvBrowser } from "./hooks/useNuiEvents";
import { Lang, playlistsAtom, playerAtom } from "./reducers/atoms";
import { getLang } from "./hooks/getLang";
import { useSetAtom } from "jotai";
import { MainApp } from "./components/MainApp/MainApp";
import { getPlaylists, getPlayerState } from "./Api/Api";
import { AudioEngine } from "./components/AudioEngine/AudioEngine";
import { MiniPlayer } from "./components/MiniPlayer/MiniPlayer";
import { AdminPanel } from "./components/AdminPanel/AdminPanel";

const theme = createTheme({
  components: {
    Tooltip: {
      defaultProps: {
        styles: {
          tooltip: {
            background: "var(--bg-card-alt)",
            color: "var(--text-primary)",
            border: "1px solid var(--border-input)",
            fontSize: 11,
            padding: "4px 9px",
            borderRadius: 6,
          },
        },
      },
    },
    Menu: {
      defaultProps: {
        styles: {
          dropdown: {
            background: "var(--bg-card)",
            border: "1px solid var(--border-input)",
            borderRadius: 8,
          },
          item: {
            color: "var(--text-muted)",
            fontSize: 12,
          },
          label: {
            color: "var(--text-secondary)",
            fontSize: 10,
          },
          divider: {
            borderColor: "var(--border-faint)",
          },
        },
      },
    },
  },
});

const App = () => {
  const setLang = useSetAtom(Lang);
  const setPlaylists = useSetAtom(playlistsAtom);
  const setPlayer = useSetAtom(playerAtom);
  const [loaded, setLoaded] = useState(false);
  const [currentApp, setCurrentApp] = useState<null | string>(
    isEnvBrowser() ? "music" : null,
  );
  const [appSize, setAppSize] = useState({ width: "100%", height: "100%" });

  const restoreState = async () => {
    const [pls, state] = await Promise.all([getPlaylists(), getPlayerState()]);
    setPlaylists(pls);
    if (state) {
      setPlayer((p) => ({
        ...p,
        track: state.track,
        playing: state.playing,
        currentTime: state.currentTime,
        durationSecs: state.duration,
        progress: state.progress,
      }));
    }
  };

  const fetchInit = async () => {
    try {
      const lang = await getLang();
      setLang(lang);
      fetchNui("av_music", "loaded");
      await restoreState();
    } catch (err) {
      console.error("fetchInit error:", err);
    } finally {
      setLoaded(true);
    }
  };

  useEffect(() => {
    const handleMessage = (event: MessageEvent) => {
      if (!event.data || typeof event.data !== "object" || !event.data.message)
        return;
      switch (event.data.message) {
        case "loadApp":
          setCurrentApp(event.data.name);

          restoreState();
          break;
        case "resize":
          setAppSize({
            width: `${event.data.width}px`,
            height: `${event.data.height}px`,
          });
          break;
      }
    };
    window.addEventListener("message", handleMessage);
    return () => window.removeEventListener("message", handleMessage);
  }, []);

  useEffect(() => {
    if (isEnvBrowser()) {
      document.body.style.background = `url("https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/background2.jpg") no-repeat center center fixed`;
      document.body.style.backgroundSize = "cover";
    }
    if (!loaded) fetchInit();
  }, []);

  if (!loaded) return null;

  return (
    <MantineProvider theme={theme} defaultColorScheme="dark">
      <AudioEngine />
      <MiniPlayer />
      <AdminPanel />

      {currentApp &&
        (isEnvBrowser() ? (
          <Box className="main-container" style={{ backgroundColor: "black" }}>
            <Box
              className="laptop-frame"
              style={{
                backgroundImage: `url(https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/mountains.jpg)`,
                backgroundSize: "cover",
              }}
            >
              <Box
                className="app-window"
                style={{ display: "flex", flexDirection: "column" }}
              >
                <MainApp />
              </Box>
            </Box>
          </Box>
        ) : (
          <Box
            style={{
              width: appSize.width,
              height: appSize.height,
              overflowY: "auto",
              overflowX: "hidden",
              position: "absolute",
              top: 0,
              left: 0,
              display: "flex",
              flexDirection: "column",
            }}
          >
            <MainApp />
          </Box>
        ))}
    </MantineProvider>
  );
};

export default App;
