import { useCallback, useEffect, useRef, useState, useSyncExternalStore, type CSSProperties } from 'react'
import { fireNuiEvent, fireNuiEvents } from '@/nui/fireNuiEvent'
import { fetchNui } from '@/nui/nui'
import { useNuiEvent } from '@/nui/useNuiEvent'
import { applyThemeConfig } from '@/utils/theme'
import { DEFAULT_UI_SETTINGS, normalizeUiSettings, type UiSettingsState } from '@/utils/uiSettings'
import { UiSettingsControls } from './UiSettingsControls'
import { runShowcaseDemo, stopShowcaseDemo } from './showcase/runShowcaseDemo'
import { getShowcaseRunning, subscribeShowcaseRunning } from './showcase/store'
import { Icon } from '@/components/Icon'
import { ContextIconFrame } from '@/components/ContextMenu/ContextIconFrame'
import type {
  AlertDialogProps,
  ContextMenuProps,
  IconValue,
  InputDialogProps,
  NotificationProps,
  NotificationType,
} from '@/types'

function fireNotify(data: NotificationProps) {
  fireNuiEvent<NotificationProps>('notify', data)
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
        { label: 'Mileage', value: '12,408 km' },
      ],
    },
    { title: 'Customisation', description: 'Open the tuning options', icon: 'wrench', menu: 'tuning_menu' },
    { title: 'Repair in progress', icon: 'screwdriver-wrench', progress: 64, readOnly: true },
    { title: 'Sell Vehicle', description: 'This action cannot be undone', icon: 'dollar-sign', event: 'demo:sell', arrow: true },
    { title: 'Impounded', icon: 'ban', disabled: true },
  ],
}

const DIALOG_DEMO: InputDialogProps = {
  heading: 'Player Registration',
  options: { allowCancel: true, size: 'md' },
  rows: [
    { type: 'input', label: 'Full name', placeholder: 'John Doe', icon: 'user', required: true },
    { type: 'input', label: 'Password', password: true, icon: 'lock' },
    { type: 'number', label: 'Age', default: 21, min: 18, max: 99, icon: 'hashtag' },
    { type: 'slider', label: 'Reputation', default: 50, min: 0, max: 100 },
    {
      type: 'select',
      label: 'Faction',
      icon: 'flag',
      clearable: true,
      searchable: true,
      options: [
        { value: 'lspd', label: 'LSPD' },
        { value: 'bcso', label: 'BCSO' },
        { value: 'sahp', label: 'San Andreas Highway Patrol' },
        { value: 'ems', label: 'EMS' },
        { value: 'doj', label: 'Department of Justice' },
        { value: 'civ', label: 'Civilian' },
      ],
    },
    {
      type: 'multi-select',
      label: 'Licenses',
      maxSelectedValues: 2,
      options: [
        { value: 'car', label: 'Driver' },
        { value: 'bike', label: 'Motorcycle' },
        { value: 'weapon', label: 'Weapon' },
        { value: 'pilot', label: 'Pilot' },
      ],
    },
    { type: 'textarea', label: 'Notes', placeholder: 'Optional background…', autosize: true },
    { type: 'date', label: 'Date of birth', icon: 'calendar', format: 'DD/MM/YYYY', returnString: true },
    { type: 'color', label: 'Plate colour' },
    { type: 'checkbox', label: 'Accept the server rules', checked: false, required: true },
  ],
}

const SUCCESS_NOTIFY: NotificationProps = {
  type: 'success',
  title: 'Payment received',
  description: '$2,450 deposited.',
  showDuration: true,
  duration: 5000,
}

const LIST_MENU_DEMO = {
  title: 'Vehicle Controls',
  position: 'top-left' as const,
  items: [
    { label: 'Engine', icon: 'power-off', checked: true, description: 'Toggle the engine' },
    { label: 'Doors', icon: 'door-open', values: ['All', 'Front', 'Rear', 'Trunk'], defaultIndex: 1 },
    { label: 'Fuel', icon: 'gas-pump', progress: 64, colorScheme: 'green' },
    { label: 'Lock', icon: 'lock', description: 'Lock the vehicle' },
    { label: 'Livery', icon: 'palette', values: ['Stock', 'Police', 'Racing', 'Custom'] },
    { label: 'Store vehicle', icon: 'warehouse', close: true },
  ],
}

const PROGRESS_FULL = {
  label: 'Repairing engine',
  description: 'Hold still while the repair completes.',
  duration: 6000,
  canCancel: true,
}

const SKILL_CHECK_FULL = {
  difficulty: 'medium' as const,
  inputs: ['e'],
  title: 'Lockpicking',
  difficultyText: 'Rusty Lock',
}

const TEXTUI_BOTTOM = {
  text: '[Shift] Sprint · hold to **boost**',
  position: 'bottom-center' as const,
}

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

const DEMO_DURATION_MS = 3_000

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
  ])
}

function runBaseStack(hud: UiSettingsState) {
  fireNuiEvent('uiSettings', hud)
  fireNotify(SUCCESS_NOTIFY)
  fireNuiEvent('showContext', CONTEXT_DEMO)
  fireNuiEvent('setMenu', LIST_MENU_DEMO)
}

type DemoStack =
  | 'inputDialog'
  | 'progressFull'
  | 'skillCheckFull'
  | 'textUiBottom'
  | 'radialMenu'

function runDemoStack(stack: DemoStack, hud: UiSettingsState) {
  resetOpenUi()
  runBaseStack(hud)
  switch (stack) {
    case 'inputDialog':
      fireNuiEvent('openDialog', DIALOG_DEMO)
      break
    case 'progressFull':
      fireNuiEvent('progress', PROGRESS_FULL)
      break
    case 'skillCheckFull':
      fireNuiEvent('startSkillCheck', SKILL_CHECK_FULL)
      break
    case 'textUiBottom':
      fireNuiEvent('textUi', TEXTUI_BOTTOM)
      break
    case 'radialMenu':
      fireNuiEvent('openRadialMenu', RADIAL_DEMO)
      break
  }
}

const PUSH_ALL_TYPES: NotificationType[] = ['success', 'error', 'warning']

const NOTIFY_DEMOS: { label: string; type: NotificationType; data: NotificationProps }[] = [
  { label: 'Success', type: 'success', data: { type: 'success', title: 'Payment received', description: '$2,450 deposited.', showDuration: true, duration: 5000 } },
  { label: 'Error', type: 'error', data: { type: 'error', title: 'Cannot equip item', description: 'Your inventory is full.', showDuration: true, duration: 5000 } },
  { label: 'Warning', type: 'warning', data: { type: 'warning', title: 'Engine overheating', description: 'Pull over or risk breakdown.', showDuration: true, duration: 6000 } },
  { label: 'Info · top', type: 'info', data: { type: 'info', title: 'Dispatch update', description: '10-31 in progress · Legion Square.', position: 'top', showDuration: true, duration: 5000 } },
  { label: 'Info · bottom-left', type: 'info', data: { type: 'info', title: 'Friend request', description: 'Alex_M wants to add you.', position: 'bottom-left', showDuration: true, duration: 5000 } },
]

const DOT: Record<NotificationType, string> = {
  success: 'var(--rs-success)',
  error: 'var(--rs-danger)',
  warning: 'var(--rs-warning)',
  info: 'var(--rs-info)',
}

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div className="flex flex-col gap-2 border-b border-white/[0.06] pb-4 last:border-b-0 last:pb-0">
      <span
        className="font-display text-[8.5px] font-semibold uppercase tracking-[0.2em]"
        style={{ color: 'var(--rs-accent)' }}
      >
        {title}
      </span>
      <div className="flex flex-wrap gap-1.5">{children}</div>
    </div>
  )
}

function Btn({ onClick, dot, children }: { onClick: () => void; dot?: string; children: React.ReactNode }) {
  return (
    <button
      type="button"
      onClick={onClick}
      className="inline-flex items-center gap-2 rounded-[calc(8px*var(--border-radius-scale))] px-2.5 py-1.5 text-[12px] font-medium text-fg-soft transition-colors duration-150 hover:bg-white/[0.03] hover:text-fg active:scale-[0.98]"
    >
      {dot && (
        <span
          className="h-1 w-1 shrink-0 rounded-full"
          style={{ background: dot, boxShadow: `0 0 5px ${dot}` }}
        />
      )}
      {children}
    </button>
  )
}

function Guide({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <span className="inline-flex items-center gap-1.5">
      <span
        className="font-display text-[8.5px] font-semibold uppercase tracking-[0.2em]"
        style={{ color: 'var(--rs-accent)' }}
      >
        {label}
      </span>
      <span className="flex gap-0.5">{children}</span>
    </span>
  )
}

function Kbd({ icon }: { icon: IconValue }) {
  return (
    <kbd
      className="flex h-[20px] w-[20px] shrink-0 items-center justify-center p-0 rs-icon-block"
      style={{ '--icon-rgb': '232,232,232' } as CSSProperties}
    >
      <Icon icon={icon} className="block text-[10px] leading-none" fixedWidth />
    </kbd>
  )
}

function pushAllNotifications() {
  NOTIFY_DEMOS.filter((d) => PUSH_ALL_TYPES.includes(d.type)).forEach((d) => fireNotify(d.data))
}

export function DevPanel() {
  const isDevBrowser = import.meta.env.DEV
  const [sessionOpen, setSessionOpen] = useState(isDevBrowser)
  const [minimized, setMinimized] = useState(false)
  const [demoActive, setDemoActive] = useState(false)
  const showcaseRunning = useSyncExternalStore(subscribeShowcaseRunning, getShowcaseRunning, () => false)
  const [uiSettings, setUiSettings] = useState<UiSettingsState>(() => normalizeUiSettings(DEFAULT_UI_SETTINGS))
  const demoTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null)
  const uiSettingsRef = useRef(uiSettings)

  useEffect(() => {
    uiSettingsRef.current = uiSettings
  }, [uiSettings])

  useNuiEvent<boolean>('setDevPanelVisible', (open) => {
    setSessionOpen(open)
    if (!open) {
      setMinimized(false)
      setDemoActive(false)
      if (demoTimerRef.current) clearTimeout(demoTimerRef.current)
      resetOpenUi()
    }
  })

  const exitPanel = useCallback(() => {
    resetOpenUi()
    setMinimized(false)
    setDemoActive(false)
    if (demoTimerRef.current) clearTimeout(demoTimerRef.current)
    if (isDevBrowser) {
      setSessionOpen(false)
    } else {
      fetchNui('devPanelClose')
    }
  }, [isDevBrowser])

  useEffect(() => {
    return () => {
      if (demoTimerRef.current) clearTimeout(demoTimerRef.current)
    }
  }, [])

  const startShowcase = useCallback(async () => {
    if (showcaseRunning) {
      stopShowcaseDemo()
      return
    }

    if (demoTimerRef.current) clearTimeout(demoTimerRef.current)
    setDemoActive(true)
    setMinimized(true)

    try {
      await runShowcaseDemo(uiSettingsRef.current)
    } finally {
      setDemoActive(false)
      setMinimized(false)
    }
  }, [showcaseRunning])

  const startTimedDemo = useCallback((stack: DemoStack) => {
    if (demoTimerRef.current) clearTimeout(demoTimerRef.current)
    setDemoActive(true)
    setMinimized(true)

    const hud = uiSettingsRef.current

    requestAnimationFrame(() => {
      runDemoStack(stack, hud)
      if (!isDevBrowser) fetchNui('devPanelKeepFocus')
    })

    demoTimerRef.current = setTimeout(() => {
      resetOpenUi()
      setDemoActive(false)
      setMinimized(false)
      if (!isDevBrowser) fetchNui('devPanelKeepFocus')
      demoTimerRef.current = null
    }, DEMO_DURATION_MS)
  }, [isDevBrowser])

  if (!isDevBrowser && !sessionOpen) return null

  if (minimized && !demoActive) {
    return (
      <button
        type="button"
        onClick={() => setMinimized(false)}
        className="fixed bottom-[3vh] left-[3vh] z-[200] flex items-center gap-2.5 overflow-hidden rounded-[calc(14px*var(--border-radius-scale))] border-[0.5px] border-white/[0.09] bg-[image:var(--rs-panel-gradient)] px-3 py-2.5 [box-shadow:var(--shadow-raised),inset_0_1px_0_rgba(255,255,255,0.06)] transition-colors duration-150 hover:border-white/[0.14]"
      >
        <ContextIconFrame iconRgb="232,232,232">
          <Icon icon="screwdriver-wrench" color="var(--rs-accent)" fixedWidth />
        </ContextIconFrame>
        <span className="text-[12.5px] font-semibold text-fg">UI preview</span>
      </button>
    )
  }

  if (minimized && (demoActive || showcaseRunning)) return null

  return (
    <div className="fixed left-1/2 top-[3vh] z-[200] flex max-h-[82vh] w-[480px] max-w-[92vw] -translate-x-1/2 flex-col overflow-hidden rounded-[calc(14px*var(--border-radius-scale))] border-[0.5px] border-white/[0.09] bg-[image:var(--rs-panel-gradient)] [box-shadow:var(--shadow-raised),inset_0_1px_0_rgba(255,255,255,0.06)]">
      <header className="relative z-[1] flex shrink-0 items-center gap-2.5 border-b-[0.5px] border-sep px-3 py-3">
        <ContextIconFrame iconRgb="232,232,232">
          <Icon icon="bolt" color="var(--rs-accent)" fixedWidth />
        </ContextIconFrame>

        <div className="min-w-0 flex flex-1 gap-2.5">
          <div className="min-w-0 flex-1">
            <p className="truncate text-[12.5px] font-semibold leading-tight tracking-[-0.01em] text-fg">
              ox_lib · Jakers Designs
            </p>
            <p className="mt-0.5 text-[11.5px] leading-[1.4] text-fg-soft">
              {isDevBrowser ? 'Browser preview' : 'Admin UI preview · /ox_uidev'}
            </p>
          </div>

          <div className="flex shrink-0 flex-col items-end gap-0.5">
            <span className="flex items-center gap-1.5">
              <span
                className="h-1 w-1 shrink-0 rounded-full"
                style={{ background: 'var(--rs-accent)', boxShadow: '0 0 5px rgba(var(--accent-rgb),0.8)' }}
              />
              <span
                className="font-display text-[8.5px] font-semibold uppercase tracking-[0.2em]"
                style={{ color: 'var(--rs-accent)' }}
              >
                Preview
              </span>
            </span>

            <button
              type="button"
              onClick={() => setMinimized(true)}
              className="grid h-[18px] w-[18px] place-items-center rounded-full text-[9px] text-fg-mute transition-all duration-150 hover:bg-white/10 hover:text-fg active:scale-90"
              aria-label="Minimize dev panel"
            >
              <Icon icon="xmark" fixedWidth />
            </button>
          </div>
        </div>
      </header>

      <div className="relative min-h-0 flex-1 p-2">
        <div className="relative flex max-h-[calc(82vh-120px)] min-h-0 flex-col overflow-hidden rounded-[calc(10px*var(--border-radius-scale))] border-[0.5px] border-sep bg-[image:var(--rs-panel-gradient)] [box-shadow:inset_0_0_0_1px_rgba(255,255,255,0.05),inset_0_2px_10px_rgba(0,0,0,0.42)]">
          <div className="sb-scroll flex min-h-0 flex-1 flex-col gap-4 px-3 py-3">
        <Section title="Showcase">
          <Btn onClick={startShowcase}>
            <Icon icon={showcaseRunning ? 'stop' : 'circle-play'} fixedWidth />
            {showcaseRunning ? 'Stop showcase' : 'showcase · full reel'}
          </Btn>
          <Btn onClick={() => startTimedDemo('inputDialog')}>
            1 · <Icon icon="keyboard" fixedWidth /> Input dialog
          </Btn>
          <Btn onClick={() => startTimedDemo('progressFull')}>
            2 · <Icon icon="bars-progress" fixedWidth /> Progress · full
          </Btn>
          <Btn onClick={() => startTimedDemo('skillCheckFull')}>
            3 · <Icon icon="gauge-high" fixedWidth /> Skill check · full
          </Btn>
          <Btn onClick={() => startTimedDemo('textUiBottom')}>
            4 · <Icon icon="hand-pointer" fixedWidth /> Text UI · bottom
          </Btn>
          <Btn onClick={() => startTimedDemo('radialMenu')}>
            5 · <Icon icon="bullseye" fixedWidth /> Radial menu
          </Btn>
        </Section>

        <Section title="Notifications">
          <Btn onClick={pushAllNotifications}>
            <Icon icon="bell" fixedWidth /> Push all
          </Btn>
          {NOTIFY_DEMOS.map((d) => (
            <Btn key={d.label} dot={DOT[d.type]} onClick={() => fireNotify(d.data)}>
              {d.label}
            </Btn>
          ))}
          <Btn
            onClick={() =>
              fireNotify({
                type: 'info',
                icon: 'spinner',
                iconAnimation: 'spin',
                title: 'Processing payment…',
                description: 'Verifying transfer with the bank.',
                showDuration: true,
                duration: 8000,
              })
            }
          >
            <Icon icon="spinner" spin fixedWidth /> Animated icon
          </Btn>
          <Btn
            onClick={() => {
              fireNotify({ id: 'job', type: 'info', title: 'Mining in progress', description: 'Extracting ore from the vein…', showDuration: true, duration: 6000 })
              setTimeout(
                () => fireNotify({ id: 'job', type: 'success', title: 'Ore collected', description: '3× iron ore added to inventory.', showDuration: true, duration: 4000 }),
                1400,
              )
            }}
          >
            Refresh by id
          </Btn>
          <Btn
            onClick={() =>
              Array.from({ length: 8 }).forEach((_, i) =>
                fireNotify({ type: 'info', title: `Alert ${i + 1}`, description: 'Older alerts drop off when the stack is full.' }),
              )
            }
          >
            Flood ×8
          </Btn>
        </Section>

        <Section title="Context menu">
          <Btn onClick={() => fireNuiEvent('showContext', CONTEXT_DEMO)}>
            <Icon icon="list" fixedWidth /> Open
          </Btn>
          <Btn
            onClick={() =>
              fireNuiEvent('showContext', {
                title: 'Quick Actions',
                options: [
                  { title: 'Give cash', event: 'demo:cash' },
                  { title: 'Send message', event: 'demo:msg' },
                  { title: 'View profile', arrow: true },
                ],
              } satisfies ContextMenuProps)
            }
          >
            No icons
          </Btn>
          <Btn
            onClick={() =>
              fireNuiEvent('showContext', { title: 'Inventory', options: [] } satisfies ContextMenuProps)
            }
          >
            Empty
          </Btn>
          <Btn onClick={() => fireNuiEvent('hideContext', {})}>Hide</Btn>
        </Section>

        <Section title="Input dialog">
          <Btn onClick={() => fireNuiEvent('openDialog', DIALOG_DEMO)}>
            <Icon icon="keyboard" fixedWidth /> Open
          </Btn>
          <Btn onClick={() => fireNuiEvent('closeInputDialog', {})}>Close</Btn>
        </Section>

        <Section title="Alert dialog">
          <Btn
            onClick={() =>
              fireNuiEvent<AlertDialogProps>('sendAlert', {
                header: 'Delete vehicle?',
                icon: 'trash',
                content: 'This will **permanently** remove the *Karin Sultan RS* from your garage.\n\nThis action cannot be undone.',
                cancel: true,
                labels: { confirm: 'Delete', cancel: 'Keep it' },
              })
            }
          >
            <Icon icon="triangle-exclamation" fixedWidth /> Confirm
          </Btn>
          <Btn
            onClick={() =>
              fireNuiEvent<AlertDialogProps>('sendAlert', {
                header: 'Server Rules',
                icon: 'shield-halved',
                centered: true,
                size: 'sm',
                content: 'By playing you agree to:\n\n- No RDM / VDM\n- Stay in character\n- Respect staff',
              })
            }
          >
            Centered
          </Btn>
          <Btn onClick={() => fireNuiEvent('closeAlertDialog', {})}>Close</Btn>
        </Section>

        <Section title="UI settings">
          <div className="w-full basis-full">
            <UiSettingsControls settings={uiSettings} onChange={setUiSettings} />
          </div>
        </Section>

        <Section title="Theme (ox.cfg)">
          <Btn onClick={() => applyThemeConfig({ primaryColor: 'jakers', primaryShade: 5 })}>
            <Icon icon="palette" fixedWidth /> Jakers · default
          </Btn>
          <Btn onClick={() => applyThemeConfig({ primaryColor: 'blue', primaryShade: 8 })}>
            Blue · shade 8
          </Btn>
          <Btn onClick={() => applyThemeConfig({ primaryColor: 'red', primaryShade: 6 })}>
            Red · shade 6
          </Btn>
        </Section>

        <Section title="Progress">
          <Btn onClick={() => fireNuiEvent('progress', { label: 'Lockpicking vehicle', duration: 5000 })}>
            <Icon icon="bars-progress" fixedWidth /> Bar
          </Btn>
          <Btn
            onClick={() =>
              fireNuiEvent('progress', {
                label: 'Repairing engine',
                description: 'Hold still while the repair completes.',
                duration: 6000,
                canCancel: true,
              })
            }
          >
            Bar · full
          </Btn>
          <Btn onClick={() => fireNuiEvent('circleProgress', { label: 'Searching', duration: 5000, position: 'middle' })}>
            <Icon icon="circle-notch" fixedWidth /> Circle · middle
          </Btn>
          <Btn onClick={() => fireNuiEvent('circleProgress', { label: 'Repairing', duration: 5000, position: 'bottom' })}>
            Circle · bottom
          </Btn>
          <Btn onClick={() => fireNuiEvent('progressCancel', {})}>Cancel</Btn>
        </Section>

        <Section title="TextUI">
          <Btn
            onClick={() =>
              fireNuiEvent('textUi', { text: '[E] Open trunk', position: 'right-center' })
            }
          >
            Key · right
          </Btn>
          <Btn
            onClick={() =>
              fireNuiEvent('textUi', { text: '[Shift] Sprint · hold to **boost**', position: 'bottom-center' })
            }
          >
            Wide key · bottom
          </Btn>
          <Btn
            onClick={() =>
              fireNuiEvent('textUi', {
                text: 'Restricted area ahead',
                icon: 'triangle-exclamation',
                iconColor: 'var(--rs-danger)',
                position: 'top-center',
              })
            }
          >
            Icon · top
          </Btn>
          <Btn onClick={() => fireNuiEvent('textUiHide', {})}>Hide</Btn>
        </Section>

        <Section title="Skill check">
          <Btn onClick={() => fireNuiEvent('startSkillCheck', { difficulty: 'easy', inputs: ['e'] })}>
            Easy
          </Btn>
          <Btn onClick={() => fireNuiEvent('startSkillCheck', { difficulty: 'hard', inputs: ['e', 'f', 'q'] })}>
            Hard
          </Btn>
          <Btn
            onClick={() =>
              fireNuiEvent('startSkillCheck', { difficulty: ['easy', 'medium', 'hard'], inputs: ['e', 'f'] })
            }
          >
            3 rounds
          </Btn>
          <Btn
            onClick={() =>
              fireNuiEvent('startSkillCheck', {
                difficulty: 'medium',
                inputs: ['e'],
                title: 'Lockpicking',
                difficultyText: 'Rusty Lock',
              })
            }
          >
            Custom title
          </Btn>
          <Btn onClick={() => fireNuiEvent('skillCheckCancel', {})}>Cancel</Btn>
        </Section>

        <Section title="Radial menu">
          <Btn
            onClick={() =>
              fireNuiEvent('openRadialMenu', {
                items: [
                  { icon: 'car', label: 'Vehicle' },
                  { icon: 'user', label: 'Player', menu: 'sub' },
                  { icon: 'handcuffs', label: 'Arrest' },
                  { icon: 'wrench', label: 'Repair' },
                  { icon: 'dollar-sign', label: 'Wallet' },
                  { icon: 'map-location-dot', label: 'Waypoint' },
                ],
              })
            }
          >
            <Icon icon="bullseye" fixedWidth /> Open
          </Btn>
          <Btn
            onClick={() =>
              fireNuiEvent('openRadialMenu', {
                sub: true,
                items: [
                  { icon: 'id-card', label: 'Show ID' },
                  { icon: 'comment', label: 'Talk' },
                  { icon: 'hand', label: 'Wave' },
                ],
              })
            }
          >
            Submenu
          </Btn>
          <Btn onClick={() => fireNuiEvent('openRadialMenu', false)}>Close</Btn>
        </Section>

        <Section title="List menu">
          <Btn onClick={() => fireNuiEvent('setMenu', LIST_MENU_DEMO)}>
            <Icon icon="bars" fixedWidth /> Open
          </Btn>
          <Btn onClick={() => fireNuiEvent('closeMenu', {})}>Close</Btn>
        </Section>
          </div>

          <span className="pointer-events-none absolute inset-x-0 top-0 h-3 bg-gradient-to-b from-[rgba(16,16,16,0.95)] to-transparent" />
          <span className="pointer-events-none absolute inset-x-0 bottom-0 h-3 bg-gradient-to-t from-[rgba(16,16,16,0.95)] to-transparent" />
        </div>
      </div>

      <footer className="relative z-[1] flex shrink-0 flex-wrap items-center justify-center gap-x-4 gap-y-2 border-t-[0.5px] border-sep px-3 py-3">
        <Guide label="Minimize">
          <Kbd icon="xmark" />
        </Guide>
        {!isDevBrowser && (
          <button
            type="button"
            onClick={exitPanel}
            className="text-[11px] font-medium text-fg-soft transition-colors hover:text-fg"
          >
            Exit preview
          </button>
        )}
      </footer>
    </div>
  )
}
