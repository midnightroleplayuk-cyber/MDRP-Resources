import "./App.css";
import "@mantine/core/styles.css";
import { useEffect, useState } from "react";
import { MantineProvider, Box } from "@mantine/core";
import { isEnvBrowser } from "./hooks/useNuiEvents";
import { Lang } from "./reducers/atoms";
import { useSetRecoilState } from "recoil";
import { MainApp } from "./components/Gangs/MainApp";
import { getLang } from "./hooks/getLang";
import { Admin } from "./components/Admin/Admin";
import { Graffitis } from "./components/Graffitis/Graffitis";

const App = () => {
  const [showAdmin, setShowAdmin] = useState(isEnvBrowser());
  const [showApp, setShowApp] = useState(false);
  const setLang = useSetRecoilState(Lang);
  const [loaded, setLoaded] = useState(false);
  window.addEventListener("message", (event) => {
    switch (event.data.message) {
      case "loadApp":
        setShowApp(true);
        break;
      case "adminMenu":
        setShowAdmin(event.data.state);
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
    if (isEnvBrowser()) {
      document.body.style.background = `url("https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/background2.jpg") no-repeat center center fixed`;
      document.body.style.backgroundSize = "cover";
    }
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
          {showAdmin && <Admin />}
        </MantineProvider>
      )}
      <Graffitis />
    </>
  );
};
export default App;
