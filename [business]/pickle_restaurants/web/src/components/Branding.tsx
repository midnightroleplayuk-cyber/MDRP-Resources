import { useState, useRef, useEffect, useMemo } from "react";
import { fetchNui } from "@/lib/nui";
import { useAutoSave } from "@/lib/autosave";
import { applyTheme, normalizeTheme, THEME_PRESETS, DEFAULT_THEME, type ThemeConfig } from "@/lib/theme";
import { cn } from "@/lib/utils";
import { _L } from "@/lib/locale";
import { Input } from "@/components/ui/input";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Modal } from "@/components/ui/modal";
import { Image as ImageIcon, RotateCcw, X, Pencil, Plus, Trash2, Palette, Check, Loader2, Store, TriangleAlert } from "lucide-react";

// ─── identity (rename) ────────────────────────────────────────────────────────
// The restaurant's display name — what every customer-facing surface shows (map
// blip, station prompts, menu/orders boards, receipts, the phone app). The
// internal codename is DERIVED from it server-side (same slug the create form
// uses), so there is one field here, not two — and the codename itself is never
// shown: it's an implementation detail, not something staff should read or type. Auto-saves debounced like every
// other setting — this app has no save buttons.
// `event` = "management:setName" | "admin:setName" (both hit SetRestaurantName).

const MAX_LABEL_LEN = 100; // mirrors `pickle_restaurants`.label

export function NameEditor({
  id, label, event, onChange,
}: {
  id: number; label: string; event: string;
  // Fired after each accepted save with the new label, so the parent's cached
  // copy (panel header, admin list row) stays live without a refetch — the same
  // contract ThemeEditor's `onChange` has. Neither panel refreshes on this save:
  // remounting mid-edit would yank the cursor out of the field.
  onChange?: (label: string) => void;
}) {
  const [draft, setDraft] = useState(label || "");
  const saved = useRef(label || "");

  const trimmed = draft.trim().slice(0, MAX_LABEL_LEN);
  const valid = trimmed.length > 0;

  const status = useAutoSave(async () => {
    if (!valid || trimmed === saved.current) return;
    const res = (await fetchNui(event, { id, label: trimmed })) as { ok?: boolean; label?: string } | undefined;
    if (res?.ok === false) return; // server refused (permission / gone) — keep the draft
    saved.current = res?.label || trimmed;
    onChange?.(saved.current);
  }, [trimmed]);

  return (
    <Card>
      <CardContent className="pt-4">
        <div className="mb-1 flex items-center justify-between gap-2">
          <h3 className="flex items-center gap-2 text-sm font-semibold">
            <Store className="h-4 w-4 text-primary" /> {_L("identity.title")}
          </h3>
          <span className="flex shrink-0 items-center gap-1 text-xs text-muted-foreground">
            {!valid ? (
              <><TriangleAlert className="h-3 w-3 text-destructive" /> {_L("identity.required")}</>
            ) : status === "saving" ? (
              <><Loader2 className="h-3 w-3 animate-spin" /> {_L("theme.saving")}</>
            ) : status === "saved" ? (
              <><Check className="h-3 w-3 text-primary" /> {_L("theme.saved")}</>
            ) : _L("theme.live_hint")}
          </span>
        </div>
        <p className="mb-3 text-[11px] text-muted-foreground">{_L("identity.hint")}</p>
        <Input
          value={draft}
          maxLength={MAX_LABEL_LEN}
          onChange={(e) => setDraft(e.target.value)}
          placeholder={_L("identity.placeholder")}
          className="font-display text-base font-bold"
        />
      </CardContent>
    </Card>
  );
}

// ─── theme editor ─────────────────────────────────────────────────────────────
// The restaurant's franchise look: one brand color seed + surface mode + corner
// radius. The entire UI palette is derived from these (CSS relative colors), so
// every change previews LIVE on the open panel and auto-saves debounced.
// `event` = "management:setTheme" | "admin:setTheme" (both hit SetRestaurantTheme).

const HEX_OK = /^#[0-9a-f]{6}$/i;

function Segmented<T extends string>({
  value, onChange, options,
}: {
  value: T; onChange: (v: T) => void; options: { value: T; label: string }[];
}) {
  return (
    <div className="inline-flex rounded-md border border-border bg-muted/50 p-0.5">
      {options.map((o) => (
        <button
          key={o.value}
          onClick={() => onChange(o.value)}
          className={cn(
            "rounded-[calc(var(--radius)-6px)] px-3 py-1 text-xs font-semibold transition-colors",
            value === o.value ? "bg-primary text-primary-foreground shadow-sm" : "text-muted-foreground hover:text-foreground"
          )}
        >
          {o.label}
        </button>
      ))}
    </div>
  );
}

export function ThemeEditor({
  id, theme, event, onChange, heading, blurb, scoped,
}: {
  id: number; theme?: ThemeConfig | null; event: string;
  // Fired on every edit with the new seed — lets the parent keep its cached copy
  // live so remounts (tab switches, leave→return) re-apply the CURRENT theme, not
  // the stale open-payload one.
  onChange?: (t: Required<ThemeConfig>) => void;
  heading?: string; blurb?: string;
  // `scoped` = this editor tunes a theme that is NOT the panel it lives in (the
  // admin panel editing a restaurant's franchise seed). It must NOT hijack the
  // surrounding panel with a live preview — the admin keeps its OWN app theme. A
  // contained swatch below shows the seed instead. Boss panel leaves it off, where
  // "the open panel IS the preview" is correct.
  scoped?: boolean;
}) {
  const [cfg, setCfg] = useState(() => normalizeTheme(theme));
  const [hexDraft, setHexDraft] = useState(cfg.primary);

  const set = (patch: Partial<ThemeConfig>) => {
    setCfg((c) => {
      const next = normalizeTheme({ ...c, ...patch });
      if (!scoped) applyTheme(next); // live preview — the open panel IS the preview
      onChange?.(next); // keep the parent's cached theme in sync
      return next;
    });
  };
  const setPrimary = (hex: string) => {
    setHexDraft(hex);
    if (HEX_OK.test(hex)) set({ primary: hex });
  };

  const status = useAutoSave(() => fetchNui(event, { id, theme: cfg }), [cfg]);

  return (
    <Card>
      <CardContent className="pt-4">
        <div className="mb-1 flex items-center justify-between gap-2">
          <h3 className="flex items-center gap-2 text-sm font-semibold">
            <Palette className="h-4 w-4 text-primary" /> {heading ?? _L("theme.title")}
          </h3>
          <span className="flex shrink-0 items-center gap-1 text-xs text-muted-foreground">
            {status === "saving" && <><Loader2 className="h-3 w-3 animate-spin" /> {_L("theme.saving")}</>}
            {status === "saved" && <><Check className="h-3 w-3 text-primary" /> {_L("theme.saved")}</>}
            {status === "idle" && _L("theme.live_hint")}
          </span>
        </div>
        <p className="mb-3 text-[11px] text-muted-foreground">{blurb ?? _L("theme.hint")}</p>

        <span className="tape mb-1.5 block">{_L("theme.brand_color")}</span>
        <div className="flex flex-wrap items-center gap-1.5">
          {THEME_PRESETS.map((p) => {
            const active = cfg.primary === p.hex;
            return (
              <button
                key={p.hex}
                title={p.label}
                onClick={() => setPrimary(p.hex)}
                style={{ backgroundColor: p.hex }}
                className={cn(
                  "h-7 w-7 rounded-full border transition-transform",
                  active
                    ? "scale-110 border-white/90 ring-2 ring-primary"
                    : "border-black/30 hover:scale-105"
                )}
              />
            );
          })}
          {/* custom seed: native picker + hex field */}
          <label className="relative ml-1 inline-flex h-7 w-7 cursor-pointer overflow-hidden rounded-full border border-dashed border-border">
            <input
              type="color"
              value={HEX_OK.test(hexDraft) ? hexDraft : cfg.primary}
              onChange={(e) => setPrimary(e.target.value)}
              className="absolute -inset-2 h-[calc(100%+16px)] w-[calc(100%+16px)] cursor-pointer border-0 p-0"
            />
          </label>
          <Input
            value={hexDraft}
            onChange={(e) => setPrimary(e.target.value.startsWith("#") ? e.target.value : "#" + e.target.value)}
            placeholder="#ff7a2e"
            className="h-7 w-24 font-mono text-[11px] tabular-nums"
          />
        </div>

        <div className="mt-3 flex flex-wrap items-end gap-4">
          <div>
            <span className="tape mb-1.5 block">{_L("theme.mode")}</span>
            <Segmented
              value={cfg.mode as "dark" | "paper"}
              onChange={(v) => set({ mode: v })}
              options={[
                { value: "dark", label: _L("theme.mode_dark") },
                { value: "paper", label: _L("theme.mode_paper") },
              ]}
            />
          </div>
          <div>
            <span className="tape mb-1.5 block">{_L("theme.radius")}</span>
            <Segmented
              value={cfg.radius as "sharp" | "soft" | "round"}
              onChange={(v) => set({ radius: v })}
              options={[
                { value: "sharp", label: _L("theme.radius_sharp") },
                { value: "soft", label: _L("theme.radius_soft") },
                { value: "round", label: _L("theme.radius_round") },
              ]}
            />
          </div>
          <button
            onClick={() => { setHexDraft(DEFAULT_THEME.primary); set({ ...DEFAULT_THEME }); }}
            className="ml-auto flex items-center gap-1 rounded-md border border-border bg-secondary px-2 py-1 text-[11px] font-semibold text-muted-foreground transition hover:text-foreground"
          >
            <RotateCcw className="h-3 w-3" /> {_L("theme.reset")}
          </button>
        </div>

        {/* Scoped preview: the admin panel keeps its OWN theme, so this seed can't
            preview on the surrounding panel — a self-contained WYSIWYG chip (inline
            styles straight off the seed, not the token system) shows it instead. */}
        {scoped && (
          <div
            className="mt-3 flex items-center gap-3 border p-3"
            style={{
              borderRadius: cfg.radius === "sharp" ? 2 : cfg.radius === "round" ? 16 : 8,
              backgroundColor: cfg.mode === "paper" ? "#f5f1e8" : "#14140f",
              color: cfg.mode === "paper" ? "#14140f" : "#f5f1e8",
              borderColor: cfg.mode === "paper" ? "#00000022" : "#ffffff1f",
            }}
          >
            <span
              className="grid h-8 w-8 shrink-0 place-items-center font-display text-sm font-bold text-white"
              style={{ backgroundColor: cfg.primary, borderRadius: cfg.radius === "sharp" ? 2 : cfg.radius === "round" ? 999 : 6 }}
            >Aa</span>
            <div className="min-w-0 flex-1">
              <div className="text-xs font-semibold">{_L("theme.preview_title")}</div>
              <div className="text-[11px] opacity-70">{_L("theme.preview_blurb")}</div>
            </div>
            <span
              className="shrink-0 px-2.5 py-1 text-[11px] font-semibold text-white"
              style={{ backgroundColor: cfg.primary, borderRadius: cfg.radius === "sharp" ? 2 : cfg.radius === "round" ? 999 : 6 }}
            >{_L("theme.preview_action")}</span>
          </div>
        )}
      </CardContent>
    </Card>
  );
}

// Per-texture UI copy (label + hint). The ASPECT it crops to is NOT hardcoded here —
// it comes from the render-target registry (core/shared.lua), synced to the panel as
// `renderTargets` (see `brandTextures()` below), so the crop frame always matches the
// resolution/orientation the game actually renders at. `w`/`h` here are only a fallback
// display aspect for when the sync hasn't arrived.
type BrandTex = { key: string; label: string; w: number; h: number; hint: string };
// LAZY getter (memoized): `_L()` resolves at render, not at module import — a
// module-scope `_L()` runs before loadLocale() and would freeze to the raw key.
let _brandTextureMeta: Record<string, { label: string; hint: string; w: number; h: number }> | null = null;
const BRAND_TEXTURE_META = () => (_brandTextureMeta ??= {
  pizza_box: { label: _L("branding.tex_pizza_box_label"), hint: _L("branding.tex_pizza_box_hint"), w: 1024, h: 1024 },
  cup: { label: _L("branding.tex_cup_label"), hint: _L("branding.tex_cup_hint"), w: 1024, h: 1792 },
  tray: { label: _L("branding.tex_tray_label"), hint: _L("branding.tex_tray_hint"), w: 1792, h: 1024 },
  side: { label: _L("branding.tex_side_label"), hint: _L("branding.tex_side_hint"), w: 2304, h: 1024 },
  bag: { label: _L("branding.tex_bag_label"), hint: _L("branding.tex_bag_hint"), w: 1024, h: 1024 },
  kiosk: { label: _L("branding.tex_kiosk_label"), hint: _L("branding.tex_kiosk_hint"), w: 1080, h: 1920 },
});

// Build the editable brand-texture list. Prefers the synced render-target aspects
// (display w/h from the server); falls back to the META defaults if the sync is absent.
// Only keys we have UI copy for are shown (an unknown target has no label/hint).
function brandTextures(rts?: { key: string; w: number; h: number }[]): BrandTex[] {
  const meta = BRAND_TEXTURE_META();
  const src = rts && rts.length ? rts : Object.entries(meta).map(([key, m]) => ({ key, w: m.w, h: m.h }));
  return src
    .filter((t) => meta[t.key])
    .map((t) => {
      const m = meta[t.key];
      return { key: t.key, w: t.w, h: t.h, label: m.label, hint: m.hint };
    });
}

export type Crop = { x: number; y: number; w: number; h: number };
type Aspect = { w: number; h: number };
// A photo target: the crop frame's aspect + copy for the picker dialog. The brand
// textures satisfy this structurally (they add a `key`); other callers pass their own.
export type PhotoAspect = { label: string; w: number; h: number; hint: string };
export type PhotoEntry = { url: string; crop?: Crop | null };
const clampN = (v: number, a: number, b: number) => Math.max(a, Math.min(b, v));

// The largest normalised rect of the target aspect that fits inside the image
// (a centred "cover" crop) — the fallback when nothing is positioned.
function coverRect(nat: { w: number; h: number }, A: number) {
  const ia = nat.w / nat.h;
  return ia >= A ? { mw: A / ia, mh: 1 } : { mw: 1, mh: ia / A };
}

// Draw a crop (or a centred cover, when crop is null) of `img` filling a canvas.
// Identical math to the DUI (html/brand.html), so previews are WYSIWYG.
function drawCrop(
  ctx: CanvasRenderingContext2D, img: HTMLImageElement, crop: Crop | null,
  cw: number, ch: number, nat: { w: number; h: number }, A: number
) {
  ctx.clearRect(0, 0, cw, ch);
  let sx, sy, sw, sh;
  if (crop && crop.w > 0 && crop.h > 0) {
    sx = crop.x * nat.w; sy = crop.y * nat.h; sw = crop.w * nat.w; sh = crop.h * nat.h;
  } else {
    const { mw, mh } = coverRect(nat, A);
    sw = mw * nat.w; sh = mh * nat.h; sx = (nat.w - sw) / 2; sy = (nat.h - sh) / 2;
  }
  ctx.drawImage(img, sx, sy, sw, sh, 0, 0, cw, ch);
}

// Per-restaurant branding editor: a shared default image, then one card per packaging
// texture. Each texture is set through a "Set/Update photo" dialog (URL → position the
// crop) and saved only on confirm. `event` is the NUI event to save through —
// "management:setBrandImage" or "admin:setBrandImage" (both hit SetRestaurantBrand).
export default function Branding({
  id, brand, brandImages, phoneImage, event, renderTargets,
}: {
  id: number; brand: string; brandImages: Record<string, any>; phoneImage?: string; event: string;
  renderTargets?: { key: string; w: number; h: number }[];
}) {
  // local optimistic copy so cards update without a full panel refetch
  const [images, setImages] = useState<Record<string, { url: string; crop?: Crop | null }>>(
    () => ({ ...(brandImages || {}) })
  );
  // The editable textures + their crop aspects, sourced from the synced render-target
  // registry (falls back to the built-in defaults if the sync hasn't landed).
  const textures = brandTextures(renderTargets);

  const saveTexture = (key: string, entry: { url: string; crop?: Crop | null } | null) => {
    setImages((m) => {
      const next = { ...m };
      if (entry && entry.url) next[key] = entry; else delete next[key];
      return next;
    });
    fetchNui(event, { id, key, url: entry?.url || "", crop: entry?.url ? entry.crop || undefined : undefined });
  };

  return (
    <div className="space-y-3">
      {/* The two plain-URL images sit side by side, the same two-column row the
          packaging texture cards use below. */}
      <div className="grid grid-cols-2 gap-3">
        <UrlImageField
          title={_L("branding.default_image")}
          value={brand}
          placeholder={_L("branding.default_image_placeholder")}
          hint={_L("branding.default_image_hint")}
          empty={_L("branding.no_image")}
          aspect={DEFAULT_IMAGE_ASPECT}
          onCommit={(url) => fetchNui(event, { id, url })}
        />
        <UrlImageField
          title={_L("branding.phone_image")}
          value={phoneImage || ""}
          placeholder={_L("branding.phone_image_placeholder")}
          hint={_L("branding.phone_image_hint")}
          empty={_L("branding.uses_default_image")}
          aspect={PHONE_IMAGE_ASPECT}
          onCommit={(url) => fetchNui(event, { id, key: "phone", url })}
        />
      </div>

      <div className="grid grid-cols-2 gap-3">
        {textures.map((t) => (
          <BrandTextureCard
            key={t.key}
            tex={t}
            entry={images[t.key]}
            onSave={(entry) => saveTexture(t.key, entry)}
          />
        ))}
      </div>
    </div>
  );
}

// The two plain-URL brand images (the shared default packaging art + the phone
// storefront hero). No crop is stored for either — the game and the phone app both
// auto-crop them centred — so their preview is the SAME `CropThumb` the packaging
// cards use, with `crop = null` (a centred cover crop), which is exactly what the
// consumer renders. Aspects below are only the preview frame's shape.
const DEFAULT_IMAGE_ASPECT: Aspect = { w: 1024, h: 1024 }; // re-cropped per packaging shape
const PHONE_IMAGE_ASPECT: Aspect = { w: 1600, h: 800 };    // landscape hero (feed card / menu header)

// Shared "nothing set yet" thumb — same box the packaging cards show before a photo.
function EmptyThumb({ label }: { label: string }) {
  return (
    <div className="flex h-28 items-center justify-center rounded-md border border-dashed border-border bg-muted/30 px-2 text-center text-[11px] text-muted-foreground">
      {label}
    </div>
  );
}

// One URL-only image field: label, URL input, live preview, hint. Saving is unchanged
// (commit on blur through the caller's `onCommit` → the same brand NUI event); the
// preview is debounced off the typed value so a half-typed URL never flashes "Bad URL".
function UrlImageField({
  title, value, placeholder, hint, empty, aspect, onCommit,
}: {
  title: string; value: string; placeholder: string; hint: string; empty: string;
  aspect: Aspect; onCommit: (url: string) => void;
}) {
  const [url, setUrl] = useState(value || "");
  const [preview, setPreview] = useState((value || "").trim());

  useEffect(() => {
    const t = setTimeout(() => setPreview(url.trim()), 400);
    return () => clearTimeout(t);
  }, [url]);

  return (
    <Card>
      <CardContent className="pt-4">
        <h3 className="mb-2 flex items-center gap-2 text-sm font-semibold">
          <ImageIcon className="h-4 w-4 shrink-0" /> <span className="truncate">{title}</span>
        </h3>
        <Input
          value={url}
          placeholder={placeholder}
          className="h-9"
          onChange={(e) => setUrl(e.target.value)}
          onBlur={(e) => onCommit(e.target.value.trim())}
        />
        <div className="mt-2">
          {preview ? (
            <CropThumb url={preview} aspect={aspect} crop={null} />
          ) : (
            <EmptyThumb label={empty} />
          )}
        </div>
        <p className="mt-1.5 text-[11px] text-muted-foreground">{hint}</p>
      </CardContent>
    </Card>
  );
}

function BrandTextureCard({
  tex, entry, onSave,
}: {
  tex: BrandTex; entry?: { url: string; crop?: Crop | null }; onSave: (e: { url: string; crop?: Crop | null } | null) => void;
}) {
  const [editing, setEditing] = useState(false);
  const has = !!entry?.url;
  return (
    <Card>
      <CardContent className="pt-4">
        <div className="mb-2 flex items-center justify-between gap-2">
          <h3 className="truncate text-sm font-semibold">{tex.label}</h3>
          <span className="shrink-0 text-[10px] tabular-nums text-muted-foreground">{tex.w}×{tex.h}</span>
        </div>

        {has ? (
          <CropThumb url={entry!.url} aspect={tex} crop={entry!.crop || null} />
        ) : (
          <EmptyThumb label={_L("branding.uses_default_image")} />
        )}

        <div className="mt-2 flex items-center gap-2">
          <button
            onClick={() => setEditing(true)}
            className="flex flex-1 items-center justify-center gap-1.5 rounded-md bg-secondary px-2 py-1.5 text-xs font-semibold text-foreground transition hover:bg-accent"
          >
            {has ? <><Pencil className="h-3.5 w-3.5" /> {_L("branding.update_photo")}</> : <><Plus className="h-3.5 w-3.5" /> {_L("branding.set_photo")}</>}
          </button>
          {has && (
            <button
              onClick={() => onSave(null)}
              title={_L("branding.remove_photo")}
              className="flex items-center justify-center rounded-md border border-border bg-secondary p-1.5 text-muted-foreground transition hover:border-destructive/60 hover:text-destructive"
            >
              <Trash2 className="h-3.5 w-3.5" />
            </button>
          )}
        </div>
        <p className="mt-1.5 text-[11px] text-muted-foreground">{tex.hint}</p>

        {editing && (
          <BrandPhotoModal
            tex={tex}
            initial={entry || null}
            onClose={() => setEditing(false)}
            onSave={(e) => { onSave(e); setEditing(false); }}
          />
        )}
      </CardContent>
    </Card>
  );
}

// A reusable "Set / Update / Remove photo" card (URL + crop), shared by the brand
// textures and the food-image editors. `aspect` locks the crop frame + dialog copy; `entry`
// is the current { url, crop }; `onChange(null)` clears it. `empty` overrides the
// no-photo caption. Same WYSIWYG cropper as the packaging brands.
export function PhotoField({
  aspect, entry, onChange, empty, className,
}: {
  aspect: PhotoAspect; entry?: PhotoEntry | null;
  onChange: (e: PhotoEntry | null) => void; empty?: string; className?: string;
}) {
  const [editing, setEditing] = useState(false);
  const has = !!entry?.url;
  return (
    <div className={className}>
      {has ? (
        <CropThumb url={entry!.url} aspect={aspect} crop={entry!.crop || null} />
      ) : (
        <EmptyThumb label={empty ?? _L("branding.uses_default_image")} />
      )}
      <div className="mt-2 flex items-center gap-2">
        <button
          onClick={() => setEditing(true)}
          className="flex flex-1 items-center justify-center gap-1.5 rounded-md bg-secondary px-2 py-1.5 text-xs font-semibold text-foreground transition hover:bg-accent"
        >
          {has ? <><Pencil className="h-3.5 w-3.5" /> {_L("branding.update_photo")}</> : <><Plus className="h-3.5 w-3.5" /> {_L("branding.set_photo")}</>}
        </button>
        {has && (
          <button
            onClick={() => onChange(null)}
            title={_L("branding.remove_photo")}
            className="flex items-center justify-center rounded-md border border-border bg-secondary p-1.5 text-muted-foreground transition hover:border-destructive/60 hover:text-destructive"
          >
            <Trash2 className="h-3.5 w-3.5" />
          </button>
        )}
      </div>
      {editing && (
        <BrandPhotoModal
          tex={aspect}
          initial={entry || null}
          onClose={() => setEditing(false)}
          onSave={(e) => { onChange(e); setEditing(false); }}
        />
      )}
    </div>
  );
}

// A small static preview of the saved crop, drawn the same way the prop will look.
// Fixed height, aspect-correct width — so a tall texture (cup) doesn't blow up the card.
export function CropThumb({ url, aspect, crop }: { url: string; aspect: Aspect; crop: Crop | null }) {
  const A = aspect.w / aspect.h;
  const imgRef = useRef<HTMLImageElement | null>(null);
  const canvasRef = useRef<HTMLCanvasElement | null>(null);
  const [nat, setNat] = useState<{ w: number; h: number } | null>(null);
  const [broken, setBroken] = useState(false);

  useEffect(() => {
    const c = canvasRef.current, im = imgRef.current;
    if (!c || !im || !nat) return;
    const ctx = c.getContext("2d");
    if (ctx) drawCrop(ctx, im, crop, c.width, c.height, nat, A);
  }, [nat, crop, A, url]);

  const IH = 224; // intrinsic px (2× the 112px display height) for a crisp draw
  return (
    <div className="flex h-28 items-center justify-center overflow-hidden rounded-md border border-border bg-black/40">
      <img ref={imgRef} src={url} alt="" onLoad={(e) => { setBroken(false); setNat({ w: e.currentTarget.naturalWidth, h: e.currentTarget.naturalHeight }); }} onError={() => { setBroken(true); setNat(null); }} style={{ display: "none" }} />
      {broken ? (
        <span className="text-[11px] text-destructive">{_L("branding.bad_url")}</span>
      ) : (
        <canvas ref={canvasRef} width={Math.round(IH * A)} height={IH} className="h-full w-auto" style={{ aspectRatio: A }} />
      )}
    </div>
  );
}

// The "Set / Update Photo" dialog: enter the URL, then drag + zoom to position the
// image inside a frame locked to the texture's aspect ratio, then Save. Nothing is
// written until Save — Cancel discards.
// Built on the shared Modal, so its scrim covers the PANEL CONTENT it was opened
// from (portaled into the panel's content region via context) rather than the whole
// screen. It used to be a hand-rolled `fixed inset-0` overlay, which dimmed the game
// and the panel chrome along with it.
function BrandPhotoModal({
  tex, initial, onClose, onSave,
}: {
  tex: PhotoAspect; initial: { url: string; crop?: Crop | null } | null;
  onClose: () => void; onSave: (e: { url: string; crop?: Crop | null } | null) => void;
}) {
  const [url, setUrl] = useState(initial?.url || "");
  const [crop, setCrop] = useState<Crop | null>(initial?.crop || null);
  const trimmed = url.trim();

  // typing a different URL invalidates the current crop — the cropper reseeds to cover
  const onUrlChange = (v: string) => {
    setUrl(v);
    if (v.trim() !== trimmed) setCrop(null);
  };

  return (
    <Modal
      open
      onClose={onClose}
      title={_L("branding.photo_title", tex.label)}
      subtitle={_L("branding.photo_sub", tex.hint, tex.w, tex.h)}
      icon={<ImageIcon className="h-4 w-4" />}
      footer={
        <>
          <Button variant="ghost" size="sm" onClick={onClose}>{_L("branding.cancel")}</Button>
          <Button size="sm" disabled={!trimmed} onClick={() => onSave(trimmed ? { url: trimmed, crop } : null)}>
            {_L("branding.apply_photo")}
          </Button>
        </>
      }
    >
      <label className="text-[11px] font-medium text-muted-foreground">{_L("branding.photo_url")}</label>
      <Input
        autoFocus
        value={url}
        onChange={(e) => onUrlChange(e.target.value)}
        placeholder="https://…/image.png"
        className="mt-1 h-9"
      />

      <div className="mt-3">
        {trimmed ? (
          <BrandCropper url={trimmed} aspect={tex} crop={crop} onChange={setCrop} />
        ) : (
          <div className="flex h-40 items-center justify-center rounded-md border border-dashed border-border text-[11px] text-muted-foreground">
            {_L("branding.paste_url_prompt")}
          </div>
        )}
      </div>
    </Modal>
  );
}

// A crop rectangle over the full image (like a photo editor's crop tool): the whole
// image is shown, a movable/resizable frame — locked to the texture's aspect ratio,
// with a rule-of-thirds grid and the outside dimmed — selects the region. Reports the
// normalised source rect via onChange as it's adjusted.
type PxRect = { l: number; t: number; w: number; h: number };
function BrandCropper({
  url, aspect, crop, onChange,
}: {
  url: string; aspect: Aspect; crop: Crop | null; onChange: (c: Crop) => void;
}) {
  const A = aspect.w / aspect.h;
  const [nat, setNat] = useState<{ w: number; h: number } | null>(null);
  const [broken, setBroken] = useState(false);
  const [rect, setRect] = useState<PxRect | null>(null);
  const wrapRef = useRef<HTMLDivElement | null>(null);
  const gesture = useRef<any>(null);
  const onChangeRef = useRef(onChange);
  onChangeRef.current = onChange;

  // displayed image size: contain within a bounded box (image shown undistorted, so
  // display px map uniformly to image px — the crop rect works in display px)
  const MAXW = 380, MAXH = 260;
  const disp = useMemo(() => {
    if (!nat) return { w: MAXW, h: Math.round(MAXW / A) };
    const ia = nat.w / nat.h;
    let w = MAXW, h = MAXW / ia;
    if (h > MAXH) { h = MAXH; w = MAXH * ia; }
    return { w: Math.round(w), h: Math.round(h) };
  }, [nat, A]);

  const MIN = 40;
  const toNorm = (r: PxRect): Crop => ({ x: r.l / disp.w, y: r.t / disp.h, w: r.w / disp.w, h: r.h / disp.h });
  // the largest A-aspect frame that fits the displayed image, centred
  const coverPx = (): PxRect => {
    let w = disp.w, h = w / A;
    if (h > disp.h) { h = disp.h; w = h * A; }
    return { l: (disp.w - w) / 2, t: (disp.h - h) / 2, w, h };
  };

  // seed the frame from the saved crop, else cover, whenever a new image/size lands
  useEffect(() => {
    if (!nat) return;
    if (crop && crop.w > 0 && crop.h > 0) {
      setRect({ l: crop.x * disp.w, t: crop.y * disp.h, w: crop.w * disp.w, h: crop.h * disp.h });
    } else {
      setRect(coverPx());
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [nat, url, disp.w, disp.h]);

  // report the crop upward whenever the frame moves/resizes
  useEffect(() => { if (rect) onChangeRef.current(toNorm(rect)); /* eslint-disable-next-line */ }, [rect]);

  // one window-level gesture (move or corner-resize) at a time
  useEffect(() => {
    const move = (e: PointerEvent) => {
      const g = gesture.current;
      if (!g) return;
      if (g.type === "move") {
        const l = clampN(g.r.l + (e.clientX - g.px), 0, disp.w - g.r.w);
        const t = clampN(g.r.t + (e.clientY - g.py), 0, disp.h - g.r.h);
        setRect({ ...g.r, l, t });
      } else {
        // resize from a corner; the OPPOSITE corner (anchor) stays fixed, aspect locked
        const ax = g.fixedLeft ? g.r.l : g.r.l + g.r.w;
        const ay = g.fixedTop ? g.r.t : g.r.t + g.r.h;
        const box = wrapRef.current!.getBoundingClientRect();
        const px = e.clientX - box.left;
        let w = Math.abs(px - ax);
        const maxW = g.fixedLeft ? disp.w - ax : ax;
        const maxH = g.fixedTop ? disp.h - ay : ay;
        w = clampN(w, MIN, Math.min(maxW, maxH * A));
        const h = w / A;
        setRect({ l: g.fixedLeft ? ax : ax - w, t: g.fixedTop ? ay : ay - h, w, h });
      }
    };
    const up = () => { gesture.current = null; };
    window.addEventListener("pointermove", move);
    window.addEventListener("pointerup", up);
    return () => { window.removeEventListener("pointermove", move); window.removeEventListener("pointerup", up); };
  }, [disp.w, disp.h, A]);

  const startMove = (e: React.PointerEvent) => {
    e.preventDefault();
    if (rect) gesture.current = { type: "move", px: e.clientX, py: e.clientY, r: rect };
  };
  const startResize = (fixedLeft: boolean, fixedTop: boolean) => (e: React.PointerEvent) => {
    e.preventDefault(); e.stopPropagation();
    if (rect) gesture.current = { type: "resize", px: e.clientX, py: e.clientY, r: rect, fixedLeft, fixedTop };
  };

  // corners: [dx,dy for the handle centre, anchor-fixedLeft, anchor-fixedTop, cursor]
  const corners: [number, number, boolean, boolean, string][] = [
    [0, 0, false, false, "nwse-resize"], // NW → anchor SE
    [1, 0, true, false, "nesw-resize"],  // NE → anchor SW
    [0, 1, false, true, "nesw-resize"],  // SW → anchor NE
    [1, 1, true, true, "nwse-resize"],   // SE → anchor NW
  ];

  return (
    <div>
      {broken ? (
        <div className="flex h-40 items-center justify-center rounded-md border border-dashed border-destructive/50 text-[11px] text-destructive">{_L("branding.image_load_failed")}</div>
      ) : !nat ? (
        <>
          <img src={url} alt="" onLoad={(e) => { setBroken(false); setNat({ w: e.currentTarget.naturalWidth, h: e.currentTarget.naturalHeight }); }} onError={() => { setBroken(true); }} style={{ display: "none" }} />
          <div className="flex h-40 items-center justify-center rounded-md border border-dashed border-border text-[11px] text-muted-foreground">{_L("branding.loading_image")}</div>
        </>
      ) : (
        <div className="flex flex-col items-center gap-2">
          <div ref={wrapRef} className="relative select-none" style={{ width: disp.w, height: disp.h, touchAction: "none" }}>
            <img src={url} alt="" draggable={false} className="block h-full w-full rounded-md" />
            {rect && (
              <>
                {/* dim + grid, clipped to the image so the shadow can't bleed onto the modal */}
                <div className="pointer-events-none absolute inset-0 overflow-hidden rounded-md">
                  <div
                    className="absolute"
                    style={{ left: rect.l, top: rect.t, width: rect.w, height: rect.h, boxShadow: "0 0 0 9999px rgba(0,0,0,0.55)", outline: "1px solid rgba(255,255,255,0.9)" }}
                  >
                    <div className="absolute inset-y-0" style={{ left: "33.333%", borderLeft: "1px solid rgba(255,255,255,0.4)" }} />
                    <div className="absolute inset-y-0" style={{ left: "66.666%", borderLeft: "1px solid rgba(255,255,255,0.4)" }} />
                    <div className="absolute inset-x-0" style={{ top: "33.333%", borderTop: "1px solid rgba(255,255,255,0.4)" }} />
                    <div className="absolute inset-x-0" style={{ top: "66.666%", borderTop: "1px solid rgba(255,255,255,0.4)" }} />
                  </div>
                </div>
                {/* move surface (grab anywhere inside the frame) */}
                <div
                  onPointerDown={startMove}
                  className="absolute cursor-move"
                  style={{ left: rect.l, top: rect.t, width: rect.w, height: rect.h }}
                />
                {/* corner resize handles — outside the clip so they stay visible on edges */}
                {corners.map(([dx, dy, fl, ft, cur]) => (
                  <div
                    key={`${dx}${dy}`}
                    onPointerDown={startResize(fl, ft)}
                    className="absolute h-3 w-3 rounded-sm border border-white bg-primary"
                    style={{ left: rect.l + dx * rect.w - 6, top: rect.t + dy * rect.h - 6, cursor: cur }}
                  />
                ))}
              </>
            )}
          </div>
          <div className="flex w-full items-center justify-between">
            <p className="text-[11px] text-muted-foreground">{_L("branding.cropper_hint")}</p>
            <button onClick={() => setRect(coverPx())} title={_L("branding.reset")} className="flex items-center gap-1 rounded-md border border-border bg-secondary px-2 py-1 text-[11px] font-semibold text-foreground transition hover:bg-accent">
              <RotateCcw className="h-3 w-3" /> {_L("branding.reset")}
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
