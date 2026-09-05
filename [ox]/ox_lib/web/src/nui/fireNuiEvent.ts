/** Dispatch a NUI message locally (same shape as SendNUIMessage from Lua). */
export function fireNuiEvent<T = unknown>(action: string, data: T) {
  window.dispatchEvent(
    new MessageEvent('message', {
      data: { action, data },
    }),
  )
}

export function fireNuiEvents(events: { action: string; data: unknown }[], delay = 0) {
  if (delay === 0) {
    for (const event of events) {
      fireNuiEvent(event.action, event.data)
    }
    return
  }

  for (const event of events) {
    setTimeout(() => fireNuiEvent(event.action, event.data), delay)
  }
}
