import { useEffect, useState, Suspense, lazy } from "react";
import { MantineProvider, Box } from "@mantine/core";
import { isEnvBrowser } from "./hooks/useNuiEvents";
import { Lang } from "./reducers/atoms";
import { useSetRecoilState } from "recoil";
import { MainApp } from "./components/MainApp";
import { getLang } from "./hooks/getLang";
import { InputInfo } from "./types/types";
import { Loading } from "./components/Loading";
import "./App.css";
import "@mantine/core/styles.css";

const Labs = lazy(() => import("./Labs/Labs"));
const Admin = lazy(() => import("./Admin/Admin"));
const Inputs = lazy(() => import("./Inputs/Inputs"));

const App = () => {
  const setLang = useSetRecoilState(Lang);
  const [showApp, setShowApp] = useState(false);
  const [showInput, setShowInput] = useState(false);
  const [showLab, setShowLab] = useState<boolean | string>(false);
  const [inputData, setInputData] = useState<InputInfo>({});
  const [showAdmin, setShowAdmin] = useState(isEnvBrowser());
  const [loaded, setLoaded] = useState(false);
  window.addEventListener("message", (event) => {
    switch (event.data.message) {
      case "loadApp":
        setShowApp(true);
        break;
      case "loadInput":
        setInputData(event.data.inputs);
        setShowInput(event.data.state);
        break;
      case "loadLab":
        setShowLab(event.data.state);
        break;
      case "loadAdmin":
        setShowAdmin(event.data.state);
        break;
      case "close":
        setShowApp(false);
        setShowLab(false);
        setInputData({});
        setShowInput(false);
        setShowAdmin(false);
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
          {!showApp && showInput && (
            <>
              <Suspense fallback={<Loading />}>
                <Inputs data={inputData} show={setShowInput} />
              </Suspense>
            </>
          )}
          {!showApp && showLab && (
            <>
              <Suspense fallback={<Loading />}>
                <Labs identifier={showLab} />
              </Suspense>
            </>
          )}
          {!showApp && showAdmin && (
            <>
              <Suspense fallback={<Loading />}>
                <Admin />
              </Suspense>
            </>
          )}
        </MantineProvider>
      )}
    </>
  );
};
export default App;
