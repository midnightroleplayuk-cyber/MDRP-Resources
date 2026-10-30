import { useEffect, type ReactNode } from "react";
import { createPortal } from "react-dom";
import { X } from "lucide-react";
import { cn } from "@/lib/utils";
import { Truncate } from "@/components/ui/truncate";
import { usePanelContent } from "@/components/ui/panel-content";
import { _L } from "@/lib/locale";

// A centered dialog over a faded scrim. Inside a Panel it portals into the
// panel's content region (published via context), so the scrim covers only the
// area below the header — not the panel chrome or the rest of the screen. Used
// outside a Panel it falls back to a full-viewport overlay on <body>. The scrim
// fades in; the dialog rises + scales in. Closes on the X, a scrim click, or
// Escape. CEF has no backdrop-filter (it composites to an opaque black rectangle
// on a transparent page — see CLAUDE.md), so the scrim is a plain translucent
// black fill, never a blur.
export function Modal({
  open, onClose, title, subtitle, icon, children, footer, size = "md",
}: {
  open: boolean;
  onClose: () => void;
  title: ReactNode;
  subtitle?: ReactNode;
  icon?: ReactNode;
  children: ReactNode;
  footer?: ReactNode;
  size?: "md" | "lg" | "xl";
}) {
  const container = usePanelContent();

  useEffect(() => {
    if (!open) return;
    const onKey = (e: KeyboardEvent) => { if (e.key === "Escape") { e.stopPropagation(); onClose(); } };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [open, onClose]);

  if (!open) return null;
  const maxW = size === "xl" ? "max-w-3xl" : size === "lg" ? "max-w-2xl" : "max-w-lg";

  return createPortal(
    <div
      className={cn(
        "inset-0 z-[120] flex items-center justify-center bg-black/70 p-4 animate-scrim",
        // scoped to the panel content area when inside a Panel, else full screen
        container ? "absolute" : "fixed",
      )}
      onMouseDown={(e) => { if (e.target === e.currentTarget) onClose(); }}
      role="dialog"
      aria-modal="true"
    >
      <div className={cn("flex max-h-full w-full flex-col overflow-hidden rounded-xl border border-border bg-card shadow-2xl animate-dialog-in", maxW)}>
        <div className="flex shrink-0 items-start justify-between gap-3 border-b border-border px-4 py-3">
          <div className="flex min-w-0 items-center gap-2.5">
            {icon && <div className="shrink-0 text-muted-foreground">{icon}</div>}
            <div className="min-w-0">
              <Truncate className="text-sm font-semibold">{title}</Truncate>
              {subtitle && <Truncate className="mt-0.5 text-[11px] text-muted-foreground">{subtitle}</Truncate>}
            </div>
          </div>
          <button
            onClick={onClose}
            aria-label={_L("ui.close")}
            className="shrink-0 rounded-md p-1 text-muted-foreground transition-colors hover:bg-accent hover:text-foreground"
          >
            <X className="h-4 w-4" />
          </button>
        </div>
        <div className="min-h-0 flex-1 overflow-y-auto px-4 py-4">{children}</div>
        {footer && (
          <div className="flex shrink-0 items-center justify-end gap-2 border-t border-border px-4 py-3">{footer}</div>
        )}
      </div>
    </div>,
    container || document.body,
  );
}
