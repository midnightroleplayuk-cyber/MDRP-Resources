import { useEffect, useState, Suspense, lazy } from "react";
import { MantineProvider, Box } from "@mantine/core";
import { isEnvBrowser } from "./hooks/useNuiEvents";
import { Lang } from "./reducers/atoms";
import { useSetRecoilState } from "recoil";
import { getLang } from "./hooks/getLang";
import { Loading } from "./components/Loading";
import "./App.css";
import "@mantine/core/styles.css";
import { MainApp } from "./components/MainApp";

const App = () => {
  const setLang = useSetRecoilState(Lang);
  const [showApp, setShowApp] = useState(isEnvBrowser());
  const [loaded, setLoaded] = useState(false);
  window.addEventListener("message", (event) => {
    switch (event.data.message) {
      case "loadApp":
        setShowApp(true);
        break;
      default:
        break;
    }
  });
  useEffect(() => {
    const fetchLang = async () => {
      const resp = await getLang();
      setLang(resp);
      setLoaded(true);
    };
    fetchLang();
  }, []);
  return (
    <>
      {loaded && (
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
                        backgroundImage: `url(https://raw.githubusercontent.com/Renovamen/playground-macos/main/public/img/ui/wallpaper-night.jpg)`,
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
      )}
    </>
  );
};
export default App;
