import { createSlice, PayloadAction } from '@reduxjs/toolkit';
import type { RootState } from '.';

export interface PlayerStatusState {
  health: number; // 0..100
  armour: number; // 0..100
  hunger: number; // 0..100
  thirst: number; // 0..100
}

const initialState: PlayerStatusState = {
  health: 100,
  armour: 0,
  hunger: 100,
  thirst: 100,
};

export const playerStatusSlice = createSlice({
  name: 'playerStatus',
  initialState,
  reducers: {
    setPlayerStatus(state, action: PayloadAction<Partial<PlayerStatusState>>) {
      Object.assign(state, action.payload);
    },
  },
});

export const { setPlayerStatus } = playerStatusSlice.actions;
export const selectPlayerStatus = (state: RootState) => state.playerStatus;
export default playerStatusSlice.reducer;
