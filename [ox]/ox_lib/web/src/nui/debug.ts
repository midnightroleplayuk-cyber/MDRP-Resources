export interface DebugEvent<T = unknown> {
  action: string
  data: T
}

export function debugData<T = unknown>(events: DebugEvent<T>[], delay = 0) {
  if (!import.meta.env.DEV) return

  for (const event of events) {
    setTimeout(() => {
      window.dispatchEvent(
        new MessageEvent('message', {
          data: { action: event.action, data: event.data },
        }),
      )
    }, delay)
  }
}
