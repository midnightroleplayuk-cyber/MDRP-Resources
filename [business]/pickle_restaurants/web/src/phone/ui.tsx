import { ReactNode, useEffect, useLayoutEffect, useRef, useState } from "react";
import { createPortal } from "react-dom";
import { ChevronLeft, Star, ImageOff, Loader2 } from "lucide-react";
import { cn } from "../lib/utils";
import { _L } from "../lib/locale";
import { usePhone } from "./store";

// ─── bottom sheet host ───────────────────────────────────────────────────────
// EVERY sheet must render through this. A sheet is `position: absolute; bottom: 0`,
// and .pf-screen animates a `transform` — a transformed ancestor becomes the
// containing block for absolutely-positioned descendants, so a sheet rendered
// inside a screen pinned itself to the bottom of the (tall, scrollable) PAGE
// instead of the viewport: opening the item options put "Add to cart" far below
// the fold, which read as the page jumping to the bottom. Portalling into
// #pf-overlay (a child of .pf-root, outside any screen) keeps every sheet fixed
// to the bottom of the visible phone, whatever the scroll offset.
//
// ENTER *and* EXIT are owned here, so no call site ever writes animation logic.
// Enter is pure CSS (.pf-scrim / .pf-sheet keyframes). Exit is the hard half: every
// call site renders a sheet conditionally (`{sheet && <ItemSheet/>}`), so React rips
// the nodes out of the DOM the instant the state flips — there is nothing left to
// animate, which is why sheets used to just blink away. Rather than force each call
// site to latch its data and keep the sheet mounted, this component snapshots its own
// scrim + sheet on unmount (a deep clone, with scroll offsets carried over so a
// scrolled options list doesn't jump to the top mid-exit), re-parents the ghosts into
// the overlay host, plays the out-animation on them, and drops them. The ghosts are
// inert (pointer-events: none) and sit BELOW a live sheet's z-index, so opening a new
// sheet while the old one leaves never covers the new one.
const SHEET_EXIT_MS = 260;

function copyScroll(from: Element, to: Element) {
  const a = from.querySelectorAll("*");
  const b = to.querySelectorAll("*");
  for (let i = 0; i < a.length && i < b.length; i++) {
    const src = a[i] as HTMLElement;
    if (src.scrollTop || src.scrollLeft) {
      (b[i] as HTMLElement).scrollTop = src.scrollTop;
      (b[i] as HTMLElement).scrollLeft = src.scrollLeft;
    }
  }
  if (from.scrollTop || from.scrollLeft) {
    to.scrollTop = from.scrollTop;
    to.scrollLeft = from.scrollLeft;
  }
}

export function Sheet({
  onClose,
  children,
  className,
}: {
  onClose?: () => void;
  children: ReactNode;
  className?: string;
}) {
  const scrimRef = useRef<HTMLDivElement | null>(null);
  const sheetRef = useRef<HTMLDivElement | null>(null);

  // useLayoutEffect (not useEffect): a passive cleanup can run AFTER React has already
  // detached the nodes, and a detached node reports scrollTop 0. Nodes are captured
  // here in the effect body, never read off the refs at cleanup time (React nulls refs
  // while unmounting the subtree).
  useLayoutEffect(() => {
    const scrim = scrimRef.current;
    const sheet = sheetRef.current;
    return () => {
      const host = document.getElementById("pf-overlay");
      if (!host || !sheet) return;
      const ghosts: HTMLElement[] = [];
      if (scrim) {
        const g = scrim.cloneNode(true) as HTMLElement;
        g.classList.add("pf-out");
        g.style.zIndex = "38";
        ghosts.push(g);
      }
      const g = sheet.cloneNode(true) as HTMLElement;
      g.classList.add("pf-out");
      g.style.zIndex = "39";
      ghosts.push(g);
      copyScroll(sheet, g);
      for (const el of ghosts) {
        el.style.pointerEvents = "none";
        host.appendChild(el);
      }
      // Clones are static snapshots — scrollTop must be re-applied after insertion,
      // since a detached node silently discards the assignment.
      copyScroll(sheet, g);
      const drop = () => {
        for (const el of ghosts) el.remove();
      };
      // StrictMode's dev-only remount fires this cleanup without ever removing the
      // real nodes. One frame later, an original still in the document means this was
      // a simulated unmount, not a close — pull the ghosts back off.
      requestAnimationFrame(() => {
        if (sheet.isConnected) drop();
      });
      window.setTimeout(drop, SHEET_EXIT_MS + 60);
    };
  }, []);

  const body = (
    <>
      <div ref={scrimRef} className="pf-scrim" onClick={onClose} />
      <div ref={sheetRef} className={cn("pf-sheet", className)}>
        {children}
      </div>
    </>
  );
  const host = typeof document !== "undefined" ? document.getElementById("pf-overlay") : null;
  return host ? createPortal(body, host) : body;
}

// ─── screen chrome ───────────────────────────────────────────────────────────
export function TopBar({
  title,
  subtitle,
  onBack,
  right,
  transparent,
}: {
  title?: ReactNode;
  subtitle?: ReactNode;
  onBack?: () => void;
  right?: ReactNode;
  transparent?: boolean;
}) {
  return (
    <div
      className={cn(
        "sticky top-0 z-20 flex items-center gap-2 px-4 py-2.5",
        !transparent && "pf-elev border-b border-border bg-card/95"
      )}
    >
      {onBack && (
        <button
          onClick={onBack}
          className="grid h-9 w-9 shrink-0 place-items-center rounded-full bg-muted text-foreground transition-transform active:scale-90"
        >
          <ChevronLeft className="h-5 w-5" />
        </button>
      )}
      <div className="min-w-0 flex-1">
        {title && (
          <div className="truncate font-display text-[1.05rem] font-extrabold leading-tight">
            {title}
          </div>
        )}
        {subtitle && (
          <div className="truncate text-[0.72rem] text-muted-foreground">{subtitle}</div>
        )}
      </div>
      {right}
    </div>
  );
}

export function Screen({ children, className }: { children: ReactNode; className?: string }) {
  return <div className={cn("pf-screen", className)}>{children}</div>;
}

export function Spinner({ label }: { label?: string }) {
  return (
    <div className="flex flex-col items-center justify-center gap-2 py-16 text-muted-foreground">
      <Loader2 className="h-6 w-6 animate-spin" />
      {label && <div className="text-xs">{label}</div>}
    </div>
  );
}

export function Empty({ icon, title, hint }: { icon?: ReactNode; title: string; hint?: string }) {
  return (
    <div className="flex flex-col items-center justify-center gap-2 px-8 py-14 text-center">
      {icon && <div className="mb-1 text-muted-foreground/70">{icon}</div>}
      <div className="font-display text-base font-bold">{title}</div>
      {hint && <div className="text-[0.78rem] text-muted-foreground">{hint}</div>}
    </div>
  );
}

// ─── bits ────────────────────────────────────────────────────────────────────
export function ItemImg({
  src,
  alt,
  className,
}: {
  src?: string;
  alt?: string;
  className?: string;
}) {
  if (!src)
    return (
      <div className={cn("grid place-items-center bg-muted text-muted-foreground/50", className)}>
        <ImageOff className="h-5 w-5" />
      </div>
    );
  return (
    <img
      src={src}
      alt={alt}
      className={cn("object-cover", className)}
      onError={(e) => ((e.target as HTMLImageElement).style.visibility = "hidden")}
    />
  );
}

export function Stars({
  value,
  size = 14,
  onPick,
}: {
  value: number;
  size?: number;
  onPick?: (n: number) => void;
}) {
  return (
    <div className="flex items-center gap-0.5">
      {[1, 2, 3, 4, 5].map((n) => {
        const filled = value >= n - 0.25;
        return (
          <Star
            key={n}
            onClick={onPick ? () => onPick(n) : undefined}
            className={cn(onPick && "pf-star", filled ? "text-warn" : "text-muted-foreground/40")}
            style={{ width: size, height: size }}
            fill={filled ? "currentColor" : "none"}
          />
        );
      })}
    </div>
  );
}

export function Rating({ value, count }: { value: number; count?: number }) {
  return (
    <span className="inline-flex items-center gap-1 text-[0.74rem] font-semibold">
      <Star className="h-3 w-3 text-warn" fill="currentColor" />
      {value > 0 ? value.toFixed(1) : _L("phone.rating.new")}
      {count != null && count > 0 && (
        <span className="text-muted-foreground">({count})</span>
      )}
    </span>
  );
}

export function PromoTag({ label }: { label: string }) {
  return (
    <span className="tape rounded-full bg-brand px-2 py-0.5 text-[0.6rem] text-brand-ink">
      {label}
    </span>
  );
}

// The signature loyalty punch-card.
export function PunchCard({ punches, goal }: { punches: number; goal: number }) {
  const done = punches % goal;
  const free = punches >= goal;
  return (
    <div className="pf-punch">
      {Array.from({ length: goal }).map((_, i) => {
        const on = i < (free ? goal : done);
        const isFreeSlot = i === goal - 1;
        return (
          <div
            key={i}
            className={cn("pf-hole", on && "on", isFreeSlot && free && "free")}
            title={isFreeSlot ? _L("phone.punch.free_item") : _L("phone.punch.n", i + 1)}
          >
            {isFreeSlot ? "★" : on ? "" : i + 1}
          </div>
        );
      })}
    </div>
  );
}

// A tappable pill.
export function Pill({
  active,
  children,
  onClick,
}: {
  active?: boolean;
  children: ReactNode;
  onClick?: () => void;
}) {
  return (
    <button
      onClick={onClick}
      className={cn(
        "whitespace-nowrap rounded-full border px-3 py-1.5 text-[0.76rem] font-semibold transition-colors active:scale-95",
        active
          ? "border-brand bg-brand text-brand-ink"
          : "border-border bg-card text-foreground"
      )}
    >
      {children}
    </button>
  );
}

export function money2(n: number) {
  return Math.round(n || 0).toLocaleString();
}

// A CEF-safe input modal (bottom sheet), driven by the store's `ask()`. Mounted once
// by the shell; renders only while a prompt is pending. Replaces window.prompt(), which
// FiveM's CEF silently suppresses.
export function AskModal() {
  const { askState, closeAsk } = usePhone();
  const [val, setVal] = useState("");
  useEffect(() => {
    setVal(askState?.initial != null ? String(askState.initial) : "");
  }, [askState]);
  if (!askState) return null;
  const numeric = askState.kind !== "text";
  const submit = () => closeAsk(val.trim() === "" ? null : val.trim());
  return (
    <Sheet onClose={() => closeAsk(null)}>
      <>
        <div className="pf-grab" />
        <div className="px-4 pt-2" style={{ paddingBottom: "calc(1rem + var(--pf-bottom))" }}>
          <div className="font-display text-lg font-extrabold leading-tight">{askState.title}</div>
          {askState.label && (
            <div className="mb-3 mt-0.5 text-[0.76rem] text-muted-foreground">{askState.label}</div>
          )}
          <div className={cn("mt-3 flex items-center gap-2 rounded-2xl border border-border bg-background px-3", askState.label && "mt-0")}>
            {askState.prefix && (
              <span className="font-mono text-lg font-bold text-muted-foreground">{askState.prefix}</span>
            )}
            <input
              autoFocus
              type={numeric ? "number" : "text"}
              inputMode={numeric ? "numeric" : undefined}
              value={val}
              onChange={(e) => setVal(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === "Enter") submit();
                if (e.key === "Escape") closeAsk(null);
              }}
              placeholder={askState.placeholder}
              className="w-full bg-transparent py-3 font-mono text-lg font-bold outline-none"
            />
          </div>
          <div className="mt-3 flex gap-2">
            <button
              onClick={() => closeAsk(null)}
              className="flex-1 rounded-full bg-muted py-2.5 text-sm font-bold text-muted-foreground active:scale-[0.99]"
            >
              {_L("phone.common.cancel")}
            </button>
            <button
              onClick={submit}
              className="flex-1 rounded-full bg-brand py-2.5 text-sm font-bold text-brand-ink active:scale-[0.99]"
            >
              {askState.confirm || _L("phone.common.confirm")}
            </button>
          </div>
        </div>
      </>
    </Sheet>
  );
}

// A themed toast, mounted once by the shell.
export function Toast() {
  const { toastMsg } = usePhone();
  if (!toastMsg) return null;
  return (
    <div className="pointer-events-none absolute inset-x-0 top-[calc(var(--pf-top)+0.5rem)] z-50 flex justify-center px-4">
      <div
        className={cn(
          "pf-screen rounded-full px-4 py-2 text-[0.8rem] font-semibold shadow-lg",
          toastMsg.tone === "err"
            ? "bg-destructive text-destructive-foreground"
            : "bg-foreground text-background"
        )}
      >
        {toastMsg.msg}
      </div>
    </div>
  );
}
