const LocalesData = {
  "brand:name": "Overflow",
  "title:map": "Map",
  "title:players": "Players",
  "title:police": "Police",
  "title:discord": "Discord",
  "value:yes": "YES",
  "value:no": "NO",
  "button:rules": "Rules",
  "button:shop": "Shop",
  "button:close_game": "Close game",
  "button:settings": "Settings",
  "info:cash": "Cash",
  "info:bank": "Bank",
} as const
 
export type LocalesKeys = keyof typeof LocalesData

export type Locales = {
  [K in LocalesKeys]: string
}

export interface LocalesStore {
  locales: Locales,
  setLocales: (locales: Locales) => void
  t: (key: LocalesKeys, fb?: string) => string
}

export default LocalesData
