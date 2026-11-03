import '@mantine/core/styles.css';
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.tsx'
import { Provider } from 'react-redux'
import { store } from "./reducers/store";
import {isEnvBrowser} from "./hooks/useNuiEvents.ts";
import './index.css'
import './global.css'

const root = ReactDOM.createRoot(document.getElementById("root")!);

const loadApp = (height:any) => {
  root.render(
    <React.StrictMode>
      <Provider store={store}>
        <App height={height}/>
      </Provider>
    </React.StrictMode>
  );
};

window.addEventListener("message", (event) => {
  if (event.data.message === "loadApp") {
    loadApp(event.data.height);
  }
});

if(isEnvBrowser()) loadApp(null)