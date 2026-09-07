import React from 'react';
import { mocks } from './';

interface Events {
  [key: string]: Array<(data: any) => void>;
}

declare function GetParentResourceName(): string;

const events: Events = {};

async function fetchWithTimeout(resource: string, options: any = {}): Promise<Response> {
  const { timeout = 15000 } = options;

  const controller = new AbortController();
  const id = setTimeout(() => controller.abort(), timeout);

  const response = await fetch(resource, {
    ...options,
    signal: controller.signal,
  });
  clearTimeout(id);

  return response;
}

async function fetchWithRetries(resource: string, options: any = {}, retries: number = 1): Promise<Response> {
  try {
    return await fetchWithTimeout(resource, options);
  } catch (error: any) {
    if (error.name === 'AbortError' && retries > 0) {
      console.log(`Request Failed due to timeout: ${resource}`);
      return fetchWithRetries(resource, options, retries - 1);
    }
  }

  return new Response(null, {
    status: 408,
    statusText: 'Request Timeout',
    headers: {
      'Content-Length': '0',
    },
  });
}

async function post(event: string, data = {}): Promise<any> {
  if (!import.meta.env.PROD) {
    if (!mocks[event]) return;

    return mocks[event](data);
  }

  const url = `https://${GetParentResourceName()}/${event}`;

  const response = await fetchWithRetries(
    url,
    {
      method: 'post',
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify(data),
    },
    5,
  );

  const text = await response.text();
  if (!text || text.trim() === '') {
    return null;
  }

  try {
    return JSON.parse(text);
  } catch (e) {
    console.warn('Failed to parse JSON response:', text);
    return { error: 'Invalid JSON response', rawResponse: text };
  }
}

function onEvent(type: string, func: (data: any) => void): void {
  if (!events[type]) {
    events[type] = [];
  }
  events[type].push(func);
}

function offEvent(type: string, func: (data: any) => void): void {
  if (!events[type]) return;
  
  const index = events[type].indexOf(func);
  if (index > -1) {
    events[type].splice(index, 1);
  }
}

function emitEvent(type: string, payload: any): void {
  window.dispatchEvent(
    new MessageEvent('message', {
      data: { type, payload },
    }),
  );
}

const Nui = { post, onEvent, offEvent, emitEvent };

export default Nui;

export const EventListener = () => {
  React.useEffect(() => {
    const handleMessage = (e: MessageEvent) => {
      if (!events[e.data.type] || events[e.data.type].length === 0) return;

      events[e.data.type].forEach(handler => {
        handler(e.data.payload);
      });
    }

    window.addEventListener('message', handleMessage);

    return () => {
      window.removeEventListener('message', handleMessage);
    }
  }, []);

  return null;
};