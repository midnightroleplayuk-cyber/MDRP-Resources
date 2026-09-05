import { fetchNui } from "./fetchNui.js";
import { iconClass } from "./main.js";

function escapeHtml(value) {
  const el = document.createElement("span");
  el.textContent = value ?? "";
  return el.innerHTML;
}

function toMetaRows(metadata) {
  if (!metadata) return [];
  if (typeof metadata === "string") return [{ label: metadata }];
  if (Array.isArray(metadata)) {
    return metadata.map((entry) =>
      typeof entry === "string" ? { label: entry } : { ...entry },
    );
  }

  return Object.entries(metadata).map(([label, value]) => ({ label, value }));
}

function iconFrameMarkup(icon, iconColor, image) {
  if (!icon && !image) return "";

  const frameSvg = `<svg viewBox="0 0 34 34" aria-hidden="true">
    <rect x="1.5" y="1.5" width="31" height="31" rx="6" ry="6" fill="none" stroke="rgba(255,255,255,0.08)" stroke-width="1.5"></rect>
  </svg>`;

  if (image) {
    return `<span class="context-icon-frame" aria-hidden="true">
      ${frameSvg}
      <span class="rs-icon-block" style="--icon-rgb: 232, 232, 232">
        <img src="${escapeHtml(image)}" alt="" class="ctx-menu-item-image" />
      </span>
    </span>`;
  }

  const classes = iconClass(icon);
  const color = iconColor || "rgba(255,255,255,0.82)";

  return `<span class="context-icon-frame" aria-hidden="true">
    ${frameSvg}
    <span class="rs-icon-block" style="--icon-rgb: 232, 232, 232">
      <i class="${escapeHtml(classes)}" style="color: ${escapeHtml(color)}"></i>
    </span>
  </span>`;
}

function progressMarkup(progress, colorScheme) {
  if (typeof progress !== "number") return "";

  const schemeColors = {
    red: "var(--rs-danger)",
    green: "var(--rs-success)",
    teal: "var(--rs-success)",
    blue: "var(--rs-info)",
    cyan: "var(--rs-info)",
    yellow: "var(--rs-success)",
    orange: "var(--rs-warning)",
  };

  const clamped = Math.min(100, Math.max(0, progress));
  const fill = schemeColors[colorScheme] ?? "linear-gradient(90deg, var(--rs-accent), var(--rs-accent-hi))";

  return `<div class="ctx-menu-item-progress">
    <div class="ctx-menu-item-progress-track">
      <div class="ctx-menu-item-progress-fill" style="width: ${clamped}%; background: ${fill}"></div>
    </div>
    <span class="ctx-menu-item-progress-label">${Math.round(clamped)}%</span>
  </div>`;
}

function metadataMarkup(rows) {
  if (!rows.length) return "";

  const items = rows
    .map((row) => {
      const value =
        row.value != null
          ? `<span class="ctx-menu-meta-value">${escapeHtml(String(row.value))}</span>`
          : "";

      const progress =
        typeof row.progress === "number"
          ? `<div class="ctx-menu-meta-progress">
              <div class="ctx-menu-meta-progress-fill" style="width: ${Math.min(100, Math.max(0, row.progress))}%"></div>
            </div>`
          : "";

      return `<div class="ctx-menu-meta-row">
        <div class="ctx-menu-meta-line">
          <span class="ctx-menu-meta-label">${escapeHtml(row.label)}</span>
          ${value}
        </div>
        ${progress}
      </div>`;
    })
    .join("");

  return `<div class="ctx-menu-meta" aria-hidden="true">
    <span class="ctx-menu-meta-head">
      <span class="ctx-menu-meta-dot" aria-hidden="true"></span>
      <span class="ctx-menu-meta-title">Details</span>
    </span>
    <div class="ctx-menu-meta-body">${items}</div>
  </div>`;
}

function onClick() {
  if (this.disabled || this.classList.contains("is-readonly")) return;
  fetchNui("select", [this.targetType, this.targetId, this.zoneId]);
}

export function createOptions(type, data, id, zoneId, listEl) {
  if (data.hide) return null;

  const hasSubmenu = !!data.openMenu;
  const isGoBack = data.name === "builtin:goback";
  const readOnly = !!data.readOnly;
  const interactive = !data.disabled && !readOnly;
  const hasDescription = !!data.description;
  const hasProgress = typeof data.progress === "number";
  const multiline = hasDescription || hasProgress;
  const showArrow = hasSubmenu || !!data.arrow;
  const showIcon = !!(data.image || data.icon);
  const metaRows = toMetaRows(data.metadata);

  const row = document.createElement("div");
  row.className = "ctx-menu-item";
  row.dataset.cindex = String(listEl.querySelectorAll(".ctx-menu-item:not(.is-hidden)").length);
  if (isGoBack) row.classList.add("is-hidden");

  const button = document.createElement("button");
  button.type = "button";
  button.className = "group ctx-menu-item-btn";
  if (multiline) button.classList.add("is-multiline");
  if (data.disabled) button.disabled = true;
  if (readOnly) button.classList.add("is-readonly");

  button.targetType = type;
  button.targetId = id;
  button.zoneId = zoneId;
  button.dataset.name = data.name || "";
  button.dataset.interactive = interactive ? "1" : "0";

  button.innerHTML = `
    ${showIcon ? iconFrameMarkup(data.icon, data.iconColor, data.image) : ""}
    <span class="ctx-menu-item-copy">
      ${data.label ? `<p class="ctx-menu-item-title">${escapeHtml(data.label)}</p>` : ""}
      ${hasDescription ? `<p class="ctx-menu-item-desc">${escapeHtml(data.description)}</p>` : ""}
      ${progressMarkup(data.progress, data.colorScheme)}
    </span>
    ${showArrow && !isGoBack ? '<span class="ctx-menu-item-arrow" aria-hidden="true"><i class="fa-solid fa-chevron-right fa-fw"></i></span>' : ""}
  `;

  button.addEventListener("click", onClick);
  row.appendChild(button);
  if (metaRows.length) row.insertAdjacentHTML("beforeend", metadataMarkup(metaRows));
  listEl.appendChild(row);

  return row;
}

export function findGoBackOption() {
  return document.querySelector('.ctx-menu-item-btn[data-name="builtin:goback"]');
}
