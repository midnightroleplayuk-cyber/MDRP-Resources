import { configureStore } from "@reduxjs/toolkit";
import { languageSlice } from "./language";
import { heightSlice } from "./height";

export const store = configureStore({
  reducer: {
    lang: languageSlice.reducer,
    height: heightSlice.reducer,
  },
});

// Infer the `RootState` and `AppDispatch` types from the store itself
export type RootState = ReturnType<typeof store.getState>
// Inferred type: {posts: PostsState, comments: CommentsState, users: UsersState}
export type AppDispatch = typeof store.dispatch