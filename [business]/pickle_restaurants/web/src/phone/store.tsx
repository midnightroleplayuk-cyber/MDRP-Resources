import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useRef,
  useState,
} from "react";
import { fetchNui, useNuiEvent } from "../lib/nui";
import { applyTheme, normalizeTheme, type ThemeConfig } from "../lib/theme";

// ─── types ──────────────────────────────────────────────────────────────────
export type ScreenName =
  | "home"
  | "restaurant"
  | "checkout"
  | "orders"
  | "order"
  | "rewards"
  | "reserve"
  | "leaderboard"
  | "profile"
  | "kitchen"
  | "manage"
  | "staff";

export type Screen = { name: ScreenName; params?: any };
export type Tab = "home" | "orders" | "rewards" | "work" | "profile";

const TAB_ROOT: Record<Tab, ScreenName> = {
  home: "home",
  orders: "orders",
  rewards: "rewards",
  work: "kitchen",
  profile: "profile",
};

export type Mod = {
  id: string;
  label: string;
  price?: number;
  image?: string;
  color?: string;
  variant?: string;
  default?: boolean;
  group?: string;
};
export type CatalogItem = {
  key: string;
  item: string;
  label: string;
  image?: string;
  price: number;
  kind: string;
  modifiers?: Mod[];
};
export type CartLine = {
  uid: number;
  key: string;
  label: string;
  image?: string;
  price: number; // unit incl. mod extras
  qty: number;
  mods: string[];
  modLabels: string[];
};
export type Cart = { rid: number; label: string; lines: CartLine[] } | null;

// A CEF-safe replacement for window.prompt() (which FiveM's CEF suppresses, so it
// silently returns null). `ask()` resolves to the entered string, or null on cancel.
export type AskOpts = {
  title: string;
  label?: string;
  kind?: "number" | "text";
  initial?: string | number;
  placeholder?: string;
  confirm?: string;
  prefix?: string; // shown inside the field (e.g. the currency symbol) for money inputs
};

// ─── context ─────────────────────────────────────────────────────────────────
type Ctx = {
  ready: boolean;
  home: any;
  currency: string;
  refreshHome: () => Promise<any>;
  // nav
  tab: Tab;
  stack: Screen[];
  go: (name: ScreenName, params?: any) => void;
  back: () => void;
  setTab: (t: Tab) => void;
  // cart
  cart: Cart;
  addToCart: (rid: number, label: string, line: Omit<CartLine, "uid">) => void;
  setQty: (uid: number, qty: number) => void;
  clearCart: () => void;
  cartCount: number;
  cartSubtotal: number;
  // toast
  toast: (msg: string, tone?: "ok" | "err") => void;
  toastMsg: { msg: string; tone: "ok" | "err" } | null;
  // modal input (CEF-safe prompt)
  ask: (opts: AskOpts) => Promise<string | null>;
  askState: AskOpts | null;
  closeAsk: (value: string | null) => void;
};

// ─── theme boot ──────────────────────────────────────────────────────────────
// The phone's ONE global seed (`phone_theme`) only arrives with the first
// phone:home reply, which can take a second or more (lb-phone's componentsLoaded
// handshake + a possible PhoneReady retry loop). Without this the SPLASH/loading
// screen painted with index.css's static defaults and then snapped to the real
// theme once data landed. So: cache the last seed we were given and re-apply it
// synchronously at module load — before React's first render — so the loader is
// already themed. First-ever launch still falls back to the default seed.
const THEME_KEY = "pf.theme";

function cachedTheme(): ThemeConfig | null {
  try {
    const raw = localStorage.getItem(THEME_KEY);
    return raw ? (JSON.parse(raw) as ThemeConfig) : null;
  } catch {
    return null;
  }
}

function rememberTheme(t?: ThemeConfig | null) {
  try {
    // Always store the NORMALIZED seed, so clearing the setting back to the
    // default is remembered too (rather than leaving a stale seed cached).
    localStorage.setItem(THEME_KEY, JSON.stringify(normalizeTheme(t)));
  } catch {
    /* storage unavailable in this CEF context — the theme still applies live */
  }
}

// Runs at import time (before the first paint), not in an effect.
applyTheme(cachedTheme());

const PhoneCtx = createContext<Ctx>(null as any);
export const usePhone = () => useContext(PhoneCtx);
export const money = (cur: string, n: number) =>
  `${cur || "$"}${Math.round(n || 0).toLocaleString()}`;

export function PhoneProvider({ children }: { children: any }) {
  const [ready, setReady] = useState(false);
  const [home, setHome] = useState<any>(null);
  const [tab, setTabState] = useState<Tab>("home");
  const [stack, setStack] = useState<Screen[]>([{ name: "home" }]);
  const [cart, setCart] = useState<Cart>(null);
  const [toastMsg, setToastMsg] = useState<{ msg: string; tone: "ok" | "err" } | null>(null);
  const [askState, setAskState] = useState<AskOpts | null>(null);
  const askResolve = useRef<((v: string | null) => void) | null>(null);
  const uidRef = useRef(1);
  const toastTimer = useRef<any>(null);

  const currency = home?.currency || "$";

  // The phone has ONE global theme (the `phone_theme` setting), applied once here and
  // held for the whole app — it never reskins per restaurant, so the app reads like a
  // real delivery service rather than changing color on every storefront.
  // (Seeded from the cached seed at module load above so the loading screen is
  // already themed; every applied seed is cached for the NEXT cold start.)
  const applyPhoneTheme = useCallback((t?: ThemeConfig | null) => {
    applyTheme(t);
    rememberTheme(t);
  }, []);

  const refreshHome = useCallback(async () => {
    const d = await fetchNui("phone:home", {});
    if (d?.ok) {
      setHome(d);
      applyPhoneTheme(d.theme); // idempotent — keeps the seed asserted on every refresh
    }
    return d;
  }, [applyPhoneTheme]);

  // Live push: the admin panel changed the global phone theme — reskin immediately
  // (the next home refresh reasserts the same, now-saved seed).
  useNuiEvent("theme", (d) => applyPhoneTheme(d?.theme));

  // Boot: wait for lb-phone's componentsLoaded handshake, then load. The backend
  // may still be seeding (PhoneReady) right after a server restart, so retry a few
  // times before giving up and showing the app anyway.
  useEffect(() => {
    let done = false;
    const boot = async () => {
      if (done) return;
      done = true;
      for (let i = 0; i < 12; i++) {
        const d = await refreshHome();
        if (d?.ok) break;
        await new Promise((r) => setTimeout(r, 700));
      }
      setReady(true);
    };
    const onMsg = (e: MessageEvent) => {
      if (e.data === "componentsLoaded") boot();
    };
    window.addEventListener("message", onMsg);
    // Safety net if the handshake was missed / already fired.
    const t = setTimeout(boot, 1500);
    return () => {
      window.removeEventListener("message", onMsg);
      clearTimeout(t);
    };
  }, [refreshHome]);

  // ── nav ──
  const go = useCallback((name: ScreenName, params?: any) => {
    setStack((s) => [...s, { name, params }]);
  }, []);
  const back = useCallback(() => {
    setStack((s) => (s.length > 1 ? s.slice(0, -1) : s));
  }, []);
  const setTab = useCallback((t: Tab) => {
    setTabState(t);
    setStack([{ name: TAB_ROOT[t] }]);
  }, []);

  // ── cart ──
  const addToCart = useCallback(
    (rid: number, label: string, line: Omit<CartLine, "uid">) => {
      setCart((c) => {
        const base: Cart =
          c && c.rid === rid ? c : { rid, label, lines: [] };
        // Merge identical lines (same key + same mods).
        const sig = line.key + "|" + [...line.mods].sort().join(",");
        const idx = base!.lines.findIndex(
          (l) => l.key + "|" + [...l.mods].sort().join(",") === sig
        );
        let lines = base!.lines;
        if (idx >= 0) {
          lines = lines.map((l, i) =>
            i === idx ? { ...l, qty: Math.min(10, l.qty + line.qty) } : l
          );
        } else {
          lines = [...lines, { ...line, uid: uidRef.current++ }];
        }
        return { ...base!, lines };
      });
    },
    []
  );
  const setQty = useCallback((uid: number, qty: number) => {
    setCart((c) => {
      if (!c) return c;
      const lines = c.lines
        .map((l) => (l.uid === uid ? { ...l, qty } : l))
        .filter((l) => l.qty > 0);
      return lines.length ? { ...c, lines } : null;
    });
  }, []);
  const clearCart = useCallback(() => setCart(null), []);

  const cartCount = useMemo(
    () => (cart ? cart.lines.reduce((n, l) => n + l.qty, 0) : 0),
    [cart]
  );
  const cartSubtotal = useMemo(
    () => (cart ? cart.lines.reduce((n, l) => n + l.price * l.qty, 0) : 0),
    [cart]
  );

  // ── toast ──
  const toast = useCallback((msg: string, tone: "ok" | "err" = "ok") => {
    setToastMsg({ msg, tone });
    clearTimeout(toastTimer.current);
    toastTimer.current = setTimeout(() => setToastMsg(null), 2600);
  }, []);

  // ── ask (modal prompt) ──
  const ask = useCallback(
    (opts: AskOpts) =>
      new Promise<string | null>((resolve) => {
        askResolve.current = resolve;
        setAskState(opts);
      }),
    []
  );
  const closeAsk = useCallback((value: string | null) => {
    askResolve.current?.(value);
    askResolve.current = null;
    setAskState(null);
  }, []);

  const value: Ctx = {
    ready,
    home,
    currency,
    refreshHome,
    tab,
    stack,
    go,
    back,
    setTab,
    cart,
    addToCart,
    setQty,
    clearCart,
    cartCount,
    cartSubtotal,
    toast,
    toastMsg,
    ask,
    askState,
    closeAsk,
  };
  return <PhoneCtx.Provider value={value}>{children}</PhoneCtx.Provider>;
}
