import { useEffect, useRef, useState, type CSSProperties } from 'react'
import { AnimatePresence, motion } from 'framer-motion'
import { useNuiEvent } from '@/nui/useNuiEvent'
import { fetchNui } from '@/nui/nui'
import type { IconValue } from '@/types'
import { Icon } from '../Icon'
import { ContextIconFrame } from '../ContextMenu/ContextIconFrame'
import { usePanelMotion } from '@/dev/showcase/showcaseMotion'

interface ProgressState {
  type: 'bar' | 'circle'
  label?: string
  description?: string
  duration: number
  position?: 'middle' | 'bottom'
  canCancel?: boolean
}

const SQUARE_SIZE = 96
const SQUARE_STROKE = 5
const SQUARE_INSET = 5
const SQUARE_RX = 12

export function Progress() {
  const [state, setState] = useState<ProgressState | null>(null)
  const [pct, setPct] = useState(0)
  const [circleBottom, setCircleBottom] = useState(false)
  const cancelled = useRef(false)

  useNuiEvent<Omit<ProgressState, 'type'>>('progress', (d) => setState({ type: 'bar', ...d }))
  useNuiEvent<Omit<ProgressState, 'type'>>('circleProgress', (d) => {
    setCircleBottom(d.position === 'bottom')
    setState({ type: 'circle', ...d })
  })
  useNuiEvent('progressCancel', () => {
    cancelled.current = true
    setState(null)
  })

  useEffect(() => {
    if (!state) return
    cancelled.current = false
    setPct(0)
    const start = performance.now()
    let raf = 0

    const tick = (now: number) => {
      const p = Math.min(100, ((now - start) / state.duration) * 100)
      setPct(p)
      if (p >= 100) {
        if (!cancelled.current) fetchNui('progressComplete')
        setState(null)
        return
      }
      raf = requestAnimationFrame(tick)
    }

    raf = requestAnimationFrame(tick)
    return () => cancelAnimationFrame(raf)
  }, [state])

  const panelMotion = usePanelMotion('bottomPanel')

  return (
    <>
      <AnimatePresence>
        {state?.type === 'bar' && (
          <div className="pointer-events-none fixed bottom-[3vh] left-1/2 z-[800] w-[480px] max-w-[92vw] -translate-x-1/2">
            <motion.div
              key="bar"
              initial={panelMotion.initial}
              animate={panelMotion.animate}
              exit={panelMotion.exit}
              transition={panelMotion.transition}
            >
            <div className="flex w-full flex-col overflow-hidden rounded-[calc(14px*var(--border-radius-scale))] border-[0.5px] border-white/[0.09] bg-[image:var(--rs-panel-gradient)] [box-shadow:var(--shadow-raised),inset_0_1px_0_rgba(255,255,255,0.06)]">
              <header className="relative z-[1] flex shrink-0 items-center gap-2.5 border-b-[0.5px] border-sep px-3 py-3">
                <ContextIconFrame>
                  <Icon icon="bars-progress" spin color="var(--rs-accent)" fixedWidth />
                </ContextIconFrame>

                <div className="min-w-0 flex flex-1 gap-2.5">
                  <div className="min-w-0 flex-1">
                    <p className="truncate text-[12.5px] font-semibold leading-tight tracking-[-0.01em] text-fg">
                      {state.label ?? 'Progress'}
                    </p>
                    <p className="mt-0.5 text-[11.5px] leading-[1.4] text-fg-soft">
                      {Math.round(pct)}% complete
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
                        Progress
                      </span>
                    </span>
                  </div>
                </div>
              </header>

              <div className="relative min-h-0 p-2">
                <div className="relative flex flex-col overflow-hidden rounded-[calc(10px*var(--border-radius-scale))] border-[0.5px] border-sep bg-[image:var(--rs-panel-gradient)] px-3 py-3 [box-shadow:inset_0_0_0_1px_rgba(255,255,255,0.05),inset_0_2px_10px_rgba(0,0,0,0.42)]">
                  {state.description && (
                    <p className="mb-2.5 text-[11.5px] leading-[1.4] text-fg-soft">{state.description}</p>
                  )}

                  <div className="flex items-center gap-2">
                    <div className="h-[3px] min-w-0 flex-1 overflow-hidden rounded-pill bg-white/[0.08]">
                      <div
                        className="h-full w-full origin-left rounded-pill"
                        style={{
                          transform: `scaleX(${Math.min(1, Math.max(0, pct / 100))})`,
                          background: 'linear-gradient(90deg, var(--rs-accent), var(--rs-accent-hi))',
                        }}
                      />
                    </div>
                    <span className="font-mono text-[9.5px] tabular-nums text-fg-mute">{Math.round(pct)}%</span>
                  </div>
                </div>
              </div>

              {state.canCancel && (
                <footer className="relative z-[1] flex shrink-0 flex-wrap items-center justify-center gap-x-4 gap-y-2 border-t-[0.5px] border-sep px-3 py-3">
                  <Guide label="Cancel">
                    <Kbd icon="xmark" />
                  </Guide>
                </footer>
              )}
            </div>
            </motion.div>
          </div>
        )}
      </AnimatePresence>

      <div
        className={`pointer-events-none fixed inset-0 z-[800] flex justify-center ${
          circleBottom ? 'items-end pb-[3vh]' : 'items-center'
        }`}
      >
        <AnimatePresence>
          {state?.type === 'circle' && (
            <SquareProgressMinimal label={state.label} pct={pct} />
          )}
        </AnimatePresence>
      </div>
    </>
  )
}

function SquareRing({ pct, size = SQUARE_SIZE }: { pct: number; size?: number }) {
  const dim = size - SQUARE_INSET * 2

  return (
    <div
      className="relative grid place-items-center [filter:drop-shadow(0_2px_8px_rgba(0,0,0,0.6))]"
      style={{ width: size, height: size }}
    >
      <svg className="absolute inset-0 -rotate-90" viewBox={`0 0 ${size} ${size}`}>
        <rect
          x={SQUARE_INSET}
          y={SQUARE_INSET}
          width={dim}
          height={dim}
          rx={SQUARE_RX}
          ry={SQUARE_RX}
          fill="none"
          stroke="rgba(0,0,0,0.35)"
          strokeWidth={SQUARE_STROKE}
        />
        <rect
          x={SQUARE_INSET}
          y={SQUARE_INSET}
          width={dim}
          height={dim}
          rx={SQUARE_RX}
          ry={SQUARE_RX}
          fill="none"
          stroke="var(--rs-accent)"
          strokeWidth={SQUARE_STROKE}
          strokeLinecap="round"
          pathLength={100}
          strokeDasharray={100}
          strokeDashoffset={100 - Math.min(100, Math.max(0, pct))}
          style={{ filter: 'drop-shadow(0 0 6px rgba(var(--accent-rgb),0.7))' }}
        />
      </svg>
      <span className="font-mono text-[22px] font-medium tabular-nums tracking-[-0.02em] text-fg [text-shadow:0_1px_6px_rgba(0,0,0,0.8)]">
        {Math.round(pct)}
        <span className="text-[12px] text-fg-mute">%</span>
      </span>
    </div>
  )
}

function SquareProgressMinimal({ label, pct }: { label?: string; pct: number }) {
  return (
    <motion.div
      key="square-minimal"
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      transition={{ type: 'spring', stiffness: 460, damping: 34 }}
      className="flex flex-col items-center gap-3"
    >
      <SquareRing pct={pct} />
      {label && (
        <span className="max-w-[220px] truncate text-center font-display text-[10px] font-semibold uppercase tracking-[0.2em] text-fg [text-shadow:0_1px_6px_rgba(0,0,0,0.9)]">
          {label}
        </span>
      )}
    </motion.div>
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
