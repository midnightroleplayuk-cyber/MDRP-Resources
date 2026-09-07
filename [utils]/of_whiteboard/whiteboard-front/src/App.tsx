import React, { useEffect } from 'react'
import { NuiRouter } from './router/nui-router'
import { EventListener, isEnvBrowser } from './utils'
import Nui from './utils/Nui'
import { useLocales } from './store/locales/locales.store'
import type { Locales } from './store/locales/locales.data'

import background from '/images/background.png'
import DuiObject from './editor/components/dui-object'

export const App: React.FC = () => {

  useEffect(() => {
    if (isEnvBrowser()) {
      document.body.style.setProperty('background-image', `url(${background})`, 'important')
      document.body.style.setProperty('background-size', `cover`, 'important')
    }

  }, [])

  useEffect(() => {
    const handler = (payload: { locales?: Partial<Locales> }) => {
      if (!payload?.locales) return
      const current = useLocales.getState().locales
      useLocales.getState().setLocales({ ...current, ...payload.locales } as Locales)
    }

    Nui.onEvent('nui:setLocales', handler)
    return () => Nui.offEvent('nui:setLocales', handler)
  }, [])

  return (
    <>
        <NuiRouter />
        <DuiObject />
        <EventListener />
    </>
  )
}
