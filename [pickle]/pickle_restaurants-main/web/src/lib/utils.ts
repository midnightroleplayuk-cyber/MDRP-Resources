import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

/**
 * An item's codename made presentable ("cooked_patty" -> "Cooked Patty"). The
 * mirror of Lua's `PrettyItemName`. NOTHING user-facing may print a raw internal
 * key: every "label or the item name" fallback goes through this, so a config
 * with no label degrades to a readable name instead of leaking the codename.
 */
export function prettyItem(name: string | undefined | null) {
  if (!name) return "";
  return String(name).replace(/[_-]+/g, " ").replace(/\b\w/g, (c) => c.toUpperCase());
}

/** The display name for a thing that may carry its own label. */
export function itemLabel(label: string | undefined | null, item?: string | null) {
  return label || prettyItem(item);
}

export function money(n: number | undefined | null) {
  const v = Math.round(Number(n || 0));
  return "$" + v.toLocaleString("en-US");
}
