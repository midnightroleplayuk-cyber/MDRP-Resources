import React from "react";
import ReactDOM from "react-dom/client";
import PhoneApp from "./phone/PhoneApp";
import "./index.css";
import "./phone/phone.css";
import { loadLocale } from "./lib/locale";

// The lb-phone host injects its bridge (components / fetchNui / settings) into this
// iframe and, ~250ms later, posts the `componentsLoaded` handshake. We render
// immediately (so the frame is never blank) but the app waits for that signal
// before its first data fetch — see PhoneApp's boot effect. In a plain browser
// (npm run dev, no lb-phone) the handshake never comes, so we also synthesize it
// once after a short delay for local development.
if (!(window as any).__lbHostPresent) {
  setTimeout(() => window.postMessage("componentsLoaded", "*"), 400);
}

// Strings live in Lua (locales/translations/*.lua) and are fetched once here, before
// the first paint, so nothing renders raw keys. The iframe POSTs to this resource just
// like the fullscreen NUI, so the same `getLocale` callback serves both.
loadLocale().finally(() => {
  ReactDOM.createRoot(document.getElementById("root")!).render(
    <React.StrictMode>
      <PhoneApp />
    </React.StrictMode>
  );
});
