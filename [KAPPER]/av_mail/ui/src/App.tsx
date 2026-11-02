import "./App.css";
import { useEffect, useState } from "react";
import { MantineProvider, Box } from "@mantine/core";
import { fetchNui, isEnvBrowser } from "./hooks/useNuiEvents";
import { Lang, adminOpenAtom } from "./reducers/atoms";
import { getLang } from "./hooks/getLang";
import { useSetAtom } from "jotai";
import { MainApp } from "./components/MainApp/MainApp";
import { AdminPanel } from "./components/AdminPanel/AdminPanel";

const App = () => {
  const setLang = useSetAtom(Lang);
  const setAdminOpen = useSetAtom(adminOpenAtom);
  const [loaded, setLoaded] = useState(false);
  const [currentApp, setCurrentApp] = useState<null | string>(
    isEnvBrowser() ? "mail" : null,
  );
  const [appSize, setAppSize] = useState({ width: "100%", height: "100%" });

  const fetchInit = async () => {
    try {
      const response = await getLang();
      setLang(response);
      fetchNui("av_mail", "loaded");
      setLoaded(true);
    } catch (error) {
      console.error("Error loading init data:", error);
    }
  };

  useEffect(() => {
    const handleMessage = (event: MessageEvent) => {
      if (
        !event.data ||
        typeof event.data !== "object" ||
        !event.data.message
      ) {
        return;
      }
      switch (event.data.message) {
        case "loadApp":
          setCurrentApp(event.data.name);
          break;
        case "admin":
          setAdminOpen(!!event.data.state);
          break;
        case "resize":
          setAppSize({
            width: `${event.data.width}px`,
            height: `${event.data.height}px`,
          });
          return;
        default:
          break;
      }
    };

    window.addEventListener("message", handleMessage);
    return () => window.removeEventListener("message", handleMessage);
  }, [setAdminOpen]);

  useEffect(() => {
    if (isEnvBrowser()) {
      document.body.style.background = `url("https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/background2.jpg") no-repeat center center fixed`;
      document.body.style.backgroundSize = "cover";
    }
    if (!loaded) {
      fetchInit();
    }
  }, []);
  if (!loaded) return null;
  return (
    <MantineProvider defaultColorScheme="dark">
      {currentApp && (
        <>
          {isEnvBrowser() ? (
            <Box
              className="main-container"
              style={{ backgroundColor: "black" }}
            >
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
          )}
        </>
      )}
      <AdminPanel />
    </MantineProvider>
  );
};

export default App;
