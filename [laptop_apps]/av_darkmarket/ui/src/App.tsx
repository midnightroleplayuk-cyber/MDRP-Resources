import "./App.css";
import "@mantine/core/styles.css";
import { useEffect, useState } from "react";
import { MantineProvider, Box } from "@mantine/core";
import { isEnvBrowser } from "./hooks/useNuiEvents";
import { MainApp } from "./components/MainApp";

const App = () => {
  const [showApp, setShowApp] = useState(isEnvBrowser());

  useEffect(() => {
    const handleMessage = (event: MessageEvent) => {
      switch (event.data.message) {
        case "loadApp":
          setShowApp(true);
          break;
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
                  backgroundColor: isEnvBrowser() ? "black" : "transparent",
                }}
              >
                <Box
                  className="laptop-frame"
                  style={{
                    backgroundImage: `url(https://files.fivemerr.com/images/d6034dbe-d1f1-49a4-a231-3026c4b104a9.jpg)`,
                    backgroundSize: "cover",
                  }}
                >
                  <Box className="app-window">
                    <MainApp />
                  </Box>
                </Box>
              </Box>
            </>
          ) : (
            <MainApp />
          )}
        </>
      )}
    </MantineProvider>
  );
};
export default App;
