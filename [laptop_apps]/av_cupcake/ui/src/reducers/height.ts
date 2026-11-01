import { createSlice } from "@reduxjs/toolkit";
import type { RootState } from './store'

export const heightSlice = createSlice({
    name: "height",
    initialState: {
        height: 1400
    },
    reducers: {
        setHeight: (state, action) => {
            state.height = action.payload
        }
    }
})

export const { setHeight } = heightSlice.actions
export default heightSlice.reducer
export const selectHeight = (state: RootState) => state.height