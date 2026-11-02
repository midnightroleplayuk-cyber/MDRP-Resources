import { useState, useMemo, useEffect } from "react";
import { Box, Transition } from "@mantine/core";
import { ApiTypes } from "../../../../API/products";
import { Loading } from "../../../Loading";
import {
  fetchNui,
  isEnvBrowser,
  useNuiEvent,
} from "../../../../hooks/useNuiEvents";
import { CounterItems } from "../api";
import { useAtomValue } from "jotai";
import { Lang } from "../../../../reducers/atoms";
import { ApiCoupon, DiscountType } from "../../Discounts/api";
import { RegisterHeader } from "./RegisterHeader";
import { ProductsView } from "./ProductsView";
import { CartView } from "./CartView";
import classes from "./style.module.css";

interface Product {
  name: string;
  label: string;
  price: number;
  stock: number;
  type: string;
}

export interface CartItem extends Product {
  amount: number;
}

interface ItemUpdated {
  name: string;
  stock: number;
}

export const CounterRegister = () => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.counter_register || {};
  const [loaded, setLoaded] = useState(false);
  const [loading, setLoading] = useState(false);
  const [view, setView] = useState<"products" | "cart">("products");
  const [products, setProducts] = useState<Product[]>([]);
  const [cart, setCart] = useState<CartItem[]>([]);
  const [search, setSearch] = useState("");
  const [filterType, setFilterType] = useState<string | null>(null);
  const [quantities, setQuantities] = useState<Record<string, number>>({});
  const [itemTypes, setItemTypes] = useState(ApiTypes);
  const [business, setBusiness] = useState(isEnvBrowser() ? "" : "");
  const [coupon, setCoupon] = useState<DiscountType | null>(null);
  const [code, setCode] = useState<string | null>(null);
  const [tempCode, setTempCode] = useState("");
  const [inventory, setInventory] = useState("");

  useNuiEvent("setCounter", (business: string) => {
    setBusiness(business);
  });

  useNuiEvent(
    "refreshCounter",
    (data: { job: string; items: ItemUpdated[] }) => {
      if (data.job !== business) return;

      const stockMap: Record<string, number> = {};
      for (const i of data.items) stockMap[i.name] = i.stock;

      setProducts((prev) =>
        prev.map((p) =>
          stockMap[p.name] !== undefined
            ? { ...p, stock: stockMap[p.name] }
            : p,
        ),
      );

      setCart((prev) =>
        prev.reduce<CartItem[]>((acc, item) => {
          const newStock = stockMap[item.name];
          if (newStock === undefined) {
            acc.push(item);
          } else if (newStock <= 0) {
          } else if (item.amount > newStock) {
            acc.push({ ...item, amount: newStock });
          } else {
            acc.push(item);
          }
          return acc;
        }, []),
      );
    },
  );

  const handleCode = async (inputCode: string) => {
    if (isEnvBrowser()) {
      setCode(inputCode);
      setCoupon(ApiCoupon);
      return;
    }
    const resp = await fetchNui("av_business", "getCodeData", {
      code: inputCode,
      business,
    });
    if (resp) {
      setCode(inputCode);
      setCoupon(resp);
    }
  };

  const filteredProducts = useMemo(
    () =>
      products.filter((p) => {
        const matchSearch = p.label
          .toLowerCase()
          .includes(search.toLowerCase());
        const matchType = filterType ? p.type === filterType : true;
        return matchSearch && matchType;
      }),
    [products, search, filterType],
  );

  const cartTotal = useMemo(
    () => cart.reduce((total, item) => total + item.price * item.amount, 0),
    [cart],
  );

  const cartItemsCount = useMemo(
    () => cart.reduce((count, item) => count + item.amount, 0),
    [cart],
  );

  const getAmount = (name: string) => quantities[name] || 1;

  const handleAmountChange = (name: string, val: number | string) => {
    const num = typeof val === "number" ? val : parseInt(val, 10) || 1;
    setQuantities((prev) => ({ ...prev, [name]: num }));
  };

  const addToCart = (product: Product, amount: number) => {
    setCart((prev) => {
      const existing = prev.find((i) => i.name === product.name);
      if (existing) {
        const newamount = Math.min(existing.amount + amount, product.stock);
        return prev.map((i) =>
          i.name === product.name ? { ...i, amount: newamount } : i,
        );
      }
      return [...prev, { ...product, amount: Math.min(amount, product.stock) }];
    });
    setQuantities((prev) => ({ ...prev, [product.name]: 1 }));
  };

  const removeFromCart = (productName: string) => {
    setCart((prev) => prev.filter((i) => i.name !== productName));
  };

  const handleCheckout = async () => {
    setLoading(true);
    const resp = await fetchNui("av_business", "counterCheckout", {
      business,
      cart,
      code,
    });
    setLoading(false);
    if (!resp) return;
    setCart([]);
    setCoupon(null);
    setCode(null);
    setView("products");
  };

  const fetchData = async () => {
    const resp = await fetchNui("av_business", "getCounterProducts", business);
    if (resp) {
      setProducts(resp.products);
      setItemTypes(resp.types);
      setInventory(resp.inventory);
    } else {
      if (isEnvBrowser()) setProducts(CounterItems);
    }
    setLoaded(true);
  };

  useEffect(() => {
    if (business === "") return;
    fetchData();
  }, [business]);

  const onKeyDown = (e: KeyboardEvent) => {
    if (e.code === "Escape") {
      setLoaded(false);
      setBusiness("");
      setCart([]);
      setProducts([]);
      setCoupon(null);
      setCode(null);
      setTimeout(() => {
        fetchNui("av_business", "closeCounter");
      }, 250);
    }
  };
  useEffect(() => {
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, []);

  return (
    <Transition
      mounted={loaded}
      transition="fade-down"
      duration={500}
      exitDuration={500}
      timingFunction="ease"
    >
      {(styles) => (
        <Box className={classes.wrapper} style={styles}>
          <Box className={classes.box}>
            <RegisterHeader
              lang={lang}
              view={view}
              cartItemsCount={cartItemsCount}
              cartEmpty={cart.length === 0}
              onViewChange={setView}
            />
            {loading ? (
              <Loading />
            ) : (
              <>
                {view === "products" && (
                  <ProductsView
                    lang={lang}
                    inventory={inventory}
                    products={filteredProducts}
                    itemTypes={itemTypes}
                    filterType={filterType}
                    search={search}
                    onSearchChange={setSearch}
                    onFilterChange={setFilterType}
                    onAmountChange={handleAmountChange}
                    onAddToCart={addToCart}
                    getAmount={getAmount}
                  />
                )}
                {view === "cart" && (
                  <CartView
                    lang={lang}
                    daLang={daLang}
                    inventory={inventory}
                    cart={cart}
                    cartTotal={cartTotal}
                    cartItemsCount={cartItemsCount}
                    code={code}
                    coupon={coupon}
                    tempCode={tempCode}
                    onTempCodeChange={setTempCode}
                    onRemoveFromCart={removeFromCart}
                    onApplyCode={handleCode}
                    onClearCode={() => setCode(null)}
                    onCheckout={handleCheckout}
                  />
                )}
              </>
            )}
          </Box>
        </Box>
      )}
    </Transition>
  );
};
