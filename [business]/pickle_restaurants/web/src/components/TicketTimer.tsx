import { useEffect, useRef, useState } from "react";
import { cn } from "@/lib/utils";

// Live patience countdown for an NPC ticket: a depleting radial ring wrapped around
// an M:SS / Ns label. The server sends `expiresIn` (seconds left at send time) and
// `patience` (the full window — the ring's denominator); we tick DOWN locally from
// the moment each fresh value arrives, so the ring drains smoothly between the sparse
// `orders` broadcasts (the same "server duration -> local tick" approach the cooking
// tray's freshness countdown uses — server os.time() and the NUI clock never have to
// agree). Colour escalates brand -> warn -> danger as the customer runs out of
// patience. Only render this for NPC tickets that carry a timer.
//
// Tokens only (rgb(var(--…))): CEF here predates color-mix()/relative color, so the
// urgency colours come straight from the theme-planted --brand/--warn/--danger.
export default function TicketTimer({
  expiresIn,
  patience,
  size = 34,
  className,
}: {
  expiresIn: number;
  patience?: number;
  size?: number;
  className?: string;
}) {
  // Re-baseline the local clock every time a fresh server value lands.
  const baseRef = useRef({ at: Date.now(), secs: expiresIn });
  const [nowMs, setNowMs] = useState(() => Date.now());
  useEffect(() => {
    baseRef.current = { at: Date.now(), secs: expiresIn };
    setNowMs(Date.now());
  }, [expiresIn]);
  useEffect(() => {
    const t = window.setInterval(() => setNowMs(Date.now()), 500);
    return () => window.clearInterval(t);
  }, []);

  const remaining = Math.max(0, baseRef.current.secs - (nowMs - baseRef.current.at) / 1000);
  const total = patience && patience > 0 ? patience : Math.max(expiresIn, 1);
  const frac = Math.max(0, Math.min(1, remaining / total));
  const secs = Math.ceil(remaining);
  const label = secs >= 60 ? `${Math.floor(secs / 60)}:${String(secs % 60).padStart(2, "0")}` : `${secs}s`;

  // brand while there's plenty of time, warn under half, danger in the last fifth.
  const tone = frac <= 0.2 ? "var(--danger)" : frac <= 0.5 ? "var(--warn)" : "var(--brand)";
  const stroke = 3;
  const rad = (size - stroke - 1) / 2;
  const circ = 2 * Math.PI * rad;

  return (
    <span
      className={cn("relative inline-grid shrink-0 place-items-center", className)}
      style={{ width: size, height: size }}
      title={label}
    >
      <svg width={size} height={size} className="-rotate-90" aria-hidden>
        <circle cx={size / 2} cy={size / 2} r={rad} fill="none" stroke="rgb(var(--line))" strokeWidth={stroke} />
        <circle
          cx={size / 2}
          cy={size / 2}
          r={rad}
          fill="none"
          stroke={`rgb(${tone})`}
          strokeWidth={stroke}
          strokeLinecap="round"
          strokeDasharray={circ}
          strokeDashoffset={circ * (1 - frac)}
          style={{ transition: "stroke-dashoffset 0.5s linear, stroke 0.3s linear" }}
        />
      </svg>
      <span
        className="absolute font-mono font-bold leading-none tabular-nums"
        style={{ fontSize: size <= 30 ? 8 : 9, color: `rgb(${tone})` }}
      >
        {label}
      </span>
    </span>
  );
}
