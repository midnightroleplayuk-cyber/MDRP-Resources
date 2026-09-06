import { createSlice, PayloadAction } from '@reduxjs/toolkit';
import type { RootState } from '.';

export interface ClothingItem {
  key: string;
  header: string;
  worn: boolean;
  canRestore: boolean;
}

interface ClothingState {
  items: ClothingItem[];
}

const initialState: ClothingState = { items: [] };

export const clothingSlice = createSlice({
  name: 'clothing',
  initialState,
  reducers: {
    setClothing(state, action: PayloadAction<ClothingItem[]>) {
      state.items = action.payload;
    },
  },
});

export const { setClothing } = clothingSlice.actions;
export const selectClothing = (state: RootState) => state.clothing.items;
export default clothingSlice.reducer;
