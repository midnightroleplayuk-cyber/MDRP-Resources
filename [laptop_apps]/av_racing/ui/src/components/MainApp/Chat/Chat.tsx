import { useEffect, useState } from "react";
import {
  Modal,
  Stack,
  ScrollArea,
  Textarea,
  Group,
  Text,
  ActionIcon,
  Box,
} from "@mantine/core";
import { Copy as IconCopy } from "lucide-react";
import { ChatType } from "../../../types/types";
import { useViewportHeight } from "../../../hooks/windowResize";
import { Loading } from "../../Loading";
import {
  fetchNui,
  isEnvBrowser,
  useNuiEvent,
} from "../../../hooks/useNuiEvents";
import { ApiChat } from "../../../Api/Chat";
import { formatTimestampToTime, sortMessages } from "./helpers";
import { useRecoilValue } from "recoil";
import { Lang, Profile } from "../../../reducers/atoms";
import global from "../../../global.module.css";
import classes from "./style.module.css";

interface Properties {
  id: string;
  setId: () => void;
  isAdmin?: boolean;
}

interface Message {
  event: string;
  message: ChatType;
}

export const Chat = ({ id, setId, isAdmin }: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const { name } = useRecoilValue(Profile);
  const [loaded, setLoaded] = useState(false);
  const [messages, setMessages] = useState<ChatType[]>([]);
  const [message, setMessage] = useState("");
  const [host, setHost] = useState("");
  const height = useViewportHeight();

  useNuiEvent("newMessage", (data: Message) => {
    if (data.event !== id) return;
    setMessages([...messages, data.message]);
  });

  const getNameClass = (msgName: string, identifier: string) => {
    if (msgName === lang.system_username) return classes.systemName;
    if (identifier === host) return classes.hostName;
    return classes.messageName;
  };

  const handleSend = () => {
    const trimmedMessage = message.trim();
    if (trimmedMessage.length === 0) {
      return;
    }
    fetchNui("av_racing", "sendMessage", {
      event: id,
      message,
      name: isAdmin ? lang.system_username : name,
    });
    setMessage("");
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getChat", id);
      if (resp) {
        const ordered = sortMessages(resp.chat ?? []);
        setHost(resp.host);
        setMessages(ordered);
      } else {
        if (isEnvBrowser()) {
          const ordered = sortMessages(ApiChat);
          setMessages(ordered);
        }
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, [id]);

  return (
    <Modal
      classNames={{ content: global.content, header: global.header }}
      opened
      size="100%"
      centered
      lockScroll={false}
      trapFocus={false}
      title={
        <Text fw={800} fz="lg" tt="uppercase" c="white" lts={1}>
          {lang.event_chat ?? "EVENT CHAT"}
        </Text>
      }
      onClose={setId}
      styles={{
        content: {
          maxWidth: "700px",
          minHeight: !loaded ? height / 2 : undefined,
          backdropFilter: isAdmin ? "unset" : undefined,
        },
      }}
    >
      {!loaded ? (
        <Loading />
      ) : (
        <Stack className={classes.window}>
          <ScrollArea
            className={classes.scroll}
            h={420}
            type="hover"
            scrollbars="y"
            scrollbarSize={6}
            offsetScrollbars
          >
            <Stack p="sm" gap={2}>
              {messages.map((data, idx) => (
                <Box key={idx} className={classes.messageCard}>
                  <Group className={classes.messageHeader}>
                    <Text className={getNameClass(data.name, data.identifier)}>
                      {data.name}
                    </Text>
                    <Text className={classes.messageTime}>
                      {formatTimestampToTime(data.date)}
                    </Text>
                    {isAdmin && (
                      <Group ml="auto" gap="xs">
                        <Text fz="xs" c="var(--text-dim)">
                          {data.identifier}
                        </Text>
                        <ActionIcon
                          size="xs"
                          variant="transparent"
                          c="var(--text-dim)"
                          onClick={() => {
                            fetchNui("av_laptop", "copy", data.identifier);
                          }}
                        >
                          <IconCopy style={{ height: 14, width: 14 }} />
                        </ActionIcon>
                      </Group>
                    )}
                  </Group>
                  <Text className={classes.messageText}>{data.message}</Text>
                </Box>
              ))}
            </Stack>
          </ScrollArea>

          <Textarea
            classNames={{ input: global.input }}
            value={message}
            rightSection={
              <button className={classes.sendButton} onClick={handleSend}>
                {lang.send ?? "SEND"}
              </button>
            }
            onKeyDown={(e) => {
              if (e.code === "Enter" && !e.shiftKey) {
                e.preventDefault();
                handleSend();
              }
            }}
            rightSectionWidth={80}
            maxLength={100}
            maxRows={1}
            onChange={(e) => {
              setMessage(e.currentTarget.value);
            }}
          />
        </Stack>
      )}
    </Modal>
  );
};
