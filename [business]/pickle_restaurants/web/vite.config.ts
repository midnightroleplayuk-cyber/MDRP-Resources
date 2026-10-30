import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import path from "path";

export default defineConfig({
  plugins: [react()],
  base: "./",
  build: {
    outDir: "../nui",
    emptyOutDir: true,
    // PINNED: FiveM ships CEF 103 (Chromium 103). Vite 5's default target
    // ("modules" → chrome87) happens to be safe, but newer Vite defaults to
    // baseline-widely-available (chrome111) — a major bump would silently emit
    // syntax CEF can't parse and break the WHOLE NUI, not just one view.
    target: "chrome103",
    chunkSizeWarningLimit: 2000,
    rollupOptions: {
      // TWO html entries emitted in ONE pass (so emptyOutDir stays safe):
      //   index.html → the in-world NUI / DUIs (App / KioskDui / RegisterDui)
      //   phone.html → the lb-phone companion app (served as nui/phone.html)
      input: {
        main: path.resolve(__dirname, "index.html"),
        phone: path.resolve(__dirname, "phone.html"),
      },
    },
  },
  resolve: {
    alias: { "@": path.resolve(__dirname, "./src") },
  },
});
