import { useEffect, useLayoutEffect, useRef, useState } from 'react'
import { createPortal } from 'react-dom'
import { AnimatePresence, motion } from 'framer-motion'
import type { InputSelectOption } from '@/types'
import { Icon } from '../Icon'

interface Props {
  options: InputSelectOption[]
  value: string
  onChange: (v: string) => void
  placeholder?: string
  disabled?: boolean
  searchable?: boolean
  clearable?: boolean
  errored?: boolean
}

const PANEL_MAX = 260

export function Combobox({ options, value, onChange, placeholder, disabled, searchable, clearable, errored }: Props) {
  const [open, setOpen] = useState(false)
  const [query, setQuery] = useState('')
  const [pos, setPos] = useState<{ left: number; top: number; width: number; flip: boolean } | null>(null)
  const triggerRef = useRef<HTMLButtonElement>(null)
  const panelRef = useRef<HTMLDivElement>(null)

  const selected = options.find((o) => o.value === value)
  const filtered = searchable && query
    ? options.filter((o) => o.label.toLowerCase().includes(query.toLowerCase()))
    : options

  const place = () => {
    const el = triggerRef.current
    if (!el) return
    const r = el.getBoundingClientRect()
    const flip = r.bottom + PANEL_MAX > window.innerHeight && r.top > PANEL_MAX
    setPos({ left: r.left, top: flip ? r.top : r.bottom, width: r.width, flip })
  }

  useLayoutEffect(() => {
    if (open) place()
  }, [open])

  useEffect(() => {
    if (!open) return
    const outside = (e: MouseEvent) => {
      const t = e.target as Node
      if (panelRef.current?.contains(t) || triggerRef.current?.contains(t)) return
      setOpen(false)
    }
    const onScroll = (e: Event) => {
      if (panelRef.current?.contains(e.target as Node)) return
      setOpen(false)
    }
    const onResize = () => setOpen(false)
    const onKey = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        e.stopPropagation()
        setOpen(false)
      }
    }
    document.addEventListener('mousedown', outside)
    window.addEventListener('scroll', onScroll, true)
    window.addEventListener('resize', onResize)
    document.addEventListener('keydown', onKey, true)
    return () => {
      document.removeEventListener('mousedown', outside)
      window.removeEventListener('scroll', onScroll, true)
      window.removeEventListener('resize', onResize)
      document.removeEventListener('keydown', onKey, true)
    }
  }, [open])

  const pick = (v: string) => {
    onChange(v)
    setOpen(false)
    setQuery('')
  }

  return (
    <div className="relative">
      <button
        ref={triggerRef}
        type="button"
        disabled={disabled}
        onClick={() => setOpen((o) => !o)}
        className={`flex w-full items-center gap-2 rounded-md border-[0.5px] bg-surface-02 px-3.5 py-2.5 text-left text-[14px] outline-none transition-all duration-150 ${
          errored
            ? 'border-danger/70'
            : open
              ? 'border-white/[0.14] bg-white/[0.04]'
              : 'border-white/[0.08] hover:bg-white/[0.03]'
        }`}
      >
        <span className={`flex-1 truncate ${selected ? 'text-fg' : 'text-fg-mute'}`}>
          {selected?.label ?? placeholder ?? 'Select…'}
        </span>
        {clearable && selected && (
          <span
            role="button"
            onClick={(e) => {
              e.stopPropagation()
              onChange('')
            }}
            className="grid h-5 w-5 place-items-center rounded-full text-[10px] text-fg-mute transition-colors hover:bg-white/10 hover:text-fg"
          >
            <Icon icon="xmark" fixedWidth />
          </span>
        )}
        <Icon
          icon="chevron-down"
          className={`text-[11px] text-fg-mute transition-transform duration-200 ${open ? 'rotate-180' : ''}`}
          fixedWidth
        />
      </button>

      {createPortal(
        <AnimatePresence>
          {open && pos && (
            <motion.div
              ref={panelRef}
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              transition={{ duration: 0.15, ease: [0.22, 1, 0.36, 1] }}
              style={{
                position: 'fixed',
                left: pos.left,
                width: pos.width,
                ...(pos.flip ? { bottom: window.innerHeight - pos.top + 4 } : { top: pos.top + 4 }),
              }}
              className="z-[2000] overflow-hidden rounded-[calc(10px*var(--border-radius-scale))] border-[0.5px] border-sep bg-[image:var(--rs-panel-gradient)] [box-shadow:var(--shadow-raised),inset_0_1px_0_rgba(255,255,255,0.06)]"
            >
              {searchable && (
                <div className="flex items-center gap-2 border-b-[0.5px] border-sep px-3 py-2">
                  <Icon icon="magnifying-glass" className="text-[11px] text-fg-mute" fixedWidth />
                  <input
                    autoFocus
                    value={query}
                    onChange={(e) => setQuery(e.target.value)}
                    placeholder="Search…"
                    className="w-full bg-transparent text-[13px] text-fg outline-none placeholder:text-fg-mute"
                  />
                </div>
              )}
              <div className="sb-scroll flex max-h-[220px] flex-col gap-0.5 p-1.5">
                {filtered.length > 0 ? (
                  filtered.map((opt) => {
                    const on = opt.value === value
                    return (
                      <button
                        key={opt.value}
                        type="button"
                        onClick={() => pick(opt.value)}
                        className={`flex items-center gap-2 rounded-[calc(7px*var(--border-radius-scale))] px-2.5 py-2 text-left text-[13.5px] transition-colors duration-150 ${
                          on ? 'bg-white/[0.04] text-fg' : 'text-fg-soft hover:bg-white/[0.03]'
                        }`}
                      >
                        <span className="flex-1 truncate">{opt.label}</span>
                        {on && <Icon icon="check" className="text-[11px] text-accent" fixedWidth />}
                      </button>
                    )
                  })
                ) : (
                  <p className="px-2.5 py-3 text-center text-[12px] text-fg-mute">No results</p>
                )}
              </div>
            </motion.div>
          )}
        </AnimatePresence>,
        document.body,
      )}
    </div>
  )
}
