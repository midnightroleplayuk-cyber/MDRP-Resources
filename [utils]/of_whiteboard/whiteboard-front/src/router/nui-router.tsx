import { EditorScreen } from '@/editor/editor-screen'
import React from 'react'
import { Route, Routes } from 'react-router'

export const NuiRouter: React.FC = () => {
  return (
    <Routes>
        <Route path="/" element={ <EditorScreen /> } />
    </Routes>
  )
}
