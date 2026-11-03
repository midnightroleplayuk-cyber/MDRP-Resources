import { Button, Group, Text } from "@mantine/core";
import { useRecoilValue } from "recoil";
import { CartItems, Lang } from "../../reducers/atoms";
import classes from "./style.module.css";
import { ShoppingCart } from "lucide-react";
import { isWide } from "../../hooks/wide";

interface Properties {
  showCart: () => void;
}

export const CartButton = ({ showCart }: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const cart = useRecoilValue(CartItems);
  const wide = isWide();
  const totalItems = cart.reduce((acc, item) => acc + item.amount, 0);

  return (
    <Button
      className={classes.button}
      ml="auto"
      variant="transparent"
      onClick={showCart}
    >
      <ShoppingCart size={13} color="var(--primary-200)" />
      {wide && (
        <Text fz="xs" c="gray.3" ml="xs">
          {`${totalItems} ${lang.items}`}
        </Text>
      )}
    </Button>
  );
};
