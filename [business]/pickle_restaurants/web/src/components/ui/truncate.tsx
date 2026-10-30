import { useRef, useState, type ReactNode } from "react";
import { createPortal } from "react-dom";
import { cn } from "@/lib/utils";

// Single-line ellipsis text that reveals the FULL value in a custom tooltip on
// hover — but only when the text is actually clipped (no tooltip noise on short
// values). Native `title` tooltips don't render in FiveM's CEF, hence custom.
// The tooltip portals to <body> with fixed positioning so it escapes any
// overflow-hidden ancestor (modals, scrolling lists) and sits above the modal
// scrim (z-[120]).
const TIP_MAX_W = 320;

export function Truncate({ children, className }: { children: ReactNode; className?: string }) {
  const ref = useRef<HTMLSpanElement>(null);
  const [tip, setTip] = useState<{ x: number; y: number; up: boolean } | null>(null);

  const onEnter = () => {
    const el = ref.current;
    if (!el || el.scrollWidth <= el.clientWidth + 1) return; // not clipped — no tooltip
    const r = el.getBoundingClientRect();
    const up = r.bottom + 48 > window.innerHeight; // flip above when near the bottom edge
    setTip({
      x: Math.max(8, Math.min(r.left, window.innerWidth - TIP_MAX_W - 8)),
      y: up ? r.top - 6 : r.bottom + 6,
      up,
    });
  };

  return (
    <>
      <span
        ref={ref}
        className={cn("block min-w-0 truncate", className)}
        onMouseEnter={onEnter}
        onMouseLeave={() => setTip(null)}
      >
        {children}
      </span>
      {tip &&
        createPortal(
          <div
            className="pointer-events-none fixed z-[200] rounded-md border border-border bg-popover px-2.5 py-1.5 text-xs leading-snug text-foreground shadow-xl"
            style={{ left: tip.x, top: tip.y, maxWidth: TIP_MAX_W, transform: tip.up ? "translateY(-100%)" : undefined }}
          >
            {children}
          </div>,
          document.body,
        )}
    </>
  );
}
