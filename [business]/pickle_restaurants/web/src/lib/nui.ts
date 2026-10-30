import { useEffect, useRef } from "react";

const RESOURCE =
  (typeof window !== "undefined" && (window as any).GetParentResourceName?.()) ||
  "pickle_restaurants";

export async function fetchNui<T = any>(event: string, data: any = {}): Promise<T> {
  try {
    const resp = await fetch(`https://${RESOURCE}/${event}`, {
      method: "POST",
      headers: { "Content-Type": "application/json; charset=UTF-8" },
      body: JSON.stringify(data),
    });
    return (await resp.json()) as T;
  } catch {
    return {} as T;
  }
}

// Fade the whole NUI to 75% while the user peeks at a highlighted world entity
// behind the panel (a prop-card hover beams/outlines the prop in the world). Driven
// by a `data-peek` attr on <html>; index.css fades the app root with a transition.
export function setPeek(on: boolean) {
  if (on) document.documentElement.setAttribute("data-peek", "1");
  else document.documentElement.removeAttribute("data-peek");
}

// ─── live-push capability ────────────────────────────────────────────────────
// Server→app pushes need the phone to expose a Lua→iframe emitter. lb-phone has one
// (SendCustomAppMessage); Quasar publishes none, so its bridge reports pushless and
// the screens that depend on live data poll instead. Probed ONCE per page load and
// shared by every caller — the answer can't change while the page is up.
let pushSupported: boolean | null = null;
let pushProbe: Promise<boolean> | null = null;

async function supportsPush(): Promise<boolean> {
  if (pushSupported !== null) return pushSupported;
  // Default to TRUE on a failed/absent callback: assuming push works costs a screen
  // its live updates only on a phone that genuinely can't push, whereas assuming it
  // doesn't would make every lb-phone install poll needlessly.
  pushProbe = pushProbe || fetchNui("phone:pushSupported").then((d) => d?.supported !== false);
  pushSupported = await pushProbe;
  return pushSupported;
}

// Calls `refresh` on an interval, but ONLY on a phone that can't push. On lb-phone
// this hook does nothing at all and the screen stays purely event-driven.
export function usePushFallback(refresh: () => void, ms = 5000) {
  const saved = useRef(refresh);
  saved.current = refresh;
  useEffect(() => {
    let timer: any;
    let cancelled = false;
    supportsPush().then((ok) => {
      if (cancelled || ok) return;
      timer = setInterval(() => saved.current(), ms);
    });
    return () => {
      cancelled = true;
      if (timer) clearInterval(timer);
    };
  }, [ms]);
}

type Handler = (data: any) => void;

// Subscribes to NUI messages. Matches on either `action` or `type` (the core
// interact-text message uses `type`).
export function useNuiEvent(name: string, handler: Handler) {
  const saved = useRef<Handler>(handler);
  saved.current = handler;
  useEffect(() => {
    const listener = (e: MessageEvent) => {
      const d = e.data || {};
      if (d.action === name || d.type === name) saved.current(d);
    };
    window.addEventListener("message", listener);
    return () => window.removeEventListener("message", listener);
  }, [name]);
}
