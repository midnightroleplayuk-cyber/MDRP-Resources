import React from 'react';
import { fetchNui } from '../../utils/fetchNui';

interface Props {
  open: boolean;
  mode: 'follow' | 'prop';
}

interface Hint {
  keys: string[];
  label: string;
}

const PROP_HINTS: Hint[] = [
  { keys: ['W', 'A', 'S', 'D'], label: 'Move' },
  { keys: ['R', 'F'], label: 'Height' },
  { keys: ['Q', 'E'], label: 'Rotate' },
  { keys: ['Shift'], label: 'Faster' },
];

// Floating, themed control bar shown while placing a prop / picking a spot.
const PlacementBar: React.FC<Props> = ({ open, mode }) => {
  if (!open) return null;

  const action = (a: 'confirm' | 'cancel') => fetchNui('stashPlacementAction', { action: a });
  const isProp = mode === 'prop';

  return (
    <div className="pb-wrap">
      <div className="pb-bar">
        <div className="pb-title">
          <span className="pb-dot" />
          {isProp ? 'PLACE PROP' : 'PICK SPOT'}
        </div>

        <div className="pb-hints">
          {isProp ? (
            PROP_HINTS.map((h) => (
              <div className="pb-hint" key={h.label}>
                <div className="pb-keys">
                  {h.keys.map((k) => (
                    <kbd className="pb-key" key={k}>
                      {k}
                    </kbd>
                  ))}
                </div>
                <span className="pb-hint-label">{h.label}</span>
              </div>
            ))
          ) : (
            <span className="pb-hint-label">Walk to the spot, then confirm.</span>
          )}
        </div>

        <div className="pb-actions">
          <button className="pb-btn pb-btn-cancel" onClick={() => action('cancel')}>
            <kbd className="pb-key">Esc</kbd>
            Cancel
          </button>
          <button className="pb-btn pb-btn-confirm" onClick={() => action('confirm')}>
            <kbd className="pb-key pb-key-light">Enter</kbd>
            Confirm
          </button>
        </div>
      </div>
    </div>
  );
};

export default PlacementBar;
