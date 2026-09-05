import type { CSSProperties } from 'react'

// Lua scripts can send `style` as a CSS string or an array-like table. Spreading
// those into React's style prop yields indexed keys, which crash with
// "Failed to set an indexed property on 'CSSStyleDeclaration'" in production.
export function sanitizeStyle(input: unknown): CSSProperties | undefined {
  if (!input || typeof input !== 'object' || Array.isArray(input)) return undefined
  const out: Record<string, string | number> = {}
  for (const [key, value] of Object.entries(input)) {
    if (/^\d+$/.test(key)) continue
    if (typeof value === 'string' || typeof value === 'number') out[key] = value
  }
  return out as CSSProperties
}
