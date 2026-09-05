import { useState } from 'react'
import type { InputDialogRow } from '@/types'
import { Icon } from '../Icon'
import { ContextIconFrame } from '../ContextMenu/ContextIconFrame'
import { Combobox } from './Combobox'

interface Props {
  row: InputDialogRow
  value: unknown
  onChange: (value: unknown) => void
  error: string | null
  showError: boolean
}

const FIELD_BASE =
  'w-full rounded-md border-[0.5px] bg-surface-02 px-3.5 py-2.5 text-[14px] text-fg outline-none transition-all duration-150 placeholder:text-fg-mute'

function Label({ row, counter }: { row: InputDialogRow; counter?: React.ReactNode }) {
  return (
    <div className="mb-2 flex items-center gap-2.5">
      {row.icon && (
        <ContextIconFrame iconRgb="232,232,232">
          <Icon icon={row.icon} color={row.iconColor ?? 'rgba(255,255,255,0.82)'} fixedWidth />
        </ContextIconFrame>
      )}
      <span className="text-[12.5px] font-semibold leading-tight tracking-[-0.01em] text-fg">
        {row.label}
        {row.required && <span className="ml-1 text-danger">*</span>}
      </span>
      {counter && <span className="ml-auto font-mono text-[9.5px] text-fg-mute">{counter}</span>}
    </div>
  )
}

export function DialogRow({ row, value, onChange, error, showError }: Props) {
  const [reveal, setReveal] = useState(false)
  const [msQuery, setMsQuery] = useState('')
  const errored = showError && !!error

  const fieldCls = `${FIELD_BASE} ${
    errored
      ? 'border-danger/70 focus:border-danger/70 focus:[box-shadow:0_0_0_3px_rgba(var(--danger-rgb),0.12)]'
      : 'border-white/[0.08] hover:bg-white/[0.03] focus:border-white/[0.14] focus:bg-white/[0.04]'
  }`

  if (row.type === 'checkbox') {
    const on = value === true
    return (
      <div>
        <label
          className={`flex cursor-pointer items-center justify-between gap-3 rounded-lg border-[0.5px] px-3.5 py-3 transition-colors ${
            errored ? 'border-danger/50 bg-[rgba(var(--danger-rgb),0.05)]' : 'border-white/[0.05] bg-surface-02 hover:bg-white/[0.03]'
          }`}
        >
          <div className="min-w-0">
            <span className="text-[12.5px] font-semibold leading-tight tracking-[-0.01em] text-fg">{row.label}</span>
            {row.description && <p className="mt-0.5 text-[11.5px] leading-[1.4] text-fg-soft">{row.description}</p>}
          </div>
          <button
            type="button"
            disabled={row.disabled}
            onClick={() => onChange(!on)}
            className={`relative h-[26px] w-[46px] shrink-0 rounded-pill border-[0.5px] transition-all duration-200 ${
              on
                ? 'border-accent/80 bg-[linear-gradient(135deg,var(--rs-accent)_0%,var(--rs-accent-hi)_100%)] [box-shadow:0_0_12px_rgba(var(--accent-rgb),0.35)]'
                : 'border-white/[0.08] bg-white/10'
            }`}
          >
            <span
              className={`absolute top-[2px] h-[21px] w-[21px] rounded-full transition-transform duration-200 [box-shadow:0_2px_6px_rgba(0,0,0,0.45)] ${
                on ? 'translate-x-[21px] bg-[#101010]' : 'translate-x-[2px] bg-white'
              }`}
            />
          </button>
        </label>
        <ErrorMsg show={errored} text={error} />
      </div>
    )
  }

  const counter =
    (row.type === 'input' || row.type === 'textarea') && row.maxLength
      ? `${(value as string)?.length ?? 0}/${row.maxLength}`
      : row.type === 'multi-select' && row.maxSelectedValues
        ? `${((value as string[]) ?? []).length}/${row.maxSelectedValues}`
        : undefined

  return (
    <div>
      <Label row={row} counter={counter} />
      {row.description && <p className="-mt-1 mb-2 text-[11.5px] leading-[1.4] text-fg-soft">{row.description}</p>}

      {(() => {
        switch (row.type) {
          case 'input':
            return (
              <div className="relative">
                <input
                  type={row.password && !reveal ? 'password' : 'text'}
                  className={`${fieldCls} ${row.password ? 'pr-10' : ''}`}
                  placeholder={row.placeholder}
                  disabled={row.disabled}
                  minLength={row.minLength}
                  maxLength={row.maxLength}
                  value={(value as string) ?? ''}
                  onChange={(e) => onChange(e.target.value)}
                />
                {row.password && (
                  <button
                    type="button"
                    onClick={() => setReveal((r) => !r)}
                    className="absolute right-3 top-1/2 -translate-y-1/2 text-fg-mute transition-colors hover:text-fg"
                  >
                    <Icon icon={reveal ? 'eye-slash' : 'eye'} fixedWidth />
                  </button>
                )}
              </div>
            )

          case 'textarea':
            return (
              <textarea
                ref={(el) => {
                  if (el && row.autosize) {
                    el.style.height = 'auto'
                    el.style.height = `${el.scrollHeight}px`
                  }
                }}
                className={`${fieldCls} min-h-[92px] leading-relaxed ${row.autosize ? 'resize-none overflow-hidden' : 'resize-y'}`}
                placeholder={row.placeholder}
                disabled={row.disabled}
                maxLength={row.maxLength}
                value={(value as string) ?? ''}
                onChange={(e) => onChange(e.target.value)}
              />
            )

          case 'number': {
            const step = row.step ?? 1
            const cur = typeof value === 'number' && Number.isFinite(value) ? value : row.min ?? 0
            const clamp = (n: number) => {
              if (row.min != null) n = Math.max(row.min, n)
              if (row.max != null) n = Math.min(row.max, n)
              return n
            }
            return (
              <div className="relative">
                <input
                  type="number"
                  className={`${fieldCls} pr-[60px]`}
                  placeholder={row.placeholder}
                  disabled={row.disabled}
                  min={row.min}
                  max={row.max}
                  step={step}
                  value={value as number}
                  onChange={(e) => onChange(e.target.value === '' ? '' : Number(e.target.value))}
                />
                <div className="absolute right-1.5 top-1/2 flex -translate-y-1/2 items-center gap-1">
                  <Stepper icon="minus" disabled={row.disabled} onClick={() => onChange(clamp(cur - step))} />
                  <Stepper icon="plus" disabled={row.disabled} onClick={() => onChange(clamp(cur + step))} />
                </div>
              </div>
            )
          }

          case 'slider': {
            const min = row.min ?? 0
            const max = row.max ?? 100
            const v = (value as number) ?? min
            const pct = max > min ? ((v - min) / (max - min)) * 100 : 0
            return (
              <div className="flex items-center gap-3.5">
                <input
                  type="range"
                  className="star-slider flex-1"
                  disabled={row.disabled}
                  min={min}
                  max={max}
                  step={row.step ?? 1}
                  value={v}
                  onChange={(e) => onChange(Number(e.target.value))}
                  style={{
                    background: `linear-gradient(90deg, var(--rs-accent) ${pct}%, rgba(255,255,255,0.1) ${pct}%)`,
                  }}
                />
                <span className="min-w-[48px] rounded-md border-[0.5px] border-[var(--rs-border-glow)] bg-surface-02 px-2.5 py-1.5 text-center font-mono text-[13px] text-accent">
                  {v}
                </span>
              </div>
            )
          }

          case 'select':
            return (
              <Combobox
                options={row.options ?? []}
                value={(value as string) ?? ''}
                onChange={onChange}
                placeholder={row.placeholder}
                disabled={row.disabled}
                searchable={row.searchable}
                clearable={row.clearable}
                errored={errored}
              />
            )

          case 'multi-select': {
            const selected = (value as string[]) ?? []
            const cap = row.maxSelectedValues
            const atCap = cap != null && selected.length >= cap
            const toggle = (val: string) => {
              if (selected.includes(val)) return onChange(selected.filter((s) => s !== val))
              if (atCap) return
              onChange([...selected, val])
            }
            const opts =
              row.searchable && msQuery
                ? (row.options ?? []).filter((o) => o.label.toLowerCase().includes(msQuery.toLowerCase()))
                : row.options ?? []
            return (
              <div
                className={`overflow-hidden rounded-md border-[0.5px] bg-surface-02 ${
                  errored ? 'border-danger/60' : 'border-white/[0.08]'
                }`}
              >
                {row.searchable && (
                  <div className="flex items-center gap-2 border-b-[0.5px] border-sep px-3 py-2">
                    <Icon icon="magnifying-glass" className="text-[11px] text-fg-mute" fixedWidth />
                    <input
                      value={msQuery}
                      onChange={(e) => setMsQuery(e.target.value)}
                      placeholder="Search…"
                      className="w-full bg-transparent text-[13px] text-fg outline-none placeholder:text-fg-mute"
                    />
                  </div>
                )}
                <div className="sb-scroll flex max-h-[176px] flex-col gap-1 p-1.5">
                  {opts.length > 0 ? (
                    opts.map((opt) => {
                      const on = selected.includes(opt.value)
                      const locked = !on && atCap
                      return (
                        <button
                          key={opt.value}
                          type="button"
                          disabled={locked}
                          onClick={() => toggle(opt.value)}
                          className={`flex items-center gap-2.5 rounded-[calc(7px*var(--border-radius-scale))] px-2.5 py-2 text-left text-[13.5px] transition-colors duration-150 ${
                            on
                              ? 'bg-white/[0.04] text-fg'
                              : locked
                                ? 'cursor-not-allowed text-fg-mute opacity-50'
                                : 'text-fg-soft hover:bg-white/[0.03]'
                          }`}
                        >
                          <span
                            className={`grid h-[18px] w-[18px] shrink-0 place-items-center rounded-[calc(5px*var(--border-radius-scale))] border-[0.5px] text-[10px] transition-colors ${
                              on ? 'border-accent bg-accent text-[#101010]' : 'border-white/15 bg-transparent text-transparent'
                            }`}
                          >
                            <Icon icon="check" fixedWidth />
                          </span>
                          {opt.label}
                        </button>
                      )
                    })
                  ) : (
                    <p className="px-2.5 py-3 text-center text-[12px] text-fg-mute">No results</p>
                  )}
                </div>
              </div>
            )
          }

          case 'date':
            return (
              <input
                type="date"
                className={`${fieldCls} [color-scheme:dark]`}
                disabled={row.disabled}
                value={(value as string) ?? ''}
                onChange={(e) => onChange(e.target.value)}
              />
            )

          case 'time':
            return (
              <input
                type="time"
                className={`${fieldCls} [color-scheme:dark]`}
                disabled={row.disabled}
                value={(value as string) ?? ''}
                onChange={(e) => onChange(e.target.value)}
              />
            )

          case 'date-range': {
            const range = (value as string) ?? ''
            const [from, to] = range.split('|')
            const setPart = (which: 0 | 1, part: string) => {
              const next = which === 0 ? [part, to ?? ''] : [from ?? '', part]
              onChange(next.join('|'))
            }
            return (
              <div className="flex items-center gap-2.5">
                <input
                  type="date"
                  className={`${fieldCls} [color-scheme:dark]`}
                  value={from ?? ''}
                  onChange={(e) => setPart(0, e.target.value)}
                />
                <Icon icon="arrow-right-long" className="shrink-0 text-fg-mute" fixedWidth />
                <input
                  type="date"
                  className={`${fieldCls} [color-scheme:dark]`}
                  value={to ?? ''}
                  onChange={(e) => setPart(1, e.target.value)}
                />
              </div>
            )
          }

          case 'color': {
            const hex = (value as string) || '#CDFF03'
            return (
              <div className="flex items-center gap-3 rounded-md border-[0.5px] border-white/[0.08] bg-surface-02 px-3 py-2.5">
                <label className="relative h-9 w-9 shrink-0 cursor-pointer overflow-hidden rounded-[calc(9px*var(--border-radius-scale))] [box-shadow:var(--shadow-inset-tile)]">
                  <span className="absolute inset-0" style={{ background: hex }} />
                  <input
                    type="color"
                    className="absolute inset-0 cursor-pointer opacity-0"
                    disabled={row.disabled}
                    value={hex}
                    onChange={(e) => onChange(e.target.value)}
                  />
                </label>
                <span className="font-mono text-[14px] uppercase text-fg">{hex}</span>
              </div>
            )
          }

          default:
            return null
        }
      })()}

      <ErrorMsg show={errored} text={error} />
    </div>
  )
}

function Stepper({ icon, onClick, disabled }: { icon: string; onClick: () => void; disabled?: boolean }) {
  return (
    <button
      type="button"
      tabIndex={-1}
      disabled={disabled}
      onClick={onClick}
      className="grid h-6 w-6 place-items-center rounded-[calc(6px*var(--border-radius-scale))] bg-surface-03 text-[10px] text-fg-soft transition-all duration-150 hover:bg-white/[0.03] hover:text-fg active:scale-90 disabled:opacity-40"
    >
      <Icon icon={icon} fixedWidth />
    </button>
  )
}

function ErrorMsg({ show, text }: { show: boolean; text: string | null }) {
  if (!show || !text) return null
  return (
    <p className="mt-1.5 flex items-center gap-1.5 text-[11px] text-danger">
      <Icon icon="circle-exclamation" fixedWidth />
      {text}
    </p>
  )
}
