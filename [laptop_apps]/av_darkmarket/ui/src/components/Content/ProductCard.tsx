import {
  Card,
  Text,
  Group,
  Tooltip,
  Image,
  Button,
  ActionIcon,
  NumberInput,
} from "@mantine/core";
import { ProductType } from "../../types/types";
import { Box, Minus, Plus } from "lucide-react";
import classes from "./style.module.css";
import global from "../../global.module.css";
import { findItemInCart } from "./utils";
import { useRecoilValue } from "recoil";
import { CartItems, Lang } from "../../reducers/atoms";
import { Modifier } from "../Modifier/Modifier";

interface Properties {
  product: ProductType;
  inventory: string;
  handleControl: (item: ProductType, type: string, amount: number) => void;
}

export const ProductCard = ({
  product,
  inventory,
  handleControl,
}: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const cart = useRecoilValue(CartItems);
  const exists = findItemInCart(product.identifier, cart);
  return (
    <Card className={classes.card} maw={220}>
      <Card.Section className={classes.header}>
        <Tooltip
          label={lang.product_stock}
          position="top-start"
          ml="md"
          offset={-5}
          withArrow
          color="var(--dark-border)"
          fz="xs"
        >
          <Group gap={5} w="fit-content">
            <Box size={12} color="var(--primary-200)" />
            <Text fz="xs" c="var(--primary-100)" fw={500}>
              {product.stock}
            </Text>
          </Group>
        </Tooltip>
      </Card.Section>
      <Card.Section className={classes.image}>
        <Image
          src={
            product.image
              ? product.image
              : `https://cfx-nui-${inventory}${product.name}.${
                  product.extension ? product.extension : "png"
                }`
          }
          fallbackSrc="./no_image.png"
          h={75}
          w={75}
          ml="auto"
          mr="auto"
          fit="contain"
        />
      </Card.Section>
      <Card.Section className={classes.description}>
        <Text fz="md" fw={500} c="var(--light)" truncate ta="center" maw={170}>
          {product.label}
        </Text>
        <Text fz="xs" fw={450} c="var(--text-subdued)" ta="center">
          {`${product.price.toLocaleString("en-US")} ${product.accountLabel}`}
        </Text>
      </Card.Section>
      <Card.Section p="sm">
        {exists ? (
          <>
            <Modifier
              product={product}
              handleControl={handleControl}
              width={"70%"}
            />
          </>
        ) : (
          <Button
            className={global.mainButton}
            size="xs"
            ml="auto"
            mr="auto"
            fullWidth
            disabled={product.stock == 0}
            onClick={() => {
              handleControl(product, "set", 1);
            }}
          >
            {lang.add_cart}
          </Button>
        )}
      </Card.Section>
    </Card>
  );
};
