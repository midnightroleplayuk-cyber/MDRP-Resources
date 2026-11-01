import { Scroller, UnstyledButton, Text, Group } from "@mantine/core";
import { CategoryType } from "../../../../types/types";

interface Properties {
  active: string;
  setActive: (category: string) => void;
  allCategories: CategoryType[];
}

export const Categories = ({
  active,
  setActive,
  allCategories,
}: Properties) => {
  return (
    <Scroller
      p="xs"
      style={{
        borderBottom: "1px solid var(--border-light)",
        overflowX: "auto",
      }}
      styles={{
        control: {
          background: "transparent",
          border: "none",
        },
      }}
    >
      <Group gap="sm" wrap="nowrap">
        {allCategories.map((cat) => {
          const isActive = active === cat.value;
          return (
            <UnstyledButton
              key={cat.value}
              onClick={() => setActive(cat.value)}
              px="md"
              py={8}
              style={{
                borderRadius: 8,
                border: `1px solid ${isActive ? "var(--accent)" : "var(--border-light)"}`,
                backgroundColor: isActive ? "var(--accent)" : "var(--bg-card)",
                color: isActive ? "var(--text-main)" : "var(--text-secondary)",
                fontWeight: isActive ? 600 : 500,
                fontSize: 13,
                display: "flex",
                alignItems: "center",
                gap: 6,
                transition: "all 0.2s",
                flexShrink: 0,
              }}
            >
              {cat.label}
              <Text
                span
                size="xs"
                style={{
                  color: isActive
                    ? "rgba(255, 255, 255, 0.7)"
                    : "var(--text-muted)",
                  marginLeft: 4,
                }}
              >
                {cat.count}
              </Text>
            </UnstyledButton>
          );
        })}
      </Group>
    </Scroller>
  );
};
