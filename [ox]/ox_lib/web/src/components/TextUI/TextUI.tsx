import { useState } from 'react'
import { AnimatePresence, motion } from 'framer-motion'
import ReactMarkdown from 'react-markdown'
import remarkGfm from 'remark-gfm'
import { useNuiEvent } from '@/nui/useNuiEvent'
import type { TextUIData, TextUIPosition } from '@/types'
import { sanitizeStyle } from '@/utils/style'
import { Icon } from '../Icon'
import { ContextIconFrame } from '../ContextMenu/ContextIconFrame'
import { usePanelMotion } from '@/dev/showcase/showcaseMotion'

const ANCHOR: Record<TextUIPosition, string> = {
  'right-center': 'fixed right-[3vh] top-1/2 -translate-y-1/2',
  'left-center': 'fixed left-[3vh] top-1/2 -translate-y-1/2',
  'top-center': 'fixed top-[3vh] left-1/2 -translate-x-1/2',
  'bottom-center': 'fixed bottom-[3vh] left-1/2 -translate-x-1/2',
}

const TILT: Record<TextUIPosition, string> = {
  'right-center': 'rs-tilt-stage-y-right rs-tilt-origin-center-right',
  'left-center': 'rs-tilt-stage-y-left rs-tilt-origin-center-left',
  'top-center': '',
  'bottom-center': '',
}

const TILT_INNER: Record<TextUIPosition, string> = {
  'right-center': 'rs-tilt-y-right',
  'left-center': 'rs-tilt-y-left',
  'top-center': '',
  'bottom-center': '',
}

/** Bottom-center matches progress bar / skill check width; side prompts match context menu. */
const WIDTH: Record<TextUIPosition, string> = {
  'right-center': 'w-[312px]',
  'left-center': 'w-[312px]',
  'top-center': 'w-[312px]',
  'bottom-center': 'w-[480px]',
}

function parsePrompt(text: string): { key: string | null; rest: string } {
  const clean = text.replace(/~[a-z0-9_]+~/gi, '').replace(/\^[0-9]/g, '')
  const bracket = clean.match(/^\s*\[([^\]]{1,12})\]\s*([\s\S]*)$/)
  if (bracket) return { key: bracket[1].trim(), rest: bracket[2].trim() }
  return { key: null, rest: clean.trim() }
}

function titleFrom(text: string) {
  const line = text.split('\n')[0]?.trim() ?? 'Interaction'
  return line.length > 48 ? `${line.slice(0, 48)}…` : line
}

export function TextUI() {
  const [data, setData] = useState<TextUIData | null>(null)
  const [pos, setPos] = useState<TextUIPosition>('right-center')

  useNuiEvent<TextUIData>('textUi', (d) => {
    setPos(d.position ?? 'right-center')
    setData(d)
  })
  useNuiEvent('textUiHide', () => setData(null))

  const parsed = data ? parsePrompt(data.text) : { key: null, rest: '' }
  const title = parsed.rest ? titleFrom(parsed.rest) : data?.text ? titleFrom(data.text) : 'Interaction'
  const subtitle = parsed.key ? `Press ${parsed.key}` : 'Interaction prompt'
  const iconColor = data?.iconColor ?? 'var(--rs-accent)'
  const panelMotion = usePanelMotion(
    pos === 'bottom-center' ? 'bottomPanel' : pos === 'left-center' ? 'listMenu' : 'notification',
  )

  const panel = data && (
    <motion.div
      key="textui"
      initial={panelMotion.initial}
      animate={panelMotion.animate}
      exit={panelMotion.exit}
      transition={panelMotion.transition}
      style={sanitizeStyle(data.style)}
      className={`pointer-events-none flex max-w-[92vw] flex-col overflow-hidden rounded-[calc(14px*var(--border-radius-scale))] border-[0.5px] border-white/[0.09] bg-[image:var(--rs-panel-gradient)] [box-shadow:var(--shadow-raised),inset_0_1px_0_rgba(255,255,255,0.06)] ${WIDTH[pos]}`}
    >
      <header className="relative z-[1] flex shrink-0 items-center gap-2.5 border-b-[0.5px] border-sep px-3 py-3">
        <ContextIconFrame>
          {data.icon ? (
            <Icon icon={data.icon} color={iconColor} fixedWidth />
          ) : parsed.key && parsed.key.length <= 2 ? (
            <span
              className="font-mono text-[11px] font-bold uppercase leading-none"
              style={{ color: 'var(--rs-accent)' }}
            >
              {parsed.key}
            </span>
          ) : (
            <Icon icon={parsed.key ? 'keyboard' : 'hand-pointer'} color="var(--rs-accent)" fixedWidth />
          )}
        </ContextIconFrame>

        <div className="min-w-0 flex flex-1 gap-2.5">
          <div className="min-w-0 flex-1">
            <p className="truncate text-[12.5px] font-semibold leading-tight tracking-[-0.01em] text-fg">{title}</p>
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
                TextUI
              </span>
            </span>
          </div>
        </div>
      </header>

      {parsed.rest &&
        (parsed.rest.includes('\n') || parsed.rest !== title || /\*\*|__|`/.test(parsed.rest)) && (
          <div className="relative min-h-0 p-2">
            <div className="relative overflow-hidden rounded-[calc(10px*var(--border-radius-scale))] border-[0.5px] border-sep bg-[image:var(--rs-panel-gradient)] px-3 py-3 [box-shadow:inset_0_0_0_1px_rgba(255,255,255,0.05),inset_0_2px_10px_rgba(0,0,0,0.42)]">
              <div className="textui-md min-w-0">
                <ReactMarkdown remarkPlugins={[remarkGfm]}>{parsed.rest}</ReactMarkdown>
              </div>
            </div>
          </div>
        )}
    </motion.div>
  )

  return (
    <div className={`pointer-events-none z-[400] ${ANCHOR[pos] ?? ANCHOR['right-center']}`}>
      <AnimatePresence>
        {data &&
          (TILT[pos] ? (
            <div className={`max-w-[92vw] ${WIDTH[pos]} ${TILT[pos]}`}>
              <div className={`w-full ${TILT_INNER[pos]}`}>{panel}</div>
            </div>
          ) : (
            panel
          ))}
      </AnimatePresence>
    </div>
  )
}
