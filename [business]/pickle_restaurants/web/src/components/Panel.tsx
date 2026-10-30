import { useState } from "react";
import { X } from "lucide-react";
import { Button } from "@/components/ui/button";
import { PanelContentContext } from "@/components/ui/panel-content";

/**
 * Fixed-size shell for every management panel — a piece of the restaurant's
 * own-brand hardware. The brand hairline across the top edge and the monogram
 * tile carry the franchise identity (both derive live from the theme seed).
 * The frame keeps a constant height regardless of how much content a tab
 * holds — content scrolls inside the body, the window never grows or shrinks.
 */
export default function Panel({
  title,
  subtitle,
  onClose,
  children,
  headerRight,
  width = "max-w-3xl",
}: {
  title: string;
  subtitle?: string;
  onClose: () => void;
  children: React.ReactNode;
  headerRight?: React.ReactNode;
  width?: string;
}) {
  const monogram = (title.trim()[0] || "•").toUpperCase();
  // Published to nested Modals so a dialog's scrim covers only the content area
  // below the header. A callback ref into state so the value updates once the
  // element mounts (a Modal opened later then portals into it).
  const [contentEl, setContentEl] = useState<HTMLElement | null>(null);
  return (
    <div className="fixed inset-0 flex items-center justify-center">
      <div
        className={`animate-pop-in flex h-[86vh] max-h-[760px] min-h-[480px] w-full ${width} flex-col overflow-hidden rounded-lg border border-border bg-background shadow-2xl`}
      >
        <div className="brand-hairline h-0.5 shrink-0" />
        <div className="flex shrink-0 items-center justify-between gap-3 border-b border-border/80 bg-card px-5 py-3">
          <div className="flex min-w-0 items-center gap-3">
            <div className="grid h-9 w-9 shrink-0 place-items-center rounded-md bg-primary/15 font-display text-lg font-bold text-primary">
              {monogram}
            </div>
            <div className="min-w-0">
              <h2 className="truncate font-display text-lg font-bold leading-tight tracking-tight">{title}</h2>
              {subtitle && <p className="tape truncate">{subtitle}</p>}
            </div>
          </div>
          <div className="flex shrink-0 items-center gap-2">
            {headerRight}
            <Button variant="ghost" size="icon" onClick={onClose}>
              <X className="h-4 w-4" />
            </Button>
          </div>
        </div>
        {/* Content region below the header. A non-scrolling `relative` wrapper
            bounds it so a nested Modal (portaled into it via context) overlays
            exactly this area and stays put while the inner list scrolls. */}
        <div ref={setContentEl} className="relative flex min-h-0 flex-1 flex-col">
          <div className="flex min-h-0 flex-1 flex-col overflow-y-auto p-5">
            <PanelContentContext.Provider value={contentEl}>{children}</PanelContentContext.Provider>
          </div>
        </div>
      </div>
    </div>
  );
}
