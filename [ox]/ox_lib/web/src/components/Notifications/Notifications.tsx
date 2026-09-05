import { useCallback, useState } from 'react'
import { AnimatePresence } from 'framer-motion'
import { useNuiEvent } from '@/nui/useNuiEvent'
import type { NotificationPosition, NotificationProps } from '@/types'
import { NotificationCard } from './NotificationCard'

interface Active {
  uid: number
  seq: number
  oxId?: string | number
  data: NotificationProps
}

const POSITIONS: NotificationPosition[] = [
  'top-left',
  'top',
  'top-right',
  'center-left',
  'center-right',
  'bottom-left',
  'bottom',
  'bottom-right',
]

const ANCHOR: Record<NotificationPosition, string> = {
  'top-left': 'top-[3vh] left-[3vh]',
  top: 'top-[3vh] left-1/2 -translate-x-1/2',
  'top-right': 'top-[3vh] right-[3vh]',
  'center-left': 'top-1/2 left-[3vh] -translate-y-1/2',
  'center-right': 'top-1/2 right-[3vh] -translate-y-1/2',
  'bottom-left': 'bottom-[3vh] left-[3vh]',
  bottom: 'bottom-[3vh] left-1/2 -translate-x-1/2',
  'bottom-right': 'bottom-[3vh] right-[3vh]',
}

const COLUMN: Record<NotificationPosition, string> = {
  'top-left': 'items-stretch flex-col-reverse',
  top: 'items-stretch flex-col-reverse',
  'top-right': 'items-stretch flex-col-reverse',
  'center-left': 'items-stretch flex-col',
  'center-right': 'items-stretch flex-col',
  'bottom-left': 'items-stretch flex-col',
  bottom: 'items-stretch flex-col',
  'bottom-right': 'items-stretch flex-col',
}

const TILT: Record<NotificationPosition, { stage: string; inner: string } | null> = {
  'top-left': { stage: 'rs-tilt-stage-y-left rs-tilt-axis-viewport-y-left', inner: 'rs-tilt-y-left' },
  top: null,
  'top-right': { stage: 'rs-tilt-stage-y-right rs-tilt-axis-viewport-y-right', inner: 'rs-tilt-y-right' },
  'center-left': { stage: 'rs-tilt-stage-y-left rs-tilt-origin-center-left', inner: 'rs-tilt-y-left' },
  'center-right': { stage: 'rs-tilt-stage-y-right rs-tilt-origin-center-right', inner: 'rs-tilt-y-right' },
  'bottom-left': { stage: 'rs-tilt-stage-y-left rs-tilt-axis-viewport-y-left-bottom', inner: 'rs-tilt-y-left' },
  bottom: null,
  'bottom-right': { stage: 'rs-tilt-stage-y-right rs-tilt-axis-viewport-y-right-bottom', inner: 'rs-tilt-y-right' },
}

const MAX_VISIBLE = 6

// Normalise any unknown/invalid position to top-right so a toast is never
// silently dropped for using a position outside the supported set.
const posOf = (d: NotificationProps): NotificationPosition =>
  POSITIONS.includes(d.position as NotificationPosition) ? (d.position as NotificationPosition) : 'top-right'

let counter = 0

export function Notifications() {
  const [items, setItems] = useState<Active[]>([])

  const dismiss = useCallback((uid: number) => {
    setItems((prev) => prev.filter((n) => n.uid !== uid))
  }, [])

  useNuiEvent('clearNotifications', () => {
    setItems([])
  })

  useNuiEvent<NotificationProps>('notify', (data) => {
    setItems((prev) => {
      if (data.id != null) {
        const idx = prev.findIndex((n) => n.oxId === data.id)
        if (idx !== -1) {
          const next = [...prev]
          next[idx] = { ...next[idx], seq: next[idx].seq + 1, data }
          return next
        }
      }

      const entry: Active = { uid: ++counter, seq: 0, oxId: data.id, data }
      const next = [...prev, entry]

      const pos = posOf(data)
      const samePos = next.filter((n) => posOf(n.data) === pos)
      if (samePos.length > MAX_VISIBLE) {
        const drop = samePos[0].uid
        return next.filter((n) => n.uid !== drop)
      }
      return next
    })
  })

  return (
    <>
      {POSITIONS.map((pos) => {
        const group = items.filter((n) => posOf(n.data) === pos)

        return (
          <div key={pos} className={`pointer-events-none fixed z-[9999] w-[312px] max-w-[90vw] ${ANCHOR[pos]}`}>
            {TILT[pos] ? (
              <div className={`w-full ${TILT[pos]!.stage}`}>
                <div className={`w-full ${TILT[pos]!.inner}`}>
                  <div className={`flex w-full gap-2 ${COLUMN[pos]}`}>
                    <AnimatePresence mode="sync">
                      {group.map((n) => (
                        <NotificationCard
                          key={n.uid}
                          restartKey={n.seq}
                          notification={n.data}
                          onDismiss={() => dismiss(n.uid)}
                        />
                      ))}
                    </AnimatePresence>
                  </div>
                </div>
              </div>
            ) : (
              <div className={`flex w-full gap-2 ${COLUMN[pos]}`}>
                <AnimatePresence mode="sync">
                  {group.map((n) => (
                    <NotificationCard
                      key={n.uid}
                      restartKey={n.seq}
                      notification={n.data}
                      onDismiss={() => dismiss(n.uid)}
                    />
                  ))}
                </AnimatePresence>
              </div>
            )}
          </div>
        )
      })}
    </>
  )
}
