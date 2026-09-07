import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react-swc'
import tailwindcss from '@tailwindcss/vite'
import path from "path"

// https://vite.dev/config/
export default defineConfig({
  envDir: './env/',
  plugins: [react(), tailwindcss()],
  base: './',
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  build: {
    outDir: '../dist',
    // ../dist sits outside the project root, so vite won't clear it on its own and
    // old hashed assets pile up in the folder that actually ships
    emptyOutDir: true,
  },
})
