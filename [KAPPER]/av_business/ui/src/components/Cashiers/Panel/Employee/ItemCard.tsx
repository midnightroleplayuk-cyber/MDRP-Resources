import { ItemImage } from "../../../ItemImage/ItemImage";
import {
  Card,
  Text,
  Group,
  Tooltip,
  ScrollArea,
  Badge,
  Button,
} from "@mantine/core";
import classes from "./style.module.css";
import { JobItem } from "../../../../types/types";

interface ItemType extends JobItem {
  toUse: string[];
}

interface Properties {
  daLang: any;
  inventory: string;
  product: ItemType | JobItem;
  usingIngredient: (
    ingredient: string,
    toUse: string[] | undefined,
  ) => string | boolean | undefined;
  handleIngredient: (name: string, ingredient: string, index: number) => void;
  getIngredientLabel: (ingredient: string) => string;
  handleCart: (
    product: ItemType | JobItem,
    type: string,
    index: number,
  ) => void;
  isCart: boolean;
  index: number;
}

export const ItemCard = ({
  daLang,
  inventory,
  product,
  usingIngredient,
  handleIngredient,
  getIngredientLabel,
  handleCart,
  isCart,
  index,
}: Properties) => {
  const lang = daLang.cashier;
  return (
    <Card
      className={classes.card}
      h={isCart ? 300 : 250}
      padding="md"
      style={{ display: "flex", flexDirection: "column" }}
    >
      {isCart && (
        <Card.Section p={7}>
          <Group justify="end" gap="xs">
            <Text fz="xs" c="gray.4">
              x{product.amount ?? 1}
            </Text>
          </Group>
        </Card.Section>
      )}
      <Card.Section className={classes.imageSection}>
        <ItemImage
          inventory={inventory}
          name={product?.name}
          image={product.image}
          w={60}
          mt={5}
          fit="cover"
        />
      </Card.Section>
      <Group mt="sm">
        <Tooltip label={product.label} color="dark.4" fz="xs">
          <Text fz="xs" truncate maw={100} c="white">
            {product.label}
          </Text>
        </Tooltip>
        <Text fz="xs" ml="auto" c="gray.3">{`${
          daLang.money_symbol
        }${product.price.toLocaleString("en-US")}`}</Text>
      </Group>
      <Text fz="xs" c="dimmed">
        {lang.ingredients}
      </Text>
      <ScrollArea h={75} type="hover" scrollbars="y" scrollbarSize={4}>
        <Group gap={7} mt="xs">
          {product.ingredients.map((ingredient) => (
            <Badge
              size="xs"
              fw={300}
              color={
                usingIngredient(ingredient, product.toUse)
                  ? `var(--accent)`
                  : `dark.4`
              }
              fz={8}
              onClick={() => {
                handleIngredient(product.name, ingredient, index);
              }}
            >
              {getIngredientLabel(ingredient)}
            </Badge>
          ))}
        </Group>
      </ScrollArea>
      <Group justify="center" mt="auto">
        <Button
          className={classes.button}
          size="xs"
          fw={300}
          fz="11px"
          radius={20}
          w={180}
          onClick={() => {
            handleCart(product, isCart ? "remove" : "add", index);
          }}
        >
          {isCart ? lang.remove : lang.add_cart}
        </Button>
      </Group>
    </Card>
  );
};
