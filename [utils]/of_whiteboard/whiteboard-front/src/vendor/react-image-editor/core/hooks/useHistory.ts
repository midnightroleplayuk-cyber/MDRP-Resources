import { fabric } from "fabric";
import { useCallback, useReducer, useRef } from "react";

import type { HistoryState, UseHistoryReturn } from "../types";

interface HistoryReducerState {
  history: HistoryState[];
  currentIndex: number;
}

type HistoryAction =
  | { type: "PUSH"; payload: HistoryState }
  | { type: "UNDO" }
  | { type: "REDO" }
  | { type: "INITIALIZE"; payload: HistoryState }
  | { type: "CLEAR" };

interface UseHistoryOptions {
  maxHistorySize?: number;
  throttleMs?: number;
  onAfterStateLoad?: () => void;
  customProperties?: string[];
}

const DEFAULT_MAX_HISTORY = 50;
const DEFAULT_THROTTLE_MS = 300;

export const DEFAULT_CUSTOM_PROPERTIES = [
  "id",
  "isBlurPatch",
  "blurRectId",
  "isDrawing",
  "isShape",
  "shapeType",
  "isText",
  "isEraserPath",
  "selectable",
  "evented",
  "hasControls",
  "hasBorders",
  "lockMovementX",
  "lockMovementY",
  "lockRotation",
  "lockScalingX",
  "lockScalingY",
  "lockUniScaling",
];

function createHistoryReducer(maxHistorySize: number) {
  return function historyReducer(
    state: HistoryReducerState,
    action: HistoryAction
  ): HistoryReducerState {
    switch (action.type) {
      case "PUSH": {
        const newHistory = [
          ...state.history.slice(0, state.currentIndex + 1),
          action.payload,
        ];

        const trimmedHistory =
          newHistory.length > maxHistorySize
            ? newHistory.slice(-maxHistorySize)
            : newHistory;

        return {
          history: trimmedHistory,
          currentIndex: trimmedHistory.length - 1,
        };
      }

      case "UNDO": {
        if (state.currentIndex <= 0) {
          return state;
        }
        return {
          ...state,
          currentIndex: state.currentIndex - 1,
        };
      }

      case "REDO": {
        if (state.currentIndex >= state.history.length - 1) {
          return state;
        }
        return {
          ...state,
          currentIndex: state.currentIndex + 1,
        };
      }

      case "INITIALIZE": {
        return {
          history: [action.payload],
          currentIndex: 0,
        };
      }

      case "CLEAR": {
        return {
          history: [],
          currentIndex: -1,
        };
      }

      default:
        return state;
    }
  };
}

export function useHistory(
  canvasRef: React.MutableRefObject<fabric.Canvas | null>,
  options: UseHistoryOptions = {}
): UseHistoryReturn {
  const {
    maxHistorySize = DEFAULT_MAX_HISTORY,
    throttleMs = DEFAULT_THROTTLE_MS,
    onAfterStateLoad,
    customProperties = DEFAULT_CUSTOM_PROPERTIES,
  } = options;

  const [state, dispatch] = useReducer(
    createHistoryReducer(maxHistorySize),
    { history: [], currentIndex: -1 }
  );

  const isUndoRedoOperation = useRef(false);
  const lastSaveTime = useRef(0);

  const serializeCanvas = useCallback(
    (canvas: fabric.Canvas): string => {
      return JSON.stringify(canvas.toJSON(customProperties));
    },
    [customProperties]
  );

  const saveState = useCallback(() => {
    const canvas = canvasRef.current;
    if (!canvas || isUndoRedoOperation.current) {
      return;
    }

    const now = Date.now();
    if (now - lastSaveTime.current < throttleMs) {
      return;
    }
    lastSaveTime.current = now;

    const json = serializeCanvas(canvas);
    const newState: HistoryState = {
      json,
      timestamp: now,
    };

    dispatch({ type: "PUSH", payload: newState });
  }, [canvasRef, throttleMs, serializeCanvas]);

  const undo = useCallback(() => {
    const canvas = canvasRef.current;
    if (!canvas || state.currentIndex <= 0) {
      return;
    }

    isUndoRedoOperation.current = true;

    const targetIndex = state.currentIndex - 1;
    const targetState = state.history[targetIndex];

    if (targetState) {
      canvas.loadFromJSON(targetState.json, () => {
        canvas.renderAll();
        dispatch({ type: "UNDO" });
        isUndoRedoOperation.current = false;
        onAfterStateLoad?.();
      });
    } else {
      isUndoRedoOperation.current = false;
    }
  }, [canvasRef, state.currentIndex, state.history, onAfterStateLoad]);

  const redo = useCallback(() => {
    const canvas = canvasRef.current;
    if (!canvas || state.currentIndex >= state.history.length - 1) {
      return;
    }

    isUndoRedoOperation.current = true;

    const targetIndex = state.currentIndex + 1;
    const targetState = state.history[targetIndex];

    if (targetState) {
      canvas.loadFromJSON(targetState.json, () => {
        canvas.renderAll();
        dispatch({ type: "REDO" });
        isUndoRedoOperation.current = false;
        onAfterStateLoad?.();
      });
    } else {
      isUndoRedoOperation.current = false;
    }
  }, [canvasRef, state.currentIndex, state.history, onAfterStateLoad]);

  const initializeHistory = useCallback(() => {
    const canvas = canvasRef.current;
    if (!canvas) {
      return;
    }

    const json = serializeCanvas(canvas);
    const initialState: HistoryState = {
      json,
      timestamp: Date.now(),
    };

    dispatch({ type: "INITIALIZE", payload: initialState });
  }, [canvasRef, serializeCanvas]);

  const clearHistory = useCallback(() => {
    dispatch({ type: "CLEAR" });
  }, []);

  return {
    saveState,
    undo,
    redo,
    initializeHistory,
    clearHistory,
    canUndo: state.currentIndex > 0,
    canRedo: state.currentIndex < state.history.length - 1,
    historyLength: state.history.length,
    currentIndex: state.currentIndex,
  };
}

export default useHistory;
