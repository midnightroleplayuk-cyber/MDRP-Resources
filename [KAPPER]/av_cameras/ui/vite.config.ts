import react from "@vitejs/plugin-react";
import { defineConfig } from "vite";

// https://vitejs.dev/config/
export default defineConfig(({ command }) => ({
  base: command === "build" ? "/ui/dist" : undefined,
  define: {
    global: "window",
  },
  css: {
    modules: {
      exportGlobals: true,
    },
  },
  build: {
    sourcemap: false,
  },
  optimizeDeps: {
    esbuildOptions: {
      mainFields: ["module", "main"],
      resolveExtensions: [".js", ".jsx", ".ts", ".tsx"],
    },
  },
  server: {
    port: 3000,
    open: true,
  },
  plugins: [react()],
}));
