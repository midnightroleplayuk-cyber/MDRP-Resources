import { useEffect, useState } from "react";
import { fetchNui, useNuiEvent } from "@/lib/nui";
import { _L } from "@/lib/locale";
import { cn } from "@/lib/utils";
import type { Crop } from "@/components/Branding";

// EAT-IN. The meal itself is real world props on the table in front of a seated
// customer (modules/dining lays them out with the kitchen's own renderer), so this
// view is deliberately almost nothing: a transparent click surface over the world,
// the hover tooltip for whatever the cursor is over, and a one-line hint.
//
// Clicks are resolved WORLD-side, not here: a DOM element can't sit on a 3D prop,
// so the Lua hover loop decides what's under the cursor and `dining:click` acts on
// it — the same split the kitchen uses for clicking food on the prep table.
//
// SELECTION IS EXPLICIT. Hovering a serving only names it; clicking LOCKS it in, and
// only a locked card carries the eat/drink buttons. The card sits above the food, so
// reaching for a button always leaves the food's hover radius and passes over its
// neighbours on the way — with hover alone driving the target, that reach is a race
// between the cursor and whatever it crosses. A lock has nothing to race.

type Hover = {
  index?: number | null;
  x?: number;
  y?: number;
  label?: string;
  image?: string;
  drink?: boolean;
  // USED rather than eaten (a DLC toy laid on the tray with the meal): there is no
  // "one bite vs finish it" to choose between, so the tooltip collapses to one button
  play?: boolean;
  // the food's own crop for `image` ({x,y,w,h}, 0..1) — the tooltip frames exactly
  // the rectangle the admin chose rather than letterboxing the whole picture
  crop?: Crop | null;
  // mouthfuls left on this serving; shown on the "take a bite" button
  bitesLeft?: number;
  // The selection was CLICKED, not merely hovered — the card is pinned to this
  // serving and may offer the actions. Hover-only shows the name and how to pick it.
  locked?: boolean;
};

export default function Dining() {
  const [hover, setHover] = useState<Hover>({});
  const [busy, setBusy] = useState(false);

  useNuiEvent("diningHover", (d: Hover) => setHover(d || {}));

  // ESC hands the meal back (nothing is consumed) — mirrored in Lua so the props
  // and camera come down either way. Lua refuses mid-mouthful, and so does this: a
  // bite the server has already committed is not cancellable.
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape" && !busy) fetchNui("dining:close");
    };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
    // `busy` is in the deps on purpose: with [] the listener closes over the first
    // render's value and would post through a mouthful.
  }, [busy]);

  // Both actions are buttons on the LOCKED tooltip. A world click never eats — it
  // only picks what the buttons will act on.
  const act = async (event: string) => {
    if (busy || hover.index == null) return;
    setBusy(true);
    await fetchNui(event);
    setBusy(false);
  };

  const has = hover.index != null && !!hover.label;

  return (
    <div className="h-full w-full select-none">
      {/* The world click surface: a click anywhere that ISN'T the card locks the
          selection onto whatever the cursor is over (or clears it on empty space).
          It sits UNDER the tooltip and is a separate element, so a click on a button
          never reaches it. */}
      <div className="fixed inset-0 z-30" onPointerDown={() => fetchNui("dining:click")} />

      {/* the targeted food: the same card language the kitchen's bar tooltip uses */}
      {has && (
        <div
          className="pointer-events-none fixed z-40 -translate-x-1/2 -translate-y-[140%]"
          style={{ left: `${(hover.x ?? 0.5) * 100}%`, top: `${(hover.y ?? 0.5) * 100}%` }}
        >
          {/* pointer-events-auto ONLY on the card: the tooltip carries the buttons,
              while the rest of the screen stays a click-through surface for the world.
              A locked card reads as selected (brand border); an un-locked one is just
              a label. */}
          <div
            className={cn(
              "pointer-events-auto w-60 rounded-xl border bg-card p-3 text-center shadow-2xl",
              hover.locked ? "border-primary" : "border-border"
            )}
          >
            {hover.image && (
              <div className="mx-auto h-12 w-12 overflow-hidden rounded">
                <img
                  src={hover.image}
                  alt={hover.label}
                  className="h-full w-full object-cover"
                  // Honour the admin's crop: scale the picture so the chosen
                  // rectangle fills the frame, then offset to it. Falls back to a
                  // plain cover when the food never had one cropped.
                  style={
                    hover.crop && hover.crop.w > 0 && hover.crop.h > 0
                      ? {
                          width: `${100 / hover.crop.w}%`,
                          height: `${100 / hover.crop.h}%`,
                          objectFit: "cover",
                          transform: `translate(${-hover.crop.x * 100}%, ${-hover.crop.y * 100}%)`,
                          transformOrigin: "top left",
                          maxWidth: "none",
                        }
                      : undefined
                  }
                />
              </div>
            )}
            <div className="mt-1.5 text-sm font-semibold leading-tight">{hover.label}</div>
            {/* NOT selected yet: say how to select it, and offer nothing to aim at.
                The card can't be reached without crossing other food, so there is
                deliberately no action here to reach for. */}
            {!hover.locked && (
              <div className="mt-1.5 text-[11px] text-muted-foreground">{_L("dining.click_to_select")}</div>
            )}
            {/* one row, two buttons: a single mouthful (with how many are left) or
                the whole serving. A thing that is USED rather than eaten (a toy) is
                one action — offering it "one bite" of a plush would be nonsense — so
                it collapses to the single button. */}
            {hover.locked && (
            <div className="mt-2.5 flex gap-1.5">
              {hover.play ? (
                <button
                  disabled={busy}
                  onClick={() => act("dining:finish")}
                  className="flex-1 rounded-md bg-primary px-2 py-1.5 text-xs font-semibold text-primary-foreground transition hover:opacity-90 disabled:cursor-not-allowed disabled:bg-muted disabled:text-muted-foreground"
                >
                  {_L("dining.play_with")}
                </button>
              ) : (
                <>
                  <button
                    disabled={busy}
                    onClick={() => act("dining:bite")}
                    className="flex-1 rounded-md bg-secondary px-2 py-1.5 text-xs font-semibold transition hover:opacity-90 disabled:cursor-not-allowed disabled:opacity-50"
                  >
                    {_L(hover.drink ? "dining.take_sip" : "dining.take_bite")}
                    <span className="ml-1 font-mono tabular-nums opacity-60">({hover.bitesLeft ?? 1})</span>
                  </button>
                  <button
                    disabled={busy}
                    onClick={() => act("dining:finish")}
                    className="flex-1 rounded-md bg-primary px-2 py-1.5 text-xs font-semibold text-primary-foreground transition hover:opacity-90 disabled:cursor-not-allowed disabled:bg-muted disabled:text-muted-foreground"
                  >
                    {_L(hover.drink ? "dining.finish_drink" : "dining.finish_food")}
                  </button>
                </>
              )}
            </div>
            )}
          </div>
          <div className="absolute left-1/2 top-full h-0 w-0 -translate-x-1/2 border-x-[6px] border-t-[6px] border-x-transparent border-t-card" />
        </div>
      )}

      {/* NO bottom-of-screen hint. The seated help prompt already says ESC puts the
          meal away (modules/seating, which owns that line because it also owns what
          ESC does next), and the tooltip says how to pick a serving — a third copy
          of the same instruction was just furniture over the food. */}
    </div>
  );
}
