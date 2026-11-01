import "@mantine/core/styles.css";
import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.tsx";
import { RecoilRoot } from "recoil";
import "./index.css";

const rootElement = document.getElementById("root");
const root = ReactDOM.createRoot(rootElement!);

root.render(
  <React.StrictMode>
    <RecoilRoot>
      <App />
    </RecoilRoot>
  </React.StrictMode>
);
