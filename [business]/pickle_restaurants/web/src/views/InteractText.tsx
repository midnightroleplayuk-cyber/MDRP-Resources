import { useState } from "react";
import { useNuiEvent } from "@/lib/nui";

// Mirrors the core/client.lua contract: SendNUIMessage({ type:"setInteractText", text })
export default function InteractText() {
  const [text, setText] = useState<string | null>(null);
  useNuiEvent("setInteractText", (d) => setText(d.text ?? null));

  if (!text) return null;
  return (
    <div className="pointer-events-none fixed inset-x-0 bottom-24 flex justify-center">
      {/* No backdrop-filter: on a transparent NUI page CEF composites it as an
          opaque black rectangle. Use a solid card colour instead. */}
      <div className="animate-fade-in flex items-stretch overflow-hidden rounded-md border border-border bg-card shadow-xl">
        <div className="w-1 shrink-0 bg-primary" />
        <div className="whitespace-pre-line px-3.5 py-2 text-center text-sm font-medium text-foreground">
          {text}
        </div>
      </div>
    </div>
  );
}
