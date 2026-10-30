import { useEffect, useRef, useState } from "react";
import L from "leaflet";
import "leaflet/dist/leaflet.css";
import "./map.css";
import { fetchNui, useNuiEvent } from "../../lib/nui";
import { _L } from "../../lib/locale";
import {
  EMPTY_TILE_URL,
  MAX_NATIVE_ZOOM,
  MAX_ZOOM,
  MIN_ZOOM,
  TILE_URL,
  mapBounds,
  worldToLatLng,
  type WorldPoint,
} from "./projection";

// The optional `map` key the Lua side stamps onto an order/ticket payload.
export type OrderMapData = {
  restaurant?: WorldPoint;
  dest?: WorldPoint; // delivery only
  type: "delivery" | "pickup";
};

// Auto-fit never zooms past this: a pickup whose restaurant and driver are 40m
// apart would otherwise slam to max zoom and show three featureless blocks.
const FIT_MAX_ZOOM = 3;
const FIT_PADDING: L.PointTuple = [26, 26];
// Driver pings land every ~3s. Tween just under that so the marker is still
// gliding when the next one arrives ("animate, never teleport").
const DRIVER_TWEEN_MS = 2600;

// Marker glyphs — inline lucide-ish SVG so they inherit the pin's `color` token.
// NEVER Leaflet's default PNG markers (wrong look, and they'd need the Vite
// icon-path fix).
const SVG_UTENSILS =
  '<svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M3 2v7a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2V2"/><path d="M6 11v11"/><path d="M18 2c-1.7 1.2-2.5 3-2.5 5.5S16.3 12 18 12v10"/></svg>';
const SVG_HOME =
  '<svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="m3 10 9-7 9 7v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><path d="M9 21v-7h6v7"/></svg>';
// The live driver is a car. Lucide's `car` is drawn low in its 24-box (the body
// sits on wheels near the baseline), so it is NOT optically centred by geometric
// centring alone — the viewBox below is shifted to put the car's visual mass in
// the middle of the pin, which is what the halo rings around.
const SVG_CAR =
  '<svg viewBox="0 1.5 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 17h2v-4.6a1 1 0 0 0-.1-.4l-1.6-3.3A2 2 0 0 0 17.5 7h-11a2 2 0 0 0-1.8 1.1L3.1 12a1 1 0 0 0-.1.4V17h2"/><path d="M5 17h14"/><circle cx="7" cy="17" r="2"/><circle cx="17" cy="17" r="2"/></svg>';

// ONE source of truth for pin geometry: the CSS box, the Leaflet `iconSize` and
// the `iconAnchor` must agree exactly, or the marker sits off its true position
// (and the driver's halo, which centres on the box, reads as off-centre).
const PIN_SIZE = { restaurant: 26, dest: 26, driver: 26 } as const;

function pin(kind: "restaurant" | "dest" | "driver") {
  const size = PIN_SIZE[kind];
  const glyph = kind === "restaurant" ? SVG_UTENSILS : kind === "dest" ? SVG_HOME : SVG_CAR;
  return L.divIcon({
    className: "", // suppress Leaflet's default `.leaflet-div-icon` white box
    html: `<div class="pf-map-pin ${kind}" style="width:${size}px;height:${size}px">${glyph}</div>`,
    iconSize: [size, size],
    iconAnchor: [size / 2, size / 2],
  });
}

/** Ease a marker to `to` over `ms`, cancelling any run already in flight. */
function tweenMarker(marker: L.Marker, to: L.LatLng, ms: number, raf: { id: number }) {
  const from = marker.getLatLng();
  if (raf.id) cancelAnimationFrame(raf.id);
  raf.id = 0;
  // A jump big enough that tweening would read as a glitch (respawn, teleport,
  // a fresh driver taking over) — just place it.
  if (!from || Math.abs(from.lat - to.lat) + Math.abs(from.lng - to.lng) > 40) {
    marker.setLatLng(to);
    return;
  }
  const t0 = performance.now();
  const step = (now: number) => {
    const k = Math.min(1, (now - t0) / ms);
    const e = 1 - (1 - k) * (1 - k); // easeOutQuad — arrives calmly
    marker.setLatLng(
      L.latLng(from.lat + (to.lat - from.lat) * e, from.lng + (to.lng - from.lng) * e)
    );
    raf.id = k < 1 ? requestAnimationFrame(step) : 0;
  };
  raf.id = requestAnimationFrame(step);
}

/**
 * The live order map embedded in the ticket, under the progress stepper.
 * Mount it CONDITIONALLY (`{order.map && <OrderMap …/>}`) — without map data
 * there is nothing to draw, and this way its hooks never run on a plain ticket.
 */
export function OrderMap({ orderId, data }: { orderId: number; data: OrderMapData }) {
  const hostRef = useRef<HTMLDivElement | null>(null);
  const mapRef = useRef<L.Map | null>(null);
  const driverRef = useRef<L.Marker | null>(null);
  const staticRef = useRef<L.LatLng[]>([]); // restaurant + destination pins
  const rafRef = useRef({ id: 0 });

  // Once the user has zoomed/panned by hand, the 3s driver ping must NOT yank
  // the view back — auto-fit switches off until they hit Recenter. The ref is
  // what the (stable) callbacks read; the state only drives the button's
  // visibility.
  const freeRef = useRef(false);
  const [free, setFree] = useState(false);
  // Our OWN camera moves fire `zoomstart`/`dragstart` too, so guard them out.
  const selfMoveRef = useRef(false);

  const markFree = useRef(() => {
    if (selfMoveRef.current || freeRef.current) return;
    freeRef.current = true;
    setFree(true);
  }).current;

  // Fit to everything we currently know about: static pins + the driver.
  // `force` is the Recenter button — it fits even while the user is in control.
  const fit = useRef((force?: boolean) => {
    const map = mapRef.current;
    if (!map) return;
    if (freeRef.current && !force) return;
    const pts = [...staticRef.current];
    const drv = driverRef.current?.getLatLng();
    if (drv) pts.push(drv);
    if (!pts.length) return;
    selfMoveRef.current = true;
    map.fitBounds(L.latLngBounds(pts), {
      padding: FIT_PADDING,
      maxZoom: FIT_MAX_ZOOM,
      animate: false,
    });
    // `animate: false` makes fitBounds synchronous, but a trailing moveend/
    // zoomend can still land in this tick — release the guard after it.
    setTimeout(() => (selfMoveRef.current = false), 0);
  }).current;

  const recenter = useRef(() => {
    freeRef.current = false;
    setFree(false);
    fit(true);
  }).current;

  const zoomBy = useRef((delta: 1 | -1) => {
    const map = mapRef.current;
    if (!map) return;
    markFree(); // a deliberate zoom IS taking control
    if (delta > 0) map.zoomIn();
    else map.zoomOut();
  }).current;

  // ── init / teardown ────────────────────────────────────────────────────────
  useEffect(() => {
    const host = hostRef.current;
    if (!host) return;

    const bounds = mapBounds();
    const map = L.map(host, {
      crs: L.CRS.Simple,
      minZoom: MIN_ZOOM,
      maxZoom: MAX_ZOOM,
      // Leaflet's own control is replaced by our themed buttons below — its
      // stock look is nothing like this app.
      zoomControl: false,
      attributionControl: false,
      // The card sits in a scrolling phone screen — a wheel over it must scroll
      // the screen, not zoom the map. Zooming is the +/- buttons and
      // double-click instead (both explicitly on).
      scrollWheelZoom: false,
      doubleClickZoom: true,
      dragging: true,
      maxBounds: bounds,
      // NOT 1 — a fully solid edge feels like the map is stuck when you drag
      // near it. 0.8 still resists, but the view keeps following the cursor.
      maxBoundsViscosity: 0.8,
    });
    mapRef.current = map;

    L.tileLayer(TILE_URL, {
      tileSize: 256,
      minZoom: MIN_ZOOM,
      // The map goes to MAX_ZOOM but the pyramid stops here — Leaflet upscales
      // the z4 images past this rather than 404ing into `errorTileUrl`.
      maxNativeZoom: MAX_NATIVE_ZOOM,
      maxZoom: MAX_ZOOM,
      noWrap: true,
      bounds,
      errorTileUrl: EMPTY_TILE_URL,
      attribution: "",
      keepBuffer: 1,
    }).addTo(map);

    selfMoveRef.current = true;
    map.fitBounds(bounds);
    selfMoveRef.current = false;

    // Anything that isn't one of OUR camera moves means the user took over.
    map.on("zoomstart", markFree);
    map.on("dragstart", markFree);

    // Leaflet sizes itself off the container at construction time. This card is
    // inside `.pf-screen`, which ANIMATES IN — at mount the host can still be
    // mid-transform / zero-height, and the map then renders as a grey sliver
    // forever. Re-measure once the layout settles, and keep watching the box.
    const settle = () => mapRef.current?.invalidateSize({ animate: false });
    const raf = requestAnimationFrame(settle);
    const t1 = window.setTimeout(settle, 120);
    const t2 = window.setTimeout(settle, 400);
    const ro = typeof ResizeObserver !== "undefined" ? new ResizeObserver(settle) : null;
    ro?.observe(host);

    return () => {
      cancelAnimationFrame(raf);
      if (rafRef.current.id) cancelAnimationFrame(rafRef.current.id);
      window.clearTimeout(t1);
      window.clearTimeout(t2);
      ro?.disconnect();
      map.remove(); // the ticket screen mounts/unmounts as the user navigates
      mapRef.current = null;
      driverRef.current = null;
    };
  }, []);

  // ── static markers (restaurant / destination) ──────────────────────────────
  const rx = data.restaurant?.x;
  const ry = data.restaurant?.y;
  const dx = data.dest?.x;
  const dy = data.dest?.y;

  useEffect(() => {
    const map = mapRef.current;
    if (!map) return;
    const layers: L.Marker[] = [];
    const pts: L.LatLng[] = [];

    if (rx != null && ry != null) {
      const at = worldToLatLng(rx, ry);
      pts.push(at);
      layers.push(L.marker(at, { icon: pin("restaurant"), interactive: false }).addTo(map));
    }
    if (data.type === "delivery" && dx != null && dy != null) {
      const at = worldToLatLng(dx, dy);
      pts.push(at);
      layers.push(L.marker(at, { icon: pin("dest"), interactive: false }).addTo(map));
    }
    staticRef.current = pts;
    fit();

    return () => {
      for (const l of layers) l.remove();
    };
  }, [rx, ry, dx, dy, data.type, fit]);

  // ── draw helpers (shared by the live events and the mount seed) ────────────
  // Stable refs, not inline handlers: the seed effect below must be able to call
  // exactly what the events call, without re-running when they'd be re-created.
  const applyDriver = useRef((x: number, y: number) => {
    const map = mapRef.current;
    if (!map) return;
    const at = worldToLatLng(x, y);
    if (!driverRef.current) {
      driverRef.current = L.marker(at, {
        icon: pin("driver"),
        interactive: false,
        zIndexOffset: 500,
      }).addTo(map);
      fit();
    } else {
      tweenMarker(driverRef.current, at, DRIVER_TWEEN_MS, rafRef.current);
    }
  }).current;

  // ── live driver position ───────────────────────────────────────────────────
  useNuiEvent("driverCoords", (d: any) => {
    if (d?.orderId !== orderId) return; // never let another ticket move our pin
    if (d.x == null || d.y == null) return;
    applyDriver(d.x, d.y);
  });

  // ── the driver gave the run back ───────────────────────────────────────────
  // Cancelled, or they left the server. The marker must GO — leaving it frozen on
  // the last ping reads as a driver who stopped moving, not one who is gone.
  useNuiEvent("driverGone", (d: any) => {
    if (d?.orderId !== orderId) return;
    if (rafRef.current.id) cancelAnimationFrame(rafRef.current.id);
    rafRef.current.id = 0;
    driverRef.current?.remove();
    driverRef.current = null;
    fit();
  });

  // ── mount SEED ─────────────────────────────────────────────────────────────
  // Driver position and route arrive as fire-and-forget broadcasts, so opening (or
  // RE-opening) a ticket mid-delivery drew an empty map until the next push — and the
  // route only re-sends every ~12s, or on deviation, so a driver holding a steady
  // course left the polyline blank indefinitely. Ask the server for its last-known
  // telemetry once and render it as if the events had fired; live events take over
  // from there. Server-side this is gated to the order's own customer.
  useEffect(() => {
    if (data.type !== "delivery") return;
    let cancelled = false;
    fetchNui<{ driver?: WorldPoint }>("phone:trackOrder", { orderId })
      .then((res) => {
        // The reply can land after the user has navigated off the ticket.
        if (cancelled || !mapRef.current || !res) return;
        if (res.driver && res.driver.x != null && res.driver.y != null) {
          applyDriver(res.driver.x, res.driver.y);
        }
      })
      .catch(() => {});
    return () => {
      cancelled = true;
    };
  }, [orderId, data.type, applyDriver]);

  return (
    // The Leaflet host is its OWN node: Leaflet appends/strips DOM inside it, so
    // nothing React renders (the caption) may share it.
    <div className="pf-map h-40 w-full">
      <div ref={hostRef} className="pf-map-canvas" />

      {/* Zoom controls — React siblings OVER the host, not Leaflet's control,
          so they're fully themed. They live inside `.pf-map`'s stacking context
          (see map.css) and sit above the Leaflet panes via z-index. */}
      <div className="pf-map-zoom">
        <button type="button" aria-label={_L("phone.map.zoom_in")} onClick={() => zoomBy(1)}>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.6" strokeLinecap="round">
            <path d="M12 5v14M5 12h14" />
          </svg>
        </button>
        <button type="button" aria-label={_L("phone.map.zoom_out")} onClick={() => zoomBy(-1)}>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.6" strokeLinecap="round">
            <path d="M5 12h14" />
          </svg>
        </button>
      </div>

      {/* Only offered once the user has taken the camera — it's the way BACK to
          auto-fit, so it'd be meaningless while auto-fit is already running. */}
      {free && (
        <button
          type="button"
          className="pf-map-recenter"
          aria-label={_L("phone.map.recenter")}
          onClick={recenter}
        >
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
            <circle cx="12" cy="12" r="3.2" />
            <circle cx="12" cy="12" r="8" />
            <path d="M12 2v2.6M12 19.4V22M2 12h2.6M19.4 12H22" />
          </svg>
          <span>{_L("phone.map.recenter")}</span>
        </button>
      )}

      <div className="pf-map-caption">
        {data.type === "delivery" ? _L("phone.map.live_delivery") : _L("phone.map.pickup_location")}
      </div>
    </div>
  );
}
