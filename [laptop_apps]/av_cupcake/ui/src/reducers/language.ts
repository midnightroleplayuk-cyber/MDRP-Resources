import { createSlice } from "@reduxjs/toolkit";
import type { RootState } from './store'

export const languageSlice = createSlice({
    name: "language",
    initialState: {
        lang: {}
    },
    reducers: {
        setLanguage: (state, action) => {
            state.lang = action.payload
        }
    }
})

export const { setLanguage } = languageSlice.actions
export default languageSlice.reducer
export const selectLang = (state: RootState) => state.lang