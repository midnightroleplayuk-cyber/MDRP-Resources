import { createOptions } from "./createOptions.js";
import { applyTheme } from "./theme.js";
import { initStudio, openStudio, isStudioOpen } from "./studio.js";
import { fetchNui } from "./fetchNui.js";

const optionsWrapper = document.getElementById("options-wrapper");
const body = document.body;
const reticle = document.getElementById("reticle");

// default look until the client pushes the stored theme
applyTheme(null);
initStudio();

const popReticle = () => {
  reticle.classList.remove("pop");
  void reticle.offsetWidth;
  reticle.classList.add("pop");
};

window.addEventListener("message", (event) => {
  switch (event.data.event) {
    case "visible": {
      if (isStudioOpen()) return;
      optionsWrapper.innerHTML = "";
      body.style.visibility = event.data.state ? "visible" : "hidden";
      if (event.data.state) popReticle();
      return reticle.classList.remove("on-target");
    }

    case "leftTarget": {
      if (isStudioOpen()) return;
      optionsWrapper.innerHTML = "";
      return reticle.classList.remove("on-target");
    }

    case "setTarget": {
      if (isStudioOpen()) return;
      optionsWrapper.innerHTML = "";
      reticle.classList.add("on-target");

      if (event.data.options) {
        for (const type in event.data.options) {
          event.data.options[type].forEach((data, id) => {
            createOptions(type, data, id + 1);
          });
        }
      }

      if (event.data.zones) {
        for (let i = 0; i < event.data.zones.length; i++) {
          event.data.zones[i].forEach((data, id) => {
            createOptions("zones", data, id + 1, i + 1);
          });
        }
      }
      return;
    }

    case "setTheme": {
      return applyTheme(event.data.settings || null);
    }

    case "openStudio": {
      return openStudio(event.data);
    }
  }
});

// tell the client the NUI is mounted so it can push the stored theme
fetchNui("themeReady").catch(() => {});
