import {
  Card,
  Group,
  Text,
  Stack,
  Badge,
  Box,
  Tooltip,
  Divider,
  ActionIcon,
} from "@mantine/core";
import { ItemImage } from "../../ItemImage/ItemImage";
import { IconPencil, IconTrash } from "@tabler/icons-react";
import { IngredientsType, JobItem } from "../../../types/types";
import global from "../../../global.module.css";

interface Properties {
  lang: any;
  product: JobItem;
  inventory: string;
  handleEdit: (product: JobItem) => void;
  handleDelete: (name: string) => void;
  ingredients: IngredientsType[];
}

export const ProductCard = ({
  ingredients,
  lang,
  product,
  inventory,
  handleDelete,
  handleEdit,
}: Properties) => {
  const getIngredientLabel = (input: string): string => {
    const ingredient = ingredients.find((ing) => ing.value === input);
    return ingredient ? ingredient.label : input;
  };

  return (
    <Card
      padding={0}
      radius="md"
      h={300}
      style={{
        backgroundColor: "var(--bg-card)",
        border: "1px solid rgba(255,255,255,0.07)",
        display: "flex",
        flexDirection: "column",
        overflow: "hidden",
        transition: "border-color 0.2s",
      }}
      onMouseEnter={(e) => {
        (e.currentTarget as HTMLDivElement).style.borderColor =
          "rgba(255,255,255,0.13)";
      }}
      onMouseLeave={(e) => {
        (e.currentTarget as HTMLDivElement).style.borderColor =
          "rgba(255,255,255,0.07)";
      }}
    >
      <Box
        p="sm"
        style={{
          background:
            "linear-gradient(135deg, rgba(124,96,200,0.08) 0%, transparent 60%)",
          borderBottom: "1px solid rgba(255,255,255,0.06)",
        }}
      >
        <Group justify="space-between" align="flex-start" wrap="nowrap">
          <Group gap={10} wrap="nowrap" style={{ minWidth: 0 }}>
            <Box
              style={{
                width: 46,
                height: 46,
                flexShrink: 0,
                backgroundColor: "var(--bg-input)",
                borderRadius: 8,
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                border: "1px solid rgba(255,255,255,0.07)",
              }}
            >
              <ItemImage
                inventory={inventory}
                name={product?.name}
                image={product.image}
                w={34}
                h={34}
                style={{ objectFit: "contain" }}
              />
            </Box>
            <Stack gap={1} style={{ minWidth: 0 }}>
              <Tooltip
                label={product.label}
                color="var(--tooltip)"
                fz="xs"
                withArrow
              >
                <Text
                  fw={700}
                  size="md"
                  truncate
                  maw={130}
                  style={{
                    color: "var(--text-main)",
                    fontFamily: "var(--font-display)",
                    textTransform: "uppercase",
                    letterSpacing: "0.5px",
                    lineHeight: 1.1,
                  }}
                >
                  {product.label}
                </Text>
              </Tooltip>
              <Text
                size="10px"
                fw={700}
                style={{
                  color: "var(--cyan)",
                  textTransform: "uppercase",
                  letterSpacing: "1px",
                  opacity: 0.85,
                }}
              >
                {product.type}
              </Text>
            </Stack>
          </Group>
          <Text
            fw={800}
            size="lg"
            style={{
              color: "var(--success)",
              fontFamily: "var(--font-display)",
              letterSpacing: "-0.5px",
              flexShrink: 0,
            }}
          >
            ${product.price}
          </Text>
        </Group>
      </Box>

      <Stack gap={0} p="sm" style={{ flex: 1, minHeight: 0 }}>
        {product.description && (
          <Text
            size="xs"
            lineClamp={2}
            mb="xs"
            style={{ color: "var(--text-dim)", lineHeight: 1.5 }}
          >
            {product.description}
          </Text>
        )}

        <Box
          p="xs"
          style={{
            flex: 1,
            backgroundColor: "var(--bg-input)",
            borderRadius: 6,
            border: "1px solid rgba(255,255,255,0.05)",
            overflow: "hidden",
          }}
        >
          <Text
            size="10px"
            fw={700}
            mb={6}
            style={{
              color: "var(--accent)",
              textTransform: "uppercase",
              letterSpacing: "1.5px",
            }}
          >
            {lang.ingredients}
          </Text>
          <Group gap={4}>
            {product.ingredients.slice(0, 6).map((ing, index) => (
              <Badge
                key={index}
                variant="light"
                size="xs"
                styles={{
                  root: {
                    borderColor: "rgba(255,255,255,0.1)",
                    color: "var(--text-dim)",
                    textTransform: "none",
                    fontWeight: 500,
                    backgroundColor: "rgba(255,255,255,0.04)",
                    fontFamily: "var(--font-display)",
                  },
                }}
              >
                {getIngredientLabel(ing)}
              </Badge>
            ))}
            {product.ingredients.length > 6 && (
              <Text
                size="10px"
                fw={700}
                style={{ color: "var(--accent)", opacity: 0.8 }}
              >
                +{product.ingredients.length - 6}
              </Text>
            )}
          </Group>
        </Box>
      </Stack>

      <Divider color="rgba(255,255,255,0.05)" />

      <Group justify="flex-end" gap={6} px="sm" py={8}>
        <Tooltip label={lang.edit} fz="xs" color="var(--tooltip)" withArrow>
          <ActionIcon
            size="sm"
            variant="transparent"
            className={global.actionGlass}
            onClick={() => handleEdit(product)}
          >
            <IconPencil size={13} stroke={1.8} color="var(--accent)" />
          </ActionIcon>
        </Tooltip>
        <Tooltip label={lang.delete} fz="xs" color="var(--tooltip)" withArrow>
          <ActionIcon
            size="sm"
            variant="transparent"
            className={global.actionGlassRed}
            onDoubleClick={() => handleDelete(product.name)}
          >
            <IconTrash size={13} stroke={1.8} color="#dc3545" />
          </ActionIcon>
        </Tooltip>
      </Group>
    </Card>
  );
};
