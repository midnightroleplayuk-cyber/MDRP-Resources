import L from "leaflet";

// ─── GTA V world → Leaflet map projection ────────────────────────────────────
//
// The tiles under `web/public/map/` are a plain XYZ pyramid, zoom 0-4, 256px
// JPEGs, north-up, one SQUARE image of the whole San Andreas map (z4 = 16×16
// tiles = 4096×4096px). They ship with no README and no reference points, so
// there is no authoritative constant set — everything below is a FIT, not a
// documented standard.
//
// We use `L.CRS.Simple`, whose coordinate space at zoom 0 is exactly the z0
// tile: 256×256 units. So one "map unit" here == one pixel of the z0 tile ==
// 16 pixels of the z4 tile. Image pixel Y runs DOWNWARD.
//
//   px = worldX * SCALE_X + OFFSET_X      (image pixel X, 0 → 256, left → right)
//   py = worldY * SCALE_Y + OFFSET_Y      (image pixel Y, 0 → 256, top → bottom)
//
// SCALE_Y is NEGATIVE because GTA's +Y points north while image +Y points down.
// `worldToLatLng` then flips py once more when handing Leaflet a LatLng, because
// CRS.Simple's built-in transformation is (1, 0, -1, 0) — it projects
// latLng(lat, lng) to the pixel (lng, -lat). So lat = -py, lng = px.
//
// ─── TUNE IN-GAME ────────────────────────────────────────────────────────────
// These four numbers are an APPROXIMATE two-point affine fit, derived by
// eyeballing two landmarks in the vendored tiles against their commonly-cited
// world coordinates:
//
//   Los Santos International    world (-1050, -2700)  ≈  image px (92.8, 229.5)
//   Sandy Shores airstrip       world ( 1650,  3250)  ≈  image px (140.5, 109.0)
//
// with |SCALE_X| forced equal to |SCALE_Y| (the map render is isotropic — that
// constraint is what makes a two-landmark fit trustworthy). The result puts the
// world origin (0, 0) at image pixel (110.9, 174.5) and makes the square cover
// ~13,500 world units on a side (world X ≈ -5850..7650, Y ≈ -4300..9200 — the
// island plus its ocean margin).
//
// TO RECALIBRATE (expect to): stand at a known world coord in game with a live
// order open, see where the pin lands on this map, and edit ONLY the four
// constants below.
//   * pin drifts the same direction everywhere → adjust OFFSET_X / OFFSET_Y.
//   * pin error grows the further you get from the middle → adjust SCALE.
// Two known points are enough to solve it exactly:
//   SCALE_X  = (px2 - px1) / (worldX2 - worldX1)
//   OFFSET_X = px1 - worldX1 * SCALE_X
//   SCALE_Y  = (py2 - py1) / (worldY2 - worldY1)      // comes out negative
//   OFFSET_Y = py1 - worldY1 * SCALE_Y
// where px/py are image pixels in the 0..256 z0 space (a z4 pixel ÷ 16).
export const SCALE_X = 0.018963;
export const OFFSET_X = 110.9;
export const SCALE_Y = -0.018963;
export const OFFSET_Y = 174.5;

/** Side length of the square map in CRS.Simple units (== the z0 tile in px). */
export const MAP_SIZE = 256;

/** Tile pyramid: `map/{z}/{x}/{y}.jpg`, relative so `base: "./"` keeps working. */
export const TILE_URL = "map/{z}/{x}/{y}.jpg";
/** Out-of-range tiles (Leaflet asks for a few at the edges). */
export const EMPTY_TILE_URL = "map/empty.jpg";

export const MIN_ZOOM = 0;
/** Deepest zoom level that actually EXISTS on disk (`map/4/…` is the last one). */
export const MAX_NATIVE_ZOOM = 4;
/**
 * Deepest zoom the MAP allows. Past `MAX_NATIVE_ZOOM` there are no tiles, so the
 * tile layer is given `maxNativeZoom` and Leaflet upscales the z4 images instead
 * of requesting 404s and falling through to `errorTileUrl` (a blank map). Capped
 * two levels up — beyond that the JPEG is mush.
 */
export const MAX_ZOOM = 6;

/** World point as the Lua side sends it. */
export type WorldPoint = { x: number; y: number };

/** GTA world coordinate → Leaflet LatLng in the CRS.Simple tile space. */
export function worldToLatLng(x: number, y: number): L.LatLng {
  const px = x * SCALE_X + OFFSET_X;
  const py = y * SCALE_Y + OFFSET_Y;
  // CRS.Simple projects latLng(lat, lng) → point(lng, -lat), so lat = -py.
  return L.latLng(-py, px);
}

/** The tile square, so the map can't be panned off into grey void. */
export function mapBounds(): L.LatLngBounds {
  return L.latLngBounds(L.latLng(-MAP_SIZE, 0), L.latLng(0, MAP_SIZE));
}
