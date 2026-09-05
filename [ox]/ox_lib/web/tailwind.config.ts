import type { Config } from 'tailwindcss'

export default {
  content: ['./index.html', './src/**/*.{ts,tsx}'],
  corePlugins: {
    preflight: false,
  },
  theme: {
    extend: {
      colors: {
        bg: 'var(--rs-bg)',
        'surface-01': 'var(--rs-surface-01)',
        'surface-02': 'var(--rs-surface-02)',
        'surface-03': 'var(--rs-surface-03)',
        panel: 'var(--rs-panel)',
        'panel-hi': 'var(--rs-panel-hi)',
        fg: 'var(--rs-fg)',
        'fg-soft': 'var(--rs-fg-soft)',
        'fg-mute': 'var(--rs-fg-mute)',
        sep: 'var(--rs-sep)',
        accent: 'rgb(var(--accent-rgb) / <alpha-value>)',
        'accent-hi': 'rgb(var(--accent-hi-rgb) / <alpha-value>)',
        'accent-soft': 'var(--rs-accent-soft)',
        danger: 'rgb(239 68 68 / <alpha-value>)',
        warning: 'rgb(255 149 0 / <alpha-value>)',
        success: 'rgb(205 255 3 / <alpha-value>)',
        info: 'rgb(232 232 232 / <alpha-value>)',
      },
      borderRadius: {
        sm: 'var(--rs-radius-sm)',
        md: 'var(--rs-radius-md)',
        lg: 'var(--rs-radius-lg)',
        xl: 'var(--rs-radius-xl)',
        pill: 'var(--rs-radius-pill)',
        icon: 'var(--rs-radius-icon)',
      },
      fontFamily: {
        display: 'var(--font-display)',
        body: 'var(--font-body)',
        mono: 'var(--font-mono)',
      },
      transitionTimingFunction: {
        out: 'var(--ease-out)',
      },
    },
  },
  plugins: [],
} satisfies Config
