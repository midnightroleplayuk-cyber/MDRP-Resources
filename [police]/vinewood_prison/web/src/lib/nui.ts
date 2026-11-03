type Win = Window & { GetParentResourceName?: () => string };
const resource = (window as Win).GetParentResourceName?.() ?? 'vinewood_prison';
export const inGame = !!(window as Win).GetParentResourceName;

export type Result<T = Record<string, unknown>> = ({ ok: true } & T) | { ok: false; error: string };

async function post<T>(endpoint: string, body: unknown = {}): Promise<T> {
  try {
    const res = await fetch(`https://${resource}/${endpoint}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify(body),
    });
    return (await res.json()) as T;
  } catch {
    return { ok: false, error: 'no_response' } as T;
  }
}

export function call<T = Record<string, unknown>>(name: string, ...args: unknown[]) {
  return post<Result<T>>('call', { name, args });
}

export function local<T = Record<string, unknown>>(name: string, ...args: unknown[]) {
  return post<Result<T>>('local', { name, args });
}

export function closeUi() {
  return post('close');
}

type Listener = (data: any) => void;
const listeners = new Map<string, Set<Listener>>();

export function on(event: string, fn: Listener) {
  if (!listeners.has(event)) listeners.set(event, new Set());
  listeners.get(event)!.add(fn);
  return () => { listeners.get(event)!.delete(fn); };
}

export function emit(event: string, data: unknown) {
  listeners.get(event)?.forEach((fn) => fn(data));
}
