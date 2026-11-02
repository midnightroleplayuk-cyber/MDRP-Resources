import { Box } from "@mantine/core";
import { useEffect, useState, lazy, Suspense } from "react";
import { fetchNui, isEnvBrowser, useNuiEvent } from "../../hooks/useNuiEvents";
import { Loading } from "../Loading";
import { Navbar } from "./Navbar/Navbar";
import { Header } from "./Header/Header";
import { useSetAtom } from "jotai";
import { BusinessInfo, MyPermissions } from "../../reducers/atoms";
import { ApiMyPermissions } from "../../API/permissions";
import classes from "./app.module.css";

const Overview = lazy(() => import("./Overview/Overview"));
const Employees = lazy(() => import("./Employees/Employees"));
const Bank = lazy(() => import("./Bank/Bank"));
const Products = lazy(() => import("./Products/Products"));
const Supplies = lazy(() => import("./Supplies/Supplies"));
const Applications = lazy(() => import("./Applications/Applications"));
const Billing = lazy(() => import("./Billing/Billing"));
const Settings = lazy(() => import("./Settings/Settings"));
const Poster = lazy(() => import("./Poster/Poster"));
const Deliveries = lazy(() => import("./Deliveries/Deliveries"));
const Discounts = lazy(() => import("./Discounts/Discounts"));
const Laundry = lazy(() => import("./Laundry/Laundry"));
const Pawnshop = lazy(() => import("./Pawnshop/Pawnshop"));
const Counter = lazy(() => import("./Counter/Counter"));
const Bills = lazy(() => import("./Bills/Bills"));
const Loyalty = lazy(() => import("./Loyalty/Loyalty"));

export const MainApp = () => {
  const [loaded, setLoaded] = useState(false);
  const [tab, setTab] = useState("overview");
  const setMyPermissions = useSetAtom(MyPermissions);
  const [isOpen, setIsOpen] = useState(false);
  const setBusiness = useSetAtom(BusinessInfo);
  useNuiEvent("permissions", (data) => {
    setMyPermissions(data);
  });
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "fetchApp");
      if (resp) {
        setMyPermissions(resp.myPermissions);
        setIsOpen(resp.blip);
        setBusiness(resp.business);
      } else {
        if (isEnvBrowser()) {
          setMyPermissions(ApiMyPermissions);
        }
      }
      setLoaded(true);
    };
    fetchData();
  }, []);
  return (
    <Box className={classes.wrapper}>
      {!loaded ? (
        <Loading />
      ) : (
        <>
          <Header isOpen={isOpen} setIsOpen={setIsOpen} />
          <Box className={classes.main}>
            <Navbar tab={tab} setTab={setTab} />
            <Suspense fallback={<Loading />}>
              <Box className={classes.content} p="md">
                {tab == "overview" && <Overview />}
                {tab == "employees" && <Employees />}
                {tab == "bank" && <Bank />}
                {tab == "products" && <Products />}
                {tab == "supplies" && <Supplies />}
                {tab == "applications" && <Applications />}
                {tab == "billing" && <Billing isLaptop={true} />}
                {tab == "settings" && <Settings />}
                {tab == "poster" && <Poster />}
                {tab == "deliveries" && <Deliveries />}
                {tab == "discounts" && <Discounts />}
                {tab == "laundry" && <Laundry />}
                {tab == "pawnshop" && <Pawnshop />}
                {tab == "counter" && <Counter />}
                {tab == "bills" && <Bills />}
                {tab == "loyalty" && <Loyalty />}
              </Box>
            </Suspense>
          </Box>
        </>
      )}
    </Box>
  );
};
