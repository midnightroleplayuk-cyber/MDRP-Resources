import { useState, useRef, useEffect } from "react";
import {
  Box,
  Group,
  Text,
  Avatar,
  ActionIcon,
  ScrollArea,
  Textarea,
  Divider,
  Image,
  Tooltip,
} from "@mantine/core";
import { Copy, Send } from "lucide-react";
import {
  fetchNui,
  isEnvBrowser,
  useNuiEvent,
} from "../../../../hooks/useNuiEvents";
import { ApiMessages } from "../../../../Api/Conversations";
import { Message } from "../../../../types/types";
import { useTimestamp } from "../../../../hooks/formatTime";
import { useAtomValue } from "jotai";
import { Lang } from "../../../../reducers/atoms";

interface ChatAreaProps {
  id: string;
}

const getDaysAgo = (timestamp: number, lang: any) => {
  const ts = timestamp > 9999999999 ? timestamp : timestamp * 1000;
  const days = Math.floor((Date.now() - ts) / 86400000);

  if (days <= 0) return lang.listedToday;
  if (days === 1) return lang.listedYesterday;
  return `${lang.listed} ${days} ${lang.daysAgo}`;
};

export const ChatArea = ({ id }: ChatAreaProps) => {
  const lang: any = useAtomValue(Lang);
  const [post, setPost] = useState({
    title: "",
    price: 0,
    image: "",
    created_at: 1716300000,
  });
  const [messages, setMessages] = useState<Message[]>([]);
  const [msgText, setMsgText] = useState("");
  const [profile, setProfile] = useState({
    username: "Jon Doe",
    avatar: "",
    identifier: "abc123",
  });
  const viewportRef = useRef<HTMLDivElement>(null);

  useNuiEvent("newMessage", (data: any) => {
    if (data.conversationId === id) {
      setMessages((prev) => [...prev, data.message]);
    }
  });

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_marketplace", "getMessages", id);
      if (resp) {
        setPost(resp.post);
        setProfile(resp.profile);
        setMessages(resp.messages);
      } else {
        if (isEnvBrowser()) {
          setMessages(ApiMessages);
        }
      }
    };
    fetchData();
  }, [id]);

  useEffect(() => {
    if (viewportRef.current) {
      viewportRef.current.scrollTo({
        top: viewportRef.current.scrollHeight,
        behavior: "smooth",
      });
    }
  }, [messages]);

  const handleSend = () => {
    if (!msgText.trim()) return;
    fetchNui("av_marketplace", "sendMessage", {
      conversationId: id,
      message: msgText.trim(),
    });
    setMsgText("");
  };

  return (
    <Box style={{ flex: 1, display: "flex", flexDirection: "column" }}>
      <Group
        p="md"
        h={70}
        style={{
          borderBottom: "1px solid var(--border-light)",
          backgroundColor: "var(--bg-panel)",
        }}
      >
        <Group>
          <Image
            src={profile.avatar}
            h={44}
            w={44}
            radius={100}
            fallbackSrc="avatar_default.png"
          />
          <Text size="sm" fw={600} c="var(--text-main)">
            {profile.username}
          </Text>
        </Group>
        <Tooltip label={lang.chatCopyIdentifier} withArrow fw={500} radius="md">
          <ActionIcon
            variant="transparent"
            size="sm"
            color="indigo.3"
            onClick={() => {
              fetchNui("av_laptop", "copy", profile.identifier);
            }}
          >
            <Copy size={16} />
          </ActionIcon>
        </Tooltip>
      </Group>
      <Group
        p="sm"
        px="md"
        wrap="nowrap"
        style={{
          borderBottom: "1px solid var(--border-light)",
          backgroundColor: "var(--bg-card)",
        }}
      >
        <Avatar src={post.image} size={44} radius="md" />
        <Box style={{ flex: 1 }}>
          <Text size="sm" fw={600} c="var(--text-main)">
            {post.title}
          </Text>
          <Text size="sm" ff="var(--font-display)" c="var(--green)" fw={700}>
            {`$${post.price.toLocaleString("en-US")}`}
            <Text
              span
              ff="var(--font-body)"
              size="xs"
              c="var(--text-hint)"
              fw={400}
              ml={4}
            >
              {getDaysAgo(post.created_at, lang)}
            </Text>
          </Text>
        </Box>
      </Group>
      <ScrollArea flex={1} p="xl" viewportRef={viewportRef}>
        <Divider
          labelPosition="center"
          my="lg"
          color="var(--border-light)"
          styles={{
            label: {
              color: "var(--text-hint)",
              backgroundColor: "var(--bg-main)",
            },
          }}
        />
        <Box style={{ display: "flex", flexDirection: "column", gap: "16px" }}>
          {messages.map((msg) => {
            const isMe = msg.sender === "me";
            return (
              <Box
                key={msg.id}
                style={{
                  alignSelf: isMe ? "flex-end" : "flex-start",
                  maxWidth: "70%",
                }}
              >
                <Box
                  p="10px 14px"
                  style={{
                    backgroundColor: isMe ? "var(--accent)" : "var(--bg-card)",
                    color: isMe ? "white" : "var(--text-secondary)",
                    borderRadius: isMe
                      ? "16px 4px 16px 16px"
                      : "4px 16px 16px 16px",
                    fontSize: "14px",
                    lineHeight: 1.5,
                    border: isMe ? "none" : "1px solid var(--border-light)",
                    userSelect: "text",
                  }}
                >
                  {msg.message}
                </Box>
                <Text
                  fz={10}
                  c="var(--text-hint)"
                  mt={4}
                  ta={isMe ? "right" : "left"}
                >
                  {useTimestamp(msg.created_at, "datetime")}
                </Text>
              </Box>
            );
          })}
        </Box>
      </ScrollArea>

      <Box
        p="md"
        style={{
          borderTop: "1px solid var(--border-light)",
          backgroundColor: "var(--bg-panel)",
        }}
      >
        <Box
          style={{
            display: "flex",
            alignItems: "flex-end",
            gap: "8px",
            backgroundColor: "var(--bg-main)",
            border: "1px solid var(--border-light)",
            borderRadius: "12px",
            padding: "8px 12px",
          }}
        >
          <Textarea
            placeholder={`${lang.chatMessagePlaceholder} ${profile.username}...`}
            minRows={1}
            maxRows={4}
            autosize
            variant="unstyled"
            value={msgText}
            onChange={(e) => setMsgText(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === "Enter" && !e.shiftKey) {
                e.preventDefault();
                handleSend();
              }
            }}
            styles={{
              input: {
                border: "none",
              },
            }}
            style={{ flex: 1 }}
          />
          <ActionIcon
            variant="filled"
            size="lg"
            radius="md"
            onClick={handleSend}
            disabled={!msgText.trim()}
            style={{
              backgroundColor: msgText.trim()
                ? "var(--accent)"
                : "var(--bg-pill-active)",
              color: msgText.trim() ? "white" : "var(--text-muted)",
            }}
          >
            <Send size={16} />
          </ActionIcon>
        </Box>
      </Box>
    </Box>
  );
};
