import { AnimatePresence, motion } from 'framer-motion'
import { useSyncExternalStore } from 'react'
import { getLogoVisible, subscribeLogoVisible } from './store'

const LOGO_SRC = `${import.meta.env.BASE_URL}jakers-logo.png?v=2`

export function ShowcaseLogo() {
  const visible = useSyncExternalStore(subscribeLogoVisible, getLogoVisible, () => false)

  return (
    <AnimatePresence>
      {visible && (
        <motion.div
          key="showcase-logo"
          className="pointer-events-none fixed inset-0 z-[100] grid place-items-center"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 0.45, ease: [0.22, 1, 0.36, 1] }}
        >
          <motion.div
            className="h-[min(38vh,320px)] w-[min(38vh,320px)] overflow-hidden rounded-full"
            initial={{ opacity: 0, scale: 0.82, filter: 'blur(8px)' }}
            animate={{ opacity: 1, scale: 1, filter: 'blur(0px)' }}
            exit={{ opacity: 0, scale: 1.06, filter: 'blur(10px)' }}
            transition={{ type: 'spring', stiffness: 420, damping: 32 }}
          >
            <img
              src={LOGO_SRC}
              alt="Jakers Designs"
              draggable={false}
              className="h-full w-full select-none object-cover"
            />
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  )
}
