import { useEffect, useState } from "react";
import { MantineProvider, Box, Group, Text, ActionIcon } from "@mantine/core";
import { isEnvBrowser } from "./hooks/useNuiEvents";
import { useAppDispatch } from "./hooks/reduxHooks";
import { setHeight } from "./reducers/height";
import { setLanguage } from "./reducers/language";
import { Cupcake } from "./components/Cupcake";
import "./App.css";
import "@mantine/core/styles.css";
import { useViewportHeight } from "./hooks/windowResize";
import { getLang } from "./hooks/getLang";

const App = ({ height }: any) => {
  const viewPort = useViewportHeight();
  const [loaded, setLoaded] = useState(false);
  const dispatch = useAppDispatch();
  useEffect(() => {
    if (height) {
      dispatch(setHeight(height));
    } else {
      dispatch(setHeight(viewPort));
    }
    const fetchLang = async () => {
      const resp = await getLang();
      if (resp) dispatch(setLanguage(resp));
      setLoaded(true);
    };
    fetchLang();
  }, []);
  return (
    <>
      {loaded && (
        <MantineProvider defaultColorScheme="dark">
          {isEnvBrowser() ? (
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
                <Box className="app-window" w={"80%"} h={"80%"}>
                  <Box
                    className="app-bar"
                    style={{ display: "flex", alignItems: "center", zIndex: 2 }}
                  >
                    <Group
                      justify="space-between"
                      w={"100%"}
                      style={{ marginLeft: "auto", marginRight: "auto" }}
                    >
                      <Text size="xs" ml={5} c="dimmed" fw={600}>
                        Custom App
                      </Text>
                      <ActionIcon
                        size={10}
                        color="rgba(183,83,83,0.9)"
                        radius={50}
                        mr={5}
                      />
                    </Group>
                  </Box>
                  <Cupcake />
                </Box>
              </Box>
            </Box>
          ) : (
            <Cupcake />
          )}
        </MantineProvider>
      )}
    </>
  );
};
export default App;
