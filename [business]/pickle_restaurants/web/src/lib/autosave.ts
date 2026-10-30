import { useEffect, useRef, useState } from "react";

export type SaveStatus = "idle" | "saving" | "saved";

// ── global "an auto-save is pending/in-flight" tracker ───────────────────────
// Lets the panel refuse to close mid-save (App.close waits on this) so a debounced
// write is never dropped. Counts a hook from the moment it goes dirty until its save
// resolves — NOT the 1.5s "Saved" display, so the count reflects real in-flight work.
let pending = 0;
const subs = new Set<() => void>();
function bump(delta: number) {
  pending = Math.max(0, pending + delta);
  subs.forEach((f) => f());
}
export function isSaving() { return pending > 0; }
export function onSavingChange(fn: () => void): () => void {
  subs.add(fn);
  return () => { subs.delete(fn); };
}

// Debounced auto-save. Whenever `deps` change (after the first render), it waits
// `delay` ms of quiet and then runs `save` — so edits persist automatically with no
// Save button. Returns a status for an inline "Saving…/Saved" hint. The first render
// never saves. Any owed save is FLUSHED on unmount (group switch / panel close) so it
// isn't lost, and counts toward `isSaving()` so the panel won't close mid-write.
export function useAutoSave(save: () => Promise<unknown> | unknown, deps: unknown[], delay = 600): SaveStatus {
  const [status, setStatus] = useState<SaveStatus>("idle");
  const first = useRef(true);
  const owing = useRef(false);          // this hook owes a save (counted in `pending`)
  const mounted = useRef(true);
  const saveRef = useRef(save);
  saveRef.current = save;               // always call the latest closure
  const savedTimer = useRef<number | null>(null);

  // Run the owed save now (called by the debounce timer OR flush-on-unmount).
  const flush = useRef(async () => {
    if (!owing.current) return;
    owing.current = false;
    try { await saveRef.current(); }
    finally {
      bump(-1);
      if (mounted.current) {
        setStatus("saved");
        if (savedTimer.current) window.clearTimeout(savedTimer.current);
        savedTimer.current = window.setTimeout(() => { if (mounted.current) setStatus("idle"); }, 1500);
      }
    }
  });

  useEffect(() => {
    if (first.current) { first.current = false; return; }
    if (!owing.current) { owing.current = true; bump(1); } // mark dirty (blocks close)
    setStatus("saving");
    const t = window.setTimeout(() => { void flush.current(); }, delay);
    return () => window.clearTimeout(t);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, deps);

  // Flush any owed save on unmount so switching groups / closing the panel can't drop it.
  useEffect(() => () => { mounted.current = false; void flush.current(); }, []);

  return status;
}
