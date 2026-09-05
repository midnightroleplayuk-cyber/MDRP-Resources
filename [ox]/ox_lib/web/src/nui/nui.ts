export const IN_GAME = typeof (window as any).GetParentResourceName === 'function'

function resourceName(): string {
  const fn = (window as any).GetParentResourceName
  return typeof fn === 'function' ? fn() : 'ox_lib'
}

export async function fetchNui<T = unknown>(
  callback: string,
  data?: unknown,
  mock?: T,
): Promise<T> {
  if (import.meta.env.DEV) {
    console.log(`[nui:dev] -> ${callback}`, data)
    return (mock ?? ({} as T)) as T
  }

  const res = await fetch(`https://${resourceName()}/${callback}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(data ?? {}),
  })

  return (await res.json()) as T
}
