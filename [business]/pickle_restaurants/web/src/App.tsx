import { useState, useCallback, useEffect, Component, type ReactNode } from "react";
import { useNuiEvent, fetchNui, setPeek } from "@/lib/nui";
import { isSaving, onSavingChange } from "@/lib/autosave";
import { applyTheme } from "@/lib/theme";
import InteractText from "@/views/InteractText";
import TicketsWidget from "@/views/TicketsWidget";
import Cooking from "@/views/Cooking";
import Admin from "@/views/Admin";
import Management from "@/views/Management";
import Register from "@/views/Register";
import Order from "@/views/Order";
import PayConfirm from "@/views/PayConfirm";
import Dining from "@/views/Dining";

type View = "none" | "cooking" | "admin" | "management" | "register" | "order" | "payconfirm" | "dining";

// Contains a render error in any single view (e.g. a malformed payload) so it
// can't white-screen the whole NUI — the panel closes and control returns to the
// game instead of leaving a dead, focus-stealing overlay. Resets when the view
// changes (keyed by `view`), so reopening a panel is a clean mount.
class ViewErrorBoundary extends Component<{ children: ReactNode; onError: () => void }, { failed: boolean }> {
  state = { failed: false };
  static getDerivedStateFromError() { return { failed: true }; }
  componentDidCatch(err: unknown) { console.error("[pickle_restaurants] view crashed:", err); this.props.onError(); }
  render() { return this.state.failed ? null : this.props.children; }
}

export default function App() {
  const [view, setView] = useState<View>("none");
  const [data, setData] = useState<any>(null);

  useNuiEvent("setView", (d) => {
    const v = (d.view || "none") as View;
    setView(v);
    setData(d.data ?? null);
    // Restaurant-scoped payloads carry the franchise theme seed; closing (or a
    // payload without one) resets the UI to the default kit.
    applyTheme(v === "none" ? null : d.data?.theme);
    // Any panel that (re)opens must start at full opacity — clear a leftover
    // prop-hover "peek" fade (e.g. a placement/edit hand-off closed the panel
    // mid-hover), so a reopened panel is never rendered washed out.
    setPeek(false);
  });

  // Re-skin the NUI to a panel's theme without switching views. Object placement
  // runs with the panel closed but keeps drawing the InteractText control hints;
  // it re-asserts the launching panel's theme (admin app theme / boss restaurant
  // theme) so those hints aren't stranded on the default kit. `null` → default.
  useNuiEvent("applyTheme", (d) => applyTheme(d?.theme ?? null));

  const doClose = useCallback(() => {
    setView("none");
    fetchNui("close");
  }, []);

  // Don't close mid-save: if a debounced setting write is pending/in-flight, keep the
  // panel open and close as soon as it lands (so no edit is dropped). A fallback timer
  // guarantees the UI can't get stuck if a save ever hangs.
  const close = useCallback(() => {
    if (!isSaving()) { doClose(); return; }
    let done = false;
    const finish = () => {
      if (done) return;
      done = true;
      unsub();
      window.clearTimeout(fallback);
      doClose();
    };
    const unsub = onSavingChange(() => { if (!isSaving()) finish(); });
    const fallback = window.setTimeout(finish, 4000);
  }, [doClose]);

  // ESC closes panel views (cooking manages its own escape).
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      // cooking and the eat-in meal view own their escape (world props + a camera)
      if (e.key === "Escape" && view !== "none" && view !== "cooking" && view !== "dining") close();
    };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [view, close]);

  return (
    <div className="peek-fade h-full w-full">
      {view === "none" && <InteractText />}

      {/* Persistent read-only ticket board — self-gates on its own `ticketWidget`
          message, so it survives view switches and lives outside the per-view
          error boundary. */}
      <TicketsWidget />

      {view !== "none" && (
        <ViewErrorBoundary key={view} onError={doClose}>
          {view === "cooking" && <Cooking data={data} />}
          {view === "admin" && <Admin data={data} onClose={close} />}
          {view === "management" && <Management data={data} onClose={close} />}
          {view === "register" && <Register data={data} onClose={close} />}
          {view === "order" && <Order data={data} onClose={close} />}
          {view === "payconfirm" && <PayConfirm data={data} />}
          {view === "dining" && <Dining />}
        </ViewErrorBoundary>
      )}
    </div>
  );
}
