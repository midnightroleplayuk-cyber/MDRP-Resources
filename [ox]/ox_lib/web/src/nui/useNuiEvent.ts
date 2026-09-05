import { useEffect, useRef } from 'react'

interface NuiMessage<T = unknown> {
  action: string
  data: T
}

export function useNuiEvent<T = unknown>(
  action: string,
  handler: (data: T) => void,
) {
  const saved = useRef(handler)

  useEffect(() => {
    saved.current = handler
  }, [handler])

  useEffect(() => {
    const listener = (event: MessageEvent<NuiMessage<T>>) => {
      const { action: act, data } = event.data ?? {}
      if (act === action) saved.current(data)
    }

    window.addEventListener('message', listener)
    return () => window.removeEventListener('message', listener)
  }, [action])
}
