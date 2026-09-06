import React from 'react';
import { PropPreset } from './propPresets';

interface Props {
  presets: PropPreset[];
  value: string;
  onChange: (model: string) => void;
}

const CUSTOM = '__custom__';

// Dropdown of prop presets + a "Custom…" option that reveals a text input.
const PropSelect: React.FC<Props> = ({ presets, value, onChange }) => {
  const isPreset = presets.some((p) => p.model === value);
  const selectValue = isPreset ? value : CUSTOM;

  return (
    <div className="sa-prop-select">
      <div className="sa-select sa-select-block">
        <select
          value={selectValue}
          onChange={(e) => {
            const v = e.target.value;
            onChange(v === CUSTOM ? '' : v);
          }}
        >
          {presets.map((p) => (
            <option key={p.model} value={p.model}>
              {p.label}
            </option>
          ))}
          <option value={CUSTOM}>Custom…</option>
        </select>
        <span className="sa-select-arrow">▾</span>
      </div>

      {selectValue === CUSTOM && (
        <input
          className="sa-input"
          value={value}
          placeholder="prop_model_name"
          onChange={(e) => onChange(e.target.value)}
        />
      )}
    </div>
  );
};

export default PropSelect;
