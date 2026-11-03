import { useState, useEffect } from "react";
import { Grid, ScrollArea } from "@mantine/core";
import { Loading } from "../Loading";
import { fetchNui, isEnvBrowser, useNuiEvent } from "../../hooks/useNuiEvents";
import { ApiProducts } from "../../Api/Products";
import { CartType, ProductType } from "../../types/types";
import { ProductCard } from "./ProductCard";
import { useRecoilState, useRecoilValue } from "recoil";
import { CartItems, SubheaderAtom } from "../../reducers/atoms";
import { sortProducts } from "./utils";
import global from "../../global.module.css";

interface Properties {
  category: string;
  inventory: string;
}

interface UpdateList {
  identifier: string;
  stock: number;
}

const Content = ({ category, inventory }: Properties) => {
  const [loaded, setLoaded] = useState(false);
  const atom = useRecoilValue(SubheaderAtom);
  const [cart, setCart] = useRecoilState(CartItems);
  const [allProducts, setAllProducts] = useState<ProductType[]>([]);
  const [filtered, setFiltered] = useState<ProductType[]>([]);

  useNuiEvent("refresh", () => {
    fetchData();
  });

  useNuiEvent("updateStock", (updated: UpdateList[]) => {
    const stockMap = Object.fromEntries(
      updated.map((item) => [item.identifier, item.stock]),
    );
    const newProducts = allProducts.map((product) => {
      if (stockMap[product.identifier] !== undefined) {
        return { ...product, stock: stockMap[product.identifier] };
      }
      return product;
    });
    const newCart = cart
      .map((item) => {
        if (stockMap[item.identifier] !== undefined) {
          const newStock = stockMap[item.identifier];
          return {
            ...item,
            stock: newStock,
            amount: Math.min(item.amount, newStock),
          };
        }
        return item;
      })
      .filter((item) => item.stock > 0);
    setAllProducts(newProducts);
    setCart(newCart);
  });
  const handleControl = (item: ProductType, type: string, amount: number) => {
    const cleanAmount = Number(amount);
    if (isNaN(cleanAmount)) return;
    setCart((prevCart) => {
      const existingItem = prevCart.find(
        (i) => i.identifier === item.identifier,
      );
      if (existingItem) {
        if (type === "set" && cleanAmount <= 0) {
          return prevCart.filter((i) => i.identifier !== item.identifier);
        }
        if (type === "remove" && existingItem.amount - cleanAmount <= 0) {
          return prevCart.filter((i) => i.identifier !== item.identifier);
        }
        return prevCart.map((cartItem) => {
          if (cartItem.identifier !== item.identifier) return cartItem;
          let newAmount = cartItem.amount;
          if (type === "add") {
            newAmount = Math.min(cartItem.stock, cartItem.amount + cleanAmount);
          } else if (type === "remove") {
            newAmount = Math.max(0, cartItem.amount - cleanAmount);
          } else if (type === "set") {
            newAmount = Math.min(cartItem.stock, cleanAmount);
          }
          return { ...cartItem, amount: newAmount };
        });
      } else {
        if (cleanAmount <= 0) return prevCart;
        const initialAmount = Math.min(item.stock, cleanAmount);
        const newItem: CartType = {
          ...item,
          category,
          amount: initialAmount,
        };
        return [...prevCart, newItem];
      }
    });
  };

  useEffect(() => {
    const { search, account } = atom;
    let result = [...allProducts];
    if (search && search !== "") {
      const query = search.toLowerCase();
      result = result.filter(
        (product) =>
          product.name.toLowerCase().includes(query) ||
          product.label.toLowerCase().includes(query),
      );
    }
    if (account) {
      const query = account.toLowerCase();
      result = result.filter((product) =>
        product.accountLabel.toLowerCase().includes(query),
      );
    }
    const sorted = sortProducts(result);
    setFiltered(sorted);
  }, [atom, allProducts]);

  const fetchData = async () => {
    setLoaded(false);
    const resp = await fetchNui("av_darkmarket", "getProducts", category);
    if (resp) {
      const sorted = sortProducts(resp);
      setAllProducts(sorted);
      setFiltered(sorted);
    } else {
      if (isEnvBrowser()) {
        const sorted = sortProducts(ApiProducts);
        setAllProducts(sorted);
        setFiltered(sorted);
      }
    }
    setTimeout(() => {
      setLoaded(true);
    }, 100);
  };

  useEffect(() => {
    fetchData();
  }, [category]);

  if (!loaded) return <Loading />;
  return (
    <>
      <ScrollArea
        className={global.scroll}
        type="hover"
        scrollbars="y"
        scrollbarSize={5}
        offsetScrollbars
      >
        <Grid gutter="sm">
          {filtered.map((product) => (
            <Grid.Col span={1} miw={220}>
              <ProductCard
                product={product}
                inventory={inventory}
                handleControl={handleControl}
              />
            </Grid.Col>
          ))}
        </Grid>
      </ScrollArea>
    </>
  );
};

export default Content;
