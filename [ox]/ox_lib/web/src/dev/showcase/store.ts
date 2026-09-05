import { DEFAULT_UI_SETTINGS, normalizeUiSettings, type UiSettingsState } from '@/utils/uiSettings'

type Listener = () => void

let showcaseActive = false
let logoVisible = false
let showcaseRunning = false
let settingsPanelVisible = false
let showcaseSettings: UiSettingsState = normalizeUiSettings(DEFAULT_UI_SETTINGS)
let abortController: AbortController | null = null

const activeListeners = new Set<Listener>()
const logoListeners = new Set<Listener>()
const runningListeners = new Set<Listener>()
const settingsPanelListeners = new Set<Listener>()

function notify(set: Set<Listener>) {
  set.forEach((listener) => listener())
}

export function getShowcaseActive() {
  return showcaseActive
}

export function getLogoVisible() {
  return logoVisible
}

export function getShowcaseRunning() {
  return showcaseRunning
}

export function getShowcaseSettingsPanelVisible() {
  return settingsPanelVisible
}

export function getShowcaseSettings() {
  return showcaseSettings
}

export function subscribeShowcaseActive(listener: Listener) {
  activeListeners.add(listener)
  return () => activeListeners.delete(listener)
}

export function subscribeLogoVisible(listener: Listener) {
  logoListeners.add(listener)
  return () => logoListeners.delete(listener)
}

export function subscribeShowcaseRunning(listener: Listener) {
  runningListeners.add(listener)
  return () => runningListeners.delete(listener)
}

export function subscribeShowcaseSettingsPanel(listener: Listener) {
  settingsPanelListeners.add(listener)
  return () => settingsPanelListeners.delete(listener)
}

export function setShowcaseActive(active: boolean) {
  if (showcaseActive === active) return
  showcaseActive = active
  document.documentElement.dataset.showcase = active ? '1' : ''
  notify(activeListeners)
}

export function setLogoVisible(visible: boolean) {
  if (logoVisible === visible) return
  logoVisible = visible
  notify(logoListeners)
}

export function setShowcaseRunning(running: boolean) {
  if (showcaseRunning === running) return
  showcaseRunning = running
  notify(runningListeners)
}

export function setShowcaseSettingsPanel(visible: boolean, settings?: UiSettingsState) {
  settingsPanelVisible = visible
  if (settings) showcaseSettings = settings
  notify(settingsPanelListeners)
}

export function patchShowcaseSettings(partial: Partial<UiSettingsState>) {
  showcaseSettings = { ...showcaseSettings, ...partial }
  notify(settingsPanelListeners)
}

export function resetShowcaseSettings(base: UiSettingsState) {
  showcaseSettings = { ...base }
}

export function beginShowcaseAbort() {
  abortController?.abort()
  abortController = new AbortController()
  return abortController
}

export function getShowcaseAbortSignal() {
  return abortController?.signal
}

export function abortShowcase() {
  abortController?.abort()
  abortController = null
}
