import { useSyncExternalStore } from 'react'
import type { Transition } from 'framer-motion'
import { getShowcaseActive, subscribeShowcaseActive } from './store'

export type PanelMotionKey =
  | 'notification'
  | 'contextMenu'
  | 'listMenu'
  | 'bottomPanel'
  | 'centerPanel'
  | 'radial'
  | 'fade'

/** Time to wait after triggering enter — matches spring settle. */
export const SHOWCASE_ENTER_MS = 780
/** Time to wait after triggering exit before the next step. */
export const SHOWCASE_EXIT_MS = 620
/** Default hold once a panel is fully visible (transient showcase steps). */
export const SHOWCASE_HOLD_MS = 2000
/** Blue / red theme montage hold. */
export const SHOWCASE_THEME_HOLD_MS = 3500

const SHOWCASE_SPRING: Transition = { type: 'spring', stiffness: 260, damping: 30, mass: 1 }
const DEFAULT_SPRING: Transition = { type: 'spring', stiffness: 460, damping: 34 }

export function useShowcaseActive() {
  return useSyncExternalStore(subscribeShowcaseActive, getShowcaseActive, () => false)
}

export function usePanelMotion(key: PanelMotionKey) {
  const showcase = useShowcaseActive()
  return getPanelMotion(showcase, key)
}

export function getPanelMotion(showcase: boolean, key: PanelMotionKey) {
  if (!showcase) {
    return {
      initial: { opacity: 0 },
      animate: { opacity: 1 },
      exit: { opacity: 0, transition: { duration: 0.16 } },
      transition: DEFAULT_SPRING,
    }
  }

  switch (key) {
    case 'notification':
    case 'contextMenu':
      return {
        initial: { opacity: 0, x: 40 },
        animate: { opacity: 1, x: 0 },
        exit: { opacity: 0, x: 40, transition: { duration: 0.28, ease: [0.22, 1, 0.36, 1] } },
        transition: SHOWCASE_SPRING,
      }
    case 'listMenu':
      return {
        initial: { opacity: 0, x: -40 },
        animate: { opacity: 1, x: 0 },
        exit: { opacity: 0, x: -40, transition: { duration: 0.28, ease: [0.22, 1, 0.36, 1] } },
        transition: SHOWCASE_SPRING,
      }
    case 'bottomPanel':
      return {
        initial: { opacity: 0, y: 36 },
        animate: { opacity: 1, y: 0 },
        exit: { opacity: 0, y: 36, transition: { duration: 0.28, ease: [0.22, 1, 0.36, 1] } },
        transition: SHOWCASE_SPRING,
      }
    case 'centerPanel':
      return {
        initial: { opacity: 0, scale: 0.96 },
        animate: { opacity: 1, scale: 1 },
        exit: { opacity: 0, scale: 0.96, transition: { duration: 0.24, ease: [0.22, 1, 0.36, 1] } },
        transition: SHOWCASE_SPRING,
      }
    case 'radial':
      return {
        initial: { opacity: 0, scale: 0.94 },
        animate: { opacity: 1, scale: 1 },
        exit: { opacity: 0, scale: 0.94, transition: { duration: 0.28, ease: [0.22, 1, 0.36, 1] } },
        transition: SHOWCASE_SPRING,
      }
    case 'fade':
    default:
      return {
        initial: { opacity: 0 },
        animate: { opacity: 1 },
        exit: { opacity: 0, transition: { duration: 0.2 } },
        transition: SHOWCASE_SPRING,
      }
  }
}
