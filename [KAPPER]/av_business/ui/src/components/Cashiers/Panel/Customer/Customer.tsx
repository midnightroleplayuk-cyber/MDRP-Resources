import { useEffect, useState } from "react";
import { Box, Group, Text } from "@mantine/core";
import { Loading } from "../../../Loading";
import { fetchNui, isEnvBrowser } from "../../../../hooks/useNuiEvents";
import { ApiCustomer, CartItem } from "./api";
import { IngredientsType, SelectType } from "../../../../types/types";
import { ApiIngredients } from "../../../../API/products";
import { DiscountType, PromoType } from "../../../Business/Discounts/api";
import { useAtomValue } from "jotai";
import { Lang } from "../../../../reducers/atoms";
import { Content } from "./Content";
import { Rating } from "./Rating";

export interface LoyaltyVerifyResult {
  serial: string;
  promo_name: string;
  discount: number;
  discount_type: "percentage" | "amount";
  visits: number;
  required_visits: number;
  redeemed: number;
}

type View = "cart" | "rating";

export const Customer = ({ job, id }: { job: string; id: string }) => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.cashier;
  const [loaded, setLoaded] = useState(false);
  const [view, setView] = useState<View>("cart");
  const [items, setItems] = useState<CartItem[]>([]);
  const [coupon, setCoupon] = useState<DiscountType | undefined>();
  const [code, setCode] = useState<string | null>(null);
  const [inventory, setInventory] = useState("");
  const [customerName, setCustomerName] = useState("");
  const [accounts, setAccounts] = useState<SelectType[]>([]);
  const [account, setAccount] = useState("bank");
  const [ingredients, setIngredients] = useState<IngredientsType[]>([]);
  const [total, setTotal] = useState(0);
  const [itemsTotal, setItemsTotal] = useState(0);
  const [activePromo, setActivePromo] = useState<PromoType | null>(null);
  const [loyaltySerial, setLoyaltySerial] = useState<string | null>(null);
  const [loyaltyInfo, setLoyaltyInfo] = useState<LoyaltyVerifyResult | null>(
    null,
  );

  const getIngredientLabel = (ingredient: string) => {
    const match = ingredients.find((item) => item.value === ingredient);
    return match ? match.label : ingredient;
  };

  const handleCode = async (code: string) => {
    const resp = await fetchNui("av_business", "getCodeData", { code, job });
    if (resp) {
      setCode(code);
      setCoupon(resp);
    }
  };

  const verifyLoyalty = async (serial: string): Promise<boolean> => {
    const resp: LoyaltyVerifyResult | false = await fetchNui(
      "av_business",
      "verifyLoyaltyCard",
      { serial, job },
    );
    if (!resp) return false;
    setLoyaltySerial(serial);
    setLoyaltyInfo(resp);
    return true;
  };

  const clearLoyalty = () => {
    setLoyaltySerial(null);
    setLoyaltyInfo(null);
  };

  const handlePay = async () => {
    setLoaded(false);
    const paid = await fetchNui("av_business", "payOrder", {
      job,
      id,
      customerName,
      account,
      code,
      loyalty_serial: loyaltySerial,
    });
    if (paid) {
      setItems([]);
      setCoupon(undefined);
      setCode("");
      clearLoyalty();
      const canRate = await fetchNui("av_business", "canRate", { job });
      if (canRate) {
        setLoaded(true);
        setView("rating");
        return;
      }
    }
    setTimeout(() => {
      setLoaded(true);
    }, 100);
  };

  const handleRatingDone = () => {
    fetchNui("av_business", "closeCashier");
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getCashier", { job, id });
      if (resp) {
        setItems(resp.items);
        setAccounts(resp.accounts);
        setIngredients(resp.ingredients);
        setCoupon(resp.discount);
        setCode(resp.discount?.code ?? null);
        setInventory(resp.inventory);
        setCustomerName(resp.customerName);
      } else {
        if (isEnvBrowser()) {
          setIngredients(ApiIngredients);
          setItems(ApiCustomer.cart);
          setCoupon(ApiCustomer.discount);
          setCode(ApiCustomer?.discount?.code ?? null);
          setAccounts([
            { value: "cash", label: "Cash" },
            { value: "bank", label: "Bank" },
          ]);
        }
      }
      const promoResp = await fetchNui("av_business", "getActivePromo", {
        job,
      });
      if (promoResp) setActivePromo(promoResp);
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, [job, id]);

  useEffect(() => {
    const { totalPrice, totalItems } = items.reduce(
      (acc, item) => {
        const price = item.price ?? 1;
        const amount = item.amount ?? 1;
        acc.totalPrice += price * amount;
        acc.totalItems += amount;
        return acc;
      },
      { totalPrice: 0, totalItems: 0 },
    );
    setTotal(totalPrice);
    setItemsTotal(totalItems);
  }, [items]);

  if (!loaded) return <Loading />;
  return (
    <Box style={{ display: "flex", flexDirection: "column", height: "100%" }}>
      <Group p="md" bg="var(--bg-sidebar)" style={{ flexShrink: 0 }}>
        <Group gap="xs">
          <Text fz="md" c="white" fw={500}>
            {view === "rating" ? lang.rate_header : lang.header}
          </Text>
          {view === "cart" && (
            <Text fz="xs">{`#${id.replace(/\D/g, "")}`}</Text>
          )}
        </Group>
      </Group>
      <Box style={{ flex: 1, overflow: "hidden", padding: "14px" }}>
        {view === "rating" ? (
          <Rating job={job} daLang={daLang} onDone={handleRatingDone} />
        ) : (
          <Content
            code={code}
            coupon={coupon}
            daLang={daLang}
            getIngredientLabel={getIngredientLabel}
            handleCode={handleCode}
            handlePay={handlePay}
            inventory={inventory}
            items={items}
            itemsTotal={itemsTotal}
            setCode={() => {
              setCode(null);
              setCoupon(undefined);
            }}
            total={total}
            accounts={accounts}
            account={account}
            setAccount={setAccount}
            customerName={customerName}
            setCustomerName={setCustomerName}
            activePromo={activePromo}
            loyaltySerial={loyaltySerial}
            loyaltyInfo={loyaltyInfo}
            verifyLoyalty={verifyLoyalty}
            clearLoyalty={clearLoyalty}
          />
        )}
      </Box>
    </Box>
  );
};
