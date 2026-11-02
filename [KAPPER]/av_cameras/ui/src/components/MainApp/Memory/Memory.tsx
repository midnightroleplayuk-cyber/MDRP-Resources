import { useEffect, useState } from "react";
import {
  Modal,
  Box,
  ScrollArea,
  Stack,
  Group,
  Text,
  Button,
} from "@mantine/core";
import { Loading } from "../../Loading";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { ModalType } from "../../../types/types";
import { ModalMenu } from "../../ModalMenu/ModalMenu";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";

interface FileType {
  id: string;
  name: string;
  content?: string;
  type: "video" | "replay";
}

interface Properties {
  identifier: string;
  onClose: () => void;
}

export const Memory = ({ identifier, onClose }: Properties) => {
  const lang: any = useAtomValue(Lang);
  const [files, setFiles] = useState<FileType[]>([]);
  const [loaded, setLoaded] = useState(false);
  const [activeVideo, setActiveVideo] = useState<FileType | null>(null);
  const [modalData, setModalData] = useState<ModalType>({ state: false });

  const handleView = (file: FileType) => {
    if (file.type === "video" && file.content) {
      setActiveVideo(file);
    } else {
      setModalData({
        state: true,
        info: {
          title: file.name,
          options: [
            {
              type: "info",
              description: lang.replay_load_warning,
              size: "xs",
            },
          ],
          button: lang.load_replay,
          extraData: file.id,
        },
      });
    }
  };

  const handleCallback = (data: any) => {
    setModalData({ state: false });
    if (!data) return;
    const { extraData } = data;
    fetchNui("av_cameras", "fetchReplayContent", extraData);
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_cameras", "fetchMemory", identifier);
      if (resp) {
        const sorted = [...resp].sort((a, b) => b.created - a.created);
        setFiles(sorted);
      } else {
        if (isEnvBrowser()) {
          setFiles([
            {
              id: "1",
              name: "Footage 1",
              content: "https://r2.fivemanage.com/video/92RdLqJPuVqX.webm",
              type: "video",
            },
            {
              id: "2",
              name: "Footage 2",
              content: "https://r2.fivemanage.com/video/92RdLqJPuVqX.webm",
              type: "video",
            },
            {
              id: "3",
              name: "Footage 3",
              type: "replay",
            },
          ]);
        }
      }
      setLoaded(true);
    };
    fetchData();
  }, []);

  return (
    <>
      {modalData.state && (
        <ModalMenu data={modalData} callback={handleCallback} />
      )}
      <Modal
        opened
        onClose={onClose}
        title={lang.camera_memory}
        centered
        lockScroll={false}
        c="white"
        trapFocus={false}
        styles={{
          body: {
            height: 400,
            display: "flex",
            flexDirection: "column",
            justifyContent: "space-between",
          },
        }}
        classNames={{
          header: "header",
          title: "title",
          body: "body",
          content: "content",
        }}
      >
        {loaded ? (
          <ScrollArea
            flex={1}
            mb="sm"
            type="hover"
            offsetScrollbars
            scrollbarSize={6}
          >
            <Stack gap="sm">
              {files.length > 0 ? (
                files.map((item: FileType, index: number) => (
                  <Group
                    key={index}
                    bg="var(--bg-card)"
                    p="sm"
                    style={{ borderRadius: 6 }}
                  >
                    <Group gap="xs">
                      <Text fz="sm" c="var(--text-main)">
                        {item.name}
                      </Text>
                      <Text fz="xs" c="var(--text-dim)">
                        {item.type === "video" ? lang.video : lang.replay}
                      </Text>
                    </Group>
                    <Button
                      ml="auto"
                      size="xs"
                      variant="outline"
                      color="var(--accent)"
                      onClick={() => handleView(item)}
                    >
                      {lang.view}
                    </Button>
                  </Group>
                ))
              ) : (
                <Text fz="sm" c="var(--text-dim)" ta="center">
                  {lang.no_files_found}
                </Text>
              )}
            </Stack>
          </ScrollArea>
        ) : (
          <Loading />
        )}
      </Modal>
      <Modal
        opened={!!activeVideo}
        onClose={() => setActiveVideo(null)}
        title={activeVideo?.name ?? ""}
        centered
        lockScroll={false}
        c="white"
        trapFocus={false}
        size="80vw"
        zIndex={300}
        classNames={{
          header: "header",
          title: "title",
          body: "body",
          content: "content",
        }}
      >
        {activeVideo && activeVideo.type === "video" && (
          <Box>
            <video
              key={activeVideo.content}
              src={activeVideo.content}
              controls
              autoPlay
              style={{
                width: "100%",
                borderRadius: 6,
                background: "#000",
                maxHeight: 600,
              }}
            />
          </Box>
        )}
      </Modal>
    </>
  );
};
