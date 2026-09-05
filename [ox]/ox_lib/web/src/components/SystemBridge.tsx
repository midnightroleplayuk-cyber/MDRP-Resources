import { useEffect } from 'react'
import { useNuiEvent } from '@/nui/useNuiEvent'
import { fetchNui } from '@/nui/nui'
import { setLocaleData } from '@/nui/locale'
import {
  applyThemeConfig,
  DEFAULT_PRIMARY_COLOR,
  DEFAULT_PRIMARY_SHADE,
  type ThemeConfig,
} from '@/utils/theme'
import { applyUiSettings, DEFAULT_UI_SETTINGS, type UiSettings } from '@/utils/uiSettings'

export function SystemBridge() {
  useEffect(() => {
    fetchNui('init')
    fetchNui<ThemeConfig>('getConfig', undefined, {
      primaryColor: DEFAULT_PRIMARY_COLOR,
      primaryShade: DEFAULT_PRIMARY_SHADE,
    })
      .then(applyThemeConfig)
      .catch(() => {})
    fetchNui<UiSettings>('getUiSettings', undefined, DEFAULT_UI_SETTINGS)
      .then(applyUiSettings)
      .catch(() => {})
  }, [])

  useNuiEvent<UiSettings>('uiSettings', applyUiSettings)

  useNuiEvent<Record<string, unknown>>('setLocale', (data) => setLocaleData(data))

  useNuiEvent<string>('setClipboard', (text) => {
    if (!text) return
    try {
      const ta = document.createElement('textarea')
      ta.value = text
      ta.style.cssText = 'position:fixed;top:0;left:0;opacity:0;pointer-events:none'
      document.body.appendChild(ta)
      ta.focus()
      ta.select()
      document.execCommand('copy')
      document.body.removeChild(ta)
    } catch {
      navigator.clipboard?.writeText(text).catch(() => {})
    }
  })

  return null
}
