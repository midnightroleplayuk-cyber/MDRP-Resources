import { useCallback, useEffect } from 'react'
import { fireNuiEvent } from '@/nui/fireNuiEvent'
import { fetchNui, IN_GAME } from '@/nui/nui'
import { Icon } from '@/components/Icon'
import {
  applyUiSettings,
  DEFAULT_UI_SETTINGS,
  normalizeUiSettings,
  PERSPECTIVE_OPTIONS,
  UI_SETTINGS_RANGES,
  type UiSettingsState,
} from '@/utils/uiSettings'

function SliderRow({
  label,
  icon,
  value,
  min,
  max,
  step,
  onChange,
  disabled,
}: {
  label: string
  icon: string
  value: number
  min: number
  max: number
  step: number
  onChange: (value: number) => void
  disabled?: boolean
}) {
  const pct = max > min ? ((value - min) / (max - min)) * 100 : 0

  return (
    <div className="flex w-full flex-col gap-1.5">
      <div className="flex items-center gap-2">
        <Icon icon={icon} className="w-3.5 text-[11px] text-fg-mute" fixedWidth />
        <span className="text-[11.5px] font-medium text-fg-soft">{label}</span>
        <span className="ml-auto min-w-[36px] rounded-md border-[0.5px] border-[var(--rs-border-glow)] bg-surface-02 px-2 py-0.5 text-center font-mono text-[11px] text-accent">
          {value}
        </span>
      </div>
      <input
        type="range"
        className="star-slider w-full"
        min={min}
        max={max}
        step={step}
        value={value}
        disabled={disabled}
        onChange={(e) => onChange(Number(e.target.value))}
        style={{
          background: `linear-gradient(90deg, var(--rs-accent) ${pct}%, rgba(255,255,255,0.1) ${pct}%)`,
        }}
      />
    </div>
  )
}

interface Props {
  settings: UiSettingsState
  onChange: (next: UiSettingsState) => void
  interactive?: boolean
}

export function UiSettingsControls({ settings, onChange, interactive = true }: Props) {
  useEffect(() => {
    if (!IN_GAME) return
    fetchNui('getUiSettings', undefined, DEFAULT_UI_SETTINGS)
      .then((s) => onChange(normalizeUiSettings(s)))
      .catch(() => {})
  }, [onChange])

  const patch = useCallback(
    (partial: Partial<UiSettingsState>) => {
      const next = { ...settings, ...partial }
      applyUiSettings(next)
      fireNuiEvent('uiSettings', next)
      onChange(next)
    },
    [onChange, settings],
  )

  const reset = useCallback(() => {
    const next = normalizeUiSettings(DEFAULT_UI_SETTINGS)
    applyUiSettings(next)
    fireNuiEvent('uiSettings', next)
    onChange(next)
  }, [onChange])

  return (
    <div className="flex w-full flex-col gap-3.5">
      <SliderRow
        label="Panel transparency"
        icon="droplet"
        {...UI_SETTINGS_RANGES.transparency}
        value={settings.transparency}
        onChange={(transparency) => patch({ transparency })}
        disabled={!interactive}
      />
      <SliderRow
        label="Border radius"
        icon="square"
        {...UI_SETTINGS_RANGES.borderRadius}
        value={settings.borderRadius}
        onChange={(borderRadius) => patch({ borderRadius })}
        disabled={!interactive}
      />
      <SliderRow
        label="Gradient intensity"
        icon="palette"
        {...UI_SETTINGS_RANGES.gradientIntensity}
        value={settings.gradientIntensity}
        onChange={(gradientIntensity) => patch({ gradientIntensity })}
        disabled={!interactive}
      />

      <div className="flex w-full flex-col gap-1.5">
        <div className="flex items-center gap-2">
          <Icon icon="cube" className="text-[11px] text-fg-mute" fixedWidth />
          <span className="text-[11.5px] font-medium text-fg-soft">Panel perspective</span>
        </div>
        <div className="flex flex-wrap gap-1.5">
          {PERSPECTIVE_OPTIONS.map((opt) => {
            const active = settings.perspective === opt.value
            return (
              <button
                key={opt.value}
                type="button"
                disabled={!interactive}
                onClick={() => patch({ perspective: opt.value })}
                className={`inline-flex items-center rounded-[calc(8px*var(--border-radius-scale))] px-2.5 py-1.5 text-[11.5px] font-medium transition-colors duration-150 active:scale-[0.98] ${
                  active
                    ? 'bg-white/[0.08] text-fg [box-shadow:inset_0_0_0_1px_rgba(var(--accent-rgb),0.35)]'
                    : 'text-fg-soft hover:bg-white/[0.03] hover:text-fg'
                }`}
              >
                {opt.label}
              </button>
            )
          })}
        </div>
      </div>

      {!interactive ? null : (
      <button
        type="button"
        onClick={reset}
        className="inline-flex w-fit items-center gap-2 rounded-[calc(8px*var(--border-radius-scale))] px-2.5 py-1.5 text-[12px] font-medium text-fg-soft transition-colors duration-150 hover:bg-white/[0.03] hover:text-fg active:scale-[0.98]"
      >
        <Icon icon="rotate-left" fixedWidth /> Reset defaults
      </button>
      )}
    </div>
  )
}
