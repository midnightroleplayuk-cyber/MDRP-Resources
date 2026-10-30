/** @type {import('tailwindcss').Config} */

// Tokens are "R G B" triplet custom properties (set by lib/theme.ts) consumed
// as rgb(var(--x) / alpha) — plain CSS Color 4 syntax that FiveM's CEF supports
// (it predates color-mix()/relative colors, so no modern color functions here).
const token = (v) => `rgb(${v} / <alpha-value>)`;

export default {
  darkMode: ["class"],
  content: ["./index.html", "./src/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        border: token("var(--line)"),
        input: token("var(--line)"),
        ring: token("var(--brand)"),
        background: token("var(--bg)"),
        foreground: token("var(--ink)"),
        primary: { DEFAULT: token("var(--brand)"), foreground: token("var(--brand-ink)") },
        // `brand`/`brand-ink` are aliases of the primary seed for the phone app, which
        // styles with `bg-brand`/`text-brand-ink`/`border-brand` (nested keys flatten to
        // `-ink`/`-hover`/`-active`). Same tokens as `primary`, just the phone's vocabulary.
        brand: {
          DEFAULT: token("var(--brand)"),
          ink: token("var(--brand-ink)"),
          hover: token("var(--brand-hover)"),
          active: token("var(--brand-active)"),
        },
        secondary: { DEFAULT: token("var(--card-2)"), foreground: token("var(--ink)") },
        destructive: { DEFAULT: token("var(--danger)"), foreground: "#fff7f5" },
        muted: { DEFAULT: token("var(--sunk)"), foreground: token("var(--ink-mute)") },
        accent: { DEFAULT: token("var(--wash)"), foreground: token("var(--ink)") },
        card: { DEFAULT: token("var(--card)"), foreground: token("var(--ink)") },
        popover: { DEFAULT: token("var(--card-2)"), foreground: token("var(--ink)") },
        ok: token("var(--ok)"),
        warn: token("var(--warn)"),
        paper: { DEFAULT: token("var(--paper)"), foreground: token("var(--paper-ink)"), muted: token("var(--paper-mute)") },
      },
      fontFamily: {
        sans: ['"Figtree Variable"', "ui-sans-serif", "system-ui", "sans-serif"],
        display: ['"Bricolage Grotesque Variable"', '"Figtree Variable"', "ui-sans-serif", "sans-serif"],
        mono: ['"Spline Sans Mono Variable"', "ui-monospace", "SFMono-Regular", "monospace"],
      },
      borderRadius: {
        lg: "var(--radius)",
        md: "calc(var(--radius) - 2px)",
        sm: "calc(var(--radius) - 4px)",
      },
      keyframes: {
        "fade-in": { from: { opacity: "0", transform: "translateY(8px)" }, to: { opacity: "1", transform: "translateY(0)" } },
        "pop-in": { from: { opacity: "0", transform: "scale(0.975)" }, to: { opacity: "1", transform: "scale(1)" } },
        // a modal scrim fading in (opacity only — no translate, it's full-bleed)
        "scrim": { from: { opacity: "0" }, to: { opacity: "1" } },
        // a dialog rising + scaling into place over the scrim
        "dialog-in": { from: { opacity: "0", transform: "translateY(10px) scale(0.97)" }, to: { opacity: "1", transform: "translateY(0) scale(1)" } },
        // a receipt sliding out of the printer
        "print": { from: { opacity: "0", transform: "translateY(-14px)" }, to: { opacity: "1", transform: "translateY(0)" } },
      },
      animation: {
        "fade-in": "fade-in 0.18s ease-out",
        "pop-in": "pop-in 0.16s ease-out",
        "scrim": "scrim 0.15s ease-out",
        "dialog-in": "dialog-in 0.19s cubic-bezier(0.2, 0.9, 0.3, 1)",
        "print": "print 0.28s cubic-bezier(0.2, 0.9, 0.3, 1)",
      },
    },
  },
  plugins: [],
};
