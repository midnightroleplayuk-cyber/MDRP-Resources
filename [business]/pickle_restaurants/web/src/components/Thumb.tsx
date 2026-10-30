import { useEffect, useState } from "react";
import { cn } from "@/lib/utils";
import { ImageOff } from "lucide-react";

/**
 * THE item thumbnail for the desktop NUI. Anywhere a menu entry, recipe, sellable
 * or ingredient is named, its picture goes next to it — a codename or a label alone
 * is not enough to tell a burger from a burnt patty at a glance.
 *
 * Url-based: the server already resolves every item/food image to a direct `nui://`
 * (or http) url, so a caller that has the entry has the picture. The sibling
 * `ItemImage`/`EntryThumb` in components/editors.tsx resolve a picture from an item
 * NAME against the catalogue (plus the admin's custom overrides) — use those when all
 * you hold is a codename; use this when the payload already carries the url.
 *
 * A missing or broken url degrades to a neutral placeholder rather than a gap, so a
 * row's layout never shifts depending on whether the art loaded.
 */
export default function Thumb({ src, alt, className }: { src?: string; alt?: string; className?: string }) {
  const [broken, setBroken] = useState(false);
  useEffect(() => setBroken(false), [src]); // a different url gets a fresh try
  if (!src || broken) {
    return (
      <div className={cn("flex items-center justify-center rounded bg-muted/60 text-muted-foreground", className)}>
        <ImageOff className="h-1/2 w-1/2" />
      </div>
    );
  }
  return <img src={src} alt={alt || ""} onError={() => setBroken(true)} className={cn("rounded object-contain", className)} />;
}
