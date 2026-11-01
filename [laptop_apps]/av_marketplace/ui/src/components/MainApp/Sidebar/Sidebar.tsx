import { Stack, ActionIcon, Avatar, Center } from "@mantine/core";
import { Store, Home, MessageSquare, Settings, List } from "lucide-react";

interface Properties {
  tab: string;
  setTab: (tab: string) => void;
  setShowSettings: (show: boolean) => void;
}

export function Sidebar({ tab, setTab, setShowSettings }: Properties) {
  const icons = [
    { id: "market", icon: Home },
    { id: "messages", icon: MessageSquare },
    { id: "listings", icon: List },
  ];
  return (
    <Stack
      p="md"
      w={72}
      bg="var(--bg-panel)"
      h="100%"
      style={{
        backdropFilter: "blur(16px)",
        borderRight: "1px solid var(--border-light)",
        alignItems: "center",
      }}
    >
      <Center
        w={40}
        h={40}
        bg="var(--accent)"
        style={{
          borderRadius: 12,
          boxShadow: "0 0 10px rgba(98, 113, 235, 0.3)",
          marginBottom: 16,
        }}
      >
        <Store size={20} color="var(--text-main)" fill="var(--accent)" />
      </Center>
      <Stack gap="xs" flex={1}>
        {icons.map((item) => (
          <ActionIcon
            key={item.id}
            variant="transparent"
            size={44}
            radius="md"
            onClick={() => setTab(item.id)}
            style={{
              color: tab === item.id ? "var(--accent)" : "var(--text-hint)",
              backgroundColor:
                tab === item.id ? "var(--bg-card)" : "transparent",
              transition: "all 0.2s",
              boxShadow:
                tab === item.id ? "inset 2px 0 0 var(--accent)" : "none",
            }}
          >
            <item.icon size={20} />
          </ActionIcon>
        ))}
      </Stack>
      <ActionIcon
        variant="transparent"
        size={44}
        radius="md"
        style={{ color: "var(--text-hint)" }}
        onClick={() => setShowSettings(true)}
      >
        <Settings size={20} />
      </ActionIcon>
    </Stack>
  );
}
