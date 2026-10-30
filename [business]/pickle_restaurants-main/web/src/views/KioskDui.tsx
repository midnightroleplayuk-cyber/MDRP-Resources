import { useEffect, useRef, useState } from "react";
import { useNuiEvent, fetchNui } from "@/lib/nui";
import { applyTheme } from "@/lib/theme";
import { Button } from "@/components/ui/button";
import { _L } from "@/lib/locale";
import { Check, ShoppingBag } from "lucide-react";
import { OrderBuilder, arr, type Cat } from "@/components/OrderBuilder";

// The restaurant brand the idle kiosk screen shows: a url + optional normalised
// source-crop rectangle (the same { url, crop } the render-target driver paints —
// modules/rendertarget). nil → no brand configured (the idle screen is solid black).
type Brand = { url?: string; crop?: { x: number; y: number; w: number; h: number } } | null;

// Milliseconds the brand cover takes to slide up (reveal) / down (conceal). The Lua
// (modules/kiosk CloseKioskScreen) waits KIOSK.close_ms — keep it >= this so the
// cover has finished sliding down before the screen is handed back to the brand driver.
const SLIDE_MS = 450;

// Paint the brand image so it fills the cover exactly like brand.html does on the idle
// screen: the owner's crop rectangle mapped to fill the surface (else `cover`-centred),
// over a white backdrop for transparent logo areas. nil brand → solid black (the idle
// screen's blackDefault). The kiosk stage already applies the screen orientation, so
// this paints in upright content space just like the menu it slides away to reveal.
function coverStyle(brand: Brand): React.CSSProperties {
  if (!brand || !brand.url) return { background: "#000000" };
  const base: React.CSSProperties = {
    backgroundColor: "#ffffff",
    backgroundImage: `url("${brand.url}")`,
    backgroundRepeat: "no-repeat",
  };
  const c = brand.crop;
  if (c && c.w > 0 && c.h > 0) {
    // Show source rect [x,y,w,h] (normalised) filling the box: scale the image so the
    // crop spans the box, then offset so the crop's top-left lands at the box origin.
    return {
      ...base,
      backgroundSize: `${100 / c.w}% ${100 / c.h}%`,
      backgroundPosition: `${c.w >= 1 ? 0 : (c.x / (1 - c.w)) * 100}% ${c.h >= 1 ? 0 : (c.y / (1 - c.h)) * 100}%`,
    };
  }
  return { ...base, backgroundSize: "cover", backgroundPosition: "center" };
}

// The self-service kiosk rendered as a DUI painted onto the kiosk's own in-world
// screen (modules/kiosk), NOT a fullscreen NUI. The Lua drives a virtual cursor
// into this page via SendDuiMouse*, so it behaves like a normal clickable page.
//
// Data arrives by SendDuiMessage ("kioskData" with the same payload the old NUI
// order view received, plus `orient`); "kioskReset" clears the cart between
// customers. Placing an order flows through the shared OrderBuilder
// ("sales:kioskOrder", unchanged); the "Done" button asks the Lua to step the
// player away ("kiosk:exit").
//
// ORIENTATION: the kiosk screen's texture can be rotated/mirrored on the model (the
// same rot/flip the brand target paints with — modules/rendertarget). We apply the
// IDENTICAL transform brand.html uses (rotate about centre + flips) so the page
// lands upright on the prop. A 90/270 turn lays the content out LANDSCAPE (surface
// W/H swapped), which is also why the POS gets a proper wide layout there. The Lua
// mirrors this exact transform for the cursor→surface mapping.
type Orient = { rot?: number; flipx?: boolean; flipy?: boolean };

export default function KioskDui() {
  const [data, setData] = useState<any>(null);
  const [orient, setOrient] = useState<Orient>({ rot: 0 });
  const [placed, setPlaced] = useState<number | null>(null);
  const [nonce, setNonce] = useState(0); // remount OrderBuilder to clear the cart
  const [brand, setBrand] = useState<Brand>(null); // idle-screen brand for the reveal
  // The brand cover slides UP to reveal the menu on open, DOWN to conceal it on exit.
  // Starts concealed (covering the menu) so the brand the idle screen was showing
  // appears to persist through the texture swap, then lifts away.
  const [revealed, setRevealed] = useState(false);
  const revealTimer = useRef<ReturnType<typeof setTimeout> | null>(null);
  // The virtual cursor, in UPRIGHT content space [0..1] (the Lua streams it as it
  // moves). CEF doesn't paint its own cursor onto the runtime texture here, so we
  // draw it — inside the rotated stage, so it stays upright in-world and sits exactly
  // where a click lands (both come from the same vx,vy the Lua sends to SendDuiMouseMove).
  const [cursor, setCursor] = useState<{ x: number; y: number; down?: boolean } | null>(null);

  useNuiEvent("kioskData", (d) => {
    setData(d.data ?? null);
    setOrient(d.orient ?? { rot: 0 });
    setBrand((d.data?.brand as Brand) ?? null);
    applyTheme(d.data?.theme ?? null);
    setPlaced(null);
    setNonce((n) => n + 1);
    // Open COVERED (brand down over the menu). The Lua binds the texture to the prop
    // while it's covered, then explicitly asks us to reveal (kioskReveal) once the
    // screen is bound and framed — so the brand cover is the first frame shown and the
    // reveal never races the texture swap (no first-open flash). The timer is only a
    // safety net in case that message is missed.
    setRevealed(false);
    if (revealTimer.current) clearTimeout(revealTimer.current);
    revealTimer.current = setTimeout(() => setRevealed(true), 1500);
  });
  // The Lua lifts the brand cover once the screen is bound + the camera is framed.
  useNuiEvent("kioskReveal", () => {
    if (revealTimer.current) clearTimeout(revealTimer.current);
    setRevealed(true);
  });
  // The Lua asks the page to slide the brand back down over the menu as the player
  // steps away (modules/kiosk CloseKioskScreen), then waits for it before handing the
  // screen back to the idle brand driver — so the conceal is seen and the handoff is
  // seamless (the cover and the idle brand look the same).
  useNuiEvent("kioskClosing", () => {
    if (revealTimer.current) clearTimeout(revealTimer.current);
    setRevealed(false);
  });
  useNuiEvent("kioskCursor", (d) => setCursor({ x: d.x ?? 0.5, y: d.y ?? 0.5, down: !!d.down }));
  // The Lua forwards a click as the SURFACE pixel it lands on; we hit-test that point
  // and dispatch a real DOM mouse sequence there. `elementFromPoint` respects the CSS
  // transform (the stage is rotated), and the cursor overlay is pointer-events:none so
  // it's skipped. This bypasses CEF's unreliable SendDuiMouseDown/Up entirely.
  useNuiEvent("kioskClick", (d) => {
    const px = d.x ?? 0, py = d.y ?? 0;
    const el = document.elementFromPoint(px, py) as HTMLElement | null;
    if (!el) return;
    const opts: MouseEventInit = { bubbles: true, cancelable: true, clientX: px, clientY: py, button: 0, view: window };
    el.dispatchEvent(new MouseEvent("mousedown", opts));
    el.dispatchEvent(new MouseEvent("mouseup", opts));
    el.dispatchEvent(new MouseEvent("click", opts));
  });
  useNuiEvent("kioskReset", () => {
    setPlaced(null);
    setCursor(null);
    setNonce((n) => n + 1);
    // Stay concealed between customers; the next open re-reveals.
    if (revealTimer.current) clearTimeout(revealTimer.current);
    setRevealed(false);
  });

  // Tell the Lua the moment we've painted, so it binds the runtime texture to a
  // live frame rather than the blank surface the first bind would catch.
  useEffect(() => {
    if (data) fetchNui("kiosk:painted");
  }, [data]);

  // The DUI surface size is the browser viewport (CreateDui w×h). A 90/270 turn
  // makes the pre-rotation content box landscape so it still fills the surface.
  const W = typeof window !== "undefined" ? window.innerWidth : 1080;
  const H = typeof window !== "undefined" ? window.innerHeight : 1920;
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
    // Idle placeholder (the brand render target normally owns the screen when we're
    // not open; this only shows in the brief gap before the first data push).
    <div className="h-full w-full bg-background" />
  ) : (
    // Root padding keeps the whole UI inside the kiosk prop's screen bezel, which
    // otherwise clips content at the edges (tune the p-* value in-game to the model).
    <div className="flex h-full w-full flex-col bg-background p-10 text-foreground">
      <div className="flex shrink-0 items-center justify-between gap-3 border-b border-border px-5 py-5">
        <div className="min-w-0">
          <div className="tape text-base text-primary">{_L("order.title")}</div>
          <div className="truncate font-display text-4xl font-semibold leading-tight">{data.label || ""}</div>
        </div>
        <ShoppingBag className="h-11 w-11 shrink-0 text-primary" />
      </div>

      <div className="min-h-0 flex-1">
        {placed !== null ? (
          <div className="flex h-full flex-col items-center justify-center gap-8 p-10 text-center">
            <div className="grid h-32 w-32 place-items-center rounded-full bg-primary/15 text-primary">
              <Check className="h-16 w-16" />
            </div>
            <div>
              <div className="font-display text-5xl font-semibold">{_L("order.placed_title")}</div>
              <div className="mt-3 text-2xl text-muted-foreground">{_L("order.placed_desc", placed)}</div>
            </div>
            <div className="flex gap-4">
              <Button variant="outline" size="lg" className="h-16 px-8 text-xl" onClick={() => { setPlaced(null); setNonce((n) => n + 1); }}>
                {_L("order.another")}
              </Button>
              <Button size="lg" className="h-16 px-8 text-xl" onClick={() => fetchNui("kiosk:exit")}>{_L("order.done")}</Button>
            </div>
          </div>
        ) : (
          <OrderBuilder
            key={nonce}
            id={data.restaurantId}
            catalog={arr<Cat>(data.catalog)}
            mode="kiosk"
            onOrdered={(t) => setPlaced(t ?? 0)}
          />
        )}
      </div>
    </div>
  );

  return (
    <div className="absolute inset-0 overflow-hidden bg-background">
      <div style={stageStyle}>
        {inner}
        {/* Brand cover — slides up to reveal the menu on open, down to conceal on exit.
            Lives in the (already-oriented) stage so it paints upright exactly like the
            menu beneath it and the idle brand it hands off to. */}
        {data && (
          <div
            className="pointer-events-none absolute inset-0 z-40 ease-in-out"
            style={{
              ...coverStyle(brand),
              transitionProperty: "transform",
              transitionDuration: `${SLIDE_MS}ms`,
              transform: revealed ? "translateY(-100%)" : "translateY(0)",
            }}
          />
        )}
        {cursor && (
          <div
            style={{
              position: "absolute",
              left: cursor.x * DW,
              top: cursor.y * DH,
              pointerEvents: "none",
              zIndex: 9999,
            }}
          >
            {/* Classic pointer arrow, tip at (0,0) so it sits on the cursor point.
                White fill + dark outline + drop shadow reads on any brand colour. */}
            <svg width="26" height="32" viewBox="0 0 16 20" style={{ display: "block", filter: "drop-shadow(0 1px 2px rgba(0,0,0,0.55))" }}>
              {/* fill dims to grey while Lua reports the button held — a live check that
                  the click is being detected and forwarded. */}
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
