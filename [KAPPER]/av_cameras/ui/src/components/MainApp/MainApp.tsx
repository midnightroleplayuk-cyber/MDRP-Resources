import { lazy, Suspense, useState } from "react";
import { Box, Flex } from "@mantine/core";
import { Sidebar } from "./Sidebar/Sidebar";
import { Header } from "./Header/Header";
import { Loading } from "../Loading";
import { ModalMenu } from "../ModalMenu/ModalMenu";
import { CamLoader } from "./Content/CamLoader";
import { useCameras } from "../../hooks/useCameras";
import { Authorized } from "./Authorized/Authorized";
import { Memory } from "./Memory/Memory";
import classes from "./style.module.css";

const GridView = lazy(() => import("./Content/GridView"));
const MapView = lazy(() => import("./Content/MapView"));

export const CameraApp = () => {
  const [authWindow, setAuthWindow] = useState<any>({
    state: false,
    type: "",
    identifier: "",
  });
  const [memory, setMemory] = useState({ state: false, identifier: "" });

  const handleAccessMemory = (identifier: string) => {
    setMemory({ state: true, identifier });
  };

  const {
    view,
    setView,
    allGroups,
    allCameras,
    filtered,
    filteredBy,
    myCoords,
    connection,
    modalData,
    setModalData,
    handleConnection,
    handleCallback,
    handleFiltered,
    handleSearch,
    handleRename,
    handleSendToGroup,
    handleShare,
    handleRemove,
    handleRemoveGroup,
  } = useCameras();

  const handleAuth = (type: string, identifier: string) => {
    setAuthWindow({ state: true, type, identifier });
  };

  return (
    <Box className={classes.wrapper}>
      {memory.state && (
        <Memory
          identifier={memory.identifier}
          onClose={() => setMemory({ state: false, identifier: "" })}
        />
      )}
      {authWindow.state && (
        <Authorized
          type={authWindow.type}
          identifier={authWindow.identifier}
          onClose={() =>
            setAuthWindow({ state: false, type: "", identifier: "" })
          }
        />
      )}
      {connection.connecting && (
        <CamLoader cameraLabel={connection.cameraLabel} />
      )}
      {modalData.state && (
        <ModalMenu data={modalData} callback={handleCallback} />
      )}
      <Header view={view} setView={setView} handleSearch={handleSearch} />
      <Flex className={classes.mainArea}>
        <Sidebar
          allCameras={allCameras}
          allGroups={allGroups}
          filteredBy={filteredBy}
          handleFiltered={handleFiltered}
          setModalData={setModalData}
          handleRemoveGroup={handleRemoveGroup}
          handleAuth={handleAuth}
        />
        <Flex direction="column" flex={1} style={{ overflow: "hidden" }}>
          <Box className={classes.content}>
            <Suspense fallback={<Loading />}>
              {view === "grid" && (
                <GridView
                  filtered={filtered}
                  allGroups={allGroups}
                  handleConnection={handleConnection}
                  handleRename={handleRename}
                  handleSendToGroup={handleSendToGroup}
                  handleShare={handleShare}
                  handleRemove={handleRemove}
                  handleAccessMemory={handleAccessMemory}
                />
              )}
              {view === "map" && (
                <MapView
                  filtered={filtered}
                  myCoords={myCoords}
                  allGroups={allGroups}
                  handleConnection={handleConnection}
                  handleRename={handleRename}
                  handleSendToGroup={handleSendToGroup}
                  handleShare={handleShare}
                  handleRemove={handleRemove}
                  handleAccessMemory={handleAccessMemory}
                />
              )}
            </Suspense>
          </Box>
        </Flex>
      </Flex>
    </Box>
  );
};

export default CameraApp;
