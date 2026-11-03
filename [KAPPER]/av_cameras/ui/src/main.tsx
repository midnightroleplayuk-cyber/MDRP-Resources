import "@mantine/core/styles.css";
import "./index.css";
import "./global.css";
import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.tsx";

const rootElement = document.getElementById("root");
const root = ReactDOM.createRoot(rootElement!);

root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
);
