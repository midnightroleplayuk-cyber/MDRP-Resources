/** Mantine default palettes (v6/v7) — keys match `setr ox:primaryColor` values. */
const MANTINE_COLORS: Record<string, readonly string[]> = {
  dark: ['#C9C9C9', '#b8b8b8', '#828282', '#696969', '#424242', '#3b3b3b', '#2e2e2e', '#242424', '#1f1f1f', '#141414'],
  gray: ['#f8f9fa', '#f1f3f5', '#e9ecef', '#dee2e6', '#ced4da', '#adb5bd', '#868e96', '#495057', '#343a40', '#212529'],
  red: ['#fff5f5', '#ffe3e3', '#ffc9c9', '#ffa8a8', '#ff8787', '#ff6b6b', '#fa5252', '#f03e3e', '#e03131', '#c92a2a'],
  pink: ['#fff0f6', '#ffdeeb', '#fcc2d7', '#faa2c1', '#f783ac', '#f06595', '#e64980', '#d6336c', '#c2255c', '#a61e4d'],
  grape: ['#f8f0fc', '#f3d9fa', '#eebefa', '#e599f7', '#da77f2', '#cc5de8', '#be4bdb', '#ae3ec9', '#9c36b5', '#862e9c'],
  violet: ['#f3f0ff', '#e5dbff', '#d0bfff', '#b197fc', '#9775fa', '#845ef7', '#7950f2', '#7048e8', '#6741d9', '#5f3dc4'],
  indigo: ['#edf2ff', '#dbe4ff', '#bac8ff', '#91a7ff', '#748ffc', '#5c7cfa', '#4c6ef5', '#4263eb', '#3b5bdb', '#364fc7'],
  blue: ['#e7f5ff', '#d0ebff', '#a5d8ff', '#74c0fc', '#4dabf7', '#339af0', '#228be6', '#1c7ed6', '#1971c2', '#1864ab'],
  cyan: ['#e3fafc', '#c5f6fa', '#99e9f2', '#66d9e8', '#3bc9db', '#22b8cf', '#15aabf', '#1098ad', '#0c8599', '#0b7285'],
  teal: ['#e6fcf5', '#c3fae8', '#96f2d7', '#63e6be', '#38d9a9', '#20c997', '#12b886', '#0ca678', '#099268', '#087f5b'],
  green: ['#ebfbee', '#d3f9d8', '#b2f2bb', '#8ce99a', '#69db7c', '#51cf66', '#40c057', '#37b24d', '#2f9e44', '#2b8a3e'],
  lime: ['#f4fce3', '#e9fac8', '#d8f5a2', '#c0eb75', '#a9e34b', '#94d82d', '#82c91e', '#74b816', '#66a80f', '#5c940d'],
  yellow: ['#fff9db', '#fff3bf', '#ffec99', '#ffe066', '#ffd43b', '#fcc419', '#fab005', '#f59f00', '#f08c00', '#e67700'],
  orange: ['#fff4e6', '#ffe8cc', '#ffd8a8', '#ffc078', '#ffa94d', '#ff922b', '#fd7e14', '#f76707', '#e8590c', '#d9480f'],
}

/** Jakers RS brand palette — default when convars are unset. Shade 5 = accent, 4 = hi. */
const JAKERS_PALETTE = [
  '#f7ffe0',
  '#efffc2',
  '#e8ff8a',
  '#e4ff5c',
  '#E0FF45',
  '#CDFF03',
  '#b8d902',
  '#94b302',
  '#708c02',
  '#566f02',
] as const

export const THEME_PALETTES: Record<string, readonly string[]> = {
  ...MANTINE_COLORS,
  jakers: JAKERS_PALETTE,
}

export const DEFAULT_PRIMARY_COLOR = 'jakers'
export const DEFAULT_PRIMARY_SHADE = 5

export interface ThemeConfig {
  primaryColor?: string
  primaryShade?: number
}

function hexToRgb(hex: string): string {
  const raw = hex.replace('#', '')
  const normalized =
    raw.length === 3
      ? raw
          .split('')
          .map((c) => c + c)
          .join('')
      : raw
  const n = Number.parseInt(normalized, 16)
  return `${(n >> 16) & 255}, ${(n >> 8) & 255}, ${n & 255}`
}

function clampShade(shade: number): number {
  return Math.max(0, Math.min(9, Math.round(shade)))
}

function resolvePalette(name: string): readonly string[] {
  return THEME_PALETTES[name.toLowerCase()] ?? JAKERS_PALETTE
}

/** Apply `ox:primaryColor` / `ox:primaryShade` to accent CSS variables. */
export function applyThemeConfig(config: ThemeConfig): void {
  const palette = resolvePalette(config.primaryColor ?? DEFAULT_PRIMARY_COLOR)
  const shade = clampShade(config.primaryShade ?? DEFAULT_PRIMARY_SHADE)
  const accent = palette[shade]
  const accentHi = palette[Math.max(0, shade - 1)]

  const root = document.documentElement
  const rgb = hexToRgb(accent)

  root.style.setProperty('--accent-rgb', rgb)
  root.style.setProperty('--accent-hi-rgb', hexToRgb(accentHi))
  root.style.setProperty('--rs-accent', accent)
  root.style.setProperty('--rs-accent-hi', accentHi)
  root.style.setProperty('--rs-success', accent)
  root.style.setProperty('--success-rgb', rgb)
}
