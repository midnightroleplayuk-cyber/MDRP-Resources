import { useEffect, useState } from "react";
import { useNuiEvent } from "@/lib/nui";
import { cn } from "@/lib/utils";
import { _L } from "@/lib/locale";
import { ClipboardList, ChevronDown, Check, Clock, ImageOff, Ban } from "lucide-react";
import TicketTimer from "@/components/TicketTimer";
import { channelIcon, channelLabel, isDelivery } from "@/lib/orders";

type LineMod = { label: string; image?: string; color?: string; added?: boolean; removed?: boolean };
type Line = { label: string; qty: number; image?: string; mods?: LineMod[] };
// `ready` = completable at all (singles alone OR using one of the pool's meals), so a
// meal sitting on the tray counts toward readiness. Falls back to `ok` for safety.
type Fulfill = { ok: boolean; ready?: boolean; missing?: string[] };
// `npc` walk-ins carry a patience countdown (`expiresIn` seconds left at send time,
// ticked down locally; `patience` = the full window for the radial). Player tickets
// have neither.
// `channel` is how the order arrived (delivery / pickup / dine_in / walk_in), resolved
// server-side by OrderChannel — `npc` is orthogonal (an AI customer can order delivery).
type Ticket = { orderId: number; ticket: number; customer: string; lines: Line[]; fulfill?: Fulfill; npc?: boolean; expiresIn?: number; patience?: number; channel?: string; orderType?: string; address?: string };

// Coerce a server list to a real array (Lua encodes an empty list as `{}`).
const arr = <T,>(x: unknown): T[] => (Array.isArray(x) ? (x as T[]) : []);
// Ready = completable by any means (prefer the meal-aware `ready`, fall back to `ok`).
const isReady = (f?: Fulfill) => !!(f?.ready ?? f?.ok);

// Inventory thumbnail from a nui:// url the server resolved, with a graceful
// fallback (inventories store images differently, and a value can be missing).
function Thumb({ src, className }: { src?: string; className?: string }) {
  const [broken, setBroken] = useState(false);
  useEffect(() => setBroken(false), [src]);
  if (!src || broken) {
    return (
      <div className={cn("flex items-center justify-center rounded-sm bg-muted/60 text-muted-foreground", className)}>
        <ImageOff className="h-1/2 w-1/2" />
      </div>
    );
  }
  return <img src={src} onError={() => setBroken(true)} className={cn("rounded-sm object-contain", className)} />;
}

// One topping chip: the modifier's item image (or a colour swatch), captioned by
// its name on hover. A removed default is dimmed + crossed out.
function ModDot({ m, size = "sm" }: { m: LineMod; size?: "sm" | "md" }) {
  const box = size === "md" ? "h-5 w-5" : "h-4 w-4";
  const dot = size === "md" ? "h-3 w-3" : "h-2.5 w-2.5";
  return (
    <span
      title={(m.removed ? _L("register.opt_no") + " " : "") + m.label}
      className={cn(
        "relative flex shrink-0 items-center justify-center overflow-hidden rounded-sm border",
        box,
        m.removed ? "border-destructive/50" : "border-border/70 bg-muted",
      )}
    >
      {m.image
        ? <Thumb src={m.image} className={cn("h-full w-full", m.removed && "opacity-40")} />
        : m.color
          ? <span className={cn("rounded-full border border-border/60", dot, m.removed && "opacity-40")} style={{ backgroundColor: m.color }} />
          : <span className={cn("rounded-full bg-muted-foreground/40", dot, m.removed && "opacity-40")} />}
      {m.removed && (
        <span className="pointer-events-none absolute inset-0 grid place-items-center text-destructive"><Ban className={dot} /></span>
      )}
    </span>
  );
}

// added extras first, then removed defaults (dimmed/crossed).
const orderMods = (mods: LineMod[]) => [...mods.filter((m) => !m.removed), ...mods.filter((m) => m.removed)];

// The toppings a line carries, as a compact strip of image chips: as many as fit,
// then a "+N" for the rest. Hovering the whole ticket reveals every name in the
// side panel, so this strip is just the at-a-glance summary.
function ModStrip({ mods }: { mods: LineMod[] }) {
  if (mods.length === 0) return null;
  const MAX = 5;
  const shown = mods.slice(0, MAX);
  const overflow = mods.length - shown.length;
  return (
    <div className="mt-1 flex items-center gap-1">
      {shown.map((m, i) => <ModDot key={i} m={m} />)}
      {overflow > 0 && (
        <span className="font-mono text-[9px] font-bold leading-none tabular-nums text-muted-foreground">+{overflow}</span>
      )}
    </div>
  );
}

// A small Ready / Not-ready status pill (shared by the row and the detail panel).
function StatusPill({ ok, missing }: { ok: boolean; missing: string[] }) {
  return (
    <span
      className={cn(
        "flex shrink-0 items-center gap-1 rounded-full px-1.5 py-0.5 text-[10px] font-semibold",
        ok ? "bg-[rgb(var(--ok)/0.15)] text-[rgb(var(--ok))]" : "bg-[rgb(var(--warn)/0.15)] text-[rgb(var(--warn))]",
      )}
      title={!ok && missing.length ? _L("register.missing", missing.join(", ")) : undefined}
    >
      {ok ? <Check className="h-3 w-3" /> : <Clock className="h-3 w-3" />}
      {ok ? _L("widget.ready") : _L("widget.pending")}
    </span>
  );
}

// How the order arrived, as a compact chip: a delivery has to be told apart from a
// counter order at a glance (the kitchen packs it for a driver, not for someone
// standing at the till). Highlighted for a delivery, muted otherwise.
function ChannelChip({ t }: { t: Ticket }) {
  const Icon = channelIcon(t);
  return (
    <span
      title={isDelivery(t) && t.address ? _L("order.delivery_to", t.address) : undefined}
      className={cn("flex shrink-0 items-center gap-1 rounded-sm px-1.5 py-0.5 font-mono text-[9px] font-bold uppercase tracking-wider",
        isDelivery(t) ? "bg-primary/15 text-primary" : "bg-muted text-muted-foreground")}
    >
      <Icon className="h-2.5 w-2.5" /> {channelLabel(t)}
    </span>
  );
}

// The full, un-truncated detail for the hovered ticket, shown to the RIGHT of the
// board: every line with its image + exact name + qty, and each topping spelled out
// (image + name, "No X" for a removed default). Read-only, so it ignores the cursor.
function TicketDetail({ t }: { t: Ticket }) {
  const okReady = isReady(t.fulfill);
  const missing = arr<string>(t.fulfill?.missing);
  return (
    <div className="pointer-events-none absolute left-full top-0 z-[71] ml-2 w-72 select-none rounded-md border border-border bg-card p-3 shadow-2xl">
      <div className="mb-2 flex items-center justify-between gap-2">
        <div className="flex min-w-0 items-center gap-1.5">
          <span className="shrink-0 rounded-sm bg-muted px-1.5 py-0.5 font-mono text-[10px] font-bold uppercase tabular-nums text-muted-foreground">
            {_L("register.ticket_num", t.ticket)}
          </span>
          <span className="truncate text-xs font-semibold text-foreground">{t.customer}</span>
          <ChannelChip t={t} />
        </div>
        <div className="flex shrink-0 items-center gap-1.5">
          {t.npc && t.expiresIn != null && (
            <TicketTimer expiresIn={t.expiresIn} patience={t.patience} size={30} />
          )}
          <StatusPill ok={okReady} missing={missing} />
        </div>
      </div>
      <div className="max-h-[50vh] space-y-2 overflow-y-auto pr-0.5 pb-2">
        {arr<Line>(t.lines).map((l, i) => {
          const mods = orderMods(arr<LineMod>(l.mods));
          return (
            <div key={i} className="flex items-start gap-2 rounded-sm bg-muted/40 p-1.5">
              <Thumb src={l.image} className="mt-0.5 h-9 w-9 shrink-0" />
              <div className="min-w-0 flex-1">
                <div className="flex items-center justify-between gap-2">
                  <span className="truncate text-xs font-medium text-foreground">{l.label}</span>
                  <span className="shrink-0 font-mono text-[10px] tabular-nums text-muted-foreground">×{l.qty}</span>
                </div>
                {mods.length > 0 && (
                  <div className="mt-1 space-y-0.5">
                    {mods.map((m, j) => (
                      <div key={j} className="flex items-center gap-1.5">
                        <ModDot m={m} size="md" />
                        <span className={cn("truncate text-[11px]", m.removed ? "text-destructive line-through" : "text-muted-foreground")}>
                          {(m.removed ? _L("register.opt_no") + " " : "") + m.label}
                        </span>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            </div>
          );
        })}
      </div>
      {!okReady && missing.length > 0 && (
        <div className="mt-2 rounded-sm bg-[rgb(var(--warn)/0.12)] px-2 py-1.5 text-[11px] font-medium text-[rgb(var(--warn))]">
          {_L("register.missing", missing.join(", "))}
        </div>
      )}
    </div>
  );
}

// A persistent, READ-ONLY ticket board pinned top-left in restaurant experiences
// where staff can't reach the register's ticket tab (the kitchen station, the boss
// panel). It shows each pending POS ticket and whether the shared cooked-items pool
// can already complete it (`fulfill.ok`) — staff can SEE readiness but not serve.
// Each line shows its item image + a topping strip; hovering a ticket pops the FULL
// detail (exact names + images) out to the right. Driven entirely by the Lua
// `ticketWidget` message; themed by the app-wide CSS tokens applied on setView.
export default function TicketsWidget() {
  const [show, setShow] = useState(false);
  const [tickets, setTickets] = useState<Ticket[]>([]);
  const [open, setOpen] = useState(false);
  const [hoverId, setHoverId] = useState<number | null>(null);

  useNuiEvent("ticketWidget", (d) => {
    const on = d?.show === true;
    setShow(on);
    if (d?.tickets !== undefined) setTickets(arr<Ticket>(d.tickets));
    if (!on) setOpen(false);
  });
  // A closed experience clears the board so a stale list can't flash on reopen.
  useEffect(() => { if (!show) setTickets([]); }, [show]);
  useEffect(() => { if (!open) setHoverId(null); }, [open]);

  if (!show) return null;

  const ready = tickets.filter((t) => isReady(t.fulfill)).length;
  const hovered = hoverId != null ? tickets.find((t) => t.orderId === hoverId) : undefined;

  return (
    <div className="fixed left-3 top-3 z-[70] w-64 select-none font-sans">
      {/* header pill — click to expand the pending list */}
      <button
        onClick={() => setOpen((o) => !o)}
        className={cn(
          "flex w-full items-center gap-2 rounded-md border border-border bg-card px-3 py-2 text-left shadow-xl transition-colors hover:bg-accent/60",
          open && "rounded-b-none",
        )}
      >
        <ClipboardList className="h-4 w-4 shrink-0 text-primary" />
        <span className="text-sm font-semibold text-foreground">{_L("widget.tickets")}</span>
        <span className="ml-1 rounded-full bg-muted px-1.5 py-0.5 font-mono text-[10px] font-bold tabular-nums text-muted-foreground">
          {tickets.length}
        </span>
        {tickets.length > 0 && (
          <span className="flex items-center gap-1 font-mono text-[10px] font-bold tabular-nums text-[rgb(var(--ok))]">
            <Check className="h-3 w-3" /> {ready}
          </span>
        )}
        <ChevronDown className={cn("ml-auto h-4 w-4 shrink-0 text-muted-foreground transition-transform", open && "rotate-180")} />
      </button>

      {open && (
        <div className="max-h-[60vh] overflow-y-auto rounded-b-md border border-t-0 border-border bg-card shadow-xl">
          {tickets.length === 0 ? (
            <div className="px-3 py-4 text-center text-xs text-muted-foreground">{_L("widget.none")}</div>
          ) : (
            <div className="divide-y divide-border">
              {tickets.map((t) => {
                const okReady = isReady(t.fulfill);
                const missing = arr<string>(t.fulfill?.missing);
                return (
                  <div
                    key={t.orderId}
                    onMouseEnter={() => setHoverId(t.orderId)}
                    onMouseLeave={() => setHoverId((h) => (h === t.orderId ? null : h))}
                    className={cn("px-3 py-2 transition-colors", hoverId === t.orderId && "bg-accent/50")}
                  >
                    <div className="mb-1.5 flex items-center justify-between gap-2">
                      <div className="flex min-w-0 items-center gap-1.5">
                        <span className="shrink-0 rounded-sm bg-muted px-1.5 py-0.5 font-mono text-[10px] font-bold uppercase tabular-nums text-muted-foreground">
                          {_L("register.ticket_num", t.ticket)}
                        </span>
                        <span className="truncate text-xs font-medium text-foreground">{t.customer}</span>
                        <ChannelChip t={t} />
                      </div>
                      <div className="flex shrink-0 items-center gap-1.5">
                        {t.npc && t.expiresIn != null && (
                          <TicketTimer expiresIn={t.expiresIn} patience={t.patience} size={26} />
                        )}
                        <StatusPill ok={okReady} missing={missing} />
                      </div>
                    </div>
                    <div className="space-y-1">
                      {arr<Line>(t.lines).map((l, i) => {
                        const mods = orderMods(arr<LineMod>(l.mods));
                        return (
                          <div key={i} className="flex items-start gap-2">
                            <Thumb src={l.image} className="mt-0.5 h-7 w-7 shrink-0" />
                            <div className="min-w-0 flex-1">
                              <div className="flex items-center justify-between gap-2">
                                <span className="truncate text-[11px] font-medium text-foreground">{l.label}</span>
                                <span className="shrink-0 font-mono text-[10px] tabular-nums text-muted-foreground">×{l.qty}</span>
                              </div>
                              <ModStrip mods={mods} />
                            </div>
                          </div>
                        );
                      })}
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>
      )}

      {/* full detail for the hovered ticket, popped out to the right of the board */}
      {open && hovered && <TicketDetail t={hovered} />}
    </div>
  );
}
