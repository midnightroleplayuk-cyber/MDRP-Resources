import { Image, type ImageProps } from "@mantine/core";
import { useMemo, useState } from "react";
export const DEFAULT_ITEM_IMAGE = "./item_default.png";
const DEFAULT_FORMATS = ["png", "webp"];

let itemImageFormats: string[] = [...DEFAULT_FORMATS];

export const setItemImageFormats = (formats?: unknown) => {
  if (!Array.isArray(formats)) return;
  const clean = formats
    .filter((f): f is string => typeof f === "string" && f.trim().length > 0)
    .map((f) => f.trim().replace(/^\./, "").toLowerCase());
  if (clean.length > 0) itemImageFormats = clean;
};

export const getItemImageFormats = () => [...itemImageFormats];

const HAS_EXTENSION = /\.(png|webp|jpe?g|gif|svg|avif)(\?.*)?$/i;
const IS_URL = /^(https?:|nui:|data:|blob:|\.?\/)/i;

const resolvedCache = new Map<string, string>();

export const buildItemImageCandidates = (
  inventory: string | undefined | null,
  name: string | undefined | null,
  image?: string | null,
): string[] => {
  const list: string[] = [];

  if (typeof image === "string" && image.trim().length > 1) {
    list.push(image.trim());
  }

  if (typeof name === "string" && name.trim().length > 0) {
    const n = name.trim();
    if (IS_URL.test(n)) {
      list.push(n);
    } else if (HAS_EXTENSION.test(n)) {
      list.push(`https://cfx-nui-${inventory ?? ""}${n}`);
    } else {
      for (const ext of itemImageFormats) {
        list.push(`https://cfx-nui-${inventory ?? ""}${n}.${ext}`);
      }
    }
  }

  list.push(DEFAULT_ITEM_IMAGE);
  return list;
};

export interface ItemImageProps
  extends Omit<ImageProps, "src" | "fallbackSrc"> {
  /** Inventory images path, e.g. "ox_inventory/web/images/" */
  inventory?: string | null;
  /** Item name (without extension) */
  name?: string | null;
  /** Optional custom image URL (metadata / av_items image column) */
  image?: string | null;
  /** Force the default placeholder (e.g. custom cashier items) */
  useDefault?: boolean;
  alt?: string;
}

const initialIndex = (key: string, candidates: string[]) => {
  const cached = resolvedCache.get(key);
  if (!cached) return 0;
  const i = candidates.indexOf(cached);
  return i >= 0 ? i : 0;
};

export const ItemImage = ({
  inventory,
  name,
  image,
  useDefault,
  alt,
  ...props
}: ItemImageProps) => {
  const candidates = useMemo(
    () =>
      useDefault
        ? [DEFAULT_ITEM_IMAGE]
        : buildItemImageCandidates(inventory, name, image),
    [inventory, name, image, useDefault],
  );
  const key = candidates.join("|");

  const [state, setState] = useState(() => ({
    key,
    index: initialIndex(key, candidates),
  }));

  // Reset when the item changes (derive-state-from-props pattern)
  let index = state.index;
  if (state.key !== key) {
    index = initialIndex(key, candidates);
    setState({ key, index });
  }

  const src = candidates[Math.min(index, candidates.length - 1)];
  const isLast = index >= candidates.length - 1;

  return (
    <Image
      {...props}
      alt={alt ?? (typeof name === "string" ? name : undefined)}
      src={src}
      onLoad={() => {
        if (!isLast) resolvedCache.set(key, src);
      }}
      onError={() => {
        if (isLast) return;
        setState((s) =>
          s.key === key && s.index === index ? { key, index: index + 1 } : s,
        );
      }}
    />
  );
};

export default ItemImage;
