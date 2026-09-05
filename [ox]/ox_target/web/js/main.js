import { createOptions, findGoBackOption } from "./createOptions.js";
import { fetchNui } from "./fetchNui.js";

// ── Theme ──
const THEME_PALETTES = {
  jakers: ['#f7ffe0', '#efffc2', '#e8ff8a', '#e4ff5c', '#E0FF45', '#CDFF03', '#b8d902', '#94b302', '#708c02', '#566f02'],
  dark: ['#C9C9C9', '#b8b8b8', '#828282', '#696969', '#424242', '#3b3b3b', '#2e2e2e', '#242424', '#1f1f1f', '#141414'],
  gray: ['#f8f9fa', '#f1f3f5', '#e9ecef', '#dee2e6', '#ced4da', '#adb5bd', '#868e96', '#495057', '#343a40', '#212529'],
  red: ['#fff5f5', '#ffe3e3', '#ffc9c9', '#ffa8a8', '#ff8787', '#ff6b6b', '#fa5252', '#f03e3e', '#e03131', '#c92a2a'],
  pink: ['#fff0f6', '#ffdeeb', '#fcc2d7', '#faa2c1', '#f783ac', '#f06595', '#e64980', '#d6336c', '#c2255c', '#a61e4d'],
  grape: ['#f8f0fc', '#f3d9fa', '#eebefa', '#e599f7', '#da77f2', '#cc5de8', '#be4bdb', '#ae3ec9', '#9c36b5', '#862e9c'],
  violet: ['#f3f0ff', '#e5dbff', '#d0bfff', '#b197fc', '#9775fa', '#845ef7', '#7950f2', '#7048e8', '#6741d9', '#5f3dc4'],
  indigo: ['#edf2ff', '#dbe4ff', '#bac8ff', '#91a7ff', '#748ffc', '#5c7cfa', '#4c6ef5', '#4263eb', '#3b5bdb', '#364fc7'],
  blue: ['#e7f5ff', '#d0ebff', '#a5d8ff', '#74c0fc', '#4dabf7', '#339af0', '#228be6', '#1c7ed6', '#1971c2', '#1864ab'],
  cyan: ['#e3fafc', '#c5f6fa', '#99e9f2', '#66d9e8', '#3bc9db', '#22b8cf', '#15aabf', '#1098ad', '#0c8599', '#0b7285'],
  teal: ['#e6fcf5', '#c3fae8', '#96f2d7', '#63e6be', '#38d9a9', '#20c997', '#12b886', '#0ca678', '#099268', '#087f5b'],
  green: ['#ebfbee', '#d3f9d8', '#b2f2bb', '#8ce99a', '#69db7c', '#51cf66', '#40c057', '#37b24d', '#2f9e44', '#2b8a3e'],
  lime: ['#f4fce3', '#e9fac8', '#d8f5a2', '#c0eb75', '#a9e34b', '#94d82d', '#82c91e', '#74b816', '#66a80f', '#5c940d'],
  yellow: ['#fff9db', '#fff3bf', '#ffec99', '#ffe066', '#ffd43b', '#fcc419', '#fab005', '#f59f00', '#f08c00', '#e67700'],
  orange: ['#fff4e6', '#ffe8cc', '#ffd8a8', '#ffc078', '#ffa94d', '#ff922b', '#fd7e14', '#f76707', '#e8590c', '#d9480f'],
};

function hexToRgb(hex) {
  const raw = hex.replace('#', '');
  const normalized = raw.length === 3 ? raw.split('').map((c) => c + c).join('') : raw;
  const n = Number.parseInt(normalized, 16);
  return `${(n >> 16) & 255}, ${(n >> 8) & 255}, ${n & 255}`;
}

function clampShade(shade) {
  return Math.max(0, Math.min(9, Math.round(shade)));
}

function resolvePalette(name) {
  return THEME_PALETTES[name?.toLowerCase()] ?? THEME_PALETTES.jakers;
}

function applyThemeConfig(config = {}) {
  const palette = resolvePalette(config.primaryColor ?? 'jakers');
  const shade = clampShade(config.primaryShade ?? 5);
  const accent = palette[shade];
  const accentHi = palette[Math.max(0, shade - 1)];
  const root = document.documentElement;
  const rgb = hexToRgb(accent);

  root.style.setProperty('--accent-rgb', rgb);
  root.style.setProperty('--accent-hi-rgb', hexToRgb(accentHi));
  root.style.setProperty('--rs-accent', accent);
  root.style.setProperty('--rs-accent-hi', accentHi);
  root.style.setProperty('--rs-accent-soft', `rgba(${rgb}, 0.12)`);
  root.style.setProperty('--rs-accent-glow', `0 0 20px rgba(${rgb}, 0.28)`);
  root.style.setProperty('--rs-accent-gradient', `linear-gradient(135deg, ${accent} 0%, ${accentHi} 100%)`);
  root.style.setProperty('--rs-success', accent);
  root.style.setProperty('--success-rgb', rgb);
  root.style.setProperty('--rs-sep', `rgba(${rgb}, 0.16)`);
}

// ── Icons ──
export function iconClass(icon) {
  if (!icon) return "";

  if (Array.isArray(icon)) {
    const prefix = icon[0] ?? "fas";
    const name = String(icon[1] ?? "").replace(/^fa-/, "");
    const style = prefix === "fab" ? "fa-brands" : prefix === "far" ? "fa-regular" : "fa-solid";
    return `${style} fa-${name} fa-fw`;
  }

  const value = String(icon).trim();
  if (!value) return "";

  if (value.includes(" ")) {
    return value.includes("fa-fw") ? value : `${value} fa-fw`;
  }

  return `fa-solid fa-${value.replace(/^fa-/, "")} fa-fw`;
}

// ── Branch / spline ──
const BRANCH_ANGLE = -45;
const HUB_HALF = 17;
const SPOKE_GAP = 24;

const SPOKE_START_X = HUB_HALF;
const SPOKE_START_Y = -HUB_HALF;
const ANGLE_RAD = (BRANCH_ANGLE * Math.PI) / 180;
const SPOKE_DIR_X = Math.cos(ANGLE_RAD);
const SPOKE_DIR_Y = Math.sin(ANGLE_RAD);

const PANEL_X = SPOKE_START_X + SPOKE_DIR_X * SPOKE_GAP;
const PANEL_Y = SPOKE_START_Y + SPOKE_DIR_Y * SPOKE_GAP;

let panelObserver;

function rootCenter(root) {
  const rect = root.getBoundingClientRect();
  return {
    x: rect.left + rect.width / 2,
    y: rect.top + rect.height / 2,
  };
}

function syncSpokeFromCorners(root, startX, startY, endX, endY) {
  const dx = endX - startX;
  const dy = endY - startY;
  const length = Math.hypot(dx, dy);
  const angle = `${(Math.atan2(dy, dx) * 180) / Math.PI}deg`;

  root.style.setProperty("--spoke-start-x", `${startX}px`);
  root.style.setProperty("--spoke-start-y", `${startY}px`);
  root.style.setProperty("--branch-length", `${length}px`);
  root.style.setProperty("--branch-angle", angle);

  const spline = root.querySelector("#target-spline");
  if (spline) spline.style.transform = `rotate(${angle})`;
}

function measureSpoke(root) {
  const hub = root.querySelector(".target-hub-frame");
  const panel = root.querySelector(".ctx-menu-panel");

  if (!hub || !panel) {
    syncSpokeFromCorners(root, SPOKE_START_X, SPOKE_START_Y, PANEL_X, PANEL_Y);
    return;
  }

  const center = rootCenter(root);
  const hubRect = hub.getBoundingClientRect();
  const panelRect = panel.getBoundingClientRect();

  syncSpokeFromCorners(
    root,
    hubRect.right - center.x,
    hubRect.top - center.y,
    panelRect.left - center.x,
    panelRect.bottom - center.y,
  );
}

function initBranchLayout(root) {
  root.style.setProperty("--cards-x", `${PANEL_X}px`);
  root.style.setProperty("--cards-y", `${PANEL_Y}px`);
  syncSpokeFromCorners(root, SPOKE_START_X, SPOKE_START_Y, PANEL_X, PANEL_Y);

  if (panelObserver) panelObserver.disconnect();

  const panel = root.querySelector(".ctx-menu-panel");
  if (panel && typeof ResizeObserver !== "undefined") {
    panelObserver = new ResizeObserver(() => {
      if (root.classList.contains("has-target")) measureSpoke(root);
    });
    panelObserver.observe(panel);
  }
}

function syncSpoke(root) {
  requestAnimationFrame(() => {
    requestAnimationFrame(() => measureSpoke(root));
  });
}

function setSplineActive(root, active) {
  root.querySelector("#target-spline")?.classList.toggle("active", !!active);
}

// ── DOM ──
const targetRoot = document.getElementById("target-root");
const targetHub = document.getElementById("target-hub");
const optionsList = document.getElementById("options-list");
const ctxSubtitle = document.getElementById("ctx-subtitle");
const ctxBadgeLabel = document.getElementById("ctx-badge-label");
const ctxBack = document.getElementById("ctx-back");
const ctxBackGuide = document.getElementById("ctx-back-guide");
const body = document.body;

// ── Navigation ──
let focusIndex = -1;
let focusChangeHandler = null;

function getRows() {
  return [...optionsList.querySelectorAll(".ctx-menu-item:not(.is-hidden)")];
}

function isSelectableButton(button) {
  return button && !button.disabled && button.dataset.interactive === "1";
}

function getItems() {
  return getRows()
    .map((row) => row.querySelector(".ctx-menu-item-btn"))
    .filter(isSelectableButton);
}

function setFocusedItem(index) {
  const items = getItems();
  focusIndex = items.length === 0 ? -1 : Math.max(0, Math.min(index, items.length - 1));

  getRows().forEach((row) => {
    const btn = row.querySelector(".ctx-menu-item-btn");
    if (!btn) return;
    const itemIndex = items.indexOf(btn);
    btn.classList.toggle("is-focused", itemIndex === focusIndex);
  });

  const current = items[focusIndex];
  if (current) {
    current.closest(".ctx-menu-item")?.scrollIntoView({ block: "nearest" });
  }

  if (focusChangeHandler) {
    focusChangeHandler(current ?? null);
  }
}

function setFocusChangeHandler(handler) {
  focusChangeHandler = handler;
}

function resetFocus() {
  focusIndex = -1;
  optionsList.querySelectorAll(".ctx-menu-item-btn.is-focused").forEach((btn) => {
    btn.classList.remove("is-focused");
  });

  if (focusChangeHandler) {
    focusChangeHandler(null);
  }
}

function syncFocus() {
  const items = getItems();
  if (items.length === 0) {
    resetFocus();
    return;
  }

  if (focusIndex < 0 || focusIndex >= items.length) {
    setFocusedItem(0);
    return;
  }

  setFocusedItem(focusIndex);
}

function moveFocus(direction) {
  const items = getItems();
  if (items.length === 0) return null;

  if (focusIndex < 0) {
    setFocusedItem(direction > 0 ? 0 : items.length - 1);
    return items[focusIndex];
  }

  const next = (focusIndex + direction + items.length) % items.length;
  setFocusedItem(next);
  return items[focusIndex];
}

function focusItem(index) {
  setFocusedItem(index);
  return getItems()[focusIndex] ?? null;
}

function getFocusedItem() {
  const items = getItems();
  return focusIndex >= 0 ? items[focusIndex] ?? null : null;
}

function bindItemFocus() {
  optionsList.addEventListener("mouseover", (event) => {
    const row = event.target.closest(".ctx-menu-item:not(.is-hidden)");
    if (!row || row.closest("#options-list") !== optionsList) return;

    const btn = row.querySelector(".ctx-menu-item-btn");
    if (!isSelectableButton(btn)) return;

    const items = getItems();
    const index = items.indexOf(btn);
    if (index >= 0) setFocusedItem(index);
  });
}

function getOptionCount() {
  return getRows().length;
}

// ── App ──
let isAltPressed = false;
let isVisible = false;
let inSubmenu = false;

function applyUiSettings(settings) {
  if (!settings || typeof settings !== "object") return;
  const root = document.documentElement;

  if (typeof settings.transparency === "number") {
    root.style.setProperty("--container-transparency", String(settings.transparency / 100));
  }
  if (typeof settings.borderRadius === "number") {
    root.style.setProperty("--border-radius-scale", String(settings.borderRadius / 10));
  }
  if (typeof settings.gradientIntensity === "number") {
    root.style.setProperty("--gradient-intensity", String((settings.gradientIntensity / 100) * 0.08));
  }
  if (typeof settings.perspective === "string") {
    root.setAttribute("data-perspective", settings.perspective);
  }
}

function updateHeader() {
  const count = getOptionCount();
  ctxSubtitle.textContent = `${count} ${count === 1 ? "option" : "options"}`;
  ctxBadgeLabel.textContent = inSubmenu ? "Submenu" : "Menu";
  ctxBack.classList.toggle("is-hidden", !inSubmenu);
  ctxBackGuide.classList.toggle("is-hidden", !inSubmenu);
}

function setPanelVisible(visible) {
  targetRoot.classList.toggle("has-target", visible);
  if (visible) {
    fetchNui("requestFocus", {}).catch(() => {});
    syncSpoke(targetRoot);
  } else {
    setSplineActive(targetRoot, false);
  }
}

function clearOptions() {
  optionsList.innerHTML = "";
  resetFocus();
  setPanelVisible(false);
  inSubmenu = false;
  updateHeader();
}

function selectOption(option) {
  if (!option) return;
  option.click();
}

function setTargetingActive(active) {
  targetRoot.classList.toggle("is-hidden", !active);
  targetHub.classList.toggle("is-hidden", !active);
  targetRoot.classList.toggle("hub-active", active);

  if (!active) {
    clearOptions();
  }
}

function rebuildOptions(data) {
  optionsList.innerHTML = "";
  resetFocus();
  inSubmenu = !!data.menu;

  if (data.options) {
    for (const type in data.options) {
      data.options[type].forEach((optionData, id) => {
        createOptions(type, optionData, id + 1, undefined, optionsList);
      });
    }
  }

  if (data.zones) {
    for (let i = 0; i < data.zones.length; i++) {
      data.zones[i].forEach((optionData, id) => {
        createOptions("zones", optionData, id + 1, i + 1, optionsList);
      });
    }
  }

  const count = getOptionCount();
  setPanelVisible(count > 0);
  updateHeader();
  syncFocus();

  if (count > 0) {
    syncSpoke(targetRoot);
  }
}

function goBack() {
  const goBackOption = findGoBackOption();
  if (goBackOption) selectOption(goBackOption);
}

setFocusChangeHandler((item) => {
  setSplineActive(targetRoot, targetRoot.classList.contains("has-target") && !!item);
});

bindItemFocus();
initBranchLayout(targetRoot);

ctxBack.addEventListener("click", goBack);

fetchNui("getConfig", {}).then(applyThemeConfig).catch(() => applyThemeConfig());
fetchNui("uiLoaded", {}).then(applyUiSettings).catch(() => {});

document.addEventListener("keydown", (event) => {
  if (event.key === "Alt") {
    isAltPressed = true;
  }

  if (!isVisible || !targetRoot.classList.contains("has-target")) return;

  if (event.key === "ArrowDown") {
    event.preventDefault();
    moveFocus(1);
    return;
  }

  if (event.key === "ArrowUp") {
    event.preventDefault();
    moveFocus(-1);
    return;
  }

  if (event.key === "Enter") {
    event.preventDefault();
    selectOption(getFocusedItem());
    return;
  }

  if (event.key === "Backspace" && inSubmenu) {
    event.preventDefault();
    goBack();
    return;
  }

  if (isAltPressed && event.key >= "1" && event.key <= "9") {
    const optionNumber = parseInt(event.key, 10);
    const option = focusItem(optionNumber - 1);

    if (option) {
      setTimeout(() => {
        selectOption(option);
        fetchNui("releaseAlt", {});
        isAltPressed = false;
      }, 100);
    }
  }
});

document.addEventListener("keyup", (event) => {
  if (event.key === "Alt") {
    isAltPressed = false;
  }
});

window.addEventListener("message", (event) => {
  if (event.data.event === "uiSettings") {
    applyUiSettings(event.data.data);
    return;
  }

  switch (event.data.event) {
    case "visible": {
      isVisible = event.data.state;
      body.style.visibility = event.data.state ? "visible" : "hidden";
      setTargetingActive(event.data.state);
      return;
    }

    case "leftTarget": {
      clearOptions();
      return;
    }

    case "keyPressed": {
      const keyNumber = parseInt(event.data.key, 10);
      selectOption(focusItem(keyNumber - 1));
      return;
    }

    case "setTarget": {
      rebuildOptions(event.data);
      return;
    }
  }
});
