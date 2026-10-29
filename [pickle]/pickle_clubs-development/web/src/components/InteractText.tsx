import { useState } from "react";
import { useNuiEvent } from "../providers/nui/useNui";

export function InteractText() {
  const [text, setText] = useState<string | null>(null);

  useNuiEvent("setInteractText", (data: { text?: string | null }) => {
    const value = data.text ?? null;
    setText(typeof value === "string" && value.length > 0 ? value : null);
  });

  if (text == null || text === "") return null;

  return (
    <div
      className="absolute bottom-[80px] left-1/2 -translate-x-1/2 pointer-events-none z-[1000] bg-background/95 border border-border rounded-md px-4 py-2 text-primary text-sm whitespace-pre-line"
      style={{ maxWidth: "90vw" }}
    >
      {text}
    </div>
  );
}
