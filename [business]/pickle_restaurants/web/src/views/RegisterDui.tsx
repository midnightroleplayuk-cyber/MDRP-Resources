import { useEffect, useState } from "react";
import { useNuiEvent, fetchNui } from "@/lib/nui";
import { applyTheme } from "@/lib/theme";
import { money, cn } from "@/lib/utils";
import { _L } from "@/lib/locale";
import { ShoppingCart, ClipboardList, X } from "lucide-react";
import { OrderBuilder, arr, type Cat, type Near, type Ticket } from "@/components/OrderBuilder";
import { Tickets } from "@/components/RegisterTickets";

// The staff POS register rendered as a DUI painted onto the counter's own in-world
// screen (modules/register), NOT a full-screen NUI. The Lua drives a virtual cursor
// into this page via SendDuiMouse* + a `registerClick` DOM-dispatch shim, so it
// behaves like a normal clickable page — exactly like the kiosk (views/KioskDui.tsx),
// which this mirrors. VIRTUAL registers keep the full-screen NUI (views/Register.tsx);
// only a PHYSICAL counter's register is this DUI.
//
// Data arrives by SendDuiMessage: "registerData" (the same payload the NUI register
// view gets, plus `orient`), "registerOrders" (the live open-ticket list off the
// server's orders broadcast, forwarded by the Lua while this register is open), and
// "registerReset" (clears the session between cashiers). The order/fulfilment actions
// (sales:createOrder / completeOrder / cancelOrder) still POST through the shared
// components unchanged. "register:exit" asks the Lua to step the player away.
//
// The register screen is SQUARE (see modules/register REGISTER.w == .h), so the layout
// is built for a square surface; the orient transform below is kept (defaulting to
// rot 0) so a rotated/mirrored screen UV can still be corrected in-game.
type Orient = { rot?: number; flipx?: boolean; flipy?: boolean };

export default function RegisterDui() {
  const [data, setData] = useState<any>(null);
  const [orient, setOrient] = useState<Orient>({ rot: 0 });
  const [tab, setTab] = useState<"new" | "tickets">("new");
  const [tickets, setTickets] = useState<Ticket[]>([]);
  const [nonce, setNonce] = useState(0); // remount OrderBuilder to clear the cart
  // The virtual cursor, in UPRIGHT content space [0..1] (the Lua streams it as it
  // moves). CEF doesn't paint its own cursor onto the runtime texture here, so we draw
  // it inside the rotated stage so it stays upright in-world and sits exactly where a
  // click lands (both come from the same vx,vy the Lua sends to SendDuiMouseMove).
  const [cursor, setCursor] = useState<{ x: number; y: number; down?: boolean } | null>(null);

  useNuiEvent("registerData", (d) => {
    setData(d.data ?? null);
    setOrient(d.orient ?? { rot: 0 });
    applyTheme(d.data?.theme ?? null);
    setTickets(arr<Ticket>(d.data?.tickets));
    setTab("new");
    setNonce((n) => n + 1);
  });
  // Live ticket list: the Lua forwards the server's `orders` broadcast for THIS
  // restaurant while the register is open (SendNUIMessage never reaches a DUI).
  useNuiEvent("registerOrders", (d) => setTickets(arr<Ticket>(d?.orders)));
  useNuiEvent("registerCursor", (d) => setCursor({ x: d.x ?? 0.5, y: d.y ?? 0.5, down: !!d.down }));
  // The Lua forwards a click as the SURFACE pixel it lands on; we hit-test that point
  // and dispatch a real DOM mouse sequence there. `elementFromPoint` respects the CSS
  // transform (the stage may be rotated), and the cursor overlay is pointer-events:none
  // so it's skipped. This bypasses CEF's unreliable SendDuiMouseDown/Up entirely.
  useNuiEvent("registerClick", (d) => {
    const px = d.x ?? 0, py = d.y ?? 0;
    const el = document.elementFromPoint(px, py) as HTMLElement | null;
    if (!el) return;
    const opts: MouseEventInit = { bubbles: true, cancelable: true, clientX: px, clientY: py, button: 0, view: window };
    el.dispatchEvent(new MouseEvent("mousedown", opts));
    el.dispatchEvent(new MouseEvent("mouseup", opts));
    el.dispatchEvent(new MouseEvent("click", opts));
  });
  useNuiEvent("registerReset", () => {
    setCursor(null);
    setTab("new");
    setNonce((n) => n + 1);
  });

  // Tell the Lua the moment we've painted, so it binds the runtime texture to a live
  // frame rather than the blank surface the first bind would catch.
  useEffect(() => {
    if (data) fetchNui("register:painted");
  }, [data]);

  // The DUI surface size is the browser viewport (CreateDui w×h — square). A 90/270
  // turn makes the pre-rotation content box swap W/H so it still fills the surface.
  const W = typeof window !== "undefined" ? window.innerWidth : 1024;
  const H = typeof window !== "undefined" ? window.innerHeight : 1024;
  const rot = ((Math.round((orient.rot || 0) / 90) * 90) % 360 + 360) % 360;
  const swap = rot === 90 || rot === 270;
  const DW = swap ? H : W;
  const DH = swap ? W : H;
  const fx = orient.flipx ? -1 : 1;
  const fy = orient.flipy ? -1 : 1;
  const stageStyle: React.CSSProperties = {
    position: "absolute",
    left: "50%",
    top: "50%",
    width: DW,
    height: DH,
    marginLeft: -DW / 2,
    marginTop: -DH / 2,
    transform: `rotate(${rot}deg) scaleX(${fx}) scaleY(${fy})`,
    transformOrigin: "center center",
  };

  const inner = !data ? (
    // Idle placeholder (only shows in the brief gap before the first data push).
    <div className="h-full w-full bg-background" />
  ) : (
    // Root padding keeps the whole UI inside the counter prop's screen bezel.
    <div className="flex h-full w-full flex-col bg-background p-8 text-foreground">
      <div className="flex shrink-0 items-center justify-between gap-3 border-b border-border pb-4">
        <div className="min-w-0">
          <div className="tape text-sm text-primary">{_L("register.title")}</div>
          <div className="truncate font-display text-3xl font-semibold leading-tight">{data.label || ""}</div>
        </div>
        {/* Staff-only chrome — hidden on the always-on idle board (no balance in the
            public payload, and nothing to click without a cursor). */}
        {!data.idle && (
          <div className="flex shrink-0 items-center gap-3">
            {data.balance != null && (
              <div className="text-right">
                <div className="tape text-[11px] text-muted-foreground">{_L("register.balance")}</div>
                <div className="font-mono text-xl font-bold tabular-nums">{money(data.balance)}</div>
              </div>
            )}
            <button onClick={() => fetchNui("register:exit")}
              className="grid h-12 w-12 shrink-0 place-items-center rounded-full text-muted-foreground transition-colors hover:bg-accent hover:text-foreground">
              <X className="h-7 w-7" />
            </button>
          </div>
        )}
      </div>

      {/* tab switch — New Order ⇄ Tickets (big targets for the virtual cursor) */}
      <div className="mt-4 flex shrink-0 gap-2">
        <TabBtn active={tab === "new"} onClick={() => setTab("new")} icon={<ShoppingCart className="h-5 w-5" />}>
          {_L("register.new_order")}
        </TabBtn>
        <TabBtn active={tab === "tickets"} onClick={() => setTab("tickets")} icon={<ClipboardList className="h-5 w-5" />}>
          {_L("register.tickets", tickets.length)}
        </TabBtn>
      </div>

      {/* Both panes stay MOUNTED and toggle via CSS so the in-progress cart survives
          a hop to Tickets and back (the `nonce` key still remounts — clearing the
          cart — only on a fresh session: new data or a register reset). */}
      <div className="mt-4 min-h-0 flex-1">
        <div className={cn("h-full", tab !== "new" && "hidden")}>
          <OrderBuilder
            key={nonce}
            id={data.restaurantId}
            catalog={arr<Cat>(data.catalog)}
            nearby={arr<Near>(data.nearby)}
            mode="register"
            big
          />
        </div>
        <div className={cn("h-full", tab !== "tickets" && "hidden")}>
          <Tickets id={data.restaurantId} tickets={tickets} big />
        </div>
      </div>
    </div>
  );

  return (
    <div className="absolute inset-0 overflow-hidden bg-background">
      <div style={stageStyle}>
        {inner}
        {cursor && (
          <div style={{ position: "absolute", left: cursor.x * DW, top: cursor.y * DH, pointerEvents: "none", zIndex: 9999 }}>
            {/* Classic pointer arrow, tip at (0,0). White fill + dark outline reads on
                any brand colour; dims to grey while Lua reports the button held. */}
            <svg width="26" height="32" viewBox="0 0 16 20" style={{ display: "block", filter: "drop-shadow(0 1px 2px rgba(0,0,0,0.55))" }}>
              <path
                d="M0.6 0.6 L0.6 15.2 L4.5 11.6 L7.1 17.6 L9.6 16.5 L7.0 10.8 L13.2 10.8 Z"
                fill={cursor.down ? "#9ca3af" : "#ffffff"}
                stroke="#111111"
                strokeWidth="1.1"
                strokeLinejoin="round"
              />
            </svg>
          </div>
        )}
      </div>
    </div>
  );
}

function TabBtn({ active, onClick, icon, children }: { active: boolean; onClick: () => void; icon: React.ReactNode; children: React.ReactNode }) {
  return (
    <button onClick={onClick}
      className={cn("inline-flex flex-1 items-center justify-center gap-2 rounded-xl border py-3 text-lg font-semibold transition-colors",
        active ? "border-primary bg-primary/15 text-primary" : "border-border text-muted-foreground hover:bg-accent hover:text-foreground")}>
      {icon} {children}
    </button>
  );
}
