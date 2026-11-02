import { MutableRefObject, useEffect, useRef } from "react";

export const isEnvBrowser = (): boolean => !(window as any).invokeNative;

interface NuiMessageData<T = unknown> {
  action: string;
  data: T;
}

type NuiHandlerSignature<T> = (data: T) => void;

export const useNuiEvent = <T = any>(action: string, handler: (data: T) => void) => {
  const savedHandler: MutableRefObject<NuiHandlerSignature<T>> = useRef(() => {});

  useEffect(() => {
    savedHandler.current = handler;
  }, [handler]);

  useEffect(() => {
    const eventListener = (event: MessageEvent) => {
      const { action: eventAction, data } = event.data;
      if (eventAction && eventAction === action && savedHandler.current) {
        try {
          savedHandler.current(data);
        } catch (error) {
          console.error(`Error in useNuiEvent handler for action ${action}:`, error);
        }
      }
    };

    window.addEventListener('message', eventListener);

    return () => {
      window.removeEventListener('message', eventListener);
    };
  }, [action]);
};

export async function fetchNui<T = any>(resourceName: string, eventName: string, data?: any): Promise<T> {
  const options = {
    method: 'post',
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify(data),
  };

  if (isEnvBrowser()) return undefined as any;

  try {
    const resp = await fetch(`https://${resourceName}/${eventName}`, options);
    const respFormatted = await resp.json();
    return respFormatted;
  } catch (error) {
    console.log(`Error in fetchNui for ${resourceName}/${eventName}`)
    return undefined as any;
  }
}