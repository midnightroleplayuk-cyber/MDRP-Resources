import { Group, Text, TextInput, Button, ActionIcon } from "@mantine/core";
import { useAtomValue } from "jotai";
import { Search, Plus, X } from "lucide-react";
import { Lang } from "../../../reducers/atoms";

interface Properties {
  tab: string;
  search: string;
  setSearch: (search: string) => void;
  setCreator: () => void;
}

export const Header = ({ tab, search, setSearch, setCreator }: Properties) => {
  const lang: any = useAtomValue(Lang);
  return (
    <Group
      p="sm"
      bg="var(--bg-panel)"
      style={{ borderBottom: "1px solid var(--border-light)" }}
      h={65}
    >
      <Group gap={4} align="center">
        <Text
          fz={29}
          ff="var(--font-display)"
          lts={2.5}
          fw={800}
          c="var(--text-main)"
          tt="uppercase"
        >
          Market
        </Text>
        <Text
          fz={29}
          ff="var(--font-display)"
          lts={2.5}
          fw={800}
          c="var(--accent-light)"
          tt="uppercase"
        >
          Place
        </Text>
      </Group>
      {tab !== "messages" && (
        <Group ml="auto">
          <TextInput
            size="sm"
            placeholder="Search..."
            leftSection={<Search size={18} />}
            rightSection={
              search.length > 0 ? (
                <ActionIcon
                  size="sm"
                  variant="transparent"
                  onClick={() => setSearch("")}
                  style={{ color: "var(--text-muted)" }}
                >
                  <X size={14} />
                </ActionIcon>
              ) : null
            }
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            w={255}
            ml="xl"
            radius="md"
            styles={{
              input: {
                backgroundColor: "var(--bg-card)",
                borderColor: "var(--border-light)",
                color: "var(--text-main)",
                transition: "all 0.2s",
              },
            }}
          />
          <Button
            size="sm"
            leftSection={<Plus size={16} />}
            radius="md"
            fz="sm"
            style={{
              backgroundColor: "var(--accent)",
              color: "var(--text-main)",
              fontFamily: "var(--font-display)",
              fontWeight: 700,
              textTransform: "uppercase",
              border: "none",
            }}
            onClick={setCreator}
          >
            {lang.createListingBtn}
          </Button>
        </Group>
      )}
    </Group>
  );
};
