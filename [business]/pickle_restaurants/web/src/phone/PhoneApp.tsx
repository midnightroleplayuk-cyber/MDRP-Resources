import { useEffect } from "react";
import { Home as HomeIcon, ClipboardList, Award, ChefHat, User } from "lucide-react";
import { cn } from "../lib/utils";
import { _L } from "../lib/locale";
import { PhoneProvider, usePhone, money, Tab } from "./store";
import { Spinner, Toast, AskModal } from "./ui";
import { fetchNui, useNuiEvent } from "../lib/nui";

import Home from "./screens/Home";
import { Restaurant, Checkout } from "./screens/Restaurant";
import { Orders, OrderTrack } from "./screens/Orders";
import { Rewards, Reserve, Leaderboard, Profile } from "./screens/Rewards";
import { Kitchen, Manage, Staff } from "./screens/Work";

function Router() {
  const { stack } = usePhone();
  const top = stack[stack.length - 1];
  switch (top.name) {
    case "home":
      return <Home />;
    case "restaurant":
      return <Restaurant params={top.params} />;
    case "checkout":
      return <Checkout params={top.params} />;
    case "orders":
      return <Orders />;
    case "order":
      return <OrderTrack params={top.params} />;
    case "rewards":
      return <Rewards />;
    case "reserve":
      return <Reserve params={top.params} />;
    case "leaderboard":
      return <Leaderboard params={top.params} />;
    case "profile":
      return <Profile />;
    case "kitchen":
      return <Kitchen params={top.params} />;
    case "manage":
      return <Manage params={top.params} />;
    case "staff":
      return <Staff params={top.params} />;
    default:
      return <Home />;
  }
}

function CartBar() {
  const { cart, cartCount, cartSubtotal, currency, go, stack } = usePhone();
  const top = stack[stack.length - 1].name;
  // Only show the floating cart on the storefront/menu screen.
  if (!cart || cartCount === 0 || (top !== "restaurant" && top !== "home")) return null;
  return (
    <div className="pf-cartbar">
      <button
        onClick={() => go("checkout", { rid: cart.rid })}
        className="pf-elev-lg flex w-full items-center justify-between gap-2 rounded-2xl bg-brand px-4 py-3.5 text-brand-ink transition-transform active:scale-[0.98]"
      >
        <span className="flex items-center gap-2.5 font-bold">
          <span className="grid h-6 min-w-6 place-items-center rounded-full bg-brand-ink/20 px-1.5 font-mono text-sm tabular-nums">
            {cartCount}
          </span>
          {_L("phone.cart.view")}
        </span>
        <span className="font-mono font-bold tabular-nums">{money(currency, cartSubtotal)}</span>
      </button>
    </div>
  );
}

function TabBar() {
  const { tab, setTab, home } = usePhone();
  const employed = (home?.employment?.length || 0) > 0;
  const tabs: { id: Tab; label: string; icon: any }[] = [
    { id: "home", label: _L("phone.tab.order"), icon: HomeIcon },
    { id: "orders", label: _L("phone.tab.orders"), icon: ClipboardList },
    { id: "rewards", label: _L("phone.tab.rewards"), icon: Award },
    ...(employed ? [{ id: "work" as Tab, label: _L("phone.tab.work"), icon: ChefHat }] : []),
    { id: "profile", label: _L("phone.tab.profile"), icon: User },
  ];
  return (
    <div className="pf-tabs">
      {tabs.map((t) => {
        const Icon = t.icon;
        const on = tab === t.id;
        return (
          <button key={t.id} className={cn("pf-tab", on && "on")} onClick={() => setTab(t.id)}>
            <span className="pf-tab-ico">
              <Icon className="h-[1.2rem] w-[1.2rem]" strokeWidth={on ? 2.6 : 2} />
            </span>
            {t.label}
          </button>
        );
      })}
    </div>
  );
}

// Live server → app pushes (order feed, promos, delivery). Individual screens also
// subscribe; this top-level one just surfaces promo toasts + refreshes badges.
function LiveBridge() {
  const { toast, refreshHome } = usePhone();
  useNuiEvent("promo", (d) => {
    if (d?.title) toast(`${d.title}`);
  });
  useNuiEvent("backup", () => toast(_L("phone.toast.backup"), "err"));
  useEffect(() => {
    const t = setInterval(refreshHome, 30000);
    return () => clearInterval(t);
  }, [refreshHome]);
  return null;
}

function Shell() {
  const { ready } = usePhone();
  return (
    <div className="pf-root font-sans">
      <Toast />
      <LiveBridge />
      {!ready ? (
        // Splash. The theme seed is already planted at module load (store.tsx
        // caches the last one), so this paints in the phone's colors instead of
        // flashing the static index.css defaults until phone:home lands.
        <>
          <div className="pf-statusbar" />
          <div className="grid flex-1 place-items-center">
            <div className="flex flex-col items-center gap-3">
              {/* The real app icon, not a stand-in glyph — the same file the phone
                  shows on its home screen, so launching the app lands on something
                  recognisably continuous. Relative path: `nui/phone-icon.png` sits
                  beside `nui/phone.html` (Vite copies web/public verbatim), and the
                  build's base is "./", so this resolves in-game and in dev alike. */}
              <img src="phone-icon.png" alt="" className="pf-elev-lg h-16 w-16 rounded-2xl" />
              <div className="font-display text-lg font-extrabold">{_L("phone.app.name")}</div>
              <Spinner label={_L("phone.loading")} />
            </div>
          </div>
        </>
      ) : (
        <>
          <div className="pf-statusbar" />
          {/* ONE scroll region owns the content AND the cart bar: the bar is the
              scroller's last child (sticky bottom), so it hovers over the list
              while scrolling and becomes the final row at the end of the list
              instead of covering it — see .pf-cartbar. */}
          <div className="pf-scroll">
            <Router />
            <CartBar />
          </div>
          <TabBar />
          {/* Portal host for every bottom sheet — see `Sheet` in ui.tsx. Lives here,
              a direct child of .pf-root, so sheets are positioned against the phone
              viewport and never against a scrolled screen's transformed box. */}
          <div id="pf-overlay" className="pf-overlay" />
          <AskModal />
        </>
      )}
    </div>
  );
}

export default function PhoneApp() {
  // Best-effort: tell lb-phone we're a host-aware page (skips the dev handshake).
  useEffect(() => {
    (window as any).__lbHostPresent = true;
    // Signal readiness so the driver-blip cleanup can be requested on unmount.
    return () => {
      fetchNui("phone:endDeliveryBlip", {}).catch(() => {});
    };
  }, []);
  return (
    <PhoneProvider>
      <Shell />
    </PhoneProvider>
  );
}
