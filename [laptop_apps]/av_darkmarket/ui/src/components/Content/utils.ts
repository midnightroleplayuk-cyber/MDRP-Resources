import { CartType, ProductType } from "../../types/types";

export const sortProducts = (products: ProductType[]): ProductType[] => {
  return [...products].sort((a, b) => {
    const aOutOfStock = a.stock == 0;
    const bOutOfStock = b.stock == 0;

    if (aOutOfStock !== bOutOfStock) {
      return aOutOfStock ? 1 : -1;
    }

    return a.label.localeCompare(b.label);
  });
};

export const findItemInCart = (
  identifier: string,
  cart: CartType[],
): CartType | false => {
  const item = cart.find((product) => product.identifier === identifier);
  return item || false;
};
