import { createSlice, PayloadAction } from '@reduxjs/toolkit';
import type { RootState } from '.';

export interface PlayerAccount {
  name: string;
  money: number;
  label?: string;
}

export interface PlayerJob {
  name?: string;
  label?: string;
  grade?: number;
  gradeLabel?: string;
}

export interface PlayerState {
  name: string;
  accounts: PlayerAccount[];
  identifier?: string;
  serverId?: number;
  mugshot?: string;
  job?: PlayerJob;
  licenses?: string[]; // optional — fed by Lua (HABILITAÇÕES); falls back to "—"
  registration?: string; // optional — fed by Lua (REGISTRO); falls back to serverId
}

const initialState: PlayerState = {
  name: '',
  accounts: [],
};

export const playerSlice = createSlice({
  name: 'player',
  initialState,
  reducers: {
    setPlayerData(state, action: PayloadAction<Partial<PlayerState>>) {
      if (action.payload.name !== undefined) state.name = action.payload.name;
      if (action.payload.accounts !== undefined) state.accounts = action.payload.accounts;
      if (action.payload.identifier !== undefined) state.identifier = action.payload.identifier;
      if (action.payload.serverId !== undefined) state.serverId = action.payload.serverId;
      if (action.payload.mugshot !== undefined) state.mugshot = action.payload.mugshot;
      if (action.payload.job !== undefined) state.job = action.payload.job;
      if (action.payload.licenses !== undefined) state.licenses = action.payload.licenses;
      if (action.payload.registration !== undefined) state.registration = action.payload.registration;
    },
    setAccount(state, action: PayloadAction<PlayerAccount>) {
      const index = state.accounts.findIndex((account) => account.name === action.payload.name);

      if (index !== -1) state.accounts[index] = { ...state.accounts[index], ...action.payload };
      else state.accounts.push(action.payload);
    },
    setJob(state, action: PayloadAction<PlayerJob>) {
      state.job = action.payload;
    },
  },
});

export const { setPlayerData, setAccount, setJob } = playerSlice.actions;

export const selectPlayer = (state: RootState) => state.player;
export const selectPlayerAccounts = (state: RootState) => state.player.accounts;

export default playerSlice.reducer;
