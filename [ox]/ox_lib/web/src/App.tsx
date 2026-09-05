import { Notifications } from './components/Notifications/Notifications'
import { ContextMenu } from './components/ContextMenu/ContextMenu'
import { InputDialog } from './components/InputDialog/InputDialog'
import { AlertDialog } from './components/AlertDialog/AlertDialog'
import { Progress } from './components/Progress/Progress'
import { TextUI } from './components/TextUI/TextUI'
import { SkillCheck } from './components/SkillCheck/SkillCheck'
import { RadialMenu } from './components/RadialMenu/RadialMenu'
import { MotionConfig } from 'framer-motion'
import { MenuList } from './components/MenuList/MenuList'
import { SystemBridge } from './components/SystemBridge'
import { DevPanel } from './dev/DevPanel'
import { DevPreviewBackground } from './dev/DevPreviewBackground'
import { ShowcaseLogo } from './dev/showcase/ShowcaseLogo'
import { ShowcaseControls } from './dev/showcase/ShowcaseControls'
import { ShowcaseSettingsPanel } from './dev/showcase/ShowcaseSettingsPanel'

export default function App() {
  return (
    <MotionConfig reducedMotion="user">
      <SystemBridge />

      <Notifications />
      <ContextMenu />
      <InputDialog />
      <AlertDialog />
      <Progress />
      <TextUI />
      <SkillCheck />
      <RadialMenu />
      <MenuList />

      {import.meta.env.DEV && <DevPreviewBackground />}
      {import.meta.env.DEV && <ShowcaseLogo />}
      {import.meta.env.DEV && <ShowcaseControls />}
      {import.meta.env.DEV && <ShowcaseSettingsPanel />}
      <DevPanel />
    </MotionConfig>
  )
}
