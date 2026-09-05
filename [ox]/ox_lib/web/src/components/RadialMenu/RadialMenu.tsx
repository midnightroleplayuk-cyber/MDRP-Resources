import { useEffect, useState, type CSSProperties } from 'react'
import { AnimatePresence, motion } from 'framer-motion'
import { useNuiEvent } from '@/nui/useNuiEvent'
import { fetchNui } from '@/nui/nui'
import type { IconValue } from '@/types'
import { Icon } from '../Icon'
import { ContextIconFrame } from '../ContextMenu/ContextIconFrame'
import { usePanelMotion } from '@/dev/showcase/showcaseMotion'
import './radial.css'

interface RadialItem {
  icon: IconValue
  label: string
  menu?: string
  iconWidth?: number
  iconHeight?: number
}

interface RadialData {
  items: RadialItem[]
  sub?: boolean
  option?: number
}

const RADIUS = 132

export function RadialMenu() {
  const [menu, setMenu] = useState<RadialData | null>(null)
  const [hover, setHover] = useState<number | null>(null)
  const [version, setVersion] = useState(0)

  useNuiEvent<RadialData | false>('openRadialMenu', (data) => {
    if (!data) {
      setMenu(null)
      setHover(null)
      return
    }
    setMenu(data)
    setHover(typeof data.option === 'number' ? data.option : null)
    setVersion((v) => v + 1)
  })

  useNuiEvent<number | null>('radialSetHover', (index) => {
    setHover(typeof index === 'number' ? index : null)
  })

  const close = () => {
    setMenu(null)
    setHover(null)
    fetchNui('radialClose')
  }
  const back = () => fetchNui('radialBack')
  const click = (i: number) => fetchNui('radialClick', i)

  useEffect(() => {
    if (!menu) return
    const onKey = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        e.preventDefault()
        close()
      } else if (e.key === 'Backspace' && menu.sub) {
        e.preventDefault()
        back()
      }
    }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [menu])

  const radialMotion = usePanelMotion('radial')
  const activeItem = hover != null && menu ? menu.items[hover] : null

  return (
    <AnimatePresence>
      {menu && (
    <motion.div
      key="radial-menu"
      initial={radialMotion.initial}
      animate={radialMotion.animate}
      exit={radialMotion.exit}
      transition={radialMotion.transition}
      className="radial-backdrop"
      onMouseDown={() => (menu.sub ? back() : close())}
      onContextMenu={(e) => {
        e.preventDefault()
        menu.sub ? back() : close()
      }}
    >
      <div
        className={'radial-wheel' + (menu.sub ? ' sub' : '')}
        key={version}
        onMouseDown={(e) => e.stopPropagation()}
      >
        {menu.items.map((_, i) => {
          const step = 360 / menu.items.length
          return (
            <span
              key={'sp' + i}
              className={'radial-spoke' + (hover === i ? ' active' : '')}
              style={{ transform: `rotate(${-90 + i * step}deg)`, ['--d' as never]: `${i * 28}ms` }}
            />
          )
        })}

        <button
          type="button"
          className={'radial-hub' + (menu.sub ? ' back' : '')}
          onClick={menu.sub ? back : undefined}
          disabled={!menu.sub}
        >
          <span
            className="radial-hub-in"
            key={hover != null ? `h${hover}` : menu.sub ? 'back' : 'idle'}
          >
            <ContextIconFrame iconRgb="232,232,232">
              {activeItem ? (
                <Icon icon={activeItem.icon} color="var(--rs-accent)" fixedWidth />
              ) : menu.sub ? (
                <Icon icon="chevron-left" color="var(--rs-accent)" fixedWidth />
              ) : (
                <Icon icon="list" color="var(--rs-accent)" fixedWidth />
              )}
            </ContextIconFrame>

            <div className="radial-hub-copy">
              <span className="radial-hub-label">
                {activeItem ? activeItem.label : menu.sub ? 'Back' : 'Radial Menu'}
              </span>
              <span className="radial-hub-badge">
                <span className="radial-hub-dot" />
                <span>{menu.sub ? 'Submenu' : 'Menu'}</span>
              </span>
            </div>
          </span>
        </button>

        {menu.items.map((it, i) => {
          const step = 360 / menu.items.length
          const a = (-90 + i * step) * (Math.PI / 180)
          const x = Math.cos(a) * RADIUS
          const y = Math.sin(a) * RADIUS
          const active = hover === i

          return (
            <button
              type="button"
              key={i}
              className={'radial-node' + (active ? ' active' : '')}
              style={{ transform: `translate(${x}px, ${y}px)`, ['--d' as never]: `${i * 28}ms` }}
              onMouseEnter={() => setHover(i)}
              onMouseLeave={() => setHover((h) => (h === i ? null : h))}
              onClick={() => click(i)}
            >
              <div className="radial-node-tile">
                <ContextIconFrame iconRgb="232,232,232">
                  <Icon
                    icon={it.icon}
                    color={active ? 'var(--rs-accent)' : 'rgba(255,255,255,0.82)'}
                    fixedWidth
                  />
                </ContextIconFrame>
              </div>
              <span className="radial-node-label">{it.label}</span>
            </button>
          )
        })}
      </div>

      <footer className="radial-footer">
        <Guide label="Select">
          <Kbd icon="hand-pointer" />
        </Guide>
        {menu.sub && (
          <Guide label="Back">
            <Kbd icon="delete-left" />
          </Guide>
        )}
        <Guide label="Close">
          <Kbd icon="xmark" />
        </Guide>
      </footer>
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
