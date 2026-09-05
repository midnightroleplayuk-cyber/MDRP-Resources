import { useCallback, useEffect, useMemo, useRef, useState, type CSSProperties } from 'react'
import { AnimatePresence, motion } from 'framer-motion'
import { useNuiEvent } from '@/nui/useNuiEvent'
import { fetchNui } from '@/nui/nui'
import type { ContextMenuItem, ContextMenuProps, IconValue } from '@/types'
import { Icon } from '../Icon'
import { ContextItem } from './ContextItem'
import { ContextIconFrame } from './ContextIconFrame'
import { usePanelMotion } from '@/dev/showcase/showcaseMotion'

type Entry = [key: string, item: ContextMenuItem]

function toEntries(options: ContextMenuProps['options']): Entry[] {
  if (Array.isArray(options)) return options.map((item, i) => [String(i), item])
  return Object.entries(options)
}

const selectable = (item: ContextMenuItem) => !item.disabled && !item.readOnly

const listVariants = {
  show: { transition: { staggerChildren: 0.026, delayChildren: 0.05 } },
}

export function ContextMenu() {
  const [menu, setMenu] = useState<ContextMenuProps | null>(null)
  const [navKey, setNavKey] = useState(0)
  const [focus, setFocus] = useState(-1)
  const listRef = useRef<HTMLDivElement>(null)
  const visible = menu !== null

  useNuiEvent<ContextMenuProps>('showContext', (data) => {
    setMenu(data)
    setNavKey((k) => k + 1)
  })
  useNuiEvent('hideContext', () => setMenu(null))

  const entries = useMemo(() => (menu ? toEntries(menu.options) : []), [menu])

  const navigable = useMemo(
    () => entries.flatMap(([, item], i) => (selectable(item) ? [i] : [])),
    [entries],
  )

  const close = useCallback(() => {
    if (menu && menu.canClose === false) return
    setMenu(null)
    fetchNui('closeContext')
  }, [menu])

  const openSubmenu = useCallback((id: string, back = false) => {
    fetchNui('openContext', { id, back })
  }, [])

  const select = useCallback(
    (key: string, item: ContextMenuItem) => {
      if (!selectable(item)) return
      if (item.menu) return openSubmenu(item.menu)
      fetchNui('clickContext', key)
    },
    [openSubmenu],
  )

  const moveFocus = useCallback(
    (dir: 1 | -1) => {
      setFocus((cur) => {
        if (navigable.length === 0) return -1
        const pos = navigable.indexOf(cur)
        if (pos === -1) return navigable[dir === 1 ? 0 : navigable.length - 1]
        return navigable[(pos + dir + navigable.length) % navigable.length]
      })
    },
    [navigable],
  )

  useEffect(() => {
    setFocus(navigable[0] ?? -1)
  }, [navKey, navigable])

  useEffect(() => {
    if (focus < 0) return
    listRef.current
      ?.querySelector<HTMLElement>(`[data-cindex="${focus}"]`)
      ?.scrollIntoView({ block: 'nearest' })
  }, [focus])

  useEffect(() => {
    if (!visible) return
    const onKey = (e: KeyboardEvent) => {
      switch (e.key) {
        case 'Escape':
          e.preventDefault()
          close()
          break
        case 'Backspace':
          if (menu?.menu) {
            e.preventDefault()
            openSubmenu(menu.menu, true)
          }
          break
        case 'ArrowDown':
          e.preventDefault()
          moveFocus(1)
          break
        case 'ArrowUp':
          e.preventDefault()
          moveFocus(-1)
          break
        case 'Enter': {
          e.preventDefault()
          const entry = entries[focus]
          if (entry) select(entry[0], entry[1])
          break
        }
      }
    }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [visible, menu, entries, focus, moveFocus, close, openSubmenu, select])

  const panelMotion = usePanelMotion('contextMenu')

  return (
    <AnimatePresence>
      {menu && (
        <motion.div
          key="ctx"
          className="fixed right-[3vh] top-1/2 z-[500] w-[312px] max-h-[82vh] -translate-y-1/2"
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
          <div className="rs-tilt-stage-y-right rs-tilt-origin-center-right max-h-[82vh] w-full">
          <div className="rs-tilt-y-right max-h-[82vh] w-full">
          <div className="flex max-h-[82vh] w-full flex-col overflow-hidden rounded-[calc(14px*var(--border-radius-scale))] border-[0.5px] border-white/[0.09] bg-[image:var(--rs-panel-gradient)] [box-shadow:var(--shadow-raised),inset_0_1px_0_rgba(255,255,255,0.06)]">

          <header className="relative z-[1] flex shrink-0 items-center gap-2.5 border-b-[0.5px] border-sep px-3 py-3">

            {menu.menu && (
              <button
                onClick={() => openSubmenu(menu.menu as string, true)}
                className="grid h-[26px] w-[26px] shrink-0 place-items-center rounded-full text-[10px] text-fg-mute transition-all duration-150 hover:bg-white/10 hover:text-fg active:scale-90"
                aria-label="Back"
              >
                <Icon icon="chevron-left" fixedWidth />
              </button>
            )}

            <ContextIconFrame>
              <Icon icon="list" color="var(--rs-accent)" fixedWidth />
            </ContextIconFrame>

            <div className="min-w-0 flex flex-1 gap-2.5">
              <div className="min-w-0 flex-1">
                <p className="truncate text-[12.5px] font-semibold leading-tight tracking-[-0.01em] text-fg">
                  {menu.title}
                </p>
                <p className="mt-0.5 text-[11.5px] leading-[1.4] text-fg-soft">
                  {entries.length} {entries.length === 1 ? 'option' : 'options'}
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
                    {menu.menu ? 'Submenu' : 'Menu'}
                  </span>
                </span>

                {menu.canClose !== false && (
                  <button
                    onClick={close}
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
            <motion.div
              key={navKey}
              ref={listRef}
              variants={listVariants}
              initial="hidden"
              animate="show"
              className="sb-scroll flex min-h-0 flex-1 flex-col"
            >
              {entries.length > 0 ? (
                entries.map(([key, item], i) => (
                  <ContextItem
                    key={key}
                    index={i}
                    item={item}
                    focused={focus === i}
                    onHover={() => selectable(item) && setFocus(i)}
                    onSelect={() => select(key, item)}
                  />
                ))
              ) : (
                <div className="grid flex-1 place-items-center px-4 py-10 text-center">
                  <div>
                    <Icon icon="inbox" className="text-[22px] text-fg-mute" />
                    <p className="mt-2.5 text-[12px] text-fg-mute">No options available</p>
                  </div>
                </div>
              )}
            </motion.div>

            <span className="pointer-events-none absolute inset-x-0 top-0 h-3 bg-gradient-to-b from-[rgba(16,16,16,0.95)] to-transparent" />
            <span className="pointer-events-none absolute inset-x-0 bottom-0 h-3 bg-gradient-to-t from-[rgba(16,16,16,0.95)] to-transparent" />
            </div>
          </div>

          <footer className="relative z-[1] flex shrink-0 flex-wrap items-center justify-center gap-x-4 gap-y-2 border-t-[0.5px] border-sep px-3 py-3">
            <Guide label="Move">
              <Kbd icon="chevron-up" />
              <Kbd icon="chevron-down" />
            </Guide>
            <Guide label="Select">
              <Kbd icon="arrow-turn-down" />
            </Guide>
            {menu.menu && (
              <Guide label="Back">
                <Kbd icon="delete-left" />
              </Guide>
            )}
            {menu.canClose !== false && (
              <Guide label="Close">
                <Kbd icon="xmark" />
              </Guide>
            )}
          </footer>
          </div>
          </div>
          </div>
        </motion.div>
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
