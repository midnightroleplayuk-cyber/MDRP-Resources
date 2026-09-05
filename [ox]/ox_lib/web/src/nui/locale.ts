import { useSyncExternalStore } from 'react'

type LocaleData = Record<string, unknown>

let store: LocaleData = {}
const subs = new Set<() => void>()

export function setLocaleData(data: LocaleData) {
  store = data || {}
  subs.forEach((f) => f())
}

export function locale(path: string, fallback = ''): string {
  const val = path.split('.').reduce<unknown>(
    (o, k) => (o && typeof o === 'object' ? (o as Record<string, unknown>)[k] : undefined),
    store,
  )
  return typeof val === 'string' ? val : fallback
}

function subscribe(cb: () => void) {
  subs.add(cb)
  return () => subs.delete(cb)
}

export function useT() {
  useSyncExternalStore(subscribe, () => store)
  return locale
}
