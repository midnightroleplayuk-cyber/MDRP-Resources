import { useEffect, useRef, useState, type CSSProperties } from 'react'
import { motion } from 'framer-motion'
import type { NotificationProps, NotificationType, IconValue } from '@/types'
import { sanitizeStyle } from '@/utils/style'
import { Icon } from '../Icon'
import { usePanelMotion } from '@/dev/showcase/showcaseMotion'

interface Props {
  notification: NotificationProps
  restartKey: number
  onDismiss: () => void
}

const TYPE: Record<NotificationType, { color: string; rgb: string; label: string; icon: string }> = {
  info: { color: 'var(--rs-info)', rgb: '232,232,232', label: 'Notice', icon: 'circle-info' },
  success: { color: 'var(--rs-success)', rgb: '205,255,3', label: 'Success', icon: 'circle-check' },
  warning: { color: 'var(--rs-warning)', rgb: '255,149,0', label: 'Alert', icon: 'triangle-exclamation' },
  error: { color: 'var(--rs-danger)', rgb: '239,68,68', label: 'Error', icon: 'circle-exclamation' },
}

const BLOCK_RING = 100

function IconFrame({
  type,
  rgb,
  color,
  showRing,
  progress,
  icon,
  iconColor,
  iconAnimation,
}: {
  type: NotificationType | undefined
  rgb: string
  color: string
  showRing: boolean
  progress: number
  icon: IconValue
  iconColor: string
  iconAnimation?: NotificationProps['iconAnimation']
}) {
  const isSuccess = type === 'success'

  return (
    <div className="relative grid h-[34px] w-[34px] shrink-0 place-items-center self-center">
      {showRing && (
        <svg className="absolute inset-0" viewBox="0 0 34 34">
          <rect
            x="1.5"
            y="1.5"
            width="31"
            height="31"
            rx="6"
            ry="6"
            fill="none"
            stroke="rgba(255,255,255,0.08)"
            strokeWidth="1.5"
          />
          <rect
            x="1.5"
            y="1.5"
            width="31"
            height="31"
            rx="6"
            ry="6"
            fill="none"
            stroke={color}
            strokeWidth="1.5"
            pathLength={BLOCK_RING}
            strokeDasharray={BLOCK_RING}
            strokeDashoffset={BLOCK_RING * (1 - progress / 100)}
            style={{ filter: `drop-shadow(0 0 3px rgba(${rgb},0.7))` }}
          />
        </svg>
      )}

      <span
        className="grid h-[26px] w-[26px] place-items-center text-[12px] rs-icon-block"
        style={isSuccess ? undefined : ({ '--icon-rgb': rgb } as CSSProperties)}
      >
        <Icon icon={icon} color={iconColor} animation={iconAnimation} fixedWidth />
      </span>
    </div>
  )
}

function clockNow() {
  return new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', hour12: false })
}

export function NotificationCard({ notification, restartKey, onDismiss }: Props) {
  // Fall back to 'info' for any type not in the map ('inform', custom values, …)
  // so an unknown type never crashes on t.color.
  const t = TYPE[notification.type as NotificationType] ?? TYPE.info
  const duration = notification.duration ?? 3000
  const iconColor = notification.iconColor ?? t.color
  const showRing =
    (notification.showDuration ??
      (notification.type === 'success' ||
        notification.type === 'warning' ||
        notification.type === 'error')) &&
    duration > 0

  const [progress, setProgress] = useState(100)
  const [time, setTime] = useState(clockNow)

  const start = useRef(0)
  const pausedAt = useRef<number | null>(null)

  const pause = () => {
    if (pausedAt.current == null) pausedAt.current = performance.now()
  }
  const resume = () => {
    if (pausedAt.current != null) {
      start.current += performance.now() - pausedAt.current
      pausedAt.current = null
    }
  }

  useEffect(() => {
    setTime(clockNow())
    if (duration <= 0) return
    setProgress(100)
    start.current = performance.now()
    pausedAt.current = null
    let raf = 0

    const tick = (now: number) => {
      if (pausedAt.current != null) {
        raf = requestAnimationFrame(tick)
        return
      }
      const elapsed = now - start.current
      const pct = Math.max(0, 100 - (elapsed / duration) * 100)
      setProgress(pct)
      if (elapsed >= duration) return onDismiss()
      raf = requestAnimationFrame(tick)
    }

    raf = requestAnimationFrame(tick)
    return () => cancelAnimationFrame(raf)
  }, [duration, restartKey, onDismiss])

  const panelMotion = usePanelMotion('notification')

  return (
    <motion.div
      onMouseEnter={pause}
      onMouseLeave={resume}
      initial={panelMotion.initial}
      animate={panelMotion.animate}
      exit={panelMotion.exit}
      transition={panelMotion.transition}
      className="group pointer-events-auto relative w-full overflow-hidden rounded-[calc(14px*var(--border-radius-scale))] border-[0.5px] border-white/[0.09] bg-[image:var(--rs-panel-gradient)] px-3 py-2.5 [box-shadow:var(--shadow-raised),inset_0_1px_0_rgba(255,255,255,0.06)]"
      style={sanitizeStyle(notification.style)}
    >

      <div className="flex items-center gap-2.5">

        <IconFrame
          type={notification.type}
          rgb={t.rgb}
          color={t.color}
          showRing={showRing}
          progress={progress}
          icon={notification.icon ?? t.icon}
          iconColor={iconColor}
          iconAnimation={notification.iconAnimation}
        />

        <div className="min-w-0 flex flex-1 gap-2.5">
          <div className="min-w-0 flex-1">
            {notification.title && (
              <p className="truncate text-[12.5px] font-semibold leading-tight tracking-[-0.01em] text-fg">
                {notification.title}
              </p>
            )}
            {notification.description && (
              <p
                className={`whitespace-pre-line break-words text-[11.5px] leading-[1.4] text-fg-soft ${
                  notification.title ? 'mt-0.5' : ''
                }`}
              >
                {notification.description}
              </p>
            )}
          </div>

          <div className="flex shrink-0 flex-col items-end gap-0.5">
            <span className="flex items-center gap-1.5">
              <span
                className="h-1 w-1 shrink-0 rounded-full [animation:pulse-dot_1.8s_ease-in-out_infinite]"
                style={{ background: t.color, boxShadow: `0 0 5px rgba(${t.rgb},0.8)` }}
              />
              <span
                className="font-display text-[8.5px] font-semibold uppercase tracking-[0.2em]"
                style={{ color: t.color }}
              >
                {t.label}
              </span>
            </span>

            <span className="relative h-3.5">
              <span className="font-mono text-[9.5px] text-fg-mute transition-opacity duration-150 group-hover:opacity-0">
                {time}
              </span>
              <button
                onClick={onDismiss}
                className="absolute -right-1 -top-1 grid h-[18px] w-[18px] place-items-center rounded-full text-[9px] text-fg-mute opacity-0 transition-all duration-150 hover:bg-white/10 hover:text-fg group-hover:opacity-100 active:scale-90"
                aria-label="Dismiss"
              >
                <Icon icon="xmark" fixedWidth />
              </button>
            </span>
          </div>
        </div>
      </div>
    </motion.div>
  )
}
