import { Box } from "@mantine/core";
import { Sidebar } from "./Sidebar/Sidebar";
import { MainView } from "./MainView/MainView";
import { PlaylistsView } from "./PlaylistsView/PlaylistsView";
import { RadioView } from "./RadioView/RadioView";
import { QueueView } from "./QueueView/QueueView";
import { PlayerBar } from "./PlayerBar/PlayerBar";
import { useAtomValue } from "jotai";
import { viewAtom, playerAtom } from "../../reducers/atoms";
import classes from "./style.module.css";

export const MainApp = () => {
  const view = useAtomValue(viewAtom);
  const player = useAtomValue(playerAtom);
  const cover = player.track?.cover ?? "";

  return (
    <Box className={classes.root}>
      <Box className={classes.contentRow}>
        <Sidebar />
        <Box className={classes.viewWrapper}>
          <Box
            className={classes.blurBg}
            style={{ backgroundImage: cover ? `url('${cover}')` : "none" }}
            data-visible={cover ? "true" : "false"}
          />
          {view === "browse" && <MainView />}
          {view === "playlists" && <PlaylistsView />}
          {view === "radio" && <RadioView />}
          {view === "queue" && <QueueView />}
        </Box>
      </Box>
      <PlayerBar />
    </Box>
  );
};
