import { create } from 'zustand'
import type { Locales, LocalesKeys, LocalesStore } from './locales.data'
import LocalesData from './locales.data';

export const useLocales = create<LocalesStore>( (set, get) => {
    return {
        locales: {
          ...LocalesData
        },
        setLocales: (locales: Locales) => {
          set((curr) => ({ ...curr, locales: locales }))
        },
        t: (key: LocalesKeys, fb?: string): string => {
          return get().locales[key] || fb || key
        }
    }
})
