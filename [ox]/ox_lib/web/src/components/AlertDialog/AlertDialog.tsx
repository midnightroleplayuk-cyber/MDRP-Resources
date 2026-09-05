import { useCallback, useEffect, useState, type CSSProperties } from 'react'
import { AnimatePresence, motion } from 'framer-motion'
import ReactMarkdown from 'react-markdown'
import remarkGfm from 'remark-gfm'
import { useNuiEvent } from '@/nui/useNuiEvent'
import { fetchNui } from '@/nui/nui'
import type { AlertDialogProps, AlertResult, IconValue } from '@/types'
import { Icon } from '../Icon'
import { ContextIconFrame } from '../ContextMenu/ContextIconFrame'
import { usePanelMotion } from '@/dev/showcase/showcaseMotion'

const SIZE: Record<string, string> = {
  xs: 'w-[312px]',
  sm: 'w-[360px]',
  md: 'w-[420px]',
  lg: 'w-[520px]',
  xl: 'w-[640px]',
}

export function AlertDialog() {
  const [alert, setAlert] = useState<AlertDialogProps | null>(null)
  const visible = alert !== null

  useNuiEvent<AlertDialogProps>('sendAlert', (data) => setAlert(data))
  useNuiEvent('closeAlertDialog', () => setAlert(null))

  const respond = useCallback((result: AlertResult) => {
    setAlert(null)
    fetchNui('closeAlert', result)
  }, [])

  useEffect(() => {
    if (!visible) return
    const onKey = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        e.preventDefault()
        respond('cancel')
      } else if (e.key === 'Enter') {
        e.preventDefault()
        respond('confirm')
      }
    }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [visible, respond])

  return (
    <AnimatePresence>
      {alert && <AlertCard key="alert" alert={alert} onRespond={respond} />}
    </AnimatePresence>
  )
}

function AlertCard({ alert, onRespond }: { alert: AlertDialogProps; onRespond: (r: AlertResult) => void }) {
  const centered = !!alert.centered
  const icon = alert.icon ?? 'circle-exclamation'
  const iconColor = alert.iconColor ?? 'var(--rs-accent)'
  const confirmLabel = alert.labels?.confirm ?? 'Confirm'
  const cancelLabel = alert.labels?.cancel ?? 'Cancel'
  const panelMotion = usePanelMotion('centerPanel')
  const fadeMotion = usePanelMotion('fade')

  return (
    <motion.div
      initial={fadeMotion.initial}
      animate={fadeMotion.animate}
      exit={fadeMotion.exit}
      transition={{ duration: 0.2 }}
      onMouseDown={(e) => e.target === e.currentTarget && onRespond('cancel')}
      className="fixed inset-0 z-[1100]"
    >
      <div className="pointer-events-none fixed left-1/2 top-1/2 max-h-[82vh] max-w-[92vw] -translate-x-1/2 -translate-y-1/2">
        <motion.div
          initial={panelMotion.initial}
          animate={panelMotion.animate}
          exit={panelMotion.exit}
          transition={panelMotion.transition}
          onMouseDown={(e) => e.stopPropagation()}
          className={`pointer-events-auto flex max-h-[82vh] w-full flex-col overflow-hidden rounded-[calc(14px*var(--border-radius-scale))] border-[0.5px] border-white/[0.09] bg-[image:var(--rs-panel-gradient)] [box-shadow:var(--shadow-raised),inset_0_1px_0_rgba(255,255,255,0.06)] ${
            SIZE[alert.size ?? 'md'] ?? SIZE.md
          }`}
        >
        <header className="relative z-[1] flex shrink-0 items-center gap-2.5 border-b-[0.5px] border-sep px-3 py-3">
          <ContextIconFrame>
            <Icon icon={icon} color={iconColor} fixedWidth />
          </ContextIconFrame>

          <div className="min-w-0 flex flex-1 gap-2.5">
            <div className="min-w-0 flex-1">
              <p className="truncate text-[12.5px] font-semibold leading-tight tracking-[-0.01em] text-fg">
                {alert.header}
              </p>
              <p className="mt-0.5 text-[11.5px] leading-[1.4] text-fg-soft">
                {alert.cancel ? 'Review and confirm' : 'Confirmation required'}
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
                  Alert
                </span>
              </span>

              <button
                type="button"
                onClick={() => onRespond('cancel')}
                className="grid h-[18px] w-[18px] place-items-center rounded-full text-[9px] text-fg-mute transition-all duration-150 hover:bg-white/10 hover:text-fg active:scale-90"
                aria-label="Close"
              >
                <Icon icon="xmark" fixedWidth />
              </button>
            </div>
          </div>
        </header>

        <div className="relative min-h-0 flex-1 p-2">
          <div className="relative flex max-h-[50vh] min-h-0 flex-col overflow-hidden rounded-[calc(10px*var(--border-radius-scale))] border-[0.5px] border-sep bg-[image:var(--rs-panel-gradient)] [box-shadow:inset_0_0_0_1px_rgba(255,255,255,0.05),inset_0_2px_10px_rgba(0,0,0,0.42)]">
            <div className={`sb-scroll min-h-0 flex-1 overflow-y-auto overscroll-contain px-3 py-3 ${centered ? 'text-center' : ''}`}>
              <div className={`alert-md ${centered ? 'centered' : ''}`}>
                <ReactMarkdown remarkPlugins={[remarkGfm]}>{alert.content}</ReactMarkdown>
              </div>
            </div>

            <span className="pointer-events-none absolute inset-x-0 top-0 h-3 bg-gradient-to-b from-[rgba(16,16,16,0.95)] to-transparent" />
            <span className="pointer-events-none absolute inset-x-0 bottom-0 h-3 bg-gradient-to-t from-[rgba(16,16,16,0.95)] to-transparent" />
          </div>
        </div>

        <footer className="relative z-[1] flex shrink-0 flex-wrap items-center justify-center gap-x-4 gap-y-2 border-t-[0.5px] border-sep px-3 py-3">
          <button
            type="button"
            onClick={() => onRespond('confirm')}
            className="inline-flex items-center gap-1.5 rounded-[calc(8px*var(--border-radius-scale))] px-2 py-1 transition-colors duration-150 hover:bg-white/[0.04] active:scale-[0.98]"
          >
            <Guide label={confirmLabel}>
              <Kbd icon="arrow-turn-down" />
            </Guide>
          </button>
          {alert.cancel && (
            <button
              type="button"
              onClick={() => onRespond('cancel')}
              className="inline-flex items-center gap-1.5 rounded-[calc(8px*var(--border-radius-scale))] px-2 py-1 transition-colors duration-150 hover:bg-white/[0.04] active:scale-[0.98]"
            >
              <Guide label={cancelLabel}>
                <Kbd icon="xmark" />
              </Guide>
            </button>
          )}
        </footer>
      </motion.div>
      </div>
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
