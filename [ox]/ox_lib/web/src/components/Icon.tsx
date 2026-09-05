import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import {
  library,
  findIconDefinition,
  type IconName,
  type IconPrefix,
  type IconProp as FaIconProp,
} from '@fortawesome/fontawesome-svg-core'
import { fas } from '@fortawesome/free-solid-svg-icons'
import { fab } from '@fortawesome/free-brands-svg-icons'
import type { IconAnimationType, IconValue } from '@/types'

library.add(fas, fab)

interface IconProps {
  icon: IconValue
  className?: string
  color?: string
  spin?: boolean

  animation?: IconAnimationType
  fixedWidth?: boolean
}

function resolve(icon: IconValue): FaIconProp | null {
  let prefix: IconPrefix = 'fas'
  let name: string

  if (Array.isArray(icon)) {
    prefix = icon[0] as IconPrefix
    name = icon[1]
  } else {
    name = icon
  }

  name = name.replace(/^fa-/, '')

  const iconName = name as IconName
  if (findIconDefinition({ prefix, iconName })) return { prefix, iconName } as FaIconProp
  if (prefix !== 'fas' && prefix !== 'fab' && findIconDefinition({ prefix: 'fas', iconName }))
    return { prefix: 'fas', iconName } as FaIconProp
  return null
}

export function Icon({ icon, className, color, spin, animation, fixedWidth }: IconProps) {
  const def = resolve(icon)
  if (!def) return null

  const anim = animation ? { [animation]: true } : undefined

  return (
    <FontAwesomeIcon
      icon={def}
      className={className}
      spin={spin}
      fixedWidth={fixedWidth}
      style={color ? { color } : undefined}
      {...anim}
    />
  )
}
