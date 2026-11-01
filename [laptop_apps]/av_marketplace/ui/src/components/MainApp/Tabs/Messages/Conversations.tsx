import { useState } from "react";
import {
  Box,
  Group,
  Text,
  TextInput,
  Avatar,
  ScrollArea,
  UnstyledButton,
  Badge,
  Image,
} from "@mantine/core";
import { Search } from "lucide-react";
import { isWide } from "../../../../hooks/isWide";
import { Conversation } from "../../../../types/types";

interface ConversationListProps {
  conversations: Conversation[];
  activeConv: string;
  onSelectConv: (id: string) => void;
}

export const ConversationList = ({
  conversations,
  activeConv,
  onSelectConv,
}: ConversationListProps) => {
  const [filtered, setFiltered] = useState(conversations);
  const [search, setSearch] = useState("");
  const wide = isWide();

  const handleSearch = (query: string) => {
    setSearch(query);
    if (!query.trim()) {
      setFiltered(conversations);
    } else {
      const lowerQuery = query.toLowerCase();
      setFiltered(
        conversations.filter(
          (conv) =>
            conv.username.toLowerCase().includes(lowerQuery) ||
            conv.post.title.toLowerCase().includes(lowerQuery),
        ),
      );
    }
  };
  return (
    <Box
      style={{
        width: wide ? 320 : 240,
        flexShrink: 0,
        borderRight: "1px solid var(--border-light)",
        backgroundColor: "var(--bg-panel)",
        display: "flex",
        flexDirection: "column",
      }}
    >
      <Box
        p="md"
        style={{ borderBottom: "1px solid var(--border-light)" }}
        h={70}
      >
        <TextInput
          placeholder="Search conversations..."
          leftSection={<Search size={16} />}
          value={search}
          onChange={(e) => handleSearch(e.target.value)}
          styles={{
            input: {
              backgroundColor: "var(--bg-card)",
              borderColor: "var(--border-light)",
              color: "var(--text-main)",
              fontFamily: "var(--font-body)",
            },
          }}
        />
      </Box>
      <ScrollArea flex={1} type="hover">
        <Box
          p="sm"
          style={{ display: "flex", flexDirection: "column", gap: "6px" }}
        >
          {filtered.map((conv) => (
            <UnstyledButton
              key={conv.id}
              onClick={() => onSelectConv(conv.conversation_id)}
              style={{
                padding: "12px",
                borderRadius: "10px",
                backgroundColor:
                  activeConv === conv.conversation_id
                    ? "var(--bg-card)"
                    : "transparent",
                border: `1px solid ${activeConv === conv.conversation_id ? "var(--border-active)" : "transparent"}`,
                transition: "background 0.2s",
                fontFamily: "var(--font-body)",
              }}
            >
              <Group wrap="nowrap" align="flex-start">
                <Image
                  src={conv.avatar}
                  h={44}
                  w={44}
                  radius={100}
                  fallbackSrc="avatar_default.png"
                />
                <Box style={{ flex: 1, minWidth: 0 }}>
                  <Group justify="space-between" mb={2}>
                    <Text size="sm" fw={600} c="var(--text-main)" truncate>
                      {conv.username}
                    </Text>
                    <Text size="xs" c="var(--text-hint)">
                      {conv.updated_at
                        ? new Date(conv.updated_at * 1000).toLocaleTimeString(
                            [],
                            {
                              hour: "2-digit",
                              minute: "2-digit",
                            },
                          )
                        : ""}
                    </Text>
                  </Group>
                  <Group justify="space-between" wrap="nowrap">
                    <Text
                      size="xs"
                      c={
                        conv.unread > 0
                          ? "var(--text-main)"
                          : "var(--text-muted)"
                      }
                      fw={conv.unread > 0 ? 600 : 400}
                      truncate
                    >
                      {conv.last_message}
                    </Text>
                    {conv.unread > 0 && (
                      <Badge
                        size="xs"
                        color="var(--accent)"
                        variant="filled"
                        circle
                      >
                        {conv.unread}
                      </Badge>
                    )}
                  </Group>
                  <Group
                    mt="xs"
                    gap={8}
                    wrap="nowrap"
                    style={{
                      backgroundColor: "var(--bg-main)",
                      padding: "4px 8px",
                      borderRadius: "6px",
                    }}
                  >
                    <Avatar src={conv.post.image} size={20} radius="sm" />
                    <Text
                      size="xs"
                      c="var(--text-muted)"
                      truncate
                      style={{ flex: 1 }}
                    >
                      {conv.post.title}
                    </Text>
                    <Text
                      size="xs"
                      fw={700}
                      ff="var(--font-display)"
                      c="var(--green)"
                      fz={13}
                    >
                      {`$${conv.post.price.toLocaleString("en-US")}`}
                    </Text>
                  </Group>
                </Box>
              </Group>
            </UnstyledButton>
          ))}
        </Box>
      </ScrollArea>
    </Box>
  );
};
