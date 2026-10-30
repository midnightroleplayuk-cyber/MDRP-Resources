import { createContext, useContext } from "react";

// The Panel publishes its content region (the area BELOW the header) here so a
// Modal renders scoped to that region — the scrim fades only the content, not
// the panel chrome. null when a Modal is used outside a Panel (it then falls
// back to a full-viewport overlay).
export const PanelContentContext = createContext<HTMLElement | null>(null);
export const usePanelContent = () => useContext(PanelContentContext);
