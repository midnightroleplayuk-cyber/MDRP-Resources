import { fireNuiEvent, fireNuiEvents } from '@/nui/fireNuiEvent'
import { applyThemeConfig } from '@/utils/theme'
import { UI_SETTINGS_RANGES, type UiSettingsState } from '@/utils/uiSettings'
import type { AlertDialogProps, ContextMenuProps, InputDialogProps, NotificationProps } from '@/types'
import {
  abortShowcase,
  beginShowcaseAbort,
  patchShowcaseSettings,
  resetShowcaseSettings,
  setLogoVisible,
  setShowcaseActive,
  setShowcaseRunning,
  setShowcaseSettingsPanel,
} from './store'
import { SHOWCASE_ENTER_MS, SHOWCASE_EXIT_MS, SHOWCASE_HOLD_MS, SHOWCASE_THEME_HOLD_MS } from './showcaseMotion'

const PROGRESS_DURATION_MS = 2000
const SHOWCASE_NOTIFY_GAP_MS = SHOWCASE_ENTER_MS + 350

const PROGRESS_DEMO = {
  label: 'Repairing engine',
  description: 'Hold still while the repair completes.',
  duration: PROGRESS_DURATION_MS,
  canCancel: true,
}

const CONTEXT_DEMO: ContextMenuProps = {
  title: 'Vehicle Garage',
  canClose: true,
  options: [
    {
      title: 'Karin Sultan RS',
      description: 'Plate · 48ABC123 · Stored',
      icon: 'car',
      arrow: true,
      metadata: [
        { label: 'Fuel', value: '82%', progress: 82 },
        { label: 'Engine', value: '94%', progress: 94 },
      ],
    },
    { title: 'Customisation', description: 'Open the tuning options', icon: 'wrench', menu: 'tuning_menu' },
    { title: 'Sell Vehicle', description: 'This action cannot be undone', icon: 'dollar-sign', event: 'demo:sell', arrow: true },
  ],
}

const LIST_MENU_DEMO = {
  title: 'Vehicle Controls',
  items: [
    { label: 'Engine', icon: 'power-off', checked: true, description: 'Toggle the engine' },
    { label: 'Doors', icon: 'door-open', values: ['All', 'Front', 'Rear', 'Trunk'], defaultIndex: 1 },
    { label: 'Fuel', icon: 'gas-pump', progress: 64, colorScheme: 'green' },
    { label: 'Lock', icon: 'lock', description: 'Lock the vehicle' },
  ],
}

const DIALOG_DEMO: InputDialogProps = {
  heading: 'Player Registration',
  options: { allowCancel: true, size: 'md' },
  rows: [
    { type: 'input', label: 'Full name', placeholder: 'John Doe', icon: 'user', required: true },
    { type: 'number', label: 'Age', default: 21, min: 18, max: 99, icon: 'hashtag' },
    {
      type: 'select',
      label: 'Faction',
      icon: 'flag',
      options: [
        { value: 'lspd', label: 'LSPD' },
        { value: 'ems', label: 'EMS' },
      ],
    },
  ],
}

const ALERT_DEMO: AlertDialogProps = {
  header: 'Delete vehicle?',
  icon: 'trash',
  content: 'This will **permanently** remove the *Karin Sultan RS* from your garage.',
  cancel: true,
  labels: { confirm: 'Delete', cancel: 'Keep it' },
}

/** Default top-right stack — duration 0 keeps them visible for the whole reel. */
const NOTIFY_STACK: NotificationProps[] = [
  { type: 'success', title: 'Payment received', description: '$2,450 deposited.', showDuration: false, duration: 0, position: 'top-right' },
  { type: 'warning', title: 'Engine overheating', description: 'Pull over or risk breakdown.', showDuration: false, duration: 0, position: 'top-right' },
  { type: 'error', title: 'Cannot equip item', description: 'Your inventory is full.', showDuration: false, duration: 0, position: 'top-right' },
]

const RADIAL_DEMO = {
  items: [
    { icon: 'car', label: 'Vehicle' },
    { icon: 'user', label: 'Player', menu: 'sub' },
    { icon: 'handcuffs', label: 'Arrest' },
    { icon: 'wrench', label: 'Repair' },
    { icon: 'dollar-sign', label: 'Wallet' },
    { icon: 'map-location-dot', label: 'Waypoint' },
  ],
}

function resetOpenUi() {
  fireNuiEvents([
    { action: 'clearNotifications', data: {} },
    { action: 'hideContext', data: {} },
    { action: 'closeInputDialog', data: {} },
    { action: 'closeMenu', data: {} },
    { action: 'progressCancel', data: {} },
    { action: 'skillCheckCancel', data: {} },
    { action: 'textUiHide', data: {} },
    { action: 'openRadialMenu', data: false },
    { action: 'closeAlertDialog', data: {} },
  ])
}

function wait(ms: number, signal: AbortSignal) {
  return new Promise<void>((resolve, reject) => {
    if (signal.aborted) {
      reject(new DOMException('Aborted', 'AbortError'))
      return
    }

    const timer = window.setTimeout(() => {
      signal.removeEventListener('abort', onAbort)
      resolve()
    }, ms)

    const onAbort = () => {
      window.clearTimeout(timer)
      reject(new DOMException('Aborted', 'AbortError'))
    }

    signal.addEventListener('abort', onAbort, { once: true })
  })
}

async function beat(signal: AbortSignal, ms: number) {
  await wait(ms, signal)
}

async function showLogo(signal: AbortSignal, holdMs: number) {
  setLogoVisible(true)
  await beat(signal, holdMs)
  setLogoVisible(false)
  await beat(signal, SHOWCASE_EXIT_MS)
}

async function stepProgressFull(signal: AbortSignal) {
  fireNuiEvent('progress', PROGRESS_DEMO)
  await beat(signal, SHOWCASE_ENTER_MS)
  await beat(signal, PROGRESS_DURATION_MS + 500)
  await beat(signal, SHOWCASE_EXIT_MS)
}

const RADIAL_HOVER_MS = 380

async function stepRadialShowcase(signal: AbortSignal) {
  const itemCount = RADIAL_DEMO.items.length

  fireNuiEvent('openRadialMenu', RADIAL_DEMO)
  await beat(signal, SHOWCASE_ENTER_MS)

  for (let i = 0; i < itemCount; i++) {
    fireNuiEvent('radialSetHover', i)
    await beat(signal, RADIAL_HOVER_MS)
  }

  await beat(signal, 600)
  fireNuiEvent('openRadialMenu', false)
  await beat(signal, SHOWCASE_EXIT_MS)
}

async function stepSkillCheckFull(signal: AbortSignal) {
  fireNuiEvent('startSkillCheck', {
    difficulty: ['easy', 'medium', 'hard'],
    inputs: ['e', 'f'],
    title: 'Lockpicking',
    difficultyText: 'Rusty Lock',
  })
  await beat(signal, SHOWCASE_ENTER_MS)
  // Three rounds auto-pass in showcase; brief hold on final green OK.
  await beat(signal, 2000)
  await beat(signal, 280)
}

async function stepTransient(
  signal: AbortSignal,
  show: () => void,
  hide: () => void,
  holdMs = SHOWCASE_HOLD_MS,
) {
  show()
  await beat(signal, SHOWCASE_ENTER_MS)
  await beat(signal, holdMs)
  hide()
  await beat(signal, SHOWCASE_EXIT_MS)
}

function applyHud(hud: UiSettingsState) {
  fireNuiEvent('uiSettings', hud)
}

async function animateSlider(
  signal: AbortSignal,
  key: 'transparency' | 'borderRadius' | 'gradientIntensity',
  from: number,
  to: number,
  state: UiSettingsState,
  steps = 28,
  stepMs = 42,
): Promise<UiSettingsState> {
  let current = { ...state }

  for (let i = 0; i <= steps; i++) {
    const value = Math.round(from + ((to - from) * i) / steps)
    current = { ...current, [key]: value }
    applyHud(current)
    patchShowcaseSettings({ [key]: value })
    await beat(signal, stepMs)
  }

  return current
}

async function setPerspectiveStage(
  signal: AbortSignal,
  perspective: string,
  state: UiSettingsState,
  holdMs = 1400,
): Promise<UiSettingsState> {
  const next = { ...state, perspective }
  applyHud(next)
  patchShowcaseSettings({ perspective })
  await beat(signal, holdMs)
  return next
}

async function revealSettingsShowcase(signal: AbortSignal, baseHud: UiSettingsState) {
  applyThemeConfig({ primaryColor: 'jakers', primaryShade: 5 })

  let hud: UiSettingsState = { ...baseHud }
  resetShowcaseSettings(hud)
  applyHud(hud)
  setShowcaseSettingsPanel(true, hud)
  await beat(signal, SHOWCASE_ENTER_MS)

  const { min: tMin } = UI_SETTINGS_RANGES.transparency
  const { min: rMin, max: rMax } = UI_SETTINGS_RANGES.borderRadius
  const { max: gMax } = UI_SETTINGS_RANGES.gradientIntensity

  hud = await animateSlider(signal, 'transparency', hud.transparency, tMin, hud)
  await beat(signal, 320)
  hud = await animateSlider(signal, 'transparency', tMin, 75, hud)
  await beat(signal, 480)

  hud = await animateSlider(signal, 'borderRadius', hud.borderRadius, rMin, hud)
  await beat(signal, 320)
  hud = await animateSlider(signal, 'borderRadius', rMin, rMax, hud)
  await beat(signal, 320)
  hud = await animateSlider(signal, 'borderRadius', rMax, 15, hud)
  await beat(signal, 480)

  hud = await animateSlider(signal, 'gradientIntensity', hud.gradientIntensity, gMax, hud)
  await beat(signal, 320)
  hud = await animateSlider(signal, 'gradientIntensity', gMax, 75, hud)
  await beat(signal, 480)

  hud = await setPerspectiveStage(signal, 'none', hud, 900)
  hud = await setPerspectiveStage(signal, 'tilt-10', hud)
  hud = await setPerspectiveStage(signal, 'tilt-20', hud)
  hud = await setPerspectiveStage(signal, 'tilt-30', hud)

  applyThemeConfig({ primaryColor: 'blue', primaryShade: 8 })
  await beat(signal, SHOWCASE_THEME_HOLD_MS)

  applyThemeConfig({ primaryColor: 'red', primaryShade: 6 })
  await beat(signal, SHOWCASE_THEME_HOLD_MS)

  setShowcaseSettingsPanel(false)
  await beat(signal, SHOWCASE_EXIT_MS)
}

/** One notification at a time — wait for enter before the next. */
async function revealPersistentStack(signal: AbortSignal) {
  for (const data of NOTIFY_STACK) {
    fireNuiEvent('notify', data)
    await beat(signal, SHOWCASE_NOTIFY_GAP_MS)
  }

  fireNuiEvent('showContext', CONTEXT_DEMO)
  await beat(signal, SHOWCASE_ENTER_MS + 600)

  fireNuiEvent('setMenu', LIST_MENU_DEMO)
  await beat(signal, SHOWCASE_ENTER_MS + 600)
}

export async function runShowcaseDemo(defaultHud: UiSettingsState) {
  abortShowcase()
  const controller = beginShowcaseAbort()
  const { signal } = controller

  setShowcaseRunning(true)
  setShowcaseActive(true)
  resetOpenUi()
  applyThemeConfig({ primaryColor: 'jakers', primaryShade: 5 })
  applyHud(defaultHud)

  try {
    await showLogo(signal, 2200)

    await revealPersistentStack(signal)

    await stepTransient(
      signal,
      () => fireNuiEvent('openDialog', DIALOG_DEMO),
      () => fireNuiEvent('closeInputDialog', {}),
    )

    await stepProgressFull(signal)

    await stepSkillCheckFull(signal)

    await stepTransient(
      signal,
      () => fireNuiEvent('textUi', { text: '[Shift] Sprint · hold to **boost**', position: 'bottom-center' }),
      () => fireNuiEvent('textUiHide', {}),
    )

    await stepRadialShowcase(signal)

    await stepTransient(
      signal,
      () => fireNuiEvent('sendAlert', ALERT_DEMO),
      () => fireNuiEvent('closeAlertDialog', {}),
    )

    await beat(signal, SHOWCASE_EXIT_MS)

    await revealSettingsShowcase(signal, defaultHud)

    resetOpenUi()
    await beat(signal, SHOWCASE_EXIT_MS)

    applyThemeConfig({ primaryColor: 'jakers', primaryShade: 5 })
    applyHud(defaultHud)
    await showLogo(signal, 2200)
  } catch (error) {
    if (!(error instanceof DOMException && error.name === 'AbortError')) throw error
  } finally {
    resetOpenUi()
    setShowcaseSettingsPanel(false)
    setLogoVisible(false)
    setShowcaseActive(false)
    setShowcaseRunning(false)
    applyThemeConfig({ primaryColor: 'jakers', primaryShade: 5 })
    applyHud(defaultHud)
  }
}

export function stopShowcaseDemo() {
  abortShowcase()
}
