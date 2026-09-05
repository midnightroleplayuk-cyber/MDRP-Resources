import { useCallback, useEffect, useRef, useState } from 'react'
import { AnimatePresence, motion } from 'framer-motion'
import { useNuiEvent } from '@/nui/useNuiEvent'
import { fetchNui } from '@/nui/nui'
import { Icon } from '../Icon'
import { ContextIconFrame } from '../ContextMenu/ContextIconFrame'
import { usePanelMotion, useShowcaseActive } from '@/dev/showcase/showcaseMotion'

type Difficulty = 'easy' | 'medium' | 'hard' | { areaSize: number; speedMultiplier: number }

interface SkillCheckData {
  difficulty: Difficulty | Difficulty[]
  inputs?: string[]
  title?: string
  difficultyText?: string
}

interface Round {
  areaSize: number
  speedMultiplier: number
}

const PRESETS: Record<string, Round> = {
  easy: { areaSize: 50, speedMultiplier: 1 },
  medium: { areaSize: 40, speedMultiplier: 1.5 },
  hard: { areaSize: 25, speedMultiplier: 1.75 },
}

const resolve = (d: Difficulty): Round => (typeof d === 'string' ? PRESETS[d] ?? PRESETS.medium : d)
const toRounds = (d: SkillCheckData['difficulty']): Round[] => (Array.isArray(d) ? d.map(resolve) : [resolve(d)])

const BASE_SPEED = 250

const randomZoneStart = (areaSize: number) => 120 + Math.floor(Math.random() * (360 - areaSize - 120))

function normalizeKey(e: KeyboardEvent): string {
  const capitalHetaCode = 880
  if (e.key.charCodeAt(0) >= capitalHetaCode) {
    if (e.code.indexOf('Key') === 0 && e.code.length === 4) return e.code.charAt(3).toLowerCase()
    if (e.code.indexOf('Digit') === 0 && e.code.length === 6) return e.code.charAt(5).toLowerCase()
  }
  return e.key.toLowerCase()
}

function difficultyInfo(r: Round): { text: string } {
  if (r.areaSize >= 50) return { text: 'easy' }
  if (r.areaSize >= 40) return { text: 'medium' }
  return { text: 'hard' }
}

function toPct(deg: number) {
  return ((deg % 360) / 360) * 100
}

export function SkillCheck() {
  const showcase = useShowcaseActive()
  const [sc, setSc] = useState<{ rounds: Round[]; inputs: string[]; title?: string; difficultyText?: string } | null>(
    null,
  )
  const [round, setRound] = useState(0)
  const [angle, setAngle] = useState(0)
  const [result, setResult] = useState<'success' | 'fail' | null>(null)

  const params = useRef({ key: 'e', areaStart: 120, areaSize: 40, speed: BASE_SPEED })
  const angleRef = useRef(0)
  const doneRef = useRef(false)

  const finish = useCallback((success: boolean) => {
    if (doneRef.current) return
    doneRef.current = true
    setResult(success ? 'success' : 'fail')
    window.setTimeout(() => {
      setSc(null)
      setResult(null)
      setRound(0)
      fetchNui('skillCheckOver', success)
    }, 280)
  }, [])

  useNuiEvent<SkillCheckData>('startSkillCheck', (data) => {
    doneRef.current = false
    setResult(null)
    setRound(0)
    setSc({
      rounds: toRounds(data.difficulty),
      inputs: (data.inputs?.length ? data.inputs : ['e']).map((k) => k.toLowerCase()),
      title: data.title,
      difficultyText: data.difficultyText,
    })
  })
  useNuiEvent('skillCheckCancel', () => finish(false))

  useEffect(() => {
    if (!sc) return
    const r = sc.rounds[round] ?? PRESETS.medium
    const areaSize = Math.min(120, Math.max(8, r.areaSize))
    const areaStart = randomZoneStart(areaSize)
    const key = sc.inputs[Math.floor(Math.random() * sc.inputs.length)]
    params.current = { key, areaStart, areaSize, speed: BASE_SPEED * (r.speedMultiplier || 1) }
    angleRef.current = 0
    setAngle(0)

    let raf = 0
    let last = performance.now()
    const tick = (now: number) => {
      if (doneRef.current) return
      const dt = (now - last) / 1000
      last = now
      angleRef.current += params.current.speed * dt
      if (angleRef.current >= 360) {
        if (showcase) {
          if (round + 1 < sc.rounds.length) setRound((n) => n + 1)
          else finish(true)
        } else {
          finish(false)
        }
        return
      }
      setAngle(angleRef.current)
      raf = requestAnimationFrame(tick)
    }
    raf = requestAnimationFrame(tick)
    return () => cancelAnimationFrame(raf)
  }, [sc, round, finish, showcase])

  useEffect(() => {
    if (!sc) return
    const onKey = (e: KeyboardEvent) => {
      if (doneRef.current || showcase) return
      const k = normalizeKey(e)
      if (!sc.inputs.includes(k)) return
      e.preventDefault()
      const { key, areaStart, areaSize } = params.current
      const a = angleRef.current % 360
      const inZone = a >= areaStart && a <= areaStart + areaSize
      if (k === key && inZone) {
        if (round + 1 < sc.rounds.length) setRound((r) => r + 1)
        else finish(true)
      } else {
        finish(false)
      }
    }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [sc, round, finish, showcase])

  useEffect(() => {
    if (!sc || !showcase) return

    let raf = 0
    const tick = () => {
      if (doneRef.current) return
      const { areaStart, areaSize } = params.current
      const a = angleRef.current % 360
      if (a >= areaStart && a <= areaStart + areaSize) {
        if (round + 1 < sc.rounds.length) setRound((r) => r + 1)
        else finish(true)
        return
      }
      raf = requestAnimationFrame(tick)
    }

    raf = requestAnimationFrame(tick)
    return () => cancelAnimationFrame(raf)
  }, [sc, round, finish, showcase])

  const cur = sc?.rounds[round] ?? PRESETS.medium
  const diff = difficultyInfo(resolve(cur))
  const keyLabel = params.current.key.toUpperCase()
  const difficultyLabel = sc?.difficultyText || diff.text
  const zoneLeft = toPct(params.current.areaStart)
  const zoneWidth = toPct(params.current.areaSize)
  const markerLeft = toPct(angle)

  const statusLabel = result === 'success' ? 'OK' : result === 'fail' ? 'FAIL' : keyLabel
  const subtitle =
    sc && sc.rounds.length > 1
      ? `Round ${round + 1} of ${sc.rounds.length} · ${difficultyLabel}`
      : `${difficultyLabel} difficulty`

  const panelMotion = usePanelMotion('bottomPanel')

  return (
    <AnimatePresence>
      {sc && (
        <div className="pointer-events-none fixed bottom-[3vh] left-1/2 z-[1200] w-[480px] max-w-[92vw] -translate-x-1/2">
          <motion.div
            key="skillcheck"
            initial={panelMotion.initial}
            animate={panelMotion.animate}
            exit={panelMotion.exit}
            transition={panelMotion.transition}
          >
          <div className="flex w-full flex-col overflow-hidden rounded-[calc(14px*var(--border-radius-scale))] border-[0.5px] border-white/[0.09] bg-[image:var(--rs-panel-gradient)] [box-shadow:var(--shadow-raised),inset_0_1px_0_rgba(255,255,255,0.06)]">
            <header className="relative z-[1] flex shrink-0 items-center gap-2.5 border-b-[0.5px] border-sep px-3 py-3">
              <ContextIconFrame>
                <Icon icon="gauge-high" color="var(--rs-accent)" fixedWidth />
              </ContextIconFrame>

              <div className="min-w-0 flex flex-1 gap-2.5">
                <div className="min-w-0 flex-1">
                  <p className="truncate text-[12.5px] font-semibold leading-tight tracking-[-0.01em] text-fg">
                    {sc.title || 'Skill Check'}
                  </p>
                  <p className="mt-0.5 text-[11.5px] leading-[1.4] text-fg-soft">{subtitle}</p>
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
                      Skill Check
                    </span>
                  </span>
                </div>
              </div>
            </header>

            <div className="relative min-h-0 p-2">
              <div className="relative flex flex-col overflow-hidden rounded-[calc(10px*var(--border-radius-scale))] border-[0.5px] border-sep bg-[image:var(--rs-panel-gradient)] px-3 py-3 [box-shadow:inset_0_0_0_1px_rgba(255,255,255,0.05),inset_0_2px_10px_rgba(0,0,0,0.42)]">
                <div className="flex items-center gap-2">
                  <div className="relative min-w-0 flex-1 self-center py-[5px]">
                    <div className="absolute inset-x-0 top-1/2 h-[3px] -translate-y-1/2 overflow-hidden rounded-pill bg-white/[0.08]">
                      <div
                        className="absolute inset-y-0 rounded-pill transition-[background] duration-150"
                        style={{
                          left: `${zoneLeft}%`,
                          width: `${zoneWidth}%`,
                          background:
                            result === 'fail'
                              ? 'linear-gradient(90deg, var(--rs-danger), #f87171)'
                              : result === 'success'
                                ? 'linear-gradient(90deg, var(--rs-success), #bef264)'
                                : 'linear-gradient(90deg, var(--rs-accent), var(--rs-accent-hi))',
                        }}
                      />
                    </div>

                    {!result && (
                      <div
                        className="absolute top-1/2 z-[2] h-[10px] w-[2px] -translate-x-1/2 -translate-y-1/2 rounded-full bg-white"
                        style={{
                          left: `${markerLeft}%`,
                          boxShadow: '0 0 6px rgba(var(--accent-rgb),0.9)',
                        }}
                      />
                    )}
                  </div>

                  <span
                    className={`font-mono text-[9.5px] tabular-nums ${
                      result === 'success'
                        ? 'text-[var(--rs-success)]'
                        : result === 'fail'
                          ? 'text-[var(--rs-danger)]'
                          : 'text-fg-mute'
                    }`}
                  >
                    {statusLabel}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </motion.div>
        </div>
      )}
    </AnimatePresence>
  )
}
