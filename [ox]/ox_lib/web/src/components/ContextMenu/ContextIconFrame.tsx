import type { CSSProperties, ReactNode } from 'react'

interface Props {
  children: ReactNode
  className?: string
  iconRgb?: string
}

export function ContextIconFrame({ children, className = '', iconRgb = 'var(--accent-rgb)' }: Props) {
  return (
    <div className={`relative grid h-[34px] w-[34px] shrink-0 place-items-center self-center ${className}`}>
      <svg className="pointer-events-none absolute inset-0" viewBox="0 0 34 34" aria-hidden>
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
      </svg>

      <span
        className="relative grid h-[26px] w-[26px] place-items-center overflow-hidden text-[12px] rs-icon-block"
        style={{ '--icon-rgb': iconRgb } as CSSProperties}
      >
        {children}
      </span>
    </div>
  )
}
