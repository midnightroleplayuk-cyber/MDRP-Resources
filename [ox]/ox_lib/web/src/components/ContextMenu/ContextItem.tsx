import { useState } from 'react'
import { AnimatePresence, motion } from 'framer-motion'
import type { ContextMenuItem } from '@/types'
import { Icon } from '../Icon'
import { ContextIconFrame } from './ContextIconFrame'

interface Props {
  item: ContextMenuItem
  index: number
  focused: boolean
  onHover: () => void
  onSelect: () => void
}

type MetaRow = { label: string; value?: string | number; progress?: number }

function toMetaRows(metadata: ContextMenuItem['metadata']): MetaRow[] {
  if (!metadata) return []
  if (typeof metadata === 'string') return [{ label: metadata }]
  if (Array.isArray(metadata))
    return metadata.map((m) => (typeof m === 'string' ? { label: m } : (m as MetaRow)))
  return Object.entries(metadata).map(([label, value]) => ({ label, value }))
}

const SCHEME: Record<string, string> = {
  red: 'var(--rs-danger)',
  green: 'var(--rs-success)',
  teal: 'var(--rs-success)',
  blue: 'var(--rs-info)',
  cyan: 'var(--rs-info)',
  yellow: 'var(--rs-success)',
  orange: 'var(--rs-warning)',
}

const itemVariants = {
  hidden: { opacity: 0 },
  show: { opacity: 1, transition: { type: 'spring', stiffness: 460, damping: 34 } },
}

export function ContextItem({ item, index, focused, onHover, onSelect }: Props) {
  const [hover, setHover] = useState(false)
  const interactive = !item.disabled && !item.readOnly
  const showArrow = !!item.menu || !!item.arrow
  const meta = toMetaRows(item.metadata)
  const hasProgress = typeof item.progress === 'number'
  const multiline = !!item.description || hasProgress
  const progColor = item.colorScheme ? SCHEME[item.colorScheme] ?? 'var(--rs-accent)' : null
  const isFocused = focused && interactive
  const iconColor = item.iconColor ?? 'rgba(255,255,255,0.82)'
  const showIcon = !!(item.image || item.icon)

  return (
    <motion.div
      data-cindex={index}
      variants={itemVariants}
      className="relative border-b border-white/[0.06] last:border-b-0"
      onMouseEnter={() => {
        onHover()
        if (meta.length > 0) setHover(true)
      }}
      onMouseLeave={() => setHover(false)}
    >
      <button
        type="button"
        disabled={item.disabled}
        onClick={onSelect}
        className={[
          'group relative flex w-full items-center gap-2.5 px-3 py-2.5 text-left transition-colors duration-150',
          multiline ? 'items-start' : '',
          item.disabled
            ? 'cursor-not-allowed opacity-40'
            : !interactive
              ? 'cursor-default'
              : isFocused
                ? 'cursor-pointer bg-white/[0.04]'
                : 'cursor-pointer hover:bg-white/[0.03]',
        ].join(' ')}
      >
        {showIcon && (
          <ContextIconFrame iconRgb="232,232,232">
            {item.image ? (
              <img src={item.image} alt="" className="h-full w-full object-cover" />
            ) : (
              <Icon icon={item.icon!} color={iconColor} fixedWidth />
            )}
          </ContextIconFrame>
        )}

        <div className="min-w-0 flex-1">
          {item.title && (
            <p className="truncate text-[12.5px] font-semibold leading-tight tracking-[-0.01em] text-fg">
              {item.title}
            </p>
          )}
          {item.description && (
            <p className="mt-0.5 line-clamp-2 text-[11.5px] leading-[1.4] text-fg-soft">{item.description}</p>
          )}
          {hasProgress && (
            <div className="mt-1.5 flex items-center gap-2">
              <div className="h-[3px] flex-1 overflow-hidden rounded-pill bg-white/[0.08]">
                <div
                  className="h-full rounded-pill transition-[width] duration-300"
                  style={{
                    width: `${Math.min(100, Math.max(0, item.progress as number))}%`,
                    background: progColor ?? 'linear-gradient(90deg, var(--rs-accent), var(--rs-accent-hi))',
                  }}
                />
              </div>
              <span className="font-mono text-[9.5px] text-fg-mute">{Math.round(item.progress as number)}%</span>
            </div>
          )}
        </div>

        {showArrow && (
          <span
            className={`grid h-[18px] w-[18px] shrink-0 place-items-center rounded-full text-[9px] transition-all duration-150 ${
              multiline ? 'self-center' : ''
            } ${
              isFocused
                ? 'bg-white/10 text-fg'
                : 'text-fg-mute group-hover:bg-white/10 group-hover:text-fg-soft'
            }`}
          >
            <Icon icon="chevron-right" fixedWidth />
          </span>
        )}
      </button>

      <AnimatePresence>
        {hover && meta.length > 0 && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            transition={{ duration: 0.16 }}
            className="sb-scroll absolute right-full top-0 z-[10] mr-2.5 max-h-[260px] w-[212px] overflow-hidden rounded-[calc(14px*var(--border-radius-scale))] border-[0.5px] border-white/[0.09] bg-[image:var(--rs-panel-gradient)] p-3 [box-shadow:var(--shadow-raised),inset_0_1px_0_rgba(255,255,255,0.06)]"
          >
            <span className="mb-2 flex items-center gap-1.5">
              <span
                className="h-1 w-1 shrink-0 rounded-full"
                style={{ background: 'var(--rs-accent)', boxShadow: '0 0 5px rgba(var(--accent-rgb),0.8)' }}
              />
              <span className="font-display text-[8.5px] font-semibold uppercase tracking-[0.2em] text-accent">
                Details
              </span>
            </span>
            <div className="flex flex-col gap-2">
              {meta.map((m, i) => (
                <div key={i} className="text-[11.5px]">
                  <div className="flex items-center justify-between gap-3">
                    <span className="text-fg-soft">{m.label}</span>
                    {m.value != null && <span className="font-mono text-[11px] text-fg">{m.value}</span>}
                  </div>
                  {typeof m.progress === 'number' && (
                    <div className="mt-1.5 h-[3px] w-full overflow-hidden rounded-pill bg-white/[0.08]">
                      <div
                        className="h-full rounded-pill bg-gradient-to-r from-accent to-accent-hi"
                        style={{ width: `${Math.min(100, Math.max(0, m.progress))}%` }}
                      />
                    </div>
                  )}
                </div>
              ))}
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </motion.div>
  )
}
