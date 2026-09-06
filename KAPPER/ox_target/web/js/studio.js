// Target Studio — vanilla-DOM customization panel (/oxtarget).
// Every change applies live; Save persists (and optionally broadcasts).
import { applyTheme, DEFAULT_THEME, PRESETS, sanitize } from "./theme.js";
import { fetchNui } from "./fetchNui.js";
import { createOptions } from "./createOptions.js";

const studio = document.getElementById("studio");
const optionsWrapper = document.getElementById("options-wrapper");
const reticle = document.getElementById("reticle");

let current = { ...DEFAULT_THEME };
let saved = { ...DEFAULT_THEME };
let isAdmin = false;
let forcedActive = false;
let open = false;

const $ = (id) => document.getElementById(id);

const DEMO_OPTIONS = [
  { icon: "fa-solid fa-hand", label: "Open trunk" },
  { icon: "fa-solid fa-key", label: "Lock vehicle" },
  { icon: "fa-solid fa-gas-pump", label: "Refuel" },
  { icon: "fa-solid fa-screwdriver-wrench", label: "Repair" },
];

const renderDemo = () => {
  optionsWrapper.innerHTML = "";
  DEMO_OPTIONS.forEach((data, id) => createOptions("demo", data, id + 1));
  reticle.classList.add("on-target");
  reticle.classList.remove("pop");
  void reticle.offsetWidth;
  reticle.classList.add("pop");
};

const setFill = (input) => {
  const min = Number(input.min);
  const max = Number(input.max);
  const pct = ((Number(input.value) - min) / (max - min)) * 100;
  input.style.setProperty("--fill", `${pct}%`);
};

const syncControls = () => {
  $("st-brand").value = current.brand;
  $("st-brand-hex").value = current.brand.toUpperCase();
  $("st-bg").value = current.bg;
  $("st-bg-hex").value = current.bg.toUpperCase();
  $("st-text").value = current.text;
  $("st-text-hex").value = current.text.toUpperCase();

  $("st-scale").value = Math.round(current.scale * 100);
  $("st-scale-v").textContent = `${Math.round(current.scale * 100)}%`;
  $("st-radius").value = current.radius;
  $("st-radius-v").textContent = `${current.radius}px`;
  $("st-notch").value = current.notch;
  $("st-notch-v").textContent = `${current.notch}px`;
  $("st-alpha").value = Math.round(current.alpha * 100);
  $("st-alpha-v").textContent = `${Math.round(current.alpha * 100)}%`;
  $("st-offset").value = current.offsetX;
  $("st-offset-v").textContent = `${current.offsetX}pt`;
  $("st-speed").value = Math.round(current.speed * 100);
  $("st-speed-v").textContent = `${current.speed.toFixed(1)}x`;

  $("st-mono").dataset.on = String(current.monoLabels);
  $("st-idx").dataset.on = String(current.showIndex);
  $("st-admin-toggle").dataset.on = String(isAdmin && (forcedActive || $("st-admin-toggle").dataset.on === "true"));

  document.querySelectorAll("#st-reticles .st-chip").forEach((chip) => {
    chip.classList.toggle("active", chip.dataset.reticle === current.reticle);
  });
  document.querySelectorAll("#st-anims .st-chip").forEach((chip) => {
    chip.classList.toggle("active", chip.dataset.anim === current.anim);
  });

  document.querySelectorAll("input[type='range']").forEach(setFill);
};

const update = (patch, replayDemo) => {
  current = sanitize({ ...current, ...patch });
  applyTheme(current);
  syncControls();
  if (replayDemo && open) renderDemo();
};

// ── static wiring ──
const buildPresets = () => {
  const grid = $("st-presets");
  PRESETS.forEach((preset) => {
    const chip = document.createElement("button");
    chip.className = "st-preset";
    chip.innerHTML = `<span class="st-preset-swatch" style="background:${preset.bg}"><span class="st-preset-bar" style="background:${preset.brand}"></span></span><span class="st-preset-name">${preset.label}</span>`;
    chip.addEventListener("click", () => update({ brand: preset.brand, bg: preset.bg }, true));
    grid.appendChild(chip);
  });
};

const wireColor = (key, colorId, hexId) => {
  $(colorId).addEventListener("input", (e) => update({ [key]: e.target.value }));
  $(hexId).addEventListener("change", (e) => {
    const v = e.target.value.startsWith("#") ? e.target.value : `#${e.target.value}`;
    update({ [key]: v });
  });
};

const wireSlider = (id, fn) => {
  $(id).addEventListener("input", (e) => {
    setFill(e.target);
    fn(Number(e.target.value));
  });
};

const wireToggle = (id, key) => {
  $(id).addEventListener("click", () => {
    update({ [key]: !current[key] }, key === "showIndex" || key === "monoLabels");
  });
};

export const initStudio = () => {
  buildPresets();
  wireColor("brand", "st-brand", "st-brand-hex");
  wireColor("bg", "st-bg", "st-bg-hex");
  wireColor("text", "st-text", "st-text-hex");

  wireSlider("st-scale", (v) => update({ scale: v / 100 }));
  wireSlider("st-radius", (v) => update({ radius: v }));
  wireSlider("st-notch", (v) => update({ notch: v }));
  wireSlider("st-alpha", (v) => update({ alpha: v / 100 }));
  wireSlider("st-offset", (v) => update({ offsetX: v }));
  wireSlider("st-speed", (v) => update({ speed: v / 100 }));

  wireToggle("st-mono", "monoLabels");
  wireToggle("st-idx", "showIndex");

  document.querySelectorAll("#st-reticles .st-chip").forEach((chip) => {
    chip.addEventListener("click", () => update({ reticle: chip.dataset.reticle }));
  });
  document.querySelectorAll("#st-anims .st-chip").forEach((chip) => {
    chip.addEventListener("click", () => update({ anim: chip.dataset.anim }, true));
  });

  $("st-admin-toggle").addEventListener("click", function () {
    if (!isAdmin) return;
    this.dataset.on = String(this.dataset.on !== "true");
  });

  $("st-replay").addEventListener("click", () => renderDemo());
  $("st-reset").addEventListener("click", () => update({ ...DEFAULT_THEME }, true));
  $("st-cancel").addEventListener("click", cancelStudio);
  $("st-close").addEventListener("click", cancelStudio);
  $("st-save").addEventListener("click", saveStudio);

  window.addEventListener("keydown", (e) => {
    if (open && e.code === "Escape") cancelStudio();
  });
};

export const openStudio = (data) => {
  open = true;
  isAdmin = !!data.isAdmin;
  forcedActive = !!data.forcedActive;
  saved = sanitize(data.settings || DEFAULT_THEME);
  current = { ...saved };

  $("st-admin-toggle").disabled = !isAdmin;
  $("st-admin-toggle").dataset.on = String(isAdmin && forcedActive);
  $("st-admin-locked").classList.toggle("hidden", isAdmin);
  $("st-admin-forced").classList.toggle("hidden", !forcedActive);

  applyTheme(current);
  studio.classList.remove("hidden");
  document.body.style.visibility = "visible";
  syncControls();
  renderDemo();
};

const closeStudio = () => {
  open = false;
  studio.classList.add("hidden");
  optionsWrapper.innerHTML = "";
  reticle.classList.remove("on-target");
  document.body.style.visibility = "hidden";
};

function cancelStudio() {
  applyTheme(saved);
  closeStudio();
  fetchNui("themeStudio:close");
}

function saveStudio() {
  const adminOn = isAdmin && $("st-admin-toggle").dataset.on === "true";
  closeStudio();
  fetchNui("themeStudio:save", {
    settings: current,
    admin: adminOn,
    clearForced: isAdmin && !adminOn && forcedActive,
  });
}

export const isStudioOpen = () => open;
