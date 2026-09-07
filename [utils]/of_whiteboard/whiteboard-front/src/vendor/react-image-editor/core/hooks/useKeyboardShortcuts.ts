import { useEffect } from "react";

import { CleanupManager, addTrackedEventListener } from "../utils";

export interface KeyboardShortcutHandlers {
  onUndo?: () => void;
  onRedo?: () => void;
  onDelete?: () => void;
  canDelete?: () => boolean;
}

export function useKeyboardShortcuts(
  handlers: KeyboardShortcutHandlers
): void {
  const { onUndo, onRedo, onDelete, canDelete } = handlers;

  useEffect(() => {
    const cleanup = new CleanupManager();

    const onKeyDown = (e: KeyboardEvent) => {
      if ((e.ctrlKey || e.metaKey) && e.key === "z" && !e.shiftKey) {
        e.preventDefault();
        onUndo?.();
      }

      if (
        ((e.ctrlKey || e.metaKey) && e.key === "y") ||
        ((e.ctrlKey || e.metaKey) && e.shiftKey && e.key === "z")
      ) {
        e.preventDefault();
        onRedo?.();
      }

      if (e.key === "Delete" || e.key === "Backspace") {
        const activeElement = document.activeElement;
        const isInputFocused =
          activeElement?.tagName === "INPUT" ||
          activeElement?.tagName === "TEXTAREA";

        if (!isInputFocused && canDelete?.()) {
          e.preventDefault();
          onDelete?.();
        }
      }
    };

    addTrackedEventListener(window, "keydown", onKeyDown, cleanup);

    return () => {
      cleanup.cleanup();
    };
  }, [onUndo, onRedo, onDelete, canDelete]);
}

export default useKeyboardShortcuts;
