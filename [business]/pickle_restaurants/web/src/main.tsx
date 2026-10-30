import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App";
import KioskDui from "./views/KioskDui";
import RegisterDui from "./views/RegisterDui";
import "./index.css";
import { loadLocale } from "./lib/locale";

// The SAME built bundle is loaded three ways: as the normal ui_page NUI (<App/>), and
// as a DUI on an in-world screen selected by the URL hash —
//   #kiosk    → the self-service customer kiosk order page (modules/kiosk)
//   #register → the staff POS register painted on the counter's screen (modules/register)
const hash = window.location.hash.replace(/^#/, "").split("?")[0];

// Strings come from Lua (locales/translations/*.lua), so the table has to be in hand
// before the first paint or the app would flash raw keys. One await, once, at boot;
// it resolves immediately if the callback is unavailable, so a failure to fetch
// degrades to visible keys rather than a blank screen that never renders.
loadLocale().finally(() => {
  ReactDOM.createRoot(document.getElementById("root")!).render(
    <React.StrictMode>
      {hash === "kiosk" ? <KioskDui /> : hash === "register" ? <RegisterDui /> : <App />}
    </React.StrictMode>
  );
});
