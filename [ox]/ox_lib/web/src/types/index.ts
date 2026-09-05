
export type IconProp = 'fas' | 'far' | 'fal' | 'fat' | 'fad' | 'fab' | 'fak' | 'fass'

export type IconValue = string | [IconProp, string]

export type NotificationPosition =
  | 'top'
  | 'top-right'
  | 'top-left'
  | 'bottom'
  | 'bottom-right'
  | 'bottom-left'
  | 'center-right'
  | 'center-left'

export type NotificationType = 'info' | 'warning' | 'success' | 'error'

export type IconAnimationType =
  | 'spin'
  | 'spinPulse'
  | 'spinReverse'
  | 'pulse'
  | 'beat'
  | 'fade'
  | 'beatFade'
  | 'bounce'
  | 'shake'

export interface NotificationProps {
  id?: string | number
  title?: string
  description?: string
  duration?: number
  showDuration?: boolean
  position?: NotificationPosition
  type?: NotificationType
  style?: Record<string, string>
  icon?: IconValue
  iconColor?: string
  iconAnimation?: IconAnimationType
  alignIcon?: 'top' | 'center'
}

export interface ContextMenuItem {
  title?: string
  menu?: string
  icon?: IconValue
  iconColor?: string
  image?: string
  progress?: number
  colorScheme?: string
  arrow?: boolean
  description?: string
  metadata?: string | string[] | Record<string, string | number> | Array<{ label: string; value?: string | number; progress?: number; colorScheme?: string }>
  disabled?: boolean
  readOnly?: boolean
  event?: string
  serverEvent?: string
  args?: unknown
}

export interface ContextMenuProps {
  title: string
  canClose?: boolean
  menu?: string
  options: Record<string, ContextMenuItem> | (ContextMenuItem & { title: string })[]
}

export type InputRowType =
  | 'input'
  | 'number'
  | 'checkbox'
  | 'select'
  | 'slider'
  | 'multi-select'
  | 'date'
  | 'date-range'
  | 'time'
  | 'textarea'
  | 'color'

export interface InputSelectOption {
  value: string
  label: string
  default?: string
}

export interface InputDialogRow {
  type: InputRowType
  label: string
  options?: InputSelectOption[]
  password?: boolean
  icon?: IconValue
  iconColor?: string
  placeholder?: string
  default?: string | number | boolean
  disabled?: boolean
  checked?: boolean
  min?: number
  max?: number
  step?: number
  required?: boolean
  description?: string
  minLength?: number
  maxLength?: number
  clearable?: boolean
  autosize?: boolean
  maxSelectedValues?: number
  searchable?: boolean

  format?: string

  returnString?: boolean
  /** When set, changing this field live-previews ox_lib HUD settings (transparency, etc.). */
  preview?: 'transparency' | 'borderRadius' | 'gradientIntensity' | 'perspective'
}

export interface InputDialogProps {
  heading: string
  rows: InputDialogRow[]
  options?: {
    allowCancel?: boolean
    size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl'
    /** Brand line under the heading (e.g. Jakers Designs on /ox_lib settings). */
    subtitle?: string
    /** Header badge label; defaults to Form. */
    badge?: string
  }
}

export type InputDialogResult = (string | number | boolean | null)[] | null

export interface AlertDialogProps {
  header: string
  content: string
  centered?: boolean
  size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl'
  overflow?: boolean
  cancel?: boolean
  labels?: { cancel?: string; confirm?: string }

  icon?: IconValue
  iconColor?: string
}

export type AlertResult = 'confirm' | 'cancel'

export type TextUIPosition = 'right-center' | 'left-center' | 'top-center' | 'bottom-center'

export interface TextUIData {
  text: string
  position?: TextUIPosition
  icon?: IconValue
  iconColor?: string
  alignIcon?: 'top' | 'center'
  style?: Record<string, string>
}
