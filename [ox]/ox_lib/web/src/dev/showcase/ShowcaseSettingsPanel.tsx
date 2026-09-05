import { AnimatePresence, motion } from 'framer-motion'
import { useSyncExternalStore } from 'react'
import { Icon } from '@/components/Icon'
import { ContextIconFrame } from '@/components/ContextMenu/ContextIconFrame'
import { UiSettingsControls } from '@/dev/UiSettingsControls'
import { usePanelMotion } from '@/dev/showcase/showcaseMotion'
import {
  getShowcaseSettings,
  getShowcaseSettingsPanelVisible,
  subscribeShowcaseSettingsPanel,
} from './store'

export function ShowcaseSettingsPanel() {
  const visible = useSyncExternalStore(
    subscribeShowcaseSettingsPanel,
    getShowcaseSettingsPanelVisible,
    () => false,
  )
  const settings = useSyncExternalStore(subscribeShowcaseSettingsPanel, getShowcaseSettings, () =>
    getShowcaseSettings(),
  )
  const panelMotion = usePanelMotion('bottomPanel')

  return (
    <AnimatePresence>
      {visible && (
        <div className="pointer-events-none fixed bottom-[3vh] left-1/2 z-[1300] w-[480px] max-w-[92vw] -translate-x-1/2">
          <motion.div
            key="showcase-settings"
            initial={panelMotion.initial}
            animate={panelMotion.animate}
            exit={panelMotion.exit}
            transition={panelMotion.transition}
            className="flex w-full flex-col overflow-hidden rounded-[calc(14px*var(--border-radius-scale))] border-[0.5px] border-white/[0.09] bg-[image:var(--rs-panel-gradient)] [box-shadow:var(--shadow-raised),inset_0_1px_0_rgba(255,255,255,0.06)]"
          >
            <header className="relative z-[1] flex shrink-0 items-center gap-2.5 border-b-[0.5px] border-sep px-3 py-3">
              <ContextIconFrame>
                <Icon icon="gear" color="var(--rs-accent)" fixedWidth />
              </ContextIconFrame>

              <div className="min-w-0 flex flex-1 gap-2.5">
                <div className="min-w-0 flex-1">
                  <p className="truncate text-[12.5px] font-semibold leading-tight tracking-[-0.01em] text-fg">
                    Settings
                  </p>
                  <p className="mt-0.5 text-[11.5px] leading-[1.4] text-fg-soft">
                    <span
                      className="font-display text-[8.5px] font-semibold uppercase tracking-[0.2em]"
                      style={{ color: 'var(--rs-accent)' }}
                    >
                      Jakers Designs
                    </span>
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
                      Settings
                    </span>
                  </span>
                </div>
              </div>
            </header>

            <div className="relative min-h-0 p-3">
              <UiSettingsControls settings={settings} onChange={() => {}} interactive={false} />
            </div>
          </motion.div>
        </div>
      )}
    </AnimatePresence>
  )
}
