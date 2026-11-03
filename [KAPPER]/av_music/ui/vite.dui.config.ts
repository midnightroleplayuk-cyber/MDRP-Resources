import { defineConfig } from "vite";
import { resolve } from "path";

const duiRoot = resolve(__dirname, "src/dui");

export default defineConfig({
  root: duiRoot,
  base: "",
  build: {
    outDir: resolve(__dirname, "../html"),
    emptyOutDir: false,
    minify: "oxc",
    rollupOptions: {
      input: {
        "yt-player": resolve(duiRoot, "yt-player.html"),
        "yt-dui": resolve(duiRoot, "yt-dui.html"),
      },
      output: {
        entryFileNames: "assets/[name].js",
        chunkFileNames: "assets/[name].js",
        assetFileNames: "assets/[name][extname]",
      },
    },
  },
});
