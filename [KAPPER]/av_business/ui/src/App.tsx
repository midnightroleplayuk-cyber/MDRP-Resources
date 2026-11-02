import "./App.css";
import { lazy, useEffect, useState, Suspense } from "react";
import { MantineProvider, Box } from "@mantine/core";
import { fetchNui, isEnvBrowser } from "./hooks/useNuiEvents";
import { MainApp } from "./components/Business/MainApp";
import { BillMenu } from "./components/BillMenu/BillMenu";
import { Poster } from "./components/Poster/Poster";
import { AdminPanel } from "./components/Admin/Admin";
import { Cashiers } from "./components/Cashiers/Cashiers";
import { OrdersMenu } from "./components/Orders/OrdersMenu";
import { ApiOrder } from "./API/orders";
import { ActiveOrder } from "./components/Orders/ActiveOrder";
import { useSetAtom } from "jotai";
import { Lang } from "./reducers/atoms";
import { getLang } from "./hooks/getLang";
import { PawnshopCashier } from "./components/Business/Pawnshop/PawnshopCashier";
import { LoyaltyCardOverlay } from "./components/LoyaltyCard/LoyaltyCard";
import { CounterRegister } from "./components/Business/Counter/Register/CounterRegister";
import { setItemImageFormats } from "./components/ItemImage/ItemImage";

const Billing = lazy(() => import("./components/Business/Billing/Billing"));

const App = () => {
  const setLang = useSetAtom(Lang);
  const [loaded, setLoaded] = useState(false);
  const [appSize, setAppSize] = useState({ width: "100%", height: "100%" });
  const [showApp, setShowApp] = useState(false);
  const [showBills, setShowBills] = useState(false);
  const [showPoster, setShowPoster] = useState<null | string>(null);
  const [showAdmin, setShowAdmin] = useState(false);
  const [showOrders, setShowOrders] = useState(false);
  const [activeOrder, setActiveOrder] = useState({
    state: false,
    order: ApiOrder,
  });
  const [cashier, setCashier] = useState({
    state: false,
    isCustomer: true,
    cashierId: "av123",
    job: "uwucafe",
  });
  const [showBillMenu, setShowBillMenu] = useState(false);
  const [loyaltyCard, setLoyaltyCard] = useState<{ state: boolean; data: any }>(
    { state: true, data: null },
  );

  const fetchInit = async () => {
    try {
      const response = await getLang();
      setLang(response);
      setItemImageFormats(await fetchNui("av_business", "getImageFormats"));
      fetchNui("av_business", "loaded");
      setLoaded(true);
    } catch (error) {
      console.error("Error loading init data:", error);
    }
  };

  useEffect(() => {
    const handleNuiMessage = (event: MessageEvent) => {
      const data = event.data;
      switch (data.message) {
        case "loadApp":
          setShowApp(true);
          break;
        case "resize":
          setAppSize({
            width: `${event.data.width}px`,
            height: `${event.data.height}px`,
          });
          return;
        case "billmenu":
          setShowBills(data.state);
          break;
        case "poster":
          setShowPoster(data.url);
          break;
        case "adminMenu":
          setShowAdmin(data.state);
          break;
        case "cashiers":
          setCashier(data.cashier);
          break;
        case "orders":
          setShowOrders(data.state);
          break;
        case "activeOrder":
          setActiveOrder(data);
          break;
        case "billjob":
          setShowBillMenu(data.state);
          break;
        case "loyaltyCard":
          setLoyaltyCard({ state: data.state, data: data.data ?? null });
          break;
        default:
          break;
      }
    };

    window.addEventListener("message", handleNuiMessage);
    return () => {
      window.removeEventListener("message", handleNuiMessage);
    };
  }, []);

  useEffect(() => {
    if (isEnvBrowser()) {
      document.body.style.background = `url("https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/background2.jpg") no-repeat center center fixed`;
      document.body.style.backgroundSize = "cover";
    }

    if (!loaded) {
      fetchInit();
    }
  }, []);

  return (
    <MantineProvider defaultColorScheme="dark">
      {showApp && loaded && (
        <>
          {isEnvBrowser() ? (
            <>
              <Box
                className="main-container"
                style={{
                  backgroundColor: isEnvBrowser() ? "black" : "transparent",
                }}
              >
                <Box
                  className="laptop-frame"
                  style={{
                    backgroundImage: `url(https://raw.githubusercontent.com/Renovamen/playground-macos/main/public/img/ui/wallpaper-night.jpg)`,
                    backgroundSize: "cover",
                  }}
                >
                  <Box className="app-window">
                    <MainApp />
                  </Box>
                </Box>
              </Box>
            </>
          ) : (
            <Box
              style={{
                width: appSize.width,
                height: appSize.height,
                overflowY: "auto",
                overflowX: "hidden",
                position: "absolute",
                top: 0,
                left: 0,
                display: "flex",
                flexDirection: "column",
              }}
            >
              <MainApp />
            </Box>
          )}
        </>
      )}
      {showBills && loaded && <BillMenu />}
      {showPoster && loaded && <Poster url={showPoster} />}
      {showAdmin && loaded && <AdminPanel />}
      {cashier.state && loaded && (
        <Cashiers
          isCustomer={cashier.isCustomer}
          cashierId={cashier.cashierId}
          job={cashier.job}
        />
      )}
      {showOrders && loaded && <OrdersMenu />}
      {activeOrder.state && loaded && <ActiveOrder order={activeOrder.order} />}
      {showBillMenu && loaded && (
        <Suspense fallback={<div>...</div>}>
          <Billing />
        </Suspense>
      )}
      {loaded && <CounterRegister />}
      {loaded && <PawnshopCashier />}
      {loyaltyCard.state && loyaltyCard.data && loaded && (
        <LoyaltyCardOverlay data={loyaltyCard.data} />
      )}
    </MantineProvider>
  );
};
export default App;
