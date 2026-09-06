import { Action, configureStore, ThunkAction } from '@reduxjs/toolkit';
import { TypedUseSelectorHook, useDispatch, useSelector } from 'react-redux';
import inventoryReducer from './inventory';
import tooltipReducer from './tooltip';
import contextMenuReducer from './contextMenu';
import playerReducer from './player';
import settingsReducer from './settings';
import stashAdminReducer from './stashAdmin';
import playerStatusReducer from './playerStatus';
import clothingReducer from './clothing';

export const store = configureStore({
  reducer: {
    inventory: inventoryReducer,
    tooltip: tooltipReducer,
    contextMenu: contextMenuReducer,
    player: playerReducer,
    settings: settingsReducer,
    stashAdmin: stashAdminReducer,
    playerStatus: playerStatusReducer,
    clothing: clothingReducer,
  },
});

export type AppDispatch = typeof store.dispatch;
export type RootState = ReturnType<typeof store.getState>;
export type AppThunk<ReturnType = void> = ThunkAction<ReturnType, RootState, unknown, Action<string>>;

export const useAppDispatch = () => useDispatch<AppDispatch>();
export const useAppSelector: TypedUseSelectorHook<RootState> = useSelector;
