import "./App.css";
import { useEffect, useState, Suspense, lazy } from "react";
import { MantineProvider, Box } from "@mantine/core";
import { fetchNui, isEnvBrowser } from "./hooks/useNuiEvents";
import { RacingPanel } from "./components/RacingUI/RacingPanel";

const MainApp = lazy(() => import("./components/MainApp/MainApp"));
const Underground = lazy(() =>
  import("./components/Underground/Underground").then((m) => ({
    default: m.Underground,
  })),
);
const Editor = lazy(() =>
  import("./components/Editor/Editor").then((m) => ({ default: m.Editor })),
);
const Admin = lazy(() =>
  import("./components/Admin/Admin").then((m) => ({ default: m.Admin })),
);

const App = () => {
  const [showApp, setShowApp] = useState(isEnvBrowser());
  const [showEditor, setShowEditor] = useState(false);
  const [showAdmin, setShowAdmin] = useState(false);
  const [showRacing, setShowRacing] = useState(false);
  const [showUnderground, setShowUnderground] = useState(false);
  const [appSize, setAppSize] = useState({ width: "100%", height: "100%" });

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
          setShowApp(true);
          break;
        case "editor":
          setShowEditor(event.data.state);
          break;
        case "admin":
          setShowAdmin(event.data.state);
          break;
        case "racing":
          setShowRacing(event.data.state);
          break;
        case "underground":
          setShowUnderground(event.data.state);
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
  }, []);

  useEffect(() => {
    if (isEnvBrowser()) {
      document.body.style.background = `url("https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/background2.jpg") no-repeat center center fixed`;
      document.body.style.backgroundSize = "cover";
    }
    fetchNui("av_racing", "loaded");
  }, []);

  return (
    <MantineProvider defaultColorScheme="dark">
      {showApp && (
        <>
          {isEnvBrowser() ? (
            <>
              <Box
                className="main-container"
                style={{
                  backgroundColor: "black",
                }}
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
                    <Suspense fallback={null}>
                      <MainApp />
                    </Suspense>
                  </Box>
                </Box>
              </Box>
            </>
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
              <Suspense fallback={null}>
                <MainApp />
              </Suspense>
            </Box>
          )}
        </>
      )}
      <Suspense fallback={null}>
        {showUnderground && <Underground />}
        {showEditor && <Editor />}
        {showAdmin && <Admin />}
      </Suspense>
      {showRacing && <RacingPanel />}
    </MantineProvider>
  );
};

export default App;
