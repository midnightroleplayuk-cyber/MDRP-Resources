export const DEFAULT_UI_SETTINGS = {
  transparency: 100,
  borderRadius: 10,
  gradientIntensity: 0,
  perspective: 'none',
} as const

export type UiSettings = {
  transparency?: number
  borderRadius?: number
  gradientIntensity?: number
  perspective?: string
}

export type UiSettingsPreviewKey = keyof typeof DEFAULT_UI_SETTINGS

export const UI_SETTINGS_RANGES = {
  transparency: { min: 50, max: 100, step: 1 },
  borderRadius: { min: 0, max: 20, step: 1 },
  gradientIntensity: { min: 0, max: 100, step: 1 },
} as const

export type UiSettingsState = {
  transparency: number
  borderRadius: number
  gradientIntensity: number
  perspective: string
}

export function normalizeUiSettings(s: UiSettings = DEFAULT_UI_SETTINGS): UiSettingsState {
  return {
    transparency: s.transparency ?? DEFAULT_UI_SETTINGS.transparency,
    borderRadius: s.borderRadius ?? DEFAULT_UI_SETTINGS.borderRadius,
    gradientIntensity: s.gradientIntensity ?? DEFAULT_UI_SETTINGS.gradientIntensity,
    perspective: s.perspective ?? DEFAULT_UI_SETTINGS.perspective,
  }
}

export const PERSPECTIVE_OPTIONS = [
  { value: 'none', label: 'None' },
  { value: 'tilt-10', label: 'Slight tilt' },
  { value: 'tilt-20', label: 'Medium tilt' },
  { value: 'tilt-30', label: 'Strong tilt' },
] as const

// ox_lib /ox_lib menu slider semantics: transparency 50-100 (%), borderRadius
// 0-20 (scale x10), gradientIntensity 0-100 (% of 0.08 max alpha).
export function applyUiSettings(s: UiSettings) {
  const root = document.documentElement
  if (s.transparency != null) {
    root.style.setProperty('--container-transparency', String(Number(s.transparency) / 100))
  }
  if (s.borderRadius != null) {
    root.style.setProperty('--border-radius-scale', String(Number(s.borderRadius) / 10))
  }
  if (s.gradientIntensity != null) {
    root.style.setProperty('--gradient-intensity', String((Number(s.gradientIntensity) / 100) * 0.08))
  }
  if (s.perspective != null) {
    if (s.perspective === 'none') root.removeAttribute('data-perspective')
    else root.setAttribute('data-perspective', String(s.perspective))
  }
}
