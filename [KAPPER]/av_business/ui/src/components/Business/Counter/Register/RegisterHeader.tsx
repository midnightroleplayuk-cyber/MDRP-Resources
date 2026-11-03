import { Group, Text, Button } from "@mantine/core";
import { IconShoppingCart, IconArrowLeft } from "@tabler/icons-react";
import global from "../../../../global.module.css";

interface Properties {
  lang: any;
  view: "products" | "cart";
  cartItemsCount: number;
  cartEmpty: boolean;
  onViewChange: (view: "products" | "cart") => void;
}

export const RegisterHeader = ({
  lang,
  view,
  cartItemsCount,
  cartEmpty,
  onViewChange,
}: Properties) => (
  <Group
    justify="space-between"
    align="center"
    mb="sm"
    style={{ paddingBottom: "1rem", borderBottom: "1px solid var(--border)" }}
  >
    <Group align="center">
      <Text fz="xl" tt="uppercase" c="white" fw={700}>
        {lang.header || "Self Service"}
      </Text>
    </Group>
    {view === "products" ? (
      <Button
        leftSection={<IconShoppingCart size={16} />}
        className={global.button}
        variant="filled"
        onClick={() => onViewChange("cart")}
        disabled={cartEmpty}
        size="sm"
        fz="xs"
        fw={300}
        h={30}
      >
        {cartItemsCount > 0
          ? `${cartItemsCount} ${lang.items || "Items"}`
          : lang.empty || "Empty"}
      </Button>
    ) : (
      <Button
        className={global.button}
        leftSection={<IconArrowLeft size={16} />}
        color="var(--accent)"
        variant="filled"
        onClick={() => onViewChange("products")}
        size="sm"
        fz="xs"
        fw={300}
        h={30}
      >
        {lang.back_to_products || "Back to products"}
      </Button>
    )}
  </Group>
);
