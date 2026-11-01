import { useEffect, useState } from "react";
import { Box, Text } from "@mantine/core";
import { ConversationList } from "./Conversations";
import { ChatArea } from "./ChatArea";
import { fetchNui, isEnvBrowser } from "../../../../hooks/useNuiEvents";
import { ApiConversations } from "../../../../Api/Conversations";
import { Conversation } from "../../../../types/types";
import { Loading } from "../../../Loading";
import { useAtomValue } from "jotai";
import { Lang } from "../../../../reducers/atoms";

const Messages = () => {
  const lang: any = useAtomValue(Lang);
  const [loaded, setLoaded] = useState(false);
  const [conversations, setConversations] = useState<Conversation[]>([]);
  const [activeConv, setActiveConv] = useState<string>("");

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_marketplace", "getConversations");
      if (resp) {
        setConversations(resp);
      } else {
        if (isEnvBrowser()) {
          setConversations(ApiConversations);
        }
      }
      setLoaded(true);
    };
    fetchData();
  }, []);

  if (!loaded) return <Loading />;

  return (
    <Box
      style={{
        display: "flex",
        height: "calc(100vh - 65px)",
        backgroundColor: "var(--bg-main)",
        fontFamily: "var(--font-body)",
        overflow: "hidden",
      }}
    >
      <ConversationList
        conversations={conversations}
        activeConv={activeConv}
        onSelectConv={setActiveConv}
      />

      {activeConv ? (
        <ChatArea id={activeConv} />
      ) : (
        <Box
          style={{
            flex: 1,
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            backgroundColor: "var(--bg-main)",
          }}
        >
          <Text c="var(--text-muted)" ff="var(--font-body)">
            {lang.messagesSelectConversation}
          </Text>
        </Box>
      )}
    </Box>
  );
};

export default Messages;
