import { useCallback, useEffect, useMemo, useRef, useState, type CSSProperties } from 'react'
import { AnimatePresence, motion } from 'framer-motion'
import { useNuiEvent } from '@/nui/useNuiEvent'
import { fetchNui } from '@/nui/nui'
import { applyUiSettings, DEFAULT_UI_SETTINGS, type UiSettings } from '@/utils/uiSettings'
import type { IconValue, InputDialogProps, InputDialogRow } from '@/types'
import { Icon } from '../Icon'
import { ContextIconFrame } from '../ContextMenu/ContextIconFrame'
import { DialogRow } from './DialogRow'
import { usePanelMotion } from '@/dev/showcase/showcaseMotion'

const SIZE: Record<string, string> = {
  xs: 'w-[630px]',
  sm: 'w-[731px]',
  md: 'w-[866px]',
  lg: 'w-[1064px]',
  xl: 'w-[1300px]',
}

const PANEL_H = '24.75vh'

function seed(rows: InputDialogRow[]): unknown[] {
  return rows.map((row) => {
    switch (row.type) {
      case 'checkbox':
        return row.checked ?? false
      case 'multi-select':
        return row.default != null ? [String(row.default)] : []
      case 'number':
      case 'slider':
        return row.default != null ? Number(row.default) : row.min ?? 0
      default:
        return row.default != null ? row.default : ''
    }
  })
}

export function rowError(row: InputDialogRow, value: unknown): string | null {
  if (row.type === 'checkbox') return row.required && value !== true ? 'Required' : null

  const empty = value === '' || value == null || (Array.isArray(value) && value.length === 0)
  if (empty) return row.required ? 'Required' : null

  if ((row.type === 'input' || row.type === 'textarea') && typeof value === 'string') {
    if (row.minLength && value.length < row.minLength) return `Minimum ${row.minLength} characters`
  }
  if (row.type === 'number' && typeof value === 'number') {
    if (row.min != null && value < row.min) return `Minimum ${row.min}`
    if (row.max != null && value > row.max) return `Maximum ${row.max}`
  }
  return null
}

const pad = (n: number) => String(n).padStart(2, '0')

function formatDate(d: Date, fmt: string): string {
  const map: Record<string, string> = {
    YYYY: String(d.getFullYear()),
    MM: pad(d.getMonth() + 1),
    DD: pad(d.getDate()),
    HH: pad(d.getHours()),
    mm: pad(d.getMinutes()),
    ss: pad(d.getSeconds()),
  }
  return fmt.replace(/YYYY|MM|DD|HH|mm|ss/g, (t) => map[t] ?? t)
}

function parseISODate(s: string): Date | null {
  const [y, m, d] = s.split('-').map(Number)
  if (!y || !m || !d) return null
  return new Date(y, m - 1, d)
}

function serialize(row: InputDialogRow, value: unknown): unknown {
  if (value === '' || value == null) return value

  if (row.type === 'date' && typeof value === 'string') {
    const d = parseISODate(value)
    if (!d) return value
    return row.returnString ? (row.format ? formatDate(d, row.format) : value) : d.getTime()
  }

  if (row.type === 'time' && typeof value === 'string') {
    if (row.returnString && row.format) {
      const [h, m] = value.split(':').map(Number)
      const d = new Date()
      d.setHours(h || 0, m || 0, 0, 0)
      return formatDate(d, row.format)
    }
    return value
  }

  if (row.type === 'date-range' && typeof value === 'string') {
    const conv = (s: string) => {
      if (!s) return null
      const d = parseISODate(s)
      if (!d) return s
      return row.returnString ? (row.format ? formatDate(d, row.format) : s) : d.getTime()
    }
    const [from, to] = value.split('|')
    return [conv(from), conv(to)]
  }

  return value
}

function previewPatch(rows: InputDialogRow[], values: unknown[]): Partial<UiSettings> | null {
  const patch: Partial<UiSettings> = {}
  let hasPreview = false

  rows.forEach((row, i) => {
    if (!row.preview) return
    hasPreview = true
    ;(patch as Record<string, unknown>)[row.preview] = values[i]
  })

  return hasPreview ? patch : null
}

export function InputDialog() {
  const [dialog, setDialog] = useState<InputDialogProps | null>(null)
  const [values, setValues] = useState<unknown[]>([])
  const [attempted, setAttempted] = useState(false)
  const [shake, setShake] = useState(false)
  const formRef = useRef<HTMLFormElement>(null)
  const savedUiSettings = useRef<UiSettings | null>(null)
  const visible = dialog !== null

  const restoreUiPreview = useCallback(() => {
    if (!savedUiSettings.current) return
    applyUiSettings(savedUiSettings.current)
    savedUiSettings.current = null
  }, [])

  useNuiEvent<InputDialogProps>('openDialog', (data) => {
    setDialog(data)
    setValues(seed(data.rows))
    setAttempted(false)

    if (data.rows.some((row) => row.preview)) {
      fetchNui<UiSettings>('getUiSettings', undefined, DEFAULT_UI_SETTINGS)
        .then((s) => {
          savedUiSettings.current = { ...DEFAULT_UI_SETTINGS, ...s }
        })
        .catch(() => {
          savedUiSettings.current = { ...DEFAULT_UI_SETTINGS }
        })
    } else {
      savedUiSettings.current = null
    }
  })

  useNuiEvent('closeInputDialog', () => {
    restoreUiPreview()
    setDialog(null)
  })

  const allowCancel = dialog?.options?.allowCancel !== false
  const badge = dialog?.options?.badge ?? 'Form'
  const subtitle = dialog?.options?.subtitle

  const cancel = useCallback(() => {
    if (!allowCancel) return
    restoreUiPreview()
    setDialog(null)
    fetchNui('inputData', null)
  }, [allowCancel, restoreUiPreview])

  const setValue = useCallback((index: number, value: unknown) => {
    setValues((prev) => {
      const next = [...prev]
      next[index] = value
      return next
    })
  }, [])

  const errors = useMemo(
    () => (dialog ? dialog.rows.map((row, i) => rowError(row, values[i])) : []),
    [dialog, values],
  )
  const valid = errors.every((e) => e === null)

  const submit = useCallback(() => {
    if (!dialog) return
    if (!valid) {
      setAttempted(true)
      setShake(true)
      window.setTimeout(() => setShake(false), 420)
      return
    }
    setDialog(null)
    savedUiSettings.current = null
    fetchNui('inputData', dialog.rows.map((row, i) => serialize(row, values[i])))
  }, [dialog, valid, values])

  useEffect(() => {
    if (!dialog) return
    const patch = previewPatch(dialog.rows, values)
    if (!patch) return
    applyUiSettings({ ...DEFAULT_UI_SETTINGS, ...savedUiSettings.current, ...patch })
  }, [dialog, values])

  useEffect(() => {
    if (!dialog) return
    const raf = requestAnimationFrame(() => {
      formRef.current
        ?.querySelector<HTMLElement>('input:not([type="color"]), textarea, select')
        ?.focus()
    })
    return () => cancelAnimationFrame(raf)
  }, [dialog])

  useEffect(() => {
    if (!visible) return
    const onKey = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        e.preventDefault()
        cancel()
        return
      }

      if (e.key !== 'Enter' || e.isComposing) return

      const target = e.target as HTMLElement
      if (target.tagName === 'TEXTAREA') {
        if (e.ctrlKey || e.metaKey) {
          e.preventDefault()
          submit()
        }
        return
      }

      if (target.closest('[data-combobox-open="true"]')) return

      e.preventDefault()
      submit()
    }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [visible, cancel, submit])

  const fieldCount = dialog?.rows.length ?? 0
  const panelMotion = usePanelMotion('bottomPanel')
  const fadeMotion = usePanelMotion('fade')

  return (
    <AnimatePresence>
      {dialog && (
        <motion.div
          key="dialog-backdrop"
          initial={fadeMotion.initial}
          animate={fadeMotion.animate}
          exit={fadeMotion.exit}
          transition={{ duration: 0.2 }}
          onMouseDown={(e) => e.target === e.currentTarget && cancel()}
          className="fixed inset-0 z-[1000]"
        >
          <div className="pointer-events-none fixed bottom-[3vh] left-1/2 z-[1000] flex w-full max-w-[92vw] -translate-x-1/2 justify-center">
            <motion.div
              initial={panelMotion.initial}
              animate={panelMotion.animate}
              exit={panelMotion.exit}
              transition={panelMotion.transition}
              onMouseDown={(e) => e.stopPropagation()}
              className={`pointer-events-auto flex shrink-0 flex-col overflow-hidden rounded-[calc(14px*var(--border-radius-scale))] border-[0.5px] border-white/[0.09] bg-[image:var(--rs-panel-gradient)] [box-shadow:var(--shadow-raised),inset_0_1px_0_rgba(255,255,255,0.06)] ${
                SIZE[dialog.options?.size ?? 'md'] ?? SIZE.md
              }`}
              style={{ height: PANEL_H, maxHeight: PANEL_H }}
            >
            <div
              className={`flex h-full min-h-0 flex-col overflow-hidden ${shake ? 'animate-shake' : ''}`}
            >
              <header className="relative z-[1] flex shrink-0 items-center gap-2.5 border-b-[0.5px] border-sep px-3 py-3">
                <ContextIconFrame>
                  <Icon icon="keyboard" color="var(--rs-accent)" fixedWidth />
                </ContextIconFrame>

                <div className="min-w-0 flex flex-1 gap-2.5">
                  <div className="min-w-0 flex-1">
                    <p className="truncate text-[12.5px] font-semibold leading-tight tracking-[-0.01em] text-fg">
                      {dialog.heading}
                    </p>
                    <p className="mt-0.5 text-[11.5px] leading-[1.4] text-fg-soft">
                      {subtitle ? (
                        <span
                          className="font-display text-[8.5px] font-semibold uppercase tracking-[0.2em]"
                          style={{ color: 'var(--rs-accent)' }}
                        >
                          {subtitle}
                        </span>
                      ) : (
                        <>
                          {fieldCount} {fieldCount === 1 ? 'field' : 'fields'}
                        </>
                      )}
                    </p>
                  </div>

                  <div className="flex shrink-0 flex-col items-end gap-0.5">
                    <span className="flex items-center gap-1.5">
                      <span
                        className="h-1 w-1 shrink-0 rounded-full"
                        style={{ background: 'var(--rs-accent)', boxShadow: '0 0 5px rgba(var(--accent-rgb),0.8)' }}
                      />
                      <span
                        className="font-display text-[8.5px] font-semibold uppercase tracking-[0.2em]"
                        style={{ color: 'var(--rs-accent)' }}
                      >
                        {badge}
                      </span>
                    </span>

                    {allowCancel && (
                      <button
                        type="button"
                        onClick={cancel}
                        className="grid h-[18px] w-[18px] place-items-center rounded-full text-[9px] text-fg-mute transition-all duration-150 hover:bg-white/10 hover:text-fg active:scale-90"
                        aria-label="Close"
                      >
                        <Icon icon="xmark" fixedWidth />
                      </button>
                    )}
                  </div>
                </div>
              </header>

              <form
                ref={formRef}
                onSubmit={(e) => {
                  e.preventDefault()
                  submit()
                }}
                className="flex min-h-0 flex-1 flex-col overflow-hidden"
              >
                <div className="min-h-0 flex-1 overflow-hidden p-2">
                  <div className="relative flex h-full min-h-0 flex-col overflow-hidden rounded-[calc(10px*var(--border-radius-scale))] border-[0.5px] border-sep bg-[image:var(--rs-panel-gradient)] [box-shadow:inset_0_0_0_1px_rgba(255,255,255,0.05),inset_0_2px_10px_rgba(0,0,0,0.42)]">
                    <div className="sb-scroll flex min-h-0 flex-1 flex-col gap-4 overflow-y-auto overscroll-contain px-3 py-3">
                      {dialog.rows.map((row, i) => (
                        <DialogRow
                          key={i}
                          row={row}
                          value={values[i]}
                          onChange={(v) => setValue(i, v)}
                          error={errors[i]}
                          showError={attempted}
                        />
                      ))}
                    </div>

                    <span className="pointer-events-none absolute inset-x-0 top-0 h-3 bg-gradient-to-b from-[rgba(16,16,16,0.95)] to-transparent" />
                    <span className="pointer-events-none absolute inset-x-0 bottom-0 h-3 bg-gradient-to-t from-[rgba(16,16,16,0.95)] to-transparent" />
                  </div>
                </div>
                <button type="submit" className="sr-only" tabIndex={-1} aria-hidden>
                  Submit
                </button>
              </form>

              <footer className="relative z-[1] flex shrink-0 flex-wrap items-center justify-center gap-x-4 gap-y-2 border-t-[0.5px] border-sep px-3 py-3">
                <button
                  type="button"
                  onClick={submit}
                  className="inline-flex items-center gap-1.5 rounded-[calc(8px*var(--border-radius-scale))] px-2 py-1 transition-colors duration-150 hover:bg-white/[0.04] active:scale-[0.98]"
                >
                  <Guide label="Confirm">
                    <Kbd icon="arrow-turn-down" />
                  </Guide>
                </button>
                {allowCancel && (
                  <button
                    type="button"
                    onClick={cancel}
                    className="inline-flex items-center gap-1.5 rounded-[calc(8px*var(--border-radius-scale))] px-2 py-1 transition-colors duration-150 hover:bg-white/[0.04] active:scale-[0.98]"
                  >
                    <Guide label="Cancel">
                      <Kbd icon="xmark" />
                    </Guide>
                  </button>
                )}
              </footer>
            </div>
          </motion.div>
          </div>
        </motion.div>
      )}
    </AnimatePresence>
  )
}

function Guide({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <span className="inline-flex items-center gap-1.5">
      <span
        className="font-display text-[8.5px] font-semibold uppercase tracking-[0.2em]"
        style={{ color: 'var(--rs-accent)' }}
      >
        {label}
      </span>
      <span className="flex gap-0.5">{children}</span>
    </span>
  )
}

function Kbd({ icon }: { icon: IconValue }) {
  return (
    <kbd
      className="flex h-[20px] w-[20px] shrink-0 items-center justify-center p-0 rs-icon-block"
      style={{ '--icon-rgb': '232,232,232' } as CSSProperties}
    >
      <Icon icon={icon} className="block text-[10px] leading-none" fixedWidth />
    </kbd>
  )
}
