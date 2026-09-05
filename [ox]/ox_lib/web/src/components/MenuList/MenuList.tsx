import { useCallback, useEffect, useRef, useState, type CSSProperties } from 'react'
import { AnimatePresence, motion } from 'framer-motion'
import { useNuiEvent } from '@/nui/useNuiEvent'
import { fetchNui } from '@/nui/nui'
import type { IconValue } from '@/types'
import { Icon } from '../Icon'
import { ContextIconFrame } from '../ContextMenu/ContextIconFrame'
import { usePanelMotion } from '@/dev/showcase/showcaseMotion'

type MenuValue = string | { label: string; description?: string }

interface MenuItem {
  label: string
  progress?: number
  colorScheme?: string
  icon?: IconValue
  iconColor?: string
  values?: MenuValue[]
  checked?: boolean
  description?: string
  defaultIndex?: number
  close?: boolean
}

interface MenuData {
  position?: 'top-left' | 'top-right' | 'bottom-left' | 'bottom-right'
  canClose?: boolean
  title: string
  items: MenuItem[]
  startItemIndex?: number
  disableInput?: boolean
}

const SCHEME: Record<string, string> = {
  red: 'var(--rs-danger)',
  green: 'var(--rs-success)',
  teal: 'var(--rs-success)',
  blue: 'var(--rs-info)',
  cyan: 'var(--rs-info)',
  yellow: 'var(--rs-success)',
  orange: 'var(--rs-warning)',
}

const valueLabel = (v: MenuValue) => (typeof v === 'string' ? v : v.label)
const valueDesc = (v: MenuValue) => (typeof v === 'string' ? undefined : v.description)

export function MenuList() {
  const [menu, setMenu] = useState<MenuData | null>(null)
  const [selected, setSelected] = useState(0)
  const [scroll, setScroll] = useState<Record<number, number>>({})
  const [checks, setChecks] = useState<Record<number, boolean>>({})
  const listRef = useRef<HTMLDivElement>(null)
  const interactive = menu ? menu.disableInput !== true : false
  const hasValues = menu?.items.some((it) => it.values?.length) ?? false

  const emitSelected = useCallback((items: MenuItem[], idx: number, scrollMap: Record<number, number>) => {
    const it = items[idx]
    if (!it) return
    fetchNui('changeSelected', it.values ? [idx, scrollMap[idx] ?? 0] : [idx])
  }, [])

  useNuiEvent<MenuData>('setMenu', (data) => {
    const initScroll: Record<number, number> = {}
    const initChecks: Record<number, boolean> = {}
    data.items.forEach((it, i) => {
      if (it.values) initScroll[i] = Math.max(0, (it.defaultIndex ?? 1) - 1)
      if (it.checked !== undefined) initChecks[i] = !!it.checked
    })
    const start = Math.min(Math.max(0, data.startItemIndex ?? 0), data.items.length - 1)
    setScroll(initScroll)
    setChecks(initChecks)
    setMenu(data)
    setSelected(start)
    emitSelected(data.items, start, initScroll)
  })
  useNuiEvent('closeMenu', () => setMenu(null))

  const closeWithKey = useCallback(
    (key?: 'Escape' | 'Backspace') => {
      setMenu(null)
      fetchNui('closeMenu', key)
    },
    [],
  )

  const select = useCallback(
    (idx: number) => {
      if (!menu) return
      setSelected(idx)
      emitSelected(menu.items, idx, scroll)
    },
    [menu, scroll, emitSelected],
  )

  const cycleValue = useCallback(
    (idx: number, dir: 1 | -1) => {
      if (!menu) return
      const it = menu.items[idx]
      if (!it.values?.length) return
      const len = it.values.length
      const next = ((scroll[idx] ?? 0) + dir + len) % len
      setScroll((s) => ({ ...s, [idx]: next }))
      fetchNui('changeIndex', [idx, next])
    },
    [menu, scroll],
  )

  const confirm = useCallback(
    (idx: number) => {
      if (!menu) return
      const it = menu.items[idx]

      if (it.checked !== undefined) {
        const next = !checks[idx]
        setChecks((c) => ({ ...c, [idx]: next }))
        fetchNui('changeChecked', [idx, next])
        return
      }

      fetchNui('confirmSelected', it.values ? [idx, scroll[idx] ?? 0] : [idx])
      if (it.close !== false) setMenu(null)
    },
    [menu, scroll, checks],
  )

  useEffect(() => {
    if (!menu || !interactive) return
    const n = menu.items.length
    const onKey = (e: KeyboardEvent) => {
      switch (e.key) {
        case 'ArrowDown':
          e.preventDefault()
          select((selected + 1) % n)
          break
        case 'ArrowUp':
          e.preventDefault()
          select((selected - 1 + n) % n)
          break
        case 'ArrowLeft':
          e.preventDefault()
          cycleValue(selected, -1)
          break
        case 'ArrowRight':
          e.preventDefault()
          cycleValue(selected, 1)
          break
        case 'Enter':
          e.preventDefault()
          confirm(selected)
          break
        case 'Escape':
          e.preventDefault()
          if (menu.canClose !== false) closeWithKey('Escape')
          break
        case 'Backspace':
          e.preventDefault()
          if (menu.canClose !== false) closeWithKey('Backspace')
          break
      }
    }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [menu, interactive, selected, select, cycleValue, confirm, closeWithKey])

  useEffect(() => {
    listRef.current
      ?.querySelector<HTMLElement>(`[data-mindex="${selected}"]`)
      ?.scrollIntoView({ block: 'nearest' })
  }, [selected])

  const panelMotion = usePanelMotion('listMenu')

  return (
    <AnimatePresence>
      {menu && (
        <motion.div
          key="menu"
          className="fixed left-[3vh] top-1/2 z-[550] w-[312px] max-h-[82vh] -translate-y-1/2"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0, transition: { duration: 0.16 } }}
        >
        <motion.div
          initial={panelMotion.initial}
          animate={panelMotion.animate}
          exit={panelMotion.exit}
          transition={panelMotion.transition}
          className="max-h-[82vh] w-full"
        >
          <div className="rs-tilt-stage-y-left rs-tilt-origin-center-left max-h-[82vh] w-full">
          <div className="rs-tilt-y-left max-h-[82vh] w-full">
          <div className="pointer-events-auto flex max-h-[82vh] w-full flex-col overflow-hidden rounded-[calc(14px*var(--border-radius-scale))] border-[0.5px] border-white/[0.09] bg-[image:var(--rs-panel-gradient)] [box-shadow:var(--shadow-raised),inset_0_1px_0_rgba(255,255,255,0.06)]">
            <header className="relative z-[1] flex shrink-0 items-center gap-2.5 border-b-[0.5px] border-sep px-3 py-3">
              <ContextIconFrame>
                <Icon icon="bars" color="var(--rs-accent)" fixedWidth />
              </ContextIconFrame>

              <div className="min-w-0 flex flex-1 gap-2.5">
                <div className="min-w-0 flex-1">
                  <p className="truncate text-[12.5px] font-semibold leading-tight tracking-[-0.01em] text-fg">
                    {menu.title}
                  </p>
                  <p className="mt-0.5 text-[11.5px] leading-[1.4] text-fg-soft">
                    {menu.items.length} {menu.items.length === 1 ? 'option' : 'options'}
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
                      Menu
                    </span>
                  </span>

                  {menu.canClose !== false && (
                    <button
                      type="button"
                      onClick={() => closeWithKey('Escape')}
                      className="grid h-[18px] w-[18px] place-items-center rounded-full text-[9px] text-fg-mute transition-all duration-150 hover:bg-white/10 hover:text-fg active:scale-90"
                      aria-label="Close"
                    >
                      <Icon icon="xmark" fixedWidth />
                    </button>
                  )}
                </div>
              </div>
            </header>

            <div className="relative min-h-0 flex-1 p-2">
              <div className="relative flex h-full min-h-0 flex-col overflow-hidden rounded-[calc(10px*var(--border-radius-scale))] border-[0.5px] border-sep bg-[image:var(--rs-panel-gradient)] [box-shadow:inset_0_0_0_1px_rgba(255,255,255,0.05),inset_0_2px_10px_rgba(0,0,0,0.42)]">
                <div ref={listRef} className="sb-scroll flex min-h-0 flex-1 flex-col overflow-y-auto">
                  {menu.items.map((it, i) => (
                    <Row
                      key={i}
                      index={i}
                      item={it}
                      active={selected === i}
                      scrollIndex={scroll[i] ?? 0}
                      checked={checks[i] ?? false}
                      interactive={interactive}
                      onHover={() => interactive && select(i)}
                      onConfirm={() => confirm(i)}
                      onCycle={(d) => cycleValue(i, d)}
                    />
                  ))}
                </div>

                <span className="pointer-events-none absolute inset-x-0 top-0 h-3 bg-gradient-to-b from-[rgba(16,16,16,0.95)] to-transparent" />
                <span className="pointer-events-none absolute inset-x-0 bottom-0 h-3 bg-gradient-to-t from-[rgba(16,16,16,0.95)] to-transparent" />
              </div>
            </div>

            {interactive && (
              <footer className="relative z-[1] flex shrink-0 flex-wrap items-center justify-center gap-x-4 gap-y-2 border-t-[0.5px] border-sep px-3 py-3">
                <Guide label="Move">
                  <Kbd icon="chevron-up" />
                  <Kbd icon="chevron-down" />
                </Guide>
                {hasValues && (
                  <Guide label="Scroll">
                    <Kbd icon="chevron-left" />
                    <Kbd icon="chevron-right" />
                  </Guide>
                )}
                <Guide label="Select">
                  <Kbd icon="arrow-turn-down" />
                </Guide>
                {menu.canClose !== false && (
                  <Guide label="Close">
                    <Kbd icon="xmark" />
                  </Guide>
                )}
              </footer>
            )}
          </div>
          </div>
          </div>
        </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  )
}

interface RowProps {
  index: number
  item: MenuItem
  active: boolean
  scrollIndex: number
  checked: boolean
  interactive: boolean
  onHover: () => void
  onConfirm: () => void
  onCycle: (dir: 1 | -1) => void
}

function Arrow({ dir, onClick }: { dir: 'left' | 'right'; onClick: (e: React.MouseEvent) => void }) {
  return (
    <span
      role="button"
      onClick={onClick}
      className="grid h-[18px] w-[18px] place-items-center rounded-full text-[9px] text-fg-mute transition-all duration-150 hover:bg-white/10 hover:text-fg-soft"
    >
      <Icon icon={dir === 'left' ? 'chevron-left' : 'chevron-right'} fixedWidth />
    </span>
  )
}

function Row({ index, item, active, scrollIndex, checked, interactive, onHover, onConfirm, onCycle }: RowProps) {
  const isCheckbox = item.checked !== undefined
  const value = item.values?.[scrollIndex]
  const desc = (value && valueDesc(value)) ?? item.description
  const progColor = item.colorScheme ? SCHEME[item.colorScheme] ?? 'var(--rs-accent)' : null
  const multiline = !!desc || typeof item.progress === 'number'

  return (
    <button
      type="button"
      data-mindex={index}
      onMouseEnter={onHover}
      onClick={interactive ? onConfirm : undefined}
      className={[
        'group relative flex w-full items-center gap-2.5 border-b border-white/[0.06] px-3 py-2.5 text-left transition-colors duration-150 last:border-b-0',
        multiline ? 'items-start' : '',
        active && interactive ? 'bg-white/[0.04]' : interactive ? 'hover:bg-white/[0.03]' : 'cursor-default',
        interactive ? 'cursor-pointer' : 'cursor-default',
      ].join(' ')}
    >
      {item.icon && (
        <ContextIconFrame iconRgb="232,232,232" className={multiline ? '' : ''}>
          <Icon icon={item.icon} color={item.iconColor ?? 'rgba(255,255,255,0.82)'} fixedWidth />
        </ContextIconFrame>
      )}

      <div className="min-w-0 flex flex-1 flex-col gap-1">
        <div className="flex items-center justify-between gap-2.5">
          <span className="min-w-0 flex-1 truncate text-[12.5px] font-semibold leading-tight tracking-[-0.01em] text-fg">
            {item.label}
          </span>

          {item.values?.length ? (
            <span className="flex shrink-0 items-center gap-0.5">
              <Arrow dir="left" onClick={(e) => { e.stopPropagation(); onCycle(-1) }} />
              <span className="min-w-[54px] text-center text-[11.5px] font-medium text-fg-soft">
                {value ? valueLabel(value) : ''}
              </span>
              <Arrow dir="right" onClick={(e) => { e.stopPropagation(); onCycle(1) }} />
            </span>
          ) : isCheckbox ? (
            <span
              className={`grid h-[20px] w-[20px] shrink-0 place-items-center rounded-[calc(6px*var(--border-radius-scale))] border-[0.5px] text-[10px] transition-colors ${
                checked
                  ? 'border-[var(--rs-accent)] bg-[image:var(--rs-accent-gradient)] text-[#101010] [box-shadow:0_0_6px_rgba(var(--accent-rgb),0.35)]'
                  : 'border-white/20 bg-transparent text-transparent'
              }`}
            >
              <Icon icon="check" fixedWidth />
            </span>
          ) : null}
        </div>

        {desc && <p className="line-clamp-2 text-[11.5px] leading-[1.4] text-fg-soft">{desc}</p>}

        {typeof item.progress === 'number' && (
          <div className="mt-0.5 flex items-center gap-2">
            <div className="h-[3px] flex-1 overflow-hidden rounded-pill bg-white/[0.08]">
              <div
                className="h-full rounded-pill transition-[width] duration-300"
                style={{
                  width: `${Math.min(100, Math.max(0, item.progress))}%`,
                  background: progColor ?? 'linear-gradient(90deg, var(--rs-accent), var(--rs-accent-hi))',
                }}
              />
            </div>
            <span className="font-mono text-[9.5px] text-fg-mute">{Math.round(item.progress)}%</span>
          </div>
        )}
      </div>
    </button>
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
