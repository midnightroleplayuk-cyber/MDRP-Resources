import "@mantine/core/styles.css";
import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.tsx";
import { RecoilRoot } from "recoil";
import "./index.css";
import "./global.css";
import { Listeners } from "./Listeners.tsx";

const rootElement = document.getElementById("root");
const root = ReactDOM.createRoot(rootElement!);

root.render(
  <React.StrictMode>
    <RecoilRoot>
      <Listeners />
      <App />
    </RecoilRoot>
  </React.StrictMode>
);
