import { useState, useEffect, Suspense, lazy } from "react";
import { Box, Stack } from "@mantine/core";
import { fetchNui, isEnvBrowser, useNuiEvent } from "../hooks/useNuiEvents";
import { AccountsType, SelectType } from "../types/types";
import { Loading } from "./Loading";
import { useRecoilState, useRecoilValue, useSetRecoilState } from "recoil";
import { Inventory, MoneyAccounts, RefreshTime } from "../reducers/atoms";
import { Header } from "./Header/Header";
import { ApiCategories } from "../Api/Categories";
import { ApiAccounts } from "../Api/Accounts";
import { Subheader } from "./Subheader/Subheader";
import { Cart } from "./Cart/Cart";
import classes from "./style.module.css";

const Content = lazy(() => import("./Content/Content"));

export const sortCategories = (categories: SelectType[]): SelectType[] => {
  return [...categories].sort((a, b) => a.label.localeCompare(b.label));
};

export const MainApp = () => {
  const setInventory = useSetRecoilState(Inventory);
  const setTimer = useSetRecoilState(RefreshTime);
  const inventory = useRecoilValue(Inventory);
  const [tab, setTab] = useState("");
  const [loaded, setLoaded] = useState(isEnvBrowser());
  const [categories, setCategories] = useState<SelectType[]>([]);
  const [accounts, setAccounts] = useRecoilState(MoneyAccounts);
  const [showCart, setShowCart] = useState(false);

  useNuiEvent("updateAccounts", (data: AccountsType[]) => {
    setAccounts(data);
  });

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_darkmarket", "getData");
      if (resp) {
        const sorted = sortCategories(resp.categories);
        setCategories(sorted);
        setInventory(resp.inventory);
        setAccounts(resp.accounts);
        setTab(sorted ? sorted[0]?.value : "");
        setTimer(resp.timer);
      } else {
        if (isEnvBrowser()) {
          setCategories(ApiCategories);
          setAccounts(ApiAccounts);
        }
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, []);

  return (
    <>
      <Box className={classes.app}>
        {loaded ? (
          <Box className={classes.container}>
            <Header
              accounts={accounts}
              categories={categories}
              tab={tab}
              setTab={setTab}
              showCart={() => {
                setShowCart(true);
              }}
            />
            <Stack p="md">
              {showCart && (
                <Cart
                  close={() => {
                    setShowCart(false);
                  }}
                />
              )}
              <Subheader />
              <Suspense fallback={null}>
                <Content category={tab} inventory={inventory} />
              </Suspense>
            </Stack>
          </Box>
        ) : (
          <Loading />
        )}
      </Box>
    </>
  );
};
